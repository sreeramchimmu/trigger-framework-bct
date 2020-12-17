/*
Trigger name : Po_Attachment_Val
Description  : This trigger is used as validation rule on Opportunity object to ensure it has Contract copy to change the Stage to Closed Won.
Author       : Maria Ashvini A
Date Created : 08-May-2020        
*/

trigger Po_Attachment_Val on Opportunity (before update) {
   
    boolean isActive = false; 
	Opportunity opp = Trigger.New[0];
    
    Trigger_Switch__c switchVar = Trigger_Switch__c.getInstance('POAttachmentValidationTrigger');
    if(switchVar != NULL && 'True'.equalsIgnorecase(String.valueOf(switchVar.is_active__c))){
          isActive = true;       
    }
    
    if(isActive){
      if(Trigger.isBefore){
        if(Trigger.isUpdate){
            
            if(opp.StageName == 'Closed Won'){
                system.debug('inside POAttachmentValidationTrigger');
                List<contentdocumentlink> filer = [select id,ContentDocumentId  
                                                  from contentdocumentlink where LinkedEntityId =: opp.id];
                if(filer.isEmpty())
                {
                    opp.addError('Please attach contract copy in the file upload section before Changing the Opportunity stage to closed own !');
                }  
            }
        }
    }  
    }
    
}