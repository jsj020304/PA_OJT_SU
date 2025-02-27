/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-26-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AssetBranchUpdateController {
    @AuraEnabled
    public static Map<String, Object> execute(String recordId) {
        Date NextFeeTargetDate = Date.today().addMonths(1);
        Map<String, Object> mapResult = new Map<String, Object>();
        mapResult.put('status', 'S');

        Branch__c objBranch = [
                                SELECT Id, BranchType__c
                                FROM Branch__c
                                WHERE Id =: recordId
                            ];

        List<Asset> listAssets = new List<Asset>();
        listAssets = [
                        SELECT Id, Branch__c, BranchType__c, NextFeeCreateDate__c, PaymentType__c
                        FROM Asset
                        WHERE Branch__c =: recordId
                    ];

        List<Asset> listUpdateAssets = new List<Asset>();
        if(!listAssets.isEmpty()) {
            for(Asset obj : listAssets) {
                obj.BranchType__c = objBranch.BranchType__c;
                if(obj.PaymentType__c == '후불') {
                    obj.NextFeeCreateDate__c = NextFeeTargetDate;
                }
                listUpdateAssets.add(obj);
            }
            if(!listUpdateAssets.isEmpty()){
                update listUpdateAssets;
            }
        }
        return mapResult;
    }
}