@isTest(SeeAllData=false)
public class CopyBillTermRevTermTestCls {
	static testMethod void validateCopyBillToRevTerm(){
         Test.startTest();

      Account nAcc = new Account(Name='RevTeslaaaX',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaaX' LIMIT 1];
        System.debug('Test Account Created --->' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-CaarX',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000,  SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-CaarX',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000);
        	System.debug('New Test Opportunity --->:' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-CaarX' LIMIT 1];
        	System.debug('Test Opportunity Created --->' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000,
                                                                         Practice__c='AD & MS', Pillar__c='Enterprise Services', Competency__c='BPOKPO', Product__c='BPO',Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        			System.debug('New Test Revenue Opportunity Line --->:' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c myTestOL = [SELECT id From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created --->:' + myTestOL); 
               
        			billing_term__c nBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=10,Billing_Date__c=System.today(),SrNo__c = 1);
         			 insert nbt;
        
        			Revenue_Term__c nRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=100,Revenue_Date__c=System.today(),SrNo__c = 1);
         			insert nRt;
        
        
     //   Opportunity_Line_Item__c myTestOL = [SELECT max(srid__c), id From Opportunity_Line_Item__c LIMIT 1];
        
       
        PageReference myVfPage = Page.BillingTerm_Copyto_RevenueTermPage;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);
        
 		ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        BillingTerm_Copyto_RevenueTerm_CX testctrlr = new BillingTerm_Copyto_RevenueTerm_CX(sc); 
        testctrlr.Save();
        //testctrlr.navback();
        
    }
}