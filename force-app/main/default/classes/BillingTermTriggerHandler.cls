/**
* Trigger Name : OpportunityTrigger
*
* Author	   : Sreeram Venkatesan
*
* Date Created : 14th Dec 2020
*
* Purpose      : BillingTermTriggerHandler is a handler class for all business logic related to Billing Splits object
*  
*/
public class BillingTermTriggerHandler implements ITriggerHandler{
	
    public static Boolean TriggerDisabled = true; 

    /*  
    Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean IsDisabled()
    {    
        if(Trigger_Switch__c.getValues('BillingTermTrigger').is_active__c){ 
           return false;          
        }
        else{            
            return TriggerDisabled;
        } 
    }
 
    public void BeforeInsert(List<SObject> newItems) {
        BillingTermTriggerHelper.billingTermBeforeInsert(newItems); 
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {         
        BillingTermTriggerHelper.billingTermBeforeUpdate(newItems.values() ,(Map<Id, Billing_term__c>) oldItems);          
    }
  
    public void BeforeDelete(Map<Id, SObject> oldItems) {
         
    }
 
    public void AfterInsert(Map<Id, SObject> newItems) {
         
    }
  
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) { 
        BillingTermTriggerHelper.billingTermAfterUpdate((Map<Id, Billing_term__c>) newItems,(Map<Id, Billing_term__c>) oldItems);		 
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {
        
    }
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {
        
    }
}