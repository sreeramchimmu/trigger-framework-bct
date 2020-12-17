trigger OppTotalLineItemsValueCheckTrigger on Opportunity_Line_Item__c (before insert,before update,after update,after delete) {
    
    
    double opp_line_tot =0;
    double opp_line_val =0;
    double tot_order_val =0;
    double newValue =0;
    double opp_line_value =0;
    boolean isActive = false; 
    
    List<TriggerSwitch__c> trgsettings = [SELECT Id, IS_ACTIVE__c, Name FROM TriggerSwitch__c where Name='OppTotalLineItemsValueCheckTrigger' and IS_ACTIVE__c=true];
    for(TriggerSwitch__c trig : trgsettings)
    {
        isActive = true;
    }     
    if(isActive)
    {
        List <opportunity_line_item__c> opl_value = Trigger.new;
        
        //Before trigger
        
        if(trigger.isbefore){
            
            //List<Opportunity> opp_total_value = [SELECT id,Amount,Project_ID__c,StageName, SubmitForApproval__c, Practice__c,Cyclic_Key__c,BillingTerm_Milestone_Amount__c, Revenue_Term_Roll_Summary_value__c,Funnel_Code__c,Approval_Status__c, Approval_Key__c FROM Opportunity where id = :opl_value[0].Opportunity_ID__c];
            List<Opportunity> opp_total_value = [SELECT id,Amount,Project_ID__c,StageName, Practice__c  FROM Opportunity where id = :opl_value[0].Opportunity_ID__c];
            for(Opportunity opp_Value : opp_total_value){
                tot_order_val =opp_value.Amount;
                
                if(trigger.isinsert){
                    
                    newValue = opl_value[0].Total_Value__c; 
                    List<opportunity_line_item__c> oppIds = new List<opportunity_line_item__c>([SELECT Id, Opportunity_ID__c, Total_Value__c,Project_ID__c,Practice__c,Pillar__c,Competency__c, Product__c FROM Opportunity_Line_Item__c where Opportunity_ID__c = :opl_value[0].Opportunity_ID__c]);
                    for(opportunity_line_item__c opp : oppIds){
                        
                        opp_line_tot = opp_line_tot + opp.Total_Value__c; 
                        
                    }
                    
                    opp_line_tot = opp_line_tot + newValue; 
                    
                    
                    if(opp_line_tot > tot_order_val)
                    {
                        opl_value[0].addError('Opportunity Line total value should not exceed the Total Order Value!!');
                        
                    }
                    
                    //check for project id
                    if(opp_Value.Project_ID__c == NULL)
                    {
                        opp_Value.Project_ID__c = opl_value[0].Project_ID__c;
                    }
                    else if(opp_Value.Project_ID__c <> opl_value[0].Project_ID__c)
                    {    
                        opp_Value.Project_ID__c = opp_Value.Project_ID__c+','+opl_value[0].Project_ID__c ;      
                    }
                    
                    
                    //check for practice
                    if(opp_Value.Practice__c == NULL)
                    {
                        opp_Value.Practice__c = opl_value[0].Practice__c;
                    }
                    else if(opp_Value.Practice__c <> opl_value[0].Practice__c)
                    {    
                        opp_Value.Practice__c = opp_Value.Practice__c+','+opl_value[0].Practice__c ;      
                    }           
                    
                    //check for pillar
                    if(opp_Value.Pillars__c == NULL)
                    {
                        opp_Value.Pillars__c = opl_value[0].Pillar__c;
                    }
                    else if(opp_Value.Pillars__c <> opl_value[0].Pillar__c)
                    {    
                        opp_Value.Pillars__c = opp_Value.Pillars__c+','+opl_value[0].Pillar__c ;      
                    }             
                    
                    //check for competency
                    if(opp_Value.Competencies__c == NULL)
                    {
                        opp_Value.Competencies__c = opl_value[0].Competency__c;
                    }
                    else if(opp_Value.Competencies__c <> opl_value[0].Competency__c)
                    {    
                        opp_Value.Competencies__c = opp_Value.Competencies__c +','+opl_value[0].Competency__c ;      
                    }       
                    
                    
                    //check for product
                    if(opp_Value.Product__c == NULL)
                    {
                        opp_Value.Product__c = opl_value[0].Product__c;
                    }
                    else if(opp_Value.Product__c <> opl_value[0].Product__c)
                    {    
                        opp_Value.Product__c = opp_Value.Product__c +','+opl_value[0].Product__c ;      
                    }             
                    update opp_Value;
                }      
            } 
            if(trigger.isupdate) {
 
                List <opportunity_line_item__c> opl_value_old = Trigger.new;
                List<opportunity_line_item__c> opp_Ids = new List<opportunity_line_item__c>([SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where Opportunity_ID__c = :opl_value_old[0].Opportunity_ID__c and id != :opl_value_old[0].id]);
                for(opportunity_line_item__c oppl : opp_Ids){
                    
                    opp_line_tot = opp_line_tot + oppl.Total_Value__c;
                } 
                double newOppLineTotal =  opl_value[0].Total_Value__c + opp_line_tot;
                
                system.debug('changing opportunity total value!!!!!!!!!!!'+newOppLineTotal );
                
                if( newOppLineTotal >  tot_order_val)
                {
                    opl_value[0].addError('Opportunity Line total value should not exceed the Total Order Value!!');
                    
                }                 
            } 
        } 
        
        //After Trigger
        
        if ((trigger.isAfter && trigger.isupdate) || (trigger.isAfter && trigger.isdelete)) { 
             
            String opp_projectid ;
            String opp_practice ;
            String opp_pillar;
            String opp_competency;
            String opp_product;  
            
            Integer i=0;  
            
            For (opportunity_line_item__c opl_values : trigger.OLD){
                  ID OPMID = opl_values.Opportunity_ID__c;
                Opportunity oppObj = new Opportunity(ID=OPMID);
                
                List<opportunity_line_item__c> opl_List = new List<opportunity_line_item__c>([SELECT Id, Opportunity_ID__r.Funnel_Code__c, Opportunity_ID__c, Total_Value__c,Project_ID__c,Practice__c,Pillar__c,Competency__c,Product__c FROM Opportunity_Line_Item__c where Opportunity_ID__c = :opl_values.Opportunity_ID__c]); 
                list<Opportunity> opp_List= new list<Opportunity>(); 
                for(i=0; i<opl_List.size(); i++) {
                    opp_projectid = null != opp_projectid ? opp_projectid +  ',' + opl_List[i].Project_ID__c :  opl_List[i].Project_ID__c;
                    opp_practice = null != opp_practice ? opp_practice + ','+ opl_List[i].Practice__c : opl_List[i].Practice__c;
                    opp_pillar = null != opp_pillar ? opp_pillar + ','+ opl_List[i].Pillar__c : opl_List[i].Pillar__c;
                    opp_competency = null != opp_competency ? opp_competency + ','+  opl_List[i].Competency__c :  opl_List[i].Competency__c;
                    opp_product = null != opp_product ? opp_product + ','+ opl_List[i].Product__c : opl_List[i].Product__c; 
                }  
                
                oppObj.Project_ID__c = opp_projectid ;
                oppObj.Practice__c = opp_practice ;
                oppObj.Pillars__c = opp_pillar;
                oppObj.Competencies__c = opp_competency;
                oppObj.Product__c = opp_product; 
                opp_List.add(oppObj);
                 
                if(null != opl_List && opl_List.size()>=0)
                {
                    try{
                        update opp_List;
                        
                    }
                    catch(DMLException dmle){
                        system.debug('::Error while Updating opportunity line item datas in Opportunity Header::' + dmle); 
                    }
                }
            }
            
        }
        else
        {
            system.debug('OppTotalLineItemsValueCheck Trigger is set to IN ACTIVE');
        }
    }  
}