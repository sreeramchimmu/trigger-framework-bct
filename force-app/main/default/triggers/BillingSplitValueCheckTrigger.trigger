trigger BillingSplitValueCheckTrigger on Billing_Term__c (before insert,before update) {

double line_total_value = 0;
double newValue = 0;
double billing_total_value = 0;
double new_billing_value = 0;
boolean isActive = false; 

List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='BillingSplitValueCheckTrigger' and IS_ACTIVE__c=true];
for(TriggerSwitch__c trig : trgsettings)
{
       isActive = true;
}    
  
if(isActive)
 { 
    List <Billing_Term__c> bill_value = Trigger.new;
    if(trigger.isbefore)
    {
        List<opportunity_line_item__c> opp_total_value = [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where id = :bill_value[0].Opportunity_Line_Item_id__c];
        for (opportunity_line_item__c  opl_value : opp_total_value)
        {
        line_total_value = opl_value.Total_Value__c ;
        system.debug('value of opportunity line item '+line_total_value);
        }

        if(trigger.isinsert)
        {
            newValue = bill_value[0].Amount__c;
            system.debug('amount of billing value'+newValue );
            List <Billing_Term__c> billing_tot_value = [SELECT Id, Opportunity_Line_Item_id__c, Amount__c FROM Billing_Term__c where Opportunity_Line_Item_id__c =:bill_value[0].Opportunity_Line_Item_id__c ];
            for( Billing_Term__c  billing_value : billing_tot_value)
            {
            billing_total_value = billing_total_value + billing_value.Amount__c;
            }
            billing_total_value = billing_total_value + newValue ;
            system.debug('Total value of billong amount'+billing_total_value);
            if(billing_total_value > line_total_value )
            {
                bill_value[0].addError('Milestone Amount should not exceed the Opportunity Line value!!');
    
            }       
        }
      if(trigger.isupdate) 
      {
        List <Billing_Term__c> bill_value_old = Trigger.new;
        List <Billing_Term__c> billingIds = [SELECT Id, Opportunity_Line_Item_id__c, Amount__c FROM Billing_Term__c where Opportunity_Line_Item_id__c =:bill_value_old[0].Opportunity_Line_Item_id__c and Id != :bill_value_old[0].Id ];
        for(Billing_Term__c  billIds : billingIds )
        {
            billing_total_value = billing_total_value + billIds.Amount__c;
        }
        new_billing_value = bill_value[0].Amount__c + billing_total_value ;
        if(new_billing_value > line_total_value )
        {
            bill_value[0].addError('Milestone Amount should not exceed the Opportunity Line value!!');
        }
      }
    }
   }
   else
   {
      system.debug('BillingSplitValueCheck Trigger is set to IN ACTIVE');
   }
}