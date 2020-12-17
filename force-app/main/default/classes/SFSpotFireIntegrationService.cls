@RestResource(URLMapping = '/sfspot/wonOppNPipelineaging/*')
global class SFSpotFireIntegrationService {

/*
 * This service returns Won opportunties report 
 * and Pipeline aging report from Opportunity object
 * 
 */    
  @HttpGet
  global static List<opportunity> getOpportunity() {
   // String dateStr = RestContext.request.params.get('lastModifiedDate');
   // Datetime lmdt = Datetime.parse(dateStr);
     Datetime reportLastExeDateTime ;
     Integer  reportNumber = Integer.valueOf(RestContext.request.params.get('reportNumber'));
      
      if( null != DateTime.valueOf(RestContext.request.params.get('reportLastExeDate'))){
            reportLastExeDateTime = DateTime.valueOf(RestContext.request.params.get('reportLastExeDate'));
      }
    	system.debug('Report Number : ' + reportNumber);
      	system.debug('reportLastExeDateTime  : ' + reportLastExeDateTime);
      if(reportNumber ==1 ){
          //Pipeline report
       List<Opportunity> oppDet = [Select ID, Name, CurrencyIsoCode, Owner_Full_Name__c, Funnel_Code__c, SBU__c, Opportunity_number_new__c, LeadSource, Type, Account_Name__c, StageName, Probability__c,	Total_Order_Value_Report__c, Total_COGS_BCTPL_Opp__c, Total_COGS_Others_Opp__c, Total_Gross_Margin__c , Current_FY_Revenue__c,	Next_FY_Revenue__c,	Current_FY_Wt_Revenue_del__c,	Next_FY_Wt_Revenue__c, createddate, Stage_Duration__c, Opportunity_Age__c, Last_Stage_Change_Date__c, Lastmodifieddate, ForecastCategoryName, CloseDate from Opportunity WHERE lastModifiedDate >: reportLastExeDateTime ];
	  	  return oppDet;
      }else if(reportNumber ==2){
          //Won opportunities
          List<Opportunity> wonOpps = [Select ID, Name, CurrencyIsoCode, SBU__c, stagename, Type, KeyOpportunity__c, Opportunity_number_new__c, Owner_Full_Name__c, Account_Name__c, LeadSource, Opportunity_Age__c, CloseDate, Total_Order_Value_Report__c, Total_COGS_BCTPL_Opp__c, Total_COGS_Others_Opp__c, Total_Gross_Margin__c, Current_FY_Cogs_Bctpl__c, Current_FY_Cogs_others__c,Current_FY_Gross_Margin__c,  Current_FY_Revenue__c, Next_FY_Revenue__c,CONTRACT_PO_NUMBER__c, CONTRACT_PO_SIGN_DATE__c from Opportunity WHERE StageName in ('PO Received','Closed Won') AND (CloseDate >= 2018-04-01 AND CloseDate <= 2019-03-31) AND lastModifiedDate >:reportLastExeDateTime];
		  return wonOpps;
      }
       
    return null; 
  }
}