/*
 * Class Name : IncentiveProcessorMonthlyEngine.apex
 * Description : This process is made to run on daily basis to get the updated revenue and the incentive details on a daily basis.
 * This process collects the calculated incentive from Incentive Master obj and new revenues from quota details obj , recalculates the incentive 
 * and compares with the old incentive rows from Incentive master and updates it. If rows not found then the code understands its a new entries and inserts
 * it in Incentive master 
 */ 

public class IncentiveProcessorMonthlyEngine {
   
  public Map<id, List<QuotaDetail__c>> ownerToQuotaDetailsMap;
   public list<QuotaDetail__c> qDetToUpdate = new List<QuotaDetail__c>();
   public List<QuotaDetail__c> qdets;
   public List<ID> existingOwnerIdsList = new List<ID>();
    
    Date currrDate = Date.today();
    Integer currMonth = currrDate.month();
  //  Integer currMonth = 12;
    Integer currYear =  currrDate.year();
    String fyPeriod;
    String startFY;
    String endFY;
    Integer prevMonth;
    List<Integer> incentiveMonths;
    
    public static String  SIPRODUCTSEXECUTIVE = 'SIProductsExecutive'; 	//SI Products 
    public static String  BCTIPEXECUTIVE = 'BCTIPExecutive'; 			//BCT IP
	public static String  PROFSERVICESEXECUTIVE = 'ProfServicesExecutive';  // Professional Services 	
	
	public static String  DIGITALTIBCOSVCSEXECUTIVE = 'BCTApprovedDigitalTIBCOServices';   //BCT approved Digital & TIBCO Services	
    public static String  CFENTSVCSEXECUTIVE = 'BCTCFEnterpriseServies'; 			//BCT C/F & Enterprise Servies
    public static String  TIBCOPRODUCTLICENSEEXECUTIVE = 'TIBCOProductLicenseExecutive'; 			//BCT IP 
    
	public static String  NEWLOGOEXECUTIVE = 'NewLogoExecutive'; 		//Not in this new changes
    
	
	
    public List<Incentive_Scheme__c> incScheme;
  	//Map<BCTServicesExecutive, Map<R31TO50, 0.15 Value>>
    public Map<String , Map<String, Decimal>> incentiveSchemeMap;
    
   
    public IncentiveProcessorMonthlyEngine(){
        system.debug('Running Monthly Incentive Processor');
       
        if(currMonth > 3 ){
            startFY = String.valueOf(currYear);
            endFY = String.valueOf(currYear + 1);
            
            system.debug('startFY   : ' + startFY);
            system.debug('endFY   : ' + endFY);
        }else{
            startFY = String.valueOf(currYear -1);
            endFY = String.valueOf(currYear);
              
            system.debug('startFY 1  : ' + startFY);
            system.debug('endFY  1 : ' + endFY);
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
        system.debug('Current month : ' + currMonth);
        system.debug('Prev  month : ' + prevMonth);
        system.debug('Curr  Year : ' + currYear);
        
        List<Integer> futureMonths = new List<Integer>();
        if(currMonth > 4 && currMonth <= 12 ){
              system.debug('Inside IF loop : ' + currMonth);
            for(integer i=currMonth + 1 ; i <= 12 ; i++){
                futureMonths.add(i);
                // system.debug('Future Months : ' + futureMonths);
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
		incentiveMonths.add(currMonth);
        incentiveMonths.add(prevMonth);
        for(Integer eachFutMon : futureMonths){
               incentiveMonths.add(eachFutMon);
        }
     	
        system.debug('Final Future Months : ' + futureMonths);
        system.debug('Final Incentive Months : ' + incentiveMonths);
      
        incScheme = [SELECT ID, IC_BUSINESS_CATEGORY__C, IC_REVENUE_STREAM__C, INCENTIVE_SCHEME_TYPE__C, R31TO50__C, R51TO75__C, R76TO90__C, R91TO100__C, R101TO110__C, R110PLUS__C, INCENTIVE_TERM__C, INCENTIVE_PERIOD__C FROM INCENTIVE_SCHEME__C WHERE INCENTIVE_PERIOD__C=:fyPeriod ];
        
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
        system.debug('Incentive Scheme Map : ' + incentiveSchemeMap);
        
        
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
    
    
    public void processMonthlyIncentive(){
       
        List<Incentive_Master__c> incmstr;
        List<QuotamasterNew__c> qmst;
        List<id> qmstIdList = new List<id>();
        
        String tempQPeriod = startFY +'-'+ endFY;
        
        system.debug('Quota Period in Process Incentive method : ' + tempQPeriod);
        system.debug('Quota Period for Incentive months : ' + incentiveMonths);
        List<integer> financialQtr;
         
        financialQtr = getQuarter(incentiveMonths);
		
        qdets = [SELECT Id, Quota_Amount__c, new_quota__c, Revised_L0L0XL1_Quota__c,Revised_L0L0XL1L2L3_Quota__c, Total_L0L0_X_AC_FCRev__c, Total_L0_L0_X_L1_AC_FC_Rev__c, QuotaMasterNew__c, IP_Actual_Revenue_Summary__c, Total_Rev_FC__c, BCT_Services_L0_L0X_Mon_Rev__c,BCT_Services_L1_Mon_Rev__c, BCT_Services_L2_L3_Mon_Rev__c, Existing_Contracts_L0L0_X_Mon_Rev__c,  Existing_Contracts_L1_Mon_Rev__c, Existing_Contracts_L2L3_Mon_Rev__c, New_Logo_L1_Mon_Rev__c, New_Logo_L0L0X_Mon_Rev__c, New_Logo_L2L3_Mon_Rev__c, QuotaMasterNew__r.Sales_Owner_Role__c, QuotaMasterNew__r.Quota_Owner_Name__c, QuotaMasterNew__r.SBU__c, QuotaMasterNew__r.Quota_Owner_Manager__c, Quota_Owner_Formula__c, QuotaMasterNew__r.Quota_Start_Period__c,QuotaMasterNew__r.Quota_Period__c, QuotaMasterNew__r.ownerId, Quota_Date__C, Quota_Variance__c, Revenue_Recognized_Amount__c, COE_Target__c, Huringa_Quota_by_product__c, product_Type_QDET__c, quota_month__c, quotayear__c, BCT_IP_L1_Monthly_WAvg_Rev__c, BCTIP_L0_L0_X_Monthly_Actual_Rev__c, BCT_IP_L2_L3_Monthly_Rev__c, PSvc_L0L0X_Mon_Rev__c, PSvc_L1_Mon_Rev__c, PSvc_L2L3_Mon_Rev__c, SI_Products_L0_L0_X_Mon_Rev__c, SI_Products_L1_Mon_Rev__c, SI_Products_L2L3_Mon_Rev__c FROM QuotaDetail__c where QuotaMasterNew__r.Quota_Period__c = :tempQPeriod and QuotaMasterNew__r.Product_Type__c='OVERALL' and Quota_Quarter__c in : financialQtr  ORDER BY QuotaMasterNew__r.ownerId];
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
            	calculateAndProcessIncentive();
         	}            
        }
    
    
    // Main method for process and calculate the incentive 
    private void calculateAndProcessIncentive(){
		List<Incentive_Master__c> incmstr;
        List<ID> ownerIdsList = new List<ID>();
        List<ID> newlyAddedOwnerList = new List<ID>();
        List<QuotaDetail__c> incentiveQtrQdet;
        List<Incentive_Master__c> incMasterExisting;
         system.debug('In calculateAndProcessIncentive Method');
       
        //Owner Key to Incentive master detail map used to link incentive master and quota detail object
        Map<String, Incentive_Master__c> ownerKeyToOldIncMstrRowMap = new Map<String, Incentive_Master__c>();
         
        List<integer> financialQtr;
         
         financialQtr = getQuarter(incentiveMonths);
         system.debug('Finanacial Quarter :' + financialQtr + ' --> '+fyPeriod +' owner list-->'+ existingOwnerIdsList);
         incMasterExisting = [SELECT ID, OwnerId, IncentiveMasterRowKey__c, Actual_Quota__c,Actual_Revenue_Recognized__c, Total_L0L0X_Revenue__c, BCT_IP_L0L0X_QtrActualsRev__c, BCTIP_L1_Qtr_Rev__c, BCTIP_L2L3_QtrRev__c, PSvc_L0L0X_Qtr_Rev__c, PSvc_L1_Qtr_Rev__c, PSvc_L2L3_Qtr_Rev__c, SI_Products_L0L0X_Qtr_Rev__c, SI_Products_L1_Qtr_Rev__c, SI_Products_L2L3_Qtr_Rev__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c, Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L0L0X__c, Rev_BCT_CF_Ent_Svcs_L1__c, Rev_BCT_CF_Ent_Svcs_L2L3__c, Rev_TIBCO_Pdt_License_L0L0X__c, Rev_TIBCO_Pdt_License_L1__c, Rev_TIBCO_Pdt_License_L2L3__c, Total_Rev_L0_L0X__c, Total_L1_Revenue__c, Total_L2L3_Revenue__c, Incentive_BCT_IP__c,Incentive_BCT_IP_L1__c, Incentive_BCT_IP_L2_L3__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c, Incen_BCT_Appd_Digi_TIBCO_Svcs_L1__c,Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c, Incen_BCT_CF_Ent_Svcs_L0L0X__c, Incen_BCT_CF_Ent_Svcs_L1__c, Incen_BCT_CF_Ent_Svcs_L2L3__c, Incen_TIBCO_Pdt_License_L0L0X__c, Incen_TIBCO_Pdt_License_L1__c, Incen_TIBCO_Pdt_License_L2L3__c, Incentive_ProfSvcs__c, Incentive_ProfSvcs_L1__c, Incentive_ProfSvcs_L2_L3__c, Incentive_SI_Products__c, Incentive_SI_Products_L1__c, Incentive_SI_Products_L2_L3__c, Incentive_Start_Period__c,Incentive_End_Period__c,  Quarterly_IP_Quota__c, Quarterly_Overall_Quota__c, Quota_Period__c, Sales_Owner_Name__c, SalesUserId__c, Sales_User_Manager__c, SBU__c from Incentive_Master__c where   ownerid in: existingOwnerIdsList and  incentive_Quarter__c  IN : financialQtr and Quota_Period__c = :fyPeriod  ORDER BY OwnerId];
         system.debug('incMasterExisting : ' + incMasterExisting);
         id prevOwner;
         for(Incentive_Master__c eachIncMstr : incMasterExisting){
             system.debug('eachIncMstr.IncentiveMasterRowKey__c : ' + eachIncMstr.IncentiveMasterRowKey__c);
             ownerKeyToOldIncMstrRowMap.put(eachIncMstr.IncentiveMasterRowKey__c, eachIncMstr);
                
         }
         
         system.debug('incentive Master to Owner Map : ' + ownerKeyToOldIncMstrRowMap);
         
         Map<String, Incentive_Master__c> ownerKeyToQdetRowMap = new Map<String, Incentive_Master__c>();
         Incentive_Master__c newQdetailForIncMasterQ1;
         Incentive_Master__c newQdetailForIncMasterQ2;
         Incentive_Master__c newQdetailForIncMasterQ3;
         Incentive_Master__c newQdetailForIncMasterQ4;
         
        // convert qdetails monthly to quarterly   by owner basis 
		// Key - OwnerId + SBU + <QtrNo> + Quota Period
		//Outer loop to group by each owner(From Quota detail object) and inner forloop to group 4 qtrly revenues and incentives
         for (id eachOwnerQdetail : ownerToQuotaDetailsMap.keySet()){
             String tempOwnerId = String.valueOf(eachOwnerQdetail);
             String modifiedOwnerId = tempOwnerId.substring(0, tempOwnerId.length()-3);
			            	
             newQdetailForIncMasterQ1 = new Incentive_Master__c();
             newQdetailForIncMasterQ2 = new Incentive_Master__c();
             newQdetailForIncMasterQ3 = new Incentive_Master__c();
             newQdetailForIncMasterQ4 = new Incentive_Master__c();
             //Form Quota detail to Incetive master key - Owner Id + SBU + Quota Number + Quota Period
             // Sample Key 000HEAWxyER102101-IND12017-2018
			 // Constructing Incentive Master Object row from Quota Details Object value and it will be compared with its corresponding existing Incentive Master object rows for updating with updated values.
            for(QuotaDetail__c eachQdet : ownerToQuotaDetailsMap.get(eachOwnerQdetail)){
                Incentive_Master__c eachIncMasterQdetPerQtr = new Incentive_Master__c();
                Integer tempQtr = getQuarterNumber(Integer.valueOf(eachQdet.Quota_Month__c));
                if(tempQtr == 1){
                	newQdetailForIncMasterQ1 = populateIncentive(eachQdet, tempQtr, newQdetailForIncMasterQ1);
                    String tempQdtRowkey1 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 1 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                     ownerKeyToQdetRowMap.put(tempQdtRowkey1, newQdetailForIncMasterQ1);
                }else if(tempQtr == 2){
                    newQdetailForIncMasterQ2 = populateIncentive(eachQdet, tempQtr, newQdetailForIncMasterQ2);
                     String tempQdtRowkey2 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 2 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                     ownerKeyToQdetRowMap.put(tempQdtRowkey2, newQdetailForIncMasterQ2);
                }else if(tempQtr == 3){
                    newQdetailForIncMasterQ3 = populateIncentive(eachQdet, tempQtr, newQdetailForIncMasterQ3);    
                     String tempQdtRowkey3 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 3 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQdetRowMap.put(tempQdtRowkey3, newQdetailForIncMasterQ3);
                }else if(tempQtr == 4){
                    newQdetailForIncMasterQ4 = populateIncentive(eachQdet, tempQtr, newQdetailForIncMasterQ4); 
                     String tempQdtRowkey4 = modifiedOwnerId + eachQdet.QuotaMasterNew__r.SBU__c + 4 + eachQdet.QuotaMasterNew__r.Quota_Period__c;
                    ownerKeyToQdetRowMap.put(tempQdtRowkey4, newQdetailForIncMasterQ4);
                }
             }
             
         }//End of outer loop of Qdetails
           system.debug('Owner To Incentive from Qdet b4 Inc calculation Map : ' + ownerKeyToQdetRowMap);
        // This map variable will have the incentivekey to incentive details row map obtained or converted from Quota details object per quarter wise.
         Map<String, Incentive_Master__c> newOwnerKeyToQdetRowMap = new Map<String, Incentive_Master__c>();
		//This is for Calculating incentive forecast for L1 L2 L3 opportunities.

			 // Quarterly_Overall_Quota__c - Inc Master obj -  Quarterly Revised quota for L0 L0-X. This is the variable quota for LOL0-X addded with with slippage of L0 L0-X revenues.
			 // New_Quota__c  - In Quota Detail obj. This field is used to hold variable quota for L0L0-X slippage revenues.
			 // Quota_L0L0XL1_Revised__c  -In Inc Master Obj - This quota is the revised quota for L0+L0-X+L1 slipage revenues
			 // Quota_L0L0XL1L2L3_Revised__c - In Inc Master Obj - This quota is the revised quota for L0+L0-X+L1+L2+L3 slipage revenues
			 // L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c
			 // L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c Total_L0L0XL1_Revenue__c -  IncMstr Obj field - sum of L0L0XL1 qtrly rev  populated from Qdet object 
			 // L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c Total_L0L0XL1L2L3_Revenue__c - IncMstr Obj field - sum of L0L0XL1L2L3 qtrly rev  populated from Qdet object 
			 		 
         
        for(String eachQtrDetInckey : ownerKeyToQdetRowMap.keySet()){
            
             	 	Incentive_Master__c eachQdetForIncCalcPerQtr = ownerKeyToQdetRowMap.get(eachQtrDetInckey);
                    system.debug('Quarter Number : ' + eachQdetForIncCalcPerQtr.Incentive_Quarter__c);
					system.debug('each eachQtrDetInckey quarter Overall Quota : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c);
                    system.debug('each quarter Overall Actual : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Actual__c);
					
            
             if(eachQdetForIncCalcPerQtr.Incentive_Quarter__c == 1)
             {
			    system.debug('START --> Q1');
				system.debug('Q1 L0L0X Quota : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c);
				system.debug('Q1 L0L0X Revenue from Map : ' + eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  newQdetailForIncMasterQ1 L0L0XL1L2L3 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
   			  
				Decimal tempRevL0 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL1 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL2L3 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
				decimal tempQtlyAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c) * 100 : (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
				decimal tempQtlyL1AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                decimal tempQtlyL2L3AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c != 0) ? ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) / eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
				
				system.debug('Q1 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  Q1 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  Q1 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
                   
				 eachQdetForIncCalcPerQtr.Overall_IP_Actual__c = (null != eachQdetForIncCalcPerQtr.Overall_IP_Actual__c ? eachQdetForIncCalcPerQtr.Overall_IP_Actual__c : 0);
              // For Projection purpose we use BCTIP Forecast Revenue and actual revenue recognised for IP produts field.
                 decimal tempQtlyIPAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c != 0) ? ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c) * 100 : ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c)/ 1)*100 );

				newQdetailForIncMasterQ1.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				newQdetailForIncMasterQ1.Overall_Acheived__c = tempQtlyAchievementPercentage;
                Boolean isTgtAchieved = (tempQtlyAchievementPercentage > 30 ? true : false );
         
				newQdetailForIncMasterQ1.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
				newQdetailForIncMasterQ1.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
				newQdetailForIncMasterQ1.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
				
                newQdetailForIncMasterQ1 = workoutIncentiveForUsrQtrWise(eachQdetForIncCalcPerQtr, 0, isTgtAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));  
                newOwnerKeyToQdetRowMap.put(eachQtrDetInckey, newQdetailForIncMasterQ1);
             
			 }else if(eachQdetForIncCalcPerQtr.Incentive_Quarter__c == 2){
				system.debug('START --> Q2');
				system.debug('Q2 L0L0X Quota : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c);
				system.debug('Q2 L0L0X Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
   			  
			  
				Decimal tempRevL0 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL1 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL2L3 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
				decimal tempQtlyAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c) * 100 : (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
				decimal tempQtlyL1AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                decimal tempQtlyL2L3AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c != 0) ? ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) / eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
				
				system.debug('Q2 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  Q2 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  Q2 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
            
				eachQdetForIncCalcPerQtr.Overall_IP_Actual__c = (null != eachQdetForIncCalcPerQtr.Overall_IP_Actual__c ? eachQdetForIncCalcPerQtr.Overall_IP_Actual__c : 0);
                decimal tempQtlyIPAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c != 0) ? ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c) * 100 : ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / 1)*100 );
                
				system.debug('Q2 Overall achieved percentage : ' + tempQtlyAchievementPercentage +'  IP achieved : '+ tempQtlyIPAchievementPercentage);
				newQdetailForIncMasterQ2.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				newQdetailForIncMasterQ2.Overall_Acheived__c = tempQtlyAchievementPercentage;
                 
                Boolean isTgtAchieved = (tempQtlyAchievementPercentage > 30 ? true : false );
				
				newQdetailForIncMasterQ2.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
				newQdetailForIncMasterQ2.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
				newQdetailForIncMasterQ2.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
				
                newQdetailForIncMasterQ2 = workoutIncentiveForUsrQtrWise(eachQdetForIncCalcPerQtr, 0, isTgtAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));  
                newOwnerKeyToQdetRowMap.put(eachQtrDetInckey, newQdetailForIncMasterQ2);
				
             }else if(eachQdetForIncCalcPerQtr.Incentive_Quarter__c == 3){
				 
				system.debug('START --> Q3');
				system.debug('Q3 L0L0X Quota : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c);
				system.debug('Q3 L0L0X Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
   			  

			    Decimal tempRevL0 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL1 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL2L3 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
				decimal tempQtlyAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c) * 100 : (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
				decimal tempQtlyL1AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                decimal tempQtlyL2L3AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c != 0) ? ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) / eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
				
				system.debug('Q3 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  Q3 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  Q3 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
                
				eachQdetForIncCalcPerQtr.Overall_IP_Actual__c = (null != eachQdetForIncCalcPerQtr.Overall_IP_Actual__c ? eachQdetForIncCalcPerQtr.Overall_IP_Actual__c : 0);
                 // For Projection purpose we use BCTIP Forecast Revenue and actual revenue recognised for IP produts field.
                decimal tempQtlyIPAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c != 0) ? ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c) * 100 : ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / 1)*100 ); 

				newQdetailForIncMasterQ3.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				newQdetailForIncMasterQ3.Overall_Acheived__c = tempQtlyAchievementPercentage;
                 
                Boolean isTgtAchieved = (tempQtlyAchievementPercentage > 30 ? true : false );
				
				newQdetailForIncMasterQ3.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
				newQdetailForIncMasterQ3.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
				newQdetailForIncMasterQ3.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
				 
                newQdetailForIncMasterQ3 = workoutIncentiveForUsrQtrWise(eachQdetForIncCalcPerQtr, 0, isTgtAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));  
                newOwnerKeyToQdetRowMap.put(eachQtrDetInckey, newQdetailForIncMasterQ3);
             }else if(eachQdetForIncCalcPerQtr.Incentive_Quarter__c == 4){
				 
				system.debug('START --> Q4');
				system.debug('Q4 L0L0X Quota : ' + eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Quota : ' + eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c);
				system.debug('Q4 L0L0X Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  eachQdetForIncCalcPerQtr L0L0XL1L2L3 Revenue : ' + eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
   			  
			    Decimal tempRevL0 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL1 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c;
				Decimal tempRevL2L3 =  (null == eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c || eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c ==0) ? 1 :  eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c;
				  
				decimal tempQtlyAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quarterly_Overall_Quota__c) * 100 : (eachQdetForIncCalcPerQtr.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c /tempRevL0 )*100);
				decimal tempQtlyL1AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c != 0) ? (eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / eachQdetForIncCalcPerQtr.Quota_L0L0XL1_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c) /tempRevL1 )*100);
                decimal tempQtlyL2L3AchvePerc = ((null != eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c && eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c != 0) ? ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) / eachQdetForIncCalcPerQtr.Quota_L0L0XL1L2L3_Revised__c) * 100 : ((eachQdetForIncCalcPerQtr.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c) /tempRevL2L3 )*100);
				
				system.debug('Q4 L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  Q4 L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  Q4 L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
                
				eachQdetForIncCalcPerQtr.Overall_IP_Actual__c = (null != eachQdetForIncCalcPerQtr.Overall_IP_Actual__c ? eachQdetForIncCalcPerQtr.Overall_IP_Actual__c : 0);
                decimal tempQtlyIPAchievementPercentage = ((null != eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c && eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c != 0) ? ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / eachQdetForIncCalcPerQtr.Quarterly_IP_Quota__c) * 100 : ((eachQdetForIncCalcPerQtr.BCT_IP_L0L0X_QtrActualsRev__c + eachQdetForIncCalcPerQtr.BCTIP_L1_Qtr_Rev__c + eachQdetForIncCalcPerQtr.BCTIP_L2L3_QtrRev__c) / 1)*100 );
                
				newQdetailForIncMasterQ4.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				newQdetailForIncMasterQ4.Overall_Acheived__c = tempQtlyAchievementPercentage;
                
                Boolean isTgtAchieved = (tempQtlyAchievementPercentage > 30 ? true : false );
				newQdetailForIncMasterQ4.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
				newQdetailForIncMasterQ4.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
				newQdetailForIncMasterQ4.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
                
				newQdetailForIncMasterQ4 = workoutIncentiveForUsrQtrWise(eachQdetForIncCalcPerQtr, 0, isTgtAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));  
                newOwnerKeyToQdetRowMap.put(eachQtrDetInckey, newQdetailForIncMasterQ4);
              }
            }
         system.debug('New OwnerKey To Qdetail Row Map with updated incentives :  ' + newOwnerKeyToQdetRowMap);
   		//TODO : Incentive Master Replicated with udpated data from quota detail. Now to compare the updated map with the existing incentive master and map the new incentive and revenue details.
   		
   		//newOwnerKeyToQdetRowMap - Quota Detail map with udpated incentive master details
       //ownerKeyToOldIncMstrRowMap - Existing Incentive Master details 
       
        List<Incentive_Master__c> finalListToUpdateIncMstr = new List<Incentive_Master__c>();
		 List<Incentive_Master__c> newIncentiveMasterRecordToInsert = new List<Incentive_Master__c>();
        for(String eachExistIncMasRow : ownerKeyToOldIncMstrRowMap.keySet() ){
            system.debug('Comparing New OwnerKey To Qdet Row Map for existing Inc Master Key :  ' + eachExistIncMasRow);
            system.debug('Comparing New OwnerKey To Qdet Row Map for existing Inc Master Map :  ' + newOwnerKeyToQdetRowMap);
            system.debug('Comparing New OwnerKey To Qdet Row Map for existing Inc Master value :  ' + newOwnerKeyToQdetRowMap.get(eachExistIncMasRow));
           if(newOwnerKeyToQdetRowMap.get(eachExistIncMasRow) != null){
                System.debug('Owner Keyyyyy : ' + ownerKeyToOldIncMstrRowMap.get(eachExistIncMasRow).Id); 
               // Incentive_Master__c IncmasterToUpdate =  newOwnerKeyToQdetRowMap.get(eachExistIncMasRow);
                // IncmasterToUpdate.id = ownerKeyToOldIncMstrRowMap.get(eachExistIncMasRow).Id;
				system.debug('Old Incentive Values : ' + ownerKeyToOldIncMstrRowMap.get(eachExistIncMasRow));
				system.debug('New Incentive Values : ' + newOwnerKeyToQdetRowMap.get(eachExistIncMasRow));
				
				Incentive_Master__c IncmasterToUpdate = compareNPrepareUpdatedIncMaster(newOwnerKeyToQdetRowMap.get(eachExistIncMasRow), ownerKeyToOldIncMstrRowMap.get(eachExistIncMasRow));
				
				// Recalculate the Incetive for the new revenue
				
				system.debug('RECALCULATING ACHIEVED PERCENTAGE');
				system.debug('L0L0X Quota : ' + IncmasterToUpdate.Quarterly_Overall_Quota__c + '  IncmasterToUpdate L0L0XL1 Quota : ' + IncmasterToUpdate.Quota_L0L0XL1_Revised__c + '  IncmasterToUpdate L0L0XL1L2L3 Quota : ' + IncmasterToUpdate.Quota_L0L0XL1L2L3_Revised__c);
				system.debug('L0L0X Revenue : ' + IncmasterToUpdate.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + '  IncmasterToUpdate L0L0XL1 Revenue : ' + IncmasterToUpdate.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + '  IncmasterToUpdate L0L0XL1L2L3 Revenue : ' + IncmasterToUpdate.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c);
   			  
				decimal tempQtlyAchievementPercentage = (null != IncmasterToUpdate.Quarterly_Overall_Quota__c && IncmasterToUpdate.Quarterly_Overall_Quota__c != 0 ? (IncmasterToUpdate.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / IncmasterToUpdate.Quarterly_Overall_Quota__c) * 100 : (IncmasterToUpdate.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c / 1)*100);
                decimal tempQtlyL1AchvePerc = ((null != IncmasterToUpdate.Quota_L0L0XL1_Revised__c && IncmasterToUpdate.Quota_L0L0XL1_Revised__c != 0) ? (IncmasterToUpdate.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c / IncmasterToUpdate.Quota_L0L0XL1_Revised__c) * 100 : (IncmasterToUpdate.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c /1 )*100);
                decimal tempQtlyL2L3AchvePerc = ((null != IncmasterToUpdate.Quota_L0L0XL1L2L3_Revised__c && IncmasterToUpdate.Quota_L0L0XL1L2L3_Revised__c != 0) ? (IncmasterToUpdate.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c / IncmasterToUpdate.Quota_L0L0XL1L2L3_Revised__c) * 100 : (IncmasterToUpdate.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c /1 )*100);  	
				
				system.debug('L0L0X Achieved % : ' + tempQtlyAchievementPercentage + '  	L0L0XL1 Achieved % : ' + tempQtlyL1AchvePerc + '  	L0L0XL1L2L3 Achieved % : ' + tempQtlyL2L3AchvePerc);
                
				
				IncmasterToUpdate.Overall_IP_Actual__c = (null != IncmasterToUpdate.Overall_IP_Actual__c ? IncmasterToUpdate.Overall_IP_Actual__c : 0);
                decimal tempQtlyIPAchievementPercentage = ((null != IncmasterToUpdate.Quarterly_IP_Quota__c && IncmasterToUpdate.Quarterly_IP_Quota__c != 0) ? ((IncmasterToUpdate.BCT_IP_L0L0X_QtrActualsRev__c + IncmasterToUpdate.BCTIP_L1_Qtr_Rev__c + IncmasterToUpdate.BCTIP_L2L3_QtrRev__c) / IncmasterToUpdate.Quarterly_IP_Quota__c) * 100 : ((IncmasterToUpdate.BCT_IP_L0L0X_QtrActualsRev__c + IncmasterToUpdate.BCTIP_L1_Qtr_Rev__c + IncmasterToUpdate.BCTIP_L2L3_QtrRev__c) / 1)*100 );
                  
				 
				 
				IncmasterToUpdate.IP_Target_Achieved__c = tempQtlyIPAchievementPercentage;
				IncmasterToUpdate.Overall_Acheived__c = tempQtlyAchievementPercentage;
                system.debug('Q4 Overall achieved % : ' + tempQtlyAchievementPercentage +'  IP achieved % : '+ tempQtlyIPAchievementPercentage);
				system.debug('tempQtlyL1AchvePerc : ' + tempQtlyL1AchvePerc  +'  tempQtlyL2L3AchvePerc : '+ tempQtlyL2L3AchvePerc);
                Boolean isTgtAchieved = (tempQtlyAchievementPercentage > 30 ? true : false );
				
				IncmasterToUpdate.Achieved_Percent_L0_L0_X__c = tempQtlyAchievementPercentage;
				IncmasterToUpdate.Achieved_Percent_L0_L0_X_L1__c = tempQtlyL1AchvePerc;
				IncmasterToUpdate.Achieved_Percent_L0_L0_X_L1_L2_L3__c = tempQtlyL2L3AchvePerc;
				
				system.debug('RECALCULATING INCENTIVE AMOUNT');
                IncmasterToUpdate = workoutIncentiveForUsrQtrWise(IncmasterToUpdate, 0, isTgtAchieved, getAchievementRangeCode(tempQtlyAchievementPercentage), getAchievementRangeCode(tempQtlyL1AchvePerc), getAchievementRangeCode(tempQtlyL2L3AchvePerc));  
                
				system.debug('Each IncmasterToUpdate -> ' + IncmasterToUpdate );
                finalListToUpdateIncMstr.add(IncmasterToUpdate);
            }else{
					newIncentiveMasterRecordToInsert.add(ownerKeyToOldIncMstrRowMap.get(eachExistIncMasRow));
			}
        }
        
       // Final Update in Incentive Master object with calculated Incentives.
        if(null !=  finalListToUpdateIncMstr) {
            try{
                 system.debug('Updating the final Incentive Master details list : ' + finalListToUpdateIncMstr);
            	 update finalListToUpdateIncMstr;
            }catch(DmlException dmle){
                system.debug('Error Occured during Incentive Master Update : ' + dmle);
           }
        }else{
				   system.debug('Nothing To Update - Incentive Master details list is empty ');
			}		
        if(null !=  newIncentiveMasterRecordToInsert) {
            try{
                 system.debug('Inserting new Incentive Master details list : ' + newIncentiveMasterRecordToInsert);
            	insert newIncentiveMasterRecordToInsert;
            }catch(DmlException dmleIns){
                system.debug('Error Occured during Incentive Master Insert : ' + dmleIns);
           }
        }else{
				   system.debug('Nothing To Insert - There are no new Incentive Master details list for inserting ');
			}	
      
  }
    
	
	public Incentive_Master__c compareNPrepareUpdatedIncMaster(Incentive_Master__c newIncMasterFromQdet, Incentive_Master__c oldExisitngIncMaster){
			
	   oldExisitngIncMaster.Quarterly_Overall_Actual__c = null != newIncMasterFromQdet.Quarterly_Overall_Actual__c  ? newIncMasterFromQdet.Quarterly_Overall_Actual__c : 0;
        oldExisitngIncMaster.Overall_IP_Actual__c =  null != newIncMasterFromQdet.Overall_IP_Actual__c   ? newIncMasterFromQdet.Overall_IP_Actual__c : 0; 
            
        oldExisitngIncMaster.BCT_IP_L0L0X_QtrActualsRev__c = null != newIncMasterFromQdet.BCT_IP_L0L0X_QtrActualsRev__c   ? newIncMasterFromQdet.BCT_IP_L0L0X_QtrActualsRev__c : 0;  
        oldExisitngIncMaster.BCTIP_L1_Qtr_Rev__c =( null != newIncMasterFromQdet.BCTIP_L1_Qtr_Rev__c    ? newIncMasterFromQdet.BCTIP_L1_Qtr_Rev__c : 0);
        oldExisitngIncMaster.BCTIP_L2L3_QtrRev__c = ( null != newIncMasterFromQdet.BCTIP_L2L3_QtrRev__c    ? newIncMasterFromQdet.BCTIP_L2L3_QtrRev__c : 0);
        
        oldExisitngIncMaster.PSvc_L0L0X_Qtr_Rev__c	= null != newIncMasterFromQdet.PSvc_L0L0X_Qtr_Rev__c    ? newIncMasterFromQdet.PSvc_L0L0X_Qtr_Rev__c : 0; 
        oldExisitngIncMaster.PSvc_L1_Qtr_Rev__c	= null != newIncMasterFromQdet.PSvc_L1_Qtr_Rev__c  ? newIncMasterFromQdet.PSvc_L1_Qtr_Rev__c : 0;
        oldExisitngIncMaster.PSvc_L2L3_Qtr_Rev__c = null != newIncMasterFromQdet.PSvc_L2L3_Qtr_Rev__c   ?  newIncMasterFromQdet.PSvc_L2L3_Qtr_Rev__c : 0;
        
        oldExisitngIncMaster.SI_Products_L0L0X_Qtr_Rev__c = null != newIncMasterFromQdet.SI_Products_L0L0X_Qtr_Rev__c    ?  newIncMasterFromQdet.SI_Products_L0L0X_Qtr_Rev__c : 0;
        oldExisitngIncMaster.SI_Products_L1_Qtr_Rev__c	= null != newIncMasterFromQdet.SI_Products_L1_Qtr_Rev__c   ?    newIncMasterFromQdet.SI_Products_L1_Qtr_Rev__c : 0; 
        oldExisitngIncMaster.SI_Products_L2L3_Qtr_Rev__c = null != newIncMasterFromQdet.SI_Products_L2L3_Qtr_Rev__c   ?  newIncMasterFromQdet.SI_Products_L2L3_Qtr_Rev__c : 0; 
            
		oldExisitngIncMaster.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c = null != newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c    ?  newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c : 0;
        oldExisitngIncMaster.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c	= null != newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c   ?    newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c : 0; 
        oldExisitngIncMaster.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c = null != newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c   ?  newIncMasterFromQdet.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c : 0; 
        	
		oldExisitngIncMaster.Rev_BCT_CF_Ent_Svcs_L0L0X__c = null != newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L0L0X__c    ?  newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L0L0X__c : 0;
        oldExisitngIncMaster.Rev_BCT_CF_Ent_Svcs_L1__c	= null != newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L1__c   ?    newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L1__c : 0; 
        oldExisitngIncMaster.Rev_BCT_CF_Ent_Svcs_L2L3__c = null != newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L2L3__c   ?  newIncMasterFromQdet.Rev_BCT_CF_Ent_Svcs_L2L3__c : 0; 
        
		oldExisitngIncMaster.Rev_TIBCO_Pdt_License_L0L0X__c = null != newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L0L0X__c    ?  newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L0L0X__c : 0;
        oldExisitngIncMaster.Rev_TIBCO_Pdt_License_L1__c	= null != newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L1__c   ?    newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L1__c : 0; 
        oldExisitngIncMaster.Rev_TIBCO_Pdt_License_L2L3__c = null != newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L2L3__c   ?  newIncMasterFromQdet.Rev_TIBCO_Pdt_License_L2L3__c : 0; 
 				
		oldExisitngIncMaster.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c = null != newIncMasterFromQdet.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c    ?  newIncMasterFromQdet.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c : 0;
        oldExisitngIncMaster.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c	= null != newIncMasterFromQdet.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c   ?    newIncMasterFromQdet.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c : 0; 
        oldExisitngIncMaster.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c = null != newIncMasterFromQdet.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c   ?  newIncMasterFromQdet.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c : 0; 
        
		
		oldExisitngIncMaster.Quarterly_Overall_Quota__c = null != newIncMasterFromQdet.Quarterly_Overall_Quota__c    ?  newIncMasterFromQdet.Quarterly_Overall_Quota__c : 0;
        oldExisitngIncMaster.Quota_L0L0XL1_Revised__c	= null != newIncMasterFromQdet.Quota_L0L0XL1_Revised__c   ?    newIncMasterFromQdet.Quota_L0L0XL1_Revised__c : 0; 
        oldExisitngIncMaster.Quota_L0L0XL1L2L3_Revised__c = null != newIncMasterFromQdet.Quota_L0L0XL1L2L3_Revised__c   ?  newIncMasterFromQdet.Quota_L0L0XL1L2L3_Revised__c : 0; 
			
			oldExisitngIncMaster.IP_Target_Achieved__c = newIncMasterFromQdet.IP_Target_Achieved__c;
			oldExisitngIncMaster.Overall_Acheived__c = newIncMasterFromQdet.Overall_Acheived__c; 

			return oldExisitngIncMaster;
	
	}
    
	
	  // This method contructs the incentive object in quarterly by grouping the monthly quota and revenues from quota detail values.
    public Incentive_Master__c populateIncentive(QuotaDetail__c eachQdet, integer Qtr, Incentive_Master__c tempIncMsRec){
       // system.debug('Inside populateIncentive');
       // Total_Rev_FC__c - sum of all 6 revenue types of L0L0X L1 L2 L3 (Monthly)
        Date startdt;
        tempIncMsRec.SalesUserId__c = eachQdet.Quota_Owner_Formula__c;
        tempIncMsRec.OwnerId = eachQdet.Quota_Owner_Formula__c;
        tempIncMsRec.Sales_User_Manager__c = eachQdet.QuotaMasterNew__r.Quota_Owner_Manager__c;
        tempIncMsRec.SBU__c = eachQdet.QuotaMasterNew__r.SBU__c;
		// grouping quota in quarterly basis. SUmming up incentive master quotas with monthly quota detail quotas.
        if(Qtr == 1 ){
        	tempIncMsRec.Quarterly_Overall_Quota__c = (tempIncMsRec.Quarterly_Overall_Quota__c != null ? tempIncMsRec.Quarterly_Overall_Quota__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
            tempIncMsRec.Quota_L0L0XL1_Revised__c = (tempIncMsRec.Quota_L0L0XL1_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1_Revised__c + eachQdet.Revised_L0L0XL1_Quota__c: eachQdet.Revised_L0L0XL1_Quota__c);
            tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c = (tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c + eachQdet.Revised_L0L0XL1L2L3_Quota__c : eachQdet.Revised_L0L0XL1L2L3_Quota__c);
        }else{
            tempIncMsRec.Quarterly_Overall_Quota__c = (tempIncMsRec.Quarterly_Overall_Quota__c != null ? tempIncMsRec.Quarterly_Overall_Quota__c + eachQdet.New_Quota__c : eachQdet.New_Quota__c);
            tempIncMsRec.Quota_L0L0XL1_Revised__c = (tempIncMsRec.Quota_L0L0XL1_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1_Revised__c + eachQdet.Revised_L0L0XL1_Quota__c: eachQdet.Revised_L0L0XL1_Quota__c);
            tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c = (tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c != null ? tempIncMsRec.Quota_L0L0XL1L2L3_Revised__c + eachQdet.Revised_L0L0XL1L2L3_Quota__c : eachQdet.Revised_L0L0XL1L2L3_Quota__c);
        }
	
        tempIncMsRec.actual_quota__c = (tempIncMsRec.actual_quota__c != null ? tempIncMsRec.actual_quota__c + eachQdet.Quota_Amount__c : eachQdet.Quota_Amount__c);
        tempIncMsRec.Quota_Period__c =  fyPeriod;
        tempIncMsRec.Quarterly_IP_Quota__c = (tempIncMsRec.Quarterly_IP_Quota__c != null ? tempIncMsRec.Quarterly_IP_Quota__c + eachQdet.Huringa_Quota_by_product__c : eachQdet.Huringa_Quota_by_product__c); 
        // Grouping Revenues quarter wise
        tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c  = (tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_Overall_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_L0L0_X_AC_FCRev__c : eachQdet.Total_L0L0_X_AC_FCRev__c);
        tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c = (tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_L1_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c : eachQdet.Total_L0_L0_X_L1_AC_FC_Rev__c);
        tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c = (tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c != null ? tempIncMsRec.L0_L0_X_L1L2L3_Actual_Forecast_Qtr_Rev__c + eachQdet.Total_Rev_FC__c : eachQdet.Total_Rev_FC__c);
        	
     	tempIncMsRec.Actual_Revenue_Recognized__c = (tempIncMsRec.Actual_Revenue_Recognized__c != null ? tempIncMsRec.Actual_Revenue_Recognized__c + eachQdet.Revenue_Recognized_Amount__c : eachQdet.Revenue_Recognized_Amount__c);
        tempIncMsRec.Overall_IP_Actual__c =  (tempIncMsRec.Overall_IP_Actual__c != null ? tempIncMsRec.Overall_IP_Actual__c + eachQdet.IP_Actual_Revenue_Summary__c : eachQdet.IP_Actual_Revenue_Summary__c); 
    
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
        system.debug('Before calculation Incentive  : ' + insmstrObj);
      if(!achieveRangeCode.equalsIgnoreCase('LESS30')){
            
            //system.debug('Incentive BCTIP  Range Code L0 : ' + achieveRangeCode);
           // system.debug('Incentive BCTIP  Range Code value L0: ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode));
			System.debug('Achievement code for L0L0X funnel : ' + achieveRangeCode  +  '   Incentive Scheme multiplier (BCTIPEXECUTIVE):   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode));
            
            insmstrObj.Incentive_BCT_IP__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode) * insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c / 100;
            insmstrObj.Incentive_SI_Products__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(achieveRangeCode) * insmstrObj.SI_Products_L0L0X_Qtr_Rev__c / 100;
            insmstrObj.Incentive_ProfSvcs__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(achieveRangeCode) * insmstrObj.PSvc_L0L0X_Qtr_Rev__c / 100;
            
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c / 100);
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c / 100);
			insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get(achieveRangeCode) * (insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c / 100);
			
			system.debug('L0L0X Incentive Quarter wise : ' + qtr + '  Incentive_BCT_IP__c : ' + insmstrObj.Incentive_BCT_IP__c + '  Incentive_SI_Products__c  : '+ insmstrObj.Incentive_SI_Products__c  + '  Incentive_ProfSvcs__c  : '+ insmstrObj.Incentive_ProfSvcs__c+ '  Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c  : '+ insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c+ '  Incen_BCT_CF_Ent_Svcs_L0L0X__c  : '+ insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c+ '  Incen_TIBCO_Pdt_License_L0L0X__c  : '+ insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c);
			
           /* insmstrObj.Yearly_IP_Incentive__c = 0;
            insmstrObj.Yearly_Net_New_Business_Incentive__c = 0;*/
          }else{
            insmstrObj.Incentive_BCT_IP__c = 0;
            insmstrObj.Incentive_SI_Products__c =0;
            insmstrObj.Incentive_ProfSvcs__c =0;
            insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L0L0X__c = 0;
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L0L0X__c = 0;
			insmstrObj.Incen_TIBCO_Pdt_License_L0L0X__c = 0;
			
            /*insmstrObj.Yearly_IP_Incentive__c =0;
            insmstrObj.Yearly_Net_New_Business_Incentive__c = 0;*/
        }
		
		if(!L1TgtRangeCode.equalsIgnoreCase('LESS30')){
		
			//system.debug('Incentive BCTIP  Range Code L1 : ' + achieveRangeCode);
			//system.debug('Incentive BCTIP  Range Code value L1: ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode));
			System.debug('Achievement code along with L1 funnel : ' + L1TgtRangeCode  +  '   Incentive Scheme multiplier(BCTIPEXECUTIVE) :   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L1TgtRangeCode));
            insmstrObj.Incentive_BCT_IP_L1__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + insmstrObj.BCTIP_L1_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_SI_Products_L1__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.SI_Products_L0L0X_Qtr_Rev__c + insmstrObj.SI_Products_L1_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_ProfSvcs_L1__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(L1TgtRangeCode) * ((insmstrObj.PSvc_L0L0X_Qtr_Rev__c + insmstrObj.PSvc_L1_Qtr_Rev__c) / 100);
			
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
			
		//	system.debug('Incentive BCTIP  Range Code L2 : ' + achieveRangeCode);
        //  system.debug('Incentive BCTIP  Range Code value L2: ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(achieveRangeCode));
			System.debug('Achievement code along with L2 L3 funnel : ' + L2L3TgtRangeCode  +  '   Incentive Scheme multiplier(BCTIPEXECUTIVE) :   ' + incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L2L3TgtRangeCode));
			system.debug('BCT_IP_L0L0X_QtrActualsRev__c : ' + insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + ' BCTIP_L1_Qtr_Rev__c  : '+ insmstrObj.BCTIP_L1_Qtr_Rev__c  + 'BCTIP_L2L3_QtrRev__c : ' + insmstrObj.BCTIP_L2L3_QtrRev__c  );
		
			insmstrObj.Incentive_BCT_IP_L2_L3__c = incentiveSchemeMap.get(BCTIPEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.BCT_IP_L0L0X_QtrActualsRev__c + insmstrObj.BCTIP_L1_Qtr_Rev__c + insmstrObj.BCTIP_L2L3_QtrRev__c) / 100);
            insmstrObj.Incentive_SI_Products_L2_L3__c = incentiveSchemeMap.get(SIPRODUCTSEXECUTIVE).get(L2L3TgtRangeCode) *((insmstrObj.SI_Products_L0L0X_Qtr_Rev__c + insmstrObj.SI_Products_L1_Qtr_Rev__c + insmstrObj.SI_Products_L2L3_Qtr_Rev__c) / 100);
            insmstrObj.Incentive_ProfSvcs_L2_L3__c = incentiveSchemeMap.get(PROFSERVICESEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.PSvc_L0L0X_Qtr_Rev__c + insmstrObj.PSvc_L1_Qtr_Rev__c + insmstrObj.PSvc_L2L3_Qtr_Rev__c) / 100);
			
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c = incentiveSchemeMap.get(DIGITALTIBCOSVCSEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L0L0X__c + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L1__c + insmstrObj.Rev_BCT_Appd_DigiTIBCO_Svcs_L2L3__c )/ 100);
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c = incentiveSchemeMap.get(CFENTSVCSEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_BCT_CF_Ent_Svcs_L0L0X__c + insmstrObj.Rev_BCT_CF_Ent_Svcs_L1__c + insmstrObj.Rev_BCT_CF_Ent_Svcs_L2L3__c)/ 100);
			insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c = incentiveSchemeMap.get(TIBCOPRODUCTLICENSEEXECUTIVE).get(L2L3TgtRangeCode) * ((insmstrObj.Rev_TIBCO_Pdt_License_L0L0X__c + insmstrObj.Rev_TIBCO_Pdt_License_L1__c + insmstrObj.Rev_TIBCO_Pdt_License_L2L3__c ) / 100);
           
		    system.debug('L2L3 Incentive Quarter wise: ' + qtr + '  Incentive_BCT_IP_L2_L3__c : ' + insmstrObj.Incentive_BCT_IP_L2_L3__c + '  Incentive_SI_Products_L2_L3__c  : '+ insmstrObj.Incentive_SI_Products_L2_L3__c  + '  Incentive_ProfSvcs_L2_L3__c  : '+ insmstrObj.Incentive_ProfSvcs_L2_L3__c+ '  Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c  : '+ insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c+ '  Incen_BCT_CF_Ent_Svcs_L2L3__c  : '+ insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c+ '  Incen_TIBCO_Pdt_License_L2L3__c  : '+ insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c);

         }else{
			insmstrObj.Incentive_BCT_IP_L2_L3__c = 0;
            insmstrObj.Incentive_SI_Products_L2_L3__c = 0;
            insmstrObj.Incentive_ProfSvcs_L2_L3__c = 0;
			insmstrObj.Incen_BCT_Appd_Digi_TIBCO_Svcs_L2_L3__c = 0;
			insmstrObj.Incen_BCT_CF_Ent_Svcs_L2L3__c = 0;
			insmstrObj.Incen_TIBCO_Pdt_License_L2L3__c = 0;
     
  
		 }	
		 
		 system.debug('Return Inc Master After Inc Calcualtion  : ' + insmstrObj);
		 system.debug('END -->: ' + qtr);
        return insmstrObj;
    }
    
 
    public List<integer> getQuarter(List<integer> mons){
        List<Integer> tempQtrsList = new List<Integer>();
        Set<Integer> uniqQtrSet = new Set<Integer>();
        for(integer eachMonth : mons)
        {
            if(eachMonth >= 4 && eachMonth <= 6){
                tempQtrsList.add(1);
            }else if(eachMonth >= 7 && eachMonth <=9){
                tempQtrsList.add(2);
            }else if(eachMonth >= 10 && eachMonth <=12){
                tempQtrsList.add(3);
            }else{
                tempQtrsList.add(4);
            }
        }
        
        uniqQtrSet.addAll(tempQtrsList);
        tempQtrsList.clear();
        tempQtrsList.addAll(uniqQtrSet);
        
        return tempQtrsList;
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
	 
	 public integer getFy(integer qtr){
        if(qtr > 3){
            return currYear + 1;
        }else{
            return currYear;
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
}