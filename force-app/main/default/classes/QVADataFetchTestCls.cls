@isTest(SeeAllData=True)
public class QVADataFetchTestCls {

    static testMethod void validateUpdateQuota(){
        
      		User newUser = new User();
        
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
        
    }
    
    
    static testMethod void validateCreateQuota(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

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
        //testctrlr.navback();
        
    }
    
        static testMethod void validateNavBackAndEdit(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
        ApexPages.currentPage().getParameters().put('qowner', 'Vijayakumar Subramanian');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2015-2016' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95lAAC');
        ApexPages.currentPage().getParameters().put('geoLoc', 'USA');
        ApexPages.currentPage().getParameters().put('action', '');
        
        
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr2 = new QvaDataFetchController(); 
        testctrlr2.makeEdit(); 
        testctrlr2.navback();
        //testctrlr.navback();
        
    }
    
    
    
    static testMethod void validateCreateQuota1(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
        ApexPages.currentPage().getParameters().put('qowner', 'Kalirajan M');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2015-2016' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V94z');
        ApexPages.currentPage().getParameters().put('geoLoc', 'India');
        ApexPages.currentPage().getParameters().put('action', 'submit');
        
        
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr = new QvaDataFetchController(); 
        testctrlr.submitQuota();
        //testctrlr.navback();
        
    }
    
    static testMethod void validateCreateQuota2(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QvaDataFetch;
        Test.setCurrentPage(myVfPage);
        
        
        ApexPages.currentPage().getParameters().put('qowner', 'Shanthi Chandrasekar');
        ApexPages.currentPage().getParameters().put('qtaPeriod', '2015-2016' );
        ApexPages.currentPage().getParameters().put('qtaowner', '00515000006V95GAAS');
        ApexPages.currentPage().getParameters().put('geoLoc', 'Singapore');
        ApexPages.currentPage().getParameters().put('action', 'submit');
        
        
 		//ApexPAges.StandardController sc = new ApexPages.StandardController(myTestOL);
        QvaDataFetchController testctrlr = new QvaDataFetchController(); 
        testctrlr.submitQuota();
        //testctrlr.navback();
        
    }
    
           
    
    static testMethod void validateQVAController(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QVAScr;
        Test.setCurrentPage(myVfPage);
       
        
        QuotaMasterController testctrlr1 = new QuotaMasterController(); 
        testctrlr1.fiscalYear = '2016-2017';
        testctrlr1.getItems();
       // testctrlr1.getGeoLocation();
        testctrlr1.getReportees();
        testctrlr1.setOrFetchQuota();
        testctrlr1.getCountry('AED');
        testctrlr1.getCountry('BND');
        testctrlr1.getCountry('OMR');
        testctrlr1.getCountry('QAR');
        testctrlr1.getCountry('SGD');
        
    }
    
     static testMethod void validateQVAController1(){
        
      //  Opportunity_Line_Item__c myTestOL = [SELECT id From Opportunity_Line_Item__c LIMIT 1];
        
        Test.startTest();

        PageReference myVfPage = Page.QVAScr;
        Test.setCurrentPage(myVfPage);
       
        
        QuotaMasterController testctrlr1 = new QuotaMasterController(); 
        testctrlr1.fiscalYear = '2016-2017';
        testctrlr1.repId=id.valueOf('00515000006MBYh');
        map<String, String> usermap = new Map<String, String>();
		usermap.put('00515000006MBYh', '	Sundar Padmanaban');
        testctrlr1.usermap = usermap;
        testctrlr1.setOrFetchQuota();
   
    } 
    
}