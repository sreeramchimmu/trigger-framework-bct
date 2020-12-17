public class OppOwnerChangeTrigCls {

    private Map<Id, Opportunity> mapNewOpp;
	private	Map<Id, Opportunity> mapOldOpp;
    private List<Revenue_Term__c> RevTermList;
    private List<Revenue_Term__c> RevTermListToUpdate = new List<Revenue_Term__c>();
    private List<id> newOppList;
    private List<id> oldOppList;
    private List<id> ownerChangedOpportunities = new List<id>();
    private List<id> ownerChangedList = new List<id>();
    private Map<Id, id> oppToOldOwnerMap = new Map<id, id>();
    private Map<Id, id> oppToNewOwnerMap  = new Map<id, id>();
    private Date StartDate;
    private Date EndDate;
    private ID oldOwnerid;
    Date todayDate;
    
    private static Boolean blnAlreadyInsideTrigger = false;
    public OppOwnerChangeTrigCls(Map<Id, Opportunity> mapNewOpp, Map<Id, Opportunity> mapOldOpp) {
		this.mapNewOpp = mapNewOpp;
		this.mapOldOpp = mapOldOpp;
        
        if(null != mapNewOpp){
        	system.debug('mapNewOpp Size : ' + mapNewOpp.size());
        	system.debug('mapNewOpp ' + mapNewOpp); 
            newOppList = new List<id>();
            for(id opp : mapNewOpp.keySet()) {
            	newOppList.add(opp);
        	}
             for(id newopp : newOppList ){
              if(mapNewOpp.get(newopp).ownerid != mapOldOpp.get(newopp).ownerid){
                ownerChangedOpportunities.add(newopp);
                ownerChangedList.add(mapNewOpp.get(newopp).ownerid);
                oppToOldOwnerMap.put(mapOldOpp.get(newopp).id , mapOldOpp.get(newopp).ownerid);
                oppToNewOwnerMap.put(mapNewOpp.get(newopp).id , mapNewOpp.get(newopp).ownerid);
            	}
        	}
             system.debug('newOppList ' + newOppList.size()+':'+ newOppList);
        }
        
        if(null != mapOldOpp){
        	system.debug('mapOldOpp Size : ' + mapOldOpp.size());
        	system.debug('mapOldOpp  : ' + mapOldOpp);
            oldOppList = new List<id>();
             for(id opp : mapOldOpp.keySet()) {
            	oldOppList.add(opp);
        	}
             system.debug('oldOppList ' + oldOppList.size()+':'+ oldOppList); 
        }
         //RevTermList = [SELECT Id, Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId  FROM Revenue_Term__c where Opportunity_Line_Item_id__r.Opportunity_ID__r.id IN :  oldOppList];
         system.debug('oppToOldOwnerMap  ' + oppToOldOwnerMap); 
         system.debug('oppToNewOwnerMap  ' + oppToNewOwnerMap); 
         todayDate = date.today();
     }
    
    public void populateoldOppOwnerRevTerms(){
        
        if(null != ownerChangedOpportunities && ownerChangedOpportunities.size()>0){
             system.debug('ownerChangedList ' + ownerChangedList.size() +' <----> '+ ownerChangedList); 
           	 //Gowtham - get the values from the Session cache using partion name 'ownerChange' & Variable name 'ownerChangeFromDate'
           	 //Refere - https://www.biswajeetsamal.com/blog/platform-cache-in-salesforce/
            if(Cache.Session.contains('local.OwnerChangeDates.RevenueFromDate')){
                StartDate = (Date)Cache.Session.get('local.OwnerChangeDates.RevenueFromDate');
            }
            if(Cache.Session.contains('local.OwnerChangeDates.RevenueToDate')){
                EndDate = (Date)Cache.Session.get('local.OwnerChangeDates.RevenueToDate');
            }
            system.debug('StartDate_Cache =-=> ' + StartDate);
           	system.debug('EndDate_Cache   =-=> ' + EndDate);
            //Rameez-Begin
            //RevTermList = [SELECT Id, Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId  FROM Revenue_Term__c where (Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId IN :ownerChangedList  AND Opportunity_Line_Item_id__r.Opportunity_ID__r.id IN :  ownerChangedOpportunities AND revenue_date__c >= :StartDate and  revenue_date__c <= :EndDate)];
          	RevTermList = [SELECT Id, Revenue_Date__c,  Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId ,Opportunity_line_item_id__r.Opportunity_ID__r.StageName  FROM Revenue_Term__c where (Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId IN :ownerChangedList  AND Opportunity_Line_Item_id__r.Opportunity_ID__r.id IN :  ownerChangedOpportunities)];
            system.debug('RevTermList size---- ' + RevTermList.size());
        	  for(Revenue_Term__c rev : RevTermList) {
                  system.debug('Opp Stage---> '+rev.Opportunity_line_item_id__r.Opportunity_ID__r.StageName);
                  System.debug('Start Date>>'+StartDate+'end date>>'+EndDate); 
                  if(rev.Opportunity_line_item_id__r.Opportunity_ID__r.StageName=='Closed Won'){
                  	if(rev.Revenue_Date__c>=StartDate && rev.Revenue_Date__c <=EndDate){
                		rev.Revenue_Owner__c= ownerChangedList[0];
                    	RevTermListToUpdate.add(rev);
                        system.debug('----------Inside If Condition StartDate & End date----------');
                  	}
                  }else{
                      RevTermListToUpdate.add(rev);
                      system.debug('----------OutSide Condition--------------');
                  }
        	}
            //Rameez-End
            system.debug('RevTermListToUpdate  ' + RevTermListToUpdate.size() +'--->  '+ RevTermListToUpdate);
  			}
    }
     
     public void processOwnerDetails(){
         if (( Trigger.isAfter && Trigger.isUpdate)) {
              		 system.debug('Opp Owner Change Call for Update  ');
                     populateoldOppOwnerRevTerms();
                     deleteRevTermsInActuals();
                     updateRevTermListInRevTermObj();
             system.debug('Trigger.isBefore-->'+Trigger.isBefore);
              system.debug('Trigger.isDelete-->'+Trigger.isDelete);
     			} 
     }
    
    public void deleteRevTermsInActuals(){
        
        List<Actual_Detail__c> actObj = [SELECT ID, RevenueTermRef__c FROM actual_detail__c where RevenueTermRef__c IN : RevTermListToUpdate];
		system.debug('actObj  ' + actObj.size() +'--->  '+ actObj);          
        if(actObj.size() > 0){
                try{
                     system.debug('Deleting Actual details for owner changed revenue terms ' + actObj); 
                 	 delete actObj;
                	}Catch(DMLexception dmle){
                    system.debug('Error while deleting Actual details ' + dmle); 
                }
    		}
    }
    
   public void updateRevTermListInRevTermObj(){
         if(RevTermListToUpdate.size() > 0){
                try{
                     system.debug('Updating owner changed revenue terms ' + RevTermListToUpdate); 
                 	 update RevTermListToUpdate;
                	}Catch(DMLexception dmle){
                    system.debug('Error while updating revenue details ' + dmle); 
                }
    		}
    }
    
}