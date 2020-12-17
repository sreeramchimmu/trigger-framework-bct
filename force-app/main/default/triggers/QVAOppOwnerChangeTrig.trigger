trigger QVAOppOwnerChangeTrig on Opportunity (after update, before delete) {
     boolean isActive = false;
    boolean isOwnerChange = false;
    
    
      system.debug('QuotaVsActual Owner has been changed -2');
    List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='QVAOwnerChange' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings){
        isActive = true;
    }
  if(isActive){
         
    if(null != Trigger.new){
    for(Opportunity opNew : Trigger.new){
        system.debug('QuotaVsActual Owner change Trigger New Owner : '  + opNew.OwnerId);
        for(Opportunity opOld : Trigger.old){
            system.debug('QuotaVsActual Owner change Trigger Old Owner : '  + opOld.OwnerId);
            if(opNew.OwnerId != opOld.OwnerId){
                 system.debug('QuotaVsActual Owner has been changed -1 ');
                isOwnerChange = true;
               break;
            }else{
                system.debug('QuotaVsActual - No owner change');
            }
        }
    }
    }else{
         isOwnerChange = true;
    }
    
    if(isOwnerChange){
       
   
        system.debug('QuotaVsActual Owner change Trigger is ACTIVE');
        if ((Trigger.isAfter && Trigger.isUpdate) || (Trigger.isBefore &&  Trigger.isDelete)) {
            new OppOwnerChangeTrigCls(Trigger.newMap, Trigger.oldMap).processOwnerDetails();
            }
        }
         
    }else{
            system.debug('QuotaVsActual Owner change Trigger is set to IN ACTIVE');
            }
   

}