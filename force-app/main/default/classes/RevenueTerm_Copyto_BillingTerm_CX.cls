public class RevenueTerm_Copyto_BillingTerm_CX {
    private final Opportunity_line_item__c OpportunityLineItem;
    Billing_term__c billTerm = new Billing_Term__c();
    public list<Billing_Term__c> tempBillList{get;set;} 
    public list<Revenue_Term__c> results{get;set;}
    
    public RevenueTerm_Copyto_BillingTerm_CX(Apexpages.standardController stdController){
        this.OpportunityLineItem=(Opportunity_Line_Item__c)stdController.getrecord();
        system.debug('Opportunity Line Item Value is  '+OpportunityLineItem);
        tempBillList = new list<Billing_Term__c>();
        list<AggregateResult> mBill_line_ID = [select max(line_id__c) myMax from Billing_term__c];
        
        system.debug('Max  revenue term id ---> '+mBill_line_ID);
        integer billLineID = integer.valueOf(mBill_line_ID[0].get('myMax'))+1;
        Integer i = 0;
        system.debug('Opprotunity Line item Id ----------> '+ApexPages.currentPage().getParameters().get('id'));
    	results = [select SrNo__c,Split_days__c,Milestone_Basis__c,opportunity_line_item_id__c,Milestone__c,Revenue_Date__c
                   ,percentage__c,Milestone_Amount__c, CurrencyIsoCode 
                   from Revenue_Term__c where opportunity_line_item_id__c  = :ApexPages.currentPage().getParameters().get('id')];
       system.debug('Results ----------> '+results);
        for(Revenue_Term__c eachRevenueTerm :results)
        {
            system.debug('Results List are in Constructor is '+results);
            //Revenue_Term__c temp = new Revenue_Term__c(); 
            Billing_Term__c temp = new Billing_Term__c();
            eachRevenueTerm.SrNo__c = billLineID+i;
            billLineID = Integer.valueOf(eachRevenueTerm.SrNo__c);
            temp.SrNo__c = billLineID;
            
            temp.Billing_Date__c=eachRevenueTerm.Revenue_Date__c;
            temp.Opportunity_Line_Item_id__c=eachRevenueTerm.opportunity_line_item_id__c;
            String tempMilestone=eachRevenueTerm.Milestone__c;
            temp.Milestone__c=tempMilestone;
            temp.Split_days__c=eachRevenueTerm.Split_days__c;
            // Comment on 21-Sep-2016
            temp.Percentage__c=eachRevenueTerm.percentage__c; 
            temp.Milestone_Basis__c=eachRevenueTerm.Milestone_Basis__c;
            temp.Milestone_Amount__c=eachRevenueTerm.Milestone_Amount__c;
            temp.CurrencyIsoCode = eachRevenueTerm.CurrencyIsoCode;
            system.debug('Temp value is Goutam'+temp);
            tempBillList.add(temp);               
            temp=new Billing_Term__c(); 
            i++;
        }  
    }
	public pageReference Save()
    {
        insert tempBillList;
        return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    }
	
	Public pageReference navBack()
    {
        PageReference pr = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pr;
    }
}