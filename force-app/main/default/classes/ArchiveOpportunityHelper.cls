/**
* Class: ArchiveOpportunityHelper
*
* Author: Revathi Saminathan
*
* Date Created: 20.08.2020
*
* Purpose: The Opportunity helper class is responsible for making sure all of the applicable methods on your trigger invoke form this helper class.
* 
* Modified By: Revathi Saminathan
*
* Modified Date : 25.8.2020
*
* Purpose : Make it change for the batch class field update
*/
public class ArchiveOpportunityHelper {
    //variable declaration
    public static List<Archive_Opportunity__c> archiveOpp = new List<Archive_Opportunity__c>();
    public static List<Archive_Opportunity_Line_Item__c> archiveOppLineItem = new List<Archive_Opportunity_Line_Item__c>();
    public static List<Archive_Revenue_Term__c> archiveRevenueteam = new List<Archive_Revenue_Term__c>(); 
    
    public static void createMonthlyArchiveOpportunity(List<Opportunity> op1,
                                                       List<Opportunity_Line_Item__c>archiveOppLineItem,
                                                       List<Revenue_Term__c> archiveRevenueteam)
    {  
        for(Opportunity op : op1)
        {           
            Archive_Opportunity__c arcOpp = new Archive_Opportunity__c();
            arcOpp.Opportunity_Id__c = op.id;
            arcOpp.Opportunity_Related__c =op.id;
            arcOpp.Opportunity_Owner_Name__c = op.Owner_Full_Name__c;
            arcOpp.Opportunity_Owner_id__c = op.OwnerId;
            arcOpp.Opportunity_Name__c = op.Name;
            arcOpp.Account_Name__c = op.Account_Name__c;
            arcOpp.SBU__c = op.SBU__c;
            arcOpp.Opportunity_Number__c = op.Opportunity_number_new__c;
            arcOpp.Type__c = op.Type;
            arcOpp.Lead_Source__c = op.LeadSource;
            arcOpp.Primary_Campaign_Source__c = op.CampaignId;
            arcOpp.Opportunity_Description__c = op.Description;
            arcOpp.Next_Step__c = op.NextStep;
            arcOpp.Legal_Entity__c = op.Legal_Entity__c;
            arcopp.Opportunity_Category__c = op.Opportunity_Category__c;
            arcopp.Close_Date__c = op.CloseDate;
            arcopp.StageName__c = op.StageName;
            arcopp.Hold_Lost_Reason__c = op.Hold_Lost_Reason__c;
            arcopp.Hold_Lost_Description__c = op.Hold_Lost_Description__c;
            arcopp.Competitor_Lost_to__c = op.LOST_TO_COMPETITOR__c; 
            arcopp.Funnel_Code__c = op.Funnel_Code__c;
            arcopp.Probability__c = op.Probability__c;
            arcopp.Current_FY_Revenue__c = op.Current_FY_Act_Fst_Raw_Rev__c;
            arcopp.Current_FY_W_t_Revenue__c = op.Current_FY_Revenue__c;
            arcopp.Current_FY_CogsBctpl__c = op.Current_FY_Act_Fcst_Cogs_Bctpl__c;
            arcopp.Current_FY_W_t_Cogs_Bctpl__c = op.Current_FY_Cogs_Bctpl__c;
            arcopp.Current_FY_CogsOthers__c = op.Current_FY_Act_Fsct_CogsOthers__c;
            arcopp.Current_FY_W_t_Cogs_others__c = op.Current_FY_Cogs_others__c;
            arcopp.Current_FY_GM__c = op.Current_FY_Act_Fsct_GM__c;
            arcopp.Current_FY_W_t_GM__c = op.Current_FY_Gross_Margin__c;
            arcopp.Next_FY_Revenue__c = op.Next_FY_Act_Fsct_Revenue__c;
            arcopp.Next_FY_W_t_Revenue__c = op.Next_FY_Revenue__c;
            arcopp.Next_FY_Cogs_Bctpl__c = op.Next_FY_Act_Fcst_CogsBctpl__c;
            arcopp.Next_FY_W_t_Cogs_Bctpl__c = op.Next_FY_Cogs_Bctpl__c;
            arcopp.Next_FY_Cogs_Others__c = op.Next_FY_Act_Fcst_Cogs_Others__c;
            arcopp.Next_FY_W_t_Cogs_Others__c = op.Next_FY_Cogs_Others__c;
            arcopp.Next_FY_GM__c = op.Next_FY_Act_Fsct_GM__c;
            arcopp.Next_FY_W_t_GM__c = op.Next_FY_Gross_Margin__c;
            arcopp.Contract_PO_Sign_Date__c = op.CONTRACT_PO_SIGN_DATE__c;
            arcopp.Project_Start_Date__c = op.PROJECT_START_DATE__c;
            arcopp.Contract_PO__c = op.CONTRACT_PO_NUMBER__c;
            arcopp.Project_End_Date__c = op.PROJECT_END_DATE__c;
            arcopp.Project_Manager__c = op.Project_Manager__c;
            arcopp.Project_Completed__c = op.PROJECT_COMPLETED__c;
            arcopp.From_Stage__c = op.Last_StageName__c;
            arcopp.Project_Duration__c = op.Project_Duration__c;
            arcopp.Opportunity_Line_Order_value__c = op.Opportunity_Line_Order_value__c;
            arcopp.GM_OL__c = op.GEO_Margin__c;
            arcopp.Total_COGS_BCTPL_OL__c = op.Total_COGS_BCTPL_Opp__c;
            arcopp.GM_OL1__c = op.Total_GEO_Margin__c;
            arcopp.Total_COGS_Others_OL__c = op.Total_COGS_Others_Opp__c;
            arcopp.Total_Order_Value__c = op.Total_Order_Value_Report__c;
            arcopp.Opportunity_External_Id__c = op.Opportunity_number_new__c;
            arcopp.Archive_Opportunity_Snapshot__c =System.today();
            archiveOpp.add(arcopp);   
        }        
        if(archiveOpp.size() > 0)
        {
            try
            { 
                insert archiveOpp;
                createArchiveOpportunityLineItem(archiveOppLineItem,archiveOpp,archiveRevenueteam);
                
            }catch(Exception e)
            {
               HandleCustomException.LogException(e); 
            } 
        }
        
    }
    
    
    
    //create the new Archive Opportunity record when the Opportunity record is created or updated
    
    public static void createArchiveOpportunity(List<Opportunity> op1,
                                                List<Opportunity_Line_Item__c>archiveOppLineItem,
                                                List<Revenue_Term__c> archiveRevenueteam)
    {  
        for(Opportunity op : op1)
        {          
            DateTime myDateTime = op.createdDate;
            Date myDate = myDateTime.date();   
            if(myDate == System.Today())
            {  
                Archive_Opportunity__c arcOpp = new Archive_Opportunity__c();
                arcOpp.Opportunity_Id__c = op.id;
                arcOpp.Opportunity_Related__c =op.id;
                arcOpp.Opportunity_Owner_Name__c = op.Owner_Full_Name__c;
                arcOpp.Opportunity_Owner_id__c = op.OwnerId;
                arcOpp.Opportunity_Name__c = op.Name;
                arcOpp.Account_Name__c = op.Account_Name__c;
                arcOpp.SBU__c = op.SBU__c;
                arcOpp.Opportunity_Number__c = op.Opportunity_number_new__c;
                arcOpp.Type__c = op.Type;
                arcOpp.Lead_Source__c = op.LeadSource;
                arcOpp.Primary_Campaign_Source__c = op.CampaignId;
                arcOpp.Opportunity_Description__c = op.Description;
                arcOpp.Next_Step__c = op.NextStep;
                arcOpp.Legal_Entity__c = op.Legal_Entity__c;
                arcopp.Opportunity_Category__c = op.Opportunity_Category__c;
                arcopp.Close_Date__c = op.CloseDate;
                arcopp.StageName__c = op.StageName;
                arcopp.Hold_Lost_Reason__c = op.Hold_Lost_Reason__c;
                arcopp.Hold_Lost_Description__c = op.Hold_Lost_Description__c;
                arcopp.Competitor_Lost_to__c = op.LOST_TO_COMPETITOR__c; 
                arcopp.Funnel_Code__c = op.Funnel_Code__c;
                arcopp.Probability__c = op.Probability__c;
                arcopp.Current_FY_Revenue__c = op.Current_FY_Act_Fst_Raw_Rev__c;
                arcopp.Current_FY_W_t_Revenue__c = op.Current_FY_Revenue__c;
                arcopp.Current_FY_CogsBctpl__c = op.Current_FY_Act_Fcst_Cogs_Bctpl__c;
                arcopp.Current_FY_W_t_Cogs_Bctpl__c = op.Current_FY_Cogs_Bctpl__c;
                arcopp.Current_FY_CogsOthers__c = op.Current_FY_Act_Fsct_CogsOthers__c;
                arcopp.Current_FY_W_t_Cogs_others__c = op.Current_FY_Cogs_others__c;
                arcopp.Current_FY_GM__c = op.Current_FY_Act_Fsct_GM__c;
                arcopp.Current_FY_W_t_GM__c = op.Current_FY_Gross_Margin__c;
                arcopp.Next_FY_Revenue__c = op.Next_FY_Act_Fsct_Revenue__c;
                arcopp.Next_FY_W_t_Revenue__c = op.Next_FY_Revenue__c;
                arcopp.Next_FY_Cogs_Bctpl__c = op.Next_FY_Act_Fcst_CogsBctpl__c;
                arcopp.Next_FY_W_t_Cogs_Bctpl__c = op.Next_FY_Cogs_Bctpl__c;
                arcopp.Next_FY_Cogs_Others__c = op.Next_FY_Act_Fcst_Cogs_Others__c;
                arcopp.Next_FY_W_t_Cogs_Others__c = op.Next_FY_Cogs_Others__c;
                arcopp.Next_FY_GM__c = op.Next_FY_Act_Fsct_GM__c;
                arcopp.Next_FY_W_t_GM__c = op.Next_FY_Gross_Margin__c;
                arcopp.Contract_PO_Sign_Date__c = op.CONTRACT_PO_SIGN_DATE__c;
                arcopp.Project_Start_Date__c = op.PROJECT_START_DATE__c;
                arcopp.Contract_PO__c = op.CONTRACT_PO_NUMBER__c;
                arcopp.Project_End_Date__c = op.PROJECT_END_DATE__c;
                arcopp.Project_Manager__c = op.Project_Manager__c;
                arcopp.Project_Completed__c = op.PROJECT_COMPLETED__c;
                arcopp.From_Stage__c = op.Last_StageName__c;
                arcopp.Project_Duration__c = op.Project_Duration__c;
                arcopp.Opportunity_Line_Order_value__c = op.Opportunity_Line_Order_value__c;
                arcopp.GM_OL__c = op.GEO_Margin__c;
                arcopp.Total_COGS_BCTPL_OL__c = op.Total_COGS_BCTPL_Opp__c;
                arcopp.GM_OL1__c = op.Total_GEO_Margin__c;
                arcopp.Total_COGS_Others_OL__c = op.Total_COGS_Others_Opp__c;
                arcopp.Total_Order_Value__c = op.Total_Order_Value_Report__c;
                arcopp.Opportunity_External_Id__c = op.Opportunity_number_new__c;
                arcopp.Archive_Opportunity_Snapshot__c = System.today();
                archiveOpp.add(arcopp);   
            }     
        }
        if(archiveOpp.size() > 0)
        {
            try
            {
                //System.debug('archive Opp list >>'+archiveOpp.size());
                insert archiveOpp;
                createArchiveOpportunityLineItem(archiveOppLineItem,archiveOpp,archiveRevenueteam);
                
            }catch(Exception e)
            {
                HandleCustomException.LogException(e);
                System.debug('An unexpected error has occurred in Opportunity: ' + e.getMessage());
            } 
        }
    }
    
    //create the new Archive Opportunity line item record when the Opportunity line item record is created or updated
    public static void createArchiveOpportunityLineItem(List<Opportunity_Line_Item__c> opLine1,
                                                        List<Archive_Opportunity__c> opLine2,
                                                        List<Revenue_Term__c> revenueList)
    {
        System.debug('entry in create Opp line item>>>>');
        for(Opportunity_Line_Item__c opLine :opLine1)
        { 
            for(Archive_Opportunity__c opLin : opLine2)
            {
                if(opLine.Opportunity_ID__c == opLin.Opportunity_Id__c)
                {
                    if(opLin.Id != Null)
                    {  
                        Archive_Opportunity_Line_Item__c arOpLine = new Archive_Opportunity_Line_Item__c();
                        arOpLine.Balance_Amount_Billing__c = opLine.Billing_Term_Balance_amount__c;
                        arOpLine.Balance_Amount_Revenue__c = opLine.Revenue_Term_Balance_amount__c;
                        arOpLine.BCTPL_Rate_Card__c = opLine.BCTPL_Rate_Card__c;
                        arOpLine.BCT_Rate_Card__c = opLine.BCT_Rate_Card__c;
                        arOpLine.Business_Unit__c = opLine.Pillar__c;
                        arOpLine.Child_PID__c = opLine.Child_PID__c;
                        arOpLine.COGS_Bctpl_OL__c = opLine.COGS_BCTPL__c;
                        arOpLine.COGS_Bctpl_percentage_OL__c = opLine.Cogs_Bctpl_percentage__c;
                        arOpLine.COGS_Others_percentage_OL__c = opLine.COGS_Others_Percentage__c;
                        arOpLine.Competency_Product_Line__c = opLine.Competency__c;
                        arOpLine.Current_FY_CogsBctpl_OLI__c = opLine.Current_FY_CogsBctpl_OLI__c;
                        arOpLine.Current_FY_CogsOthers_OLI__c = opLine.Current_FY_CogsOthers_OLI__c;
                        arOpLine.Current_FY_GM_OLI__c = opLine.Current_FY_GM_OLI__c;
                        arOpLine.Current_FY_Revenue_OLI__c = opLine.Current_FY_Revenue_OLI__c;
                        arOpLine.Current_FY_Wt_Cogs_Bctpl_OLI__c = opLine.Current_FY_Wt_Cogs_Bctpl_OLI__c;
                        arOpLine.Current_FY_Wt_Cogs_others_OLI__c = opLine.Current_FY_Wt_Cogs_others_OLI__c;
                        arOpLine.Current_FY_Wt_GM_OLI__c = opLine.Current_FY_Wt_GM_OLI__c;
                        arOpLine.Current_FY_Wt_Revenue_OLI__c = opLine.Current_FY_W_t_Revenue_OLI__c;
                        arOpLine.Employee_ID__c = opLine.Employee_ID__c;
                        arOpLine.Employee_Name__c = opLine.Employee_Name__c;
                        arOpLine.Funnel_Code__c = opLine.Funnel_Code__c;
                        arOpLine.GM_percentage_OL__c = opLine.Total_GEO_Margin__c;
                        arOpLine.GM_OL__c = opLine.Geo_Margin__c;
                        arOpLine.Incentive_Qualifier__c = opLine.Incentive_Qualifier__c;
                        //arOpLine.Line_Item__c = opLine.Name;
                        arOpLine.Line_Item_Name__c = opLine.Name;
                        arOpLine.Nature_of_Project_Revenue_Stream__c = opLine.Revenue_Stream__c;
                        arOpLine.Next_FY_Cogs_Bctpl_OLI__c = opLine.Next_FY_Cogs_Bctpl_OLI__c;
                        arOpLine.Next_FY_Cogs_Others_OLI__c = opLine.Next_FY_Cogs_Others_OLI__c;
                        arOpLine.Next_FY_GM_OLI__c = opLine.Next_FY_GM_OLI__c;
                        arOpLine.Next_FY_Revenue_OLI__c = opLine.Next_FY_Revenue_OLI__c;
                        arOpLine.Next_FY_Wt_Revenue__c = opLine.Next_FY_Revenue__c;
                        arOpLine.Next_FY_Wt_Cogs_Bctpl_OLI__c = opLine.Next_FY_Wt_Cogs_Bctpl_OLI__c;
                        arOpLine.Next_FY_Wt_Cogs_Others_OLI__c = opLine.Next_FY_Wt_Cogs_Others_OLI__c;
                        arOpLine.Next_FY_Wt_GM_OLI__c = opLine.Next_FY_Wt_GM_OLI__c;
                        arOpLine.Next_FY_Wt_Revenue_OLI__c = opLine.Next_FY_W_t_Revenue_OLI__c;
                        arOpLine.Opp_Line_Id__c = opLine.Id;
                        arOpLine.Opportunity_Id__c = opLine.Opportunity_ID__c;
                        arOpLine.Opportunity_Name__c = opLine.Opportunity_ID__r.Name;
                        arOpLine.Prev_FY_Revenue__c = opLine.Prev_FY_Revenue__c;
                        arOpLine.Project_Delivery_Model__c = opLine.Project_Category__c;
                        arOpLine.Project_ID__c = opLine.Project_ID__c;
                        arOpLine.Project_Type__c = opLine.Project_Type__c;
                        arOpLine.RecognisedAmountSummary__c = opLine.RecognisedAmountSummary__c;
                        arOpLine.Technologies__c = opLine.Product__c;
                        arOpLine.Total_Value_OL__c = opLine.Total_Value__c;    
                        arOpLine.Archive_Opportunity_line_item_Snapshot__c = System.today();
                        arOpLine.Archive_Opportunity_Id__c = opLin.Id;            
                        archiveOppLineItem.add(arOpLine); 
                    }
                }
            }
        }
        
        if(archiveOppLineItem.size() > 0)
        {
            try
            { 
                //System.debug('archive Opp line item list >>'+archiveOppLineItem.size());
                insert archiveOppLineItem;
                if(revenueList.size() > 0 && archiveOppLineItem.size() > 0)
                {  
                    //System.debug('Revenue Size'+revenueList.size());
                    createArchiveRevenueSplit(revenueList,archiveOppLineItem); 
                }
            }catch(Exception e)
            {
                HandleCustomException.LogException(e);
                System.debug('An unexpected error has occurred in Opportunity Line item: ' + e.getMessage());
            }  
        }
        
    }
    //create the new Archive Revenue Term record when the  Revenue split record is created or updated
    public static void createArchiveRevenueSplit(List<Revenue_Term__c> revTeam1,
                                                 List<Archive_Opportunity_Line_Item__c> archiveOppLineItem)
    { 
        for(Revenue_Term__c revTeam :revTeam1)
        {
            for(Archive_Opportunity_Line_Item__c arLi : archiveOppLineItem)
            { 
                if(revTeam.Opportunity_line_item_id__c == arLi.Opp_Line_Id__c)
                {
                    if(arLi.Id != Null)
                    { 
                        Archive_Revenue_Term__c aRT =  new Archive_Revenue_Term__c();
                        aRT.Actual_COGS_BCTPL__c = revTeam.Actual_COGS_BCTPL__c;
                        aRT.Actual_COGS_Others__c = revTeam.Actual_COGS_Others__c;
                        aRT.Actual_GM__c = revTeam.Actual_GM__c;
                        aRT.Actual_Revenue__c = revTeam.Recognized_Amount__c;
                        aRT.Business_Category_Revenue__c = revTeam.Business_Category_Revenue__c;
                        aRT.Change_Reason__c = revTeam.Change_Reason__c;
                        aRT.Total_GEO_Margin__c = revTeam.Total_GEO_Margin__c;
                        aRT.Gross_Margin_Rev__c = revTeam.Geo_Margin__c;
                        aRT.Milestone__c = revTeam.Milestone__c;
                        aRT.Milestone_Amount_Percentage__c = revTeam.Percentage__c;
                        aRT.Milestone_Basis__c = revTeam.Milestone_Basis__c;
                        aRT.Opp_Line_Id__c = revTeam.Opportunity_line_item_id__c;
                        aRT.Opportunity_Id__c = revTeam.Opportunity_line_item_id__r.Opportunity_ID__c;
                        aRT.Overall_COE_Revenue__c = revTeam.Overall_COE_Revenue__c;
                        aRT.Overall_Revenue__c = revTeam.Overall_Revenue__c;
                        aRT.Product_Type_Rev__c = revTeam.Product_Type_Rev__c;
                        aRT.Revenue_Date__c = revTeam.Revenue_Date__c;
                        aRT.Revenue_Name__c = revTeam.Name;
                        aRT.Revenue_Term__c = revTeam.Revenue_Term__c;
                        aRT.Shift_Subsequent_Revenue_Dates__c = revTeam.Shift_Subsequent_Revenue_Dates__c;
                        aRT.Total_Amount__c = revTeam.Amount__c;
                        aRT.Total_COGS_BCTPL_Rev__c = revTeam.Total_COGS_BCTPL_Rev__c;
                        aRT.Total_COGS_Others_Rev__c = revTeam.Total_COGS_Others_Rev__c;
                        aRT.Overall_Revenue_Raw_Cogsother__c = revTeam.Overall_Revenue_Raw_Cogsother__c;
                        aRT.Overall_Revenue_Raw_GM__c = revTeam.Overall_Revenue_Raw_GM__c;
                        aRT.W_Avg_Cogs_Bctpl_Revenue__c = revTeam.W_Avg_Cogs_Bctpl_Revenue__c;
                        aRT.W_Avg_Cogs_Others_Revenue__c = revTeam.W_Avg_Cogs_Others_Revenue__c;
                        aRT.W_Avg_GM_Revenue__c = revTeam.W_Avg_GM_Revenue__c;
                        aRT.W_Avg_Total_Revenue__c = revTeam.W_Avg_Total_Revenue__c;
                        aRT.Archive_Revenue_Split_Snapshot__c = System.today();
                        aRT.Archive_Opportunity_Line_Item_Id__c = arLi.Id; 
                        aRT.Actual_Forecast__c =revTeam.Actual_Forecast__c;  
                        aRT.Actual_Forecast_Rev__c = revTeam.Actual_Forecast_Rev__c;  
                        aRT.Current_FY_Act_Fst_Raw_Rev__c = revTeam.Current_FY_Act_Fst_Raw_Rev__c;  
                        aRT.Total_Revenue_Cogsbctpl_Rev__c = revTeam.Total_Revenue_Cogsbctpl_Rev__c;  
                        aRT.Total_Revenue_Cogsothers_Rev__c = revTeam.Total_Revenue_Cogsothers_Rev__c;  
                        aRT.Total_Revenue_GM_Rev__c = revTeam.Total_Revenue_GM_Rev__c;    
                        aRT.Wt_Avg_Cogs_Bctpl_Rev__c = revTeam.Wt_Avg_Cogs_Bctpl_Rev__c;  
                        aRT.Wt_Avg_Cogs_Others_Rev__c = revTeam.Wt_Avg_Cogs_Others_Rev__c;  
                        aRT.Wt_Avg_GM_Rev__c = revTeam.Wt_Avg_GM_Rev__c;  
                        archiveRevenueteam.add(aRT); 
                    } 
                }
            }
        }
        if(archiveRevenueteam.size() > 0)
        {
            try
            { 
                //System.debug('archive revenue list >>'+archiveRevenueteam.size());
                insert archiveRevenueteam; 
            }catch(Exception e)
            {
                 HandleCustomException.LogException(e);
                 System.debug('An unexpected error has occurred in Revenue Split: ' + e.getMessage());
            } 
        } 
    }
    
    //When the Opportunity is Modified and related Archive Opportunity update
    public static void updateArchiveOpportunity(List<Opportunity> opList,
                                                List<Archive_Opportunity__c> archiveOppList)
    {
        List<Archive_Opportunity__c> updateArchList = new List<Archive_Opportunity__c>();
        if(opList.size()>0 && archiveOppList.size()>0)
        {
            for(Opportunity op : opList)
            {
                for(Archive_Opportunity__c arcOpp : archiveOppList)
                {
                    if(op.Id == arcOpp.Opportunity_Related__c)
                    { 
                        if(arcOpp.Id != Null)
                        { 
                            arcOpp.Opportunity_Id__c = op.id;
                            arcOpp.Opportunity_Related__c =op.id;
                            arcOpp.Opportunity_Owner_Name__c = op.Owner_Full_Name__c;
                            arcOpp.Opportunity_Owner_id__c = op.OwnerId;
                            arcOpp.Opportunity_Name__c = op.Name;
                            arcOpp.Account_Name__c = op.Account_Name__c;
                            arcOpp.SBU__c = op.SBU__c;
                            arcOpp.Opportunity_Number__c = op.Opportunity_number_new__c;
                            arcOpp.Type__c = op.Type;
                            arcOpp.Lead_Source__c = op.LeadSource;
                            arcOpp.Primary_Campaign_Source__c = op.CampaignId;
                            arcOpp.Opportunity_Description__c = op.Description;
                            arcOpp.Next_Step__c = op.NextStep;
                            arcOpp.Legal_Entity__c = op.Legal_Entity__c;
                            arcopp.Opportunity_Category__c = op.Opportunity_Category__c;
                            arcopp.Close_Date__c = op.CloseDate;
                            arcopp.StageName__c = op.StageName;
                            arcopp.Hold_Lost_Reason__c = op.Hold_Lost_Reason__c;
                            arcopp.Hold_Lost_Description__c = op.Hold_Lost_Description__c;
                            arcopp.Competitor_Lost_to__c = op.LOST_TO_COMPETITOR__c; 
                            arcopp.Funnel_Code__c = op.Funnel_Code__c;
                            arcopp.Probability__c = op.Probability__c;
                            arcopp.Current_FY_Revenue__c = op.Current_FY_Act_Fst_Raw_Rev__c;
                            arcopp.Current_FY_W_t_Revenue__c = op.Current_FY_Revenue__c;
                            arcopp.Current_FY_CogsBctpl__c = op.Current_FY_Act_Fcst_Cogs_Bctpl__c;
                            arcopp.Current_FY_W_t_Cogs_Bctpl__c = op.Current_FY_Cogs_Bctpl__c;
                            arcopp.Current_FY_CogsOthers__c = op.Current_FY_Act_Fsct_CogsOthers__c;
                            arcopp.Current_FY_W_t_Cogs_others__c = op.Current_FY_Cogs_others__c;
                            arcopp.Current_FY_GM__c = op.Current_FY_Act_Fsct_GM__c;
                            arcopp.Current_FY_W_t_GM__c = op.Current_FY_Gross_Margin__c;
                            arcopp.Next_FY_Revenue__c = op.Next_FY_Act_Fsct_Revenue__c;
                            arcopp.Next_FY_W_t_Revenue__c = op.Next_FY_Revenue__c;
                            arcopp.Next_FY_Cogs_Bctpl__c = op.Next_FY_Act_Fcst_CogsBctpl__c;
                            arcopp.Next_FY_W_t_Cogs_Bctpl__c = op.Next_FY_Cogs_Bctpl__c;
                            arcopp.Next_FY_Cogs_Others__c = op.Next_FY_Act_Fcst_Cogs_Others__c;
                            arcopp.Next_FY_W_t_Cogs_Others__c = op.Next_FY_Cogs_Others__c;
                            arcopp.Next_FY_GM__c = op.Next_FY_Act_Fsct_GM__c;
                            arcopp.Next_FY_W_t_GM__c = op.Next_FY_Gross_Margin__c;
                            arcopp.Contract_PO_Sign_Date__c = op.CONTRACT_PO_SIGN_DATE__c;
                            arcopp.Project_Start_Date__c = op.PROJECT_START_DATE__c;
                            arcopp.Contract_PO__c = op.CONTRACT_PO_NUMBER__c;
                            arcopp.Project_End_Date__c = op.PROJECT_END_DATE__c;
                            arcopp.Project_Manager__c = op.Project_Manager__c;
                            arcopp.Project_Completed__c = op.PROJECT_COMPLETED__c;
                            arcopp.From_Stage__c = op.Last_StageName__c;
                            arcopp.Project_Duration__c = op.Project_Duration__c;
                            arcopp.Opportunity_Line_Order_value__c = op.Opportunity_Line_Order_value__c;
                            arcopp.GM_OL__c = op.GEO_Margin__c;
                            arcopp.Total_COGS_BCTPL_OL__c = op.Total_COGS_BCTPL_Opp__c;
                            arcopp.GM_OL1__c = op.Total_GEO_Margin__c;
                            arcopp.Total_COGS_Others_OL__c = op.Total_COGS_Others_Opp__c;
                            arcopp.Total_Order_Value__c = op.Total_Order_Value_Report__c; 
                            arcopp.Archive_Opportunity_Snapshot__c =System.today();                   
                            updateArchList.add(arcopp);
                        }
                    }
                }
            }
            if(updateArchList.size() > 0)
            {
                try
                { 
                    update updateArchList; 
                }
                catch(Exception e)
                { 
                    HandleCustomException.LogException(e);
                    //System.debug('An unexpected error has occurred in Revenue Split: ' + e.getMessage());
                }
            }
        }
        
    }
    
    // when the Opportunity line item is modified, updating the respective Archive Opportunity line item record 
    public static void updateArchiveOpportunityLineItem(List<Opportunity_Line_Item__c> opLineItemlist,
                                                        List<Archive_Opportunity_Line_Item__c> arcOppLineItemList)
    { 
        List<Archive_Opportunity_Line_Item__c> archList = new List<Archive_Opportunity_Line_Item__c>();
        
        if(opLineItemlist.size()>0 && arcOppLineItemList.size()>0)
        {
            for(Opportunity_Line_Item__c opLine : opLineItemlist)
            {
                for(Archive_Opportunity_Line_Item__c arOpLine : arcOppLineItemList)
                {  
                    if(opLine.Name == arOpLine.Line_Item_Name__c)
                    {
                        if(arOpLine.Id != Null)
                        {
                            arOpLine.Balance_Amount_Billing__c = opLine.Billing_Term_Balance_amount__c;
                            arOpLine.Balance_Amount_Revenue__c = opLine.Revenue_Term_Balance_amount__c;
                            arOpLine.BCTPL_Rate_Card__c = opLine.BCTPL_Rate_Card__c;
                            arOpLine.BCT_Rate_Card__c = opLine.BCT_Rate_Card__c;
                            arOpLine.Business_Unit__c = opLine.Pillar__c;
                            arOpLine.Child_PID__c = opLine.Child_PID__c;
                            arOpLine.COGS_Bctpl_OL__c = opLine.COGS_BCTPL__c;
                            arOpLine.COGS_Bctpl_percentage_OL__c = opLine.Cogs_Bctpl_percentage__c;
                            arOpLine.COGS_Others_percentage_OL__c = opLine.COGS_Others_Percentage__c;
                            arOpLine.Competency_Product_Line__c = opLine.Competency__c;
                            arOpLine.Current_FY_CogsBctpl_OLI__c = opLine.Current_FY_CogsBctpl_OLI__c;
                            arOpLine.Current_FY_CogsOthers_OLI__c = opLine.Current_FY_CogsOthers_OLI__c;
                            arOpLine.Current_FY_GM_OLI__c = opLine.Current_FY_GM_OLI__c;
                            arOpLine.Current_FY_Revenue_OLI__c = opLine.Current_FY_Revenue_OLI__c;
                            arOpLine.Current_FY_Wt_Cogs_Bctpl_OLI__c = opLine.Current_FY_Wt_Cogs_Bctpl_OLI__c;
                            arOpLine.Current_FY_Wt_Cogs_others_OLI__c = opLine.Current_FY_Wt_Cogs_others_OLI__c;
                            arOpLine.Current_FY_Wt_GM_OLI__c = opLine.Current_FY_Wt_GM_OLI__c;
                            arOpLine.Current_FY_Wt_Revenue_OLI__c = opLine.Current_FY_W_t_Revenue_OLI__c;
                            arOpLine.Employee_ID__c = opLine.Employee_ID__c;
                            arOpLine.Employee_Name__c = opLine.Employee_Name__c;
                            arOpLine.Funnel_Code__c = opLine.Funnel_Code__c;
                            arOpLine.GM_percentage_OL__c = opLine.Total_GEO_Margin__c;
                            arOpLine.GM_OL__c = opLine.Geo_Margin__c;
                            arOpLine.Incentive_Qualifier__c = opLine.Incentive_Qualifier__c; 
                            arOpLine.Line_Item_Name__c = opLine.Name;
                            arOpLine.Nature_of_Project_Revenue_Stream__c = opLine.Revenue_Stream__c;
                            arOpLine.Next_FY_Cogs_Bctpl_OLI__c = opLine.Next_FY_Cogs_Bctpl_OLI__c;
                            arOpLine.Next_FY_Cogs_Others_OLI__c = opLine.Next_FY_Cogs_Others_OLI__c;
                            arOpLine.Next_FY_GM_OLI__c = opLine.Next_FY_GM_OLI__c;
                            arOpLine.Next_FY_Revenue_OLI__c = opLine.Next_FY_Revenue_OLI__c;
                            arOpLine.Next_FY_Wt_Revenue__c = opLine.Next_FY_Revenue__c;
                            arOpLine.Next_FY_Wt_Cogs_Bctpl_OLI__c = opLine.Next_FY_Wt_Cogs_Bctpl_OLI__c;
                            arOpLine.Next_FY_Wt_Cogs_Others_OLI__c = opLine.Next_FY_Wt_Cogs_Others_OLI__c;
                            arOpLine.Next_FY_Wt_GM_OLI__c = opLine.Next_FY_Wt_GM_OLI__c;
                            arOpLine.Next_FY_Wt_Revenue_OLI__c = opLine.Next_FY_W_t_Revenue_OLI__c;
                            arOpLine.Opp_Line_Id__c = opLine.Id;
                            arOpLine.Opportunity_Id__c = opLine.Opportunity_ID__c;
                            arOpLine.Opportunity_Name__c = opLine.Opportunity_ID__r.Name;
                            arOpLine.Prev_FY_Revenue__c = opLine.Prev_FY_Revenue__c;
                            arOpLine.Project_Delivery_Model__c = opLine.Project_Category__c;
                            arOpLine.Project_ID__c = opLine.Project_ID__c;
                            arOpLine.Project_Type__c = opLine.Project_Type__c;
                            arOpLine.RecognisedAmountSummary__c = opLine.RecognisedAmountSummary__c;
                            arOpLine.Technologies__c = opLine.Product__c;
                            arOpLine.Total_Value_OL__c = opLine.Total_Value__c;    
                            arOpLine.Archive_Opportunity_line_item_Snapshot__c = System.today(); 
                            archList.add(arOpLine);
                        }
                    }
                }
            }
            if(archList.size() > 0)
            {
                try
                {
                    update archList;
                }
                catch(Exception e)
                {  
                    HandleCustomException.LogException(e);
                    // System.debug('An unexpected error has occurred in Revenue Split: ' + e.getMessage());
                } 
            }
            
        }
    }
    
    public static void updateArchiveRevenueTermRecord(List<Revenue_Term__c> revlist,
                                                      List<Archive_Revenue_Term__c> arcRevList)
    {
        List<Archive_Revenue_Term__c> archRevUpdateList = new List<Archive_Revenue_Term__c>();
        
        if(revlist.size() > 0 && arcRevList.size() > 0)
        {
            for(Revenue_Term__c revTeam : revlist)
            {
                for(Archive_Revenue_Term__c aRT : arcRevList)
                {
                    if(revTeam.Name == aRT.Revenue_Name__c)
                    {
                        if(aRT.Id != Null)
                        {
                            aRT.Actual_COGS_BCTPL__c = revTeam.Actual_COGS_BCTPL__c;
                            aRT.Actual_COGS_Others__c = revTeam.Actual_COGS_Others__c;
                            aRT.Actual_GM__c = revTeam.Actual_GM__c;
                            aRT.Actual_Revenue__c = revTeam.Recognized_Amount__c;
                            aRT.Business_Category_Revenue__c = revTeam.Business_Category_Revenue__c;
                            aRT.Change_Reason__c = revTeam.Change_Reason__c;
                            aRT.Total_GEO_Margin__c = revTeam.Total_GEO_Margin__c;
                            aRT.Gross_Margin_Rev__c = revTeam.Geo_Margin__c;
                            aRT.Milestone__c = revTeam.Milestone__c;
                            aRT.Milestone_Amount_Percentage__c = revTeam.Percentage__c;
                            aRT.Milestone_Basis__c = revTeam.Milestone_Basis__c;
                            aRT.Opp_Line_Id__c = revTeam.Opportunity_line_item_id__c;
                            aRT.Opportunity_Id__c = revTeam.Opportunity_line_item_id__r.Opportunity_ID__c;
                            aRT.Overall_COE_Revenue__c = revTeam.Overall_COE_Revenue__c;
                            aRT.Overall_Revenue__c = revTeam.Overall_Revenue__c;
                            aRT.Product_Type_Rev__c = revTeam.Product_Type_Rev__c;
                            aRT.Revenue_Date__c = revTeam.Revenue_Date__c;
                            aRT.Revenue_Name__c = revTeam.Name;
                            aRT.Revenue_Term__c = revTeam.Revenue_Term__c;
                            aRT.Shift_Subsequent_Revenue_Dates__c = revTeam.Shift_Subsequent_Revenue_Dates__c;
                            aRT.Total_Amount__c = revTeam.Amount__c;
                            aRT.Total_COGS_BCTPL_Rev__c = revTeam.Total_COGS_BCTPL_Rev__c;
                            aRT.Total_COGS_Others_Rev__c = revTeam.Total_COGS_Others_Rev__c;
                            aRT.Overall_Revenue_Raw_Cogsother__c = revTeam.Overall_Revenue_Raw_Cogsother__c;
                            aRT.Overall_Revenue_Raw_GM__c = revTeam.Overall_Revenue_Raw_GM__c;
                            aRT.W_Avg_Cogs_Bctpl_Revenue__c = revTeam.W_Avg_Cogs_Bctpl_Revenue__c;
                            aRT.W_Avg_Cogs_Others_Revenue__c = revTeam.W_Avg_Cogs_Others_Revenue__c;
                            aRT.W_Avg_GM_Revenue__c = revTeam.W_Avg_GM_Revenue__c;
                            aRT.W_Avg_Total_Revenue__c = revTeam.W_Avg_Total_Revenue__c; 
                            aRT.Archive_Revenue_Split_Snapshot__c = System.today(); 
                            aRT.Actual_Forecast__c =revTeam.Actual_Forecast__c;  
                            aRT.Actual_Forecast_Rev__c = revTeam.Actual_Forecast_Rev__c;  
                            aRT.Current_FY_Act_Fst_Raw_Rev__c = revTeam.Current_FY_Act_Fst_Raw_Rev__c;  
                            aRT.Total_Revenue_Cogsbctpl_Rev__c = revTeam.Total_Revenue_Cogsbctpl_Rev__c;  
                            aRT.Total_Revenue_Cogsothers_Rev__c = revTeam.Total_Revenue_Cogsothers_Rev__c;  
                            aRT.Total_Revenue_GM_Rev__c = revTeam.Total_Revenue_GM_Rev__c;    
                            aRT.Wt_Avg_Cogs_Bctpl_Rev__c = revTeam.Wt_Avg_Cogs_Bctpl_Rev__c;  
                            aRT.Wt_Avg_Cogs_Others_Rev__c = revTeam.Wt_Avg_Cogs_Others_Rev__c;  
                            aRT.Wt_Avg_GM_Rev__c = revTeam.Wt_Avg_GM_Rev__c;   
                            archRevUpdateList.add(aRT);
                        }
                    }
                }
            }
            if(archRevUpdateList.size() > 0){
                try
                { 
                    update archRevUpdateList;
                }
                catch(Exception e)
                { 
                    HandleCustomException.LogException(e);
                    //  System.debug('An unexpected error has occurred in Revenue Split: ' + e.getMessage());
                } 
            }
        }
    }
    public static void createSingleArchiveOpportunity(List<Opportunity> op1)
    {  
        for(Opportunity op : op1)
        {          
            DateTime myDateTime = op.createdDate;
            Date myDate = myDateTime.date();   
            if(myDate == System.Today())
            {  
                Archive_Opportunity__c arcOpp = new Archive_Opportunity__c();
                arcOpp.Opportunity_Id__c = op.id;
                arcOpp.Opportunity_Related__c =op.id;
                arcOpp.Opportunity_Owner_Name__c = op.Owner_Full_Name__c;
                arcOpp.Opportunity_Owner_id__c = op.OwnerId;
                arcOpp.Opportunity_Name__c = op.Name;
                arcOpp.Account_Name__c = op.Account_Name__c;
                arcOpp.SBU__c = op.SBU__c;
                arcOpp.Opportunity_Number__c = op.Opportunity_number_new__c;
                arcOpp.Type__c = op.Type;
                arcOpp.Lead_Source__c = op.LeadSource;
                arcOpp.Primary_Campaign_Source__c = op.CampaignId;
                arcOpp.Opportunity_Description__c = op.Description;
                arcOpp.Next_Step__c = op.NextStep;
                arcOpp.Legal_Entity__c = op.Legal_Entity__c;
                arcopp.Opportunity_Category__c = op.Opportunity_Category__c;
                arcopp.Close_Date__c = op.CloseDate;
                arcopp.StageName__c = op.StageName;
                arcopp.Hold_Lost_Reason__c = op.Hold_Lost_Reason__c;
                arcopp.Hold_Lost_Description__c = op.Hold_Lost_Description__c;
                arcopp.Competitor_Lost_to__c = op.LOST_TO_COMPETITOR__c; 
                arcopp.Funnel_Code__c = op.Funnel_Code__c;
                arcopp.Probability__c = op.Probability__c;
                arcopp.Current_FY_Revenue__c = op.Current_FY_Act_Fst_Raw_Rev__c;
                arcopp.Current_FY_W_t_Revenue__c = op.Current_FY_Revenue__c;
                arcopp.Current_FY_CogsBctpl__c = op.Current_FY_Act_Fcst_Cogs_Bctpl__c;
                arcopp.Current_FY_W_t_Cogs_Bctpl__c = op.Current_FY_Cogs_Bctpl__c;
                arcopp.Current_FY_CogsOthers__c = op.Current_FY_Act_Fsct_CogsOthers__c;
                arcopp.Current_FY_W_t_Cogs_others__c = op.Current_FY_Cogs_others__c;
                arcopp.Current_FY_GM__c = op.Current_FY_Act_Fsct_GM__c;
                arcopp.Current_FY_W_t_GM__c = op.Current_FY_Gross_Margin__c;
                arcopp.Next_FY_Revenue__c = op.Next_FY_Act_Fsct_Revenue__c;
                arcopp.Next_FY_W_t_Revenue__c = op.Next_FY_Revenue__c;
                arcopp.Next_FY_Cogs_Bctpl__c = op.Next_FY_Act_Fcst_CogsBctpl__c;
                arcopp.Next_FY_W_t_Cogs_Bctpl__c = op.Next_FY_Cogs_Bctpl__c;
                arcopp.Next_FY_Cogs_Others__c = op.Next_FY_Act_Fcst_Cogs_Others__c;
                arcopp.Next_FY_W_t_Cogs_Others__c = op.Next_FY_Cogs_Others__c;
                arcopp.Next_FY_GM__c = op.Next_FY_Act_Fsct_GM__c;
                arcopp.Next_FY_W_t_GM__c = op.Next_FY_Gross_Margin__c;
                arcopp.Contract_PO_Sign_Date__c = op.CONTRACT_PO_SIGN_DATE__c;
                arcopp.Project_Start_Date__c = op.PROJECT_START_DATE__c;
                arcopp.Contract_PO__c = op.CONTRACT_PO_NUMBER__c;
                arcopp.Project_End_Date__c = op.PROJECT_END_DATE__c;
                arcopp.Project_Manager__c = op.Project_Manager__c;
                arcopp.Project_Completed__c = op.PROJECT_COMPLETED__c;
                arcopp.From_Stage__c = op.Last_StageName__c;
                arcopp.Project_Duration__c = op.Project_Duration__c;
                arcopp.Opportunity_Line_Order_value__c = op.Opportunity_Line_Order_value__c;
                arcopp.GM_OL__c = op.GEO_Margin__c;
                arcopp.Total_COGS_BCTPL_OL__c = op.Total_COGS_BCTPL_Opp__c;
                arcopp.GM_OL1__c = op.Total_GEO_Margin__c;
                arcopp.Total_COGS_Others_OL__c = op.Total_COGS_Others_Opp__c;
                arcopp.Total_Order_Value__c = op.Total_Order_Value_Report__c;
                arcopp.Opportunity_External_Id__c = op.Opportunity_number_new__c;
                arcopp.Archive_Opportunity_Snapshot__c = System.today();
                archiveOpp.add(arcopp);   
            }        
            if(archiveOpp.size() > 0)
            {
                try
                { 
                    insert archiveOpp; 
                    
                }catch(Exception e)
                {
                    HandleCustomException.LogException(e);
                    System.debug('An unexpected error has occurred in Opportunity: ' + e.getMessage());
                } 
            }
            
        }
    }    
}