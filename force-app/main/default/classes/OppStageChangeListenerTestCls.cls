@istest
public class OppStageChangeListenerTestCls {
    
   static testMethod void validateOppStageChangeTrigger(){
    
        List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='OppStageChangeListenerTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages',   IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates',    IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates',   IS_ACTIVE__c=true);
        
        trigList.add(trigObj6);
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        insert trigList;
        
        Account nAcc = new Account(Name='IncentiveTestAccount',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='IncentiveTestAccount' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
        Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Caar',CurrencyIsoCode='USD',CloseDate=System.today(), contract_po_number__c='12345', contract_po_sign_date__c=System.today(),project_start_date__c=System.today()+30,project_end_date__c=System.today()+365, sales_channel__c='', StageName='Client Meeting', Amount=30000, Type='Existing Customer - New Business', Probability__c='100', Funnel_Code__c='L0' );
            System.debug('New Test Revenue Opportunity :' + nOpp);
            upsert nOpp;
            Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Caar' LIMIT 1];
            System.debug('Test Opportunity Revenue Created' + createdOpp);
       
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='DIGITAL JOURNEY MGMT', Competency__c='CueTrans', product__c='CueTrans', Revenue_Stream__c ='AMC SUPPORT',  Project_Category__c='Onsite', Project_Type__c='Fixed Bid', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
        
                    System.debug('New Test Revenue Opportunity Line :' + nOppLn);
                    insert nOppLn;
                    List<opportunity_line_item__c> myTestOL = [SELECT id,name From opportunity_line_item__c where Total_Value__c=30000 and Pillar__c='Huringa' and Practice__c='PULSE'];
                    System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
                 for(opportunity_line_item__c insertedOppLn : myTestOL){
                    Revenue_Term__c nRt1  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=500,Revenue_Date__c=System.today()-120, Recognized_Amount__c= 1000);
                   
                     List<Revenue_Term__c> toInsertList = new List<Revenue_Term__c>();
                    
                        toInsertList.add(nRt1);
                       insert toInsertList;
                 }  
            
            Opportunity toUpdateOpp = new Opportunity();
            toUpdateOpp.id = createdOpp.id;
            toUpdateOpp.StageName = 'Proposal Submission';
            toUpdateOpp.CloseDate = System.today()+10;
            System.debug('Test Opportunity to update' + toUpdateOpp);
            update toUpdateOpp;
            Opportunity updatedOpp = [SELECT id, StageName From Opportunity WHERE Name='Tesla-Caar' LIMIT 1];
            System.debug('Test Opportunity after udpate update ' + updatedOpp);
                 
    }   
      

}