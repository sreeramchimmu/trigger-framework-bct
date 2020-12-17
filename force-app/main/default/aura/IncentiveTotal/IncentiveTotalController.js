({
    doinit : function(component,oppId) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getIncentiveEarningsTotal");
        action.setParams({
      		oppId : oppId
    	});
        //new Intl.NumberFormat().format(sum);
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.incentive', actionResult.getReturnValue());
            //component.set('v.listSize', actionResult.getReturnValue().length);
            //console.log('actionResult.getReturnValue()-->'+actionResult.getReturnValue());
         });
          $A.enqueueAction(action);
    }
})