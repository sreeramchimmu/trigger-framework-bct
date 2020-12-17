@isTest
public class RevenueMutiLineEditTestClass {
   //First Test method starts
     @isTest
    static void revenueTestMethod(){        
        //Test data insert starts        
        // Test data insert for Account object
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');        
        insert nAcc;
        Account createdAcc = [select id,name from Account where Name='RevTeslaaa' limit 1]; 
        // Test data insert for Opportunity object
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        insert nOpp;
        Opportunity createdOpp = [select id from Opportunity where Name='Tesla-Car' limit 1];
        // Test data insert for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                          Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite',
                          Incentive_Qualifier__c='BCT IP',Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj');
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [select id,name from opportunity_line_item__c limit 1];        
        // Test data insert for Revenue Term object	        
         Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
        insert nrt;
        Revenue_Term__c createdRevTerm = [select id,Revenue_Date__c From Revenue_Term__c limit 1];        
		//Test Data insert ends
		
		
		//Test starts
            Test.startTest();     
            //Setting current page to RevenueMutiEdit page
            PageReference myVfPage = Page.RevenueMutiEdit;
            Test.setCurrentPage(myVfPage);
         
           ApexPages.currentPage().getParameters().put('id', createdOppLn.id);
           String id = ApexPages.currentPage().getParameters().get('id');  
           ApexPages.currentPage().getParameters().put('action', 'update');   
           ApexPages.currentPage().getParameters().put('actionParam', 'delete');	
        
           System.assert(true,id==null);         
           RevenueMutiLineEdit revMulEdit = new RevenueMutiLineEdit();
        
         revMulEdit.saveRevenue();
         revMulEdit.deleteRevenue();
         revMulEdit.openPopup();
         revMulEdit.splitValuesEqually();
         revMulEdit.addSplitRev();
         revMulEdit.navBack();         
         revMulEdit.Cancel();
         revMulEdit.resetPage();      
         Test.stopTest();  
        //Test stops
        
        }
    
    
   //Second Test method starts
     @isTest
    static void revenueTestMethod2(){        
        //Test data insert starts        
        // Test data insert for Account object
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');        
        insert nAcc;
        Account createdAcc = [select id,name from Account where Name='RevTeslaaa' limit 1]; 
        // Test data insert for Opportunity object
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        insert nOpp;
        Opportunity createdOpp = [select id from Opportunity where Name='Tesla-Car' limit 1];
        // Test data insert for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                          Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite',
                          Incentive_Qualifier__c='BCT IP',Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj');
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [select id,name from opportunity_line_item__c limit 1];        
        // Test data insert for Revenue Term object	        
         Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
        insert nrt;
        Revenue_Term__c createdRevTerm = [select id,Revenue_Date__c From Revenue_Term__c limit 1];        
		//Test Data insert ends
		
		
		//Test starts
            Test.startTest();     
            //Setting current page to RevenueMutiEdit page
            PageReference myVfPage = Page.RevenueMutiEdit;
            Test.setCurrentPage(myVfPage);
         
           ApexPages.currentPage().getParameters().put('id', createdOppLn.id);
           String id = ApexPages.currentPage().getParameters().get('id');  
           ApexPages.currentPage().getParameters().put('action', 'delete');   
           ApexPages.currentPage().getParameters().put('actionParam', 'delete');	
        
           System.assert(true,id==null);         
           RevenueMutiLineEdit revMulEdit = new RevenueMutiLineEdit();
        
         revMulEdit.saveRevenue();
         revMulEdit.deleteRevenue();
         revMulEdit.openPopup();
         revMulEdit.splitValuesEqually();
         revMulEdit.addSplitRev();
         revMulEdit.navBack();         
         revMulEdit.Cancel();
         revMulEdit.resetPage();      
         Test.stopTest();  
        //Test stops
        
        } 
    
     //Third Test method starts
     @isTest
    static void revenueTestMethod3(){        
        //Test data insert starts        
        // Test data insert for Account object
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');        
        insert nAcc;
        Account createdAcc = [select id,name from Account where Name='RevTeslaaa' limit 1]; 
        // Test data insert for Opportunity object
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        insert nOpp;
        Opportunity createdOpp = [select id from Opportunity where Name='Tesla-Car' limit 1];
        // Test data insert for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                          Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite',
                          Incentive_Qualifier__c='BCT IP',Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj');
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [select id,name from opportunity_line_item__c limit 1];        
        // Test data insert for Revenue Term object	        
         Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
        insert nrt;
        Revenue_Term__c createdRevTerm = [select id,Revenue_Date__c From Revenue_Term__c limit 1];        
		//Test Data insert ends
		
		
		//Test starts
            Test.startTest();     
            //Setting current page to RevenueMutiEdit page
            PageReference myVfPage = Page.RevenueMutiEdit;
            Test.setCurrentPage(myVfPage);
         
           ApexPages.currentPage().getParameters().put('id', createdOppLn.id);
           String id = ApexPages.currentPage().getParameters().get('id');  
           ApexPages.currentPage().getParameters().put('action', 'splitEqually');   
           ApexPages.currentPage().getParameters().put('actionParam', 'delete');	
        
           System.assert(true,id==null);         
           RevenueMutiLineEdit revMulEdit = new RevenueMutiLineEdit();
        
         revMulEdit.saveRevenue();
         revMulEdit.deleteRevenue();
         revMulEdit.openPopup();
         revMulEdit.splitValuesEqually();
         revMulEdit.addSplitRev();
         revMulEdit.navBack();         
         revMulEdit.Cancel();
         revMulEdit.resetPage();      
         Test.stopTest();  
        //Test stops
        
        } 
    

}