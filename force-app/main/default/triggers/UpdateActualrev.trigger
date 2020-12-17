//Created By Rameez on 15/10/2019
trigger UpdateActualrev on Opportunity (after update) {
       
     boolean isActive = false; 
     /*List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='UpdateActualrev' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings)
    {
        system.debug('UpdateActualRev Trigger is ACTIVE111111'); 
       isActive = true;
    }*/
    
    Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('UpdateActualrev');
        if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c))){
           isActive = true;
           system.debug('inside switchVar UpdateActualrev :: '+limits.getQueries());
        }
    
    if(RunTriggerOnce.calledOnceflag == true)
    {
        system.debug('RunTriggerOnce Trigger is ACTIVE222222222'); 
        if(isActive)
        {
          system.debug('UpdateActualRev Trigger is ACTIVE');  
        if(trigger.isAfter && trigger.isUpdate)  
        {
            if((trigger.old[0].Probability__c!=trigger.new[0].Probability__c)||(trigger.old[0].StageName!=trigger.new[0].StageName)){
        //To update Actual_Forecast_Rev__c + Current_FY_Act_Fst_Raw_Rev__c for Opp.probability on 21/10/2019
        system.debug('UpdateActualRev Trigger is ACTIVE');
        List<Revenue_Term__c> ActualRev_revenueListToUpdate = new List<Revenue_Term__c>();
        List<Revenue_Term__c> ActualRev_RevenueList = new List<Revenue_Term__c>();
        List<Revenue_Term__c> Closewon_RevenueList = new List<Revenue_Term__c>();
        ActualRev_RevenueList =[SELECT Id,Name,Recognized_Amount__c,W_Avg_Total_Revenue__c,
                                Actual_Forecast_Rev__c,Overall_Act_Forecast_Revenue__c,Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Cogsbctpl_Rev__c ,Total_Revenue_Cogsothers_Rev__c ,Total_Revenue_GM_Rev__c ,Wt_Avg_Cogs_Bctpl_Rev__c ,Wt_Avg_Cogs_Others_Rev__c ,Wt_Avg_GM_Rev__c ,Overall_Revenue_Raw_Cogsbctpl__c ,Overall_Revenue_Raw_Cogsother__c ,Overall_Revenue_Raw_GM__c ,Overall_WtAvg_Cogsbctpl_Rev__c ,Overall_WtAvg_Cogsother_Rev__c ,Overall_WtAvg_GM_Rev__c,Actual_COGS_BCTPL__c ,Actual_COGS_Others__c ,Actual_GM__c,
                                Total_Revenue_Raw_Fcst__c,Percentage__c FROM Revenue_Term__c WHERE Opportunity_line_item_id__c IN (SELECT id FROM Opportunity_Line_Item__c where Opportunity_ID__c IN :Trigger.new)];
        if(ActualRev_RevenueList.size()>0){
            system.debug('ActualRev_RevenueList - is not empty');
        for (Opportunity  newOpp1 : trigger.new)  
         { 
             Opportunity oldOpp1 = trigger.oldMap.get(newOpp1.Id); 
             system.debug('oldOpp1.StageName--->'+newOpp1.StageName);
             //stem.debug('oldOpp1.Probability__c--->'+oldOpp1.Probability__c);
             //system.debug('newOpp1.Probability__c--->'+newOpp1.Probability__c);
             if(newOpp1.StageName =='Closed Won'){
                     system.debug('Opportunity stage after closedOwn --> '+newOpp1.StageName);
                 RunTriggerOnce.calledOnceflag = false; 
                  for(Revenue_Term__c rev1:ActualRev_RevenueList){
                    rev1.Actual_Forecast_Rev__c = rev1.Recognized_Amount__c==NULL?rev1.Percentage__c:rev1.Recognized_Amount__c;
                    rev1.Current_FY_Act_Fst_Raw_Rev__c = rev1.Recognized_Amount__c==NULL?rev1.Percentage__c:rev1.Recognized_Amount__c;
                    //Gowtham - added below fields for CogsBctpl ,CogsOther & GM
                    /*rev1.Total_Revenue_Cogsbctpl_Rev__c  = rev1.Overall_Revenue_Raw_Cogsbctpl__c;
                    rev1.Total_Revenue_Cogsothers_Rev__c   = rev1.Overall_Revenue_Raw_Cogsother__c;
                    rev1.Total_Revenue_GM_Rev__c  = rev1.Overall_Revenue_Raw_GM__c;
                    rev1.Wt_Avg_Cogs_Bctpl_Rev__c = rev1.Overall_WtAvg_Cogsbctpl_Rev__c;
                    rev1.Wt_Avg_Cogs_Others_Rev__c = rev1.Overall_WtAvg_Cogsother_Rev__c;
                    rev1.Wt_Avg_GM_Rev__c = rev1.Overall_WtAvg_GM_Rev__c;
                    system.debug('::::Rollup:::::Inside closed won');
                    system.debug('rev1.Overall_Revenue_Raw_Cogsbctpl__c-->'+rev1.Overall_Revenue_Raw_Cogsbctpl__c);
                    system.debug('rev1.Overall_Revenue_Raw_Cogsother__c-->'+rev1.Overall_Revenue_Raw_Cogsother__c);
                    system.debug('rev1.Overall_Revenue_Raw_GM__c-->'+rev1.Overall_Revenue_Raw_GM__c);
                    system.debug('rev1.Overall_WtAvg_Cogsbctpl_Rev__c-->'+rev1.Overall_WtAvg_Cogsbctpl_Rev__c);
                    system.debug('rev1.Overall_WtAvg_Cogsother_Rev__c-->'+rev1.Overall_WtAvg_Cogsother_Rev__c);
                    system.debug('rev1.Overall_WtAvg_GM_Rev__c-->'+rev1.Overall_WtAvg_GM_Rev__c);*/
                      
                    rev1.Total_Revenue_Cogsbctpl_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_Cogsbctpl__c:rev1.Actual_COGS_BCTPL__c;
                    rev1.Total_Revenue_Cogsothers_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_Cogsother__c:rev1.Actual_COGS_Others__c;
                    rev1.Total_Revenue_GM_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_GM__c:rev1.Actual_GM__c;
                    rev1.Wt_Avg_Cogs_Bctpl_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_Cogsbctpl__c:rev1.Actual_COGS_BCTPL__c;
                    rev1.Wt_Avg_Cogs_Others_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_Cogsother__c:rev1.Actual_COGS_Others__c;
                    rev1.Wt_Avg_GM_Rev__c  = rev1.Recognized_Amount__c==NULL?rev1.Overall_Revenue_Raw_GM__c:rev1.Actual_GM__c;
                    //system.debug('rev.Overall_Act_Forecast_Revenue__c11-->' + rev1.Overall_Act_Forecast_Revenue__c);
                    //system.debug('rev.Actual_Forecast_Rev__c11-->' + rev1.Actual_Forecast_Rev__c);
                    //system.debug('RevenueList - Actual+Forcast - After Update11' + rev1);
                    Closewon_RevenueList.add(rev1);
                 
               }
             }
             if(oldOpp1.Probability__c!=newOpp1.Probability__c){
                 system.debug('Probability__c--->'+oldOpp1.Probability__c+'--NEW---'+newOpp1.Probability__c);
                 for(Revenue_Term__c rev:ActualRev_RevenueList){
                    rev.Actual_Forecast_Rev__c = rev.Overall_Act_Forecast_Revenue__c;
                    rev.Current_FY_Act_Fst_Raw_Rev__c = rev.Total_Revenue_Raw_Fcst__c;
                    //Gowtham - added below fields for CogsBctpl ,CogsOther & GM
                    rev.Total_Revenue_Cogsbctpl_Rev__c  = rev.Overall_Revenue_Raw_Cogsbctpl__c;
                    rev.Total_Revenue_Cogsothers_Rev__c   = rev.Overall_Revenue_Raw_Cogsother__c;
                    rev.Total_Revenue_GM_Rev__c  = rev.Overall_Revenue_Raw_GM__c;
                    rev.Wt_Avg_Cogs_Bctpl_Rev__c = rev.Overall_WtAvg_Cogsbctpl_Rev__c;
                    rev.Wt_Avg_Cogs_Others_Rev__c = rev.Overall_WtAvg_Cogsother_Rev__c;
                    rev.Wt_Avg_GM_Rev__c = rev.Overall_WtAvg_GM_Rev__c;
                     
                    system.debug('::::Rollup:::::Outside closed won');
                    system.debug('rev.Overall_Revenue_Raw_Cogsbctpl__c-->'+rev.Overall_Revenue_Raw_Cogsbctpl__c);
                    system.debug('rev.Overall_Revenue_Raw_Cogsother__c-->'+rev.Overall_Revenue_Raw_Cogsother__c);
                    system.debug('rev.Overall_Revenue_Raw_GM__c-->'+rev.Overall_Revenue_Raw_GM__c);
                    system.debug('rev.Overall_WtAvg_Cogsbctpl_Rev__c-->'+rev.Overall_WtAvg_Cogsbctpl_Rev__c);
                    system.debug('rev.Overall_WtAvg_Cogsother_Rev__c-->'+rev.Overall_WtAvg_Cogsother_Rev__c);
                    system.debug('rev.Overall_WtAvg_GM_Rev__c-->'+rev.Overall_WtAvg_GM_Rev__c);
                    //system.debug('rev.Overall_Act_Forecast_Revenue__c-->' + rev.Overall_Act_Forecast_Revenue__c);
                    //system.debug('rev.Actual_Forecast_Rev__c-->' + rev.Actual_Forecast_Rev__c);
                    //system.debug('RevenueList - Actual+Forcast - After Update' + rev);
                    ActualRev_revenueListToUpdate.add(rev);
                }
              }
          }
              
              
              
          }
              
           if(Closewon_RevenueList.size() > 0)
            {
             try{
                 system.debug('Updation completed in Opportunity object'); 
                  update Closewon_RevenueList;
                 }
                 catch(DmlException dmle){
                 system.debug('Error while Updating Opportunity object from opportunity trigger updateLineItemStages ::' + dmle); 
                 }
            } 
    
        
             if(ActualRev_revenueListToUpdate.size() > 0){
                 try{
                    update ActualRev_revenueListToUpdate;  
                    system.debug('ActualRev_RevenueList - Actual+Forcast - Update Complete');
                }catch(DmlException e){
                    
                    System.debug('ActualRev_RevenueList - Actual+Forcast - Update exception has occurred: ' + e.getMessage());
                 }
             }
            
           } 
          }  
        }
   }
}