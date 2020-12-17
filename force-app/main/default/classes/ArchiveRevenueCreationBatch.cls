/**
* Class: ArchiveOpportunityCreationBatch
*
* Author: Revathi Saminathan
*
* Date Created: 2.11.2020
*
* Purpose: The ArchiveRevenueCreationBatch is responsible for making run batch by daily bases to create the Archive Revenue and revenue object.
* 
*/
global class ArchiveRevenueCreationBatch implements Database.Batchable<sObject> {
 
    global List<Revenue_Term__c> start(Database.BatchableContext BC) { 
        datetime objDateTime = System.now()-1;
        List<Revenue_Term__c> revList =  [Select Id,createdDate,Actual_COGS_BCTPL__c,Actual_COGS_Others__c,Actual_GM__c,Recognized_Amount__c,Business_Category_Revenue__c,
                                          Change_Reason__c,Total_GEO_Margin__c,Geo_Margin__c,Milestone__c,Percentage__c,Milestone_Basis__c,Opportunity_item_id__c,Overall_COE_Revenue__c,
                                          Overall_Revenue__c,Product_Type_Rev__c,Revenue_Date__c,Name,Revenue_Term__c,Shift_Subsequent_Revenue_Dates__c,Amount__c,Total_COGS_BCTPL_Rev__c,
                                          Total_COGS_Others_Rev__c,Overall_Revenue_Raw_Cogsother__c,Overall_Revenue_Raw_GM__c,W_Avg_Cogs_Bctpl_Revenue__c,W_Avg_Cogs_Others_Revenue__c,
                                          W_Avg_GM_Revenue__c,W_Avg_Total_Revenue__c,Opportunity_line_item_id__r.Opportunity_ID__c, Opportunity_line_item_id__c,Actual_Forecast__c,Actual_Forecast_Rev__c,
                                          Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c,Total_Revenue_Cogsothers_Rev__c,Total_Revenue_GM_Rev__c,Wt_Avg_Cogs_Bctpl_Rev__c,
                                          Wt_Avg_Cogs_Others_Rev__c,Wt_Avg_GM_Rev__c from Revenue_Term__c WHERE CreatedDate >=:objDateTime and Opportunity_line_item_id__r.createdDate !=Today];
        return revList;
    }
    
    global void execute(Database.BatchableContext BC, List<Revenue_Term__c> objList) {
         
        // process each batch of records default size is 200  
         
        List<Archive_Opportunity_Line_Item__c> archiveOppLineItemList = new List<Archive_Opportunity_Line_Item__c>();  
        List<Revenue_Term__c> revList = new List<Revenue_Term__c>();    
        List<Archive_Revenue_Term__c> archiveRevList = new List<Archive_Revenue_Term__c>(); 
         
        Set<Id> oppLineItemId = new Set<Id>();   
        Set<String> revName = new Set<String>();  
          
       if(objList.size() > 0)
        {
            for(Revenue_Term__c oLI : objList)
            { 
                oppLineItemId.add(oLI.Opportunity_line_item_id__c);
                revName.add(oLI.Name);
            } 
        }
        
        if(oppLineItemId.size() > 0)
        { 
            archiveOppLineItemList = [SELECT Id,Archive_Opportunity_line_item_Snapshot__c,Line_Item_Name__c,Opp_Line_Id__c FROM Archive_Opportunity_Line_Item__c where  Opp_Line_Id__c = : oppLineItemId and Archive_Opportunity_line_item_Snapshot__c = THIS_MONTH ORDER BY Name ASC]; 
            archiveRevList = [SELECT Revenue_Name__c,Id,Archive_Revenue_Split_Snapshot__c  FROM Archive_Revenue_Term__c where Revenue_Name__c = : revName and Archive_Revenue_Split_Snapshot__c = THIS_MONTH ORDER BY Name ASC ];    
            
            revList = [Select Id,createdDate,Actual_COGS_BCTPL__c,Actual_COGS_Others__c,Actual_GM__c,Recognized_Amount__c,Business_Category_Revenue__c,
                       Change_Reason__c,Total_GEO_Margin__c,Geo_Margin__c,Milestone__c,Percentage__c,Milestone_Basis__c,Opportunity_item_id__c,Overall_COE_Revenue__c,
                       Overall_Revenue__c,Product_Type_Rev__c,Revenue_Date__c,Name,Revenue_Term__c,Shift_Subsequent_Revenue_Dates__c,Amount__c,Total_COGS_BCTPL_Rev__c,
                       Total_COGS_Others_Rev__c,Overall_Revenue_Raw_Cogsother__c,Overall_Revenue_Raw_GM__c,W_Avg_Cogs_Bctpl_Revenue__c,W_Avg_Cogs_Others_Revenue__c,
                       W_Avg_GM_Revenue__c,W_Avg_Total_Revenue__c,Opportunity_line_item_id__r.Opportunity_ID__c, Opportunity_line_item_id__c,Actual_Forecast__c,Actual_Forecast_Rev__c,
                       Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c,Total_Revenue_Cogsothers_Rev__c,Total_Revenue_GM_Rev__c,Wt_Avg_Cogs_Bctpl_Rev__c,
                       Wt_Avg_Cogs_Others_Rev__c,Wt_Avg_GM_Rev__c from Revenue_Term__c WHERE Name = :revName ORDER BY Name ASC]; 
        }  
        if(archiveOppLineItemList.size() > 0 && revList.size() > 0 && archiveRevList.size() == 0){
            ArchiveOpportunityHelper.createArchiveRevenueSplit(revList,archiveOppLineItemList);
        }
         
        revList.clear();
        objList.clear();    
        archiveRevList.clear();
        archiveOppLineItemList.clear();
        oppLineItemId.clear();   
        revName.clear();  
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        Id BatchId = BC.getJobId();
        system.debug('BatchId>>>>>>>>>>>>>>>>'+ BatchId);
        
        AsyncApexJob a = [Select Id, Status,MethodName,ExtendedStatus,CreatedDate,CompletedDate,NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setHtmlBody('Hello, <br/><br/>This is to notify, that Daily archival batch Apex job processed ' + a.TotalJobItems +
                         ' batches with '+ a.NumberOfErrors + ' failures.<br/><br/>'+
                         +'<table border="1px solid black">'+
                         +'<tr><td><b>Job ID</b></td><td>'+ a.ID +'</td></tr>'+
                         +'<tr><td><b>Start Date</b></td><td>'+ a.CreatedDate +'</td></tr>'+                             
                         +'<tr><td><b>Completed Date</b></td><td>'+ a.CompletedDate +'</td></tr>'+
                         +'<tr><td><b>Class Name</b></td><td>'+ a.MethodName +'</td></tr>'+
                         +'<tr><td><b>Total Batches</b></td><td>'+ a.TotalJobItems +'</td></tr>'+
                         +'<tr><td><b>Batches Processed</b></td><td>'+ a.JobItemsProcessed +'</td></tr>'+
                         +'<tr><td><b>Batches Failed</b></td><td>'+ a.NumberOfErrors +'</td></tr>'+ 
                         +' </table><br/><br/>Regards,<br/>Bahwan Cybertek ');
        mail.setSubject('Daily Archival Batch Job ' + a.Status);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    } 
}