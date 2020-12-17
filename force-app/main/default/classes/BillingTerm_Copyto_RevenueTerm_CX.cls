public class BillingTerm_Copyto_RevenueTerm_CX 
{
    private final Opportunity_Line_Item__c OpportunityLineItem;
    
    Revenue_Term__c revItem = new Revenue_Term__c();
    public list<Revenue_Term__c> tempRevlist {get;set;} 
    public List<Billing_Term__c> results {get; set;}
    
    // Constructor used to get the Billing Term Record
    public BillingTerm_Copyto_RevenueTerm_CX(ApexPages.StandardController stdController) {
        this.OpportunityLineItem = (Opportunity_Line_Item__c)stdController.getRecord();
        system.debug('Opportunity Line Item Value is  '+OpportunityLineItem);
         tempRevlist = new list<Revenue_Term__c>();
        
        list<AggregateResult> mRev_line_ID = [select max(line_id__c) myMax from Revenue_term__c];
        system.debug('Max  revenue term id ---> '+mRev_line_ID);
        integer revLineID = integer.valueOf(mRev_line_ID[0].get('myMax'))+1;
        
      //for(integer i=0; i<results.size(); i++)
        Integer i = 0;
        system.debug('Opprotunity Line item Id ----------> '+ApexPages.currentPage().getParameters().get('id'));
    results = [select SrNo__c,Split_days__c,Milestone_Basis__c,opportunity_line_item_id__c,Milestone__c,Billing_Date__c,percentage__c,Milestone_Amount__c, CurrencyIsoCode from Billing_Term__c where opportunity_line_item_id__c  = :ApexPages.currentPage().getParameters().get('id')];
       system.debug('Results ----------> '+results);
        for(Billing_Term__c eachBillTerm :results)
        {
            system.debug('Results List are in Constructor is '+results);
            //Revenue_Term__c temp = new Revenue_Term__c(); 
            Revenue_Term__c temp = new Revenue_Term__c();
            eachBillTerm.SrNo__c = revLineID+i;
            revLineID = Integer.valueOf(eachBillTerm.SrNo__c);
            temp.SrNo__c = revLineID;
            temp.Revenue_Date__c=eachBillTerm.Billing_Date__c;
            temp.Opportunity_Line_Item_id__c=eachBillTerm.opportunity_line_item_id__c;
            String tempMilestone=eachBillTerm.Milestone__c;
            temp.Milestone__c=tempMilestone;
            temp.Split_days__c=eachBillTerm.Split_days__c;
            // Comment on 21-Sep-2016
            temp.Percentage__c=eachBillTerm.percentage__c; 
            temp.Milestone_Basis__c=eachBillTerm.Milestone_Basis__c;
            temp.Milestone_Amount__c=eachBillTerm.Milestone_Amount__c;
            temp.CurrencyIsoCode = eachBillTerm.CurrencyIsoCode;
           // Above has written on 21-Sep-2016
            
            
            //
            system.debug('Temp value is '+temp);
            tempRevlist.add(temp);               
            temp=new Revenue_Term__c(); 
            i++;
        } 
    }
       
    
   /* public List<Billing_Term__c>  getResults {
    
        return 
     }*/
    
    
    public pageReference Save()   
    {
        insert tempRevlist;
        return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    } 
    
    public pageReference navback(){
        
         PageReference pr = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pr;
        
    }
    
}