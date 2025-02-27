/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

System.debug('List<Map<String,String>> 값>>> ' + DN_CommonUtil.getPickListValues('MsgTemplateDetail__c', 'DisplayType__c'));