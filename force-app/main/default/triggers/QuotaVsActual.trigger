trigger QuotaVsActual on Revenue_Term__c (after insert, after update, before delete) {
   boolean isActive = false;
 List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='QuotaVsActual' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings){
        isActive = true;
    }
    if(isActive){
        system.debug('QuotaVsActual Trigger is ACTIVE');
 		if ((Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) || 
        (Trigger.isBefore &&  Trigger.isDelete)) {
        new QuotaVsActualManagerTrig(Trigger.newMap, Trigger.oldMap).processRevenueDetails();
    	}
    }else{
        system.debug('QuotaVsActual Trigger is set to IN ACTIVE');
    }
  

}