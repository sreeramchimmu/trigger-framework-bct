/*
TestClass name : QuotaMasterControllerTestClass
Description    : This is the test class for QuotaMasterController Apex class.
Author         : Sreeram. V
Date Created   : 05-May-2020
*/
 
@isTest
public class QuotaMasterControllerTestClass {

    @isTest
    static void testscenario1(){
        
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
        
		//Test starts
            Test.startTest();
    
            //Setting current page to OwnChngScrVF page
            PageReference myVfPage = Page.QuotaMasterNew;
            Test.setCurrentPage(myVfPage);
            
           	QuotaMasterController qva = new QuotaMasterController();
            
            qva.getItems();
            qva.getReportees();
            qva.getCountry('USD');
        	qva.fiscalYear = '2012-2013';        	
            qva.setOrFetchQuota();
            
            QuotaMasterController qva1 = new QuotaMasterController();
            
            qva1.getItems();
            qva1.getReportees();
            qva1.getCountry('AED');
        	qva1.fiscalYear = '2012-2013';        	
            qva1.setOrFetchQuota();
            
            QuotaMasterController qva2 = new QuotaMasterController();
            
            qva2.getItems();
            qva2.getReportees();
            qva2.getCountry('BND');
        	qva2.fiscalYear = '2012-2013';        	
            qva2.setOrFetchQuota();
            
            QuotaMasterController qva3 = new QuotaMasterController();
            
            qva3.getItems();
            qva3.getReportees();
            qva3.getCountry('INR');
        	qva3.fiscalYear = '2012-2013';        	
            qva3.setOrFetchQuota();
            
            QuotaMasterController qva4 = new QuotaMasterController();
            
            qva4.getItems();
            qva4.getReportees();
            qva4.getCountry('OMR');
        	qva4.fiscalYear = '2012-2013';        	
            qva4.setOrFetchQuota();
            
            QuotaMasterController qva5 = new QuotaMasterController();
            
            qva5.getItems();
            qva5.getReportees();
            qva5.getCountry('QAR');
        	qva5.fiscalYear = '2012-2013';        	
            qva5.setOrFetchQuota();
            
            QuotaMasterController qva6 = new QuotaMasterController();
            
            qva6.getItems();
            qva6.getReportees();
            qva6.getCountry('SGD');
        	qva6.fiscalYear = '2012-2013';        	
            qva6.setOrFetchQuota();
            
            QuotaMasterController qva7 = new QuotaMasterController();
            
            qva7.getItems();
            qva7.getReportees();
            qva7.getCountry('EEEE');
        	qva7.fiscalYear = '2012-2013';
            //qva7.usermap.get(Mgruser.id);
            qva7.repId = Mgruser.Id;
          
            qva7.setOrFetchQuota();
            
            Test.stopTest();  
        //Test stops
        }
    
    }
}