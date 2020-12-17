trigger RevenueSplitValueCheckTrigger on Revenue_Term__c (before insert,before update, after delete) {

double oppLineTotal = 0;
double newValue = 0;
double revTermTotal = 0;
double updatedRevTotal = 0;
boolean isActive = false; 

  Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('RevenueSplitValueCheckTrigger');
   if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c)))   {
          isActive = true;
       system.debug('inside switchVar RevenueSplitValueCheckTrigger :: '+limits.getQueries());
    }  
    
    if(isActive){
        if(trigger.isafter && trigger.isdelete) 
        {
            List<Archive_Revenue_Term__c> arcRev = new List<Archive_Revenue_Term__c>();  
            for(Revenue_Term__c re:Trigger.old){ // Iterating over Revenue  list.
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
    }
    
  if(isActive && RunTriggerOnce.RunTriggerOnceOnRevenueSplitValueCheckTrigger)
    { 
       //RunTriggerOnce.RunTriggerOnceOnRevenueSplitValueCheckTrigger = false;
        if(trigger.isbefore){
            
             List <Revenue_Term__c > revenueObj = Trigger.new;
        //Revenue Date from History table = 2-Jan-2020
        List <Revenue_Term__History> revenueHistoryObj = [SELECT NewValue,OldValue FROM Revenue_Term__History where ParentId=:revenueObj[0].id and Field='Percentage__c' ORDER BY CreatedDate DESC LIMIT 1];
        double oldMilestoneValue = 0.0;
        if(revenueHistoryObj.size()>0){
            oldMilestoneValue = Double.valueOf(revenueHistoryObj[0].NewValue);
        }
            
            List<opportunity_line_item__c> oppLineListInsert = [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where id = :revenueObj[0].Opportunity_Line_Item_id__c];
            for (opportunity_line_item__c  oplList : oppLineListInsert){
            oppLineTotal = oplList.Total_Value__c ;
            system.debug('value of opportunity line item '+oppLineTotal);
            //Find Varience - different between a new & Old Milestone values - 1-Jan-2020   
            double newMilestone = Double.valueOf(oldMilestoneValue);
            double oldMilestone = Double.valueOf(revenueObj[0].Percentage__c);
            system.debug('newMilestoneValue '+newMilestone+' ,oldMilestoneValue '+oldMilestone);
            //revenueObj[0].Varience__c = newMilestone-oldMilestone;
            
            //checking big object data fetching
            /*List<Revenue_Track__b> track = new List<Revenue_Track__b>();
                for(Revenue_Track__b r:[SELECT Id,Milestone_Amount_Percentage__c,Milestone_Name__c,Revenue_Date__c,Revenue_Name__c,Revenue_Split__c FROM Revenue_Track__b where Revenue_Name__c='R171872'and Milestone_Amount_Percentage__c=2000.0 and Revenue_Date__c = 2020-10-07T00:00:00.000Z]){
                    revenueObj[0].Varience__c = Double.valueOf(r.Milestone_Amount_Percentage__c);                    
                }*/
           }
      if(trigger.isinsert){
             newValue = revenueObj[0].Amount__c; 
             system.debug('amount of new revenue value'+newValue );
             List <Revenue_Term__c > revTermList =[SELECT Id, Opportunity_line_item_id__c, Amount__c,Opportunity_line_item_id__r.Total_Value__c FROM Revenue_Term__c where Opportunity_line_item_id__c = :revenueObj[0].Opportunity_line_item_id__c ];
             for (Revenue_Term__c revList : revTermList){
                 revTermTotal = revTermTotal + revList.Amount__c;
             }
             revTermTotal = revTermTotal + newValue ;
             system.debug('*******revenue term total***'+revTermTotal);
             if(revTermTotal > oppLineTotal ){
               revenueObj[0].addError('Milestone Amount should not exceed the Opportunity Line value!!');
             }
          
             //Set Revenue owner from opportunity owner
             List<Revenue_Term__c> revOwnerMap = Trigger.new;
             id oppOwnerId = [select id,ownerid from opportunity where id=:revOwnerMap[0].Opportunity_item_id__c].ownerid;
             // flagGlobal.flab = false;
             for(Revenue_term__c rev: revOwnerMap){
                 rev.Revenue_Owner__c=oppOwnerId;
             }
         }

     if(trigger.isupdate && revenueObj.size()<=1) { // size() check added to skip the MLE 
        
             //List <Revenue_Term__c > revObjOld = Trigger.new;
             
                system.debug('revTermTotal::: '+revTermTotal);
       List <Revenue_Term__c > revListUpdate =[SELECT Id, Opportunity_line_item_id__c, Amount__c FROM Revenue_Term__c where Opportunity_line_item_id__c = :revenueObj[0].Opportunity_line_item_id__c and ID != :revenueObj[0].id];
                 system.debug('revenue term list------->'+revListUpdate);
                    for(Revenue_Term__c  rList : revListUpdate ){
                     revTermTotal = revTermTotal + rList.Amount__c;
                    system.debug('*******revenue term total***'+revTermTotal);
                    }
               updatedRevTotal = revTermTotal + revenueObj[0].Amount__c;
         system.debug('updatedRevTotal::: '+updatedRevTotal);
            if (updatedRevTotal > oppLineTotal ){
                system.debug('updating new value ------------>'+revTermTotal);
                system.debug('Opportunity line total ------------>'+oppLineTotal);
                
            revenueObj[0].addError('Milestone Amount should not exceed the Opportunity Line value!!!');
            
                 }

            

         }
        
        }
        
    }
   
    else
    {
          system.debug('RevenueSplitValueCheck Trigger is set to IN ACTIVE');
    }
    
}