({
    fnInit: function(component, event, helper) {
        helper.setColumns(component);
    },

    fnClickButton: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        if(action.name === 'view_details') {
            if(row && row.Id) {
                helper.openViewDetail(component, row.Id);
            }
        } else if(action.name === 'select_account') {
            helper.updateCaseRecord(component, row);           
        }
    },
    
    fnCancel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    }
})