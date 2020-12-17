public with sharing class OwnChngScrCntrl {
       
    public List<Revenue_Term__c> wrapRevenueTerm {get; set;}  
    public List<Revenue_Term__c> revList {get;set;}       
    public Date fromDate{get;set;}
    public Date toDate{get;set;}
   	public Boolean showfetchtable {get;set;}
  	public static String currentPageID = ApexPages.currentPage().getParameters().get('id');
    
  	public OwnChngScrCntrl(ApexPages.StandardController controller) {
        showfetchtable = false;
       	//Gowtham[10-Mar-2020] - Below code is commented because a new Look field is introduce 'Revenue_Owner__c' instead of string field 'Owner_Change_Temp__c'
        wrapRevenueTerm = Database.query(' SELECT Id,Name,Revenue_Date__c,Revenue_Owner__c,Percentage__c FROM Revenue_Term__c WHERE Opportunity_item_id__c = :currentPageID ');     	      
    }        
    public void getRecords(){             
        String query = ' SELECT Id,Name,Revenue_Date__c FROM Revenue_Term__c WHERE Opportunity_item_id__c = :currentPageID  AND Revenue_Date__c >=  :fromDate  AND Revenue_Date__c <=  :toDate ';
        if(fromDate == null || toDate == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter dates!');
            ApexPages.addMessage(msg); 
        }
       	else if(fromDate != null || toDate != null){
            revList= Database.query(query); 
            showfetchtable = true; 
        }       
    }
     
    public PageReference next(){
        try{
            //Gowtham - Session cache to maintain the temprorly value in session using a partion 'ownerChange'
			Cache.Session.put('local.OwnerChangeDates.RevenueFromDate', fromDate);
            Cache.Session.put('local.OwnerChangeDates.RevenueToDate', toDate);
            PageReference pgref = new PageReference('/'+currentPageID+'/a?retURL=%2F');
            pgref.setRedirect(true);
            return pgref;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
    }

    public PageReference reset(){
        PageReference pgref = new PageReference(System.currentPageReference().getURL());
        pgref.setRedirect(true);
        return pgref;
    }
    
    public PageReference back(){    
        PageReference pgRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        return pgRef;
    }  
}