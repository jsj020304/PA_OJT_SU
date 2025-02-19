({
    fnInit: function(component, event, helper){
        helper.getInit(component);
    },
    
    fnModalSave: function(component, event, helper){
        helper.saveModal(component);
    },

    fnModalCancel: function(component, event, helper){
        helper.doGoList(component);
    }
})