@isTest
public class SplitBillTermTestCls {
    
   	 static testMethod void validateSplitBillTermIntermed(){
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
        
        
        Account nAcc = new Account(Name='Teslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Teslaaa' LIMIT 1];
        System.debug('Test Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
	    Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000);
        System.debug('New Test Opportunity :' + nOpp);
        Insert nOpp;
        Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        System.debug('Test Opportunity Created' + createdOpp);
        //Opportunity Line Item        		
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000,Practice__c='AD & MS', 
                                                                         Pillar__c='Enterprise Services',Competency__c='BPOKPO', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        System.debug('New Test Opportunity Line :' + nOppLn);
        insert nOppLn;
        opportunity_line_item__c myTestOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        System.debug('New Test Opportunity Line Created :' + myTestOppLn); 
 			         
       	billing_term__c nBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=myTestOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today());
        insert nbt;
        // Billing_Term__c myTestBT = new Billing_Term__c(Opportunity_Line_Item_id__c = createdOppLn.id,Billing_Term__c = String.valueOf(30), Split_days__c = 5, Billing_Date__c = System.today());
        
        Billing_Term__c myTestBillTerm = [SELECT id From Billing_Term__c LIMIT 1];
        //Opportunity_Line_Item__c myTestOppLn = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
		System.debug('Test query result' + myTestBillTerm +'-----> ID :'+ myTestBillTerm.id +'-----> Parent Id :'+myTestOppLn.id );	
  		Test.startTest();

        PageReference myVfPage = Page.SplitBillTermIntermed;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', myTestOppLn.id);

        String id = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('Test Put ID obj ' +  id); 
		System.assert(true,id==null);
        ApexPAges.StandardController sc = new ApexPages.StandardController(myTestBillTerm);
        SplitBillIntermed testController = new SplitBillIntermed(sc);
 		System.debug('Test Controller Obj' + testController );     
        testController.splitTerm = new Billing_Term__c();
        testController.splitTerm.Milestone__c='T & M';
        testController.splitBillInter();
        testController.navback();

        Test.stopTest(); 
        
    }
   
     static testMethod void validateSplitBillTerm(){
         //User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
        // User u1 = [SELECT Id FROM User WHERE username='gayathrip@bahwancybertek.com'];
        // System.debug('Test User data ' + u1 );	
        // System.RunAs(u1){
         List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
      Account nAcc = new Account(Name='TestAccountA',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='TestAccountA' LIMIT 1];
        System.debug('Test Account Created' + createdAcc);
//        	Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
			Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000);

         	System.debug('New Test Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000,Practice__c='AD & MS', Pillar__c='Enterprise Services', Competency__c='BPOKPO', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        			System.debug('New Test Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Opportunity Line Created :' + createdOppLn); 
 				         
       				 billing_term__c nBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today());
         			 insert nbt;
        			 Billing_Term__c myTestBT = new Billing_Term__c(Opportunity_Line_Item_id__c = createdOppLn.id,Billing_Term__c = String.valueOf(30), Split_days__c = 5, Billing_Date__c = System.today());
         
        //Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
					System.debug('Test query result myTestBT' + myTestBT +'-----> ID :'+ myTestBT.id +'-----> Parent Id Oppr Line Id :'+createdOppLn.id );	
  					Test.startTest();

        PageReference myVfPage = Page.SplitBillingTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', createdOppLn.id);
             
             ApexPages.currentPage().getParameters().put('fromDate', String.valueOf(System.today()));
             ApexPages.currentPage().getParameters().put('noOfSplits', String.valueOf(4));
             ApexPages.currentPage().getParameters().put('srcId', String.valueOf(createdOppLn.id));
             ApexPages.currentPage().getParameters().put('lncur', 'INR');
             ApexPages.currentPage().getParameters().put('btm', String.valueOf(30));
         	 ApexPages.currentPage().getParameters().put('bmst', String.valueOf('Milestone'));
             
	          String id1 = ApexPages.currentPage().getParameters().get('fromDate');
              String id2 = ApexPages.currentPage().getParameters().get('noOfSplits');
              String id3 = ApexPages.currentPage().getParameters().get('srcId');
              String id4 = ApexPages.currentPage().getParameters().get('lncur');
              String id5 = ApexPages.currentPage().getParameters().get('btm');
              String id = ApexPages.currentPage().getParameters().get('id');
             
            system.debug(' Test class main controller ---->'+id1 + '--'+ id2 +'---' + id3+'---' + id4+'---' + id5);        

        
              System.debug('Test Put ID obj ' +  id); 
              System.assert(true,id==null);
              ApexPAges.StandardController sc = new ApexPages.StandardController(myTestBT);
              SplitBillingTerm testctrlr = new SplitBillingTerm(sc);
              System.debug('Test Controller Obj' + testctrlr);  
            // testctrlr.Add();
            // testctrlr.delMilestone();
             testctrlr.SaveAccount();
            // testctrlr.navback();
             
             Test.stopTest();
            //}
         
     }
    
    
    
     static testMethod void valSplitBillTermTestCase2(){
         //User u1 = [SELECT Id FROM User WHERE username='arunr@bct.com'];
        // User u1 = [SELECT Id FROM User WHERE username='gayathrip@bahwancybertek.com'];
        // System.debug('Test User data ' + u1 );	
        // System.RunAs(u1){
   List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
         Account nAcc = new Account(Name='Teslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Teslaaa' LIMIT 1];
        System.debug('Test Account Created' + createdAcc);
        	//Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
			Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000);
         	System.debug('New Test Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Practice__c='AD & MS', Pillar__c='Enterprise Services', Competency__c='BPOKPO', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
                    System.debug('New Test Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Opportunity Line Created :' + createdOppLn); 
 				         
       				 billing_term__c nBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today());
         			 insert nbt;	
        			 Billing_Term__c myTestBT = new Billing_Term__c(Opportunity_Line_Item_id__c = createdOppLn.id,Billing_Term__c = String.valueOf(30), Split_days__c = 5, Billing_Date__c = System.today());
         
        //Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
					System.debug('Test query result myTestBT' + myTestBT +'-----> ID :'+ myTestBT.id +'-----> Parent Id Oppr Line Id :'+createdOppLn.id );	
  					Test.startTest();

        PageReference myVfPage = Page.SplitBillingTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', createdOppLn.id);
             
             ApexPages.currentPage().getParameters().put('fromDate', String.valueOf(System.today()));
             ApexPages.currentPage().getParameters().put('noOfSplits', String.valueOf(4));
             ApexPages.currentPage().getParameters().put('srcId', String.valueOf(createdOppLn.id));
             ApexPages.currentPage().getParameters().put('lncur', 'INR');
             ApexPages.currentPage().getParameters().put('btm', String.valueOf(30));
         	ApexPages.currentPage().getParameters().put('bmst', String.valueOf('Milestone'));
             
	          String id1 = ApexPages.currentPage().getParameters().get('fromDate');
              String id2 = ApexPages.currentPage().getParameters().get('noOfSplits');
              String id3 = ApexPages.currentPage().getParameters().get('srcId');
              String id4 = ApexPages.currentPage().getParameters().get('lncur');
              String id5 = ApexPages.currentPage().getParameters().get('btm');
         	  String id6 = ApexPages.currentPage().getParameters().get('bmst');
              String id = ApexPages.currentPage().getParameters().get('id');
             
            system.debug(' Test class main controller ---->'+id1 + '--'+ id2 +'---' + id3+'---' + id4+'---' + id5+'---' + id6);        

        
              System.debug('Test Put ID obj ' +  id); 
              System.assert(true,id==null);
              ApexPAges.StandardController sc = new ApexPages.StandardController(myTestBT);
              SplitBillingTerm testctrlr = new SplitBillingTerm(sc);
              System.debug('Test Controller Obj' + testctrlr);  
             testctrlr.Add();
             testctrlr.delMilestone();
            // testctrlr.SaveAccount();
            // testctrlr.navback();
             
             Test.stopTest();
            //}
         
     }
    
    
    
    
   static testMethod void valSubsequentBillDates(){
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
       
    Account nAcc = new Account(Name='Teslaaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Teslaaaa' LIMIT 1];
       // Account createdAcc = [SELECT id,name From Account WHERE Name='Biogen Idec' LIMIT 1];
        System.debug('Test Account Created' + createdAcc);
        	//Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
			Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+20,StageName='Lead Identification',Amount=500000);
        	//Opportunity nOpp = new Opportunity( Name='Biobank',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000);
         	System.debug('New Test Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	//Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Biobank' LIMIT 1];
        	System.debug('Test Opportunity Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000,Practice__c='AD & MS', Pillar__c='Enterprise Services', Competency__c='BPOKPO', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT',Incentive_Qualifier__c='BCT IP');
        			System.debug('New Test Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Opportunity Line Created :' + createdOppLn);
        				
       					List<billing_term__c> listBill = new list<billing_term__c>();
        				billing_term__c nBt  = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today());
       					billing_term__c nBt1 = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today()+30);
       					billing_term__c nBt2 = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today()+60);
       					billing_term__c nBt3 = new Billing_Term__c( Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Billing_Date__c=System.today()+90);
       					listBill.add(nBt);
                        listBill.add(nBt1);
                        listBill.add(nBt2);
                        listBill.add(nBt3);
        				System.debug('New Test Billing Term :' + nBt);
        				insert listBill;
        				billing_term__c createdBillTm = [SELECT name,Billing_Date__c From billing_term__c LIMIT 1];
						System.debug('New Test Billing Term created :' + nOppLn);
						
						createdBillTm.Billing_Date__c = System.today()-1;
						createdBillTm.Shift_subsequent_milestone_dates__c =true;
        				createdBillTm.Change_Reason__c = 'Test reason';
						
						update createdBillTm;
   }

}