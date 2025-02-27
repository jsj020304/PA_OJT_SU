({
    doSave: function(component, event) {
        component.set("v.showSpinner", true);
        var action = component.get("c.execute");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state= response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.status == 'S') {
                    this.showToast("success", "일괄 구독 업데이트 하였습니다.");
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get("e.force:refreshView").fire();
                } else {
                    this.showToast("error", result.message);
                }
            } else {
                this.showToast("error", "관리자에게 문의하세요");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    showToast: function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key : "info_alt",
            type : type,
            message : message
        });
        evt.fire();
    }
})