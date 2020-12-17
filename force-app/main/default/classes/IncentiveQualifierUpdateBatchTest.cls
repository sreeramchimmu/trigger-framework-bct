@isTest
public class IncentiveQualifierUpdateBatchTest {
    
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
        List<Revenue_Term__c> rev = new List<Revenue_Term__c>();
        for(Integer i=10; i<30; i++){
        //Revenue Term creation
        Revenue_Term__c nrev1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=oppLine1.Id,Milestone__c='AMC Support',Milestone_Basis__c='Fixed Amount',Percentage__c=250,Revenue_Date__c=Date.newInstance(2020,04, 01),CurrencyIsoCode ='USD');
        rev.add(nrev1);
        }
        
        insert rev;
        
        Test.startTest();
        
        IncentiveQualifierUpdateBatch obj = new IncentiveQualifierUpdateBatch();
        DataBase.executeBatch(obj,1);
        
        Test.stopTest();

        
    }

}