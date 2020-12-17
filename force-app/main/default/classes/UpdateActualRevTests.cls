//Created By Rameez on 24/10/2019
@isTest
private class UpdateActualRevTests {

   @isTest
    static void probability_Changed_UnitTest() { 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
        
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
		UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head BCT Consulting'];
        
        User Mgruser = new User(Alias = 'KM', Email='standarduser1@testorg.com',
					 EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
					 LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
					 UserName='Mgruser@testorg.com');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser@testorg.com' LIMIT 1];
        
        User stduser = new User(Alias = 'RG', Email='standarduser2@testorg.com',
					 EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
					 LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role2.Id, 
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',ManagerId=CreatedMgruser.id,
					 UserName='stduser@testorg.com');
         insert stduser;
        
       System.runAs(stduser) {  
           
        List<Trigger_Switch__c> trigList =  new List<Trigger_Switch__c>();        
          
        Trigger_Switch__c trigObj1 = new Trigger_Switch__c(Name='UpdateActualrev',Trigger_Name__c='UpdateActualrev',  is_active__c=true);    
            //TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='testTriggerLineItem',  IS_ACTIVE__c=true);
        trigList.add(trigObj1);   
            //trigList.add(trigObj2);
                
        insert trigList;
        
         // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
         
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Contract Finalization',Amount=500000);
        insert newOpp;
           
       // Opportunity createdOpp = [SELECT id, name, amount From Opportunity WHERE Name='Birla Tyres'];
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Tesla-Car'];
       // Test Opportunity Line Item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                          Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20);
        
        insert newOppLn;
           
        opportunity_line_item__c createdOppl = [SELECT id From opportunity_line_item__c LIMIT 1];
        
        // Create Revenue Term
        Revenue_Term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
        insert nRt1;
           
        Revenue_Term__c CreatedRevTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c From Revenue_Term__c  where id=:nRt1.id];
         
    	//Test.startTest();
    	createdOpp.Probability__c = '50';
    	update createdOpp;
        
    	createdOpp.StageName = 'Closed Won';
    	createdOpp.CONTRACT_PO_SIGN_DATE__c = Date.today();
    	createdOpp.CONTRACT_PO_NUMBER__c = '123213';
    	createdOpp.PROJECT_START_DATE__c = Date.today();
    	createdOpp.PROJECT_END_DATE__c = Date.today();
    	createdOpp.Project_Manager__c = 'asdasdasd';
        
    	CreatedRevTerm.Recognized_Amount__c = null;
        
        update CreatedRevTerm;
        update createdOpp;
    
     }
    }    
    
        
 }