@isTest
public class IncentiveQualifierTestCls {
    
    Static testmethod void ManageIncentiveQualifier (){
     List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='BillingSplitValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='RevenueSplitValueCheckTrigger',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='shiftSubsequentRevDates',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='QuotaVsActual',   IS_ACTIVE__c=true);  
        TriggerSwitch__c trigObj7 = new TriggerSwitch__c(Name='updateLineItemStages',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj8 = new TriggerSwitch__c(Name='OppTotalLineItemsValueCheckTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj9 = new TriggerSwitch__c(Name='OppStageChangeListenerTrigger',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj10 = new TriggerSwitch__c(Name='QVAOwnerChange',  IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj11 = new TriggerSwitch__c(Name='IncentiveQualifierManageTrigger',  IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
        trigList.add(trigObj6);
        trigList.add(trigObj7);
        trigList.add(trigObj8);
        trigList.add(trigObj9);
        trigList.add(trigObj10);
        trigList.add(trigObj11);
        
         insert trigList;
        
        
         //create Quota Master
        
        QuotaMasterNew__c quotaMst = new QuotaMasterNew__c (SBU__c = '101-IND');
        insert quotaMst;
        QuotaMasterNew__c createQuotaMst = [select id,SBU__c from QuotaMasterNew__c where id = :quotaMst.id];
 
       // create Quotadetail
       QuotaDetail__c quotaDet =  new QuotaDetail__c (Quota_Amount__c = 1000,QuotaMasterNew__c =createQuotaMst.id);
           insert quotaDet;
        QuotaDetail__c createquotaDet = [SELECT Id, Quota_Amount__c, QuotaMasterNew__c FROM QuotaDetail__c where id =:quotaDet.id];
        
        
        Account newAcc = new Account(Name='Incentive Qualifier Acc',SBU__c='101-IND',CurrencyIsoCode ='INR');
        insert newAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='Incentive Qualifier Acc' LIMIT 1];
         
        // Create opportunity
        Opportunity newOpp = new Opportunity(Accountid=createdAcc.id, Name='Incentive Qualifier Opp',CloseDate=System.today(),StageName='Lead Identification',Amount=30000);
        insert newOpp;
        opportunity createdOpp = [SELECT id, name, amount From opportunity WHERE Name='Incentive Qualifier Opp'];
                
        // Create Opportunity Line item
        
        opportunity_line_item__c newOpl = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='Asymmetrix', Practice__c='Asymmetrix', Competency__c='Asymmetrix', product__c='Asymmetrix', Revenue_Stream__c ='AMC SUPPORT', Project_Type__c='Fixed Bid', Project_Category__c='Onsite', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
     
        insert newOpl;
        opportunity_line_item__c createdOppl = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :newOpl.id ];
        
        Revenue_Term__c revTerm  = new Revenue_Term__c( Opportunity_Line_Item_id__c=createdOppl.id, Milestone__c='AMC Support',Percentage__c=1000,Revenue_Date__c=System.today());
         			insert revTerm;
        Revenue_Term__c createRev = [select id,Milestone__c from Revenue_Term__c where id = :revTerm.id  ];
        
        opportunity_line_item__c createdOppl1 = [SELECT id,Opportunity_ID__c,Total_Value__c From opportunity_line_item__c where id = :createdOppl.id ];
        createdOppl1.Incentive_Qualifier__c = 'SI Products';
        createdOppl1.Pillar__c ='Retina';
        createdOppl1.Product__c ='Retina';
        createdOppl1.Competency__c ='Retina'; 
        update createdOppl1 ;
        
        //Create Revenue term
        
       
        // Create Actual details
        
        Actual_Detail__c actDet = new Actual_Detail__c (RevenueTermRef__c = createRev.id,UpdateStagesRandomNo__c = 123325,QuotaDetail__c = createquotaDet.Id);
        insert actDet;
        
        Actual_Detail__c createactDet = [select id,UpdateStagesRandomNo__c from Actual_Detail__c where id = :actDet.id];
        
        if(newOpl.Incentive_Qualifier__c == 'SI Products'){
			createactDet.UpdateStagesRandomNo__c = math.random();
        
            update actDet ;

        }
    }
}