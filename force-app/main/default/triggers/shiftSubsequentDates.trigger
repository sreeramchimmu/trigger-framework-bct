trigger shiftSubsequentDates on Billing_Term__c (after update ) {
    system.debug('Entered shiftSubsequentDates Trigger on Billing_Term__c');
boolean isActive = false;
    boolean isSubsequentSelected = false;
          for (Billing_Term__c newbillTerm : trigger.new){
              if(newbillTerm.Shift_subsequent_milestone_dates__c== true){
                  isSubsequentSelected =  true;
                  break;
              }
              
          }
    
    if(trigger.isAFter){
            if(trigger.isUpdate){
                 system.debug('shiftSubsequent  Dates Trigger  old size'+trigger.old.size());
                 system.debug('shiftSubsequent Billing Dates Trigger new size'+trigger.new.size());
                if(isSubsequentSelected){
                List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='shiftSubsequentDates' and IS_ACTIVE__c=true];
                system.debug('shiftSubsequentDates Trigger Check query executed');
                for(TriggerSwitch__c trig : trgsettings){
                    isActive = true;
                }
    if(isActive)  { 
        
                date oldBillingdate;
                integer billTermCycle = 30;
                List<Billing_Term__c> BillTermListToUpdate = new List<Billing_Term__c>();
        
        for (Billing_Term__c newBillTerm : trigger.new){
                  system.debug('Trigger Activated ');
                  system.debug('Trigger New Value :'+ newBillTerm.line_id__c);
        if(newBillTerm.Shift_subsequent_milestone_dates__c == true){
            for (Billing_Term__c oldBillTerm : trigger.old){
                    oldBillingdate = oldBillTerm.billing_date__c;
                }
                      
        if(newBillTerm.Billing_Term__c.containsIgnoreCase('30')){
               billTermCycle = 30;
        }else if (newBillTerm.Billing_Term__c.containsIgnoreCase('45')){
             billTermCycle = 45;
        }else if(newBillTerm.Billing_Term__c.containsIgnoreCase('60')){
             billTermCycle = 60;
        }else if(newBillTerm.Billing_Term__c.containsIgnoreCase('90')){
             billTermCycle = 90;
        }
    
      
           system.debug('Trigger Activated');
           system.debug('New Values with subsequent option selected :'+ newBillTerm.line_id__c + 'Old Billing date : '+oldBillingdate + 'New Billing Date : '+ newBillTerm.billing_date__c );
           system.debug('select line_id__c, Billing_Date__c  from Billing_term__c where Opportunity_Line_Item_id__c='+newBillTerm.Opportunity_Line_Item_id__c+' AND billing_date__c >= '+ oldBillingdate );
           List<Billing_Term__c> BillTermList = [select line_id__c, Billing_Date__c  from Billing_term__c where (Opportunity_Line_Item_id__c= :newBillTerm.Opportunity_Line_Item_id__c AND billing_date__c >=:oldBillingdate) OR (Opportunity_Line_Item_id__c= :newBillTerm.Opportunity_Line_Item_id__c AND billing_date__c =: newBillTerm.billing_date__c) ];
           system.debug('No of BillTermList to shift date(size)--->:'+ BillTermList.size());
            system.debug('BillTermList --->:'+ BillTermList);
           if(null != BillTermList.size() && BillTermList.size() >0){
           
           Date tempDate = newBillTerm.Billing_Date__c;
           
               for(Billing_Term__c billTerm : BillTermList){
                
                if(billTerm.line_id__c == newBillTerm.line_id__c){
                    system.debug('Updating Shift_subsequent_milestone_dates__c as FALSE' + newBillTerm.Name  );
                    billTerm.Shift_subsequent_milestone_dates__c = false;
                    billTerm.Change_Reason__c = newBillTerm.Change_Reason__c;
                    BillTermListToUpdate.add(billTerm);
                
                    }else{          
                    system.debug('Adding subsequent milestones in list:'+ billTerm );
                    billTerm.Billing_Date__c = tempDate + billTermCycle ;
                    billTerm.Change_Reason__c = newBillTerm.Change_Reason__c;
                    tempDate = billTerm.Billing_Date__c;
                    system.debug('New bill ter reason for subseq list:'+ billTerm );
                    BillTermListToUpdate.add(billTerm);
                    }
                }
            
            }
        }
        
    }
    
    if(BillTermListToUpdate.size() > 0){
        
        try{
         system.debug('Updating Subsequent Billing dates' + BillTermListToUpdate);
         update BillTermListToUpdate;
        }
        Catch(DMLexception dmle){
            system.debug('Error while Updating Subsequent Billing dates' + dmle); 
          //  trigger.new[1].addError('Please provide reason for change in milestone details');
            
        }
    
    }
    }
   }
  }
}else{
        system.debug('shiftSubsequentDates Trigger is set to IN ACTIVE');
    }
}