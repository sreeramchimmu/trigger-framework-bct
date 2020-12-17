/**
* Trigger Name : OpportunityTrigger
*
* Author	   : Sreeram Venkatesan
*
* Date Created : 14th Dec 2020
*
* Purpose      : Need to perform the all the Billing split related function from the BillingTermTrigger
*  
*/
trigger BillingTermTrigger on Billing_Term__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
     TriggerDispatcher.Run(new BillingTermTriggerHandler());   
}