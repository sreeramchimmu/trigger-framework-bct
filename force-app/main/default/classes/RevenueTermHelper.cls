/**
* Class: RevenueTermHelper
*
* Author: Revathy Saminathan
*
* Date Created: 01.12.2020
*
* Purpose: RevenueTermHelper is a handler class for all business logic related to Revenue Term object
* 
*/
public class RevenueTermHelper {
    
    public static void revenueTermAfterInsert(Map<Id, Revenue_Term__c> oppNewItems)
    { 
        new QuotaVsActualManagerTrig(oppNewItems,null).processRevenueDetails(); 
    }
    public static void revenueTermAfterUpdate(Map<Id, Revenue_Term__c> revNewItems, Map<Id, Revenue_Term__c> revOldItems)
    {
        new QuotaVsActualManagerTrig(revNewItems, revOldItems).processRevenueDetails();   
    }
    public static void revenueTermBeforeDelete(Map<Id, Revenue_Term__c> revOldItems)
    {
        new QuotaVsActualManagerTrig(null, revOldItems).processRevenueDetails();   
    }
    public static void revenueTermAfterDelete(List<Revenue_Term__c> oldRevenueList)
    {

        List<Archive_Revenue_Term__c> arcRev = new List<Archive_Revenue_Term__c>();  
        for(Revenue_Term__c re : oldRevenueList){ // Iterating over Revenue  list.
            for(Archive_Revenue_Term__c arcR:[Select id from Archive_Revenue_Term__c where Revenue_Name__c=:re.Name and Archive_Revenue_Split_Snapshot__c = This_Month]){
                arcRev.add(arcR);  
            }
        }
        if(arcRev.size() > 0)
        { 
            try
            {  
                System.debug('Archive revenue Deleted successfully ???'+arcRev.size());
                delete arcRev;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            }  
        }          
    }
    
    public static void revenueTermBeforeInsert(List<Revenue_Term__c> newReveList)
    { 
         Set<Id> oppLineId = new Set<Id>();
        
        if(newReveList.size() >0 )
        {
            for(Revenue_Term__c re : newReveList)
            {
                
                System.debug('reve Owner>>>'+re.Revenue_Owner__c);
                 System.debug('line item Owner>>>'+re.Opportunity_line_item_id__r.Name);
                if(re.Revenue_Owner__c == null)
                {
                    //oppLineId.add(re.Opportunity_line_item_id__c);
                     re.Revenue_Owner__c = re.Opportunity_line_item_id__r.Owner_ID_OppLine__c;
                } 
            }
          /*  if(oppLineId.size() > 0)
            {
                List<Opportunity> opList = [];
            }*/
        }
        
       /* double oppLineTotal =0;
        double newValue =0;
        double revTermTotal;
        
        Map<Id, Opportunity_Line_Item__c> revMap = new Map<Id, Opportunity_Line_Item__c>(
            [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where id IN :setIds]
        );
        system.debug('revMap size :'+revMap.size());
        List<Revenue_Term__c> revTermList = [SELECT Id, Opportunity_line_item_id__c, Amount__c,Opportunity_line_item_id__r.Total_Value__c FROM Revenue_Term__c where Opportunity_line_item_id__c = :setIds ];
        system.debug('revTermList size :'+revTermList.size());
        for(Revenue_Term__c rev : newReveList){
            
            revTermTotal = 0;            
            oppLineTotal = revMap.get(rev.Opportunity_line_item_id__c).Total_Value__c;
            newValue = rev.Amount__c; 
            
           		system.debug('newValue : '+newValue);
            for(Revenue_term__c  revValue : revTermList){
                if(revMap.get(rev.Opportunity_line_item_id__c).id == revValue.Opportunity_line_item_id__c){
                 	revTermTotal = revTermTotal + revValue.Amount__c;   
                }				
			} 
            
            revTermTotal = revTermTotal + newValue;
            system.debug('revTermTotal : '+revTermTotal);
            system.debug('oppLineTotal : '+oppLineTotal);
            if(revTermTotal > oppLineTotal){
                rev.addError('rev NEW TRIGGER FRAMEWORK Opportunity Line total value should not exceed the Total Order Value!!');	
            }
        }*/       
        
    }
}