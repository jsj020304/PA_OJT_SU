({
    fnClick: function(component, event, helper) {
        component.set("v.accountMatching", false);
        console.log("test");
        window.setTimeout($A.getCallback(function() {
            component.set("v.accountMatching", true);
        }), 100);
        // component.set("v.accountMatching", true);만 쓰면 독자 매칭 버튼이 한번만 작동함.
        // 위 코드처럼 시간차를 두고 버튼을 누르면 false인 상태에서 몇초뒤 true로 바뀌도록 해야
        // 독자매칭 버튼을 누를 때마다 모달창이 나오는 동작을 함.
    },

    fnGetEvent: function(component, event, helper){
        var actionType = event.getParam("actionType");
        component.set("v.accountMatching", false);
        $A.get('e.force:refreshView').fire();
    }
})