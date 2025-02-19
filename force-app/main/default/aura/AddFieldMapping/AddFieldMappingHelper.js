({
    getInitData: function(component, event) {
        var action = component.get("c.getInitData");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.objectList", result['objectList']);
            } else {
                this.showToast("error", "관리자에게 문의해주세요!");
            }
        });
        $A.enqueueAction(action);
    },

    doSave: function(component, event) {
        var action = component.get("c.doSave");
        action.setParams({
            recordId : component.get("v.recordId"),
            objectValue : component.get("v.objectValue"),
            detailList : component.get("v.detailList")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                this.showToast("success", "등록이 완료되었습니다.");

                $A.get("e.force:closeQuickAction").fire();
                $A.get("e.force:refreshView").fire();
            } else {
                this.showToast("error", "관리자에게 문의해주세요!");
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key : "info_alt",
            type: type,
            message: message
        });
        evt.fire();
    }
})