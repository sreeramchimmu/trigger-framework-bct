({
    doinit : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getIncentiveEarnings");
        action.setParams({
      		oppId : oppId
    	});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                var conts = response.getReturnValue();
                component.set("v.incentives",conts);
            } 
  	});           
        $A.enqueueAction(action);
    }
})