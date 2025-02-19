({
    fnInit: function(component, event, helper) {
        console.log("AccountValidation_Start!!!!!!");
        helper.doInit(component, event, helper);
    },

    fnDoValidation: function(component, event, helper) {
        helper.doValidation(component, event, helper);
    },

    fnClose: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})