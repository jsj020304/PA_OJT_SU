({
    setColumns: function(component) {
        this.getInitData(component);
        component.set('v.columns', [
            {label: '독자/담당자명', fieldName: 'Name', type: 'button', typeAttributes: {label: {fieldName:'Name'}, name: 'view_details', variant: 'base'}},
            {label: '독자번호', fieldName: 'CustomerNum', type: 'text'},
            {label: 'ID(통합회원)', fieldName: 'HankyungID', type: 'text'},
            {label: '활성구독 수', fieldName: 'ru_ActiveAssetNum', type: 'number', cellAttributes: { alignment:'left' }},
            {label: '활성구독', fieldName: 'ActiveAssets', type: 'text'},
            {label: '(최근)구독신청일', fieldName: 'Latest_SubscriptionDate', type: 'date'},
            {label: '(최근)구독종료일', fieldName: 'Latest_SubscriptionEndDate', type: 'date'},
            {type: 'button', initialWidth: 120, typeAttributes: { label: '독자선택', name: 'select_account', title: '독자선택', variant: 'brand' }}
        ]);
    },

    getInitData: function(component, recordId) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getInitData");
        action.setParams({
                    recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === "SUCCESS" ){
                // ** List<AccountInfoWrapper>로 자료형 바꾸고, 리턴값이 return listAccountInfo;일 때,
                // ** 밑에 코드 두 줄 삭제, var data = response.getReturnValue();로 바꾸면 됨.
                var result = response.getReturnValue();
                var data = result.records;
                
                if(data == null) {
                    component.set("v.showSpinner", false);
                    this.showToast('error', '해당 전화번호로 조회된 독자가 없습니다. 신규 독자 문의 후 기존 독자일 경우 상단 검색창을 이용해주시길 바랍니다.');
                } else {
                    component.set("v.showSpinner", false);
                    // 데이터 테이블에 보이게 할 값을 대입
                    component.set("v.data", data);
                    console.log('조회데이터:::::', data);                                               
                }   
            } else if( state === "ERROR" ){
                this.showToast('error', '관리자에게 문의하세요.');
            }
        });
        $A.enqueueAction(action);
    },

    openViewDetail: function(component, recordId) {
        var workspaceAPI = component.find("AccountMatching");
        workspaceAPI.getFocusedTabInfo().then(function(response){
            var focusedTabId = response.tabId;
            workspaceAPI.openSubtab({
                pageReference : {
                    "type": "standard_recordPage",
                    "attributes": {
                        "recordId": recordId,
                        "actionName": "view"
                    },
                    "state": {}
                },
                parentTabId: focusedTabId,
                focus: true
            })
        })
        .catch(function(error){
            console.log(error);
        });
    },

    updateCaseRecord: function(component, row) {
        var action = component.get("c.updateCaseRecord");
        action.setParams({
            caseId: component.get("v.recordId"),
            accountRow: row
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast('success', '독자 정보가 수정 되었습니다.');
                console.log('state >>> ' + state);
                var evt = component.getEvent("AccountMatchingEvt");
                evt.setParams({
                    actionType: "CLOSE"
                });
                evt.fire();
            } else if (state === "ERROR") {
                  this.showToast('error', '관리자에게 문의하세요.');
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            type : type,
            message : message
        });
        evt.fire();
    }
})