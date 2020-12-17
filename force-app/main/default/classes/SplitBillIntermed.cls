public class SplitBillIntermed {
    
      public Billing_Term__c splitTerm 
		{get;set;}
   		
    public Integer balanceAmt {get;set;}
    public String oppLineStage {get;set;}
    public String oppStageCode {get;set;}
    public boolean balChk {get;set;}
    String lineCurrency;
    
    public SplitBillIntermed(ApexPages.StandardController controller){
        
        splitTerm = new Billing_Term__c();
        
        list<opportunity_line_item__c> Opp_Line_Amount ; 
        	if(Opp_Line_Amount == null){
                system.debug('Printing Id  : '+ApexPages.currentPage().getParameters().get('id'));
        	Opp_Line_Amount = [SELECT Id, Total_Value__c, Billing_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c, CurrencyIsoCode FROM Opportunity_Line_Item__c where id = :ApexPages.currentPage().getParameters().get('id')];
        	system.debug('Printing Opp_Line_Amount query result   ---->'+  Opp_Line_Amount); 
        }
        
        for(opportunity_line_item__c op: Opp_Line_Amount){
            system.debug('Printing op.Billing_Term_Balance_amount__c '+ op.Billing_Term_Balance_amount__c); 
            balanceAmt = Integer.valueOf(op.Billing_Term_Balance_amount__c);
            oppLineStage = op.stageName__c;
            oppStageCode = op.Opportunity_ID__r.Funnel_Code__c;
            lineCurrency = op.CurrencyIsoCode;
            system.debug('Printing oppStageCode '+ oppStageCode); 
        }
                        
    }
    
    
    public PageReference splitBillInter(){
        
        String url = '/apex/splitbillingtermscr?lncur='+lineCurrency+'&fromDate='+splitTerm.Billing_Date__c+'&noOfSplits='+splitTerm.Split_days__c +'&srcId=' + ApexPages.currentPage().getParameters().get('id')+'&btm='+splitTerm.Billing_Term__c+'&bmst='+EncodingUtil.urlEncode(splitTerm.Milestone__c,'UTF-8');
               
        system.debug('Printing URL  ---->'+  url); 
        PageReference pageRef = new PageReference(url);
        system.debug('Printing Page Ref  ---->'+  pageRef); 
        pageRef.setRedirect(false);
        return pageRef;
        
        
    }
    
    public PageReference navback(){
        PageReference pgRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pgRef;
    }
    

}