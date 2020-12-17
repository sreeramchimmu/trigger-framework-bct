public class MultiLineEditRevenueTerm {

  
    public Integer balanceAmt {get;set;}
    public String oppLineStage {get;set;}
    public String oppStageCode {get;set;}
    public decimal cogspercentage {get;set;}
  
	public List<innerClass> innerRwlst
	{	get;set;	}
    
	public String selectedRowIndex
	{get;set;}

	public Integer count = 0;
    Integer availableLineAmt;
    String lineCurrency;
    Id parId ;

    innerClass InnerClsObj; 
	String revMilestone;
    Date milestoneDt;
    Integer revBalancedAmt;


    public MultiLineEditRevenueTerm(ApexPages.StandardController ctlr)
	{
        list<Revenue_Term__c> RevenueTermList;
            
        innerRwlst = new List<innerClass>();
        selectedRowIndex = '0';
        
        RevenueTermList = [SELECT Id, Opportunity_line_item_id__c,Milestone__c, Percentage__c, Split_days__c, Milestone_Basis__c, Revenue_Date__c,CurrencyIsoCode  FROM Revenue_Term__c where id = :ApexPages.currentPage().getParameters().get('id')];
        for(Revenue_Term__c rt :RevenueTermList){
            parId = rt.Opportunity_line_item_id__c;
            milestoneDt  = Date.valueOf(rt.Revenue_Date__c);
            lineCurrency = String.valueOf(rt.CurrencyIsoCode);
            revMilestone = String.valueOf(rt.Milestone__c);
            
         
          System.debug('milestoneDt :'+ milestoneDt +   'lineCurrency : ' + lineCurrency + 'revMilestone : ' + revMilestone );
          }
     
     
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        	if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c,Cogs_Bctpl_percentage__c,CurrencyIsoCode from opportunity_line_item__c where id = :parId];

        }
        
        for(opportunity_line_item__c op: Opp_Line_Amount){

            balanceAmt = Integer.valueOf(op.Total_Value__c);
            revBalancedAmt = Integer.valueOf(op.Revenue_Term_balance_amount__c);
            oppLineStage = op.stageName__c;
            oppStageCode = op.Opportunity_ID__r.Funnel_Code__c;
          	cogspercentage = op.Cogs_Bctpl_percentage__c;
            System.debug('op.Total_Value__c :'+ op.Total_Value__c  +'revBalancedAmt'+ revBalancedAmt + 'balanceAmt : ' + balanceAmt + 'op.stageName__c : ' + op.stageName__c );
        }

        List<Revenue_Term__c> RevenueTermSplitList ;

        RevenueTermSplitList = [SELECT Id, Name,Percentage__c, Opportunity_line_item_id__c,Milestone_Basis__c,Amount__c,Recognized_Amount__c,Revenue_Date__c,Milestone__c,Change_Reason__c,Calculated_Amount__c,
                                Revenue_Term__c,Actual_COGS_BCTPL__c, Actual_COGS_Others__c, Actual_GM__c,Opportunity_line_item_id__r.Revenue_Term_balance_amount__c FROM Revenue_Term__c where Opportunity_line_item_id__c = :parId];
       
        if(null != RevenueTermSplitList && RevenueTermSplitList.size() > 0){
               system.debug('Revenue details Already existing. So fetching Revenue details');
              		
			  		fetchRevenueDetail(RevenueTermSplitList);
            	}
      
        
	}
  
    
   public class innerClass
	{		
		// recCount acts as a index for a row. This will be helpful to identify the row to be deleted 
		public String recCount
		{get;set;}
	
        public Revenue_Term__c rt 
		{get;set;}
		
		
		public innerClass(Integer intCount)
		{
			recCount = String.valueOf(intCount);		
 			 rt = new Revenue_Term__c();
		}
 
	}
    
    
    public void fetchRevenueDetail(List<Revenue_Term__c> rList){
       
         //  String tempMilestone_Basis = 'Fixed Amount';

        for(Revenue_Term__c revSplit: rList)
        			{	
                        //  system.debug('Before adding inner loop*****'+revSplit);
                      
                                InnerClsObj = new innerClass(count);
                                InnerClsObj.rt.Id = revSplit.Id;
                                InnerClsObj.rt.Revenue_Date__c = revSplit.Revenue_Date__c;
                                InnerClsObj.rt.Milestone__c = revSplit.Milestone__c;
                                InnerClsObj.rt.Percentage__c  = revSplit.Percentage__c;
                                InnerClsObj.rt.Recognized_Amount__c =revSplit.Recognized_Amount__c;
                                InnerClsObj.rt.Milestone_Basis__c= revSplit.Milestone_Basis__c;
                                InnerClsObj.rt.Actual_COGS_BCTPL__c =revSplit.Actual_COGS_BCTPL__c; 
                                InnerClsObj.rt.Actual_COGS_Others__c =revSplit.Actual_COGS_Others__c; 
                                InnerClsObj.rt.Actual_GM__c =revSplit.Actual_GM__c; 
                                InnerClsObj.rt.CurrencyIsoCode = lineCurrency;
                                InnerClsObj.rt.Change_Reason__c = revSplit.Change_Reason__c;
                                InnerClsObj.rt.Revenue_Term__c =  revSplit.Revenue_Term__c;
                                InnerClsObj.rt.Calculated_Amount__c = revBalancedAmt;
                                 system.debug('revenue balance amount*****'+ revBalancedAmt);                   
                        
                                innerRwlst.add(InnerClsObj);  

                                }
        	 	
        system.debug('Inner Row---->'+innerRwlst); 
           
   }
    
  
    
  public pageReference UpdateRecord()   
    {   
        
      List<Revenue_Term__c> revTermListUpdate =new List<Revenue_Term__c>();
      integer tmpRevAmt = 0;
    
      PageReference pr = new PageReference('/'+parId);
        
     //  system.debug('inner row list =====>'+innerRwlst +'inner row size==========>'+ innerRwlst.size());
   
       for(Integer j = 0;j<innerRwlst.size();j++)
		{
			revTermListUpdate.add(innerRwlst[j].rt);
		} 
       
     	
        if(revTermListUpdate.size() > 0) {
           // system.debug('Before updating revenue list---------->'+revTermListUpdate);
       		for(Revenue_Term__c tmp : revTermListUpdate){
              //system.debug('Opportunity line value ****'+tmp.Opportunity_line_item_id__r.Total_Value__c);
                system.debug('Value of Milestone amount/pecentage***'+ tmp.Percentage__c);
                system.debug('Calculated Value****'+tmp.Calculated_Amount__c);
                
                
         		if(tmp.Milestone_Basis__c == '%'){
                    
              tmpRevAmt = tmpRevAmt + Integer.valueOf(tmp.Calculated_Amount__c * tmp.Percentage__c / 100);                    
                    system.debug('temporary revenue amount -Percentage ****'+tmpRevAmt);
            	}else{
            		tmpRevAmt = tmpRevAmt + Integer.valueOf(tmp.Percentage__c);
                    
                     system.debug('temporary revenue amount -Fixed Amount ****'+tmpRevAmt);
            	}
                     
        }
          
        if(balanceAmt == tmpRevAmt){
         
            try{
                update revTermListUpdate;
            //    System.debug('After updating revenue List------------>'+revTermListUpdate);
                
            }catch(DMLException dmle){
                system.debug('DML Error during insert  ---->'+dmle);
               
                  ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to Create Revenue term record. Please contact administrator : ' + dmle.getMessage());
                  ApexPages.addMessage(myMsg1); 
               
                
                return null;
            }catch(Exception e){
                system.debug('Error during insert  ---->'+e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Unable to Create Revenue term record. Please contact administrator : ' + e.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
                
  		      return pr;
        }else{
            tmpRevAmt = 0;
             system.debug('Unable to save  ----> Resetting tmpRevAmt to zero');
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' The Sum of all splitted Revenue amounts should be equal to Opportunity Line Amount');
             system.debug('Unable to save  ---->'+errMsg);
			ApexPages.addMessage(errMsg);
            return null;
        }
    }else{
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' No records to save.');
             system.debug('Unable to save  ---->'+errMsg);
			ApexPages.addMessage(errMsg);
         return null;
    }
       
    }
      
    
    
     public pageReference navback(){
        
         PageReference pr = new PageReference('/'+parId);
        return pr;
        
    }   

  /* public void delMilestone(){
		try{
            if(count > 1){
			innerRwlst.remove(Integer.valueOf(selectedRowIndex));
            count = count -1;
            Integer thisInt = 0;
			for(innerClass n: innerRwlst){
                    n.recCount = thisInt.format();
                    thisInt++;
            	}
        }else{
             ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot remove milestone. Minimum one row required to save.');
             system.debug('Unable to save  ---->'+errMsg);
			 ApexPages.addMessage(errMsg);
        }
            
			}catch(Exception Ex){
				ApexPages.addMessages(Ex); 
		}
	}*/

   
   
}