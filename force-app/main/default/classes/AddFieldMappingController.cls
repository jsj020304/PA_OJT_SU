/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AddFieldMappingController {
    @AuraEnabled
    public static Map<String, Object> getInitData(String recordId) {
        List<MessageObj__mdt> listMessageObject = new List<MessageObj__mdt>();
        listMessageObject = [
            SELECT Id, Label, DeveloperName
            FROM MessageObj__mdt
            ORDER BY Label ASC
        ];

        List<Map<String, String>> objectList = new List<Map<String, String>>();
        for (MessageObj__mdt obj : listMessageObject) {
                objectList.add(new Map<String, String> {
                    'label' => obj.Label,
                    'value' => obj.DeveloperName
                });
        }

        Map<String, Object> mapResult = new Map<String, Object>{'objectList' => objectList};
        return mapResult;
    }

    @AuraEnabled
    public static string doSave(String recordId, String objectValue, List<MsgTemplateDetail__c> detailList){
        MsgTemplate__c objMsgTemplate = new MsgTemplate__c();
        objMsgTemplate.Id = recordId;
        if(objectValue != null && objectValue != ''){
            objMsgTemplate.TargetObject__c = objectValue;
        }

        update objMsgTemplate;

        if(!detailList.isEmpty()){
            for(MsgTemplateDetail__c objDetail : detailList){
                objDetail.TemplateName__c = recordId;
            }
            insert detailList;
        }
        return recordId;
    }
}