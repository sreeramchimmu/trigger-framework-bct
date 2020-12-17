public class SplitRevTermIntermed {

    public Revenue_Term__c splitTerm 
		{get;set;}
   		
    public Integer balanceAmt {get;set;}
    public String oppLineStage {get;set;}
    public String oppStageCode {get;set;}
    public boolean balChk {get;set;}
    String lineCurrency;
    public SplitRevTermIntermed(ApexPages.StandardController controller){
        
        splitTerm = new Revenue_Term__c();

        list<opportunity_line_item__c> Opp_Line_Amount ; 
        	if(Opp_Line_Amount == null){
        	Opp_Line_Amount = [SELECT Id, Total_Value__c, Revenue_Term_balance_amount__c,name, StageName__c, Opportunity_ID__r.Funnel_Code__c, CurrencyIsoCode from opportunity_line_item__c where id = :ApexPages.currentPage().getParameters().get('id')];
        	system.debug('Printing Opp_Line_Amount query result   ---->'+  Opp_Line_Amount); 
        }
        
        for(opportunity_line_item__c op: Opp_Line_Amount){
            system.debug('Printing op.Revenue_Term_balance_amount__c '+ op.Revenue_Term_balance_amount__c); 
            balanceAmt = Integer.valueOf(op.Revenue_Term_balance_amount__c);
            oppLineStage = op.stageName__c;
            oppStageCode = op.Opportunity_ID__r.Funnel_Code__c;
            lineCurrency = op.CurrencyIsoCode;
        }
    }
    
    public PageReference splitRevInter(){
       //splitTerm.Milestone__c=splitTerm.Milestone__c.replaceAll('&', '%26');
        //system.debug('Printing Milestone__c  ---->'+ splitTerm.Milestone__c); 
        
         String url = '/apex/splitrevenuetermscr?lncur='+lineCurrency+'&fromDate='+splitTerm.Revenue_Date__c+'&noOfSplits='+splitTerm.Split_days__c +'&srcId=' + ApexPages.currentPage().getParameters().get('id')+'&rtm='+splitTerm.Revenue_Term__c+'&rmst='+EncodingUtil.urlEncode(splitTerm.Milestone__c,'UTF-8');
         system.debug('Printing reveune split URL  ---->'+ url); 
         PageReference pref = new PageReference(url);
         system.debug('Printing Page Ref  ---->'+  pref); 
         pref.setRedirect(false);
         return pref;
    }
    
    public PageReference navback(){
        PageReference pgRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pgRef;
    }
}