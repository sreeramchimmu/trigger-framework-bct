/**
 * Class: RevenueTermTriggerHandler 
 *
 * Author: Revathi Saminathan
 *
 * Date Created: 01.12.2020
 *
 * Purpose: RevenueTermTriggerHandler is a handler class for all business logic related to Revenue Term object
 * 
 */
public class RevenueTermTriggerHandler implements ITriggerHandler{
// Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean TriggerDisabled = true; 
    /*
    Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean IsDisabled()
    {    
       if (Trigger_Switch__c.getValues('RevenueTermTrigger').is_active__c){ 
            return false;
        }
        else{ 
            return TriggerDisabled;
        } 
    }
 
    public void BeforeInsert(List<SObject> newItems) { 
        System.debug('revenue Before Insert Call');
        RevenueTermHelper.revenueTermBeforeInsert(newItems);
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('before Method method call>>>'+newItems); 
        
    }
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {
        RevenueTermHelper.revenueTermBeforeDelete((Map<Id, Revenue_Term__c>) oldItems);
    }
 
    public void AfterInsert(Map<Id, SObject> newItems) {   
        RevenueTermHelper.revenueTermAfterInsert((Map<Id, Revenue_Term__c>) newItems);
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        RevenueTermHelper.revenueTermAfterUpdate((Map<Id, Revenue_Term__c>) newItems,(Map<Id, Revenue_Term__c>)oldItems);
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) { 
         RevenueTermHelper.revenueTermAfterDelete(oldItems.values());
    }
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}