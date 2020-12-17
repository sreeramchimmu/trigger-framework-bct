public class CEO_Dashboard {
    
    public String fromMonth{get;set;}
    public String toMonth{get;set;}
    public Date d1{get;set;}
    public Date d2{get;set;}
    public Integer currentYear{get;set;}
    public Integer currentMonth{get;set;}
    public Integer FY{get;set;}
    public List<String> sbu{get;set;}
    public List<String> bu{get;set;}
    public boolean sbuChart{get;set;}
    public boolean monChart{get;set;}
    public String xAxisVal{get;set;}
    public List<String> oppOwner{get;set;}
    
    public CEO_Dashboard(){
        sbu = new List<String>();
        bu = new List<String>();
        oppOwner = new List<String>();
        
        system.debug('xAxisVal>>>>>>'+xAxisVal);
        system.debug('fromMonth>>>>>>>'+fromMonth);
        system.debug('d1>>>>>>'+d1);
        
        currentYear = date.today().year();
        currentMonth = date.today().month();
        
        system.debug('Month>>>>>'+currentMonth+'>>>>>>Year>>>>>>'+currentYear);
        
        if(currentMonth<=3){
            FY = currentYear - 1;         
        }else{
            FY = currentYear + 1; 
        }
        system.debug('FY>>>>>'+FY);
        
        if(fromMonth==Null){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
    }
    
    public List<SelectOption> getMonths() {
        List<SelectOption> monthOptions = new List<SelectOption>();
        monthOptions.add(new SelectOption('1','Jan'));
        monthOptions.add(new SelectOption('2','Feb'));
        monthOptions.add(new SelectOption('3','Mar'));
        monthOptions.add(new SelectOption('4','Apr'));
        monthOptions.add(new SelectOption('5','May'));
        monthOptions.add(new SelectOption('6','Jun'));
        monthOptions.add(new SelectOption('7','Jul'));
        monthOptions.add(new SelectOption('8','Aug'));
        monthOptions.add(new SelectOption('9','Sep'));
        monthOptions.add(new SelectOption('10','Oct'));
        monthOptions.add(new SelectOption('11','Nov'));
        monthOptions.add(new SelectOption('12','Dec'));
        return monthOptions;
    }
    
    public List<SelectOption> getQuaters() {
        List<SelectOption> monthOptions = new List<SelectOption>();
        
        monthOptions.add(new SelectOption('Current FY','Current Financial Year'));
        monthOptions.add(new SelectOption('Q1','Quarter 1'));
        monthOptions.add(new SelectOption('Q2','Quarter 2'));
        monthOptions.add(new SelectOption('Q3','Quarter 3'));
        monthOptions.add(new SelectOption('Q4','Quarter 4'));
        monthOptions.add(new SelectOption('H1','Half Yearly 1'));
        monthOptions.add(new SelectOption('H2','Half Yearly 2'));
        monthOptions.add(new SelectOption('Custom Dt Picker','Custom Date Picker'));
        
        system.debug('monthOptions>>>>>>>'+monthOptions);
        return monthOptions;
    }
    
    public List<SelectOption> getXAxis() {
        List<SelectOption> xAxisOptions = new List<SelectOption>();
        xAxisOptions.add(new SelectOption('sbu','SBU'));
        xAxisOptions.add(new SelectOption('bu','BU'));
        xAxisOptions.add(new SelectOption('oppOwner','Opportunity Owner'));
        xAxisOptions.add(new SelectOption('mon','Months'));
        system.debug('xAxisOptions>>>>>>>'+xAxisOptions);
        return xAxisOptions;
    }
    
    public List<SelectOption> getRegions() {
        List<SelectOption> SBUOptions = new List<SelectOption>();
        SBUOptions.add(new SelectOption('All','All'));
        for(AggregateResult a : [select QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c GROUP BY 
                                 QuotaDetail__r.QuotaMasterNew__r.SBU__c]){
                                     String st = (String)a.get('sbu');
                                     String str;
                                     
                                     if(st.contains('- ')){
                                         str = st.substringAfter('- ');
                                         SBUOptions.add(new SelectOption((String)a.get('sbu'),str));
                                     }
                                     
                                     else if(st.contains('-')){
                                         str = st.substringAfter('-');
                                         SBUOptions.add(new SelectOption((String)a.get('sbu'),str));
                                     }
                                     
                                     else{
                                         SBUOptions.add(new SelectOption((String)a.get('sbu'),(String)a.get('sbu')));
                                     }
                                     
                                 }
        system.debug('SBUOptions>>>>>>.'+SBUOptions);
        return SBUOptions;
    }
    
    public List<SelectOption> getBusinessUnits() {
        List<SelectOption> BUOptions = new List<SelectOption>();
        BUOptions.add(new SelectOption('All','All'));
        for(AggregateResult a : [select RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c
                                 where RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c!=Null
                                 GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c]){
            BUOptions.add(new SelectOption((String)a.get('bu'),(String)a.get('bu')));
        }
        system.debug('BUOptions>>>>>>.'+BUOptions);
        return BUOptions;
    }
    
    public List<SelectOption> getopportunityOwners() {
        List<SelectOption> oppOwnersOptions = new List<SelectOption>();
        Set<Id> OwnerIds = new Set<Id>();
        oppOwnersOptions.add(new SelectOption('All','All'));
        for(AggregateResult a : [select QuotaMasterNew__r.Quota_Owner_Name__c id,QuotaMasterNew__r.Quota_Owner_Name__r.name name 
                                 from QuotaDetail__c
                                 where QuotaMasterNew__r.Quota_Owner_Name__c!=Null
                                 GROUP BY QuotaMasterNew__r.Quota_Owner_Name__c,QuotaMasterNew__r.Quota_Owner_Name__r.Name]){
                                     oppOwnersOptions.add(new SelectOption((String)a.get('id'),(String)a.get('name')));
        }
        system.debug('oppOwnersOptions>>>>>>.'+oppOwnersOptions);
        return oppOwnersOptions;
    }
    
    public List<Data> getData() {
        
        if(xAxisVal=='SBU' || xAxisVal==Null){
        system.debug('d1>>>>>'+d1);
        system.debug('xAxisVal>>>>>>'+xAxisVal);
        system.debug('fromMonth>>>>>>>>'+fromMonth);       
        system.debug('sbu>>>>>>>>>>'+sbu);
        
        if(fromMonth=='Q1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 7, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 7, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q3'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(currentYear, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(FY, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q4'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(FY, 1, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(currentYear, 1, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            
        }
        if(fromMonth=='Current FY'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        
        system.debug('d1>>>>>'+d1);
        system.debug('d2>>>>>'+d2);
        system.debug('fromMonth>>>>>'+fromMonth+'>>>>>toMonth>>>>>'+tomonth);
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May',
            6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sep',10=>'Oct',
            11=>'Nov', 12=>'Dec'};
        
        Set<Id> QuotaDetailIDs = new Set<Id>();
		List<AggregateResult> AggregateQuotaResults = new List<AggregateResult>();  
        Map<String, Decimal> AggregateQuotaMap = new Map<String,Decimal>();
        List<AggregateResult> AggregateResults = new List<AggregateResult>();
        
        system.debug('sbu>>>>>>>'+sbu);
        system.debug('bu>>>>>>>'+bu);
        system.debug('oppOwner>>>>>>>'+oppOwner);
        
        if(oppOwner.size()>0 && !oppOwner.contains('All') && (sbu.contains('All') || sbu.size()<=0) && (bu.contains('All') || bu.size()<=0)){
            system.debug('1');
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.OwnerId,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                     AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
                                    
             AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }

        else if(sbu.size()>0 && !sbu.contains('All') && bu.size()>0 && !bu.contains('All') && ((oppOwner.contains('All')  || oppOwner.size()<=0))){
            system.debug('2');     
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
        
        else if(oppOwner.size()>0 && !oppOwner.contains('All') && bu.size()>0 && !bu.contains('All') && (sbu.contains('All') || sbu.size()<=0)){
            system.debug('3');        
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__c,
                                     (Select id from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' 
                                      AND Opportuntiy_Stage__c != 'Hold' AND
                                	  RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu ) 
                                      from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                      AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
            
            else if(sbu.size()>0 && !sbu.contains('All') && (bu.contains('All') || bu.size()<=0) && (oppOwner.contains('All') || oppOwner.size()<=0)){
                system.debug('4');
                
                 for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
            }
        
        else if(bu.size()>0 && !bu.contains('All') && sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') ){
            system.debug('5'+sbu);
            
             for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu)                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                     AND QuotaMasterNew__r.Quota_Owner_Name__c In :oppOwner]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') && (bu.contains('All')|| bu.size()<=0) ){
            system.debug('6'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                    AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
        
        else if(bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0) && (sbu.contains('All') || sbu.size()<=0) ){
            system.debug('7'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
          						GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
        
        else{
            system.debug('8');
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 
                                     AND Quota_Date__c<= :d2]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.SBU__c);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.SBU__c,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c sbu
                                from actual_Detail__c where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.SBU__c];
        }
            
        system.debug('QuotaDetailIDs>>>>>>>>'+QuotaDetailIDs);
        system.debug('AggregateQuotaResults>>>>>>'+AggregateQuotaResults);
        system.debug('AggregateResults>>>>'+AggregateResults);
        system.debug('sbuselectedoptions>>'+sbu);
        List<Data> data = new List<Data>();
         
        system.debug('AggregateQuotaMap>>>>>'+AggregateQuotaMap);    
            
        if(AggregateResults.size()>0){
        for(AggregateResult ad : AggregateResults){
            decimal d;
            decimal l1;
            decimal l2;
            decimal l3;
            String sbu;
            
            if(AggregateQuotaMap.get((string)ad.get('sbu'))==Null){
                d = 0.0;
                AggregateQuotaMap.remove((string)ad.get('sbu'));
            }
            else{
                d = AggregateQuotaMap.get((string)ad.get('sbu'));
                AggregateQuotaMap.remove((string)ad.get('sbu'));
            } 
            
            if((decimal)ad.get('L1')==Null){
                l1 = 0.0;
            }
            else{
                l1 = (decimal)ad.get('L1');
            }
            
            if((decimal)ad.get('L2')==Null){
                l2 = 0.0;
            }
            else{
                l2 = (decimal)ad.get('L2');
            }
            
            if((decimal)ad.get('L3')==Null){
                l3 = 0.0;
            }
            else{
                l3 = (decimal)ad.get('L3');
            }
            
            data.add(new Data(l1,l2,l3,d, (decimal)ad.get('revenue'), (String)ad.get('sbu')));
        }
        }
        else{
            system.debug('0.0*********');
            decimal l1 = 0.0;
            decimal l2= 0.0;
            decimal l3= 0.0;
            decimal q = 0.0;
            decimal r = 0.0;
            String str = 'test';
            for(String s : sbu){
            data.add(new Data(l1,l2,l3,q,r,s));
            }
        }
            system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
            if(AggregateQuotaMap.size()>0){
                decimal l1 = 0.0;
                decimal l2= 0.0;
                decimal l3= 0.0;
                decimal r = 0.0;
                for(String s: AggregateQuotaMap.keyset()){
                  data.add(new Data(l1,l2,l3,AggregateQuotaMap.get(s),r,s));   
                }
            }
        system.debug('data>'+data); 
        return data;
        }
        return null;
        
    }
    
    
    
    public class Data {
        
        public String month { get; set; }
        public Decimal L1 { get; set; }
        public Decimal L2 { get; set; }
        public Decimal L3 { get; set; }
        public Decimal quota { get; set; }
        public String revenueInMillion { get; set; }
        public String quotaInMillion { get; set; }
        public Decimal revenue { get; set; }
        public String sbu { get; set; }
        
        public Data(Decimal L1, Decimal L2, Decimal L3, Decimal quota, Decimal revenue, String sbu) {
            String s ;
            if(revenue > 1000000){
                decimal i = (revenue/1000000).setScale(1);
                s = i + ' M';
            }
            else if(revenue > 1000){
                decimal i = (revenue/1000).setScale(1);
                s = i + ' K';
            }
            else{
                s = string.valueOf(revenue);
            }
            
            String str;
            
            if(sbu.contains('- ')){
                str = sbu.substringAfter('- ');
                this.sbu = str;
            }
            
            else if(sbu.contains('-')){
                str = sbu.substringAfter('-');
                this.sbu = str;
            }
            
            else{
                this.sbu = sbu;
            }
            this.L1 = L1;
            this.L2 = L2;
            this.L3 = L3;
            this.quota = quota;
            this.revenueInMillion = s;
            this.revenue = revenue;
            
        }
        
    }
    
        public List<Data1> getData1() {
        
            if(xAxisVal=='mon'){
        system.debug('xAxisVal>>>>>>'+xAxisVal);
        system.debug('fromMonth>>>>>>>>'+fromMonth);
        
        monChart = true;
        
        system.debug('monChart>>>>>>>>>>'+monChart);
        
        if(fromMonth=='Q1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 7, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 7, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q3'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(currentYear, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(FY, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q4'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(FY, 1, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(currentYear, 1, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            
        }
        if(fromMonth=='Current FY'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        
        
        system.debug('fromMonth>>>>>'+fromMonth+'>>>>>toMonth>>>>>'+tomonth);
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May',
            6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sep',10=>'Oct',
            11=>'Nov', 12=>'Dec'};
                
                
                Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        
        Set<Id> QuotaDetailIDs = new Set<Id>();
		List<AggregateResult> AggregateQuotaResults = new List<AggregateResult>();  
        Map<String, Decimal> AggregateQuotaMap = new Map<String,Decimal>();
        List<AggregateResult> AggregateResults = new List<AggregateResult>();

            if(oppOwner.size()>0 && !oppOwner.contains('All') && (sbu.contains('All') || sbu.size()<=0) && (bu.contains('All')|| bu.size()<=0)){
                system.debug('1');
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,QuotaMasterNew__r.Quota_Owner_Name__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                        QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                    sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                    where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
            
            else if(sbu.size()>0 && !sbu.contains('All') && bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All')|| oppOwner.size()<=0)){
                system.debug('2');  
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                    sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                    where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                    RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
            
            else if(oppOwner.size()>0 && !oppOwner.contains('All') && bu.size()>0 && !bu.contains('All') && (sbu.contains('All')|| sbu.size()<=0)){
                system.debug('3');  
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                        AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner ]){
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                    sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                    where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                    RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
            
            else if(sbu.size()>0 && !sbu.contains('All') && (bu.contains('All')|| bu.size()<=0) && (oppOwner.contains('All')|| oppOwner.size()<=0)){
                system.debug('4');
                system.debug('sbu>>>>>>>>>'+sbu);
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                        QuotaMasterNew__r.SBU__c IN :sbu]){ 
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                system.debug('AggregateQuotaMap>>>>>>>>>>>>'+AggregateQuotaMap);
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                    sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                    where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
            
            else if(bu.size()>0 && !bu.contains('All') && sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') ){
                system.debug('5'+sbu);
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                    QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                                                                 
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                    sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                    where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                    QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                    QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
            
            else if(sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') && (bu.contains('All') || bu.size()<=0) ){
            system.debug('6'+sbu);
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                	QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
        }
            
            else if(bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0) && (sbu.contains('All') || sbu.size()<=0) ){
            system.debug('7'+sbu);
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){ 
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                Calendar_Month(QuotaDetail__r.Quota_Date__c) mon from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
          						GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
        }
            
            else{
                system.debug('8');
                
                for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,Quota_Date__c,(Select id from 
                                     QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         
                                         if(AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()))==Null){
                                         AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(monthNameMap.get(qd.Quota_Date__c.month()));
                                             AggregateQuotaMap.put(monthNameMap.get(qd.Quota_Date__c.month()),hiddenQuota);
                                         }
                                     }
                
                AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                    sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                    sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                    Calendar_Month(QuotaDetail__r.Quota_Date__c) mon
                                    from actual_Detail__c where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                    QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                    GROUP BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c) 
                                    ORDER BY CALENDAR_YEAR(QuotaDetail__r.Quota_Date__c),CALENDAR_MONTH(QuotaDetail__r.Quota_Date__c)];
            }
        system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
        system.debug('AggregateResults>>>>'+AggregateResults);
        List<Data1> data = new List<Data1>();
        if(AggregateResults.size()>0){
        for(AggregateResult ad : AggregateResults){ 
            decimal d;
            decimal l1;
            decimal l2;
            decimal l3;
            
            if(AggregateQuotaMap.get(monthNameMap.get((integer)ad.get('mon')))==Null){
                d = 0.0;
                AggregateQuotaMap.remove(monthNameMap.get((integer)ad.get('mon')));
            }
            else{
                d = AggregateQuotaMap.get(monthNameMap.get((integer)ad.get('mon')));
                AggregateQuotaMap.remove(monthNameMap.get((integer)ad.get('mon')));
            } 
            
            if((decimal)ad.get('L1')==Null){
                l1 = 0.0;
            }
            else{
                l1 = (decimal)ad.get('L1');
            }
            
            if((decimal)ad.get('L2')==Null){
                l2 = 0.0;
            }
            else{
                l2 = (decimal)ad.get('L2');
            }
            
            if((decimal)ad.get('L3')==Null){
                l3 = 0.0;
            }
            else{
                l3 = (decimal)ad.get('L3');
            }
            data.add(new Data1(monthNameMap.get((Integer)ad.get('mon')),l1,l2,l3,d, (decimal)ad.get('revenue')));
        }
        }
                
                
                system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
                if(AggregateQuotaMap.size()>0){
                    decimal l1 = 0.0;
                    decimal l2= 0.0;
                    decimal l3= 0.0;
                    decimal r = 0.0;
                    for(String s: AggregateQuotaMap.keyset()){
                        data.add(new Data1(s,l1,l2,l3,AggregateQuotaMap.get(s),r));
                    }
                }        
                
        system.debug('data>'+data);        
        return data;
            }
            return null;
    }
    
        public class Data1 {
        
        public String month { get; set; }
        public Decimal L1 { get; set; }
        public Decimal L2 { get; set; }
        public Decimal L3 { get; set; }
        public Decimal quota { get; set; }
        public String revenueInMillion { get; set; }
        public Decimal revenue { get; set; }
        public String sbu { get; set; }
        
        public Data1(String month,Decimal L1, Decimal L2, Decimal L3, Decimal quota, Decimal revenue) {
            String s ;
            if(revenue > 1000000){
                decimal i = (revenue/1000000).setScale(1);
                s = i + ' M';
            }
            else if(revenue > 1000){
                decimal i = (revenue/1000).setScale(1);
                s = i + ' K';
            }
            else{
                s = string.valueOf(revenue);
            }
            //system.debug('s>>>>>>>'+s);
            this.month = month;
            this.L1 = L1;
            this.L2 = L2;
            this.L3 = L3;
            this.quota = quota;
            this.revenueInMillion = s;
            this.revenue = revenue;
            //this.sbu = sbu;
        }
        
    }
    
    public List<Data2> getData2() {
        
        if(xAxisVal=='bu'){
        
        system.debug('xAxisVal>>>>>>'+xAxisVal);
        system.debug('fromMonth>>>>>>>>'+fromMonth);
        
        monChart = true;
        
        system.debug('monChart>>>>>>>>>>'+monChart);
        
        if(fromMonth=='Q1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 7, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 7, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q3'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(currentYear, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(FY, 12, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q4'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(FY, 1, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(currentYear, 1, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            
        }
        if(fromMonth=='Current FY'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        
        
        system.debug('fromMonth>>>>>'+fromMonth+'>>>>>toMonth>>>>>'+tomonth);
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May',
            6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sep',10=>'Oct',
            11=>'Nov', 12=>'Dec'};
        
        Map<Id,Set<String>> QuotaDetailMap = new Map<Id,Set<String>>();
        Set<String> QuotaDetailIDs = new Set<String>();
		Set<String> buNames = new Set<String>();
		List<AggregateResult> AggregateQuotaResults = new List<AggregateResult>();  
        Map<String, Decimal> AggregateQuotaMap = new Map<String,Decimal>();        
        List<AggregateResult> AggregateResults = new List<AggregateResult>();
        
        if(oppOwner.size()>0 && !oppOwner.contains('All') && (sbu.contains('All') || sbu.size()<=0) && (bu.contains('All') || bu.size()<=0)){
            system.debug('1');
            
             for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,RevenueTermRef__r.Opportunity_line_item_id__c 
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 
                                     AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                             QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
												 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                     }
            
            system.debug('QuotaDetailMap>>>>'+QuotaDetailMap);
            system.debug('QuotaDetailMap.size()>>>>'+QuotaDetailMap.size());
            system.debug('QuotaDetailIDs>>>>'+QuotaDetailIDs);
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,
                                    RevenueTermRef__r.Opportunity_line_item_id__c                                                         
									from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                    from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                    AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                             if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                             if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                             }
                                             else{
                                                 Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                             }
                                                 (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                             }
                                             }
                                             
                                         }
                                     }
                                    }
            system.debug('QuotaDetailIDs.size()>>>>>'+QuotaDetailIDs.size());
            system.debug('AggregateQuotaMap>>>>>>>>'+AggregateQuotaMap);
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0)){
            system.debug('2');   
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                             QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
												 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                             if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                             if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                             }
                                             else{
                                                 Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                             }
                                                 (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                             }
                                             }
                                             
                                         }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(oppOwner.size()>0 && !oppOwner.contains('All') && bu.size()>0 && !bu.contains('All') && (sbu.contains('All') || sbu.size()<=0)){
            system.debug('3');    
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold'AND 
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                     QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner ]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                             QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
												 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND 
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                     QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner ]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){ 
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                             if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                             if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                             }
                                             else{
                                                 Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                             }
                                                 (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                             }
                                             }
                                             
                                         }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && (bu.contains('All') || bu.size()<=0) && (oppOwner.contains('All') || oppOwner.size()<=0)){
            system.debug('4');
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                      QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                             QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
												 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                      QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                                     if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                                         if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                                         }
                                                         else{
                                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                                         }
                                                         (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(bu.size()>0 && !bu.contains('All') && sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') ){
            system.debug('5'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                	 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
                                                 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu ) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                	 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                                     if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                                         if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                                         }
                                                         else{
                                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                                         }
                                                         (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') && (bu.contains('All') || bu.size()<=0) ){
            system.debug('6'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                     QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
                                                 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                     QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){ 
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                                     if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                                         if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                                         }
                                                         else{
                                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                                         }
                                                         (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else if(bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0) && (sbu.contains('All') || sbu.size()<=0) ){
            system.debug('7'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
                                                 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                     RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                                     if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                                         if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                                         }
                                                         else{
                                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                                         }
                                                         (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
          						GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        else{
            system.debug('8');
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                             for(Actual_Detail__c ad : qd.Actual_Details__r){
                                             if(QuotaDetailMap.get(ad.QuotaDetail__r.id)==Null){
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id,new Set<String>{ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c});
                                             }
                                             else{
                                                 Set<String> buList = new Set<String>();
                                                 bulist.add(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                 bulist.addall(QuotaDetailMap.get(ad.QuotaDetail__r.id));
                                                 QuotaDetailMap.put(ad.QuotaDetail__r.id, bulist);
                                             }
                                         }
                                         }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,(Select QuotaDetail__r.id,id,RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         for(Actual_Detail__c ad : qd.Actual_Details__r){  
                                             for(Id id : QuotaDetailMap.keyset()){
                                                 if(id==ad.QuotaDetail__r.id){
                                                     if((QuotaDetailMap.get(id)).contains(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)){
                                                         if(AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c)==Null){
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,qd.Hidden_Quota_2__c);
                                                         }
                                                         else{
                                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                             AggregateQuotaMap.put(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c,hiddenQuota);
                                                         }
                                                         (QuotaDetailMap.get(id)).remove(ad.RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c);
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c bu
                                from actual_Detail__c where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c];
        }
        
        system.debug('AggregateResults>>>>'+AggregateResults);
            system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
        List<Data2> data = new List<Data2>();
            if(AggregateResults.size()>0){
                for(AggregateResult ad : AggregateResults){
                    if( (string)ad.get('bu')  != Null ){
                    decimal d;
                    decimal l1;
                    decimal l2;
                    decimal l3;                    
                    if(AggregateQuotaMap.get((string)ad.get('bu'))==Null){
                        d = 0.0;
                        AggregateQuotaMap.remove((string)ad.get('bu'));
                    }
                    else{
                        d = AggregateQuotaMap.get((string)ad.get('bu'));
                        AggregateQuotaMap.remove((string)ad.get('bu'));
                    }
                    
                    if((decimal)ad.get('L1')==Null){
                        l1 = 0.0;
                    }
                    else{
                        l1 = (decimal)ad.get('L1');
                    }
                    
                    if((decimal)ad.get('L2')==Null){
                        l2 = 0.0;
                    }
                    else{
                        l2 = (decimal)ad.get('L2');
                    }
                    
                    if((decimal)ad.get('L3')==Null){
                        l3 = 0.0;
                    }
                    else{
                        l3 = (decimal)ad.get('L3');
                    }
                    system.debug('bu>>>>>'+(String)ad.get('bu'));
                    data.add(new Data2((String)ad.get('bu'),l1,l2,l3,d, (decimal)ad.get('revenue')));
                }
                }
            }
       
		else{
            decimal l1 = 0.0;
            decimal l2= 0.0;
            decimal l3= 0.0;
            decimal q = 0.0;
            decimal r = 0.0;
            for(String s : bu){
                system.debug('s>>>>'+s);
            data.add(new Data2(s,l1,l2,l3,q,r));
            }        
    }
            
            system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
            if(AggregateQuotaMap.size()>0){
                decimal l1 = 0.0;
                decimal l2= 0.0;
                decimal l3= 0.0;
                decimal r = 0.0;
                for(String s: AggregateQuotaMap.keyset()){
                    system.debug('s>>>'+s);
                    data.add(new Data2(s,l1,l2,l3,AggregateQuotaMap.get(s),r));  
                }
            }
         
        system.debug('data>'+data);        
        return data;
    }
    return null;
    }
    
        public class Data2 {
        
        public String bu { get; set; }
        public Decimal L1 { get; set; }
        public Decimal L2 { get; set; }
        public Decimal L3 { get; set; }
        public Decimal quota { get; set; }
        public String revenueInMillion { get; set; }
        public Decimal revenue { get; set; }
        public String sbu { get; set; }
        
        public Data2(String bu,Decimal L1, Decimal L2, Decimal L3, Decimal quota, Decimal revenue) {
            String s ;
            if(revenue > 1000000){
                decimal i = (revenue/1000000).setScale(1);
                s = i + ' M';
            }
            else if(revenue > 1000){
                decimal i = (revenue/1000).setScale(1);
                s = i + ' K';
            }
            else{
                s = string.valueOf(revenue);
            }
            //system.debug('s>>>>>>>'+s);
            this.bu = bu;
            this.L1 = L1;
            this.L2 = L2;
            this.L3 = L3;
            this.quota = quota;
            this.revenueInMillion = s;
            this.revenue = revenue;
            //this.sbu = sbu;
        }
        
    }
    
    public List<Data3> getData3() {
        
        if(xAxisVal=='oppOwner'){
        
        system.debug('xAxisVal>>>>>>'+xAxisVal);
        system.debug('fromMonth>>>>>>>>'+fromMonth);
        
        monChart = true;
        
        system.debug('monChart>>>>>>>>>>'+monChart);
        
        if(fromMonth=='Q1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 6, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 7, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 7, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q3'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(currentYear, 12, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(FY, 12, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='Q4'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(FY, 1, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(currentYear, 1, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H1'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(currentYear, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(FY, 9, 30);
                d1 = startDate;
                d2 = endDate;
            }
        }
        if(fromMonth=='H2'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 10, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 10, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            
        }
        if(fromMonth=='Current FY'){
            if(currentYear<FY){
                Date startDate = Date.newinstance(currentYear, 4, 1);
                Date endDate = Date.newinstance(FY, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
            else{
                Date startDate = Date.newinstance(FY, 4, 1);
                Date endDate = Date.newinstance(currentYear, 3, 31);
                d1 = startDate;
                d2 = endDate;
            }
        }
        
        
        system.debug('fromMonth>>>>>'+fromMonth+'>>>>>toMonth>>>>>'+tomonth);
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May',
            6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sep',10=>'Oct',
            11=>'Nov', 12=>'Dec'};
                
        Set<Id> QuotaDetailIDs = new Set<Id>();
		List<AggregateResult> AggregateQuotaResults = new List<AggregateResult>();  
        Map<String, Decimal> AggregateQuotaMap = new Map<String,Decimal>();
        List<AggregateResult> AggregateResults = new List<AggregateResult>();
        
        if(oppOwner.size()>0 && !oppOwner.contains('All') && (sbu.contains('All') || sbu.size()<=0) && (bu.contains('All') || bu.size()<=0)){
            system.debug('1');
            System.debug('oppOwner>>>>>>>..'+oppOwner);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__c,
                                     (Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                    AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                       QuotaDetailIDs.add(qd.Id);  
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,
                                     (Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2
                                    AND QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                                                                 
                                        if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                        
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0)){
            system.debug('2');     
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                  
                                        if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(oppOwner.size()>0 && !oppOwner.contains('All') && bu.size()>0 && !bu.contains('All') && (sbu.contains('All') || sbu.size()<=0)){
            system.debug('3');     
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND 
                                	 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
									 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner ]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                	 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
									 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner ]){
                                                                              
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, sum(RevenueTermRef__r.Forecast_W_L2__c)L2, 
                                sum(RevenueTermRef__r.Forecast_W_L3__c)L3, 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND 
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && (bu.contains('All') || bu.size()<=0) && (oppOwner.contains('All') || oppOwner.size()<=0)){
            system.debug('4');
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(bu.size()>0 && !bu.contains('All') && sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') ){
            system.debug('5'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                	 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND 
                                	 QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(sbu.size()>0 && !sbu.contains('All') && oppOwner.size()>0 && !oppOwner.contains('All') && (bu.contains('All') || bu.size()<=0) ){
            system.debug('6'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                    QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                        QuotaDetailIDs.add(qd.id); 
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2 AND
                                    QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner]){
                                         
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner 
                                from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.QuotaMasterNew__r.SBU__c IN :sbu AND 
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__c IN :oppOwner AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else if(bu.size()>0 && !bu.contains('All') && (oppOwner.contains('All') || oppOwner.size()<=0) && (sbu.contains('All') || sbu.size()<=0) ){
            system.debug('7'+sbu);
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
									 RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu) 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1, 
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner 
                                from actual_Detail__c 
                                where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                RevenueTermRef__r.Opportunity_line_item_id__r.Pillar__c IN :bu AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
          						GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        
        else{
            system.debug('8');
            
             for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                         QuotaDetailIDs.add(qd.id);
                                     }
            
            for(QuotaDetail__c qd : [select id,Hidden_Quota_2__c, QuotaMasterNew__r.SBU__c ,QuotaMasterNew__r.Quota_Owner_Name__r.name,(Select QuotaDetail__r.id,id
                                     from QuotaDetail__c.Actual_Details__r where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold') 
                                     from QuotaDetail__c where Hidden_Quota_2__c>0 AND Quota_Date__c>= :d1 AND Quota_Date__c<= :d2]){
                                                                                  
                                         if(AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name)==Null){
                                         AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,qd.Hidden_Quota_2__c);
                                         }
                                         else{
                                             Decimal hiddenQuota = qd.Hidden_Quota_2__c + AggregateQuotaMap.get(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name);
                                             AggregateQuotaMap.put(qd.QuotaMasterNew__r.Quota_Owner_Name__r.name,hiddenQuota);
                                         }
                                         
                                     }
            
            AggregateResults = [select sum(Forecast_Wt_Avg_L0L0_X__c) revenue, sum(QuotaDetail__r.Hidden_Quota_2__c) quota, 
                                sum(RevenueTermRef__r.L1_Revenue__c)L1,
                                sum(RevenueTermRef__r.Forecast_W_L2__c)L2, sum(RevenueTermRef__r.Forecast_W_L3__c)L3,
                                QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name owner
                                from actual_Detail__c where Opportuntiy_Stage__c != 'Closed Lost' AND Opportuntiy_Stage__c != 'Hold' AND
                                QuotaDetail__r.Quota_Date__c >= :d1 AND QuotaDetail__r.Quota_Date__c<= :d2
                                GROUP BY QuotaDetail__r.QuotaMasterNew__r.Quota_Owner_Name__r.name];
        }
        system.debug('QuotaDetailIDs>>>'+QuotaDetailIDs);
        system.debug('AggregateQuotaMap>>>>>'+AggregateQuotaMap);
        system.debug('AggregateResults>>>>'+AggregateResults);
        List<Data3> data = new List<Data3>();
            decimal l1;
            decimal l2;
            decimal l3;
            decimal q;
            decimal r;
        if(AggregateResults.size()>0){
            for(AggregateResult ad : AggregateResults){
                if((String)ad.get('owner')!=Null){
                    /*if((decimal)ad.get('quota')==Null){
                        q = 0.0;
                    }
                    else{
                        q = (decimal)ad.get('quota');
                    }*/
                    if(AggregateQuotaMap.get((string)ad.get('owner'))==Null || AggregateQuotaMap.size()<=0){
                        q = 0.0;
                        AggregateQuotaMap.remove((string)ad.get('owner'));
                    }
                    else{
                        q = AggregateQuotaMap.get((string)ad.get('owner'));
                        AggregateQuotaMap.remove((string)ad.get('owner'));
                    }
                    //data.add(new Data3((String)ad.get('owner'),(decimal)ad.get('L1'),(decimal)ad.get('L2'), (decimal)ad.get('L3'),d, (decimal)ad.get('revenue')));
                }
                if((Decimal)ad.get('L1')!=Null){
                    l1 = (Decimal)ad.get('L1');
                }
                else{
                    l1 = 0.0;
                }
                if((Decimal)ad.get('L2')!=Null){
                    l2 = (Decimal)ad.get('L2');
                }
                else{
                    l2 = 0.0;
                }
                if((Decimal)ad.get('L3')!=Null){
                    l3 = (Decimal)ad.get('L3');
                }
                else{
                    l3 = 0.0;
                }
                if((Decimal)ad.get('revenue')!=Null){
                    r = (Decimal)ad.get('revenue');
                }
                else{
                    r = 0.0;
                }
                data.add(new Data3((String)ad.get('owner'),l1,l2,l3,q,r));
            }
        }
        else{
             l1 = 0.0;
             l2= 0.0;
             l3= 0.0;
             q = 0.0;
             r = 0.0;
            for(String s : oppOwner){
                data.add(new Data3(s,l1,l2,l3,q,r));
            }
        }
            
            system.debug('AggregateQuotaMap>>>>'+AggregateQuotaMap);
            if(AggregateQuotaMap.size()>0){
                 l1 = 0.0;
                 l2= 0.0;
                 l3= 0.0;
                 r = 0.0;
                for(String s: AggregateQuotaMap.keyset()){
                  data.add(new Data3(s,l1,l2,l3,AggregateQuotaMap.get(s),r));  
                }
            }
        
        system.debug('data>'+data);        
        return data;
        }
        return null;
        
    }
    
        public class Data3 {
        
        public String oppOwner { get; set; }
        public Decimal L1 { get; set; }
        public Decimal L2 { get; set; }
        public Decimal L3 { get; set; }
        public Decimal quota { get; set; }
        public String revenueInMillion { get; set; }
        public Decimal revenue { get; set; }
        public String sbu { get; set; }
        
        public Data3(String oppOwner,Decimal L1, Decimal L2, Decimal L3, Decimal quota, Decimal revenue) {
            String s ;
            if(revenue > 1000000){
                decimal i = (revenue/1000000).setScale(1);
                s = i + ' M';
            }
            else if(revenue > 1000){
                decimal i = (revenue/1000).setScale(1);
                s = i + ' K';
            }
            else{
                s = string.valueOf(revenue);
            }
            //system.debug('s>>>>>>>'+s);
            this.oppOwner =oppOwner;
            this.L1 = L1;
            this.L2 = L2;
            this.L3 = L3;
            this.quota = quota;
            this.revenueInMillion = s;
            this.revenue = revenue;
            //this.sbu = sbu;
        }
        
    }
    
}