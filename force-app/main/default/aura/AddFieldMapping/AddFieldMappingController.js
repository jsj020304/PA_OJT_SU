({
   fnInit: function(component, event, helper) {
    helper.getInitData(component, event);
   },

   fnSave: function(component, event, helper) {
      helper.doSave(component, event);
   },

   fnCancel: function(component, event, helper) {
      $A.get("e.force:closeQuickAction").fire();
   },

   fnDetailCreated: function(component, event, helper) {
      var pObject = component.get("v.objectValue");
      
      $A.createComponent(
         "c:MessageDetailPop",
         {
            "openModal" : true,
            "pObject" : component.get("v.objectValue")
         },
         function(detailCreate, status) {
            if(status === "SUCCESS") {
               component.set("v.MessageDetailPop", detailCreate);
            } else {
               helper.showToast("error", "관리자에게 문의해주세요!");
            }
         }
      )
   },

   fnDetailDelete: function(component, event, helper) {
      var idx = event.getSource().get("v.value");
      var detailList = component.get("v.detailList");
      detailList.splice(idx, 1);
      component.set("v.detailList", detailList);
   },

   fnGetEvent: function(component, event, helper) {
      var actionComponent = event.getParam("actionComponent");
      var actionType = event.getParam("actionType");

      if (actionType == "Cancel") {
         if (actionComponent == "Detail") {
            component.set("v.MessageDetailPop", null);
         }
      } else if (actionType == "Save") {
         var mapParam = event.getParam("mapParam");
         if (actionComponent == "Detail") {
            var detailList = component.get("v.detailList");
            if (!detailList) {
               detailList = [];
            }
            detailList.push(mapParam);
            component.set("v.detailList", detailList);
            component.set("v.MessageDetailPop", null);
         }
      }
   }
});