trigger Line_Item_Total_update on Opportunity (after update,after Delete) 
{
    /* for(Opportunity oppObject : trigger.new)
{

system.debug('Trigger New Value is :'+ trigger.new);
system.debug('Trigger Old Value is :'+ trigger.old);


if (trigger.oldMap.get(oppObject.id).StageName != trigger.newMap.get(oppObject.id).StageName)
//if (trigger.old.StageName != oppObject.StageName)
{
oppObject.Line_Item_Total__c=0;

}
update oppObject;

}*/ 
    boolean isActive = false;
    
    Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('Line_Item_Total_update');
    if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c)))   {
        isActive = true;
        system.debug('inside switchVar Line_Item_Total_update :: '+limits.getQueries());
    } 
    if(isActive){ 
        System.debug('IsActive Inside>>>'+isActive);
        if(trigger.isAfter && trigger.isDelete) 
        { 
            System.debug('Archive after Delete');
            List<Archive_Opportunity__c> arcOpp = new List<Archive_Opportunity__c>(); 
            for(Opportunity op:Trigger.old){ // Iterating over Revenue  list 
                System.debug('Delete opt'+op.Id);
                for(Archive_Opportunity__c arOp:[Select id from Archive_Opportunity__c where Opportunity_Id__c=:op.Id and Archive_Opportunity_Snapshot__c = This_Month]){
                    arcOpp.add(arOp);  
                    System.debug('Archive Oppty>>'+arcOpp.size());
                }
            }
            if(arcOpp.size() > 0)
            { 
                try
                {   
                    System.debug('Delete Success');
                    delete arcOpp; 
                }catch(Exception e)
                { 
                    System.debug('Delete exception');
                    HandleCustomException.LogException(e); 
                }  
            }  
        }
        
    }
    
}