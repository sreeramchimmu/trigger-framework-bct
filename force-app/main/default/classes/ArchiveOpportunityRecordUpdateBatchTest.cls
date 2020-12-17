@isTest
public class ArchiveOpportunityRecordUpdateBatchTest {
	 
    @isTest
    public static void DataFactory(){
        
        //Profile		
    	Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
    
        //Role
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
		UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'Delivery Head INDIA'];
        
    	//Manager
        User Mgruser = new User(Alias = 'KM', Email='standarduser12@testorg.com',
					 EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US',
					 LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
					 UserName='Mgruser12@testorg.com');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser12@testorg.com' LIMIT 1];
        
    	//User
        User usr1 = new User(Lastname='Arun123', CommunityNickname='ArunNick12',	Alias='AR', Email='arunrr12@bct.com',
                             username='arunrr123@bct.com', TimeZoneSidKey ='GMT', ProfileId =p.Id, EmailEncodingKey ='UTF-8', User_s_SBU__c ='USA', LocaleSidKey ='en_US', LanguageLocaleKey='en_US',ManagerId=CreatedMgruser.id,UserRoleId=Role2.Id);
    	insert usr1;
    	User createdUsr = [SELECT id,name, isActive From User WHERE username='arunrr123@bct.com' LIMIT 1];       
        
        System.runAs(usr1){
            Account nAcc = new Account(Name='RevTeslaaaa',CurrencyIsoCode ='USD');
            insert nAcc;
            Account createdAcc = [SELECT id,name From Account WHERE Name='RevTeslaaaa' LIMIT 1];
            
            Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',Type='Existing Customer - Existing Business',CurrencyIsoCode='USD',
                                               CloseDate=System.today(),StageName='Opportunity Identification',Amount=100000, ownerid=createdUsr.id,CONTRACT_PO_SIGN_DATE__c = Date.today(),CONTRACT_PO_NUMBER__c = '123',Project_Manager__c='Ashok',PROJECT_START_DATE__c=Date.today(),PROJECT_END_DATE__c=Date.today()+1);
            
            insert nOpp;  
            Datetime yesterday = Datetime.now().addDays(-1);
            Test.setCreatedDate(nOpp.Id, yesterday);
            Opportunity nOpp1 = new Opportunity( Accountid=createdAcc.id, Name='Tesla1-Car',createdDate=system.today() ,Type='Existing Customer - Existing Business',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Opportunity Identification',Amount=1000, ownerid=createdUsr.id,CONTRACT_PO_SIGN_DATE__c = Date.today(),CONTRACT_PO_NUMBER__c = '123',Project_Manager__c='Ashok',PROJECT_START_DATE__c=Date.today(),PROJECT_END_DATE__c=Date.today()+1);
            
            insert nOpp1;  
            opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=nOpp.id, Pillar__c='Asymmetrix',
                             Competency__c='Asymmetrix',Practice__c='Asymmetrix', product__c='Asymmetrix',CreatedDate=System.today(),
                             Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                             Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj', Total_Value__c=10000);
            
            insert nOppLn;    
            Datetime yesterday1 = Datetime.now().addDays(-1);
            Test.setCreatedDate(nOppLn.Id, yesterday1);
            
            opportunity_line_item__c nOppLn1 = new Opportunity_Line_Item__c(Opportunity_ID__c=nOpp.Id,Pillar__c='Asymmetrix',
                             Competency__c='Asymmetrix',Practice__c='Asymmetrix', product__c='Asymmetrix',
                             Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                             Cogs_Bctpl_percentage__c=20,Project_ID__c='test_prj', Total_Value__c=1000);
            
            insert nOppLn1; 
             Test.setCreatedDate(nOppLn1.Id, DateTime.newInstance(2020,10,27));
            Revenue_Term__c nrt = new Revenue_Term__c(Opportunity_Line_Item_id__c=nOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD'); 

            insert nrt;  
            Datetime yesterday2 = Datetime.now().addDays(-1);
            Test.setCreatedDate(nrt.Id, yesterday2);
            Revenue_Term__c nrt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=nOppLn.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=100,Revenue_Date__c =System.today(),CurrencyIsoCode ='USD'); 

            insert nrt1;   
            
            Archive_Opportunity__c arOpp = new Archive_Opportunity__c(Opportunity_Related__c=nOpp.id,Opportunity_Name__c=nOpp.Name, Archive_Opportunity_Snapshot__c=system.today());
            insert arOpp;
            
            Archive_Opportunity__c createdarOpp = [SELECT id From Archive_Opportunity__c WHERE Opportunity_Name__c='Tesla-Car' LIMIT 1];
            
            Archive_Opportunity_Line_Item__c arOli = new Archive_Opportunity_Line_Item__c(Archive_Opportunity_Id__c=createdarOpp.id, Line_Item_Name__c='test',Archive_Opportunity_line_item_Snapshot__c=system.today());
            insert arOli;
            Archive_Opportunity_Line_Item__c createdarOli = [select id,Line_Item_Name__c from Archive_Opportunity_Line_Item__c limit 1];
            
            Archive_Revenue_Term__c arRev = new Archive_Revenue_Term__c(Archive_Opportunity_Line_Item_Id__c=createdarOli.id,Archive_Revenue_Split_Snapshot__c=system.today());
            insert arRev; 
            Test.startTest();
            ArchiveOpportunityBatch obj = new ArchiveOpportunityBatch();
            DataBase.executeBatch(obj);   
            ArchiveOpportunityRecordUpdateBatch obj1 = new ArchiveOpportunityRecordUpdateBatch();
            DataBase.executeBatch(obj1);  
            ArchiveOpportunityCreationBatch obj2 = new ArchiveOpportunityCreationBatch();
            DataBase.executeBatch(obj2); 
            ArchiveOpportunityLineTemCreateBatch obj3 = new ArchiveOpportunityLineTemCreateBatch();
            DataBase.executeBatch(obj3);   
            ArchiveRevenueCreationBatch obj4 =  new ArchiveRevenueCreationBatch();
            DataBase.executeBatch(obj4);  
            Test.stopTest();
        } 
    }  
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *'; 
        Test.startTest();         
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ArchiveOpportunityScheduleClass());  
        String jobId1 = System.schedule('ScheduleApexClassTest1',  CRON_EXP, new ArchiveMontlySchedulerClass()); 
        Test.stopTest(); 
    } 
}