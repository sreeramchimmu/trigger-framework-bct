@isTest(seeAlldata=True)
public class oafDataTestCls {
    static testMethod void validateUpdateOafData()
    {
       
        User usr1 = new User(Lastname='Pal', CommunityNickname='',	Alias='GP', Email='goutamkumar.p@bct.com',
                             username='goutamkumar.p@bct.com', EmployeeNumber='111965', TimeZoneSidKey ='GMT', 
                             ProfileId ='00e15000001RUMc', EmailEncodingKey ='UTF-8', User_s_SBU__c ='PEG', LocaleSidKey ='en_US', LanguageLocaleKey='en_US');
        insert usr1;
        User createdUsr = [SELECT id,name, isActive, userName,EmployeeNumber From User WHERE username='goutamkumar.p@bct.com' LIMIT 1];
        // Create account
        Account newAcc = new Account(Name='Birla Tyres',SBU__c='101-IND',CurrencyIsoCode ='INR',Industry='Healthcare',BillingStreet='3045 Queen Frederica Dr'
                                    ,billingCity='Mississauga',BillingState='Canada',BillingPostalCode='L4Y3A2');
        insert newAcc;
        Account createdAcc = [SELECT id,name,Industry From Account WHERE Name='Birla Tyres' LIMIT 1];
        // Create Conatact
        Contact newContact = new Contact(LastName='Pal',FirstName='Goutam',Accountid=createdAcc.id,CurrencyIsoCode='INR');
        insert newContact;
        Contact CreatedContact = [SELECT name,account.name from Contact WHERE Accountid=:createdAcc.id];
        // Create opportunity
        Opportunity newOpp = new Opportunity(createdDate=System.today(),Accountid=createdAcc.id,Name='Tubeless Tyres',contract_po_number__c='12345',
                                             contract_po_sign_date__c=System.today(),CurrencyIsoCode='INR',project_start_date__c=System.today()+30,project_end_date__c=System.today()+365,
                                             sales_channel__c='',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
        Opportunity createdOpp = [Select id,createdDate, account.name,account.industry,sbu__c,name,owner.name,owner.employeenumber
                    			,account.BillingStreet, account.billingCity, account.BillingState, account.BillingPostalCode
                     			,contract_po_number__c,contract_po_sign_date__c
                                ,CurrencyIsoCode,amount,project_start_date__c,project_end_date__c
                     			,Project_Duration__c,sales_channel__c,accountID
        FROM Opportunity WHERE Name='Tubeless Tyres' LIMIT 1]; 
        // Create Opportunity Line item
        opportunity_line_item__c newOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id 
                                                                          ,Practice__c='AD & MS', Pillar__c='Enterprise Services'
                                                                          ,Competency__c='BPOKPO', Product__c='BPO', Project_Category__c='Onsite'
                                 										  ,Revenue_Stream__c='AMC SUPPORT',Incentive_Qualifier__c='BCT IP'
                                                                         ,Project_ID__c='1001',  CurrencyIsoCode='INR'
                                                                         ,Total_Value__c=1000);
        insert newOppLn;
        opportunity_line_item__c createdOppL = [SELECT ID,Revenue_Stream__c,Practice__c,Total_Value__c From opportunity_line_item__c where Opportunity_ID__c=:createdOpp.id LIMIT 1];
        // Create Revenue Term
        Revenue_Term__c newRt  = new Revenue_Term__c( Opportunity_Line_Item_id__c=createdOppL.id, Milestone__c='Against Acceptance of PO',Percentage__c=100,Milestone_amount__c=200
                                                     ,Revenue_Date__c=System.today(),SrNo__c = 1);
        insert newRt;
        Revenue_Term__c createdRt = [SELECT Milestone__c,opportunity_line_item_id__r.Revenue_Stream__c,opportunity_line_item_id__r.Practice__c
                                     ,Revenue_Date__c, Milestone_Amount__c 
                                     FROM Revenue_Term__c where Opportunity_Line_Item_id__c=:createdOppL.id LIMIT 1];
        //[SELECT Milestone__c, opportunity_line_item_id__r.revenue_stream__c,opportunity_line_item_id__r.Practice__c,Revenue_Date__c, Milestone_Amount__c 
         //             FROM Revenue_Term__c where Opportunity_item_id__c=:ApexPages.currentPage().getParameters().get('id')
        
        Test.startTest();
        // Test Visual force page       
        PageReference myVfPage = Page.oafDataPage;
        Test.setCurrentPage(myVfPage);
		ApexPages.currentPage().getParameters().put('id', createdOpp.id);
        //apexPages.currentPage().getparameters().put('Account.name',myTestOP.Account.name);

        // Test apex class
 		ApexPAges.StandardController sc = new ApexPages.StandardController(createdOpp);
        oafDataController testctrlr = new oafDataController(sc); 
        Test.stopTest();
        //testctrlr.Save();
    }

}