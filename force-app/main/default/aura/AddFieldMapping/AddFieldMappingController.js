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
         function(detailCreate, status, errorMessage) {
            if(status === "SUCCESS") {
               component.set("v.MessageDetailPop", detailCreate);
            } else {
               helper.showToast("error", "관리자에게 문의해주세요!");
            }
         }
      )
   },

   fnDetailDelete: function(component, event, helper) {

   },

   fnGetEvent: function(component, event, helper) {
   }
});