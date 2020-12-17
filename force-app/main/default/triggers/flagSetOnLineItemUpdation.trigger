/*
Trigger name : flagSetOnLineItemUpdation
Description  : This Utility trigger(for Line Item object) can be utilised for initiating or updating static boolean flags used across various triggers.
Author       : Sreeram. V
Date Created : 19-Mar-2020         

Modified for bug by : Sreeram. V
Last Modified Date  : 19-Mar-2020
*/

trigger flagSetOnLineItemUpdation on Opportunity_Line_Item__c (before update,after delete) {
    boolean isActive = false; 
    
   /*  List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='flagSetOnLineItemUpdation' and IS_ACTIVE__c=true];
    
    for(TriggerSwitch__c trig : trgsettings){
       isActive = true;
    } */
    
    Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('flagSetOnLineItemUpdation');
   if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c)))   { 
          isActive = true; 
       system.debug('inside switchVar flagSetOnLineItemUpdation :: '+limits.getQueries());
    }
    
    if(isActive){
        if(Trigger.isBefore){
            if(Trigger.isUpdate){
                system.debug('inside flagSetOnLineItemUpdation trigger::::');
                flagGlobal.flagForLineItemUpdation = false;
            }
        }
        if(trigger.isafter && trigger.isdelete) 
        {
            List<Archive_Opportunity_Line_Item__c> arcOppLine = new List<Archive_Opportunity_Line_Item__c>();  
            for(Opportunity_Line_Item__c opL:Trigger.old){ // Iterating over Revenue  list.
                for(Archive_Opportunity_Line_Item__c arOpLine:[Select id from Archive_Opportunity_Line_Item__c where Opp_Line_Id__c =:opL.Id and Archive_Opportunity_line_item_Snapshot__c = This_Month]){
                    arcOppLine.add(arOpLine);  
                }
            }
            if(arcOppLine.size() > 0)
            {
                try
                {  
                    System.debug('Archive Opp line Deleted successfully???'+arcOppLine.size());
                    delete arcOppLine;   
                }catch(Exception e)
                { 
                    HandleCustomException.LogException(e); 
                }   
            }  
        }
    } 
}