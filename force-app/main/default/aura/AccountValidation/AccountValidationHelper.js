({
    doInit: function(component, event, helper) {
        var action = component.get("c.doInit");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.objPaymentMethodType", result);
                console.log("독자 결과>>>>", result);
            } else {
                this.showToast("error", "관리자에게 문의해주세요.");
            }
        });
        $A.enqueueAction(action);
    },

    doValidation: function(component, event, helper) {
        var action = component.get("c.doValidation");
        action.setParams({
            recordId : component.get("v.recordId"),
            objPaymentMethodType : component.get("v.objPaymentMethodType")
        });
        action.setCallback(this, function(response) {
            component.set('v.showSpinner', false);
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                var statusMsg = result.split('|');
                this.showToast(statusMsg[0], statusMsg[1]);
                if(statusMsg[0] === 'success') {
                    $A.get('e.force:refreshView').fire();
                    $A.get('e.force:closeQuickAction').fire();
                } else {
                    this.showToast(statusMsg[0], statusMsg[1]);
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key     : "info_alt",
            type    : type,
            message : message
        });
        evt.fire();
    }
})