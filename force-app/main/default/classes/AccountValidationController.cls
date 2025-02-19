/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountValidationController {
    @AuraEnabled
    public static PaymentMethod__c doInit(String recordId){
        DN_CommonUtil.CCAuthNum();
        PaymentMethod__c objPaymentMethodType = new PaymentMethod__c();
        objPaymentMethodType = [
            SELECT Id, Name, Account__c, Account__r.Name, PaymentMethod__c, AccountNo__c, BankCardName__r.Name, BankCardName__r.Code__c, ConfirmInfo__c, Asset__c
            FROM PaymentMethod__c
            WHERE Id = :recordId 
        ];

        if(objPaymentMethodType == null) {
            System.debug('결제수단 데이터가 없습니다.');
        }
        else {
            System.debug('결제수단 결과 >>>>>' + objPaymentMethodType);
        }
        return objPaymentMethodType;
        
    }

    @AuraEnabled
    public static string doValidation(PaymentMethod__c objPaymentMethodType, String recordId){
        List<PaymentMethod__c> listPaymentMethod = new List<PaymentMethod__c>();
        listPaymentMethod = [
            SELECT Id, IsCCAuth__c, CCDescription__c
            FROM PaymentMethod__c
            WHERE Id = :recordId
        ];

        String resultMsg = 'success|검증완료 되었습니다.';
        boolean isSuccess = true;

        Map<String, Object> mapResult = new Map<String, Object>();

        if(objPaymentMethodType.BankCardName__r.Code__c == null || objPaymentMethodType.BankCardName__r.Code__c == '') {
            resultMsg = 'error|검증실패 - 해당 은행은 계좌검증이 지원되지 않습니다.';
            isSuccess = false;
        } else if(objPaymentMethodType.AccountNo__c == null || objPaymentMethodType.AccountNo__c == '') { 
            resultMsg = 'error|검증실패 - 계좌번호/카드번호 값이 존재하지 않습니다.';
            isSuccess = false;
        } else if(objPaymentMethodType.ConfirmInfo__c == null || objPaymentMethodType.ConfirmInfo__c == '') {
            resultMsg = 'error|검증실패 - 생년월일/사업자등록번호 값이 존재하지 않습니다.';
            isSuccess = false;
        } else if(objPaymentMethodType.Account__r.Name == null || objPaymentMethodType.Account__r.Name == '') {
            resultMsg = 'error|검증실패 - 독자 정보가 존재하지 않습니다.';
            isSuccess = false;
        } else {
            resultMsg = 'success|검증 완료 되었습니다.';
            isSuccess = true;
            // mapResBody = DN_CommonUtil.validationAccount(
            //             objPaymentMethodType.BankCardName__r.Code__c, objPaymentMethodType.AccountNo__c, objPaymentMethodType.ConfirmInfo__c, objPaymentMethodType.Account__r.Name
            // );
        }

        if(isSuccess){
            for(PaymentMethod__c obj : listPaymentMethod){
                obj.IsCCAuth__c = true;
                obj.CCDescription__c = '';
            }
        } else {
            String errorMessage = resultMsg.substring(resultMsg.indexOf('|') + 4);
            for(PaymentMethod__c obj : listPaymentMethod){
                obj.IsCCAuth__c = false;
                obj.CCDescription__c = errorMessage;
            }
        }

        update listPaymentMethod;
        return resultMsg;
    }
}