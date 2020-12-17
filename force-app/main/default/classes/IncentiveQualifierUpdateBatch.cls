global class IncentiveQualifierUpdateBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        Date dt = Date.today();
        String dtFormate = 'yyyy-MM-dd';
        Datetime revStartDate = Datetime.newInstance(dt.year(), 04, 01);
        Datetime revEndDate = Datetime.newInstance(dt.year()+1, 04, 01);
        //String revQuery =  'select Opportunity_item_id__c from revenue_term__c where Business_Category_Revenue__c LIKE \''+'%New business%'+ '\' AND Revenue_Date__c >= '+revStartDate.format(dtFormate)+'';
        String revQuery =  'select Opportunity_item_id__c from revenue_term__c where Business_Category_Revenue__c LIKE \''+'%New business%'+ '\' AND Revenue_Date__c >= 2020-04-01 and Revenue_Date__c <= 2021-03-31';
        List<revenue_term__c> revsList = Database.query(revQuery);
        system.debug('dupRevList-->'+revsList.size());
        set<string> setList = new set<string>();
        for(Revenue_Term__c rev : revsList){
            setList.add(rev.Opportunity_item_id__c);
        }
        String query = 'select id from opportunity where id in:setList'; 
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<opportunity> oppList) {
        system.debug('oppListlist size-->'+oppList.size());
        try {
            // process each batch of records default size is 200
            /*IncentiveQualifiersByRevenueSplit incRev;
            set<revenue_term__c> setList = new set<revenue_term__c>();
            for(Revenue_Term__c rev : revList){
                setList.add(rev);
                //incRev = new IncentiveQualifiersByRevenueSplit(rev.Opportunity_item_id__c);
            }
            system.debug('Batch Job - setList -> '+setList.size());
            for(revenue_term__c setVal:setList){
                //incRev = new IncentiveQualifiersByRevenueSplit(setVal.Opportunity_item_id__c);
            }*/
            for(opportunity opp:oppList){
                NewIncentiveCalculation n = new NewIncentiveCalculation(opp.id);
            }
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        System.debug('IncentiveQualifier Update completed...');
    }
}