trigger OppTotalValueCheckTrigger on Opportunity_Line_Item__c (before insert, before update,after delete, after update){
 
     
boolean isActive = false;
 List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='OppTotalValueCheckTrigger' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings){
        isActive = true;
    }
    if(isActive){
          system.debug('OppTotalValueCheckTrigger Trigger is ACTIVE');
          List<actual_detail__c > actualObjToUpdate = new List<actual_detail__c>();
    if (trigger.isBefore)
    {
        double m = 0;
        double newValue=0;
        double Line_total_value=0;
        //m=SELECT opportunity_id__r.Amount FROM Opportunity_Line_item__c where id = '0062800000AIk9a';
       /* for (opportunity_line_item__c opl_value : trigger.new)
        {
          List<Opportunity> opp_tot_value_m = [SELECT Amount,line_item_total__c,stageName FROM Opportunity where id = :opl_value.Opportunity_ID__c];
          system.debug('New value is :'+opl_value.total_value__c);
          newValue = opl_value.total_value__c;
          for(Opportunity opp_Value : opp_tot_value_m)
           {
             m = opp_Value.Amount;
             string mStageName = opp_value.StageName;
             
             if (trigger.isInsert)
             {
               double var;
               var=validate_total_opp_value.dataInsert(trigger.new);
               Line_total_value = var + newValue;
               system.debug('Return Value is :'+var+ ' and total Opp value is :'+m + ' Line Total :'+Line_total_value);
               // Check with Opportunity Master value with Line Item Value
               if (Line_total_value > m) 
               {
                opl_value.addError('Insert Line Value is more than the Balance Value !!');
               }
              else
              {
              opp_value.line_item_total__c = Line_total_value;
              opl_value.stage__c = opp_value.StageName;
              //
              update opp_value;
               }
             }
             // Update trigger 
             if (trigger.isUpdate)
             {
             //  if (opp_value.StageName == opl_value.stage__c)
              // {
               double var1=0;
               var1=validate_total_opp_value.dataUpdate(trigger.new);
               system.debug('Var1 return value is '+var1);
               if (var1 > 0)
               {
                opp_value.line_item_total__c=opp_value.line_item_total__c-var1;
                system.debug('Var1 return value is after adding var1>0 '+var1);
                update opp_value;
               }
               else
               { 
                system.debug('Opportunity.line_item_total__c ;'+opp_value.line_item_total__c);
                system.debug('Opportunity Amount'+opp_Value.amount);
                if(null == opp_value.line_item_total__c){
                  opp_value.line_item_total__c = opp_Value.amount;  
                  Opportunity oppObj = new Opportunity();
                    oppObj = opp_value;
                    oppObj.line_item_total__c = opp_Value.amount;
                    system.debug('Equating Opp_value list to new obj '+oppObj);
                    list<Opportunity> oppToUpdate = new  list<Opportunity>();
                    oppToUpdate.add(oppObj);
                    system.debug('new opportunity obj to update '+oppToUpdate);
                    update oppToUpdate;
                }else{
                system.debug('Trigger Opp total check -- Printing Var 1 :'+var1);
                opp_value.line_item_total__c=opp_value.line_item_total__c-var1;
                    update opp_value;
                }
                system.debug('After Opportunity.line_item_total__c'+opp_value.line_item_total__c);
                
                system.debug('line Before updating Opportunity line item total value in opp obj'+opp_value);
                
                //opl_value.addError('Update Line Value is more than the Balance Value !!');
               }
             // }
              //else
               //opl_value.addError('You can not change different stage record!!'); 
             }
               
            }
             
         }*/
    }
        
        /*
         * This part of code executes after update on opporutnity line when the Incentive qualifier is modified.
         * This will update the respective revenue term's corresponding Actual detail obj rows , 
         * and the process builder will udpate the respective incentive revenue
         * 
         */
        
  if(trigger.isAfter && trigger.isUpdate)
    {
        system.debug('In Opp Line incentive trigger after update event ');
        
         for (opportunity_line_item__c newOppLine : trigger.new)
        {
            
            Opportunity_line_Item__c oldOppLine = Trigger.oldMap.get(newOppLine.Id);
            if(null != oldOppLine && null != oldOppLine.Incentive_Qualifier__c){
                if(!(oldOppLine.Incentive_Qualifier__c.equals(newOppLine.Incentive_Qualifier__c))){
                    system.debug('Opportunity Line incentive qualifier Changed from : ' + oldOppLine.Incentive_Qualifier__c +'--New Stage : '+newOppLine.Incentive_Qualifier__c);
                    Revenue_Term__c[] revenueList = [SELECT id FROM Revenue_Term__c WHERE Opportunity_line_item_id__c =:newOppLine.id];
                            system.debug('Opportunity Line incentive Changed- So does the revenue : ' + revenueList);
                          if(null != revenueList && revenueList.size() > 0){
                              Actual_Detail__c[] actDet = [Select id,UpdateStagesRandomNo__c from actual_detail__c where revenuetermref__c in :revenueList];
                              if(null != actDet && actDet.size() > 0){
                                  for(Actual_Detail__c eachactDet : actDet){
                                      eachactDet.UpdateStagesRandomNo__c = math.random();
                                      actualObjToUpdate.add(eachactDet);
                                  }
                              }
                          } 
                        }
                    }
                  
           }
    }
        
        
        if(null != actualObjToUpdate && actualObjToUpdate.size() > 0){
            try{
                System.debug('Updating Actual Object from Opp Line trigger.....' + actualObjToUpdate);
                   update actualObjToUpdate;
                 }
                 catch(DMLException dmle){
                 system.debug('Error while Updating Line item stages from opportunity trigger updateLineItemStages ::' + dmle); 
                 } 
        }
    
    }else{
        system.debug('OppTotalValueCheckTrigger Trigger is set to IN ACTIVE');
    }
    
}  
  
        
 /* if (trigger.isAfter)  
  {
      system.debug('Delete Press'+trigger.old);
      for (opportunity_line_item__c opl : trigger.old)
      {
        list<opportunity> opms = [SELECT Amount,line_item_total__c,stageName FROM Opportunity where id = :opl.Opportunity_ID__c];
          for (opportunity opm : opms)
           {
               system.debug('Opportunity value is '+opm.line_item_total__c);
               if (trigger.isDelete)
               {
                if (opl.stage__c == opm.StageName)
                {
                 opm.line_item_total__c = opm.Line_Item_Total__c-opl.Total_Value__c;
                 update opm;
                 system.debug(' Tirgger is Delete :');
                 // We have to substract the Opportunity_line_item deleted value from Opportunity Master data
                }
                else
                {
                    opl.addError('You can not delete the different stage record !!'); 
                }
                
                    
               }
           }
      }
  } */