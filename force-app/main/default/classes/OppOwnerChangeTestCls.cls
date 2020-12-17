@isTest
public class OppOwnerChangeTestCls {
static testMethod void validateSplitRevTermIntermed(){
		//Profile		
    	Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
    
        //Role
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
		UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'India Sales'];
        
    	//Manager
        User Mgruser = new User(Alias = 'KM', Email='standarduser1@testorg.com',
					 EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
					 LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
					 UserName='Mgruser@testorg.com');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser@testorg.com' LIMIT 1];
       
        
    	//User
        User usr1 = new User(Lastname='Arun', CommunityNickname='ArunNick',	Alias='AR', Email='arunrr@bct.com',
                             username='arunrr@bct.com', TimeZoneSidKey ='GMT', ProfileId =p.Id, EmailEncodingKey ='UTF-8', User_s_SBU__c ='USA', LocaleSidKey ='en_US', LanguageLocaleKey='en_US',ManagerId=CreatedMgruser.id,UserRoleId=Role2.Id);
    	User usr2 = new User(Lastname='Karthik', CommunityNickname='KarthikNick',	Alias='KA', Email='karthik@bct.com',
                             username='karthik@bct.com', TimeZoneSidKey ='GMT', ProfileId =p.Id, EmailEncodingKey ='UTF-8', User_s_SBU__c ='USA', LocaleSidKey ='en_US', LanguageLocaleKey='en_US',ManagerId=CreatedMgruser.id,UserRoleId=Role2.Id);
    	insert usr1;
    	insert usr2;
    	User createdUsr = [SELECT id,name, isActive From User WHERE username='arunrr@bct.com' LIMIT 1];
        User createdUsr1 = [SELECT id,name, isActive From User WHERE username='karthik@bct.com' LIMIT 1];
    	System.debug('New User created : ' + createdUsr);
    	System.debug('New User created : ' + createdUsr1);
    
    	
    	
    System.runAs(usr1){
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=true);
    	TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='QVAOwnerChange', 	IS_ACTIVE__c=true);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
     	trigList.add(trigObj6);
        insert trigList;
    
        Account nAcc = new Account(Name='RevTeslaaa',SBU__c='USA',CurrencyIsoCode ='USD');
        insert nAcc;
    	Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaa' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');//Opportunity Identification
    	Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',Type='Existing Customer - Existing Business',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Opportunity Identification',Amount=1000, ownerid=createdUsr.id,CONTRACT_PO_SIGN_DATE__c = Date.today(),CONTRACT_PO_NUMBER__c = '123',Project_Manager__c='Ashok',PROJECT_START_DATE__c=Date.today(),PROJECT_END_DATE__c=Date.today()+1);
    	System.debug('New Test Revenue Opportunity :' + nOpp);
        insert nOpp;
        Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Car' LIMIT 1];
        System.debug('Test Opportunity Revenue Created' + createdOpp);
        	
    	// Test data preparation for opportunity line item object
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Pillar__c='Asymmetrix',
                         Competency__c='Asymmetrix',Practice__c='Asymmetrix', product__c='Asymmetrix',
                         Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                         Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj', Total_Value__c=1000);
       	insert nOppLn;
        opportunity_line_item__c createdOppLn = [SELECT id,name From opportunity_line_item__c LIMIT 1];
        
            
 		// Test data preparation for Revenue Term object	        
        Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD'); 
        insert nrt;
        Revenue_Term__c createdRevTerm = [SELECT id,Revenue_Date__c From Revenue_Term__c LIMIT 1];
    	
        //Owner Change
    	Test.StartTest();
    	createdOpp.ownerId = createdUsr1.id;
        //createdOpp.StageName='Closed Won';  
    	Cache.Session.put('local.OwnerChangeDates.RevenueFromDate', Date.today()-1);
        Cache.Session.put('local.OwnerChangeDates.RevenueToDate', Date.today()+1);
    	update createdOpp;
        Test.StopTest();
    }
   }
}