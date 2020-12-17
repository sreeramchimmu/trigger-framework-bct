/*
Trigger name : EnsureOppLineItem
Description  : This trigger is used as validation rule on Opportunity to ensure it have Line Items and
			   its associated Revenue Splits while initiating approval process or changing Stage to Closed Won.
Author       : Sreeram. V
Date Created : 05-Mar-2020         

Modified for bug by	: Sreeram. V
Last Modified Date 	: 19-Mar-2020
Modification Note   : added "flagGlobal.flagForLineItemUpdation" condition in if statement to restrict this trigger from firing while line item updation
*/

trigger EnsureOppLineItem on Opportunity ( before update, before insert) {
 	public static Boolean isTriggerExecuted = True; // this boolean variable is used to restrict cross trigger firing while Opportunity record Insertion.
    boolean isActive = false; 
    
   /* List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='EnsureOppLineItem' and IS_ACTIVE__c=true];
    
    for(TriggerSwitch__c trig : trgsettings){
       isActive = true;
    }*/
    
    Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('EnsureOppLineItem');
   if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c)))   {
          isActive = true;
       system.debug('inside switchVar EnsureOppLineItem :: '+limits.getQueries());
    }
    
    if(isActive && flagGlobal.flagForLineItemUpdation ){
        system.debug('inside ensurelineitem trigger ::');
        if(Trigger.isBefore && Trigger.isInsert){
            isTriggerExecuted = false;
            return; 
    	}     
    
       	if(Trigger.isBefore && Trigger.isUpdate){
            if(isTriggerExecuted){
       		
              Opportunity opp = Trigger.new[0];
                
                if(!OpportunityValidator.ValidateOpportunity(opp)){       
                    opp.addError('Opportunity must have Opportunity Line Items and its associated Revenue Splits before changing Stage to CLOSED WON or initiating Approval Process !!!');
                }
                
            }

    	}    
      }
}