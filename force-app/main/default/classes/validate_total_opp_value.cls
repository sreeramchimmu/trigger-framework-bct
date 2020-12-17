public with sharing class validate_total_opp_value 
{
    ///public static void dataInsert(List<Opportunity_Line_Item__c> triggerNew, Map<id,Opportunity_Line_Item__c> oldMap, Map<id,Opportunity_Line_Item__c> newMap)
    public static double dataInsert(List<Opportunity_Line_Item__c> triggerNew)
    {
        DOUBLE OPLI_TOTAL_VALUE = 0;
        String opp_id=' ';
        for (Opportunity_Line_Item__c opli : triggerNew)
        {
            // integer[] tot_value = [SELECT TOTAL_VALUE__C FROM OPPORTUNITY WHERE ID='0062800000AIk9a'];
            system.debug('Stage is :'+opli.stageName__c);
            //List<Opportunity> opp_tot_value = [SELECT total_value__c FROM Opportunity where id = :opli.Opportunity_ID__c];
            List<Opportunity_Line_Item__c> opp_tot_values = [SELECT total_value__c FROM Opportunity_Line_Item__c where Opportunity_ID__c = :opli.Opportunity_ID__c and stage__c = :opli.stageName__c];
            //system.debug('xx value '+opp_tot_values.size());
            //List<Opportunity_Line_Item__c> opp_tot_value = [SELECT total_value__c FROM Opportunity_Line_Item__c where Opportunity_ID__c= '0062800000AIk9a'];
            for (Opportunity_Line_Item__c opp_tot_value : opp_tot_values)
            {
                //system.debug('opp_tot_value value :'+ opp_tot_value);
                OPLI_TOTAL_VALUE = OPLI_TOTAL_VALUE + opp_tot_value.Total_Value__c;
            }
            // OPLI_TOTAL_VALUE = OPLI_TOTAL_VALUE + opp_tot_value.Total_Value__c;
             //OPLI_TOTAL_VALUE = opp_tot_value;
        }      
        //system.debug('Class Value is :'+ OPLI_TOTAL_VALUE);
        RETURN OPLI_TOTAL_VALUE;
    }

    
    Public static double dataUpdate(List<Opportunity_Line_Item__c> triggerNew)
     {
        DOUBLE DIFF_OPLI_VALUE = 0;
        DOUBLE OPLI_TOTAL_VALUE = 0;
        String opp_id=' ';
        for (Opportunity_Line_Item__c opli : triggerNew)
        {
            //List<Opportunity_Line_Item__c> opp_tot_values = [SELECT total_value__c FROM Opportunity_Line_Item__c where Opportunity_ID__c = :opli.Opportunity_ID__c and stage__c = :opli.stageName__c];
            List<Opportunity_Line_Item__c> opp_tot_values = [SELECT total_value__c FROM Opportunity_Line_Item__c where id = :opli.id and stage__c = :opli.stageName__c];
            for (Opportunity_Line_Item__c opp_tot_value : opp_tot_values)
            {
                //system.debug('opp_tot_value value :'+ opp_tot_value);
                DIFF_OPLI_VALUE = opp_tot_value.Total_Value__c - OPLI.Total_Value__c;
                //if (DIFF_OPLI_VALUE > 0)
                    //OPLI_TOTAL_VALUE = DIFF_OPLI_VALUE;
                system.debug('UPDATE DIFF_OPLI_VALUE'+DIFF_OPLI_VALUE);
                //else
            }
           // OPLI_TOTAL_VALUE = OPLI_TOTAL_VALUE + opp_tot_value.Total_Value__c;
           //  OPLI_TOTAL_VALUE = opp_tot_value;
        }      
        //system.debug('Class Value is :'+ OPLI_TOTAL_VALUE);
        RETURN DIFF_OPLI_VALUE;

    }
}