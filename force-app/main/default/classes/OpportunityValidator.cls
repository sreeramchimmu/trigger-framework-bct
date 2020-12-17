/*
Class name : OpportunityValidator
Description  : This is a Trigger Handler class for EnsureOppLineItem Trigger.
Author       : Sreeram. V
Date Created : 05-Mar-2020         

Modified for bug by	: Sreeram. V
Last Modified Date 	: 12-Mar-2020
*/

public with sharing class OpportunityValidator {
    
    //below method checks if the Stage is changed to Closed Won
    public static Boolean ValidateOpportunity (Opportunity opp){        
         
        if(opp.StageName == 'Closed Won'){
            system.debug('inside target1::: '+Limits.getQueries());
          return HasOppLineItem (opp);            
        }
        else{
            return true;
        }
    }
    
    //below method checks for Line item in Opportunity 
    public static Boolean HasOppLineItem(Opportunity opp){
        List<Opportunity_Line_Item__c> oppLineItem = [select id from Opportunity_Line_Item__c where Opportunity_ID__c = :opp.Id];
        system.debug('inside target2::: '+Limits.getQueries());
        if(oppLineItem.isEmpty()){
            system.debug('inside target3::: '+Limits.getQueries());
            return false;
        }
       	return HasRevTerm(oppLineItem); 
    } 
    
    //below method checks for Revenue Splits in Line Item 
    public static Boolean HasRevTerm(List<Opportunity_Line_Item__c> oppLineItem){
system.debug('inside target4::: '+Limits.getQueries());        
        List<Revenue_term__c> revList;
       	Boolean booleanswitch;
        
        Opportunity_line_item__c oppline = oppLineItem[0];
        
        //for(Opportunity_line_item__c oppline : OppLineItem){
           revList = [select id from Revenue_Term__c where Opportunity_line_item_id__c =: oppline.id];
            system.debug('inside target5::: '+Limits.getQueries());
            if(revList.isEmpty()){          
            	booleanswitch = false;
        	}
            if(!revList.isEmpty()){
            	booleanswitch =true;    
            }
        //}
        return booleanswitch;  
    }
}