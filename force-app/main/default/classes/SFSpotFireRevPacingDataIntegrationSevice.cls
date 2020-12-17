@RestResource(URLMapping = '/sfspot/revPacing/*')
global class SFSpotFireRevPacingDataIntegrationSevice {
    
    
/*
 * This service returns revenue pacing report 
 * for 2018 and 2019 FY from Revenue Term object
 * 
 */    
  @HttpGet
  global static List<Revenue_term__c> getRevenuePacingReport() {
   // String dateStr = RestContext.request.params.get('lastModifiedDate');
   // Datetime lmdt = Datetime.parse(dateStr);
    Datetime reportLastExeDateTime ;
     Integer  reportNumber = Integer.valueOf(RestContext.request.params.get('reportNumber'));
      if( null != DateTime.valueOf(RestContext.request.params.get('reportLastExeDate'))){
            reportLastExeDateTime = DateTime.valueOf(RestContext.request.params.get('reportLastExeDate'));
      }
    
      if(reportNumber == 3){
          //Revenue Pacing report for 2018 and 2019 FY
        List<REVENUE_TERM__c> revDetails = [SELECT Id, Opportunity_line_item_id__r.Opportunity_ID__r.Opportunity_number_new__c, Opportunity_line_item_id__r.Opportunity_ID__r.SBU__c, CurrencyIsoCode,	Opportunity_line_item_id__r.Opportunity_ID__r.Owner_Full_Name__c, Opportunity_line_item_id__r.Opportunity_ID__r.Account_Name__c, Opportunity_line_item_id__r.Opportunity_ID__r.Name, Opportunity_line_item_id__r.Opportunity_ID__r.type,	Opportunity_line_item_id__r.Opportunity_ID__r.StageName, Opportunity_line_item_id__r.Opportunity_ID__r.KeyOpportunity__c, Opportunity_line_item_id__r.Incentive_Qualifier__c, Opportunity_line_item_id__r.Opportunity_ID__r.createdDate, Opportunity_line_item_id__r.Opportunity_ID__r.Last_Stage_Change_Date__c, Funnel_Code_Rev__c, Opportunity_line_item_id__r.Opportunity_ID__r.Probability__c, Opp_Close_Date__c, Opportunity_line_item_id__r.Project_ID__c, Opportunity_line_item_id__r.Pillar__c, Opportunity_line_item_id__r.Competency__c, Opportunity_line_item_id__r.Product__c, Opportunity_line_item_id__r.Project_Category__c, Opportunity_line_item_id__r.Practice__c, Milestone__c, Opportunity_line_item_id__r.Revenue_Stream__c, Opportunity_line_item_id__r.Opportunity_ID__r.Total_Order_Value_Report__c, Opportunity_line_item_id__r.Opportunity_ID__r.Total_COGS_BCTPL_Opp__c, Opportunity_line_item_id__r.Opportunity_ID__r.Total_COGS_Others_Opp__c, Opportunity_line_item_id__r.Opportunity_ID__r.Total_Gross_Margin__c, Total_Revenue__c, Overall_Revenue_Raw_Cogsbctpl__c, Overall_Revenue_Raw_Cogsother__c, Total_Revenue_GM__c, W_Avg_Total_Revenue__c, W_Avg_Cogs_Bctpl_Revenue__c, W_Avg_Cogs_Others_Revenue__c, W_Avg_GM_Revenue__c, Opportunity_line_item_id__r.employee_name__c, revenue_date__c,Opportunity_line_item_id__r.Opportunity_ID__r.CONTRACT_PO_NUMBER__c, Opportunity_line_item_id__r.Opportunity_ID__r.CONTRACT_PO_SIGN_DATE__c, Opportunity_line_item_id__r.Opportunity_ID__r.PROJECT_START_DATE__c, Opportunity_line_item_id__r.Opportunity_ID__r.PROJECT_END_DATE__c,	Opportunity_line_item_id__r.Opportunity_ID__r.Hold_Reason__c, Opportunity_line_item_id__r.Opportunity_ID__r.Lost_Reason__c  FROM REVENUE_TERM__c WHERE (REVENUE_DATE__c >= 2018-04-01 AND REVENUE_DATE__c <= 2020-03-31) AND lastModifiedDate > :reportLastExeDateTime];
          //system.debug('Revenue details : ' + revDetails );
           return revDetails;
      }
       
    return null; 
  }
    	

}