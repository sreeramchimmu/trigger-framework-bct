/**
* Trigger Name : OpportunityTrigger
*
* Author	   : Sreeram Venkatesan
*
* Date Created : 14th Dec 2020
*
* Purpose      : BillingTermTriggerHelper is the Helper class for BillingTerm trigger
*  
*/
public class BillingTermTriggerHelper{ 
       
    //below method is for validation purpose on billing term object when sum of billing term record's amount increases greater than Opportunity Line item's total value while inserting a Billing term
    public static void billingTermBeforeInsert(List<Billing_term__c> newItems){
        
        Set<Id> setIds = new Set<Id>();    
		double line_total_value = 0;
        double newValue = 0;        
        double billing_total_value; 
        
        for(Billing_term__c te : newItems){           
            setIds.add(te.Opportunity_Line_Item_id__c);           
        }        
        
        Map<Id, Opportunity_Line_Item__c> oliMap = new Map<Id, Opportunity_Line_Item__c>(
            [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where id IN :setIds]
        );        
        
        List<Billing_Term__c> billing_tot_value = [SELECT Id, Opportunity_Line_Item_id__c, Amount__c FROM Billing_Term__c where Opportunity_Line_Item_id__c IN :setIds];	  
        
        for(Billing_Term__c bll : newItems){
            
            billing_total_value = 0;            
            line_total_value = oliMap.get(bll.Opportunity_Line_Item_id__c).Total_Value__c;
            newValue = bll.Amount__c;
            
            for(Billing_Term__c  billing_value : billing_tot_value){
                if(oliMap.get(bll.Opportunity_Line_Item_id__c).id == billing_value.Opportunity_Line_Item_id__c){
                 	billing_total_value = billing_total_value + billing_value.Amount__c;   
                }				
			}
            
            billing_total_value = billing_total_value + newValue;
            
            if(billing_total_value > line_total_value){
                bll.addError(System.Label.Milestone_must_not_exceed);	
            }
        }
    }
    
    public static void billingTermBeforeUpdate(List<Billing_term__c> newItems, Map<Id, Billing_term__c> oldItems){
        
        Set<Id> setIds = new Set<Id>();    
        Set<Id> setBillIds = new Set<Id>(); 
		double line_total_value = 0;
        double newValue = 0;        
        double billing_total_value; 
        
        for(Billing_term__c te : newItems){          
            setIds.add(te.Opportunity_Line_Item_id__c);
            setBillIds.add(te.ID);           
        }
        
        Map<Id, Opportunity_Line_Item__c> oliMap = new Map<Id, Opportunity_Line_Item__c>(
            [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where id IN :setIds]
        );
         
        List<Billing_Term__c> billing_tot_value = [SELECT Id, Opportunity_Line_Item_id__c, Amount__c FROM Billing_Term__c where Opportunity_Line_Item_id__c IN :setIds AND Id != :setBillIds];		
        
        for(Billing_Term__c bll : newItems){
            
            billing_total_value = 0;            
            line_total_value = oliMap.get(bll.Opportunity_Line_Item_id__c).Total_Value__c;
            newValue = bll.Amount__c;
            
           		
            for(Billing_Term__c  billing_value : billing_tot_value){
                if(oliMap.get(bll.Opportunity_Line_Item_id__c).id == billing_value.Opportunity_Line_Item_id__c){
                 	billing_total_value = billing_total_value + billing_value.Amount__c;   
                }				
			}
            
            billing_total_value = billing_total_value + newValue;
               
            if(billing_total_value > line_total_value){
                bll.addError(System.Label.Milestone_must_not_exceed);	
            }
        } 
    }

    //below method is for shifting billing dates in billings term records of a line item based on the updating billing term record
    public static  void billingTermAfterUpdate(Map<Id, Billing_term__c> newItems, Map<Id, Billing_term__c> oldItems){        
        
        List<Id> billTermIds = new List<Id>();
        
        boolean isSubsequentSelected = false;
        date oldBillingdate;
        date newBillingdate;
        integer billTermCycle = 30;
        List<Billing_Term__c> BillTermListToUpdate = new List<Billing_Term__c>();  
          
        for (Billing_Term__c newbillTerm : newItems.values()){  
               if(newbillTerm.Shift_subsequent_milestone_dates__c== true){
                    isSubsequentSelected =  true;
                    break;
              } 
        }
        
        if(isSubsequentSelected){
              for (Billing_Term__c newBillTerm : newItems.values()){
                
                  	billTermIds.add(newbillTerm.Opportunity_Line_Item_id__c);
                    newBillingdate = newBillTerm.billing_date__c;
                   
                    oldBillingdate =  oldItems.get(newBillTerm.ID).billing_date__c; 
                      if(newBillTerm.Billing_Term__c.containsIgnoreCase('30')){
                             billTermCycle = 30;
                      }else if (newBillTerm.Billing_Term__c.containsIgnoreCase('45')){
                           billTermCycle = 45;
                      }else if(newBillTerm.Billing_Term__c.containsIgnoreCase('60')){
                           billTermCycle = 60;
                      }else if(newBillTerm.Billing_Term__c.containsIgnoreCase('90')){
                           billTermCycle = 90;
                      }
              } 
            
            List<Billing_Term__c> BillTermList = [select line_id__c, Billing_Date__c  from Billing_term__c where (Opportunity_Line_Item_id__c IN :billTermIds AND billing_date__c >=:oldBillingdate) OR (Opportunity_Line_Item_id__c IN :billTermIds AND billing_date__c =: newBillingdate)];
           
            if(null != BillTermList.size() && BillTermList.size() >0){           
             
                for(Billing_Term__c billTerm1 : newItems.values()){
  
                   Date tempDate = billTerm1.Billing_Date__c;
                    
                   for(Billing_Term__c billTerm : BillTermList){
                  
                      if(billTerm.line_id__c == billTerm1.line_id__c){
                          
                          billTerm.Shift_subsequent_milestone_dates__c = false;
                          billTerm.Change_Reason__c = billTerm1.Change_Reason__c;
                          BillTermListToUpdate.add(billTerm);
                      }
                      else{          
                        
                          billTerm.Billing_Date__c = tempDate + billTermCycle ;
                          billTerm.Change_Reason__c = billTerm1.Change_Reason__c;
                          tempDate = billTerm.Billing_Date__c;
                         
                          BillTermListToUpdate.add(billTerm);
                      }
                  }
                    
                }
                 
              }
            
            if(BillTermListToUpdate.size() > 0){          
                  try{
                      update BillTermListToUpdate;
                  }
                  catch(DMLexception dmle){ 
                      HandleCustomException.LogException(dmle);
                  }              
              }
          }
    }
}