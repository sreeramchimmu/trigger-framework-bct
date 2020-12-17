@isTest
public class QvaDataFetchControllerTestClass {

    @isTest 
    static void createquota1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
        
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
    	UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'India Sales'];
        
        User Mgruser = new User(Alias = 'KM', Email='standarduser1@testorg.com',
           EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
           UserName='Mgruser2@testorg.com',currencyIsoCode='USD');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser2@testorg.com' LIMIT 1];
        
        User stduser = new User(Alias = 'RG', Email='standarduser2@testorg.com',
           EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role2.Id, 
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',ManagerId=CreatedMgruser.id,
           UserName='stduser2@testorg.com');
        insert stduser; 
        
        
        System.runAs(Mgruser){
            PageReference myVfPage = Page.QvaDataFetch;
        	Test.setCurrentPage(myVfPage);
        
        
            ApexPages.currentPage().getParameters().put('qowner', 'Vijayakumar Subramanian');
            ApexPages.currentPage().getParameters().put('qtaPeriod', '2015-2016' );
            ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95lAAC');
            ApexPages.currentPage().getParameters().put('geoLoc', 'India');
        	ApexPages.currentPage().getParameters().put('action', 'submit');
        
            //ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
            QvaDataFetchController testctrlr = new QvaDataFetchController(); 
            testctrlr.submitQuota();
        }
    }
    
    @isTest
    static void validateNavBackAndEdit(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
        ApexPages.currentPage().getParameters().put('qowner', 'Vijayakumar Subramanian');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2015-2016' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95lAAC');
        ApexPages.currentPage().getParameters().put('geoLoc', 'USA');
        ApexPages.currentPage().getParameters().put('action', 'update');
        
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr2 = new QvaDataFetchController(); 
        testctrlr2.makeEdit(); 
        testctrlr2.navback();
        //testctrlr.navback();
        Test.stopTest();
        
    }
    
    @isTest
    static void validateUpdateQuota(){       
      		
        
        Test.startTest();

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
        ApexPages.currentPage().getParameters().put('qowner', 'Vijayakumar Subramanian');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2013-2014' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95lAAC');
        ApexPages.currentPage().getParameters().put('geoLoc', 'SGD');
        ApexPages.currentPage().getParameters().put('action', 'update');
        
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr = new QvaDataFetchController(); 
        testctrlr.updateQuota();
        //testctrlr.navback();
        Test.stopTest();
    }
    
    @isTest
    static void validatefetchquotadetails(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
        
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
    	UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'India Sales'];
        
        User Mgruser = new User(Alias = 'KM', Email='standarduser1@testorg.com',
           EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
           UserName='Mgruser2@testorg.com',currencyIsoCode='USD');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser2@testorg.com' LIMIT 1];
        
        User stduser = new User(Alias = 'RG', Email='standarduser2@testorg.com',
           EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role2.Id, 
                     User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',ManagerId=CreatedMgruser.id,
           UserName='stduser2@testorg.com');
        insert stduser; 
        
        system.debug('sss '+Mgruser.Name);
        System.runAs(Mgruser){
         
        Test.startTest();
        QuotaMasterNew__c qm = new QuotaMasterNew__c( Quota_Owner_Name__c=Mgruser.Id,Product_type__c ='OVERALL',Geo_Location__c='USA',Quota_Period__c='2016-2017',SBU__c='SGD');
        insert qm;
        QuotaDetail__c qd = new QuotaDetail__c(QuotaMasterNew__c=qm.id);
        insert qd;
        List<QuotaDetail__c> qdlst = [select id from QuotaDetail__c];
        
        

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
       ApexPages.currentPage().getParameters().put('qowner', 'daniel pope');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2013-2014' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95lAAC');
        ApexPages.currentPage().getParameters().put('geoLoc', 'SGD');
        ApexPages.currentPage().getParameters().put('action', 'update');
        //String qtaPeriod =  ApexPages.currentPage().getParameters().put('qtaPeriod', '2013-2014' );   
        //String startPeriod = getStartDatePeriod(integer.valueOf(qtaPeriod.substring(0,4)));
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr = new QvaDataFetchController(); 
       
        //testctrlr.navback();
        Test.stopTest();
    }
    }
    
}