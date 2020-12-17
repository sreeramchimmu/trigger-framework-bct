/**
* Class: ArchiveOpportunityCreationBatch
*
* Author: Revathi Saminathan
*
* Date Created: 22.10.2020
*
* Purpose: The ArchiveOpportunityLineTemCreateBatch is responsible for making run batch by daily bases to create the Archive opportunity line item and revenue object.
* 
*/
global class ArchiveOpportunityLineTemCreateBatch implements Database.Batchable<sObject> {
     
    global List<Opportunity_Line_Item__c> start(Database.BatchableContext BC) { 
        datetime objDateTime = System.now()-1;
        List<Opportunity_Line_Item__c> opLineList = [SELECT Id,createdDate,Billing_Term_Balance_amount__c,Revenue_Term_Balance_amount__c,BCTPL_Rate_Card__c,BCT_Rate_Card__c,Child_PID__c,COGS_BCTPL__c,Cogs_Bctpl_percentage__c,
                                                     COGS_Others__c,COGS_Others_Percentage__c,Competency__c,Current_FY_CogsBctpl_OLI__c,Current_FY_CogsOthers_OLI__c,Current_FY_GM_OLI__c,
                                                     Current_FY_Wt_Cogs_Bctpl_OLI__c,Current_FY_Wt_Cogs_others_OLI__c,Current_FY_Wt_GM_OLI__c,Current_FY_W_t_Revenue_OLI__c,Current_FY_Revenue__c,
                                                     Employee_ID__c,Employee_Name__c,Funnel_Code__c,Total_GEO_Margin__c,Geo_Margin__c,Incentive_Qualifier__c,Line_Item__c,Name,Revenue_Stream__c,
                                                     Next_FY_Cogs_Bctpl_OLI__c,Next_FY_Cogs_Others_OLI__c,Next_FY_GM_OLI__c,Next_FY_Revenue_OLI__c,Next_FY_Revenue__c,Next_FY_Wt_Cogs_Bctpl_OLI__c,
                                                     Next_FY_Wt_Cogs_Others_OLI__c,Next_FY_Wt_GM_OLI__c,Next_FY_W_t_Revenue_OLI__c,Prev_FY_Revenue__c,Project_Category__c,Project_ID__c,
                                                     Project_Type__c,Pillar__c,Current_FY_Revenue_OLI__c,Opportunity_ID__c,Opportunity_ID__r.Name,
                                                     RecognisedAmountSummary__c,Product__c,Total_Value__c FROM Opportunity_Line_Item__c  WHERE CreatedDate >=:objDateTime and Opportunity_ID__r.createdDate !=Today ORDER BY Name ASC];
        return opLineList;
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity_Line_Item__c> objList) {
         
        // process each batch of records default size is 200 
        List<Archive_Opportunity__c> archiveOppList = new List<Archive_Opportunity__c>();
         
        List<Archive_Opportunity_Line_Item__c> archiveOppLineItemList = new List<Archive_Opportunity_Line_Item__c>();  
        List<Revenue_Term__c> revList = new List<Revenue_Term__c>();   
         
        Set<Id> oppLineItemId = new Set<Id>();   
        Set<Id> opprelatedLineId = new Set<Id>();  
          
       if(objList.size() > 0)
        {
            for(Opportunity_Line_Item__c oLI : objList)
            {
                oppLineItemId.add(oLI.Id);
                opprelatedLineId.add(oLI.Opportunity_ID__c);
            } 
        }
        
        if(oppLineItemId.size() > 0)
        {
            archiveOppList = [SELECT Id,Opportunity_Related__c,Opportunity_Id__c,CreatedDate,Archive_Opportunity_Snapshot__c FROM Archive_Opportunity__c where Opportunity_Id__c = :opprelatedLineId and Archive_Opportunity_Snapshot__c = THIS_MONTH ORDER BY Name ASC];   
            archiveOppLineItemList = [SELECT Id,Archive_Opportunity_line_item_Snapshot__c,Line_Item_Name__c,Opp_Line_Id__c FROM Archive_Opportunity_Line_Item__c where  Opp_Line_Id__c = : oppLineItemId and Archive_Opportunity_line_item_Snapshot__c = THIS_MONTH ORDER BY Name ASC]; 
            revList = [Select Id,createdDate,Actual_COGS_BCTPL__c,Actual_COGS_Others__c,Actual_GM__c,Recognized_Amount__c,Business_Category_Revenue__c,
                       Change_Reason__c,Total_GEO_Margin__c,Geo_Margin__c,Milestone__c,Percentage__c,Milestone_Basis__c,Opportunity_item_id__c,Overall_COE_Revenue__c,
                       Overall_Revenue__c,Product_Type_Rev__c,Revenue_Date__c,Name,Revenue_Term__c,Shift_Subsequent_Revenue_Dates__c,Amount__c,Total_COGS_BCTPL_Rev__c,
                       Total_COGS_Others_Rev__c,Overall_Revenue_Raw_Cogsother__c,Overall_Revenue_Raw_GM__c,W_Avg_Cogs_Bctpl_Revenue__c,W_Avg_Cogs_Others_Revenue__c,
                       W_Avg_GM_Revenue__c,W_Avg_Total_Revenue__c,Opportunity_line_item_id__r.Opportunity_ID__c, Opportunity_line_item_id__c,Actual_Forecast__c,Actual_Forecast_Rev__c,
                       Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c,Total_Revenue_Cogsothers_Rev__c,Total_Revenue_GM_Rev__c,Wt_Avg_Cogs_Bctpl_Rev__c,
                       Wt_Avg_Cogs_Others_Rev__c,Wt_Avg_GM_Rev__c from Revenue_Term__c WHERE Opportunity_line_item_id__c = :oppLineItemId ORDER BY Name ASC]; 
        }  
        if(objList.size() > 0 && archiveOppList.size() > 0 && revList.size() > 0 && archiveOppLineItemList.size() ==0)
        { 
            ArchiveOpportunityHelper.createArchiveOpportunityLineItem(objList,archiveOppList,revList);
        }
           
        revList.clear();
        objList.clear();   
        archiveOppList.clear(); 
        oppLineItemId.clear(); 
        opprelatedLineId.clear();
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