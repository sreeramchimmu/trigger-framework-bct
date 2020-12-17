/**
 * Class: OpportunityTriggerHandler 
 *
 * Author: Revathi Saminathan
 *
 * Date Created: 11.11.2020
 *
 * Purpose: OpportunityTriggerHandler is a handler class for all business logic related to opportunity object
 * 
 */
public class OpportunityTriggerHandler implements ITriggerHandler{
    // Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean TriggerDisabled = false; 
    /*
    Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean IsDisabled()
    {    
       if (Trigger_Switch__c.getValues('OpportunityTrigger').is_active__c = true){ 
            return false;
        }
        else{ 
            return TriggerDisabled;
        } 
    }
 
    public void BeforeInsert(List<SObject> newItems) {
        System.debug('Beforeinsert method call>>>'+newItems);
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('before Method method call>>>'+newItems);
        OpportunityHelper.opportunityBeforeUpdate(newItems.values(),(Map<Id, Opportunity>)oldItems);
    }
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {
        OpportunityHelper.opportunityBeforeDelete(oldItems.values());
        
    }
 
    public void AfterInsert(Map<Id, SObject> newItems) {
          System.debug('After insert method call>>>'+newItems);
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('After update helper method call>>>'+newItems);
        OpportunityHelper.opportunityAfterUpdate((Map<Id, Opportunity>) newItems,(Map<Id, Opportunity>)oldItems);
    }
 
    public void AfterDelete(Map<Id, SObject> oldItems) {
        OpportunityHelper.opportunityAfterDelete(oldItems.values());
    }
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}