/**
* Trigger Name : RevenueTermTrigger
*
* Author: Revathi Saminathan
*
* Date Created: 01.12.2020
*
* Purpose: Need to perform the all the opportunity related function from the Revenue Term object logic 
*  
*/
trigger RevenueTermTrigger on Revenue_Term__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
 TriggerDispatcher.Run(new RevenueTermTriggerHandler());
}