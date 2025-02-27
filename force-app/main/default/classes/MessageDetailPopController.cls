/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class MessageDetailPopController {
    @AuraEnabled
    public static Map<String, Object> getInitData(String setObject){
        Map<String, Object> fieldList = doObjectChange(setObject);

        Map<String, Object> mapResult = new Map<String, Object> {
            'DisplayType' => DN_CommonUtil.getPickListValues('MsgTemplateDetail__c', 'DisplayType__c'),
            'fieldList' => fieldList.get('fieldList')
        };
        return mapResult;
    }

    @AuraEnabled
    public static Map<String, Object> doObjectChange(String setObject) {
        Map<String, Object> mapResult = new Map<String, Object>();
        List<Map<String, String>> fieldList = new List<Map<String, String>>();
        Map<String, Schema.SObjectType> globalDescript = Schema.getGlobalDescribe();
        Schema.SObjectType objectTypes = globalDescript.get(setObject);

        if(ObjectTypes != null) {
            Schema.DescribeSObjectResult ros1 = objectTypes.getDescribe();
            Map<String, Schema.SObjectField> mapFieldLists = ros1.fields.getMap();
            for(Schema.SObjectField field : mapFieldLists.values()) {
                Schema.DescribeFieldResult fieldResults = field.getDescribe();
                fieldList.add(new Map<String, String> {
                    'label' => fieldResults.getLabel(),
                    'value' => fieldResults.getName(),
                    'type' => String.valueOf(fieldResults.getType()),
                    'lookupApi' => String.valueOf(fieldResults.getReferenceTo()).replace('(', '').replace(')', '')
                });
            }
        }
        mapResult.put('fieldList', fieldList);
        return mapResult;
    }
}