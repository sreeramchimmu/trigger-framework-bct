@isTest
public class BillingAndRevValueCheckTestCls 
{
    static testMethod void BillSplitValCheckTrgTstCases()
    {
       List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        
         insert trigList;
         //Test.startTest();
         
        // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
         
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Birla Tyres',CurrencyIsoCode='INR',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Birla Tyres'];
                
        // Create Opportunity Line item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000,Practice__c='AD & MS', Competency__c='BPOKPO', 
                                                                         Pillar__c='Enterprise Services', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        insert newOppLn;
        opportunity_line_item__c createdOppl = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :newOppLn.id ];
        
         // Create Billing Term
         Billing_Term__c newBillTerm = new Billing_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=1000);
         insert newBillTerm;    
         Billing_Term__c CreatedBillTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c From Billing_Term__c  where id=:newBillTerm.id ];
        
         /*if (CreatedBillTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedBillTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          insert newBillTerm;
         }*/
        
         if (CreatedBillTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedBillTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          update newBillTerm;
         }
         // Test.stopTest(); 
     }
    
    ///// Test cases for RevenueSplitValueCheckTrigger 
    static testMethod void RevnSplitValCheckTrgTstCases()
    {
       List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        
         insert trigList;
         //Test.startTest();
         
        // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
         
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Birla Tyres',CurrencyIsoCode='INR',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
       // Opportunity createdOpp = [SELECT id, name, amount From Opportunity WHERE Name='Birla Tyres'];
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Birla Tyres'];
                
        // Create Opportunity Line item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000,Practice__c='AD & MS', Competency__c='BPOKPO', 
                                                                         Pillar__c='Enterprise Services', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        insert newOppLn;
        opportunity_line_item__c createdOppl = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :newOppLn.id ];
        
         // Create Revenue Term
         Revenue_Term__c newRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500);
         insert newRevTerm;    
         Revenue_Term__c CreatedRevTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c From Revenue_Term__c  where id=:newRevTerm.id ];
         /*if (CreatedRevTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedRevTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          insert newRevTerm;
         }*/
        
         if (CreatedRevTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedRevTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          update newRevTerm;
         }
         // Test.stopTest(); 
         
     }
    ////
    /////// Test cases for OppTotalLineItemsValueCheckTrigger 
    static testMethod void OppTotalLineItemsValueCheckTriggerTstCases()
    {
       List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
         insert trigList;
         //Test.startTest();
         
        // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
         
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Birla Tyres',CurrencyIsoCode='INR',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
       // Opportunity createdOpp = [SELECT id, name, amount From Opportunity WHERE Name='Birla Tyres'];
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Birla Tyres'];
                
        // Create Opportunity Line item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000,Practice__c='AD & MS', Competency__c='BPOKPO', 
                                                                         Pillar__c='Enterprise Services', Product__c='BPO', Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT', 
                                                                         Incentive_Qualifier__c='BCT IP');
        insert newOppLn;
        opportunity_line_item__c createdOppl = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :newOppLn.id ];
        
         // Create Revenue Term
         Revenue_Term__c newRevTerm = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500);
         insert newRevTerm;    
         Revenue_Term__c CreatedRevTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c From Revenue_Term__c  where id=:newRevTerm.id ];
         /*if (CreatedRevTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedRevTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          insert newRevTerm;
         }*/
        
         if (CreatedRevTerm.Milestone_Amount__c > createdOppl.Total_Value__c)
         {
            CreatedRevTerm.addError('Milestone Amount should not exceed the Opportunity Line value!!');
         }
         else
         {
          update newRevTerm;
         }
         // Test.stopTest(); 
         
     }
    /////
    static testMethod void updateLineItemStagesTstCases()
    {
       List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        insert trigList;
         //Test.startTest();
  	if(updateDateOnce.calledOnceflag == true)
    {
     updateDateOnce.calledOnceflag = false;     
        // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
        
        // Create Contact
        Contact newContact = new Contact(LastName='Pal', FirstName='Goutam', AccountId=createdAcc.id,CurrencyIsoCode='INR');
        insert newContact;
        Contact createdContact = [Select id, Name, Accountid from Contact where Name = 'Goutam Pal' ];
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Birla Tyres',CurrencyIsoCode='INR',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
       // Opportunity createdOpp = [SELECT id, name, amount From Opportunity WHERE Name='Birla Tyres'];
        opportunity createdOpp = [SELECT id, name, amount,CloseDate From opportunity WHERE Name='Birla Tyres'];
        date newCloseDate = createdOpp.CloseDate+30;
        // Create ContactRole 
        OpportunityContactRole newContactRole = new OpportunityContactRole(contactId=createdContact.id,OpportunityId=createdOpp.id,IsPrimary = TRUE);
        insert newContactRole;
        OpportunityContactRole createdOpContRole = [select ContactId from OpportunityContactRole where OpportunityId = :createdOpp.id and IsPrimary = TRUE];
        // added on 19-Mar-2018
        Contact ContactName = [Select name from contact where id = :createdContact.id];
        
        Opportunity oppUpdate = [SELECT Id, Name, Contact_Name__c FROM Opportunity where id = :createdOpp.id];
 		oppUpdate.Contact_Name__c = ContactName.Name;
        update oppUpdate;
        // Create Opportunity Line item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=1000
                                            ,Practice__c='AD & MS', Competency__c='BPOKPO',Pillar__c='Enterprise Services', Product__c='BPO'
                                            ,Project_Category__c='Onsite', Revenue_Stream__c='AMC SUPPORT',Incentive_Qualifier__c='BCT IP'
                                            ,Op_ContactName__c=ContactName.Name);  
                                                                         
                                                                         
        insert newOppLn;
        opportunity_line_item__c createdOppl = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :newOppLn.id ];
        
         // Create Revenue Term
         List<Revenue_Term__c> newRevTerm = new List<Revenue_Term__c>();
         Revenue_Term__c newRevTerm1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500,Revenue_Date__c=system.today()
                                                          ,Revenue_Term__c='30 Days',Change_Reason__c='Record has been updated due to opportunity closed date changed');
         Revenue_Term__c newRevTerm2 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500,Revenue_Date__c=system.today()+60
                                                          ,Revenue_Term__c='60 Days',Change_Reason__c='Record has been updated due to opportunity closed date changed');
         Revenue_Term__c newRevTerm3 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500,Revenue_Date__c=system.today()+90
                                                          ,Revenue_Term__c='90 Days',Change_Reason__c='Record has been updated due to opportunity closed date changed');
         newRevTerm.add(newRevTerm1);
         newRevTerm.add(newRevTerm2);
         newRevTerm.add(newRevTerm3);
         insert newRevTerm;    
         Revenue_Term__c CreatedRevTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c,Revenue_Date__c,Change_Reason__c From Revenue_Term__c Limit 1];
         CreatedRevTerm.Revenue_Date__c = newCloseDate;
         CreatedRevTerm.Change_Reason__c = CreatedRevTerm.Change_Reason__c+'From '+system.today()+' To '+system.today()+30;
         if (createdOpp.CloseDate != newCloseDate)
         {
          update CreatedRevTerm;
         }
         else
         {    
            CreatedRevTerm.addError('Date can not be shifted !!');
         }    
        // Create Billing Term
        Billing_Term__c newBillTerm = new Billing_Term__c(Opportunity_Line_Item_id__c=createdOppl.Id, Milestone_Amount__c=500
                                                          ,Billing_Term__c='30 Days',Billing_Date__c=system.today(),Change_Reason__c='Record has been updated due to opportunity closed date changed');
        Insert newBillTerm;
        Billing_term__c createdBillTerm=[SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c,Billing_Date__c,Change_Reason__c From Billing_Term__c  where id=:newBillTerm.id ];
        createdBillTerm.Billing_Date__c = newCloseDate;
        createdBillTerm.Change_Reason__c = CreatedRevTerm.Change_Reason__c+'From '+system.today()+' To '+system.today()+30;
        if (createdOpp.CloseDate != newCloseDate)
        {
          update createdBillTerm;
        }
        else
        {    
            createdBillTerm.addError('Date can not be shifted !!');
        }    
        
         // Test.stopTest(); 
     }
    }
    
}