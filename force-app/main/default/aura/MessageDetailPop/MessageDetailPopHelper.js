({
    getInitData : function(component, event) {
        var action = component.get("c.getInitData");
        action.setParams({
            setObject : component.get("v.pObject")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                var displayType = result['DisplayType'];

                component.set("v.displayType", displayType[0].label);
                component.set("v.displayList", result['DisplayType']);
                component.set("v.fieldList", result['fieldList']);
    
            } else {
                this.showToast("error", "관리자에게 문의하세요");
            }
        });
        $A.enqueueAction(action);
    },

    doRelatedField : function(component, event, fieldAPI) {
        var action = component.get("c.doObjectChange");
        action.setParams ({
            setObject : fieldAPI
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.relatedFieldList", response["fieldList"]);
            } else {
                this.showToase("error", "관리자에게 문의하세요");
            }
        });
        $A.enqueueAction(action);
    },

    doSave : function(component, event) {
        var evt = component.getEvent("MessageDetailPopEvt");
        evt.setParams({
            "actionComponent" : "Detail",
            "actionType" : "Save",
            "mapParam" : component.get("v.mapParam")
        });
        evt.fire();
    },

    showToast : function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key : "info_alt",
            type : type,
            message : message
        });
        evt.fire();
    }
})