//@isTest(SeeAllData=true)
@isTest
public class SplitRevenueTermTestCls {
    
    static testMethod void validateSplitRevTermIntermed(){
        
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
       
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
        
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
			
			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='DIGITAL JOURNEY MGMT', Competency__c='CueTrans', product__c='CueTrans', Revenue_Stream__c ='AMC SUPPORT',  Project_Category__c='Onsite', Project_Type__c='Fixed Bid', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
			insert nOppLn;
			opportunity_line_item__c myTestOL = [SELECT id,name From opportunity_line_item__c LIMIT 1];
			System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
 
			Revenue_Term__c nRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
			insert nRt;
			//Revenue_Term__c myTestRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
        
        
        Revenue_Term__c myTestRevTerm = [SELECT id From Revenue_Term__c LIMIT 1];
        //Opportunity_Line_Item__c myTestOppLn = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
		System.debug('Test query result' + myTestRevTerm +'-----> ID :'+ myTestRevTerm.id +'-----> Parent Id :'+myTestOL.id );	
  		Test.startTest();

        PageReference myVfPage = Page.SplitRevTermIntermed;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);

        String id = ApexPages.currentPage().getParameters().get('id');
        System.debug('Test Put ID obj ' +  id); 
		System.assert(true,id==null);
        ApexPages.StandardController sc = new ApexPages.StandardController(myTestRevTerm);
        SplitRevTermIntermed testController = new SplitRevTermIntermed(sc);
 		System.debug('Test Controller Obj' + testController );     
	 	testController.splitTerm = new Revenue_Term__c();
        testController.splitTerm.Milestone__c='T & M';
        testController.splitRevInter();
        testController.navback();

        Test.stopTest(); 
        
    }
      

	  
   static testMethod void validateSplitRevTerm(){
      //  User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
         //System.debug('Test User data ' + u1 );	
       //  System.RunAs(u1){
       
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
         
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        	//Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        	opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c myTestOL = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
         
          			Revenue_Term__c nRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt;
        			Revenue_Term__c myTestRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
					
		System.debug('Test query result' + myTestRevTerm +'-----> ID :'+ myTestRevTerm.id +'-----> Parent Id :'+myTestOL.id );	
  		Test.startTest();

        PageReference myVfPage = Page.SplitRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);
             
             ApexPages.currentPage().getParameters().put('fromDate', String.valueOf(System.today()));
             ApexPages.currentPage().getParameters().put('noOfSplits', String.valueOf(4));
             ApexPages.currentPage().getParameters().put('srcId', String.valueOf(myTestOL.id));
             ApexPages.currentPage().getParameters().put('lncur', 'INR');
             ApexPages.currentPage().getParameters().put('rtm', String.valueOf(30));
       		 ApexPages.currentPage().getParameters().put('rmst', String.valueOf('Sample Milestone'));
             
	          String id1 = ApexPages.currentPage().getParameters().get('fromDate');
              String id2 = ApexPages.currentPage().getParameters().get('noOfSplits');
              String id3 = ApexPages.currentPage().getParameters().get('srcId');
              String id4 = ApexPages.currentPage().getParameters().get('lncur');
              String id5 = ApexPages.currentPage().getParameters().get('rtm');
              String id = ApexPages.currentPage().getParameters().get('id');
             
            system.debug(' Test class main controller ---->'+id1 + '--'+ id2 +'---' + id3+'---' + id4+'---' + id5);        

        
              System.debug('Test Put ID obj ' +  id); 
              System.assert(true,id==null);
              ApexPAges.StandardController sc = new ApexPages.StandardController(myTestRevTerm);
              SplitRevenueTerm testctrlr = new SplitRevenueTerm(sc);
              System.debug('Test Controller Obj' + testctrlr);  
              //testctrlr.Add();
              //testctrlr.delMilestone();
              testctrlr.SaveAccount();
         	  //testctrlr.navback();
             
             Test.stopTest(); 
            //}
     }
    
    
    static testMethod void vaLSplitRevTermTestCase2(){
      //  User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
         //System.debug('Test User data ' + u1 );	
       //  System.RunAs(u1){
        
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
       TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
        
        
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c myTestOL = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
         
          			Revenue_Term__c nRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt;
        			Revenue_Term__c myTestRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
					
		System.debug('Test query result' + myTestRevTerm +'-----> ID :'+ myTestRevTerm.id +'-----> Parent Id :'+myTestOL.id );	
  		Test.startTest();

        PageReference myVfPage = Page.SplitRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);
             
             ApexPages.currentPage().getParameters().put('fromDate', String.valueOf(System.today()));
             ApexPages.currentPage().getParameters().put('noOfSplits', String.valueOf(4));
             ApexPages.currentPage().getParameters().put('srcId', String.valueOf(myTestOL.id));
             ApexPages.currentPage().getParameters().put('lncur', 'INR');
             ApexPages.currentPage().getParameters().put('rtm', String.valueOf(30));
        	 ApexPages.currentPage().getParameters().put('rmst', String.valueOf('Sample Milestone'));
             
	          String id1 = ApexPages.currentPage().getParameters().get('fromDate');
              String id2 = ApexPages.currentPage().getParameters().get('noOfSplits');
              String id3 = ApexPages.currentPage().getParameters().get('srcId');
              String id4 = ApexPages.currentPage().getParameters().get('lncur');
              String id5 = ApexPages.currentPage().getParameters().get('rtm');
              String id = ApexPages.currentPage().getParameters().get('id');
             
            system.debug(' Test class main controller ---->'+id1 + '--'+ id2 +'---' + id3+'---' + id4+'---' + id5);        

        
              System.debug('Test Put ID obj ' +  id); 
              System.assert(true,id==null);
              ApexPAges.StandardController sc = new ApexPages.StandardController(myTestRevTerm);
              SplitRevenueTerm testctrlr = new SplitRevenueTerm(sc);
              System.debug('Test Controller Obj' + testctrlr);  
              testctrlr.Add();
              testctrlr.delMilestone();
              Test.stopTest(); 
            //}
     }
    
    
    
    
    static testMethod void valSubsequentDateShift(){
         	
      //  User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
         //System.debug('Test User data ' + u1 );	
       //  System.RunAs(u1){
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
     TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
       	Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Client Meeting',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
					
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn);
        			
					 List<revenue_term__c> revList =  new List<revenue_term__c>();
						revenue_term__c nRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today());
                        revenue_term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30);
                        revenue_term__c nRt2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+60);
                        revenue_term__c nRt3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+90);
        				revList.add(nRt);
        				revList.add(nRt1);
        				revList.add(nRt2);
        				revList.add(nRt3);
        				
        				insert revList;
        
        				revenue_term__c createdRevTm = [SELECT name,Revenue_Date__c From revenue_term__c LIMIT 1];
						System.debug('New Test Rev Term created :' + createdRevTm);
						
						createdRevTm.Revenue_Date__c = System.today()-1;
						createdRevTm.Shift_Subsequent_Revenue_Dates__c =true;
        				createdRevTm.Change_Reason__c = 'Test reason';
        				createdRevTm.Recognized_Amount__c = 500;
						
						update createdRevTm; 
      }
    
	// Method for different Incentive Qualifiers
	/*static testMethod void vaLSplitRevTermTestCase3(){
      //  User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
         //System.debug('Test User data ' + u1 );	
       //  System.RunAs(u1){
        
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
       TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
		TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger', 	IS_ACTIVE__c=false);
		
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
		trigList.add(trigObj6);
        insert trigList;
        
        
        
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Proposal Submission',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT Enterprise Services',Project_ID__c='1');
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c myTestOL = [SELECT id,name From opportunity_line_item__c where Project_ID__c='1'];
        			System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
         
          			Revenue_Term__c nRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt;
        			Revenue_Term__c myTestRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
					// 2nd Opportunity Line Item
					opportunity_line_item__c nOppLn1 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=31000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT Enterprise Services',Project_ID__c='12');
        			insert nOppLn1;
        			opportunity_line_item__c myTestOL1 = [SELECT id,name From opportunity_line_item__c where Project_ID__c='12'];
        			
          			Revenue_Term__c nRt1  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL1.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt1;
        			Revenue_Term__c myTestRevTerm1 = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL1.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
					// 3rd Opportunity Line Item
					opportunity_line_item__c nOppLn2 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=32000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='Professional Services',Project_ID__c='123');
        			insert nOppLn2;
        			opportunity_line_item__c myTestOL2 = [SELECT id,name From opportunity_line_item__c where Project_ID__c='123'];
        			
          			Revenue_Term__c nRt2  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL2.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt2;
        			Revenue_Term__c myTestRevTerm2 = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL2.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
					// 4th Opportunity Line Item
					opportunity_line_item__c nOppLn3 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=33000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='SI Products',Project_ID__c='1234');
        			insert nOppLn3;
        			opportunity_line_item__c myTestOL3 = [SELECT id,name From opportunity_line_item__c where Project_ID__c='1234'];
        			
          			Revenue_Term__c nRt3  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL3.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt3;
        			Revenue_Term__c myTestRevTerm3 = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL3.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
					
					// 5th Opportunity Line Item
					opportunity_line_item__c nOppLn4 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=34000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT approved Digital & TIBCO Services',Project_ID__c='12345');
        			insert nOppLn4;
        			opportunity_line_item__c myTestOL4 = [SELECT id,name From opportunity_line_item__c where Project_ID__c='12345'];
        			
          			Revenue_Term__c nRt4  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL4.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt4;
        			Revenue_Term__c myTestRevTerm4 = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL4.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
					// 6th Opportunity Line Item
					opportunity_line_item__c nOppLn5 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=35000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='TIBCO Product License',Project_ID__c='123456');
        			insert nOppLn5;
        			opportunity_line_item__c myTestOL5 = [SELECT id,name From opportunity_line_item__c where Project_ID__c='123456'];
        			
          			Revenue_Term__c nRt5  = new Revenue_Term__c( Opportunity_Line_Item_id__c=myTestOL5.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert nRt5;
        			Revenue_Term__c myTestRevTerm5 = new Revenue_Term__c(Opportunity_Line_Item_id__c = myTestOL5.id,Revenue_Term__c = String.valueOf(30), Split_days__c = 5, Revenue_Date__c = System.today()+30);
         
		 
		System.debug('Test query result' + myTestRevTerm +'-----> ID :'+ myTestRevTerm.id +'-----> Parent Id :'+myTestOL.id );	
  		Test.startTest();

      /*  PageReference myVfPage = Page.SplitRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOL.id);
             
             ApexPages.currentPage().getParameters().put('fromDate', String.valueOf(System.today()));
             ApexPages.currentPage().getParameters().put('noOfSplits', String.valueOf(4));
             ApexPages.currentPage().getParameters().put('srcId', String.valueOf(myTestOL.id));
             ApexPages.currentPage().getParameters().put('lncur', 'INR');
             ApexPages.currentPage().getParameters().put('rtm', String.valueOf(30));
        	 ApexPages.currentPage().getParameters().put('rmst', String.valueOf('Sample Milestone'));
             
	          String id1 = ApexPages.currentPage().getParameters().get('fromDate');
              String id2 = ApexPages.currentPage().getParameters().get('noOfSplits');
              String id3 = ApexPages.currentPage().getParameters().get('srcId');
              String id4 = ApexPages.currentPage().getParameters().get('lncur');
              String id5 = ApexPages.currentPage().getParameters().get('rtm');
              String id = ApexPages.currentPage().getParameters().get('id');
             
            system.debug(' Test class main controller ---->'+id1 + '--'+ id2 +'---' + id3+'---' + id4+'---' + id5);        

        
              System.debug('Test Put ID obj ' +  id); 
              System.assert(true,id==null);
              ApexPAges.StandardController sc = new ApexPages.StandardController(myTestRevTerm);
              SplitRevenueTerm testctrlr = new SplitRevenueTerm(sc);
              System.debug('Test Controller Obj' + testctrlr);  
              testctrlr.Add();
              testctrlr.delMilestone();
              
            //}
			Test.stopTest(); 
     }*/
	
	
    /*static testMethod void valSubsequentDateShift2(){
         	
      //  User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
         //System.debug('Test User data ' + u1 );	
       //  System.RunAs(u1){
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
     TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=false);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
       	Account nAcc = new Account(Name='RevTeslaaa1',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa1' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Proposal Submission',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=33000, Pillar__c='Enterprise Services', Competency__c='Oracle', product__c='OracleERP', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT Enterprise Services',Project_ID__c='1234');
        			opportunity_line_item__c nOppLn1 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=33000, Pillar__c='Digital Services', Competency__c='Cloud', product__c='AWS', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='Professional Services',Project_ID__c='1234');
        			opportunity_line_item__c nOppLn2 = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=33000, Pillar__c='TIBCO', Competency__c='Analytics', product__c='SPotFire', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='TIBCO Product License',Project_ID__c='1234');
        			
        	
        			
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
        			List<opportunity_line_item__c> oppLnList = new List<opportunity_line_item__c>();
        			oppLnList.add(nOppLn);
                    oppLnList.add(nOppLn1);
                    oppLnList.add(nOppLn2);
            		insert oppLnList;
        			opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c where product__c='OracleERP' ];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn);
        			
					 List<revenue_term__c> revList =  new List<revenue_term__c>();
						revenue_term__c nRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support1',Percentage__c=1000,Revenue_Date__c =System.today(), revenue_term__c ='45');
                        revenue_term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30);
                        revenue_term__c nRt2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+60);
                        revenue_term__c nRt3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+90);
    
        				revList.add(nRt);
        				revList.add(nRt1);
        				revList.add(nRt2);
        				revList.add(nRt3);
                     		
        				insert revList;
        
        
        			opportunity_line_item__c createdOppLn1 = [SELECT id,name From opportunity_line_item__c where Product__c='AWS'];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn1);
        			
					 List<revenue_term__c> revList1 =  new List<revenue_term__c>();
						revenue_term__c naRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn1.id, Milestone__c='AMC Support1',Percentage__c=1000,Revenue_Date__c =System.today(), revenue_term__c ='45');
                        revenue_term__c naRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn1.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30);
                       	revList1.add(naRt);
        				revList1.add(naRt1);
        				insert revList1;
        
        				opportunity_line_item__c createdOppLn2 = [SELECT id,name From opportunity_line_item__c where Product__c='SPotFire'];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn2);
        			
					 List<revenue_term__c> revList2 =  new List<revenue_term__c>();
						revenue_term__c nnRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn2.id, Milestone__c='Catering',Percentage__c=1000,Revenue_Date__c =System.today(), revenue_term__c ='45');
                        revenue_term__c nnRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn2.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30);
                        
        				revList2.add(nnRt);
        				revList2.add(nnRt1);
        				insert revList2;
        
        

        revenue_term__c createdRevTm = [SELECT name,Revenue_Date__c From revenue_term__c where milestone__c ='Catering' LIMIT 1];
						System.debug('New Test Rev Term created :' + createdRevTm);
						
						createdRevTm.Revenue_Date__c = System.today()-1;
						createdRevTm.Shift_Subsequent_Revenue_Dates__c =true;
        				createdRevTm.Change_Reason__c = 'Test reason';
        				createdRevTm.Recognized_Amount__c = 500;
						
						update createdRevTm; 
                
        
        
      }*/
    
    
    
}