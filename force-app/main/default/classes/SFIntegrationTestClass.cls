@isTest
public class SFIntegrationTestClass {

    static testMethod void testDoGet() {

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //req.requestURI = 'https://cs95.salesforce.com/services/apexrest/sfspot/wonOppNPipelineaging?reportNumber=1&reportLastExeDate=2018-01-30 06:37:16.000+0000';  
        req.requestURI = '/services/apexrest/sfspot/wonOppNPipelineaging';
        req.addParameter('reportNumber', '1');
        req.addParameter('reportLastExeDate', '2018-01-30 06:37:16.000+0000');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        SFSpotFireIntegrationService.getOpportunity();
        Test.stopTest();
        //List<Opportunity> results = SFSpotFireIntegrationService.getOpportunity();
}
    
    
     static testMethod void testDoGet1() {

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //req.requestURI = 'https://cs95.salesforce.com/services/apexrest/sfspot/wonOppNPipelineaging?reportNumber=1&reportLastExeDate=2018-01-30 06:37:16.000+0000';  
        req.requestURI = '/services/apexrest/sfspot/wonOppNPipelineaging';
        req.addParameter('reportNumber', '2');
        req.addParameter('reportLastExeDate', '2018-01-30 06:37:16.000+0000');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        SFSpotFireIntegrationService.getOpportunity();
        Test.stopTest();
        //List<Opportunity> results = SFSpotFireIntegrationService.getOpportunity();
}
    
     static testMethod void testDoGet2() {

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //req.requestURI = 'https://cs95.salesforce.com/services/apexrest/sfspot/wonOppNPipelineaging?reportNumber=1&reportLastExeDate=2018-01-30 06:37:16.000+0000';  
        req.requestURI = '/services/apexrest/sfspot/revPacing';
        req.addParameter('reportNumber', '3');
        req.addParameter('reportLastExeDate', '2018-01-30 06:37:16.000+0000');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        SFSpotFireRevPacingDataIntegrationSevice.getRevenuePacingReport();
        Test.stopTest();

      // String testBlob = res.responseBody.toString();
      // system.debug('Test Blog REST Response : ' + testBlob);
	}
}