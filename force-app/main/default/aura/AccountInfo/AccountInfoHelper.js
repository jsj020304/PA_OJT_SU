({
    getInit: function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response){
            component.set('v.tabId', response.tabId);
            workspaceAPI.setTabLabel({
                    tabId: response.tabId,
                    label: "거래처 조회" 
                })
                .then(function(response) {
                    workspaceAPI.setTabIcon({
                        icon: "standard:apps"
                    });
                });
        });
    },

    saveModal: function(component){
        var today = new Date();
        var formattedDate = $A.localizationService.formatDate(today, "YYYY-MM-DD");
        component.set("v.showSpinner", false);
        this.showToast("success", formattedDate + " 거래처 조회 완료");
        this.doGoList(component);
    },

    doGoList: function(component) {
        let tabId = component.get('v.tabId');
        // 특정 오브젝트의 홈페이지로 리디렉션
        var navEvent = $A.get("e.force:navigateToObjectHome");
        navEvent.setParams({
            "scope": "Account"
        });
        navEvent.fire();
        let workspaceAPI = component.find("workspace");
        workspaceAPI.closeTab({
            tabId: tabId
        });
    },

    showToast: function(type, message){
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key: "info_alt",
            type: type,
            message: message
        });
        evt.fire();
    }
});