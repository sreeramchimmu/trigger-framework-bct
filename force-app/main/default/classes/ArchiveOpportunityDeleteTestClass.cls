@isTest
public class ArchiveOpportunityDeleteTestClass {
    @isTest
    static void testscenario_For_archiveOpportunityDelete(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Bahwan Standard User'];
        
        UserRole Role1 = [SELECT Id FROM UserRole WHERE Name = 'GEO Head India'];
        UserRole Role2 = [SELECT Id FROM UserRole WHERE Name = 'Delivery Head INDIA'];
        
        User Mgruser = new User(Alias = 'KM', Email='standarduser1@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role1.Id,  
                                User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',
                                UserName='Mgruser2@testorg.com');
        insert Mgruser;
        User CreatedMgruser =[select Id from User where UserName='Mgruser2@testorg.com' LIMIT 1];
        
        User stduser = new User(Alias = 'RG', Email='standarduser2@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=Role2.Id, 
                                User_s_SBU__c='101-IND', TimeZoneSidKey='GMT',ManagerId=CreatedMgruser.id,
                                UserName='stduser2@testorg.com');
        insert stduser; 
        
        
        System.runAs(stduser){
            
            List<Trigger_Switch__c> trigList =  new List<Trigger_Switch__c>();        
            
            Trigger_Switch__c trigObj1 = new Trigger_Switch__c(Name='Line_Item_Total_update',Trigger_Name__c='Line_Item_Total_update',  is_active__c=true);    
            
            trigList.add(trigObj1);   
            
            
            insert trigList;
            
            // Create account
            Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR');
            insert newAcc;
            Account createdAcc = [SELECT id,name From Account WHERE Name='Birla Tyres' LIMIT 1];
            
            // Create opportunity
            Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today()+30,StageName='Contract Finalization',Amount=500000);
            insert newOpp;
            
            // Opportunity createdOpp = [SELECT id, name, amount From Opportunity WHERE Name='Birla Tyres'];
            opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Tesla-Car'];
            
            opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, 
                                                                             Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix',
                                                                             Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',
                                                                             Cogs_Bctpl_percentage__c=20);
            
            insert newOppLn;
            
            opportunity_line_item__c createdOppl = [SELECT id,Total_Value__c,Opportunity_ID__c From opportunity_line_item__c where Opportunity_ID__c=:createdOpp.id LIMIT 1];
            
            Revenue_Term__c nRt1 = new Revenue_Term__c(Opportunity_Line_Item_id__c=createdOppl.id, Milestone__c='AMC Support',Milestone_Basis__c = 'Fixed Amount',Percentage__c=1000,Revenue_Date__c =System.today()+30,CurrencyIsoCode ='USD'); 
            insert nRt1;
            
            Revenue_Term__c CreatedRevTerm = [SELECT id,Opportunity_Line_Item_id__c,Milestone_Amount__c From Revenue_Term__c  where id=:nRt1.id];
            
            Archive_Opportunity__c arOpp = new Archive_Opportunity__c(Opportunity_Related__c=newOpp.id,Opportunity_Id__c=newOpp.id,Opportunity_Name__c=createdOpp.Name, Archive_Opportunity_Snapshot__c=system.today());
            insert arOpp;
            Archive_Opportunity__c createdarOpp = [SELECT id From Archive_Opportunity__c WHERE Opportunity_Name__c='Tesla-Car' LIMIT 1];
            
            Archive_Opportunity_Line_Item__c arOli = new Archive_Opportunity_Line_Item__c(Archive_Opportunity_Id__c=createdarOpp.id, Archive_Opportunity_line_item_Snapshot__c=system.today());
            insert arOli;
            Archive_Opportunity_Line_Item__c createdarOli = [select id from Archive_Opportunity_Line_Item__c limit 1];
            
            Archive_Revenue_Term__c arRev = new Archive_Revenue_Term__c(Archive_Opportunity_Line_Item_Id__c=createdarOli.id,Archive_Revenue_Split_Snapshot__c=system.today());
            insert arRev;          
            
            Test.startTest(); 
            
            delete createdOpp;
            
            Test.stopTest();
            
        } 
    }
}