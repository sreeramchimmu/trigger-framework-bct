global class CarryForwardIncentiveBatch implements Database.Batchable<sObject>{
  
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        //String query = 'SELECT Opportunity_Number__c FROM Actual_Forecast_Report_Snapshot__c where Business_Category__c LIKE \''+'%New business%'+ '\''+' and DAY_ONLY(CreatedDate) =2020-04-05';
        system.debug(':::::::::::::CarryForwardIncentiveBatch:::::::::::::::::');
        Date dt = Date.today();
        String dtFormate = 'yyyy-MM-dd';
        Datetime createdDateLimit = Datetime.newInstance(2020, 04, 05);
        //String query = 'SELECT Opportunity_Number__c FROM Actual_Forecast_Report_Snapshot__c where Business_Category__c LIKE \''+'%New business%'+ '\''+' and DAY_ONLY(CreatedDate) ='+createdDateLimit.format(dtFormate)+'';
        String Actsnpquery = 'SELECT Opportunity_Number__c FROM Actual_Forecast_Report_Snapshot__c where DAY_ONLY(CreatedDate) ='+createdDateLimit.format(dtFormate)+'';      
        List<Actual_Forecast_Report_Snapshot__c> actFctList = Database.query(Actsnpquery);
        system.debug('actFctList-->'+actFctList.size());
        set<string> oppNumberSet = new set<string>();
        for(Actual_Forecast_Report_Snapshot__c oppNum:actFctList){
            oppNumberSet.add(oppNum.Opportunity_Number__c);  
        }
        String query='select Id,Opportunity_number_new__c from opportunity where Opportunity_number_new__c in:oppNumberSet';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<opportunity> oppnolist) {
       system.debug('oppnolist size-->'+oppnolist.size());
        try {
            CarryForwardIncentiveCalculation cfr = new CarryForwardIncentiveCalculation();
            for(opportunity oppNo:oppnolist){
                cfr.CarryForwardIncentiveCalculation_dataFetch(oppNo.Id);
            }
        } catch(Exception e) {
            System.debug(e);
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
    	System.debug('CarryForwardIncentiveBatch Update completed...');
  }

}