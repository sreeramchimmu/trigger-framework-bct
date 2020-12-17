public class SplitBillingTerm {

    public SplitBillingTerm() {

    }
    
    public Integer balanceAmt {get;set;}
    public String oppLineStage {get;set;}
    public String oppStageCode {get;set;}
    public decimal cogspercentage {get;set;}
    
    public Integer count = 0;
    Integer availableLineAmt;
    String lineCurrency;
    Id parId ;
    Integer billtermcycle;
	innerClass InnerClsObj;
    String billTerm;
    String billMilestone ='';
 	Decimal oppBalAmount;
    
    public list<Billing_Term__c> listBilling_Term = new List<Billing_Term__c>();  
    Date temp = date.newInstance(2016, 10, 5);
    
	public List<innerClass> innerRwlst
	{	get;set;	}
    
    
	public String selectedRowIndex
	{get;set;}
    
    
    
    public SplitBillingTerm(ApexPages.StandardController ctlr)
	{
		system.debug('Conrtoller Class Constructor Called ---->');      
        String param_value1 = String.valueOf(ApexPages.currentPage().getParameters().get('fromDate').trim());
        String param_value2 = String.valueOf(ApexPages.currentPage().getParameters().get('noOfSplits').trim());
        String param_value3 = String.valueOf(ApexPages.currentPage().getParameters().get('srcId').trim());
        String param_value4 = String.valueOf(ApexPages.currentPage().getParameters().get('lncur').trim());
        String param_value5 = String.valueOf(ApexPages.currentPage().getParameters().get('btm').trim());
        String param_value6 = String.valueOf(ApexPages.currentPage().getParameters().get('bmst').trim());
        
        system.debug('Conrtoller Class Constructor Called 2 ---->'+param_value1 + '--'+ param_value2 +'---' + param_value3+'---' + param_value4);      
        Date milestoneDt  = Date.valueOf(param_value1);
        Integer noOfSplits = Integer.valueOf(param_value2);
        parId = Id.valueOf(param_value3);
        lineCurrency = String.valueOf(param_value4);
        billtermcycle = getBillTermDays(param_value5);
        billTerm = param_value5;
        billMilestone = param_value6;
        	system.debug('Printing Billing Term Milestone   ---->'+  billMilestone); 
        //Code for populating header section
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        	if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [SELECT Id, Total_Value__c, Billing_Term_balance_amount__c,name, StageName__c,Cogs_Bctpl_percentage__c, Opportunity_ID__r.Funnel_Code__c, CurrencyIsoCode FROM Opportunity_Line_Item__c where id = :parId];
        	system.debug('Printing Opp_Line_Amount query result   ---->'+  Opp_Line_Amount); 
        }
        
        for(opportunity_line_item__c op: Opp_Line_Amount){
            system.debug('Printing op.Billing_Term_Balance_amount__c '+ op.Billing_Term_Balance_amount__c); 
            balanceAmt = Integer.valueOf(op.Billing_Term_Balance_amount__c);
            oppLineStage = op.stageName__c;
            oppStageCode = op.Opportunity_ID__r.Funnel_Code__c;
            cogspercentage = op.Cogs_Bctpl_percentage__c;
            system.debug('Printing oppStageCode '+ oppStageCode); 
        }
        
        system.debug('Conrtoller Class Constructor Called 3---->'+lineCurrency +'--'+noOfSplits +'---'+milestoneDt +'--'+parId);      
        innerRwlst = new List<innerClass>();
        addMore(1,noOfSplits, milestoneDt, parId);
        selectedRowIndex = '0';
        
	}/*End Constructor*/
    
    
    
    public integer getBillTermDays(String param){
        if(param.containsIgnoreCase('30')){
            return integer.Valueof(30);
        }else if (param.containsIgnoreCase('45')){
            return integer.Valueof(45);
        }else if(param.containsIgnoreCase('60')){
            return integer.Valueof(60);
        }else if(param.containsIgnoreCase('90')){
            return integer.Valueof(90);
        }
        
        return null;
    }
    public void Add()
	{	
        addMore(0,1,temp,parId);
		count = count+1;		
	}
    
    
	public void addMore(Integer reqType, Integer noOfSplits, Date billingDt, Id recId)
	{
        Decimal tempPercentage;
       
        list<AggregateResult> mBill_line_ID ;
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        integer billLineID; 
    
        if(mBill_line_ID == null){
	        mBill_line_ID = [select max(line_id__c) myMax from billing_term__c];
        	system.debug('mBill_line_ID '+ mBill_line_ID );
    	    billLineID = integer.valueOf(mBill_line_ID[0].get('myMax'))+1;
    	   // billLineID = integer.valueOf(916);
    		system.debug('mBill_line_ID new '+ billLineID );
        }
        if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [select id,Total_Value__c,Billing_Term_balance_amount__c,name, CurrencyIsoCode, Cogs_Bctpl_percentage__c,Geo_Margin__c,Total_GEO_Margin__c from opportunity_line_item__c where id = :recId];
    
        }  
        
            if(reqType == 1){
            Integer oppLineIdFK = 0;
    
            	for(opportunity_line_item__c op: Opp_Line_Amount)
        			{
                        system.debug('Printing op.Billing_Term_Balance_amount__c '+ op.Billing_Term_Balance_amount__c +' noOfSplits ---->'+  noOfSplits +'---'+ op.CurrencyIsoCode ); 
                        availableLineAmt = Integer.valueOf(op.Billing_Term_Balance_amount__c);
                        tempPercentage = ((op.Billing_Term_Balance_amount__c)/noOfSplits).doublevalue();
                        system.debug('Printing op.Billing_Term_Balance_amount__c '+ op.Billing_Term_Balance_amount__c +' noOfSplits ---->'+  noOfSplits +'Calculated Field '+ tempPercentage +'lineCurrency--'+lineCurrency); 
                        String tempMilestone_Basis = 'Fixed Amount';
                        
                            FOR(integer i=0; i<noOfSplits; i++)
                            {
                                InnerClsObj = new innerClass(count, 1);
                         
                                InnerClsObj.bt.srNo__c=billLineID+i;
    
                                billLineID = Integer.valueOf(InnerClsObj.bt.srNo__c);
                                InnerClsObj.bt.Billing_Date__c = billingDt;
                                billingDt = InnerClsObj.bt.Billing_Date__c + billtermcycle;
    
                                //InnerClsObj.bt.Milestone__c= '';
                                InnerClsObj.bt.Split_days__c=noOfSplits;
                                InnerClsObj.bt.Percentage__c  = tempPercentage;
                                InnerClsObj.bt.Milestone__c = billMilestone.equalsIgnoreCase('null') ? '' : billMilestone;
                                /* if(billMilestone.equalsIgnoreCase('null')){
                                InnerClsObj.bt.Milestone__c = '';    
                                }else{
                                    InnerClsObj.bt.Milestone__c = billMilestone;
                                }*/
                                
                                InnerClsObj.bt.opportunity_line_item_id__c = op.id;
                                InnerClsObj.bt.Milestone_Basis__c= tempMilestone_Basis;
                                InnerClsObj.bt.Calculated_Amount__c= op.Billing_Term_balance_amount__c;
                                oppBalAmount = op.Billing_Term_balance_amount__c;
                                InnerClsObj.bt.CurrencyIsoCode = lineCurrency;
                                //InnerClsObj.bt.Cogs_Bctpl__c = InnerClsObj.bt.Calculated_Amount__c * cogspercentage/100;
                                InnerClsObj.bt.Billing_Term__c = billTerm;
                                innerRwlst.add(InnerClsObj);    
                                count++;
                                system.debug('Inner Row List object in for loop  :' + innerRwlst + ' I value is '+i);
                                }
 				          	}
        	 	}else{
        		     InnerClsObj = new innerClass(count);
                     InnerClsObj.bt.srNo__c = getMaxBillingTermId() + 1 ;
                     billLineID = Integer.valueOf(InnerClsObj.bt.srNo__c);
                     InnerClsObj.bt.Split_days__c = 1;
                     InnerClsObj.bt.opportunity_line_item_id__c = Opp_Line_Amount.get(0).id;
                     InnerClsObj.bt.Calculated_Amount__c = oppBalAmount;
                     //InnerClsObj.bt.Cogs_Bctpl__c = InnerClsObj.bt.Calculated_Amount__c * cogspercentage/100;
                     system.debug('Opportunit balance amout :'+ oppBalAmount);
                     InnerClsObj.bt.CurrencyIsoCode = lineCurrency;
                     InnerClsObj.bt.Billing_Term__c = billTerm;
                     innerRwlst.add(InnerClsObj);    
        			}
            
		//add the record to the inner class list
        system.debug('Inner Row---->'+innerRwlst);            
    }/* end addMore*/
    
    public Integer getMaxBillingTermId(){
	 if(innerRwlst.size() != null && innerRwlst.size() >0){
        Integer rowListSize = innerRwlst.size();
        Integer maxBillId = Integer.valueOf(innerRwlst.get(rowListSize-1).bt.srNo__c);
        return maxBillId;
		}else{
        	return null;
		}	
    }
    
   public class innerClass
	{		
		/*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
		public String recCount
		{get;set;}
	
        public Billing_Term__c bt 
		{get;set;}
		
		/*Inner Class Constructor*/
		public innerClass(Integer intCount)
		{
			recCount = String.valueOf(intCount);		
     
			 bt = new Billing_Term__c();
		}
        
        public innerClass(Integer noOfSplitsReq, Integer reqType) // Request Type 0 for Manual Add and 1 for Auto Split . noOfSplitsReq holds the number of splits required for the given amount
		{
			recCount = String.valueOf(noOfSplitsReq);		
 		   	bt = new Billing_Term__c();
        }
	}
    
    public pageReference SaveAccount()   
    {
        
        Decimal tmpBillAmt = 0;
        PageReference pr = new PageReference('/'+parId);
          system.debug('Inside Save Account  Size  ---->'+innerRwlst.size());
          system.debug('Inside Save Account   ---->'+innerRwlst);
       listBilling_Term.clear();
        for(Integer j = 0;j<innerRwlst.size();j++)
		{
			listBilling_Term.add(innerRwlst[j].bt);
		}

       for(Billing_Term__c tmp : listBilling_Term){
            if(tmp.Milestone_Basis__c == '%'){
            tmpBillAmt = tmpBillAmt + (double.valueOf(tmp.Calculated_Amount__c) * double.valueOf(tmp.Percentage__c) / 100);
            }else{
                tmpBillAmt = tmpBillAmt + double.valueOf(tmp.Percentage__c);
            }
        }
        if(availableLineAmt == tmpBillAmt){
        system.debug('List to save  ---->'+listBilling_Term);
            try{
                insert listBilling_Term;
            }catch(DMLException dmle){
                system.debug('DML Error during insert  ---->'+dmle);
               
               /* if(dmle.getMessage().contains('LineMilestoneCompKey__c') && dmle.getMessage().contains('DUPLICATE_VALUE')){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate milestone found. Please change to different milestone to proceed.');
                    ApexPages.addMessage(myMsg);    
                }else{*/
                     ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to Create bill term record. Please contact administrator : ' + dmle.getMessage());
                     ApexPages.addMessage(myMsg1); 
               // }
                
                return null;
            }catch(Exception e){
                system.debug('Error during insert  ---->'+e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Unable to Create bill term record. Please contact administrator : ' + e.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
                  
  		      return pr;
        }else{
            tmpBillAmt = 0;
             system.debug('Unable to save  ----> Resetting tmpBillAmt to zero');
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' The Sum of all splitted bill amounts should be equal to Opportunity Line Amount');
             system.debug('Unable to save  ---->'+errMsg);
			ApexPages.addMessage(errMsg);
            return null;
        }
        
    }
    
    public pageReference navback(){
        
         PageReference pr = new PageReference('/'+parId);
        return pr;
        
    }
	
	
	public void delMilestone(){
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
	}
}