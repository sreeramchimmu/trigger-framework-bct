trigger IncentiveQualifierManageTrigger on Opportunity_Line_Item__c (after update,after delete) {

       boolean isActive = false;
 List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='IncentiveQualifierManageTrigger' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings){
        isActive = true;
    }
        if(isActive){
            
                String oldIncenticveQualifier ;
                String newIncenticveQualifier ;
                String newProduct;
                String oldProduct;
                String newCompetency;
                String oldCompetency;
                id opplineId;
            
            
             system.debug('IncentiveQualifierManageTrigger Trigger is ACTIVE');
            if(Trigger.isAfter && Trigger.isUpdate){   
               
                
           List <opportunity_line_item__c> oplObj = Trigger.new;
            
            for (opportunity_line_item__c oplNewMap : Trigger.new) {
                opportunity_line_item__c oplOldMap =Trigger.OldMap.get(oplNewMap.Id);
                oldIncenticveQualifier = oplOldMap.Incentive_Qualifier__c ;
                newIncenticveQualifier = oplNewMap.Incentive_Qualifier__c ;
                newProduct = oplNewMap.Product__c;
                oldProduct = oplOldMap.Product__c;
                newCompetency = oplNewMap.Competency__c;
                oldCompetency = oplOldMap.Competency__c;
                opplineId = oplNewMap.id;
            }
            
            if(!oldIncenticveQualifier.equalsIgnoreCase(newIncenticveQualifier)){
               List <Actual_Detail__c> actualList  =[select id, UpdateStagesRandomNo__c from Actual_Detail__c where 
                                                   RevenueTermRef__r.Opportunity_line_item_id__r.id = :opplineId];
                    for (Actual_Detail__c actList : actualList) {
                        actList.UpdateStagesRandomNo__c = math.random() ;
                    }
                     
                    update actualList;
                  }
				system.debug('Old Product-->'+ oldProduct + '   New Product --> '+ newProduct );
                system.debug('Old Competency-->'+ oldCompetency + '   New Competency --> '+ newCompetency );

                   if(!(oldProduct.equalsIgnoreCase(newProduct)) || !(newCompetency.equalsIgnoreCase(oldCompetency) ) ){
                    
                    system.debug(' Product or competency changed');
                    new ProductChangeHandler(Trigger.newMap,Trigger.oldMap).shiftProductRevenue(Trigger.newMap,Trigger.oldMap);
                 
                }
                
               /* else if( !newCompetency.equalsIgnoreCase(oldCompetency)){
                    system.debug('competency changed');
                    new ProductChangeHandler(Trigger.newMap,Trigger.oldMap).shiftProductRevenue(Trigger.newMap,Trigger.oldMap);
                 
                }*/
                
            }
            
            if(Trigger.IsAfter && Trigger.IsDelete){
            
             List<Actual_Detail__c> actObj = [SELECT ID, RevenueTermRef__c, Actual_Revenue_RecognizedAmount__c FROM actual_detail__c where RevenueTermRef__r.Opportunity_line_item_id__r.id = :opplineId ];
		system.debug('actObj  ' + actObj.size() +'--->  '+ actObj);          
        if(actObj.size() > 0){
                try{
                     system.debug('After deleting opportunity line items for deleting actuals ' + actObj); 
                 	 delete actObj;
                	}Catch(DMLexception dmle){
                    system.debug('Error while deleting Actual details ' + dmle); 
                }
    		}
            
            
            
            }            
            
            
            
        }
    else
    {
         system.debug('IncentiveQualifierManageTrigger Trigger is INACTIVE');
    }
 
}