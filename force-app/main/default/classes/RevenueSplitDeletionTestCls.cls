@isTest
public class RevenueSplitDeletionTestCls {
	
    @isTest
    static void testmeth(){
        
        // making RevenueSplitValueCheckTrigger active for testmethod
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);
        trigList.add(trigObj2);        
		insert trigList;
        
        // Test data preparation for Account object
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');        
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];        
        
        // Test data preparation for Opportunity object
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        insert nOpp;
        Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        
        // Test data preparation for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000,Practice__c='AD & MS', 
                                                                         Pillar__c='Enterprise Services', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
       
 		// Test data preparation for Revenue Term object	         
       	Revenue_Term__c nrt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
        insert nrt;
        
        
        //Test starts
            Test.startTest();
        		
        		List<Revenue_Term__c> createdRevTerm = [SELECT id,Revenue_Date__c From Revenue_Term__c LIMIT 1]; 
        		delete createdRevTerm;
				        
        	Test.stopTest();
        //Test Ends
        
    }
    
    
}