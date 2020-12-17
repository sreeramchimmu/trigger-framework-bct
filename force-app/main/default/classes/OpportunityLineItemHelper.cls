/**
* Class: OpportunityLineItemHelper
*
* Author: Revathy Saminathan
*
* Date Created: 24.11.2020
*
* Purpose: OpportunityLineItemHelper is a handler class for all business logic related to opportunity line item object
* 
*/
public class OpportunityLineItemHelper {
    
    public static void opportunityLineItemAfterDelete(List<Opportunity_Line_Item__c> triggerOldList)
    {
        List<Archive_Opportunity_Line_Item__c> arcOppLine = new List<Archive_Opportunity_Line_Item__c>(); 
        List<Actual_Detail__c> aDetailUpdateList = new List<Actual_Detail__c>();
        Set<Id> oppId = new Set<Id>();
        for(Opportunity_Line_Item__c opL : triggerOldList)
        { 
            for(Archive_Opportunity_Line_Item__c arOpLine:[Select id from Archive_Opportunity_Line_Item__c where Opp_Line_Id__c =:opL.Id and Archive_Opportunity_line_item_Snapshot__c = This_Month]){
                arcOppLine.add(arOpLine);  
            }
            
            for(Actual_Detail__c aD : [SELECT ID, RevenueTermRef__c, Actual_Revenue_RecognizedAmount__c FROM actual_detail__c where RevenueTermRef__r.Opportunity_line_item_id__r.id = :opL.Id])
            {
                System.debug('Actual detail delete >>'+aD.Name);
                aDetailUpdateList.add(aD);
            }
            
            if(opL.Opportunity_ID__c != Null){
                oppId.add(opL.Opportunity_ID__c);
            }
            
        }
        if(oppId.size() > 0)
        {
            updateOpportunityFields(oppId,triggerOldList);
        }
        
        if(aDetailUpdateList.size() > 0)
        {
            try
            {  
                System.debug('Actual Detail record Deleted successfully???'+aDetailUpdateList.size());
                delete aDetailUpdateList;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            }  
        }
        if(arcOppLine.size() > 0)
        {
            try
            {  
                System.debug('Archive Opp line Deleted successfully???'+arcOppLine.size());
                delete arcOppLine;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            }   
        }  
    }
    
    public static void updateOpportunityFields(Set<Id> opId,List<Opportunity_Line_Item__c> triggerOldList)
    {
       //  List<Opportunity> opList = [Select id,Project_ID__c,Practice__c,Pillars__c,Competencies__c,Product__c from Opportunity where id in: opId];
    }
    public static void opportunityLineItemAfterUpdate(Map<Id, Opportunity_Line_Item__c> oppNewItems, Map<Id, Opportunity_Line_Item__c> oppOldItems)
    {
        List<Opportunity_Line_Item__c> triggerNewList = oppNewItems.values();
        Set<Id> opLineId = new Set<Id>();
        Set<Id> oppOldId = new Set<Id>();
        
        
        for(Opportunity_Line_Item__c oL : triggerNewList)
        {
            oppOldId.add(oL.Opportunity_ID__c);
            if(oL.Incentive_Qualifier__c != oppOldItems.get(oL.Id).Incentive_Qualifier__c)
            {
                opLineId.add(oL.Id);
            }
            
            if(oL.Product__c != oppOldItems.get(oL.Id).Product__c || 
               oL.Competency__c != oppOldItems.get(oL.Id).Competency__c)
            {  
                new ProductChangeHandler(oppNewItems,oppOldItems).shiftProductRevenue(oppNewItems,oppOldItems);  
            }
        }
        if(opLineId.size() > 0)
        {
            updateActualDetaliList(opLineId);
        }
        if(oppOldId.size() > 0)
        {
            updateOpportunityfield(oppOldId,triggerNewList);
        }
        
    }
    
    public static void updateOpportunityfield(Set<Id> opOldId, List<Opportunity_Line_Item__c> triggerNewList)
    {
        List<Opportunity> oplist = [SELECT id,Amount,Project_ID__c,StageName,
                                    Practice__c,Pillars__c,Competencies__c,Product__c FROM Opportunity where id = : opOldId];
       
        
    }
    public static void updateActualDetaliList(Set<Id> opLineId)
    {
        List<Actual_Detail__c> actDetailUpdateLst = new List<Actual_Detail__c>();
        for (Actual_Detail__c aD : [select id, UpdateStagesRandomNo__c from Actual_Detail__c where 
                                    RevenueTermRef__r.Opportunity_line_item_id__r.id = :opLineId])
        {
            aD.UpdateStagesRandomNo__c = math.random() ;
            actDetailUpdateLst.add(aD);
        } 
        if(actDetailUpdateLst.size() > 0)
        {
            try
            {   
                update actDetailUpdateLst;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            } 
        }
    }
    
    public static void opportunityLineItemBeforeInsert(List<Opportunity_Line_Item__c> triggerNewList)
    {     
        Set<Id> opLId = new Set<Id>();
        Set<Id> oppNewId = new Set<Id>();
 
        // code block for validation functionalty before insert--- STARTS
        double tot_order_val =0;
        double newValue =0;
        double opp_line_tot;
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT id,Amount,Project_ID__c,StageName, Practice__c  FROM Opportunity where id IN :oppNewId]
        );
        
        List<Opportunity_Line_Item__c> billing_tot_value = [SELECT Id, Opportunity_ID__c, Total_Value__c,Project_ID__c,Practice__c,Pillar__c,Competency__c, Product__c FROM Opportunity_Line_Item__c where Opportunity_ID__c IN :oppNewId];
        
        for(Opportunity_Line_Item__c oli : triggerNewList){
            
         /*   opp_line_tot = 0;            
            tot_order_val = oppMap.get(oli.Opportunity_ID__c).Amount;
            newValue = oli.Total_Value__c; 
            
           		system.debug('newValue : '+newValue);
            for(Opportunity_Line_Item__c  billing_value : billing_tot_value){
                if(oppMap.get(oli.Opportunity_ID__c).id == billing_value.Opportunity_ID__c){
                 	opp_line_tot = opp_line_tot + billing_value.Total_Value__c;   
                }				
			} 
            
            opp_line_tot = opp_line_tot + newValue;
                
            if(opp_line_tot > tot_order_val){
                oli.addError('NEW TRIGGER FRAMEWORK Opportunity Line total value should not exceed the Total Order Value!!');	
            }*/
             oppNewId.add(oli.Opportunity_ID__c); 
        }  
        
        // code block for validation functionalty before insert --- ENDS
        
        
        if(oppNewId.size() > 0)
        {
            System.debug('invoke before insert');
            opportunityFieldsUpdate(oppNewId,triggerNewList); 
        }
        
    }
    
    public static void opportunityLineItemBeforeUpdate(List<Opportunity_line_item__c> newItems, Map<Id, Opportunity_line_item__c> oldItems){
      	Set<Id> setIds = new Set<Id>();    
        Set<Id> setBillIds = new Set<Id>(); 
        Set<Id> oppId = new Set<Id>();
        
        for(Opportunity_line_item__c oli : newItems)
        {
            if(oli.Opportunity_ID__c != null){
                setIds.add(oli.Opportunity_ID__c);
                setBillIds.add(oli.ID);
            }
            if(oli.Project_ID__c != oldItems.get(oli.id).Project_ID__c || oli.Practice__c != oldItems.get(oli.id).Practice__c || 
               oli.Pillar__c != oldItems.get(oli.id).Pillar__c || oli.Competency__c != oldItems.get(oli.id).Competency__c || 
               oli.Product__c != oldItems.get(oli.id).Product__c)
            {
                oppId.add(oli.Opportunity_ID__c);
            }
        }
        if(oppId.size() > 0)
        {
            opportunityfieldAfterUpdate(oppId,newItems);
        }
        
        double tot_order_val =0;
        double newValue =0;
        double opp_line_tot;
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT id,Amount,Project_ID__c,StageName, Practice__c  FROM Opportunity where id IN :setIds]
        );
        system.debug('oppMap size :'+oppMap.size());
        List<Opportunity_Line_Item__c> oli_tot_value = [SELECT Id, Opportunity_ID__c, Total_Value__c FROM Opportunity_Line_Item__c where Opportunity_ID__c IN :setIds and id != :setBillIds];
        system.debug('oli_tot_value size :'+oli_tot_value.size());
        for(Opportunity_Line_Item__c oli : newItems){
            
            opp_line_tot = 0;            
            tot_order_val = oppMap.get(oli.Opportunity_ID__c).Amount;
            newValue = oli.Total_Value__c; 
            
           		system.debug('newValue : '+newValue);
            for(Opportunity_Line_Item__c  oli_value : oli_tot_value){
                if(oppMap.get(oli.Opportunity_ID__c).id == oli_value.Opportunity_ID__c){
                 	opp_line_tot = opp_line_tot + oli_value.Total_Value__c;   
                }				
			} 
            
            opp_line_tot = opp_line_tot + newValue;
            system.debug('opp_line_tot : '+opp_line_tot);
            system.debug('tot_order_val : '+tot_order_val);
            if(opp_line_tot > tot_order_val){
                oli.addError('NEWi TRIGGER FRAMEWORK Opportunity Line total value should not exceed the Total Order Value!!');	
            }
        }       
    }
    
    public static void opportunityfieldAfterUpdate(Set<Id> oppNewId , List<Opportunity_Line_Item__c> triggerNewList)
    {
        
        String opp_projectid ;
        String opp_practice ;
        String opp_pillar;
        String opp_competency;
        String opp_product;
        List<Opportunity_Line_Item__c> oppLineList =[SELECT Id, Opportunity_ID__r.Funnel_Code__c, Opportunity_ID__c, Total_Value__c,
                                                     Project_ID__c,Practice__c,Pillar__c,Competency__c,Product__c FROM Opportunity_Line_Item__c where Opportunity_ID__c =: oppNewId];
        List<Opportunity> opList = [SELECT id,Amount,Project_ID__c,StageName,
                                    Practice__c,Pillars__c,Competencies__c,Product__c FROM Opportunity where id = : oppNewId];
        List<Opportunity> opListUpdate = new List<Opportunity>();
        for(Opportunity op : opList)
        { 
            for(Opportunity_Line_Item__c olI : oppLineList)
            {
                if(op.Id == olI.Opportunity_ID__c)
                {    
                    opp_projectid = null != opp_projectid ? opp_projectid +  ',' + olI.Project_ID__c :  olI.Project_ID__c;
                    opp_practice = null != opp_practice ? opp_practice + ','+ olI.Practice__c : olI.Practice__c;
                    opp_pillar = null != opp_pillar ? opp_pillar + ','+ olI.Pillar__c : olI.Pillar__c;
                    opp_competency = null != opp_competency ? opp_competency + ','+  olI.Competency__c :  olI.Competency__c;
                    opp_product = null != opp_product ? opp_product + ','+ olI.Product__c : olI.Product__c; 
                    
                }
            }
            op.Project_ID__c = opp_projectid ;
            op.Practice__c = opp_practice ;
            op.Pillars__c = opp_pillar;
            op.Competencies__c = opp_competency;
            op.Product__c = opp_product; 
            opListUpdate.add(op);
        }
        if(opListUpdate.size() > 0)
        {
            try
            {   
                update opListUpdate;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            } 
        }
    }
    public static void opportunityFieldsUpdate(Set<Id> oppNewId , List<Opportunity_Line_Item__c> triggerNewList)
    {
        List<Opportunity> opList = [SELECT id,Amount,Project_ID__c,StageName,
                                    Practice__c,Pillars__c,Competencies__c,Product__c FROM Opportunity where id = : oppNewId];
        List<Opportunity> opListUpdate = new List<Opportunity>();
        for(Opportunity_Line_Item__c olI : triggerNewList)
        {
            System.debug('Inside the opportunity line item update field>>>'+olI);
            for(Opportunity o : opList)
            {
                System.debug('Inside the opportunity update field>>>'+o.id+'opp line item >>'+olI.id);
                if(o.Id == olI.Opportunity_ID__c)
                {
                    if(o.Project_ID__c == Null)
                    {
                        o.Project_ID__c = olI.Project_ID__c;
                    }
                    else if(o.Project_ID__c <> olI.Project_ID__c)
                    {
                        o.Project_ID__c = o.Project_ID__c + ',' + olI.Project_ID__c;
                    }
                    
                    if(o.Practice__c == Null)
                    {
                        o.Practice__c = olI.Practice__c;
                    }
                    else if(o.Practice__c <> olI.Practice__c)
                    {
                        o.Practice__c = o.Practice__c + ',' + olI.Practice__c;
                    }
                    
                    if(o.Pillars__c == Null)
                    {
                        o.Pillars__c = olI.Pillar__c;
                    }
                    else if(o.Pillars__c <> olI.Pillar__c)
                    {
                        o.Pillars__c = o.Pillars__c + ',' + olI.Pillar__c;
                    }
                    
                    if(o.Competencies__c == Null)
                    {
                        o.Competencies__c = olI.Competency__c;
                    }
                    else if(o.Competencies__c <> olI.Competency__c)
                    {
                        o.Competencies__c = o.Competencies__c + ',' + olI.Competency__c;
                    }
                    if(o.Product__c == Null)
                    {
                        o.Product__c = olI.Product__c;
                    }
                    else if(o.Product__c <> olI.Product__c)
                    {
                        o.Product__c = o.Product__c + ',' + olI.Product__c;
                    }
                    opListUpdate.add(o);
                }
            }
        }
        if(opListUpdate.size() > 0)
        {
            try
            {   
                update opListUpdate;   
            }catch(Exception e)
            { 
                HandleCustomException.LogException(e); 
            } 
        }  
    } 
}