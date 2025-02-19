/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-05-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public with sharing class AccountMatchingController {
    @AuraEnabled
    // ** 반환값 자료형 때문에 데이터 테이블의 값이 나오지 않은 거였음.
    // ** List<AccountInfoWrapper>로 자료형 바꿔도 됨. 그렇게 되면 리턴값은 return listAccountInfo;가 됨.
    public static Map<String, Object> getInitData(String recordId) {
        System.debug('start!!!!!');
        Case Cases = [
            SELECT MobilePhone__c
            FROM Case
            WHERE Id = :recordId
        ];
        System.debug('Cases:::::::::::' + Cases);
        
        List<Account> Accounts = new List<Account>();
        Accounts = [
            SELECT Id, Name, CustomerNum__c, HankyungID__c, ru_ActiveAssetNum__c, 
                    Latest_SubscriptionDate__c, Latest_SubscriptionEndDate__c, CompanyCode__c, RecordType.DeveloperName
            FROM Account
            WHERE (MobilePhone__c = :Cases.MobilePhone__c AND MobilePhone__c != null)
                OR (HomePhone__c = :Cases.MobilePhone__c AND HomePhone__c != null)
        ];
        System.debug('Accounts:::::::::' + Accounts);

        if(Accounts.isEmpty()) {
            return null;
        }
        
        List<AccountInfoWrapper> listAccountInfo = new List<AccountInfoWrapper>();
        // 선언 AccountInfoWrapper accountInfo = new AccountInfoWrapper();로 찢어놓음.
        AccountInfoWrapper accountInfo;
        Set<Id> setAccountIds = new Set<Id>();

        for(Account obj : Accounts) {
            setAccountIds.add(obj.Id);
            // 초기화
            accountInfo = new AccountInfoWrapper();
            accountInfo.Id = obj.Id;
            accountInfo.Name = obj.Name;
            // DeveloperName이 HankyungID라면 CustomerNum에 CustomerNum 대입
            if(obj.RecordType.DeveloperName == 'HankyungID') {
                accountInfo.CustomerNum = obj.CustomerNum__c;
                // 아니면 CustomerNum에 회사 코드 대입
            } else {
                accountInfo.CustomerNum = obj.CompanyCode__c;
            }
            // ID 통합회원
            accountInfo.HankyungID = obj.HankyungID__c;
            accountInfo.ru_ActiveAssetNum = obj.ru_ActiveAssetNum__c;
            accountInfo.Latest_SubscriptionDate = obj.Latest_SubscriptionDate__c;
            accountInfo.Latest_SubscriptionEndDate = obj.Latest_SubscriptionEndDate__c;
            accountInfo.RecordTypeDeveloperName = obj.RecordType.DeveloperName;
            // 데이터테이블 컬럼 값 중에 활성구독에 대한 것만 빠짐.
            listAccountInfo.add(accountInfo);
        }

        List<Asset> listAssets = new List<Asset>();
        listAssets = [
            SELECT Id, Product2.Name, AccountId
            FROM Asset
            WHERE AccountId IN: setAccountIds
            AND IsActive__c = TRUE
        ];

        Map<Id, List<Asset>> mapAccountAssets = new Map<Id, List<Asset>>();

        for(Asset obj : listAssets) {
            if(!mapAccountAssets.containsKey(obj.AccountId)) {
                mapAccountAssets.put(obj.AccountId, new List<Asset>());
            }
            mapAccountAssets.get(obj.AccountId).add(obj);

            System.debug('AccountId::: ' + obj.AccountId + ', Asset Id::: ' + obj.Id + ', Product2.Name::: ' + obj.Product2.Name);
        }

        System.debug('mapAccountAssets => ' + mapAccountAssets);

        for(AccountInfoWrapper obj : listAccountInfo) {
            if(mapAccountAssets.containsKey(obj.Id)) {
                List<Asset> assets = mapAccountAssets.get(obj.Id);
                obj.ru_ActiveAssetNum = assets.size();
                for(Asset objAssets : assets) {
                    if(obj.ActiveAssets == null) {
                        obj.ActiveAssets = objAssets.Product2.Name;
                        obj.AssetIds = objAssets.Id;
                    } else {
                        obj.ActiveAssets = obj.ActiveAssets + ', ' + objAssets.Product2.Name;
                        obj.AssetIds = obj.AssetIds + ', ' + objAssets.Id;
                    }
                }
            } else {
                obj.ru_ActiveAssetNum = 0;
            }
        }

        Map<String, Object> result = new Map<String, Object>();
        result.put('records', listAccountInfo);

        return result;
    }

    @AuraEnabled
    public static void updateCaseRecord(String caseId, Map<String, Object> accountRow) {
        System.debug('accountRow >> ' + accountRow);
        System.debug('AccountRow Json > ' + JSON.serialize(accountRow));
        Case cases = [
                SELECT Id, AccountId
                FROM Case
                WHERE Id = :caseId
        ];

        if (cases != null) {
            cases.AccountId = (Id) accountRow.get('Id');

            if((Decimal) accountRow.get('ru_ActiveAssetNum') == 1) {
                cases.AssetId = (Id) accountRow.get('AssetIds');
            }
            update cases;
        }
    }

    public class AccountInfoWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String CustomerNum;
        @AuraEnabled public String HankyungID;
        @AuraEnabled public Decimal ru_ActiveAssetNum;
        @AuraEnabled public Date Latest_SubscriptionDate;
        @AuraEnabled public Date Latest_SubscriptionEndDate;
        @AuraEnabled public String RecordTypeDeveloperName;
        @AuraEnabled public String ActiveAssets;
        @AuraEnabled public String AssetIds;
    }
}