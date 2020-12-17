trigger Milestone_Amount_Update on Billing_Term__c(before insert,before update,after delete) 
{
 for (Billing_Term__c newBillObject : trigger.new)
 {
 List<Billing_Term__c> listBillingTerm = [select Amount__c,Milestone_basis__c,percentage__c from Billing_term__c where id = :newBillObject.id];
 double diffAmount = 0;
 for (Billing_Term__c BillToUpdate : listBillingTerm)
 {
// Opportunity_line_item__c Opli = [select Billing_Term_Balance_amount__c from Opportunity_line_item__c  where id = :trigger.new.Opportunity_Line_Item_id__c];
 //double oppli_balance_amount = [select Opportunity_Line_Item_id__r.Billing_Term_Balance_amount__c from Billing_Term__c  where Opportunity_Line_Item_id__c = :trigger.new.id]; 
 if (Trigger.isBefore)
 {
  if (Trigger.isInsert)
  system.debug('Goutam I am in Before and insert trigger');
  {
   newBillObject.Milestone_Amount__c=newBillObject.Amount__c; 
  }
 
 
 
 
  if (Trigger.isUpdate)
  {
  System.debug('Goutam I am in Update Trigger');
  {
  
   if (newBillObject.Amount__c > BillToUpdate.Amount__c)
   {
    diffAmount = newBillObject.Amount__c - BillToUpdate.Amount__c;
    newBillObject.Milestone_Amount__c=newBillObject.Amount__c + diffAmount; 
   }
   else
   {
    diffAmount =  BillToUpdate.Amount__c - newBillObject.Amount__c;
    newBillObject.Milestone_Amount__c=newBillObject.Amount__c-diffAmount;
   }
  }
  /* 
  // For Insert Record
  if (Trigger.isInsert)
  {
   if (BillToUpdate.Milestone_Basis__c=='%')
   {
    newBillObject.Milestone_Amount__c=newBillObject.Opportunity_Line_Item_id__r.Total_Value__c  *  (newBillObject.Percentage__c/100);
    }
   else
   {
    newBillObject.Milestone_Amount__c=newBillObject.Percentage__c;
   }
   newBillObject.Milestone_Amount__c = newBillObject.Amount__c;   
  }
  //
  */
   update listBillingTerm;
  }
 }
 }
 }
}