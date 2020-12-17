/**
* Trigger Name : OpportunityLineItemTrigger
*
* Author: Revathi Saminathan
*
* Date Created: 24.11.2020
*
* Purpose: Need to perform the all the opportunity related function from the OpportunityLineItemTrigger 
*  
*/
trigger OpportunityLineItemTrigger on Opportunity_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.Run(new OpportunityLineItemTriggerHandler()); 
}