public class OpportunityShareCls {
    
    public List<Opportunity_Share__mdt> shareOpplist {get; set;}
    public List<opportunityShare> oppshareUpdateLst {get; set;}
    public Set<Id> oppId {get; set;}
    
    public void ShareOpportunityRecord(){
        
        shareOpplist = [select Id,Business_Unit__c,Competency_Product_Line__c,Product__c from Opportunity_Share__mdt]; 
        
        for(Opportunity_Share__mdt opsh : shareOpplist)
        { 
            for(Opportunity_Line_Item__c oppLineItem : [select Id,Pillar__c,Competency__c,Product__c,Opportunity_ID__c from Opportunity_Line_Item__c where Pillar__c =: opsh.Business_Unit__c OR Competency__c =: opsh.Competency_Product_Line__c OR Product__c =:opsh.Product__c])
            {
                oppId.add(oppLineItem.Opportunity_ID__c);
            } 
        }
        
        if(oppId.size() > 0)
        {
            List<Opportunity> opList = [Select Id from Opportunity Where Id IN :oppId];
            List<Group> grpList = [Select Id,DeveloperName,Name from Group where id='00G150000042BHIEA2'];
            for(Opportunity op :opList){
                
                opportunityShare opptyShare = new opportunityShare();
                opptyShare.OpportunityAccessLevel = 'Edit'; 
                opptyShare.OpportunityId = op.Id;  
                opptyShare.UserOrGroupId = grpList[0].Id;  
                oppshareUpdateLst.add(opptyShare); 
            } 
        }
        
        if(oppshareUpdateLst.size() > 0)
        {
            Database.SaveResult[] srList = Database.insert(oppshareUpdateLst, false);
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully shared Opportunity ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }            
            }
        }
    }
}