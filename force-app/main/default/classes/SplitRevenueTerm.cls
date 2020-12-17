public class SplitRevenueTerm {

  
    public Integer balanceAmt {get;set;}
    public String oppLineStage {get;set;}
    public String oppStageCode {get;set;}
    public decimal cogspercentage {get;set;}
    
    public list<Revenue_Term__c> listRevenueTerm = new List<Revenue_Term__c>();  
    Date temp = date.newInstance(2016, 10, 5);

	public List<innerClass> innerRwlst
	{	get;set;	}
    

	public String selectedRowIndex
	{get;set;}
    

	public Integer count = 0;
    Integer availableLineAmt;
    String lineCurrency;
    Id parId ;
    innerClass InnerClsObj; 
    integer revtermcycle;
    String revTerm;
	String revMilestone;
    public SplitRevenueTerm(ApexPages.StandardController ctlr)
	{
		system.debug('Conrtoller Class Constructor Called 1---->');
        String param_value1 = String.valueOf(ApexPages.currentPage().getParameters().get('fromDate').trim());
        String param_value2 = String.valueOf(ApexPages.currentPage().getParameters().get('noOfSplits').trim());
        String param_value3 = String.valueOf(ApexPages.currentPage().getParameters().get('srcId').trim());
        String param_value4 = String.valueOf(ApexPages.currentPage().getParameters().get('lncur').trim());
        String param_value5 = String.valueOf(ApexPages.currentPage().getParameters().get('rtm').trim());
        String param_value6 = String.valueOf(ApexPages.currentPage().getParameters().get('rmst').trim());
        system.debug('Revenue Conrtoller Class Constructor Called 2 ---->'+param_value1 + '--'+ param_value2 +'---' + param_value3+'---' + param_value4);      
        Date milestoneDt  = Date.valueOf(param_value1);
        Integer noOfSplits = Integer.valueOf(param_value2);
        parId = Id.valueOf(param_value3);
        lineCurrency = String.valueOf(param_value4);
        revtermcycle = getRevTermDays(param_value5);
        revTerm = param_value5;
        system.debug('revMilestone Before assigning---->' +revMilestone);
        revMilestone = param_value6;
        system.debug('revMilestone After assigning---->' +revMilestone);
       
        
        if(revtermcycle == null){
            revtermcycle = 30;
        }
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        	if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c,Cogs_Bctpl_percentage__c,CurrencyIsoCode from opportunity_line_item__c where id = :parId];

        }
        
        for(opportunity_line_item__c op: Opp_Line_Amount){

            balanceAmt = Integer.valueOf(op.Revenue_Term_balance_amount__c);
            oppLineStage = op.stageName__c;
            oppStageCode = op.Opportunity_ID__r.Funnel_Code__c;
          	cogspercentage = op.Cogs_Bctpl_percentage__c;
        }
        
        system.debug('Revenue Conrtoller Class Constructor Called 3---->'+lineCurrency +'--'+noOfSplits +'---'+milestoneDt +'--'+parId);      
        innerRwlst = new List<innerClass>();
        addMore(1,noOfSplits, milestoneDt, parId);
        selectedRowIndex = '0';
        
	}
    
    
      public integer getRevTermDays(String param){
        if(param.containsIgnoreCase('30')){
            return integer.Valueof(30);
        }else if (param.containsIgnoreCase('45')){
            return integer.Valueof(45);
        }else if(param.containsIgnoreCase('60')){
            return integer.Valueof(60);
        }
          else if(param.containsIgnoreCase('90')){
            return integer.Valueof(90);
        }
          return null;
      }   
          
    public void Add()
	{	
            addMore(0,1,temp,parId);
            count = count + 1;
     }
    
    
    
	public void addMore(Integer reqType, Integer noOfSplits, Date revenueDt, Id recId)
	{
    
		
        integer tempPercentage; 
        list<AggregateResult> rev_line_ID ;
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        integer revLineID; 
    
        if(rev_line_ID == null){
	        rev_line_ID = [select max(line_id__c) myMax from Revenue_Term__c];
        
    	    revLineID = integer.valueOf(rev_line_ID[0].get('myMax'))+1;
    
        }
        if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [select id,Total_Value__c,Revenue_Term_balance_amount__c,name from opportunity_line_item__c where id = :recId];
    
        }  
           String tempMilestone_Basis = 'Fixed Amount';
        
            if(reqType == 1){
            Integer oppLineIdFK = 0;
    
            	for(opportunity_line_item__c op: Opp_Line_Amount)
        			{	
    
                        availableLineAmt = Integer.valueOf(op.Revenue_Term_balance_amount__c);
                        //tempPercentage = Decimal.valueOf(Double.valueOf(op.Revenue_Term_balance_amount__c)/noOfSplits);
                          tempPercentage = Integer.valueOf(op.Revenue_Term_balance_amount__c/noOfSplits);
                        //lineCurrency = op.CurrencyIsoCode;
                            
                            FOR(integer i=0; i<noOfSplits; i++)
                            {
                                InnerClsObj = new innerClass(count, 1);
                                InnerClsObj.rt.srNo__c=revLineID+i;
                                revLineID = Integer.valueOf(InnerClsObj.rt.srNo__c);
                                InnerClsObj.rt.Revenue_Date__c = revenueDt;
                                revenueDt = InnerClsObj.rt.Revenue_Date__c +revtermcycle;
                                system.debug('milestone value '+ revMilestone);
                                InnerClsObj.rt.Milestone__c = revMilestone.equalsIgnoreCase('null') ? '' : revMilestone;
                                InnerClsObj.rt.Split_days__c=noOfSplits;
                                InnerClsObj.rt.Percentage__c  = tempPercentage;
                                InnerClsObj.rt.opportunity_line_item_id__c = op.id;
                                InnerClsObj.rt.Milestone_Basis__c= tempMilestone_Basis;
                                InnerClsObj.rt.Calculated_Amount__c= op.Revenue_Term_balance_amount__c;
                                InnerClsObj.rt.CurrencyIsoCode = lineCurrency;
                                InnerClsObj.rt.Revenue_Term__c =  revTerm;
                                innerRwlst.add(InnerClsObj);  
                               	count++;
                               
                                system.debug('Inner Row List object in for loop  :' + innerRwlst + ' I value is '+i + 'Rec count : '+count );
                                }
 				          	}
        	 	}else{
        		     InnerClsObj = new innerClass(count);
                     InnerClsObj.rt.srNo__c = getMaxBillingTermId() + 1 ;
                     revLineID = Integer.valueOf(InnerClsObj.rt.srNo__c);
                     InnerClsObj.rt.Split_days__c = 1;
                     InnerClsObj.rt.opportunity_line_item_id__c = Opp_Line_Amount.get(0).id;
                     InnerClsObj.rt.CurrencyIsoCode = lineCurrency;
                     InnerClsObj.rt.Milestone_Basis__c= tempMilestone_Basis;
                     InnerClsObj.rt.Revenue_Term__c =  revTerm;
                     //InnerClsObj.rt.Calculated_Amount__c= op.Revenue_Term_balance_amount__c;
                	 innerRwlst.add(InnerClsObj);    
        			}
        system.debug('Inner Row---->'+innerRwlst);            
    }
    
    public Integer getMaxBillingTermId(){
        if(innerRwlst.size() != null && innerRwlst.size() >0){
        Integer rowListSize = innerRwlst.size();
        Integer maxBillId = Integer.valueOf(innerRwlst.get(rowListSize-1).rt.srNo__c);
        return maxBillId;
    	}else{
        	return null;
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
        
        public innerClass(Integer noOfSplitsReq, Integer reqType) // Request Type 0 for Manual Add and 1 for Auto Split . noOfSplitsReq holds the number of splits required for the given amount
		{
            system.debug('Creating Split for record count ---->'+noOfSplitsReq);         
			recCount = String.valueOf(noOfSplitsReq);		
 		   	rt = new Revenue_Term__c();
        }      
	}
    
    public pageReference SaveAccount()   
    {   
        integer tmpRevAmt = 0;
        PageReference pr = new PageReference('/'+parId);
     	listRevenueTerm.clear();
        for(Integer j = 0;j<innerRwlst.size();j++)
		{
			listRevenueTerm.add(innerRwlst[j].rt);
        }
          
        if(listRevenueTerm.size() > 0) {
       		for(Revenue_Term__c tmp : listRevenueTerm){
           
         		if(tmp.Milestone_Basis__c == '%'){
                	tmpRevAmt = tmpRevAmt + Integer.valueOf(tmp.Calculated_Amount__c * tmp.Percentage__c / 100);
            	}else{
            		tmpRevAmt = tmpRevAmt + Integer.valueOf(tmp.Percentage__c);
            	}
        }
        if(availableLineAmt == tmpRevAmt){
        	system.debug('List to save  ---->'+listRevenueTerm);
            try{
                insert listRevenueTerm;
            }catch(DMLException dmle){
                system.debug('DML Error during insert  ---->'+dmle);
               
                /*if(dmle.getMessage().contains('LineMilestoneCompKey__c') && dmle.getMessage().contains('DUPLICATE_VALUE')){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate milestone found. Please change to different milestone to proceed.');
                    ApexPages.addMessage(myMsg);    
                }else{*/
                     ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to Create Revenue term record. Please contact administrator : ' + dmle.getMessage());
                     ApexPages.addMessage(myMsg1); 
                //}
                
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