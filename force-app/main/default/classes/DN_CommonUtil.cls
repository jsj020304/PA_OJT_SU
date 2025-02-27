/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-24-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class DN_CommonUtil {

    public static List<Map<String, String>> getPickListValues(String objectType, String selectedField) {
        List<Map<String, String>> pickListValuesList = new List<Map<String, String>>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPickListValues();
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(new Map<String, String> {
                'label' => pickListVal.getLabel(),
                'value' => pickListVal.getValue()
            });
        }
        return pickListValuesList;         
    }

    // 세일즈포스 필드 데이터타입 중 Auto Number을 유동적으로 사용하기 위해 구현
    // Auto Number는 자동 생성되어 사용자가 직접 수정이 불가하지만, 밑에 함수로 값을 할당하면 수정 가능함.
    public static void CCAuthNum() {
        Coocon__c  CCAuthNum = new Coocon__c();

        CCAuthNum = [
            SELECT Seq__c
            FROM Coocon__c
            FOR UPDATE
        ];

        System.debug('쿠콘 데이터 >>>>> ' + CCAuthNum);

        Double myAutoNum = 0;

        if (CCAuthNum != null) {
            if(CCAuthNum.Seq__c == '0999999') {
                myAutoNum = 0;
            } else {
                myAutoNum = Double.valueOf(CCAuthNum.Seq__c);
            }

            myAutoNum += 1;
            CCAuthNum.Seq__c = String.valueOf(Integer.valueOf(myAutoNum)).leftPad(7, '0');
        }

        update CCAuthNum;
    }

    // /**
    //  * 쿠콘 계좌검증 => 인터페이스 부분이라 뺐음.
    //  * @param String	은행코드
    //  * @param String	계좌번호
    //  * @param String	생년월일(yyMMdd)/사업자등록번호
    //  * @param String	거래일련번호
    //  **/

    //  public static Map<String, String> validationAccount(String bankCode, String accountNo, String confirmInfo, String accountName) {

    //     Map<String, String> mapResult = new Map<String, String>();

    //     Http http = new Http();

    //     HttpRequest request = new HttpRequest();
    //     HttpResponse response = new HttpResponse();

    //     Coocon__c coocon = Coocon__c.getInstance();

    //     String secretKey = coocon.CC_secretKey__c;      //인증키
    //     String key = coocon.CC_APIkey__c;     //API명
    //     String charSet = 'UTF-8';          //캐릭터셋
    //     String endpoint = coocon.CC_Endpoint__c + '/rs/batch/coocon/acctnm_rcms_wapi';
    //     String authNum = coocon.seq__c;

    //     request.setMethod('POST');
    //     request.setEndpoint(endpoint);
    //     request.setTimeout(110000);
    //     request.setHeader('Content-Type', 'application/json');

    //     Map<String, Object> mapReqBody = new Map<String, Object>();
    //     mapReqBody.put('SECR_KEY', secretKey);
    //     mapReqBody.put('KEY', key);
    //     mapReqBody.put('CHAR_SET', charSet);

    //     List<Map<String, Object>> reqData = new List<Map<String, Object>>();
    //     Map<String, Object> data = new Map<String, Object>();
    //     data.put('BANK_CD', bankCode);
    //     data.put('SEARCH_ACCT_NO', accountNo);
    //     data.put('ACNM_NO', confirmInfo);
    //     data.put('ICHE_AMT', '0');
    //     data.put('TRSC_SEQ_NO', authNum);
    //     reqData.add(data);

    //     mapReqBody.put('REQ_DATA', reqData);

    //     System.debug('test0');
    //     String jsonData = JSON.serialize(mapReqBody);

    //     System.debug('===========================> validationAccountNo requestBody : ' + jsonData);
    //     System.debug('test1');
    //     request.setBody(jsonData);
    //     System.debug('test2');
    //     System.debug('=================request=============='+request);
    //     System.debug('test3');
    //     response = http.send(request);

    //     String responseBody = response.getBody();

    //     System.debug('===========================> validationAccountNo responseBody : ' + responseBody);

    //     Map<String, Object> mapResBody = new Map<String, Object>();

    //     if (response.getStatusCode() == 200) {
    //         mapResBody = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

    //         System.debug('=====================> mapResBody : ' + JSON.serialize(mapResBody));

    //         if (mapResBody <> null && mapResBody.get('RSLT_CD') <> null) {
    //             String resultCode = String.valueOf(mapResBody.get('RSLT_CD'));
    //             mapResult.put('code', resultCode);

    //             if (mapResBody <> null && mapResBody.get('RSLT_MSG') <> null) {
    //                 String resultMessage = String.valueOf(mapResBody.get('RSLT_MSG'));
    //                 mapResult.put('message', resultMessage);

    //                 Map<String, String> mapCode = new Map<String, String>();
    //                 for (CommonCode__c obj : [
    //                         SELECT Id, Code__c, Description__c
    //                         FROM CommonCode__c
    //                         WHERE Type__c = '은행코드'
    //                         ORDER BY Code__c ASC
    //                 ]) {
    //                     mapCode.put(obj.Code__c, obj.Description__c);
    //                 }

    //                 if (mapCode <> null && mapCode.get(resultCode) <> null) {
    //                     mapResult.put('RSLT_CD', mapCode.get(resultCode));
    //                 } else {
    //                     mapResult.put('RSLT_CD', '알수없는 오류 발생. 관리자에게 문의바랍니다.');
    //                 }
    //             }
    //         }

    //     }

    //     return mapResult;
    // }
}

