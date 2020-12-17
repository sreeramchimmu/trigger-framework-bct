/**
* Class: OpportunityHelper
*
* Author: Revathy Saminathan
*
* Date Created: 11.11.2020
*
* Purpose: OpportunityHelper is a handler class for all business logic related to opportunity object
* 
*/
public class OpportunityHelper { 
    
    // This method will invoke when the Opportunity record get before update
    public static void opportunityBeforeUpdate(List<Opportunity> triggerNewList, Map<Id, Opportunity> oppOldItems)
    {
        
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        Set<Id> opId = new Set<Id>();
        for(Opportunity op : triggerNewList)
        {
            System.debug('Before update method invoke>>>');
            opId.add(op.Id);
            // validate the Opportunity must have opportunity line item and revenue term when the opportunity is closed
            if(!OpportunityValidator.ValidateOpportunity(op))
            {
                op.addError(System.Label.Opportunity_must_have_line_item_Rev);
            }
            //Validate the Opportunity, when the opportunity status is changed to 'closed won' need to attach the file 
            if(op.StageName == 'Closed Won' && oppOldItems.get(op.Id).StageName !='Closed Won')
            {
                List<contentdocumentlink> filer = [select id,ContentDocumentId from contentdocumentlink where LinkedEntityId =: op.id];
                if(filer.isEmpty())
                { 
                    op.addError(System.Label.Opportunity_must_file_attach);
                }
            } 
        }
        if(opId.size() > 0)
        {
            updateContactName(opId,triggerNewList);
        }
    }
    public static void updateContactName(Set<Id> OpId,List<Opportunity> NewOppList)
    {      
        List<OpportunityContactRole> oppConRole = [select ContactId,Contact.Name,OpportunityId from OpportunityContactRole where OpportunityId = :OpId and IsPrimary = TRUE];

        for(Opportunity op : NewOppList)
        {
            for(OpportunityContactRole role : oppConRole)
            {
                if(op.Id == role.OpportunityId)
                {
                    System.debug('Contact name Value>>>'+role.Contact.Name);
                    op.Contact_Name__c = role.Contact.Name; 
                } 
            }
            op.SubmitForApproval__c = double.valueOf(op.SubmitForApproval__c);
            if(op.Line_Balance_Amount__c > 0)
            {
                op.IntegratedWCosting__c = True;
            } 
        }  
    }
    public static void opportunityBeforeDelete(List<Opportunity> triggerOldList)
    {
        Set<Id> opId = new Set<Id>();
        for(Opportunity op : triggerOldList)
        {
            opId.add(op.Id);
        }
        
        if(opId.size() > 0)
        {
            deleteActualDetails(opId); 
        }
    }
    // This method will invoke when the Opportunity record get after delete
    public static void opportunityAfterDelete(List<Opportunity> triggerOldList)
    { 
        List<Archive_Opportunity__c> arcOpp = new List<Archive_Opportunity__c>(); 
        for(Opportunity op : triggerOldList)
        {   
            // this functionality is used to when the opportunity is deleted related archive opportunity of current month record will delete
            for(Archive_Opportunity__c arOp:[Select id,Opportunity_Number__c from Archive_Opportunity__c where Opportunity_Number__c = :op.Opportunity_number_new__c and Archive_Opportunity_Snapshot__c = This_Month]){
                arcOpp.add(arOp);   
            }
        }
        if(arcOpp.size() > 0)
        { 
            try
            {    
                delete arcOpp; 
            }catch(Exception e)
            {  
                HandleCustomException.LogException(e); 
            }  
        }  
    }
    
    public static void opportunityAfterUpdate(Map<Id, Opportunity> oppNewItems, Map<Id, Opportunity> oppOldItems)
    {
        List<Opportunity> triggerNewList = oppNewItems.values();
        Set<Id> actOpId = new Set<Id>();
        Set<Id> closedOppId = new Set<Id>();
        Set<Id> opId = new Set<Id>();
        
        for(Opportunity op : triggerNewList)
        { 
            System.debug('After update method invoke');
            opId.add(op.Id);
            
            if(op.Probability__c != oppOldItems.get(op.Id).Probability__c || (op.StageName != oppOldItems.get(op.Id).StageName && op.StageName == 'Closed Won'))
            {
                actOpId.add(op.Id);
            }
           
            if(op.OwnerId != oppOldItems.get(op.Id).OwnerId)
            { 
                // when the Opportunity owner is change and opportunity status is closed won then related revenue record of the revenue date is greater than start date
                // and revenue date is less than end date then will update the revenue owner field get update on the revenue record
                 new OppOwnerChangeTrigCls(oppNewItems, oppOldItems).processOwnerDetails();
            }
        }
        if(actOpId.size() > 0)
        { 
            actualRevenueUpdate(actOpId); 
        } 
        if(opId.size() > 0)
        { 
            updateOpportunityFields(opId,triggerNewList,oppOldItems);
        }
        
    }
    
    //This method is used to when the opportunity is delete related Revenue of the Actual Detail will be delete
    public static void deleteActualDetails(Set<Id> opId)
    {
        Set<Id> reId = new Set<Id>();
        List<Revenue_Term__c> actDetailList = [SELECT Id, Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId  FROM Revenue_Term__c where Opportunity_Line_Item_id__r.Opportunity_ID__r.id IN : opId];
        for(Revenue_Term__c re : actDetailList)
        {
            reId.add(re.Id);
        }
        if(reId.size() > 0)
        {
            List<Actual_Detail__c> actObj = [SELECT ID, RevenueTermRef__c FROM actual_detail__c where RevenueTermRef__c IN : reId];
            
            if(actObj.size() > 0)
            {
                try
                {    
                    delete actObj; 
                }catch(Exception e)
                {  
                    HandleCustomException.LogException(e); 
                }  
            }
        } 
    }
    
    //This method is used to when the opportunity Probability is changed related revenue field will be get updated
    public static void actualRevenueUpdate(Set<Id> opId)
    { 
        List<Revenue_Term__c> actualRevUpdateList = new List<Revenue_Term__c>();
        System.debug('Revenue List value id>>>'+opId);
        List<Revenue_Term__c> actualRevList =[SELECT Id,Name,Recognized_Amount__c,W_Avg_Total_Revenue__c,Actual_Forecast_Rev__c,
                                              Overall_Act_Forecast_Revenue__c,Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c ,
                                              Total_Revenue_Cogsothers_Rev__c ,Total_Revenue_GM_Rev__c ,Wt_Avg_Cogs_Bctpl_Rev__c ,Wt_Avg_Cogs_Others_Rev__c ,
                                              Wt_Avg_GM_Rev__c ,Overall_Revenue_Raw_Cogsbctpl__c ,Overall_Revenue_Raw_Cogsother__c ,Overall_Revenue_Raw_GM__c ,
                                              Overall_WtAvg_Cogsbctpl_Rev__c ,Overall_WtAvg_Cogsother_Rev__c ,Overall_WtAvg_GM_Rev__c,Actual_COGS_BCTPL__c ,
                                              Actual_COGS_Others__c ,Actual_GM__c,Total_Revenue_Raw_Fcst__c,Percentage__c FROM Revenue_Term__c WHERE Opportunity_line_item_id__c IN (SELECT id FROM Opportunity_Line_Item__c where Opportunity_ID__c IN :opId)];
        System.debug('Revenue List value>>>'+actualRevList.size()+'Name'+actualRevList[0].Name);
        if(actualRevList.size() > 0)
        {
            for(Revenue_Term__c rev : actualRevList)
            {
                rev.Actual_Forecast_Rev__c = rev.Overall_Act_Forecast_Revenue__c;
                rev.Current_FY_Act_Fst_Raw_Rev__c = rev.Total_Revenue_Raw_Fcst__c; 
                rev.Total_Revenue_Cogsbctpl_Rev__c  = rev.Overall_Revenue_Raw_Cogsbctpl__c;
                rev.Total_Revenue_Cogsothers_Rev__c   = rev.Overall_Revenue_Raw_Cogsother__c;
                rev.Total_Revenue_GM_Rev__c  = rev.Overall_Revenue_Raw_GM__c;
                rev.Wt_Avg_Cogs_Bctpl_Rev__c = rev.Overall_WtAvg_Cogsbctpl_Rev__c;
                rev.Wt_Avg_Cogs_Others_Rev__c = rev.Overall_WtAvg_Cogsother_Rev__c;
                rev.Wt_Avg_GM_Rev__c = rev.Overall_WtAvg_GM_Rev__c; 
                actualRevUpdateList.add(rev);
                
            }
        }
        if(actualRevUpdateList.size() > 0)
        {
             System.debug('Revenue update List value>>>'+actualRevUpdateList.size());
            try
            {     
                 update actualRevUpdateList;
            }catch(Exception e)
            {  
                System.debug('Update error>>'+e.getMessage());
                HandleCustomException.LogException(e); 
            }  
        }
    }
    
    // This is method is used to when the opportunity status is move to closed won then related revenue record of field will be update
    public static void closedWonRevenueUpdate(Set<Id> opId)
    {
        List<Revenue_Term__c> closedWonRevUpdateList = new List<Revenue_Term__c>();
        List<Revenue_Term__c> actualRevList = [SELECT Id,Name,Recognized_Amount__c,W_Avg_Total_Revenue__c,Actual_Forecast_Rev__c,
                                               Overall_Act_Forecast_Revenue__c,Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c ,
                                               Total_Revenue_Cogsothers_Rev__c ,Total_Revenue_GM_Rev__c ,Wt_Avg_Cogs_Bctpl_Rev__c ,Wt_Avg_Cogs_Others_Rev__c ,
                                               Wt_Avg_GM_Rev__c ,Overall_Revenue_Raw_Cogsbctpl__c ,Overall_Revenue_Raw_Cogsother__c ,Overall_Revenue_Raw_GM__c ,
                                               Overall_WtAvg_Cogsbctpl_Rev__c ,Overall_WtAvg_Cogsother_Rev__c ,Overall_WtAvg_GM_Rev__c,Actual_COGS_BCTPL__c ,
                                               Actual_COGS_Others__c ,Actual_GM__c,Total_Revenue_Raw_Fcst__c,
                                               Percentage__c FROM Revenue_Term__c WHERE Opportunity_line_item_id__c IN (SELECT id FROM Opportunity_Line_Item__c where Opportunity_ID__c IN :opId)];
        if(actualRevList.size() > 0)
        {
            for(Revenue_Term__c rev : actualRevList)
            {
                rev.Actual_Forecast_Rev__c = rev.Recognized_Amount__c==NULL?rev.Percentage__c:rev.Recognized_Amount__c;
                rev.Current_FY_Act_Fst_Raw_Rev__c = rev.Recognized_Amount__c==NULL?rev.Percentage__c:rev.Recognized_Amount__c; 
                rev.Total_Revenue_Cogsbctpl_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_Cogsbctpl__c:rev.Actual_COGS_BCTPL__c;
                rev.Total_Revenue_Cogsothers_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_Cogsother__c:rev.Actual_COGS_Others__c;
                rev.Total_Revenue_GM_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_GM__c:rev.Actual_GM__c;
                rev.Wt_Avg_Cogs_Bctpl_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_Cogsbctpl__c:rev.Actual_COGS_BCTPL__c;
                rev.Wt_Avg_Cogs_Others_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_Cogsother__c:rev.Actual_COGS_Others__c;
                rev.Wt_Avg_GM_Rev__c  = rev.Recognized_Amount__c==NULL?rev.Overall_Revenue_Raw_GM__c:rev.Actual_GM__c; 
                closedWonRevUpdateList.add(rev);
            }
        }
        if(closedWonRevUpdateList.size() > 0)
        {
            try
            {   
                update closedWonRevUpdateList; 
            }catch(Exception e)
            {  
                HandleCustomException.LogException(e); 
            }  
        }
    }  
    
    public static void updateOpportunityFields(Set<Id> oppId,List<Opportunity> newOppList,Map<Id, Opportunity> oppOldItems)
    {
        System.debug('Contact name update');
        List<OpportunityContactRole> oppConRole = [select ContactId,Contact.Name,OpportunityId from OpportunityContactRole where OpportunityId = :oppId and IsPrimary = TRUE];
        Set<Id> conId = new Set<Id>();
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        List<Opportunity_Line_Item__c> opLiUpdateList = new List<Opportunity_Line_Item__c>(); 
        List<Revenue_Term__c> revListUpdate = new List<Revenue_Term__c>();
        List<Billing_Term__c> billinListUpdate = new List<Billing_Term__c>();
        Integer revenueTermDays = 0;
     
        List<Opportunity_Line_Item__c> opLine = [SELECT Id,Opportunity_ID__c FROM Opportunity_Line_Item__c WHERE Opportunity_ID__c = :oppId];
        
        for(Opportunity_Line_Item__c opLi : opLine)
        { 
            for(OpportunityContactRole opRole : oppConRole)
            {
                if(opLi.Opportunity_ID__c == opRole.OpportunityId)
                {
                    opLi.Op_ContactName__c = opRole.Contact.Name;
                } 
            } 
            opLiUpdateList.add(opLi);
            System.debug('opp line item >>>'+opLiUpdateList.size());
        }
         
        for(Opportunity op : newOppList)
        {
            revenueTermDays=0;
            if(op.CloseDate != oppOldItems.get(op.Id).CloseDate)
            { 
                revenueTermDays = oppOldItems.get(op.Id).CloseDate.daysBetween(op.CloseDate); 
                System.debug('Date difference>>'+revenueTermDays);
                for(Opportunity_Line_Item__c ol : opLine)
                {
                    for(Revenue_Term__c re : [Select Id,Name, Revenue_date__c,amount__c,Change_Reason__c,revenue_term__c FROM Revenue_Term__c WHERE Opportunity_line_item_id__c = :ol.Id])
                    {
                        re.Revenue_Date__c = re.Revenue_date__c + revenueTermDays;
                        if(re.Change_Reason__c != Null)
                        {
                            re.Change_Reason__c = re.Change_Reason__c + '; Date shifted due to Opp.Close date changed from '+oppOldItems.get(op.Id).CloseDate +' To '+op.CloseDate;    
                        }
                        else
                        {
                            re.Change_Reason__c = 'Date shifted due to Opp.Close date changed from '+oppOldItems.get(op.Id).CloseDate +' To '+ op.CloseDate;    
                        }
                         revListUpdate.add(re);
                    }
                    
                    for(Billing_Term__c bT : [SELECT id,name, Billing_date__c,amount__c,Change_Reason__c,Billing_term__c FROM Billing_Term__c WHERE Opportunity_line_item_id__c = :ol.id])
                    {
                        bT.Billing_date__c = bT.Billing_Date__c + revenueTermDays;
                        if(bT.Change_Reason__c != null)
                        {
                            bT.Change_Reason__c = bT.Change_Reason__c+ '; Date shifted due to Opp.Close date changed from '+oppOldItems.get(op.Id).CloseDate +' To '+op.CloseDate;    
                        }
                        else
                        {
                            bT.Change_Reason__c = 'Date shifted due to Opp.Close date changed from '+oppOldItems.get(op.Id).CloseDate +' To '+op.CloseDate;    
                        }
                        billinListUpdate.add(bT);
                    }
                }
            } 
        }
        if(oppUpdateList.size() > 0)
        {
            try
            {   
                update oppUpdateList; 
            }catch(Exception e)
            {  
                System.debug('Line item >>>'+e.getMessage());
                HandleCustomException.LogException(e); 
            }  
        }
        if(opLiUpdateList.size() > 0)
        {
            try
            {   
                 update opLiUpdateList; 
            }catch(Exception e)
            {  
                HandleCustomException.LogException(e); 
            }  
        }
        if(revListUpdate.size() > 0)
        {
            try
            {   
                update revListUpdate; 
            }catch(Exception e)
            {  
                HandleCustomException.LogException(e); 
            }  
        }
        if(billinListUpdate.size() > 0)
        {
            try
            {   
                 update billinListUpdate; 
            }catch(Exception e)
            {  
                HandleCustomException.LogException(e); 
            }  
        }
    } 
}