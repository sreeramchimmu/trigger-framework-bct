//@isTest(SeeAllData=true)
@isTest
public class MultiLineRevenueEditTestCls {
    
    static testMethod void MultiLineEditRevenueTermUpdate(){
       
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);

        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Contract Finalization',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        	opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20
                                                                                  
                        );
					
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
                 // List<opportunity_line_item__c> createdOppLn =new List<opportunity_line_item__c>();
        		opportunity_line_item__c createdOppLn = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c,Cogs_Bctpl_percentage__c,CurrencyIsoCode From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn);
              
                /*   Integer balanceAmt = Integer.valueOf(createdOppLn.Total_Value__c);
                   Integer revBalancedAmt = Integer.valueOf(createdOppLn.Revenue_Term_balance_amount__c);
                   String oppLineStage = createdOppLn.stageName__c;
                   String oppStageCode = createdOppLn.Opportunity_ID__r.Funnel_Code__c;
                   Decimal cogspercentage = createdOppLn.Cogs_Bctpl_percentage__c;*/
                
        
                 
        List<revenue_term__c> revList =  new List<revenue_term__c>();
						revenue_term__c nRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone_Basis__c = 'Fixed Amount',Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD');
                        revenue_term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD');
                        revenue_term__c nRt2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+60,CurrencyIsoCode ='USD');
                        revenue_term__c nRt3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+90,CurrencyIsoCode ='USD');
        				revList.add(nRt);
        				revList.add(nRt1);
        				revList.add(nRt2);
        				revList.add(nRt3);
        				
        				insert revList;
        
        				revenue_term__c createdRevTm = [SELECT Id, Opportunity_line_item_id__c,Milestone__c, Recognized_Amount__c,Percentage__c, Split_days__c, Milestone_Basis__c, Revenue_Date__c,CurrencyIsoCode From revenue_term__c LIMIT 1];
        
                       /*Id parId = createdRevTm.Opportunity_line_item_id__c;
                       Date milestoneDt  = Date.valueOf(createdRevTm.Revenue_Date__c);
                       String lineCurrency = String.valueOf(createdRevTm.CurrencyIsoCode);
                       String revMilestone = String.valueOf(createdRevTm.Milestone__c);*/
                        
                         
        
						System.debug('New Test Rev Term created :' + createdRevTm);
						
                        createdRevTm.Milestone__c ='Build & Testing';
						createdRevTm.Revenue_Date__c = System.today()-1;
        				createdRevTm.Change_Reason__c = 'Test reason';
        				createdRevTm.Recognized_Amount__c = 500;
                        createdRevTm.Percentage__c = 800;
                        createdRevTm.CurrencyIsoCode ='INR';
      				    createdRevTm.Recognized_Amount__c =100;
        
						
						update createdRevTm; 
        
       
      
        Test.startTest();

        PageReference myVfPage = Page.MultiLineEditRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', createdRevTm.id);

        String id = ApexPages.currentPage().getParameters().get('id');
        
        ApexPAges.StandardController sc = new ApexPages.StandardController(createdRevTm);
  
        MultiLineEditRevenueTerm testctrlr = new MultiLineEditRevenueTerm(sc); 
       
        testctrlr.UpdateRecord();
        testctrlr.navback();
        testctrlr.fetchRevenueDetail(revList);
       
        
        
    }
    
    
    
  /* static testMethod void NavBackRevenueTerm(){
      
    
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Contract Finalization',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20
                                                                                  
                        );
					
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
               //   List<opportunity_line_item__c> createdOppLn =new List<opportunity_line_item__c>();
        		opportunity_line_item__c createdOppLn = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c,Cogs_Bctpl_percentage__c,CurrencyIsoCode From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn);
              
        
        
        
                 
        List<revenue_term__c> revList =  new List<revenue_term__c>();
						revenue_term__c nRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD');
                       revenue_term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD');
                        revenue_term__c nRt2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+60,CurrencyIsoCode ='USD');
                        revenue_term__c nRt3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+90,CurrencyIsoCode ='USD');
        				revList.add(nRt);
        				revList.add(nRt1);
        				revList.add(nRt2);
        				revList.add(nRt3);
        				
        				insert revList;
        
        				revenue_term__c createdRevTm = [SELECT Id, Opportunity_line_item_id__c,Milestone__c, Percentage__c, Split_days__c, Milestone_Basis__c, Revenue_Date__c,CurrencyIsoCode From revenue_term__c LIMIT 1];
						System.debug('New Test Rev Term created :' + createdRevTm);
						
                        createdRevTm.Milestone__c ='Build & Testing';
						createdRevTm.Revenue_Date__c = System.today()-1;
        				createdRevTm.Change_Reason__c = 'Test reason';
        				createdRevTm.Recognized_Amount__c = 500;
                        createdRevTm.Percentage__c = 800;
                        createdRevTm.CurrencyIsoCode ='INR';
        
						
						update createdRevTm; 
        
       
      
        Test.startTest();

        PageReference myVfPage = Page.MultiLineEditRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        
        ApexPAges.StandardController sc = new ApexPages.StandardController(createdRevTm);
  
       MultiLineEditRevenueTerm testctrlr = new MultiLineEditRevenueTerm(sc); 
     
        testctrlr.navback();

        
    }
    
    
    static testMethod void fetchRevenueTermDetails(){
     
        
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Contract Finalization',Amount=500000);
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        		
        			opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20
                                                                                  
                        );
					
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
                 // List<opportunity_line_item__c> createdOppLn =new List<opportunity_line_item__c>();
        		opportunity_line_item__c createdOppLn = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c,Cogs_Bctpl_percentage__c,CurrencyIsoCode From opportunity_line_item__c LIMIT 1];
        			System.debug('New Test Revenue Opportunity Line Created :' + createdOppLn);

           
        List<revenue_term__c> revList =  new List<revenue_term__c>();
						revenue_term__c nRt  = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD');
                       revenue_term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD');
                        revenue_term__c nRt2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+60,CurrencyIsoCode ='USD');
                        revenue_term__c nRt3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c =System.today()+90,CurrencyIsoCode ='USD');
        				revList.add(nRt);
        				revList.add(nRt1);
        				revList.add(nRt2);
        				revList.add(nRt3);
        				
        				insert revList;
        
        				revenue_term__c createdRevTm = [SELECT Id, Opportunity_line_item_id__c,Milestone__c, Percentage__c, Split_days__c, Milestone_Basis__c, Revenue_Date__c,CurrencyIsoCode From revenue_term__c LIMIT 1];
						System.debug('New Test Rev Term created :' + createdRevTm);
						
                        createdRevTm.Milestone__c ='Build & Testing';
						createdRevTm.Revenue_Date__c = System.today()-1;
        				createdRevTm.Change_Reason__c = 'Test reason';
        				createdRevTm.Recognized_Amount__c = 500;
                        createdRevTm.Percentage__c = 800;
                        createdRevTm.CurrencyIsoCode ='INR';
        
						
						update createdRevTm; 
        
       
      
        Test.startTest();

        PageReference myVfPage = Page.MultiLineEditRevenueTermScr;
        Test.setCurrentPage(myVfPage);
        
        ApexPAges.StandardController sc = new ApexPages.StandardController(createdRevTm);
  
       MultiLineEditRevenueTerm testctrlr = new MultiLineEditRevenueTerm(sc); 
       
        testctrlr.fetchRevenueDetail(revList);
       

        
    }*/
    
    
    
}