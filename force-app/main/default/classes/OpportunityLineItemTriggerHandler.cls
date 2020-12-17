/**
 * Class: OpportunityLineItemTriggerHandler 
 *
 * Author: Revathi Saminathan
 *
 * Date Created: 24.11.2020
 *
 * Purpose: OpportunityLineItemTriggerHandler is a handler class for all business logic related to opportunity line item object
 * 
 */
public class OpportunityLineItemTriggerHandler implements ITriggerHandler{
 // Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean TriggerDisabled = true; 
    /*
    Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean IsDisabled()
    {    
       if (Trigger_Switch__c.getValues('OpportunityLineItemTrigger').is_active__c){ 
           system.debug('asd');
            return false;
        }
        else{ 
             system.debug('asd1');
            return TriggerDisabled;
        } 
    }
 
    public void BeforeInsert(List<SObject> newItems) {
        System.debug('Beforeinsert method call>>>'+newItems);
        OpportunityLineItemHelper.opportunityLineItemBeforeInsert(newItems);
    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('before Method method call>>>'+newItems);  
        OpportunityLineItemHelper.opportunityLineItemBeforeUpdate(newItems.values(),(Map<ID,Opportunity_line_item__c>) oldItems);
    }
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterInsert(Map<Id, SObject> newItems) {
          System.debug('After insert method call>>>'+newItems);
        
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        System.debug('After update helper method call>>>'+newItems); 
         OpportunityLineItemHelper.opportunityLineItemAfterUpdate((Map<Id, Opportunity_Line_Item__c>)newItems,(Map<Id, Opportunity_Line_Item__c>)oldItems); 
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {
        OpportunityLineItemHelper.opportunityLineItemAfterDelete(oldItems.values());
    }
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}