@isTest
public class OwnChngScrCntrlTestClass {
    
    @isTest
    static void cntrlTestMethod(){
        
        // Test data preparation for Account object
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');        
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];        
        
        // Test data preparation for Opportunity object
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        insert nOpp;
        Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        
        // Test data preparation for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj');
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        
       
 		// Test data preparation for Revenue Term object	        
         Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
        insert nrt;
        Revenue_Term__c createdRevTerm = [SELECT id,Revenue_Date__c From Revenue_Term__c LIMIT 1];        
			
		//Test starts
            Test.startTest();
    
            //Setting current page to OwnChngScrVF page
            PageReference myVfPage = Page.OwnChngScrVF;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getParameters().put('id', createdOpp.id);
            
            String id = ApexPages.currentPage().getParameters().get('id');       
            System.assert(true,id==null);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(createdRevTerm);
            OwnChngScrCntrl testController = new OwnChngScrCntrl(sc);
        
        	// test block for TRY part in next() in controller
            testController.next();
			
        	Cache.Session.put('local.OwnerChangeDates.RevenueFromDate',system.today());
        	Cache.Session.put('local.OwnerChangeDates.RevenueToDate',system.today());
        
            // test block for else part in getRecords() in controller
            testController.fromDate = (Date)Cache.Session.get('local.OwnerChangeDates.RevenueFromDate');
            testController.toDate = (Date)Cache.Session.get('local.OwnerChangeDates.RevenueToDate');

            testController.getRecords();
        
            // test block for if part in getRecords() in controller
            testController.fromDate = null;
            testController.toDate = null;
            testController.getRecords();
        
        	//test block for reset() in controller
            testController.reset();
        
            //test block for back() in controller
            testController.back();
            
            Test.stopTest();  
        //Test stops
    } 
}