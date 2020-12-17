/**
* Class: ArchiveOpportunityBatch
*
* Author: Revathi Saminathan
*
* Date Created: 25.08.2020
*
* Purpose: The ArchiveOpportunityBatch is responsible for making run batch by Monthly bases to
retrive the all the Opportunity, Opportunity line item and revenue term object to the Archive objects.
* 
*/
global class ArchiveOpportunityBatch implements Database.Batchable<sObject> {
    
    // variable declartion  
    
    public Set<Id> oppId = new Set<Id>(); 
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {  
        //All Record  Retrive form the respective Object
        String query = 'SELECT Id,StageName,createdDate,Owner_Full_Name__c,Total_Order_Value_Report__c,OwnerId,Name,SBU__c,Type,LeadSource,Account_Name__c,LOST_TO_COMPETITOR__c,Opportunity_number_new__c,CampaignId,Description,NextStep,Legal_Entity__c,Opportunity_Category__c,CloseDate,Hold_Lost_Reason__c,Hold_Lost_Description__c,Funnel_Code__c,Probability__c,Amount,Current_FY_Act_Fst_Raw_Rev__c,Current_FY_Revenue__c,Current_FY_Act_Fcst_Cogs_Bctpl__c,Current_FY_Cogs_Bctpl__c,Current_FY_Act_Fsct_CogsOthers__c,Current_FY_Cogs_others__c,Current_FY_Act_Fsct_GM__c,Current_FY_Gross_Margin__c,Next_FY_Act_Fsct_Revenue__c,Next_FY_Revenue__c,Next_FY_Act_Fcst_CogsBctpl__c,Next_FY_Cogs_Bctpl__c,Next_FY_Act_Fcst_Cogs_Others__c,Next_FY_Cogs_Others__c,Next_FY_Act_Fsct_GM__c, Next_FY_Gross_Margin__c,CONTRACT_PO_SIGN_DATE__c,PROJECT_START_DATE__c,CONTRACT_PO_NUMBER__c,PROJECT_END_DATE__c,Project_Manager__c,PROJECT_COMPLETED__c,Last_StageName__c,Project_Duration__c,Opportunity_Line_Order_value__c,GEO_Margin__c,Total_GEO_Margin__c,Total_COGS_BCTPL_Opp__c,Total_COGS_Others_Opp__c,Auto_Number__c FROM Opportunity ORDER BY Auto_Number__c ASC'; 
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> sobjList) 
    {  
        Set<Id> oppLineId = new Set<Id>();
        List<Opportunity_Line_Item__c> oppLineItemAllList = new List<Opportunity_Line_Item__c>();
        List<Revenue_Term__c> revAllList = new  List<Revenue_Term__c>();
        
        if(sobjList.size()>0)
        { 
            for(Opportunity o : sobjList)
            {
                oppId.add(o.Id); 
            }
            
            if(oppId.size()>0)
            {
                oppLineItemAllList = [SELECT Id,createdDate,Billing_Term_Balance_amount__c,Revenue_Term_Balance_amount__c,BCTPL_Rate_Card__c,BCT_Rate_Card__c,Child_PID__c,COGS_BCTPL__c,Cogs_Bctpl_percentage__c,
                                      COGS_Others__c,COGS_Others_Percentage__c,Competency__c,Current_FY_CogsBctpl_OLI__c,Current_FY_CogsOthers_OLI__c,Current_FY_GM_OLI__c,
                                      Current_FY_Wt_Cogs_Bctpl_OLI__c,Current_FY_Wt_Cogs_others_OLI__c,Current_FY_Wt_GM_OLI__c,Current_FY_W_t_Revenue_OLI__c,Current_FY_Revenue__c,
                                      Employee_ID__c,Employee_Name__c,Funnel_Code__c,Total_GEO_Margin__c,Geo_Margin__c,Incentive_Qualifier__c,Line_Item__c,Name,Revenue_Stream__c,
                                      Next_FY_Cogs_Bctpl_OLI__c,Next_FY_Cogs_Others_OLI__c,Next_FY_GM_OLI__c,Next_FY_Revenue_OLI__c,Next_FY_Revenue__c,Next_FY_Wt_Cogs_Bctpl_OLI__c,
                                      Next_FY_Wt_Cogs_Others_OLI__c,Next_FY_Wt_GM_OLI__c,Next_FY_W_t_Revenue_OLI__c,Prev_FY_Revenue__c,Project_Category__c,Project_ID__c,
                                      Project_Type__c,Pillar__c,Current_FY_Revenue_OLI__c,Opportunity_ID__c,Opportunity_ID__r.Name,
                                      RecognisedAmountSummary__c,Product__c,Total_Value__c FROM Opportunity_Line_Item__c  WHERE Opportunity_ID__c = :oppId ORDER BY Name ASC];
                
            }
            if(oppLineItemAllList.size()>0)
            {
                for(Opportunity_Line_Item__c oL : oppLineItemAllList)
                {
                    oppLineId.add(oL.Id); 
                }
            } 
            if(oppLineId.size()>0)
            { 
                revAllList = [Select Id,createdDate,Actual_COGS_BCTPL__c,Actual_COGS_Others__c,Actual_GM__c,Recognized_Amount__c,Business_Category_Revenue__c,
                              Change_Reason__c,Total_GEO_Margin__c,Geo_Margin__c,Milestone__c,Percentage__c,Milestone_Basis__c,Opportunity_item_id__c,Overall_COE_Revenue__c,
                              Overall_Revenue__c,Product_Type_Rev__c,Revenue_Date__c,Name,Revenue_Term__c,Shift_Subsequent_Revenue_Dates__c,Amount__c,Total_COGS_BCTPL_Rev__c,
                              Total_COGS_Others_Rev__c,Overall_Revenue_Raw_Cogsother__c,Overall_Revenue_Raw_GM__c,W_Avg_Cogs_Bctpl_Revenue__c,W_Avg_Cogs_Others_Revenue__c,
                              W_Avg_GM_Revenue__c,W_Avg_Total_Revenue__c,Opportunity_line_item_id__r.Opportunity_ID__c, Opportunity_line_item_id__c,Actual_Forecast__c,Actual_Forecast_Rev__c,
                              Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c,Total_Revenue_Cogsothers_Rev__c,Total_Revenue_GM_Rev__c,Wt_Avg_Cogs_Bctpl_Rev__c,
                              Wt_Avg_Cogs_Others_Rev__c,Wt_Avg_GM_Rev__c from Revenue_Term__c WHERE Opportunity_line_item_id__c = :oppLineId ORDER BY Name ASC]; 
            } 
            if(sobjList.size()>0)
            { 
                ArchiveOpportunityHelper.createMonthlyArchiveOpportunity(sobjList,oppLineItemAllList,revAllList); 
            }  
            oppId.clear();
            oppLineId.clear();
            oppLineItemAllList.clear();
            revAllList.clear();  
        }  
    }    
    global void finish(Database.BatchableContext BC)
    {
        // execute any post-processing operations like sending email
        Id BatchId = BC.getJobId();
        system.debug('BatchId>>>>>>>>>>>>>>>>'+ BatchId);
        
         AsyncApexJob a = [Select Id, Status,MethodName,ExtendedStatus,CreatedDate,CompletedDate,NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setHtmlBody('Hello, <br/><br/>This is to notify, that Monthly archival batch Apex job processed ' + a.TotalJobItems +
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
        mail.setSubject('Monthly Archival Batch Job ' + a.Status);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
    }
}