({
    fnInit : function(component, event, helper) {
        helper.getInitData(component);
    },

    fnCancel : function(component, event, helper) {
        // cmp 파일에서 <aura:registerEvent name="MessageDetailPopEvt" type="c:MessageDetailPop_evt"/>로 설정함.
        var evt = component.getEvent("MessageDetailPopEvt");
        evt.setParams({
            // aura event 파일(MessageDetailPop_evt)에 있는 속성
            "actionComponent" : "Detail",
            "actionType" : "Cancel"
        });
        evt.fire();
    },

    fnFieldChange : function(component, event, helper) {
        var fieldAPI = event.getSource().get("v.value");
        var fieldList = component.get("v.fieldList");
        var fieldType;
        var fieldLookupApi;
        for (var i in fieldList) {
            var api = fieldList[i].value;
            if (api == fieldAPI) {
                fieldType = fieldList[i].type;
                fieldLookupApi = fieldList[i].lookupApi;
                break;
            }
        }
        if (fieldType != '' && fieldType == 'REFERENCE') {
            helper.doRelatedField(component, event, fieldLookupApi);
        } else {
            component.set("v.relatedFieldList", []);
        }
    },

    fnSave : function(component, event, helper) {
        var mapTarget = {
            "VariableName__c" : component.get("v.variableName"),
            "ObjectAPI__c" : component.get("v.pObject"),
            "FieldAPI__c" : component.get("v.fieldAPI"),
            "RelatedField__c" : component.get("v.relatedField"),
            "DisplayType__c" : component.get("v.displayType")
        };
        component.set("v.mapParam", mapTarget);

        helper.doSave(component, event);
    }
});