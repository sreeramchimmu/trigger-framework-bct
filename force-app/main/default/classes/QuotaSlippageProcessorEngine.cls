public class QuotaSlippageProcessorEngine {
    
    public Map<id, List<QuotaDetail__c>> ownerToQuotaDetailsMap;
    public list<QuotaDetail__c> qDetToUpdate = new List<QuotaDetail__c>();
   
    
    public List<QuotaDetail__c> qdets;
    public List<ID> existingOwnerIdsList = new List<ID>();
    
    Date currrDate = Date.today();
    Integer currMonth = currrDate.month();
  //  Integer currMonth = 7;
    Integer currYear =  currrDate.year();
    String fyPeriod;
    String startFY;
    String endFY;
    Integer prevMonth;
    List<Integer> incentiveMonths;
    List<Integer> slippageQuarters;
    List<Integer> quotaSlipageMonths;
    Integer incentiveYear;
    Integer currQtr ;
    
    public static String  BCTSERVICESEXECUTIVE = 'BCTServicesExecutive';
    public static String  PROFSERVICESEXECUTIVE = 'ProfServicesExecutive';
    public static String  L0L0XEXECUTIVE = 'L0L0XExecutive';
    public static String  NEWLOGOEXECUTIVE = 'NewLogoExecutive';
    public static String  SIPRODUCTSEXECUTIVE = 'SIProductsExecutive';
    public static String  BCTIPEXECUTIVE = 'BCTIPExecutive';
    
    
    public List<Incentive_Scheme__c> incScheme;
    //Map<BCTServicesExecutive, Map<R31TO50, 0.15 Value>>
    public Map<String , Map<String, Decimal>> incentiveSchemeMap;
    
   
    public QuotaSlippageProcessorEngine(){
        system.debug('Running Quota Slippage Processor');
       
         Integer currQtr = getQuarterNumber(currMonth);
         
        if(currQtr == 1) {
                incentiveYear =  currYear - 1;
            }else if(currQtr == 2){
                 incentiveYear =  currYear - 1;
            }else if(currQtr == 3){
                 incentiveYear =  currYear;
            }else if(currQtr == 4){
                 incentiveYear =  currYear;
        }
        
        slippageQuarters = new List<Integer>();
        if(currQtr == 1){
            slippageQuarters.add(1);
            slippageQuarters.add(2);
            slippageQuarters.add(3);
            slippageQuarters.add(4);
        }else if(currQtr == 2){
            slippageQuarters.add(1);
            slippageQuarters.add(2);
            slippageQuarters.add(3);
            slippageQuarters.add(4);
        }else if(currQtr == 3){
            slippageQuarters.add(2);
            slippageQuarters.add(3);
            slippageQuarters.add(4);
        }else if(currQtr == 4){
            slippageQuarters.add(3);
            slippageQuarters.add(4);
        }
        
         system.debug('Curr Quarter    : ' + currQtr);
         system.debug('slippageQuarter Quarter    : ' + slippageQuarters);
         system.debug('Incentive Year  : ' + incentiveYear);
 
        if(currMonth > 3 ){
            startFY = String.valueOf(currYear);
            endFY = String.valueOf(currYear + 1);
           
        }else{
            startFY = String.valueOf(currYear -1);
            endFY = String.valueOf(currYear);
         
        }
        
        fyPeriod = startFY +'-'+ endFY;
        system.debug('fyPeriod   : ' + fyPeriod);
        
        if(currMonth - 1 <= 3 ){
            if(currMonth == 1 ){
            prevMonth = 12;
            }else if(currMonth == 2 || currMonth == 3){
                prevMonth = currMonth -1 ;
            }else{
            prevMonth = 0;
            }
            
        }else{
            prevMonth = currMonth - 1;
        }
       
        
        quotaSlipageMonths = new List<Integer>();
        quotaSlipageMonths.add(currMonth);
        quotaSlipageMonths.add(prevMonth);
        // system.debug('quotaSlipageMonths : ' + quotaSlipageMonths);
        
       /* List<Integer> futureMonths = new List<Integer>();
        if(currMonth > 4 && currMonth <= 12 ){
              system.debug('Inside IF loop : ' + currMonth);
            for(integer i=currMonth + 1 ; i <= 12 ; i++){
                futureMonths.add(i);
                 system.debug('Future Months : ' + futureMonths);
            }
            futureMonths.add(1);
            futureMonths.add(2);
            futureMonths.add(3);
            
        }
        if(currMonth < 3){
              for(integer i=currMonth + 1; i<= 3 ; i++){
                futureMonths.add(i);
                // system.debug('Future Months next year : ' + futureMonths);
            }
        }
        
        incentiveMonths = new List<Integer>();
        
        
        for(Integer eachFutMon : futureMonths){
               incentiveMonths.add(eachFutMon);
        }
        incentiveMonths.add(currMonth);
        incentiveMonths.add(prevMonth);
        system.debug('Final Future Months : ' + futureMonths);
        system.debug('Final Incentive Months : ' + incentiveMonths);*/
      
       /* incScheme = [SELECT ID, IC_BUSINESS_CATEGORY__C, IC_REVENUE_STREAM__C, INCENTIVE_SCHEME_TYPE__C, R31TO50__C, R51TO75__C, R76TO90__C, R91TO100__C, R101TO110__C, R110PLUS__C, INCENTIVE_TERM__C, INCENTIVE_PERIOD__C FROM INCENTIVE_SCHEME__C WHERE INCENTIVE_PERIOD__C=:fyPeriod ];
        
        system.debug('Incetive Scheme Data : ' + incScheme);
        
        //Map<String, Decimal> inceRangeInnerMap =  new Map<String, Decimal>();
        incentiveSchemeMap = new Map<String, Map<String, Decimal>>();
        //Populating incentive scheme map
        for(Incentive_Scheme__c eachScheme : incScheme){
                   Map<String, Decimal> inceRangeInnerMap =  new Map<String, Decimal>();
            
            if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT approved Digital & TIBCO Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                  //  system.debug('Incetive Scheme BCT Services : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('BCTApprovedDigitalTIBCOServices', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('Professional Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                 // system.debug('Incetive Scheme : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('ProfServicesExecutive', processIncentiveSchemeInnerMap(eachScheme));
                                                                       
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT Enterprise Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                 // system.debug('Incetive Scheme : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('BCTCFEnterpriseServies', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('TIBCO Product License') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                //  system.debug('Incetive Scheme : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('TIBCOProductLicenseExecutive', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('SI Products') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                 // system.debug('Incetive Scheme BCT Services : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('SIProductsExecutive', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT IP') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                                //  system.debug('Incetive Scheme BCT Services : ' + eachScheme.IC_REVENUE_STREAM__C);
                                incentiveSchemeMap.put('BCTIPExecutive', processIncentiveSchemeInnerMap(eachScheme));
                }
          }
        system.debug('Incentive Scheme Map : ' + incentiveSchemeMap);*/
        
        
    }
    
     /* public Map<String, decimal> processIncentiveSchemeInnerMap(Incentive_Scheme__c eachIncetiviScheme){
                        Map<String, decimal> inceRangeIMap = new Map<String, decimal>();
        
                        inceRangeIMap.put('R31TO50', eachIncetiviScheme.R31TO50__c);
                        inceRangeIMap.put('R51TO75', eachIncetiviScheme.R51TO75__c);
                        inceRangeIMap.put('R76TO90', eachIncetiviScheme.R76TO90__c);
                        inceRangeIMap.put('R91TO100', eachIncetiviScheme.R91TO100__c);
                        inceRangeIMap.put('R101TO110', eachIncetiviScheme.R101TO110__c);
                        inceRangeIMap.put('R110PLUS', eachIncetiviScheme.R110PLUS__C);
        
        return inceRangeIMap;
    }*/
    
    
    public void processQuotaSlippage(){
       
        List<Incentive_Master__c> incmstr;
        List<QuotamasterNew__c> qmst;
        List<id> qmstIdList = new List<id>();
        
        String tempQPeriod = startFY +'-'+ endFY;
        
        system.debug('Quota Period in Process Incentive method : ' + tempQPeriod);
        system.debug('Slippage Quota quarters method : ' + slippageQuarters);
        
        qdets = [SELECT Id,Quota_Quarter__c, Quota_Amount__c, new_quota__c, Revised_L0L0XL1_Quota__c,Revised_L0L0XL1L2L3_Quota__c, Total_L0L0_X_AC_FCRev__c, Total_L0_L0_X_L1_AC_FC_Rev__c, QuotaMasterNew__c, IP_Actual_Revenue_Summary__c, Total_Rev_FC__c, BCT_Services_L0_L0X_Mon_Rev__c,BCT_Services_L1_Mon_Rev__c, BCT_Services_L2_L3_Mon_Rev__c, Existing_Contracts_L0L0_X_Mon_Rev__c,  Existing_Contracts_L1_Mon_Rev__c, Existing_Contracts_L2L3_Mon_Rev__c, New_Logo_L1_Mon_Rev__c, New_Logo_L0L0X_Mon_Rev__c, New_Logo_L2L3_Mon_Rev__c, QuotaMasterNew__r.Sales_Owner_Role__c, QuotaMasterNew__r.Quota_Owner_Name__c, QuotaMasterNew__r.SBU__c, QuotaMasterNew__r.Quota_Owner_Manager__c, Quota_Owner_Formula__c, QuotaMasterNew__r.Quota_Start_Period__c,QuotaMasterNew__r.Quota_Period__c, QuotaMasterNew__r.ownerId, Quota_Date__C, Quota_Variance__c, Revenue_Recognized_Amount__c, COE_Target__c, Huringa_Quota_by_product__c, product_Type_QDET__c, quota_month__c, quotayear__c, BCT_IP_L1_Monthly_WAvg_Rev__c, BCTIP_L0_L0_X_Monthly_Actual_Rev__c, BCT_IP_L2_L3_Monthly_Rev__c, PSvc_L0L0X_Mon_Rev__c, PSvc_L1_Mon_Rev__c, PSvc_L2L3_Mon_Rev__c, SI_Products_L0_L0_X_Mon_Rev__c, SI_Products_L1_Mon_Rev__c, SI_Products_L2L3_Mon_Rev__c FROM QuotaDetail__c where QuotaMasterNew__r.Quota_Period__c = :tempQPeriod and QuotaMasterNew__r.Product_Type__c='OVERALL' and Quota_Quarter__c in : slippageQuarters  ORDER BY QuotaMasterNew__r.ownerId, Quota_Quarter__c ASC ];
        system.debug('1 - Engine - Quota Details size' + qdets.size());
        system.debug('1 - Engine - Quota Details ' + qdets);
        
        ownerToQuotaDetailsMap =  new Map<Id, List<QuotaDetail__c>>();
        
         List<QuotaDetail__c> qdetForaOwner;
        
        id prevOwner;
        if(null != qdets && qdets.size() > 0){
            for(QuotaDetail__c eachQdet : qdets){
             // List<QuotaDetail__c> tempQDet = new List<QuotaDetail__c>();
                if(null != prevOwner && prevOwner == eachQdet.QuotaMasterNew__r.ownerId){
                   // system.debug('Same Owner :' + eachQdet.QuotaMasterNew__r.ownerId);
                    qdetForaOwner.add(eachQdet);
                }else{
                   // system.debug('New Owner:' + eachQdet.QuotaMasterNew__r.ownerId);
                    qdetForaOwner = new List<QuotaDetail__c>();
                    qdetForaOwner.add(eachQdet);
                }
                
                ownerToQuotaDetailsMap.put(eachQdet.QuotaMasterNew__r.ownerId, qdetForaOwner);
                prevOwner = eachQdet.QuotaMasterNew__r.ownerId;
                //
            
            }//end Qdet for loop
                system.debug('Printing Owner To Qdetail list Map :' + ownerToQuotaDetailsMap);
        }
        //Populate the existing owner id list
        for(id eachOwnerId : ownerToQuotaDetailsMap.keySet()){
                existingOwnerIdsList.add(eachOwnerId);
        }
        
        
        
         system.debug('Querying incentive master obj for comparison . ');
         incmstr = [SELECT ID, OwnerId, Actual_Quota__c,Actual_Revenue_Recognized__c, Total_L0L0X_Revenue__c, BCT_IP_L0L0X_QtrActualsRev__c, BCTIP_L1_Qtr_Rev__c, BCTIP_L2L3_QtrRev__c, PSvc_L0L0X_Qtr_Rev__c, PSvc_L1_Qtr_Rev__c, PSvc_L2L3_Qtr_Rev__c, SI_Products_L0L0X_Qtr_Rev__c, SI_Products_L1_Qtr_Rev__c, SI_Products_L2L3_Qtr_Rev__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L1__c, Rev_BCT_CF_Ent_Svcs_L2L3__c, Rev_TIBCO_Pdt_License_L0L0X__c, Rev_TIBCO_Pdt_License_L1__c, Rev_TIBCO_Pdt_License_L2L3__c, Total_Rev_L0_L0X__c, Total_L1_Revenue__c, Total_L2L3_Revenue__c, Incentive_BCT_IP__c,Incentive_BCT_IP_L1__c, Incentive_BCT_IP_L2_L3__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c,Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c, Incen_BCT_CF_Ent_Svcs_L0L0X__c, Incen_BCT_CF_Ent_Svcs_L1__c, Incen_BCT_CF_Ent_Svcs_L2L3__c, Incen_TIBCO_Pdt_License_L0L0X__c, Incen_TIBCO_Pdt_License_L1__c, Incen_TIBCO_Pdt_License_L2L3__c, Incentive_ProfSvcs__c, Incentive_ProfSvcs_L1__c, Incentive_ProfSvcs_L2_L3__c, Incentive_SI_Products__c, Incentive_SI_Products_L1__c, Incentive_SI_Products_L2_L3__c, Incentive_Start_Period__c,Incentive_End_Period__c,  Quarterly_IP_Quota__c, Quarterly_Overall_Quota__c, Quota_Period__c, Sales_Owner_Name__c, SalesUserId__c, Sales_User_Manager__c, SBU__c from Incentive_Master__c where Quota_Period__c =:fyPeriod] ;
         system.debug('Incentive Master records available ? :' + incmstr);
        
        if(null != incmstr && incmstr.size() > 0 ){
           // flow for incentive master found
          Map<id, List<Incentive_Master__c>> ownerToIncmasterMap = new Map<id, List<Incentive_Master__c>>();
          List<Incentive_Master__c> incentveMastrLstForaQwner;
          id prevOwner1;
            
            for(Incentive_Master__c eachIncMstr : incmstr){
                if(null != prevOwner1 && prevOwner1 == eachIncMstr.ownerId){
                   // system.debug('Same Owner :' + eachIncMstr.Sales_Owner_Name__c);
                    incentveMastrLstForaQwner.add(eachIncMstr);
                }else{
                   // system.debug('New Owner:' + eachIncMstr.Sales_Owner_Name__c);
                    incentveMastrLstForaQwner = new List<Incentive_Master__c>();
                    incentveMastrLstForaQwner.add(eachIncMstr);
                }
                ownerToIncmasterMap.put(eachIncMstr.ownerId, incentveMastrLstForaQwner);
                prevOwner1 = eachIncMstr.ownerId;
            }// end of for loop     
                system.debug('Incentive Master RowMap per owner to 4 list of qtrs> : ' + ownerToIncmasterMap);
                //d();
            }    

            calculateAndProcessIncentive();
        }
    
     private void calculateAndProcessIncentive(){
   
      Map<String, QuotaDetail__c> newOwnerKeyToQtrlyQdetRowMap = new Map<String, QuotaDetail__c>();
     
      for (id eachOwnerQdetail : ownerToQuotaDetailsMap.keySet()){
        Map<String, QuotaDetail__c> ownerKeyToQtrlyQdetailMap = new Map<String, QuotaDetail__c>();
      String tempOwnerId = String.valueOf(eachOwnerQdetail);
      String modifiedOwnerId = tempOwnerId.substring(0, tempOwnerId.length()-3);
     system.debug('calculating for next owner : ' + modifiedOwnerId);
		
		 QuotaDetail__c qdetailsQtr1 = new QuotaDetail__c();
		 QuotaDetail__c qdetailsQtr2 = new QuotaDetail__c();
		 QuotaDetail__c qdetailsQtr3 = new QuotaDetail__c();
		 QuotaDetail__c qdetailsQtr4 = new QuotaDetail__c();
		  
       for(QuotaDetail__c eachQdet : ownerToQuotaDetailsMap.get(eachOwnerQdetail)){
        
        Integer tempQtr = getQuarterNumber(Integer.valueOf(eachQdet.Quota_Month__c));
        if(tempQtr == 1){
                    qdetailsQtr1 = groupQdetMonthlyToQtrly(eachQdet, qdetailsQtr1);
                    String tempQdtRowkey1 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 1 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQtrlyQdetailMap.put(tempQdtRowkey1, qdetailsQtr1);
                }else if(tempQtr == 2){
                    qdetailsQtr2 = groupQdetMonthlyToQtrly(eachQdet, qdetailsQtr2);
                    String tempQdtRowkey2 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 2 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQtrlyQdetailMap.put(tempQdtRowkey2, qdetailsQtr2);
                }else if(tempQtr == 3){
                    qdetailsQtr3 = groupQdetMonthlyToQtrly(eachQdet, qdetailsQtr3);
                    String tempQdtRowkey3 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 3 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQtrlyQdetailMap.put(tempQdtRowkey3, qdetailsQtr3);
                }else if(tempQtr == 4){
                    qdetailsQtr4 = groupQdetMonthlyToQtrly(eachQdet, qdetailsQtr4);
                    String tempQdtRowkey4 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 4 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQtrlyQdetailMap.put(tempQdtRowkey4, qdetailsQtr4);
                }
            }// End inner for loop
			
			 system.debug('Owner to Quota detail row map : ' + ownerKeyToQtrlyQdetailMap); 
           
            
           for(String eachQtrDetInckey : ownerKeyToQtrlyQdetailMap.keySet()){
            
                    QuotaDetail__c eachQdetForIncCalcPerQtr = ownerKeyToQtrlyQdetailMap.get(eachQtrDetInckey);
                    String eachOwnerId = eachQdetForIncCalcPerQtr.Owner_ID_Temp__c;
					String mfiedOwnerId = eachOwnerId.substring(0, eachOwnerId.length()-3);
                 if(eachQdetForIncCalcPerQtr.Quota_Quarter__c == 1)
                 {
                    system.debug('START --> Q1 - No quota slippage calculation required for Q1 - Owner :' + eachQtrDetInckey);
                    system.debug('Q1 L0L0X Quota : ' + eachQdetForIncCalcPerQtr.New_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Quota : ' + eachQdetForIncCalcPerQtr.Revised_L0L0XL1_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Quota : ' + eachQdetForIncCalcPerQtr.Revised_L0L0XL1L2L3_Quota__c);
                    system.debug('Q1 L0L0X Revenue from Map : ' + eachQdetForIncCalcPerQtr.Overall_L0_L0X_AC_FC_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Revenue : ' + eachQdetForIncCalcPerQtr.Overall_L0_L0X_L1_AC_FC_Rev__c + '  qdetailsQtr1 L0L0XL1L2L3 Revenue : ' + eachQdetForIncCalcPerQtr.Overall_L0_L0X_L1L2L3AC_FC_Rev__c);
                
                    //newOwnerKeyToQtrlyQdetRowMap.put(eachQtrDetInckey, qdetailsQtr1);
             
                 }else if(eachQdetForIncCalcPerQtr.Quota_Quarter__c == 2){
                    system.debug('START --> Q2 ' + eachQtrDetInckey);
					system.debug('Q1 L0L0X Quota from Q1 Object : ' + qdetailsQtr1.New_Quota__c + '  qdetailsQtr1 L0L0XL1 Quota : ' + qdetailsQtr1.Revised_L0L0XL1_Quota__c + '  qdetailsQtr1 L0L0XL1L2L3 Quota : ' + qdetailsQtr1.Revised_L0L0XL1L2L3_Quota__c + ' Q1 Quota_Amount__c : ' + qdetailsQtr1.Quota_Amount__c);
                    system.debug('Q1 L0L0X Revenue from Q1 Object : ' + qdetailsQtr1.Overall_L0_L0X_AC_FC_Rev__c + '  qdetailsQtr1 L0L0XL1 Revenue : ' + qdetailsQtr1.Overall_L0_L0X_L1_AC_FC_Rev__c + '  qdetailsQtr1 L0L0XL1L2L3 Revenue : ' + qdetailsQtr1.Overall_L0_L0X_L1L2L3AC_FC_Rev__c);
                    
                    decimal q1QuotaVarianceL0L0X = qdetailsQtr1.Quota_Amount__c - qdetailsQtr1.Overall_L0_L0X_AC_FC_Rev__c;
                    decimal q1QuotaVarianceL0L0XL1 = qdetailsQtr1.Quota_Amount__c - qdetailsQtr1.Overall_L0_L0X_L1_AC_FC_Rev__c;
                    decimal q1QuotaVarianceL0L0XL1L2L3 = qdetailsQtr1.Quota_Amount__c - qdetailsQtr1.Overall_L0_L0X_L1L2L3AC_FC_Rev__c;
                    system.debug('q1QuotaVarianceL0L0X : ' +  q1QuotaVarianceL0L0X +' q1QuotaVarianceL0L0XL1 : '+ q1QuotaVarianceL0L0XL1 + ' q1QuotaVarianceL0L0XL1L2L3 : ' +  q1QuotaVarianceL0L0XL1L2L3);    
                   system.debug('BEFORE Q2 L0L0X Quota from Q2 Object : ' + qdetailsQtr2.New_Quota__c  + '  qdetailsQtr2 L0L0XL1 Quota : ' + qdetailsQtr2.Revised_L0L0XL1_Quota__c  + '  qdetailsQtr2 L0L0XL1L2L3 Quota : ' + qdetailsQtr2.Revised_L0L0XL1L2L3_Quota__c  + ' Q3 Quota_Amount__c : ' + qdetailsQtr2.Quota_Amount__c);
                     // Handling quota slippage by comparing prev qtr quota with prev qtr revenune
                    qdetailsQtr2.New_Quota__c = q1QuotaVarianceL0L0X > 0 ? ((qdetailsQtr2.Quota_Amount__c/3) + q1QuotaVarianceL0L0X) : qdetailsQtr2.Quota_Amount__c/3;
                    qdetailsQtr2.Revised_L0L0XL1_Quota__c = q1QuotaVarianceL0L0XL1 > 0 ? ((qdetailsQtr2.Quota_Amount__c/3) + q1QuotaVarianceL0L0XL1) : qdetailsQtr2.Quota_Amount__c/3;
                    qdetailsQtr2.Revised_L0L0XL1L2L3_Quota__c = q1QuotaVarianceL0L0XL1L2L3 > 0 ? ((qdetailsQtr2.Quota_Amount__c/3) + q1QuotaVarianceL0L0XL1L2L3) : qdetailsQtr2.Quota_Amount__c/3;
					system.debug('Q2 Quota Amount : ' +  qdetailsQtr2.Quota_Amount__c);
                    qdetailsQtr2.Quota_Amount__c = qdetailsQtr2.Quota_Amount__c / 3 ;   
                        system.debug('Q2 Quota Amount after div: ' +  qdetailsQtr2.Quota_Amount__c);             
                    newOwnerKeyToQtrlyQdetRowMap.put(eachQtrDetInckey, qdetailsQtr2);
					 system.debug('AFTER Q2 L0L0X Quota from Q2 Object : ' + qdetailsQtr2.New_Quota__c  + '  qdetailsQtr2 L0L0XL1 Quota : ' + qdetailsQtr2.Revised_L0L0XL1_Quota__c  + '  qdetailsQtr2 L0L0XL1L2L3 Quota : ' + qdetailsQtr2.Revised_L0L0XL1L2L3_Quota__c  + ' Q3 Quota_Amount__c : ' + qdetailsQtr2.Quota_Amount__c);
                  
                 }else if(eachQdetForIncCalcPerQtr.Quota_Quarter__c == 3){
                    system.debug('START --> Q3 ' + eachQtrDetInckey);
                    system.debug('Q2 L0L0X Quota from Q2 Object (Manipulated): ' + (qdetailsQtr2.New_Quota__c+ (2*qdetailsQtr2.Quota_Amount__c))  + '  qdetailsQtr2 L0L0XL1 Quota : ' + (qdetailsQtr2.Revised_L0L0XL1_Quota__c + (2*qdetailsQtr2.Quota_Amount__c)) + '  qdetailsQtr2 L0L0XL1L2L3 Quota : ' + (qdetailsQtr2.Revised_L0L0XL1L2L3_Quota__c + (2*qdetailsQtr2.Quota_Amount__c)) + ' Q3 Quota_Amount__c : ' + qdetailsQtr2.Quota_Amount__c);
                    system.debug('Q2 L0L0X Revenue from Q2 Object : ' + qdetailsQtr2.Overall_L0_L0X_AC_FC_Rev__c + '  qdetailsQtr2 L0L0XL1 Revenue : ' + qdetailsQtr2.Overall_L0_L0X_L1_AC_FC_Rev__c + '  qdetailsQtr2 L0L0XL1L2L3 Revenue : ' + qdetailsQtr2.Overall_L0_L0X_L1L2L3AC_FC_Rev__c);
                    
                    decimal q2QuotaVarianceL0L0X = (qdetailsQtr2.New_Quota__c+ (2*qdetailsQtr2.Quota_Amount__c)) - qdetailsQtr2.Overall_L0_L0X_AC_FC_Rev__c;
                    decimal q2QuotaVarianceL0L0XL1 = (qdetailsQtr2.Revised_L0L0XL1_Quota__c+ (2*qdetailsQtr2.Quota_Amount__c)) - qdetailsQtr2.Overall_L0_L0X_L1_AC_FC_Rev__c;
                    decimal q2QuotaVarianceL0L0XL1L2L3 = (qdetailsQtr2.Revised_L0L0XL1L2L3_Quota__c+ (2*qdetailsQtr2.Quota_Amount__c)) - qdetailsQtr2.Overall_L0_L0X_L1L2L3AC_FC_Rev__c;
                    //Resetting the temp quarterly revenue variable
                    qdetailsQtr2.Overall_L0_L0X_AC_FC_Rev__c = 0;
                    qdetailsQtr2.Overall_L0_L0X_L1_AC_FC_Rev__c = 0;
                    qdetailsQtr2.Overall_L0_L0X_L1L2L3AC_FC_Rev__c = 0;
                    
                    system.debug('q2QuotaVarianceL0L0X : ' +  q2QuotaVarianceL0L0X +' q2QuotaVarianceL0L0XL1 : '+ q2QuotaVarianceL0L0XL1 + ' q2QuotaVarianceL0L0XL1L2L3 : ' +  q2QuotaVarianceL0L0XL1L2L3);
                     // Handling quota slippage by comparing prev qtr quota with prev qtr revenune
                    qdetailsQtr3.New_Quota__c = q2QuotaVarianceL0L0X > 0 ? ((qdetailsQtr3.Quota_Amount__c/3) + q2QuotaVarianceL0L0X) : qdetailsQtr3.Quota_Amount__c/3;
                    qdetailsQtr3.Revised_L0L0XL1_Quota__c = q2QuotaVarianceL0L0XL1 > 0 ? ((qdetailsQtr3.Quota_Amount__c/3) + q2QuotaVarianceL0L0XL1) : qdetailsQtr3.Quota_Amount__c/3;
                    qdetailsQtr3.Revised_L0L0XL1L2L3_Quota__c = q2QuotaVarianceL0L0XL1L2L3 > 0 ? ((qdetailsQtr3.Quota_Amount__c/3) + q2QuotaVarianceL0L0XL1L2L3) : qdetailsQtr3.Quota_Amount__c/3;
                    qdetailsQtr3.Quota_Amount__c = qdetailsQtr3.Quota_Amount__c / 3 ;
                    
                    newOwnerKeyToQtrlyQdetRowMap.put(eachQtrDetInckey, qdetailsQtr3);
					
                 }else if(eachQdetForIncCalcPerQtr.Quota_Quarter__c == 4){
                    system.debug('START --> Q4 '+ eachQtrDetInckey);
                    system.debug('Q3 L0L0X Quota from Q3 Object : ' + (qdetailsQtr3.New_Quota__c+ (2*qdetailsQtr3.Quota_Amount__c))  + '  qdetailsQtr3 L0L0XL1 Quota : ' + (qdetailsQtr3.Revised_L0L0XL1_Quota__c + (2*qdetailsQtr3.Quota_Amount__c)) + '  qdetailsQtr3 L0L0XL1L2L3 Quota : ' + (qdetailsQtr3.Revised_L0L0XL1L2L3_Quota__c + (2*qdetailsQtr3.Quota_Amount__c)) + ' Q3 Quota_Amount__c : ' + qdetailsQtr3.Quota_Amount__c);
                    system.debug('Q3 L0L0X Revenue from Q3 Object : ' + qdetailsQtr3.Overall_L0_L0X_AC_FC_Rev__c + '  qdetailsQtr3 L0L0XL1 Revenue : ' + qdetailsQtr3.Overall_L0_L0X_L1_AC_FC_Rev__c + '  qdetailsQtr3 L0L0XL1L2L3 Revenue : ' + qdetailsQtr3.Overall_L0_L0X_L1L2L3AC_FC_Rev__c);
                    
                    decimal q3QuotaVarianceL0L0X = (qdetailsQtr3.New_Quota__c + (2*qdetailsQtr3.Quota_Amount__c)) - qdetailsQtr3.Overall_L0_L0X_AC_FC_Rev__c;
                    decimal q3QuotaVarianceL0L0XL1 = (qdetailsQtr3.Revised_L0L0XL1_Quota__c + (2*qdetailsQtr3.Quota_Amount__c)) - qdetailsQtr3.Overall_L0_L0X_L1_AC_FC_Rev__c;
                    decimal q3QuotaVarianceL0L0XL1L2L3 = (qdetailsQtr3.Revised_L0L0XL1L2L3_Quota__c + (2*qdetailsQtr3.Quota_Amount__c)) - qdetailsQtr3.Overall_L0_L0X_L1L2L3AC_FC_Rev__c;
                    //Resetting the temp quarterly revenue variable
                    qdetailsQtr3.Overall_L0_L0X_AC_FC_Rev__c = 0;
                    qdetailsQtr3.Overall_L0_L0X_L1_AC_FC_Rev__c = 0;
                    qdetailsQtr3.Overall_L0_L0X_L1L2L3AC_FC_Rev__c = 0;
                    
                    system.debug('q3QuotaVarianceL0L0X : ' +  q3QuotaVarianceL0L0X +' q3QuotaVarianceL0L0XL1 : '+ q3QuotaVarianceL0L0XL1 + ' q3QuotaVarianceL0L0XL1L2L3 : ' +  q3QuotaVarianceL0L0XL1L2L3);
                     // Handling quota slippage by comparing prev qtr quota with prev qtr revenune
                    qdetailsQtr4.New_Quota__c = q3QuotaVarianceL0L0X > 0 ? ((qdetailsQtr4.Quota_Amount__c/3) + q3QuotaVarianceL0L0X) : qdetailsQtr4.Quota_Amount__c/3;
                    qdetailsQtr4.Revised_L0L0XL1_Quota__c = q3QuotaVarianceL0L0XL1 > 0 ? ((qdetailsQtr4.Quota_Amount__c/3) + q3QuotaVarianceL0L0XL1) : qdetailsQtr4.Quota_Amount__c/3;
                    qdetailsQtr4.Revised_L0L0XL1L2L3_Quota__c = q3QuotaVarianceL0L0XL1L2L3 > 0 ? ((qdetailsQtr4.Quota_Amount__c/3) + q3QuotaVarianceL0L0XL1L2L3) : qdetailsQtr4.Quota_Amount__c/3;
                    qdetailsQtr4.Quota_Amount__c = qdetailsQtr4.Quota_Amount__c / 3 ;
                    //Resetting the temp quarterly revenue variable
                    qdetailsQtr4.Overall_L0_L0X_AC_FC_Rev__c = 0;
                    qdetailsQtr4.Overall_L0_L0X_L1_AC_FC_Rev__c = 0;
                    qdetailsQtr4.Overall_L0_L0X_L1L2L3AC_FC_Rev__c = 0;
                    
                    system.debug('Q4 L0L0X Quota from Q4 Object : ' + qdetailsQtr4.New_Quota__c + '  qdetailsQtr4 L0L0XL1 Quota : ' + qdetailsQtr4.Revised_L0L0XL1_Quota__c + '  qdetailsQtr4 L0L0XL1L2L3 Quota : ' + qdetailsQtr4.Revised_L0L0XL1L2L3_Quota__c+ ' Q4 Quota_Amount__c : ' + qdetailsQtr4.Quota_Amount__c);
                    system.debug('Q4 L0L0X Revenue from Q4 Object : ' + qdetailsQtr4.Overall_L0_L0X_AC_FC_Rev__c + '  qdetailsQtr4 L0L0XL1 Revenue : ' + qdetailsQtr4.Overall_L0_L0X_L1_AC_FC_Rev__c + '  qdetailsQtr4 L0L0XL1L2L3 Revenue : ' + qdetailsQtr4.Overall_L0_L0X_L1L2L3AC_FC_Rev__c);
                    
                    newOwnerKeyToQtrlyQdetRowMap.put(eachQtrDetInckey, qdetailsQtr4);
                 }
            }//End of For loop
			
			 
        }// End outer for loop
         
              
              List<QuotaDetail__c> qdetailsFinallistToUpdate = new List<QuotaDetail__c>();
              for(String eachQtrDetInckey : newOwnerKeyToQtrlyQdetRowMap.keySet()){
                    qdetailsFinallistToUpdate.add(newOwnerKeyToQtrlyQdetRowMap.get(eachQtrDetInckey));
              }
              
              if(null != qdetailsFinallistToUpdate && qdetailsFinallistToUpdate.size() > 0){
                try{
                    system.debug('Updating Slippage Quota Details  : ' + qdetailsFinallistToUpdate);
                    update qdetailsFinallistToUpdate;
                }catch(DmlException dmle){
                    system.debug('Error Occured during Quota Detail slippage Update : ' + dmle);
                }
          }
        
    }// End of method
    
    
    public QuotaDetail__c groupQdetMonthlyToQtrly(QuotaDetail__c eachMonthlyQdet, QuotaDetail__c  qtrlyQdet){
    
                qtrlyQdet.id =  eachMonthlyQdet.id;
				qtrlyQdet.Owner_ID_Temp__c = eachMonthlyQdet.Quota_Owner_Formula__c;
				qtrlyQdet.Quota_Quarter__c = eachMonthlyQdet.Quota_Quarter__c;
                qtrlyQdet.Quota_Amount__c = null != qtrlyQdet.Quota_Amount__c ? qtrlyQdet.Quota_Amount__c + eachMonthlyQdet.Quota_Amount__c :  eachMonthlyQdet.Quota_Amount__c;
                qtrlyQdet.Revised_L0L0XL1_Quota__c = null != qtrlyQdet.Revised_L0L0XL1_Quota__c ?  qtrlyQdet.Revised_L0L0XL1_Quota__c + eachMonthlyQdet.Revised_L0L0XL1_Quota__c : eachMonthlyQdet.Revised_L0L0XL1_Quota__c ;
                qtrlyQdet.Revised_L0L0XL1L2L3_Quota__c = null != qtrlyQdet.Revised_L0L0XL1L2L3_Quota__c ? qtrlyQdet.Revised_L0L0XL1L2L3_Quota__c + eachMonthlyQdet.Revised_L0L0XL1L2L3_Quota__c :  eachMonthlyQdet.Revised_L0L0XL1L2L3_Quota__c ;
                qtrlyQdet.New_Quota__c = null != qtrlyQdet.New_Quota__c ? qtrlyQdet.New_Quota__c + eachMonthlyQdet.New_Quota__c : eachMonthlyQdet.New_Quota__c;
        
                qtrlyQdet.Overall_L0_L0X_AC_FC_Rev__c = null != qtrlyQdet.Overall_L0_L0X_AC_FC_Rev__c ? qtrlyQdet.Overall_L0_L0X_AC_FC_Rev__c + eachMonthlyQdet.Total_L0L0_X_AC_FCRev__c : eachMonthlyQdet.Total_L0L0_X_AC_FCRev__c ;
                qtrlyQdet.Overall_L0_L0X_L1_AC_FC_Rev__c = null != qtrlyQdet.Overall_L0_L0X_L1_AC_FC_Rev__c ? qtrlyQdet.Overall_L0_L0X_L1_AC_FC_Rev__c + eachMonthlyQdet.Total_L0_L0_X_L1_AC_FC_Rev__c : eachMonthlyQdet.Total_L0_L0_X_L1_AC_FC_Rev__c ;
                qtrlyQdet.Overall_L0_L0X_L1L2L3AC_FC_Rev__c = null != qtrlyQdet.Overall_L0_L0X_L1L2L3AC_FC_Rev__c ?  qtrlyQdet.Overall_L0_L0X_L1L2L3AC_FC_Rev__c + eachMonthlyQdet.Total_Rev_FC__c : eachMonthlyQdet.Total_Rev_FC__c;
                
            return qtrlyQdet;
        }
    

    public integer getQuarterNumber(integer mon){
        
        if(mon >= 4 && mon <= 6){
            return 1;
        }else if(mon >= 7 && mon <=9){
            return 2;
        }else if(mon >= 10 && mon <=12){
            return 3;
        }else{
            return 4;
        }
     }
  }