@isTest
public class NewIncentiveBatchTestCls {
    
    @isTest
    public static void incentivebatchtest(){
        
         //account creation
        Account nacc = new Account(name='IncAcc',sbu__c='USA',CurrencyIsoCode='USD');
        insert nacc;
        Account acc = [select id,name from account where name='IncAcc' limit 1];
        
        //opportunity creation
        opportunity nopp = new opportunity(accountid=acc.Id, name='IncOpp',Type='New Customer',closedate=system.today(),
                           stagename='Client Meeting',amount=20000,currencyIsoCode='USD');
        insert nopp;
        opportunity opp = [select id,name from opportunity  where name='IncOpp' limit 1];
        
        //Opportunity Line Item creation
        Opportunity_Line_Item__c noppLine1 = new Opportunity_Line_Item__c(Opportunity_ID__c=opp.id,Pillar__c='Enterprise Services',
                                             Competency__c='Others (Enterprise Services)',Product__c='None',Revenue_Stream__c='Professional Services',
                                             Project_Type__c='T&M',Project_Category__c='Onsite',Incentive_Qualifier__c='BCT IP',Total_Value__c=10000);
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
        insert rev;
        
        //Adding users into OpportunityTeam for Account Manager, Sales Manager & Presales consultant roles
        OpportunityTeamMember salesExecutiveTeam = new OpportunityTeamMember(TeamMemberRole='Account Manager',UserId='00515000007ENwqAAG',OpportunityAccessLevel='Read',Involvement__c=30,OpportunityId=opp.id);
        OpportunityTeamMember salesManagerTeam = new OpportunityTeamMember(TeamMemberRole='Sales Manager',UserId='00515000006V95rAAC',OpportunityAccessLevel='Read',Involvement__c=100,OpportunityId=opp.id);
        OpportunityTeamMember preSalesTeam = new OpportunityTeamMember(TeamMemberRole='Pre-Sales - Onsite',UserId='00515000006MBYVAA4',OpportunityAccessLevel='Read',Involvement__c=50,OpportunityId=opp.id);
       	List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
        oppTeam.add(salesExecutiveTeam);
        oppTeam.add(salesManagerTeam);
        oppTeam.add(preSalesTeam);
        insert oppTeam;
        
        Test.startTest();
        
        NewIncentiveBatch obj = new NewIncentiveBatch();
        DataBase.executeBatch(obj,1);
        
        Test.stopTest();

        
    }

}