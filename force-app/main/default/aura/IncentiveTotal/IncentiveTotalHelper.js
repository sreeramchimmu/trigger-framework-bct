({
    getIncentiveEarningsTotal : function(component,oppId) {
        var action = component.get("c.getIncentiveEarningsTotal");
        action.setParams({
      		oppId : oppId
    	});
        //new Intl.NumberFormat().format(sum);
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.incentive', actionResult.getReturnValue());
         });
          $A.enqueueAction(action);
    }
})