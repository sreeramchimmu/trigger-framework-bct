/**
* Trigger Name : OpportunityTrigger
*
* Author: Revathi Saminathan
*
* Date Created: 11.11.2020
*
* Purpose: Need to perform the all the opportunity related function from the Opportunitytrigger 
*  
*/
trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) { 
    System.debug('Opportunity trigger invoke');
    TriggerDispatcher.Run(new OpportunityTriggerHandler());
}