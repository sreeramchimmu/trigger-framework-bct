@isTest
public class IncentiveEarningsDataFechTestCls {
	@isTest
    public static void incentiveSplit(){
        
        //Trigger switch
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj7 = new TriggerSwitch__c(Name='OppStageChangeListenerTrigger', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj8 = new TriggerSwitch__c(Name='IncentiveQualifierManageTrigger', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj9 = new TriggerSwitch__c(Name='UpdateActualrev', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj10 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj11 = new TriggerSwitch__c(Name='QVAOwnerChange', 	IS_ACTIVE__c=true);
		
		trigList.add(trigObj1) ;
		trigList.add(trigObj2) ;
		trigList.add(trigObj3) ;
		trigList.add(trigObj4) ;
		trigList.add(trigObj5) ;
		trigList.add(trigObj6) ;
		trigList.add(trigObj7) ;
		trigList.add(trigObj8) ;
		trigList.add(trigObj9) ;
		trigList.add(trigObj10) ;
		trigList.add(trigObj11) ;
        insert trigList;
        
        //account creation
        Account nacc = new Account(name='IncAcc',sbu__c='USA',CurrencyIsoCode='USD');
        insert nacc;
        Account acc = [select id,name from account where name='IncAcc' limit 1];
        
        //opportunity creation
        opportunity nopp = new opportunity(accountid=acc.Id, name='IncOpp',Type='New Customer',closedate=system.today(),stagename='Client Meeting',amount=6000,currencyIsoCode='USD');
        insert nopp;
        opportunity opp = [select id,name from opportunity  where name='IncOpp' limit 1];
        
        //Opportunity Line Item creation
        Opportunity_Line_Item__c noppLine1 = new Opportunity_Line_Item__c(Opportunity_ID__c=opp.id,Pillar__c='Enterprise Services',Competency__c='Others (Enterprise Services)',Product__c='None',Revenue_Stream__c='Professional Services',Project_Type__c='T&M',Project_Category__c='Onsite',Incentive_Qualifier__c='BCT IP',Total_Value__c=1000);
        insert noppLine1;
        Opportunity_Line_Item__c oppLine1 = [select id,name,Incentive_Qualifier__c from Opportunity_Line_Item__c where Incentive_Qualifier__c='BCT IP'];
        
        //Revenue Term creation
        Revenue_Term__c nrev1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=oppLine1.Id,Milestone__c='AMC Support',Milestone_Basis__c='Fixed Amount',Percentage__c=250,Revenue_Date__c=Date.newInstance(2020,04, 01),CurrencyIsoCode ='USD');
        Revenue_Term__c nrev2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=oppLine1.Id,Milestone__c='AMC Support',Milestone_Basis__c='Fixed Amount',Percentage__c=250,Revenue_Date__c=Date.newInstance(2020,07, 01),CurrencyIsoCode ='USD');
        Revenue_Term__c nrev3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=oppLine1.Id,Milestone__c='AMC Support',Milestone_Basis__c='Fixed Amount',Percentage__c=250,Revenue_Date__c=Date.newInstance(2020,10, 01),CurrencyIsoCode ='USD');
        Revenue_Term__c nrev4 = new Revenue_Term__c(Opportunity_Line_Item_id__c=oppLine1.Id,Milestone__c='AMC Support',Milestone_Basis__c='Fixed Amount',Percentage__c=250,Revenue_Date__c=Date.newInstance(2021,01, 01),CurrencyIsoCode ='USD');
        List<Revenue_Term__c> rev = new List<Revenue_Term__c>();
        rev.add(nrev1);
        rev.add(nrev2);
        rev.add(nrev3);
        rev.add(nrev4);
        Test.startTest();
        insert rev;
        Test.stopTest();
        
        //Adding users into OpportunityTeam for Account Manager, Sales Manager & Presales consultant roles
        OpportunityTeamMember salesExecutiveTeam = new OpportunityTeamMember(TeamMemberRole='Account Manager',UserId='00515000007ENwqAAG',OpportunityAccessLevel='Read',Involvement__c=30,OpportunityId=opp.id);
        OpportunityTeamMember salesManagerTeam = new OpportunityTeamMember(TeamMemberRole='Sales Manager',UserId='00515000006V95rAAC',OpportunityAccessLevel='Read',Involvement__c=100,OpportunityId=opp.id);
        OpportunityTeamMember preSalesTeamOnSite = new OpportunityTeamMember(TeamMemberRole='Pre-Sales - Onsite',UserId='00515000006MBYVAA4',OpportunityAccessLevel='Read',Involvement__c=50,OpportunityId=opp.id);
       	List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
        oppTeam.add(salesExecutiveTeam);
        oppTeam.add(salesManagerTeam);
        oppTeam.add(preSalesTeamOnSite);
        insert oppTeam;
        
        //Below code is used for IncentiveEarningsDataFechcontroller test class
        List<Incentive_Earnings__c> incList = new List<Incentive_Earnings__c>();
        Incentive_Earnings__c inc1 = new Incentive_Earnings__c( Act_Fct_Revenue_amount__c=180000, CurrencyIsoCode='INR', Incentive_Qualifier__c='BCT IP', Is_CFI__c='N',Opportunity_Id__c=opp.id, Opportunity_Line_Item__c=oppLine1.Id, PreSales_Incentives__c=2700.0, Revenue_Date__c=nrev1.Revenue_Date__c ,Revenue_Id__c=nrev1.id, SE_Incentives__c=5400.0, SM_Incentives__c=2700.0);
        Incentive_Earnings__c inc2 = new Incentive_Earnings__c( Act_Fct_Revenue_amount__c=180000, CurrencyIsoCode='INR', Incentive_Qualifier__c='BCT IP', Is_CFI__c='N',Opportunity_Id__c=opp.id, Opportunity_Line_Item__c=oppLine1.Id, PreSales_Incentives__c=2700.0, Revenue_Date__c=nrev2.Revenue_Date__c ,Revenue_Id__c=nrev2.id, SE_Incentives__c=5400.0, SM_Incentives__c=2700.0);
        Incentive_Earnings__c inc3 = new Incentive_Earnings__c( Act_Fct_Revenue_amount__c=180000, CurrencyIsoCode='INR', Incentive_Qualifier__c='BCT IP', Is_CFI__c='N',Opportunity_Id__c=opp.id, Opportunity_Line_Item__c=oppLine1.Id, PreSales_Incentives__c=2700.0, Revenue_Date__c=nrev3.Revenue_Date__c ,Revenue_Id__c=nrev3.id, SE_Incentives__c=5400.0, SM_Incentives__c=2700.0);
        Incentive_Earnings__c inc4 = new Incentive_Earnings__c( Act_Fct_Revenue_amount__c=180000, CurrencyIsoCode='INR', Incentive_Qualifier__c='BCT IP', Is_CFI__c='N',Opportunity_Id__c=opp.id, Opportunity_Line_Item__c=oppLine1.Id, PreSales_Incentives__c=2700.0, Revenue_Date__c=nrev4.Revenue_Date__c ,Revenue_Id__c=nrev4.id, SE_Incentives__c=5400.0, SM_Incentives__c=2700.0);
		incList.add(inc1);
        incList.add(inc2); 
        incList.add(inc3);
        incList.add(inc4);
        insert incList;
        Map<String,List<Incentive_Earnings__c>> incMap = IncentiveEarningsDataFetchController.getIncentiveEarnings(opp.id);
        
        
        //Below insertion is used for getIncentiveEarningsTotal test class
        List<Incentive_Earnings__c> incTotalList = IncentiveEarningsTotalController.getIncentiveEarningsTotal(opp.id);
        Decimal convertedValue = IncentiveEarningsTotalController.currencyConvertionToUSD(inc1.CurrencyIsoCode, inc1.Act_Fct_Revenue_amount__c);
        
    }
   
}