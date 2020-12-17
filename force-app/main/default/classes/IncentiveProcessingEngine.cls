/*
 * This class run once during deployment for data migration puropse.
 * It calculates the incentive for the existing revenues for the financial year.
 * It also calculates the quota slippage for the entire year.
 * 
 * 
 */
public class IncentiveProcessingEngine {
    
     public Map<id, List<QuotaDetail__c>> ownerToQuotaDetailsMap; //Map<Owner ID, QuotaDetail Id>
     public List<QuotaDetail__c> qdets;
     	Integer currMonth;
        Integer currYear;
        String fyPeriod;
        String startFY;
        String endFY;
        Integer prevMonth;
  		Date currrDate;
    	Integer currentQtr;
    
    public static String  SIPRODUCTSEXECUTIVE = 'SIProductsExecutive'; 	//SI Products 
    public static String  BCTIPEXECUTIVE = 'BCTIPExecutive'; 			//BCT IP
	public static String  PROFSERVICESEXECUTIVE = 'ProfServicesExecutive';  // Professional Services 	
	
	public static String  DIGITALTIBCOSVCSEXECUTIVE = 'BCTApprovedDigitalTIBCOServices';   //BCT approved Digital & TIBCO Services	
    public static String  CFENTSVCSEXECUTIVE = 'BCTCFEnterpriseServies'; 			//BCT C/F & Enterprise Servies
    
	// New fields added for new incetive changes
    public static String  TIBCOPRODUCTLICENSEEXECUTIVE = 'TIBCOProductLicenseExecutive'; 			//BCT IP 
    
	public static String  NEWLOGOEXECUTIVE = 'NewLogoExecutive'; 		//Not in this new changes
    
    
    
    
    public List<Incentive_Scheme__c> incScheme;
  	//Map<BCTServicesExecutive, Map<R31TO50, 0.15 Value>>
    public Map<String , Map<String, Decimal>> incentiveSchemeMap;
    
    public void IncentiveProcessingEngine(){
       
        
    } 
    
    public Map<String, decimal> processIncentiveSchemeInnerMap(Incentive_Scheme__c eachIncetiviScheme){
        				Map<String, decimal> inceRangeIMap = new Map<String, decimal>();
        
        				inceRangeIMap.put('R31TO50', eachIncetiviScheme.R31TO50__c);
                        inceRangeIMap.put('R51TO75', eachIncetiviScheme.R51TO75__c);
                        inceRangeIMap.put('R76TO90', eachIncetiviScheme.R76TO90__c);
                        inceRangeIMap.put('R91TO100', eachIncetiviScheme.R91TO100__c);
                        inceRangeIMap.put('R101TO110', eachIncetiviScheme.R101TO110__c);
                        inceRangeIMap.put('R110PLUS', eachIncetiviScheme.R110PLUS__C);
        
        return inceRangeIMap;
    }
    
   /* public String getIncentiveFY(integer incentiveMonth){
        String startFinY;
        String endFinY;
    
        if(currMonth > 3 ){
            startFinY = String.valueOf(currYear);
            endFinY = String.valueOf(currYear + 1);
            
            system.debug('startFY 2   : ' + startFinY);
            system.debug('endFY  2 : ' + endFinY);
        }else{
            startFinY = String.valueOf(currYear -1);
            endFinY = String.valueOf(currYear);
              
            system.debug('startFY 3  : ' + startFinY);
            system.debug('endFY  3 : ' + endFinY);
        }
        return startFY+'-'+endFY;
    }    */
    
    
   // Main Incentive process starts 
    public void processIncentive(){
	
        List<Incentive_Master__c> incmstr;
        List<QuotamasterNew__c> qmst;
        List<id> qmstIdList = new List<id>();
       
        
         system.debug('Entered Incentive Processing Engine constructor .. Yeyyy');
         currrDate = Date.today();
 		 currMonth = currrDate.month();
         currYear =  currrDate.year();
        if(currMonth > 3 ){
            startFY = String.valueOf(currYear);
            endFY = String.valueOf(currYear + 1);
            
          }else{
            startFY = String.valueOf(currYear -1);
            endFY = String.valueOf(currYear);
          }
        
      /*  if(currMonth == 4){
            startFY = String.valueOf(currYear -1);
            endFY = String.valueOf(currYear);
        }*/
        
		fyPeriod = startFY +'-'+ endFY;
        system.debug('fyPeriod   : ' + fyPeriod);
        //Get Current qtr 
        currentQtr = getQuarter(currMonth);
        
        //This code is to ignore the prev fy months
        if(currMonth - 1 <= 3 ){
            prevMonth = 0;
        }else{
            prevMonth = currrDate.month() - 1;
        }
        
        // Collecting Incentive Scheme data 
        
        incScheme = [SELECT ID, IC_BUSINESS_CATEGORY__C, IC_REVENUE_STREAM__C, INCENTIVE_SCHEME_TYPE__C, R31TO50__C, R51TO75__C, R76TO90__C, R91TO100__C, R101TO110__C, R110PLUS__C, INCENTIVE_TERM__C, INCENTIVE_PERIOD__C FROM INCENTIVE_SCHEME__C WHERE INCENTIVE_PERIOD__C=:fyPeriod ];
        
      //  system.debug('Incetive Scheme Data : ' + incScheme);
        
        //Map<String, Decimal> inceRangeInnerMap =  new Map<String, Decimal>();
      	incentiveSchemeMap = new Map<String, Map<String, Decimal>>();
        //Populating incentive scheme data map
        for(Incentive_Scheme__c eachScheme : incScheme){
            	   Map<String, Decimal> inceRangeInnerMap =  new Map<String, Decimal>();
            
            if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT approved Digital & TIBCO Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                       			  incentiveSchemeMap.put('BCTApprovedDigitalTIBCOServices', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('Professional Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                				  incentiveSchemeMap.put('ProfServicesExecutive', processIncentiveSchemeInnerMap(eachScheme));
                													   
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT Enterprise Services') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                				  incentiveSchemeMap.put('BCTCFEnterpriseServies', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('TIBCO Product License') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                				  incentiveSchemeMap.put('TIBCOProductLicenseExecutive', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('SI Products') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                				  incentiveSchemeMap.put('SIProductsExecutive', processIncentiveSchemeInnerMap(eachScheme));
                
            }else if(eachScheme.IC_REVENUE_STREAM__C.equalsIgnoreCase('BCT IP') && eachScheme.INCENTIVE_SCHEME_TYPE__C.equalsIgnoreCase('Executive VC')){
                				  incentiveSchemeMap.put('BCTIPExecutive', processIncentiveSchemeInnerMap(eachScheme));
                }
          }
      
        
        String tempQPeriod = startFY +'-'+ endFY;
        
        system.debug('Quota Period in Process Incentive method : ' + tempQPeriod);
        //Added SBU = USA filter
       qdets = [SELECT Id, Quota_Amount__c, createdbyid, new_quota__c, Quota_Quarter__c, Revised_L0L0XL1_Quota__c,Revised_L0L0XL1L2L3_Quota__c, Total_L0L0_X_AC_FCRev__c, Total_L0_L0_X_L1_AC_FC_Rev__c, QuotaMasterNew__c, IP_Actual_Revenue_Summary__c, Total_Rev_FC__c, BCT_Services_L0_L0X_Mon_Rev__c,BCT_Services_L1_Mon_Rev__c, BCT_Services_L2_L3_Mon_Rev__c, Existing_Contracts_L0L0_X_Mon_Rev__c,  Existing_Contracts_L1_Mon_Rev__c, Existing_Contracts_L2L3_Mon_Rev__c, New_Logo_L1_Mon_Rev__c, New_Logo_L0L0X_Mon_Rev__c, New_Logo_L2L3_Mon_Rev__c, QuotaMasterNew__r.Sales_Owner_Role__c, QuotaMasterNew__r.Quota_Owner_Name__c, QuotaMasterNew__r.SBU__c, QuotaMasterNew__r.Quota_Owner_Manager__c, Quota_Owner_Formula__c, QuotaMasterNew__r.Quota_Start_Period__c, QuotaMasterNew__r.ownerId, Quota_Date__C, Quota_Variance__c, Revenue_Recognized_Amount__c, COE_Target__c, Huringa_Quota_by_product__c, product_Type_QDET__c, quota_month__c, quotayear__c, BCT_IP_L1_Monthly_WAvg_Rev__c, BCTIP_L0_L0_X_Monthly_Actual_Rev__c, BCT_IP_L2_L3_Monthly_Rev__c, PSvc_L0L0X_Mon_Rev__c, PSvc_L1_Mon_Rev__c, PSvc_L2L3_Mon_Rev__c, SI_Products_L0_L0_X_Mon_Rev__c, SI_Products_L1_Mon_Rev__c, SI_Products_L2L3_Mon_Rev__c FROM QuotaDetail__c where QuotaMasterNew__r.Quota_Period__c = :tempQPeriod and QuotaMasterNew__r.Product_Type__c='OVERALL'];
        
      
        system.debug('1 - Engine - Quota Details ' + qdets);
        system.debug('1 - Engine - Quota Details size' + qdets.size());
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
            }
		}
        
        system.debug('2- Engine Printing Map size :' + ownerToQuotaDetailsMap.size());
        system.debug('2- Engine Printing Map :' + ownerToQuotaDetailsMap);
        
       system.debug('Incentive Scheme Map : ' + incentiveSchemeMap);
        incmstr = [SELECT ID, OwnerId, Actual_Quota__c,Actual_Revenue_Recognized__c, Total_L0L0X_Revenue__c, BCT_IP_L0L0X_QtrActualsRev__c, BCTIP_L1_Qtr_Rev__c, BCTIP_L2L3_QtrRev__c, PSvc_L0L0X_Qtr_Rev__c, PSvc_L1_Qtr_Rev__c, PSvc_L2L3_Qtr_Rev__c, SI_Products_L0L0X_Qtr_Rev__c, SI_Products_L1_Qtr_Rev__c, SI_Products_L2L3_Qtr_Rev__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L1__c, Rev_BCT_CF_Ent_Svcs_L2L3__c, Rev_TIBCO_Pdt_License_L0L0X__c, Rev_TIBCO_Pdt_License_L1__c, Rev_TIBCO_Pdt_License_L2L3__c, Total_Rev_L0_L0X__c, Total_L1_Revenue__c, Total_L2L3_Revenue__c, Incentive_BCT_IP__c,Incentive_BCT_IP_L1__c, Incentive_BCT_IP_L2_L3__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c,Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c, Incen_BCT_CF_Ent_Svcs_L0L0X__c, Incen_BCT_CF_Ent_Svcs_L1__c, Incen_BCT_CF_Ent_Svcs_L2L3__c, Incen_TIBCO_Pdt_License_L0L0X__c, Incen_TIBCO_Pdt_License_L1__c, Incen_TIBCO_Pdt_License_L2L3__c, Incentive_ProfSvcs__c, Incentive_ProfSvcs_L1__c, Incentive_ProfSvcs_L2_L3__c, Incentive_SI_Products__c, Incentive_SI_Products_L1__c, Incentive_SI_Products_L2_L3__c, Incentive_Start_Period__c,Incentive_End_Period__c,  Quarterly_IP_Quota__c, Quarterly_Overall_Quota__c, Quota_Period__c, Sales_Owner_Name__c, SalesUserId__c, Sales_User_Manager__c, SBU__c from Incentive_Master__c where Quota_Period__c =:fyPeriod] ;
         system.debug('Incentive Master records available ? :' + incmstr);
        //List<Incentive_Master__c> tempIncMasterlist = new
        if(null != incmstr && incmstr.size() > 0 ){
            // flow for incentive master found
            try{
                delete incmstr;
            }catch(DmlException dmle){
                system.debug('Error Occured while inserting Incentive Master record ' + dmle);
            }catch(Exception e){
                system.debug('Generic error : ' + e);
                
            	}
             system.debug('Incentive Master records Deleted ? :' + incmstr);
           startfirstIncentiveCalculation();
            
          }else{
            //else flow for incentive master data not available. This will be executed only once after deploying first time.
            system.debug('Incentive Master data not found. Staring initial setup');
             startfirstIncentiveCalculation();
        	}
        }
    
    // This method runs only once since its deployed.
    
    private void startfirstIncentiveCalculation(){
       //  ownerToQuotaDetailsMap;
       //  
         Map<id, List<Incentive_Master__c>> ownerToIncMasterRecMap = new Map<id, List<Incentive_Master__c>>();
         List<Incentive_Master__c> incentveMasterListForaQwner = new List<Incentive_Master__c>();
        
        for(id eachOwner : ownerToQuotaDetailsMap.keySet()){
                List<Incentive_Master__c> incentveMasterRecList = new List<Incentive_Master__c>();
            	
            	list<QuotaDetail__c> qdetListforAOwner = ownerToQuotaDetailsMap.get(eachOwner);
                Incentive_Master__c q1 = new Incentive_Master__c();
                Incentive_Master__c q2 = new Incentive_Master__c();
                Incentive_Master__c q3 = new Incentive_Master__c();
                Incentive_Master__c q4 = new Incentive_Master__c();
                
                for(QuotaDetail__c eachQdet: qdetListforAOwner ){
                    
                    integer qMonth = Integer.valueOf(eachQdet.Quota_Month__c) ;
                    if(getQuarter(qMonth) == 1 ){
                          //Q1
                       		q1 = populateIncentive(eachQdet, 1, q1);
                        	
                    	}else if(getQuarter(qMonth) == 2){
                          // Q2
                       		q2 = populateIncentive(eachQdet, 2, q2);
                     	 	
                        }else if(getQuarter(qMonth) == 3){
                          // Q3
                        	q3 = populateIncentive(eachQdet, 3, q3);
							               
                        }else if(getQuarter(qMonth) == 4){
                          //Q4  
                        	q4 = populateIncentive(eachQdet, 4, q4);
                        }
                }// End qdet For loop
          		
            List<Integer> completedQtrs = getCompletedQtrs(currMonth) ;
            // This is for calcuating incentive projection for L1 L2 L3 opportunities
           /* decimal totalL1Revq1 = q1.BCTIP_L1_Qtr_Rev__c + q1.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + q1.Rev_BCT_CF_Ent_Svcs_L1__c + q1.PSvc_L1_Qtr_Rev__c + q1.Rev_TIBCO_Pdt_License_L1__c + q1.SI_Products_L1_Qtr_Rev__c;
            decimal totalL1Revq2 = q2.BCTIP_L1_Qtr_Rev__c + q2.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + q2.Rev_BCT_CF_Ent_Svcs_L1__c + q2.PSvc_L1_Qtr_Rev__c + q2.Rev_TIBCO_Pdt_License_L1__c + q2.SI_Products_L1_Qtr_Rev__c;
            decimal totalL1Revq3 = q3.BCTIP_L1_Qtr_Rev__c + q3.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + q3.Rev_BCT_CF_Ent_Svcs_L1__c + q3.PSvc_L1_Qtr_Rev__c + q3.Rev_TIBCO_Pdt_License_L1__c + q3.SI_Products_L1_Qtr_Rev__c;
            decimal totalL1Revq4 = q4.BCTIP_L1_Qtr_Rev__c + q4.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + q4.Rev_BCT_CF_Ent_Svcs_L1__c + q4.PSvc_L1_Qtr_Rev__c + q4.Rev_TIBCO_Pdt_License_L1__c + q4.SI_Products_L1_Qtr_Rev__c;
            
            decimal totalL2L3RevQ1 = q1.BCTIP_L2L3_QtrRev__c + q1.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c + q1.Rev_BCT_CF_Ent_Svcs_L2L3__c + q1.PSvc_L2L3_Qtr_Rev__c + q1.Rev_TIBCO_Pdt_License_L2L3__c + q1.SI_Products_L2L3_Qtr_Rev__c;
            decimal totalL2L3RevQ2 = q2.BCTIP_L2L3_QtrRev__c + q2.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c + q2.Rev_BCT_CF_Ent_Svcs_L2L3__c + q2.PSvc_L2L3_Qtr_Rev__c + q2.Rev_TIBCO_Pdt_License_L2L3__c + q2.SI_Products_L2L3_Qtr_Rev__c;
            decimal totalL2L3RevQ3 = q3.BCTIP_L2L3_QtrRev__c + q3.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c + q3.Rev_BCT_CF_Ent_Svcs_L2L3__c + q3.PSvc_L2L3_Qtr_Rev__c + q3.Rev_TIBCO_Pdt_License_L2L3__c + q3.SI_Products_L2L3_Qtr_Rev__c;
            decimal totalL2L3RevQ4 = q4.BCTIP_L2L3_QtrRev__c + q4.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c + q4.Rev_BCT_CF_Ent_Svcs_L2L3__c + q4.PSvc_L2L3_Qtr_Rev__c + q4.Rev_TIBCO_Pdt_License_L2L3__c + q4.SI_Products_L2L3_Qtr_Rev__c;
            */
            
           //  system.debug('totalL1Revq1 : ' +totalL1Revq1 +'totalL1Revq2 :  '+ totalL1Revq2 + 'totalL1Revq3 : ' + totalL1Revq3 + 'totalL1Revq4 : '+ totalL1Revq4 );
			 // Quarterly_Overall_Quota__c - Quarterly Revised quota for L0 L0-X. This is the variable quota for LOL0-X addded with with slippage of L0 L0-X revenues.
			 // New_Quota__c  - In Quota Detail obj. This field is used to hold variable quota for L0L0-X slippage revenues.
			 // Quota_L0L0XL1_Revised__c  -In Inc Master Obj - This quota is the revised quota for L0+L0-X+L1 slipage revenues
			 // Quota_L0L0XL1L2L3_Revised__c - In Inc Master Obj - This quota is the revised quota for L0+L0-X+L1+L2+L3 slipage revenues
			 // L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c
			 //  L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c Total_L0L0XL1_Revenue__c -  IncMstr Obj field - sum of L0L0XL1 qtrly rev  populated from Qdet object 
			 //  L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c Total_L0L0XL1L2L3_Revenue__c - IncMstr Obj field - sum of L0L0XL1L2L3 qtrly rev  populated from Qdet object 
			 
			
            for(Integer compQtr : completedQtrs){
                if(compQtr == 1){
                   system.debug('START --> Q1');
				   system.debug('Q1 L0L0X Quota : ' + q1.Quarterly_Overall_Quota__c + '  Q1 L0L0XL1 Quota : ' + q1.Quota_L0L0XL1_Revised__c + '  Q1 L0L0XL1L2L3 Quota : ' + q1.Quota_L0L0XL1L2L3_Revised__c);
				   system.debug('Q1 L0L0X Revenue : ' + q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  Q1 L0L0XL1 Revenue : ' + q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  Q1 L0L0XL1L2L3 Revenue : ' + q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
				   
				   
				  Decimal tempRevL0 =  (null == q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL1 =  (null == q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL2L3 =  (null == q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
					decimal tempQtlyAchievementPercentage = ((null != q1.Quarterly_Overall_Quota__c && q1.Quarterly_Overall_Quota__c != 0) ? (q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / q1.Quarterly_Overall_Quota__c) * 100 : (q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
					decimal tempQtlyL1AchvePerc = ((null != q1.Quota_L0L0XL1_Revised__c && q1.Quota_L0L0XL1_Revised__c != 0) ? (q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / q1.Quota_L0L0XL1_Revised__c) * 100 : ((q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                    decimal tempQtlyL2L3AchvePerc = ((null != q1.Quota_L0L0XL1L2L3_Revised__c && q1.Quota_L0L0XL1L2L3_Revised__c != 0) ? ((q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) / q1.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
					
					system.debug('Q1 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  Q1 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  Q1 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
                    
					q1.Overall_IP_Actual__c = (null != q1.Overall_IP_Actual__c ? q1.Overall_IP_Actual__c : 0);
                    decimal tempQtlyIPAchievementPercentage = ((null != q1.Quarterly_IP_Quota__c && q1.Quarterly_IP_Quota__c != 0) ? (q1.Overall_IP_Actual__c / q1.Quarterly_IP_Quota__c) * 100 : (q1.Overall_IP_Actual__c / 1)*100 );
                    
                    
					q1.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
					q1.Overall_Acheived__c = tempQtlyAchievementPercentage;
                    boolean isOverallAchieved = tempQtlyAchievementPercentage > 30 ? true : false;
					
                    q1.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
					q1.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
					q1.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
					
                    q1 = workoutIncentiveForUsrQtrWise(q1, 1, isOverallAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));
                 
                    
                }else if(compQtr == 2){
                     // The following code is to check if the quota is slipped for the previous quarter. If slipped then  the slipped amount is added to the next quarters new quota.
	                 // Finding Variance from previous Qtarter revenue to previous quarter Quota.
					system.debug('START --> Q2');
					decimal q1QuotaVarianceL0L0X = q1.Quarterly_Overall_Quota__c - q1.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
					decimal q1QuotaVarianceL0L0XL1 = q1.Quota_L0L0XL1_Revised__c - q1.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
					decimal q1QuotaVarianceL0L0XL1L2L3 = q1.Quota_L0L0XL1L2L3_Revised__c - q1.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
					   
					system.debug('q1QuotaVarianceL0L0X : ' +  q1QuotaVarianceL0L0X +' q1QuotaVarianceL0L0XL1 : '+ q1QuotaVarianceL0L0XL1 + ' q1QuotaVarianceL0L0XL1L2L3 : ' +  q1QuotaVarianceL0L0XL1L2L3 + '   q2 L0L0-X Revised Quota : ' + q2.Quarterly_Overall_Quota__c);
					 // Handling quota slippage by comparing prev qtr quota with prev qtr revenune
                    q2.Quarterly_Overall_Quota__c = q1QuotaVarianceL0L0X > 0 ? (q2.Quarterly_Overall_Quota__c + q1QuotaVarianceL0L0X) : q2.Quarterly_Overall_Quota__c;
					q2.Quota_L0L0XL1_Revised__c = q1QuotaVarianceL0L0XL1 > 0 ? (q2.Quota_L0L0XL1_Revised__c + q1QuotaVarianceL0L0XL1) : q2.Quota_L0L0XL1_Revised__c;
					q2.Quota_L0L0XL1L2L3_Revised__c = q1QuotaVarianceL0L0XL1L2L3 > 0 ? (q2.Quota_L0L0XL1L2L3_Revised__c + q1QuotaVarianceL0L0XL1L2L3) : q2.Quota_L0L0XL1L2L3_Revised__c;
                    
					
					system.debug('Q2 L0L0X Quota : ' + q2.Quarterly_Overall_Quota__c + '  Q2 L0L0XL1 Quota : ' + q2.Quota_L0L0XL1_Revised__c + '  Q2 L0L0XL1L2L3 Quota : ' + q2.Quota_L0L0XL1L2L3_Revised__c);
				    system.debug('Q2 L0L0X Revenue : ' + q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  Q2 L0L0XL1 Revenue : ' + q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  Q2 L0L0XL1L2L3 Revenue : ' + q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
				  
				  Decimal tempRevL0 =  (null == q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL1 =  (null == q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL2L3 =  (null == q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
					
					
					decimal tempQtlyAchievementPercentage = ((null != q2.Quarterly_Overall_Quota__c && q2.Quarterly_Overall_Quota__c != 0) ? (q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / q2.Quarterly_Overall_Quota__c) * 100 : (q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0)*100);
					decimal tempQtlyL1AchvePerc = ((null != q2.Quota_L0L0XL1_Revised__c && q2.Quota_L0L0XL1_Revised__c != 0) ? (q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / q2.Quota_L0L0XL1_Revised__c) * 100 : ((q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                    decimal tempQtlyL2L3AchvePerc = ((null != q2.Quota_L0L0XL1L2L3_Revised__c && q2.Quota_L0L0XL1L2L3_Revised__c != 0) ? (q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c / q2.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
                  
					system.debug('Q2 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + 'Q2 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + 'Q2 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);	
					
					q2.Overall_IP_Actual__c = (null != q2.Overall_IP_Actual__c ? q2.Overall_IP_Actual__c : 0);
                    decimal tempQtlyIPAchievementPercentage = ((null != q2.Quarterly_IP_Quota__c && q2.Quarterly_IP_Quota__c != 0) ? (q2.Overall_IP_Actual__c / q2.Quarterly_IP_Quota__c) * 100 : (q2.Overall_IP_Actual__c / 1)*100 );
                    //system.debug('Q2 Overall achieved percentage : ' + tempQtlyAchievementPercentage +'  IP achieved : '+ tempQtlyIPAchievementPercentage);
                    
					
					q2.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
					q2.Overall_Acheived__c = tempQtlyAchievementPercentage;
                    boolean isOverallAchieved = tempQtlyAchievementPercentage > 30 ? true : false;
					
					q2.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
					q2.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
					q2.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
                    
                    q2 = workoutIncentiveForUsrQtrWise(q2, 2, isOverallAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));
                    
                }else if(compQtr == 3){
                    system.debug('START --> Q3');
                    decimal q2QuotaVarianceL0L0X = q2.Quarterly_Overall_Quota__c - q2.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
					decimal q2QuotaVarianceL0L0XL1 = q2.Quota_L0L0XL1_Revised__c - q2.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
					decimal q2QuotaVarianceL0L0XL1L2L3 = q2.Quota_L0L0XL1L2L3_Revised__c - q2.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
					
					system.debug('q2QuotaVarianceL0L0X : ' +  q2QuotaVarianceL0L0X +' q2QuotaVarianceL0L0XL1 : '+ q2QuotaVarianceL0L0XL1 + ' q2QuotaVarianceL0L0XL1L2L3 : ' +  q2QuotaVarianceL0L0XL1L2L3); 
					
					q3.Quarterly_Overall_Quota__c = q2QuotaVarianceL0L0X > 0 ? (q3.Quarterly_Overall_Quota__c + q2QuotaVarianceL0L0X) : q3.Quarterly_Overall_Quota__c;
					q3.Quota_L0L0XL1_Revised__c = q2QuotaVarianceL0L0XL1 > 0 ? (q3.Quota_L0L0XL1_Revised__c + q2QuotaVarianceL0L0XL1) : q3.Quota_L0L0XL1_Revised__c;
					q3.Quota_L0L0XL1L2L3_Revised__c = q2QuotaVarianceL0L0XL1L2L3 > 0 ? (q3.Quota_L0L0XL1L2L3_Revised__c + q2QuotaVarianceL0L0XL1L2L3) : q3.Quota_L0L0XL1L2L3_Revised__c;
                    
					system.debug('Q3 L0L0X Quota : ' + q3.Quarterly_Overall_Quota__c + '  q3 L0L0XL1 Quota : ' + q3.Quota_L0L0XL1_Revised__c + '  q3 L0L0XL1L2L3 Quota : ' + q3.Quota_L0L0XL1L2L3_Revised__c);
				    system.debug('q3 L0L0X Revenue : ' + q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  q3 L0L0XL1 Revenue : ' + q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  q3 L0L0XL1L2L3 Revenue : ' + q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
				  
				  Decimal tempRevL0 =  (null == q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL1 =  (null == q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL2L3 =  (null == q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
					decimal tempQtlyAchievementPercentage = ((null != q3.Quarterly_Overall_Quota__c && q3.Quarterly_Overall_Quota__c != 0) ? (q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / q3.Quarterly_Overall_Quota__c) * 100 : (q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
					decimal tempQtlyL1AchvePerc = ((null != q3.Quota_L0L0XL1_Revised__c && q3.Quota_L0L0XL1_Revised__c != 0) ? (q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / q3.Quota_L0L0XL1_Revised__c) * 100 : ((q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                    decimal tempQtlyL2L3AchvePerc = ((null != q3.Quota_L0L0XL1L2L3_Revised__c && q3.Quota_L0L0XL1L2L3_Revised__c != 0) ? (q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c / q3.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
                  
					system.debug('Q3 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + 'Q3 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + 'Q3 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
					
					q3.Overall_IP_Actual__c = (null != q3.Overall_IP_Actual__c ? q3.Overall_IP_Actual__c : 0);
                    decimal tempQtlyIPAchievementPercentage = ((null != q3.Quarterly_IP_Quota__c && q3.Quarterly_IP_Quota__c != 0) ? (q3.Overall_IP_Actual__c / q3.Quarterly_IP_Quota__c) * 100 : (q3.Overall_IP_Actual__c / 1)*100 );
                   
                   // system.debug('Q3 Overall achieved percentage : ' + tempQtlyAchievementPercentage +'  IP achieved : '+ tempQtlyIPAchievementPercentage);
                    
                    
					 q3.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
					 q3.Overall_Acheived__c = tempQtlyAchievementPercentage;
                    
                    boolean isOverallAchieved = tempQtlyAchievementPercentage > 30 ? true : false;
					
					q3.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
					q3.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
					q3.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
					
                    q3 =  workoutIncentiveForUsrQtrWise(q3, 3, isOverallAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));
                  
                }else if(compQtr == 4){
                     
					 system.debug('START --> Q4');
					decimal q3QuotaVarianceL0L0X = q3.Quarterly_Overall_Quota__c - q3.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
					decimal q3QuotaVarianceL0L0XL1 = q3.Quota_L0L0XL1_Revised__c - q3.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
					decimal q3QuotaVarianceL0L0XL1L2L3 = q3.Quota_L0L0XL1L2L3_Revised__c - q3.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
					
					system.debug('q3QuotaVarianceL0L0X : ' +  q3QuotaVarianceL0L0X +' q3QuotaVarianceL0L0XL1 : '+ q3QuotaVarianceL0L0XL1 + ' q3QuotaVarianceL0L0XL1L2L3 : ' +  q3QuotaVarianceL0L0XL1L2L3); 
					
					q4.Quarterly_Overall_Quota__c = q3QuotaVarianceL0L0X > 0 ? (q4.Quarterly_Overall_Quota__c + q3QuotaVarianceL0L0X) : q4.Quarterly_Overall_Quota__c;
					q4.Quota_L0L0XL1_Revised__c = q3QuotaVarianceL0L0XL1 > 0 ? (q4.Quota_L0L0XL1_Revised__c + q3QuotaVarianceL0L0XL1) : q4.Quota_L0L0XL1_Revised__c;
					q4.Quota_L0L0XL1L2L3_Revised__c = q3QuotaVarianceL0L0XL1L2L3 > 0 ? (q4.Quota_L0L0XL1L2L3_Revised__c + q3QuotaVarianceL0L0XL1L2L3) : q4.Quota_L0L0XL1L2L3_Revised__c;
                    
					system.debug('q4 L0L0X Quota : ' + q4.Quarterly_Overall_Quota__c + '  q4 L0L0XL1 Quota : ' + q4.Quota_L0L0XL1_Revised__c + '  q4 L0L0XL1L2L3 Quota : ' + q4.Quota_L0L0XL1L2L3_Revised__c);
				    system.debug('q4 L0L0X Revenue : ' + q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  q4 L0L0XL1 Revenue : ' + q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  q4 L0L0XL1L2L3 Revenue : ' + q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
				  
				  Decimal tempRevL0 =  (null == q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL1 =  (null == q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				  
				  Decimal tempRevL2L3 =  (null == q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 : q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
				  
					decimal tempQtlyAchievementPercentage = ((null != q4.Quarterly_Overall_Quota__c && q4.Quarterly_Overall_Quota__c != 0) ? (q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / q4.Quarterly_Overall_Quota__c) * 100 : (q4.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
					decimal tempQtlyL1AchvePerc = ((null != q4.Quota_L0L0XL1_Revised__c && q4.Quota_L0L0XL1_Revised__c != 0) ? (q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / q4.Quota_L0L0XL1_Revised__c) * 100 : ((q4.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                    decimal tempQtlyL2L3AchvePerc = ((null != q4.Quota_L0L0XL1L2L3_Revised__c && q4.Quota_L0L0XL1L2L3_Revised__c != 0) ? (q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c / q4.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((q4.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
                  
					system.debug('Q4 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + 'Q4 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + 'Q4 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
					
					q4.Overall_IP_Actual__c = (null != q4.Overall_IP_Actual__c ? q4.Overall_IP_Actual__c : 0);
                    decimal tempQtlyIPAchievementPercentage = ((null != q4.Quarterly_IP_Quota__c && q4.Quarterly_IP_Quota__c != 0) ? (q4.Overall_IP_Actual__c / q4.Quarterly_IP_Quota__c) * 100 : (q4.Overall_IP_Actual__c / 1)*100 );
                    
                     //system.debug('Q4 Overall achieved percentage : ' + tempQtlyAchievementPercentage +'  IP achieved : '+ tempQtlyIPAchievementPercentage);
					 q4.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				 	 q4.Overall_Acheived__c = tempQtlyAchievementPercentage;
                    
                     boolean isOverallAchieved = tempQtlyAchievementPercentage > 30 ? true : false;
					
					q4.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
					q4.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
					q4.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
					 
                    q4 = workoutIncentiveForUsrQtrWise(q4, 4, isOverallAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc) );
                   
                }
                
            }
                        incentveMasterListForaQwner.add(q1);
                        incentveMasterListForaQwner.add(q2);
                        incentveMasterListForaQwner.add(q3);
                        incentveMasterListForaQwner.add(q4);
            
            			incentveMasterRecList.add(q1);
                        incentveMasterRecList.add(q2);
                        incentveMasterRecList.add(q3);
                        incentveMasterRecList.add(q4);
            			
            	ownerToIncMasterRecMap.put(eachOwner ,incentveMasterRecList);
            	
            	
            }// End of outer loop 
				system.debug('Owner To Inc Master Temp Map :' +  ownerToIncMasterRecMap);
                system.debug('Incentive master list for a owner size  : ' + incentveMasterListForaQwner.size());
                system.debug('Incentive master list for a owner  : ' + incentveMasterListForaQwner);
      /*  for( id everyowner : ownerToIncMasterRecMap.keySet()){
            system.debug('Printing Incentive Master Details : ');
            system.debug(ownerToIncMasterRecMap.get(everyowner));
            }*/
        
      //  system.debug('Owner To Inc Master Full Map :' +  ownerToIncMasterRecMap);
        
        if(null != incentveMasterListForaQwner && incentveMasterListForaQwner.size()> 0){
            try{
                insert incentveMasterListForaQwner;
            }catch(DmlException dmle){
                system.debug('Error Occured while inserting Incentive Master record ' + dmle);
            }catch(Exception e){
                system.debug('Generic error : ' + e);
                
            	}
        	}
        }
    
    
    public String getAchievementRangeCode(decimal achievePercentage){
        if(achievePercentage > 30  && achievePercentage <= 50 ){
            return 'R31TO50';
        }else if(achievePercentage > 50 && achievePercentage <= 75){
             return 'R51TO75';
        }else if(achievePercentage > 75 && achievePercentage <= 90){
             return 'R76TO90';
        }else if(achievePercentage > 90 && achievePercentage <= 100){
             return 'R91TO100';
        }else if(achievePercentage > 100 && achievePercentage <= 110){
             return 'R101TO110';
        }else if(achievePercentage > 110){
             return 'R110PLUS';
        }else{
             return 'LESS30';
        }
        
    }
    
    public List<integer> getCompletedQtrs(integer currentmonth){
        List<Integer> complList =  new List<Integer>();
        complList.add(1);
        complList.add(2);
        complList.add(3);
        complList.add(4);
   
        system.debug('Completed Qtrs : ' + complList);
        return complList;
        
    }
    
    // This method contructs the incentive object in quarterly by grouping the monthly quota and revenues from quota detail values.
    public Incentive_Master__c populateIncentive(QuotaDetail__c eachQdet, integer Qtr, Incentive_Master__c tempIncMsRec){
       // system.debug('Inside populateIncentive');
       // Total_Rev_FC__c - sum of all 6 revenue types of L0L0X L1 L2 L3 (Monthly)
         Date startdt;
        system.debug('Quarter : ' + Qtr);
        system.debug('in Populate incentive Method Inc Master : ' + tempIncMsRec);
        system.debug('in Populate incentive Method Qdet : ' + eachQdet);
        tempIncMsRec.SalesUserId__c = eachQdet.Quota_Owner_Formula__c;
        tempIncMsRec.OwnerId = eachQdet.Quota_Owner_Formula__c;
        tempIncMsRec.Sales_User_Manager__c = eachQdet.QuotaMasterNew__r.Quota_Owner_Manager__c;
        tempIncMsRec.SBU__c = eachQdet.QuotaMasterNew__r.SBU__c;
		// grouping quota in quarterly basis. SUmming up incentive master quotas with monthly quota detail quotas.
		// system.debug('Before L0L0X Revised Quota : ' + tempIncMsRec.Quarterly_Overall_Quota__c + 'L0L0XL1 Revised Quota  : ' + tempIncMsRec.Quota_L0L0XL1_Revised__c + 'L0L0XL1L2L3 Revised Quota : ' + tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c);
		  
        /* commenting for a defect fix if(Qtr == 1 ){
        	tempIncMsRec.Quarterly_Overall_Quota__c = (tempIncMsRec.Quarterly_Overall_Quota__c != null ? tempIncMsRec.Quarterly_Overall_Quota__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
            tempIncMsRec.Quota_L0L0XL1_Revised__c = (tempIncMsRec.Quota_L0L0XL1_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1_Revised__c + eachQdet.Revised_L0L0XL1_Quota__c: eachQdet.Revised_L0L0XL1_Quota__c);
            tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c = (tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c + eachQdet.Revised_L0L0XL1L2L3_Quota__c : eachQdet.Revised_L0L0XL1L2L3_Quota__c);
        }else{
            tempIncMsRec.Quarterly_Overall_Quota__c = (tempIncMsRec.Quarterly_Overall_Quota__c != null ? tempIncMsRec.Quarterly_Overall_Quota__c + eachQdet.New_Quota__c : eachQdet.New_Quota__c);
            tempIncMsRec.Quota_L0L0XL1_Revised__c = (tempIncMsRec.Quota_L0L0XL1_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1_Revised__c + eachQdet.Revised_L0L0XL1_Quota__c: eachQdet.Revised_L0L0XL1_Quota__c);
            tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c = (tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c + eachQdet.Revised_L0L0XL1L2L3_Quota__c : eachQdet.Revised_L0L0XL1L2L3_Quota__c);
        }*/
		
		  
		tempIncMsRec.Quarterly_Overall_Quota__c = (tempIncMsRec.Quarterly_Overall_Quota__c != null ? tempIncMsRec.Quarterly_Overall_Quota__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
		tempIncMsRec.Quota_L0L0XL1_Revised__c = (tempIncMsRec.Quota_L0L0XL1_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1_Revised__c + eachQdet.Quota_Amount__c: eachQdet.Quota_Amount__c);
		tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c = (tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
       
		
		//system.debug('After L0L0X Revised Quota : ' + tempIncMsRec.Quarterly_Overall_Quota__c + 'L0L0XL1 Revised Quota  : ' + tempIncMsRec.Quota_L0L0XL1_Revised__c + 'L0L0XL1L2L3 Revised Quota : ' + tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c);
        tempIncMsRec.actual_quota__c = (tempIncMsRec.actual_quota__c != null ? tempIncMsRec.actual_quota__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
        tempIncMsRec.Quota_Period__c =  fyPeriod;
        tempIncMsRec.Quarterly_IP_Quota__c = (tempIncMsRec.Quarterly_IP_Quota__c != null ? tempIncMsRec.Quarterly_IP_Quota__c + eachQdet.Huringa_Quota_by_product__c : eachQdet.Huringa_Quota_by_product__c); 
        // Grouping Revenues quarter wise
        tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c  = (tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_L0L0_X_AC_FCRev__c : eachQdet.Total_L0L0_X_AC_FCRev__c);
        tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c = (tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c : eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c);
        tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c = (tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_Rev_FC__c : eachQdet.Total_Rev_FC__c);
        	
       
        
        
		tempIncMsRec.Actual_Revenue_Recognized__c = (tempIncMsRec.Actual_Revenue_Recognized__c != null ? tempIncMsRec.Actual_Revenue_Recognized__c + eachQdet.Revenue_Recognized_Amount__c : eachQdet.Revenue_Recognized_Amount__c);
        tempIncMsRec.Overall_IP_Actual__c =  (tempIncMsRec.Overall_IP_Actual__c != null ? tempIncMsRec.Overall_IP_Actual__c + eachQdet.IP_Actual_Revenue_Summary__c : eachQdet.IP_Actual_Revenue_Summary__c); 
        // Grouping and accumulating Total revenue for different funnels
		/*tempIncMsRec.Total_L0L0X_Revenue__c = (tempIncMsRec.Total_L0L0X_Revenue__c != null ? tempIncMsRec.Total_L0L0X_Revenue__c + eachQdet.Total_L0L0_X_AC_FCRev__c : eachQdet.Total_L0L0_X_AC_FCRev__c); 
		tempIncMsRec.Total_L0L0XL1_Revenue__c = (tempIncMsRec.Total_L0L0XL1_Revenue__c != null ? tempIncMsRec.Total_L0L0XL1_Revenue__c + eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c : eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c); 
		tempIncMsRec.Total_L0L0XL1L2L3_Revenue__c = (tempIncMsRec.Total_L0L0XL1L2L3_Revenue__c != null ? tempIncMsRec.Total_L0L0XL1L2L3_Revenue__c + eachQdet.Total_Rev_FC__c : eachQdet.Total_Rev_FC__c); 
        */
		tempIncMsRec.BCT_IP_L0L0X_QtrActualsRev__c =(tempIncMsRec.BCT_IP_L0L0X_QtrActualsRev__c != null ? tempIncMsRec.BCT_IP_L0L0X_QtrActualsRev__c + eachQdet.BCTIP_L0_L0_X_Monthly_Actual_Rev__c : eachQdet.BCTIP_L0_L0_X_Monthly_Actual_Rev__c);  
        tempIncMsRec.BCTIP_L1_Qtr_Rev__c =(tempIncMsRec.BCTIP_L1_Qtr_Rev__c != null ? tempIncMsRec.BCTIP_L1_Qtr_Rev__c + eachQdet.BCT_IP_L1_Monthly_WAvg_Rev__c : eachQdet.BCT_IP_L1_Monthly_WAvg_Rev__c);
        tempIncMsRec.BCTIP_L2L3_QtrRev__c = (tempIncMsRec.BCTIP_L2L3_QtrRev__c != null ? tempIncMsRec.BCTIP_L2L3_QtrRev__c + eachQdet.BCT_IP_L2_L3_Monthly_Rev__c : eachQdet.BCT_IP_L2_L3_Monthly_Rev__c);
        
        tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c = (tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c != null ? tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c + eachQdet.BCT_Services_L0_L0X_Mon_Rev__c : eachQdet.BCT_Services_L0_L0X_Mon_Rev__c);
        tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c =(tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c != null ? tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + eachQdet.BCT_Services_L1_Mon_Rev__c : eachQdet.BCT_Services_L1_Mon_Rev__c);
        tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c = (tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c != null ? tempIncMsRec.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c + eachQdet.BCT_Services_L2_L3_Mon_Rev__c : eachQdet.BCT_Services_L2_L3_Mon_Rev__c);
        
        tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L0L0X__c = (tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L0L0X__c != null ? tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L0L0X__c + eachQdet.Existing_Contracts_L0L0_X_Mon_Rev__c : eachQdet.Existing_Contracts_L0L0_X_Mon_Rev__c);
        tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L1__c = (tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L1__c != null ? tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L1__c + eachQdet.Existing_Contracts_L1_Mon_Rev__c : eachQdet.Existing_Contracts_L1_Mon_Rev__c);
        tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L2L3__c =(tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L2L3__c != null ? tempIncMsRec.Rev_BCT_CF_Ent_Svcs_L2L3__c + eachQdet.Existing_Contracts_L2L3_Mon_Rev__c : eachQdet.Existing_Contracts_L2L3_Mon_Rev__c);
        
        tempIncMsRec.Rev_TIBCO_Pdt_License_L0L0X__c	= (tempIncMsRec.Rev_TIBCO_Pdt_License_L0L0X__c != null ? tempIncMsRec.Rev_TIBCO_Pdt_License_L0L0X__c + eachQdet.New_Logo_L0L0X_Mon_Rev__c : eachQdet.New_Logo_L0L0X_Mon_Rev__c);
        tempIncMsRec.Rev_TIBCO_Pdt_License_L1__c = (tempIncMsRec.Rev_TIBCO_Pdt_License_L1__c != null ? tempIncMsRec.Rev_TIBCO_Pdt_License_L1__c + eachQdet.New_Logo_L1_Mon_Rev__c : eachQdet.New_Logo_L1_Mon_Rev__c);	
        tempIncMsRec.Rev_TIBCO_Pdt_License_L2L3__c = (tempIncMsRec.Rev_TIBCO_Pdt_License_L2L3__c != null ? tempIncMsRec.Rev_TIBCO_Pdt_License_L2L3__c + eachQdet.New_Logo_L2L3_Mon_Rev__c : eachQdet.New_Logo_L2L3_Mon_Rev__c); 
        
        tempIncMsRec.PSvc_L0L0X_Qtr_Rev__c	= (tempIncMsRec.PSvc_L0L0X_Qtr_Rev__c != null ? tempIncMsRec.PSvc_L0L0X_Qtr_Rev__c + eachQdet.PSvc_L0L0X_Mon_Rev__c : eachQdet.PSvc_L0L0X_Mon_Rev__c); 
        tempIncMsRec.PSvc_L1_Qtr_Rev__c	= (tempIncMsRec.PSvc_L1_Qtr_Rev__c != null ? tempIncMsRec.PSvc_L1_Qtr_Rev__c + eachQdet.PSvc_L1_Mon_Rev__c : eachQdet.PSvc_L1_Mon_Rev__c);
        tempIncMsRec.PSvc_L2L3_Qtr_Rev__c = (tempIncMsRec.PSvc_L2L3_Qtr_Rev__c != null ? tempIncMsRec.PSvc_L2L3_Qtr_Rev__c + eachQdet.PSvc_L2L3_Mon_Rev__c : eachQdet.PSvc_L2L3_Mon_Rev__c);
        
        tempIncMsRec.SI_Products_L0L0X_Qtr_Rev__c = (tempIncMsRec.SI_Products_L0L0X_Qtr_Rev__c != null ? tempIncMsRec.SI_Products_L0L0X_Qtr_Rev__c + eachQdet.SI_Products_L0_L0_X_Mon_Rev__c : eachQdet.SI_Products_L0_L0_X_Mon_Rev__c);
        tempIncMsRec.SI_Products_L1_Qtr_Rev__c	= (tempIncMsRec.SI_Products_L1_Qtr_Rev__c != null ? tempIncMsRec.SI_Products_L1_Qtr_Rev__c + eachQdet.SI_Products_L1_Mon_Rev__c : eachQdet.SI_Products_L1_Mon_Rev__c); 
        tempIncMsRec.SI_Products_L2L3_Qtr_Rev__c = (tempIncMsRec.SI_Products_L2L3_Qtr_Rev__c != null ? tempIncMsRec.SI_Products_L2L3_Qtr_Rev__c + eachQdet.SI_Products_L2L3_Mon_Rev__c : eachQdet.SI_Products_L2L3_Mon_Rev__c); 
            	
      
        
        if(Qtr == 1 && null == tempIncMsRec.Incentive_Start_Period__c){
                         startdt =  Date.newInstance(getFy(Qtr), 4, 1);
                         tempIncMsRec.Incentive_Start_Period__c = eachQdet.Quota_Date__c;
                  		 tempIncMsRec.incentive_Quarter__c =1;
            
                	}else if (Qtr == 2 && null == tempIncMsRec.Incentive_Start_Period__c){
  						startdt =  Date.newInstance(getFy(Qtr), 7, 1);
             			tempIncMsRec.Incentive_Start_Period__c = eachQdet.Quota_Date__c;
            			tempIncMsRec.incentive_Quarter__c =2;
                	}else if(Qtr == 3 && null == tempIncMsRec.Incentive_Start_Period__c){
            			startdt =  Date.newInstance(getFy(Qtr), 10, 1);
             			tempIncMsRec.Incentive_Start_Period__c = eachQdet.Quota_Date__c;
                    	tempIncMsRec.incentive_Quarter__c =3;
                	}else if( Qtr == 4 && null == tempIncMsRec.Incentive_Start_Period__c){
                		startdt =  Date.newInstance(getFy(Qtr), 1, 1);
                 		tempIncMsRec.Incentive_Start_Period__c = eachQdet.Quota_Date__c;
                        tempIncMsRec.incentive_Quarter__c =4;
                }
        		
        		//tempIncMsRec = workoutIncentiveForUsrnQtrWise(tempIncMsRec, Qtr);
         	//system.debug('Returning from populateIncentive : ' + tempIncMsRec );
         	
         	return tempIncMsRec;
        
    }
    
    // This method calculates the incentive for a user for a qtr based on the revenue's incetive category 
    // Incentive calculated from the incentive shceme provided by the management
    public Incentive_Master__c workoutIncentiveForUsrQtrWise(Incentive_Master__c insmstrObj, integer qtr, boolean tgtAchieved, String achieveRangeCode, String L1TgtRangeCode, String L2L3TgtRangeCode){
      //incentiveSchemeMap
	  
	  
      system.debug('achieveRangeCode : ' + achieveRangeCode + '  L1TgtRangeCode  : '+ L1TgtRangeCode  + '  L2L3TgtRangeCode  : '+ L2L3TgtRangeCode);
         if(!achieveRangeCode.equalsIgnoreCase('LESS30')){
           System.debug('Achievement code for L0L0X funnel : ' + achieveRangeCode  +  '   Incentive Scheme multiplier (BCTIPEXECUTIVE):   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode));
            
            insmstrObj.Incentive_BCT_IP__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode) * (insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c / 100);
            insmstrObj.Incentive_SI_Products__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.SI_Products_L0L0X_Qtr_Rev__c / 100);
            insmstrObj.Incentive_ProfSvcs__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(achieveRangeCode) * (insmstrObj.PSvc_L0L0X_Qtr_Rev__c / 100);
            
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c / 100);
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c / 100);
			insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c / 100);
			
			//insmstrObj.Incentive_BCT_Services__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.BCT_Svcs_L0L0X_Qtr_Rev__c / 100);
            //insmstrObj.Incentive_ExistingContract__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Ext_Contracts_L0L0X_Qtr_Rev__c / 100);
            
			system.debug('L0L0X Incentive Quarter wise : ' + qtr + '  Incentive_BCT_IP__c : ' + insmstrObj.Incentive_BCT_IP__c + '  Incentive_SI_Products__c  : '+ insmstrObj.Incentive_SI_Products__c  + '  Incentive_ProfSvcs__c  : '+ insmstrObj.Incentive_ProfSvcs__c+ '  Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c  : '+ insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c+ '  Incen_BCT_CF_Ent_Svcs_L0L0X__c  : '+ insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c+ '  Incen_TIBCO_Pdt_License_L0L0X__c  : '+ insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c);
			
            insmstrObj.Yearly_IP_Incentive__c = 0;
            insmstrObj.Yearly_Net_New_Business_Incentive__c = 0;
      	  
        }else{
            insmstrObj.Incentive_BCT_IP__c = 0;
            insmstrObj.Incentive_SI_Products__c =0;
            insmstrObj.Incentive_ProfSvcs__c =0;
            
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c = 0;
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c = 0;
			insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c = 0;
			
			 //insmstrObj.Yearly_IP_Incentive__c =0;
            //insmstrObj.Yearly_Net_New_Business_Incentive__c = 0;
        }
        
        if(!L1TgtRangeCode.equalsIgnoreCase('LESS30')){
			System.debug('Achievement code along with L1 funnel : ' + L1TgtRangeCode  +  '   Incentive Scheme multiplier(BCTIPEXECUTIVE) :   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L1TgtRangeCode));
           
			system.debug('BCT_IP_L0L0X_QtrActualsRev__c : ' + insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + ' BCTIP_L1_Qtr_Rev__c  : '+ insmstrObj.BCTIP_L1_Qtr_Rev__c  );
			
            insmstrObj.Incentive_BCT_IP_L1__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + insmstrObj.BCTIP_L1_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_SI_Products_L1__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.SI_Products_L0L0X_Qtr_Rev__c+ insmstrObj.SI_Products_L1_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_ProfSvcs_L1__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.PSvc_L0L0X_Qtr_Rev__c + insmstrObj.PSvc_L1_Qtr_Rev__c )/ 100);
			
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c  = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c )/ 100);
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L1__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c + insmstrObj.Rev_BCT_CF_Ent_Svcs_L1__c) / 100);
			insmstrObj.Incen_TIBCO_Pdt_License_L1__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c + insmstrObj.Rev_TIBCO_Pdt_License_L1__c )/ 100);
			
			system.debug('L1 Incentive Quarter wise: ' + qtr + '  Incentive_BCT_IP_L1__c : ' + insmstrObj.Incentive_BCT_IP_L1__c + '  Incentive_SI_Products_L1__c  : '+ insmstrObj.Incentive_SI_Products_L1__c  + '  Incentive_ProfSvcs_L1__c  : '+ insmstrObj.Incentive_ProfSvcs_L1__c+ '  Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c  : '+ insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c+ '  Incen_BCT_CF_Ent_Svcs_L1__c  : '+ insmstrObj.Incen_BCT_CF_Ent_Svcs_L1__c+ '  Incen_TIBCO_Pdt_License_L1__c  : '+ insmstrObj.Incen_TIBCO_Pdt_License_L1__c);
            }else{
			
			insmstrObj.Incentive_BCT_IP_L1__c = 0;
            insmstrObj.Incentive_SI_Products_L1__c = 0;
            insmstrObj.Incentive_ProfSvcs_L1__c = 0;
			
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c = 0;
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L1__c = 0;
			insmstrObj.Incen_TIBCO_Pdt_License_L1__c = 0;
			
			
			}
        
        if(!L2L3TgtRangeCode.equalsIgnoreCase('LESS30')){
			System.debug('Achievement code along with L2 L3 funnel : ' + L2L3TgtRangeCode  +  '   Incentive Scheme multiplier(BCTIPEXECUTIVE) :   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L2L3TgtRangeCode));
			
			system.debug('BCT_IP_L0L0X_QtrActualsRev : ' + insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + ' BCTIP_L1_Qtr_Rev :  '+ insmstrObj.BCTIP_L1_Qtr_Rev__c + 'BCTIP_L2L3_QtrRev__c : ' + insmstrObj.BCTIP_L2L3_QtrRev__c );
		
            insmstrObj.Incentive_BCT_IP_L2_L3__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + insmstrObj.BCTIP_L1_Qtr_Rev__c + insmstrObj.BCTIP_L2L3_QtrRev__c) / 100);
            insmstrObj.Incentive_SI_Products_L2_L3__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(L2L3TgtRangeCode) *((insmstrObj.SI_Products_L0L0X_Qtr_Rev__c+ insmstrObj.SI_Products_L1_Qtr_Rev__c + insmstrObj.SI_Products_L2L3_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_ProfSvcs_L2_L3__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.PSvc_L0L0X_Qtr_Rev__c + insmstrObj.PSvc_L1_Qtr_Rev__c + insmstrObj.PSvc_L2L3_Qtr_Rev__c) / 100);
			
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c )/ 100);
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c + insmstrObj.Rev_BCT_CF_Ent_Svcs_L1__c + insmstrObj.Rev_BCT_CF_Ent_Svcs_L2L3__c)/ 100);
			insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c + insmstrObj.Rev_TIBCO_Pdt_License_L1__c + insmstrObj.Rev_TIBCO_Pdt_License_L2L3__c ) / 100);
           
		    system.debug('L2L3 Incentive Quarter : ' + qtr + '  Incentive_BCT_IP_L2_L3__c : ' + insmstrObj.Incentive_BCT_IP_L2_L3__c + '  Incentive_SI_Products_L2_L3__c  : '+ insmstrObj.Incentive_SI_Products_L2_L3__c  + '  Incentive_ProfSvcs_L2_L3__c  : '+ insmstrObj.Incentive_ProfSvcs_L2_L3__c+ '  Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c  : '+ insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c+ '  Incen_BCT_CF_Ent_Svcs_L2L3__c  : '+ insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c+ '  Incen_TIBCO_Pdt_License_L2L3__c  : '+ insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c);
			
        }else{
			insmstrObj.Incentive_BCT_IP_L2_L3__c = 0;
            insmstrObj.Incentive_SI_Products_L2_L3__c = 0;
            insmstrObj.Incentive_ProfSvcs_L2_L3__c = 0;
			
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c = 0;
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c = 0;
			insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c = 0;
           
		}
		system.debug('insmstrObj.Overall_Acheived__c : ' + insmstrObj.Overall_Acheived__c);
		if(insmstrObj.Overall_Acheived__c < 100){
		system.debug('Quarterly Qverall Quota  : ' + insmstrObj.Quarterly_Overall_Quota__c);
		system.debug('Quarterly Qverall Actual  : ' + insmstrObj.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c);
		
		decimal quotaVarianceL0L0X = insmstrObj.Quarterly_Overall_Quota__c - insmstrObj.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
		system.debug('quotaVarianceL0L0X : ' + quotaVarianceL0L0X);
		system.debug('Quarterly IP Quota  : ' + insmstrObj.Quarterly_IP_Quota__c);
		decimal minusIPQuota  = quotaVarianceL0L0X - insmstrObj.Quarterly_IP_Quota__c;
		system.debug('minusIPQuota : ' + minusIPQuota);
		if(minusIPQuota > 0 ){
			system.debug('BCT_IP_L0L0X_QtrActualsRev__c  : ' + insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c);
				insmstrObj.Incen_SIM_BCT_IP_L0L0_X__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get('R91TO100') * (insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c / 100);
				system.debug('SI_Products_L0L0X_Qtr_Rev__c  : ' + insmstrObj.SI_Products_L0L0X_Qtr_Rev__c);
				insmstrObj.Incen_SIM_SI_Product_L0L0_X__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get('R91TO100') * (insmstrObj.SI_Products_L0L0X_Qtr_Rev__c / 100);
				system.debug('PSvc_L0L0X_Qtr_Rev__c  : ' + insmstrObj.PSvc_L0L0X_Qtr_Rev__c);
				insmstrObj.Incen_SIM_Prof_Svcs_L0L0_X__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get('R91TO100') * (insmstrObj.PSvc_L0L0X_Qtr_Rev__c / 100);
				
				system.debug('Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c  : ' + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c);				
				insmstrObj.Incen_SIM_BCT_Aprvd_Dig_TIBCO_Svcs_L0L0X__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get('R91TO100') * ((insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c + minusIPQuota)  / 100);
				system.debug('Rev_BCT_CF_Ent_Svcs_L0L0X__c  : ' + insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c);
				insmstrObj.Incen_SIM_BCT_CF_Ent_Svcs_L0L0_X__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get('R91TO100') * (insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c / 100);
				system.debug('Rev_TIBCO_Pdt_License_L0L0X__c  : ' + insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c);
				insmstrObj.Incen_SIM_TIBCO_Pdt_Lic_L0L0_X__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get('R91TO100') * (insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c / 100);
		  }else{
				insmstrObj.Incen_SIM_BCT_IP_L0L0_X__c = insmstrObj.Incentive_BCT_IP__c;
				insmstrObj.Incen_SIM_SI_Product_L0L0_X__c =  insmstrObj.Incentive_SI_Products__c;
				insmstrObj.Incen_SIM_Prof_Svcs_L0L0_X__c = insmstrObj.Incentive_ProfSvcs__c;
				
				insmstrObj.Incen_SIM_BCT_Aprvd_Dig_TIBCO_Svcs_L0L0X__c = insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c;
				insmstrObj.Incen_SIM_BCT_CF_Ent_Svcs_L0L0_X__c = insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c;
				insmstrObj.Incen_SIM_TIBCO_Pdt_Lic_L0L0_X__c = insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c;
			}
		
	
		}
		
		
		
		system.debug('END -->  ' + insmstrObj );
		system.debug('END -->  ' + qtr );
        return insmstrObj;
    }
    
    
    public integer getQuarter(integer mon){
        
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
    
    public integer getFy(integer qtr){
        if(qtr > 3){
            return currYear + 1;
        }else{
            return currYear;
        }
    }
}