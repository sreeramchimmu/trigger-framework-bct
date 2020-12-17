trigger updateLineItemStages on Opportunity (after update) 
{
 //boolean isActive = true;
 //id opID;
 public String opID;    
// public integer diffDays;
 boolean isActive = false; 
 public String mContactName{get;set;}
 public List<OpportunityContactRole> OpportunityContactRoleLst{get;set;}
 public List<Contact> ContactLst{get;set;}
 
 //static boolean updateDateOnce = true;    
 List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='updateLineItemStages' and IS_ACTIVE__c=true];
  for(TriggerSwitch__c trig : trgsettings)
   {
       isActive = true;
   }
   if(updateDateOnce.calledOnceflag == true)
   {
    // updateDateOnce.calledOnceflag = false;  
    if(isActive)
    {
    system.debug('updateLineItemStages Trigger is ACTIVE');
    if(trigger.isAfter)  
     {
       if(trigger.isUpdate)
       {
          List<Opportunity> oppUpdateList = new List <Opportunity>();
          List<Opportunity_line_item__c> oplineToUpdateList = new List<Opportunity_line_item__c>();
          List<Revenue_Term__c> revenueToUpdateList = new List<Revenue_Term__c>();  
          List<Billing_Term__c> billToUpdateList = new List<Billing_Term__c>(); 
          List<Opportunity> OPM = trigger.new;
          for (Opportunity  newOpp : trigger.new)  
          {
              Opportunity oldOpp = Trigger.oldMap.get(newOpp.Id); 
              system.debug('Old Close date :'+oldOpp.CloseDate + ' New Close date :'+newOpp.CloseDate);
              date oldCloseDate = oldOpp.CloseDate; 
              date newCloseDate = newOpp.CloseDate;
              system.debug('Revenue Term Close date update Started '+newOpp.id+' Old Op id '+oldOpp.id);
              Integer diffDays = oldCloseDate.daysBetween(newOpp.CloseDate);
              //Added on 2018-Feb-15 For Contact Name display in Opportunity
              //Select Id, Name From Contact Where AccountId In (Select AccountId From Opportunity Where Id=:oppId) LIMIT 1
              OpportunityContactRoleLst = [select ContactId from OpportunityContactRole where OpportunityId = :newOpp.Id and IsPrimary = TRUE];
              for(OpportunityContactRole OpContactRole : OpportunityContactRoleLst)
              {
                String mContacid =  OpContactRole.ContactId;
                ContactLst = [Select Name from Contact where id = :mContacid]; 
                for(Contact Contacts : ContactLst)
                {
                  mContactName = Contacts.Name;
                }
              }
              //Done for the day 2018-Feb-15 
              String oppStage = newOpp.StageName;
              date oppCloseDate = newOpp.CloseDate;
              //Updating SubmitForApproval Key 
              double submitKey = newOpp.SubmitForApproval__c;
              //Opportunity[] oppList =[SELECT Id, Name, Contact_Name__c, SubmitForApproval__c,Line_Balance_Amount__c FROM Opportunity where id =:newOpp.id];
              Opportunity[] oppList =[SELECT Id, Name, Contact_Name__c, SubmitForApproval__c FROM Opportunity where id =:newOpp.id];
              for(Opportunity oppItem : oppList )
              {
              oppItem.SubmitForApproval__c = submitKey;
              oppItem.Contact_Name__c = mContactName;
              //Added on 19-Feb-2018 for Direct Proposal entry to handle
              if(oppItem.Line_Balance_Amount__c>0)
              {
                oppItem.IntegratedWCosting__c=True;
              }
              ///Completed on 19-Feb-2018
              oppUpdateList.add(oppItem);
              }
              Opportunity_Line_Item__c[] oppLineList2 = [SELECT ID FROM Opportunity_Line_Item__c WHERE Opportunity_ID__c IN :Trigger.new];
              for(Opportunity_Line_Item__c oppLineItem2 : oppLineList2)
              {
               // Added to update SalesStage__c
               oppLineItem2.Op_ContactName__c =  mcontactName;
               //oppLineItem2.IntegratedWCosting__c=True; 
               oplineToUpdateList.add(oppLineItem2); 
              // Block For Opportunity Close date shift respective Billing and Revenue date shift 
              if ((oldOpp.CloseDate != newOpp.CloseDate) && (newOpp.StageName != 'Closed Won' && newopp.StageName !='Contract Extension'))
              {  
                Revenue_Term__c[] revenueList = [SELECT id,name, Revenue_date__c,amount__c,Change_Reason__c,revenue_term__c FROM Revenue_Term__c WHERE Opportunity_line_item_id__c = :oppLineItem2.id];
                Billing_Term__c[] billList = [SELECT id,name, Billing_date__c,amount__c,Change_Reason__c,Billing_term__c FROM Billing_Term__c WHERE Opportunity_line_item_id__c = :oppLineItem2.id];
                system.debug('Closed date sleep to '+diffDays);
                integer revenueTermDays=0;
                // Revenue Term Records
                for(Revenue_Term__c RevenueDate2Update : revenueList)
                {
                    revenueTermDays = diffDays;
                    system.debug('Difference days Between old and new close date are -> '+revenueTermDays);
                    RevenueDate2Update.Revenue_date__c = RevenueDate2Update.Revenue_date__c + revenueTermDays;
                    date revenueDate = RevenueDate2Update.Revenue_date__c;
                    if(RevenueDate2Update.Change_Reason__c != null)
                    {
                    RevenueDate2Update.Change_Reason__c = RevenueDate2Update.Change_Reason__c+ '; Date shifted due to Opp.Close date changed from '+oldCloseDate +' To '+newCloseDate;    
                    }
                    else
                    {
                    RevenueDate2Update.Change_Reason__c = 'Date shifted due to Opp.Close date changed from '+oldCloseDate +' To '+newCloseDate;    
                    }
                    system.debug('Revenue Term to update details are  -  ' + revenueDate);
                    revenueToUpdateList.add(RevenueDate2Update);
                 }
                 // For Billing Term Records
                integer billTermDays = 0;
                for(Billing_Term__c BillDate2Update : BillList)
                {
                    billTermDays = diffDays;
                    system.debug('Difference days Between old and new close date are Billing_term__c-> '+billTermDays);
                    BillDate2Update.Billing_date__c = BillDate2Update.Billing_date__c + billTermDays;
                    date BillingDate = BillDate2Update.Billing_date__c;
                    if(BillDate2Update.Change_Reason__c != null)
                    {
                    BillDate2Update.Change_Reason__c = BillDate2Update.Change_Reason__c+ '; Date shifted due to Opp.Close date changed from '+oldCloseDate +' To '+newCloseDate;    
                    }
                    else
                    {
                    BillDate2Update.Change_Reason__c = 'Date shifted due to Opp.Close date changed from '+oldCloseDate +' To '+newCloseDate;    
                    }
                    billToUpdateList.add(BillDate2Update);
                }
               }
               //- Block end For Billing and Revenue date updation
             }  
          }
           if(oppUpdateList.size() > 0)
            {
             try{
                 system.debug('Updation completed in Opportunity object'); 
                     update oppUpdateList;
                 }
                 catch(DMLException dmle){
                 system.debug('Error while Updating Opportunity object from opportunity trigger updateLineItemStages ::' + dmle); 
                 }
            }
           if(oplineToUpdateList.size() > 0)
            {
             try{
                 system.debug('Updation completed in Opportunity Line Item object'); 
                    update oplineToUpdateList;
                 }
                 catch(DMLException dmle){
                 system.debug('Error while Updating Opportunity Line object from opportunity trigger updateLineItemStages ::' + dmle); 
                 }
            }
           
            if(revenueToUpdateList.size() > 0)
            {
             try{
                 system.debug('Updation completed in revenue object'); 
                     update revenueToUpdateList;
                 }
                 catch(DMLException dmle){
                 system.debug('Error while Updating Revenue date in Revenue object from opportunity trigger updateLineItemStages ::' + dmle);
                  for (Opportunity opp: Trigger.New) {
                     opp.addError('Opportunity date can not be changed due to some error in related object -> '+dmle.getDMLMessage(0));
                  }
                 }
             }
             if(billToUpdateList.size() > 0)
             {
             try{
                 system.debug('Updation completed in revenue object'); 
                 update billToUpdateList;
                 }
                 catch(DMLException dmle){
                 system.debug('Error while Updating Revenue date in Revenue object from opportunity trigger updateLineItemStages ::' + dmle); 
                for (Opportunity opp: Trigger.New) {
                      opp.addError('Opportunity date can not be changed due to some error in related object -> '+dmle.getDMLMessage(0));
                  }
                 }
             }
          }
      
     }
  }else
  {
    system.debug('updateLineItemStages Trigger is set to IN ACTIVE');
  }
 }
}