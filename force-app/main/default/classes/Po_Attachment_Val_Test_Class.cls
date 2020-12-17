/*
Class name 	 : Po_Attachment_Val_Test_Class
Description  : This is a test class for Po_Attachment_Val trigger.
Author       : Maria Ashvini A
Date Created : 20-May-2020  
*/

@isTest
public class Po_Attachment_Val_Test_Class {
    @isTest
    Static void testScenario1()
    {
        List<Trigger_Switch__c> trigList =  new List<Trigger_Switch__c>();        
          
        Trigger_Switch__c trigObj1 = new Trigger_Switch__c(Name='POAttachmentValidationTrigger',Trigger_Name__c='POAttachmentValidationTrigger',  is_active__c=true);  
        trigList.add(trigObj1);        
        insert trigList;
        
        Opportunity newOpp = new Opportunity(Accountid='0011500001XkgJmAAJ', Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Contract Finalization',Amount=500000);
        insert newOpp;
   
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Tesla-Car'];
        
        Test.startTest();
        createdOpp.StageName = 'Closed Won';
         
        try{
         update createdOpp;    
        }
        catch(Exception ex){
            System.Assert(ex.getMessage().contains('Please attach contract copy'), 'TEST');
        }
                             
       	Test.stopTest();
    }
    

}