({
    fnModalSave: function(component, event, helper) {
        helper.doSave(component);
    },

    fnCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})