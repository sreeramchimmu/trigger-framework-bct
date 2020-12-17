@isTest(SeeAllData=false)
public class CopyRevTermBillTermTestCls { 
	    static testMethod void validateCopyRevTermToBill(){
        Test.startTest();
        // Test Account object
	    Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
        System.debug('Test Account Created --->' + createdAcc);
        // Test Opportunity Object
        Opportunity newOpp = new Opportunity( Accountid=createdAcc.id, Name='Birla Tyres',CurrencyIsoCode='INR',CloseDate=System.today()+30,StageName='Lead Identification',Amount=30000);
        System.debug('New Test Opportunity --->:' + newOpp);
        insert newOpp;
        Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Birla Tyres' LIMIT 1];
        System.debug('Test Opportunity Created --->' + createdOpp);
        // Test Opportunity Line Item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000,
                                                                         Practice__c='AD & MS', Competency__c='BPOKPO',Pillar__c='Enterprise Services', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        System.debug('New Test Revenue Opportunity Line --->:' + newOppLn);
        insert newOppLn;
        opportunity_line_item__c myTestOL = [SELECT id From opportunity_line_item__c LIMIT 1];
        System.debug('New Test Revenue Opportunity Line Created --->:' + myTestOL); 
        // Test Billing Term       
        billing_term__c newBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=10,Billing_Date__c=System.today(),SrNo__c = 1);
        insert newbt;
        Revenue_Term__c newRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=100,Revenue_Date__c=System.today(),SrNo__c = 1);
        insert newRt;
        // Test Visual force page       
        PageReference myVfPage = Page.RevenueTerm_Copyto_BillingTermPage;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);
        // Test apex class
 		ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        RevenueTerm_Copyto_BillingTerm_CX testctrlr = new RevenueTerm_Copyto_BillingTerm_CX(sc); 
        testctrlr.Save();
        //testctrlr.navback();
        
    }
}