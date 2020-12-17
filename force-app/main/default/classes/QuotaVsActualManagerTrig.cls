/* Class:       QuotaVsActualManagerTrig
 * Created On:  02/25/2017
 * Created by:  Arun Rajendran
 * Description: Handler for trigger on Revenue Term object.
 */
public class QuotaVsActualManagerTrig {
    
    private Map<Id, Revenue_Term__c> mapNewRevTerms;
	private	Map<Id, Revenue_Term__c> mapOldRevTerms;
    public String corporateCurrency ='USD';
    
    private static Boolean blnAlreadyInsideTrigger = false;
  
    //New class level variables
	Map<ID, ID> revOpportunityOwnerMap;
    Map<ID, Date> actualDetIdToDateMap;
    Map<String, ID> actIdToQuotaDetailIdMap; 
	Map<String, ID> actIdKeyToPrdtQtaDetIdMap; 
    Map<String, ID> revIdToActualDetailMap;
	Map<ID, ID> oppOwnerIDToMangerId;
    Set<Decimal> newRevMonths = new Set<Decimal>();
	Set<String> newRevSBUs = new Set<String>();
    Set<Decimal> newRevYears = new Set<Decimal>();
    Set<Id> newOwnerIds = new Set<Id>();
    List<Actual_Detail__c> actObjListToInsert = new List<Actual_Detail__c>();
	list<id> revIdsToDelete = new List<id>();
   
	private static String ASYMMETRIX ='ASYMMETRIX';
    private static String PULSE ='PULSE';
    private static String DROPTHOUGHT ='DROPTHOUGHT';
    private static String RETINA ='RETINA';
    private static String CUETRACK ='CUETRACK';
    private static String CUETRANS ='CUETRANS';  
    private static String GEODATAFY ='GEODATAFY';  
    private static String OVERALL ='OVERALL';
    
    private static List<String> ASYMMETRIX_PDT;
    private static List<String> PULSE_PDT;
    private static List<String> DROPTHOUGHT_PDT;
    private static List<String> RETINA_PDT;
    private static List<String> CUETRACK_PDT;
    private static List<String> CUETRANS_PDT;
    private static List<String> GEODATAFY_PDT;
    
    Map<String, List<String>> ASYMMETRIX_PDTMAP;
    Map<String, List<String>> DROPTHOUGHT_PDTMAP;
    Map<String, List<String>> PULSE_PDTMAP;
    Map<String, List<String>> RETINA_PDTMAP;
    Map<String, List<String>> CUETRACK_PDTMAP;
    Map<String, List<String>> CUETRANS_PDTMAP;
    Map<String, List<String>> GEODATAFY_PDTMAP;
     
    
    
    private static String BCTIP ='BCT IP';
    private static String PS ='Professional Services';
    private static String SIPRODUCTS ='SI Products';  
	public static String  DIGITIBCOSVCSEXECUTIVE = 'BCT approved Digital & TIBCO Services';   //BCT approved Digital & TIBCO Services	
    public static String  BCTCFENTSVCSEXECUTIVE = 'BCT Enterprise Services'; 			//BCT C/F & Enterprise Servies
    
	// New fields added for new incetive changes
    public static String  TIBCOPRODUCTLICENSEEXECUTIVE = 'TIBCO Product License'; 			//BCT IP 
 
	private static String BCTSVCS ='BCT Services';
    private static String EXTCONTRACTS ='Existing Contracts';
    private static String NEWLOGO ='NEWLOGO';
    
    
    
    public ID revIdToResetFlag {get; set;}
	
	public List<String> productType {get; set;}
    
    public QuotaVsActualManagerTrig(Map<Id, Revenue_Term__c> mapNewRevTerms, Map<Id, Revenue_Term__c> mapOldRevTerms) {
		
        this.mapNewRevTerms = mapNewRevTerms;
		this.mapOldRevTerms = mapOldRevTerms;
        
        if(null != mapNewRevTerms){
        system.debug('mapNewRevTerms Size' + mapNewRevTerms.size());
        //system.debug('mapNewRevTerms' + mapNewRevTerms);    
        }
        
        if(null != mapOldRevTerms){
        	//system.debug('mapOldRevTerms Size : ' + mapOldRevTerms.size());
        	//system.debug('mapOldRevTerms  : ' + mapOldRevTerms);    
        }
        
       //Populating month, year and Owner id
        if(null != mapNewRevTerms){
        	for (ID newRevTerm : mapNewRevTerms.keySet()) {
             	newRevMonths.add(mapNewRevTerms.get(newRevTerm).Revenue_date__c.month());
            	newRevYears.add(mapNewRevTerms.get(newRevTerm).Revenue_date__c.year());
				newRevSBUs.add(mapNewRevTerms.get(newRevTerm).Revenue_SBU__c);
                newRevYears.add(2019);
            	}
  			system.debug('In QVA Trigger Process Revenue Method : New Rev years '+ newRevYears +' --> Months :'+ newRevMonths +' --> SBUs list : ' + newRevSBUs);            
            
        }
        
        ASYMMETRIX_PDTMAP = new Map<String, List<String>>();
        ASYMMETRIX_PDT = new List<String>();
        ASYMMETRIX_PDT.add('ASYMMETRIX');
        ASYMMETRIX_PDT.add('ALM');
        ASYMMETRIX_PDT.add('Capital Engine');
        ASYMMETRIX_PDT.add('Credit Early Warning');
        ASYMMETRIX_PDT.add('Model Validation');
        ASYMMETRIX_PDT.add('RAROC Calculator');
        ASYMMETRIX_PDT.add('Regulatory Reporting');
        ASYMMETRIX_PDT.add('Asymmetrix - Full Suite');
        ASYMMETRIX_PDT.add('Dashboards');
        ASYMMETRIX_PDT.add('Operational Risk');
        ASYMMETRIX_PDTMAP.put(ASYMMETRIX, ASYMMETRIX_PDT); 

		DROPTHOUGHT_PDTMAP = new Map<String, List<String>>();
        DROPTHOUGHT_PDT = new List<String>();
        DROPTHOUGHT_PDT.add('DROPTHOUGHT');
        DROPTHOUGHT_PDTMAP.put(DROPTHOUGHT, DROPTHOUGHT_PDT);
        
        PULSE_PDTMAP = new Map<String, List<String>>();
        PULSE_PDT =  new List<String>();
        PULSE_PDT.add('PULSE');
        PULSE_PDTMAP.put(PULSE,PULSE_PDT);
        
        RETINA_PDTMAP = new Map<String, List<String>>();
        RETINA_PDT = new List<String>();
        RETINA_PDT.add('RETINA');
        RETINA_PDT.add('Cuecent Retina - Full Suite');
        RETINA_PDT.add('Retina Empower');
        RETINA_PDT.add('Retina Enhance');
        RETINA_PDTMAP.put(RETINA,RETINA_PDT );
        
       	CUETRACK_PDTMAP = new Map<String, List<String>>();
        CUETRACK_PDT = new List<String>();
        CUETRACK_PDT.add('CUETRACK');
        CUETRACK_PDTMAP.put(CUETRACK, CUETRACK_PDT);
        
        CUETRANS_PDTMAP = new Map<String, List<String>>();
        CUETRANS_PDT = new List<String>();
        CUETRANS_PDT.add('CUETRANS');
        CUETRANS_PDT.add('IVMS');
        CUETRANS_PDT.add('Cuecent MTL');
        CUETRANS_PDT.add('Freight Exchange');
        CUETRANS_PDT.add('People Logistics');
        CUETRANS_PDT.add('CueTrans - Full Suite');
        CUETRANS_PDT.add('CueTrans TMS');
        CUETRANS_PDT.add('CueTrans SJM');
        CUETRANS_PDT.add('CueTrans IVMS');
        CUETRANS_PDT.add('Cuecent FSA');
        CUETRANS_PDT.add('Fuel Trans  - Ful Suite');
        CUETRANS_PDT.add('Fuel Trans');
        
        CUETRANS_PDTMAP.put(CUETRANS,CUETRANS_PDT);
        
        
        GEODATAFY_PDTMAP = new Map<String, List<String>>();
        GEODATAFY_PDT = new List<String>();
        GEODATAFY_PDT.add('GeoData FY');
        GEODATAFY_PDTMAP.put(GEODATAFY,GEODATAFY_PDT);
        
	}
    
    // UTIL METHOD : 1
    // Populates the opporutnity and its owner map
    // 
    public void populateOpportunityOwnerMap(SET<ID> revIds){
        revOpportunityOwnerMap = new Map<ID, ID>();
        List<Revenue_Term__c> revDetailObjs = [SELECT Id, Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId  FROM Revenue_Term__c where id in:revIds];
        //system.debug('Rvenue Term wth owner :  '+ revDetailObjs);
        if(revDetailObjs != null && revDetailObjs.size()>0){
        for(Revenue_Term__c eachrevTerm : revDetailObjs){
                    revOpportunityOwnerMap.put( eachrevTerm.id, eachrevTerm.Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId);
            		newOwnerIds.add(eachrevTerm.Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId);
                   }
            	}
			//system.debug('Revenue and its Opportunity Owner Map : ' +revOpportunityOwnerMap.size()+'-->'+ revOpportunityOwnerMap);
        	//system.debug('New Owner Ids list: ' + newOwnerIds);
	}
    
      
    //UTIL METHOD :2
    //This method will populate the Actual id  to Reveune date map for update reference purpose.
    //populate the Actual id + product key  to Reveune date map for update reference purpose.
    
    public void populateActualToRevDateMap(){
         List<Actual_Detail__c> actObj ;
         List<ID> revIdsList = new List<ID>();
          
        Set<Date> OldRevDates = new Set<Date>();
        for (ID newRevTerm : mapNewRevTerms.keySet()) {
             	revIdsList.add(newRevTerm);
            if(mapOldRevTerms != null){
            		OldRevDates.add(mapOldRevTerms.get(newRevTerm).Revenue_Date__c);
            	}
            }
        //system.debug('Inside populateRevID To OldRevDateMap from Actual Detial object:  Revenue Ids : '+revIdsList +'OldRevDates ' + OldRevDates);  
           if(mapOldRevTerms != null){
               
               String soqlQuery = 'select ' +
        				' ID, Actual_Revenue_Date__c, RevenueTermRef__r.Opportunity_line_item_id__r.product__c ' +  
        					'from actual_detail__c where RevenueTermRef__c IN :'+revIdsList +'and Actual_Revenue_Date__c IN :'+ OldRevDates;
      			system.debug('=======> query = ' + soqlQuery);
      			
               
               
               actObj = [SELECT ID, Actual_Revenue_Date__c, RevenueTermRef__c, RevenueTermRef__r.Opportunity_line_item_id__r.product__c,RevenueTermRef__r.Opportunity_line_item_id__r.Competency__c, Product_Code_QuotaDet__c FROM actual_detail__c where RevenueTermRef__c IN :mapNewRevTerms.keySet() and Actual_Revenue_Date__c IN : OldRevDates];
      			//system.debug('=======> There are ' + revIdsList.size() + 'Revenue Terms records to process.');
	 			//system.debug('populateRevID To OldRevDateMap() Values : ' + actObj);
            	}
        
        
       			if( null != actObj && actObj.size()>0 ){
					actualDetIdToDateMap = new Map<ID, Date>();
                    revIdToActualDetailMap = new Map<String,ID>();
                    for(Actual_Detail__c eachActObj : actObj){
                        //actualDetIdToDateMap - Actual ID to Old Revenue date map
                        actualDetIdToDateMap.put(eachActObj.id, eachActObj.actual_revenue_date__c);
                        String tempRevKey = eachActObj.RevenueTermRef__c + OVERALL;
                        system.debug('**Temp Revenue Key***'+tempRevKey);
                        String tempPdtOrComp = (null != eachActObj.RevenueTermRef__r.Opportunity_line_item_id__r.product__c && eachActObj.RevenueTermRef__r.Opportunity_line_item_id__r.product__c.equalsIgnoreCase('none')) ? eachActObj.RevenueTermRef__r.Opportunity_line_item_id__r.Competency__c : eachActObj.RevenueTermRef__r.Opportunity_line_item_id__r.product__c ;
						system.debug('**Temp ProductORCompetency Key***'+tempPdtOrComp);
                        String tempkeyPdt = eachActObj.RevenueTermRef__c + getProductCodeFromProduct(tempPdtOrComp);
                        system.debug('**Temp Product Key***'+tempkeyPdt);
                        
					    
                       // revIdToActualDetailMap.put(eachActObj.RevenueTermRef__c, eachActObj.id);
                       // revIdToActualDetailMap - Actual Id + Product  to actual object Id
					   ////system.debug('*+* TEMP KEY FOR MAP tempRevKey: ' + tempRevKey);  
						if(eachActObj.Product_Code_QuotaDet__c.equalsIgnoreCase(OVERALL)){
							revIdToActualDetailMap.put(tempRevKey, eachActObj.id);
					   }else{
						system.debug('*+* TEMP  PRODUCT KEY FOR MAP tempkeyPdt: ' + tempkeyPdt);  
							revIdToActualDetailMap.put(tempkeyPdt, eachActObj.id);
						}
                    }
                     system.debug('*+* Actual ID to Revenue Date MAP : ' + actualDetIdToDateMap);   
                   system.debug('*** Revenue ID PRODUCT KEY  to Actual obj id MAP : ' + revIdToActualDetailMap);   
       		}
    	}
    
     
    // UTIL METHOD : 3
    // Map <Actual ID, Quota ID>
    // Description : This method populates the map of Actual key (Opp Owner id  +  Quota Month + Quota Year + Product )to respective Quota ID
    public void populateQuotaIdsForActuals(){
        Id quotaIdforActual;
        
       actIdToQuotaDetailIdMap = new Map<String, ID>();
        actIdKeyToPrdtQtaDetIdMap = new Map<String, ID>();
        //system.debug('Printing newoqwner ids : ' + newOwnerIds +' Years : '+ newRevYears +' Months: '+ newRevMonths);  
        List<QuotaDetail__c> qtDetailObjs = [select Id, Quota_Date__c, Quota_month__c, QuotaYear__c,QuotaMasterNew__r.id, QuotaMasterNew__r.Quota_Owner_Name__r.id, QuotaMasterNew__r.SBU__C,
                                             Quota_Amount__c , QuotaKey__c, Product_Type_QDET__c from QuotaDetail__c 
        where 
        (QuotaMasterNew__r.Quota_Owner_Name__r.id = :newOwnerIds 
		and Quota_Month__c in :newRevMonths and QuotaYear__c in :newRevYears 
		and  QuotaMasterNew__r.SBU__c =: newRevSBUs 
		and Product_Type_QDET__c in ('ASYMMETRIX', 'RETINA', 'CUETRACK','CUETRANS','DROPTHOUGHT','PULSE','GEODATAFY','OVERALL'))
        order by QuotaMasterNew__r.Quota_Owner_Name__r.id, Quota_Date__c];
        
		//system.debug('Quota Details for Quota month, year and owner  : ' + qtDetailObjs);        
        if(qtDetailObjs != null && qtDetailObjs.size()>0){
          
            for(QuotaDetail__c eachQdet : qtDetailObjs){
                    quotaIdforActual = eachQdet.id;
                    
					String tempQKeyPdt = String.valueOf(eachQdet.QuotaMasterNew__r.Quota_Owner_Name__r.id) + String.valueOf(eachQdet.Quota_month__c) + String.valueOf(eachQdet.QuotaYear__c)+String.valueOf(eachQdet.Product_Type_QDET__c)+ eachQdet.QuotaMasterNew__r.SBU__C;
					
                	String tempQKey = String.valueOf(eachQdet.QuotaMasterNew__r.Quota_Owner_Name__r.id) + String.valueOf(eachQdet.Quota_month__c) + String.valueOf(eachQdet.QuotaYear__c)+ eachQdet.QuotaMasterNew__r.SBU__C;
                    
					actIdToQuotaDetailIdMap.put(tempQKey , eachQdet.Id );
                	actIdKeyToPrdtQtaDetIdMap.put(tempQKeyPdt, eachQdet.Id);
            	}
            }
        	system.debug('Actual to Quota Details map   : ' + actIdToQuotaDetailIdMap); 
         	system.debug('*** - Actual to Product Quota Details map   : ' + actIdKeyToPrdtQtaDetIdMap);  
        //return quotaIdforActual;
        
    }
	
	
	// UTIL METHOD : 4
    // Map <Owner Id, Manager ID>
    // Description : This method populates the map of Quota Owner to its manager ID
	
	public void populateQuotaManagerId(){
       // id qmgrId;
		oppOwnerIDToMangerId =  new Map<ID, ID>();
        List<User> reportingMgr = [Select managerid, UserRole.name, id from user where id IN :newOwnerIds AND isActive = true];
          if(null != reportingMgr && reportingMgr .size() > 0){
               for(User repMgr : reportingMgr){
                   oppOwnerIDToMangerId.put(repMgr.id, repMgr.managerid);
                   //usrRole = String.valueOf(repMgr.UserRole.name);
               }
          }
        //system.debug('Quota owners manager ids '+ oppOwnerIDToMangerId);
        
    }
	
    
    public String getIPProductCode(String product, Map<String, List<String>> productMap){
        for(String pdtCode : productMap.keySet()){
            for(String eachPdt : productMap.get(pdtCode)){
               if(product.equalsIgnoreCase(eachPdt)) {
                   system.debug('Product Code : ' + pdtCode);                      
                	return pdtCode;
                 break;
            	} 
            }
         }
        return 'NOTMATCHING';
    }
    
   //Added for Product Grouping Requirement
   // UTIL METHOD : 5
    public String getProductCodeFromProduct(String productName){
		system.debug('Revenue Product Code ::  ' + productName);
        IF(null != productName && (productName.equalsIgnoreCase(ASYMMETRIX)|| ASYMMETRIX.equalsIgnoreCase(getIPProductCode(productName,ASYMMETRIX_PDTMAP )))){
		system.debug('ASYMMETRIX Product Found');
            return ASYMMETRIX;
        }else if(null != productName && (productName.equalsIgnoreCase(RETINA)|| RETINA.equalsIgnoreCase(getIPProductCode(productName,RETINA_PDTMAP )))){
			system.debug('Retina Product Found');
            return RETINA;
        }else if(null != productName && (productName.equalsIgnoreCase(DROPTHOUGHT) || DROPTHOUGHT.equalsIgnoreCase(getIPProductCode(productName,DROPTHOUGHT_PDTMAP )))){
		system.debug('DROPTHOUGHT Product Found');
            return DROPTHOUGHT;
        }else if(null != productName && (productName.equalsIgnoreCase(PULSE) || PULSE.equalsIgnoreCase(getIPProductCode(productName,PULSE_PDTMAP )))){
		system.debug('PULSE Product Found');
            return PULSE;
        }else if(null != productName && (productName.equalsIgnoreCase(CUETRACK) || CUETRACK.equalsIgnoreCase(getIPProductCode(productName,CUETRACK_PDTMAP )))){
		system.debug('CUETRACK Product Found');
            return CUETRACK;
        }else if(null != productName && (productName.equalsIgnoreCase(CUETRANS)|| CUETRANS.equalsIgnoreCase(getIPProductCode(productName,CUETRANS_PDTMAP )))){
		system.debug('CUETRANS Product Found');
            return CUETRANS;
        }else if(null != productName && (productName.equalsIgnoreCase(GEODATAFY)|| GEODATAFY.equalsIgnoreCase(getIPProductCode(productName,GEODATAFY_PDTMAP )))){
		system.debug('GEODATAFY Product Found');
            return GEODATAFY;
        }else if(null == productName || productName.equalsIgnoreCase('') || productName.equalsIgnoreCase('OVERALL')){
		system.debug('OVERALL Product Found');
            return OVERALL;
        }
        
        return null;
        
    }
	// UTIL METHOD : 6
    public ID getActualIdforOldRevDate(Id newRevTermId, String productKey, Date revDate){
        Id actualDetailId;
        
         system.debug('Getting actual id for old rev date    : ' + newRevTermId +'--> old date : '+revDate +'--'+productKey);  
        if(null != newRevTermId  && null != revDate){
          //  system.debug('Actual detail map****'+revIdToActualDetailMap);
           //  system.debug('Actual date map****'+actualDetIdToDateMap);
            
            if(null!= revIdToActualDetailMap){
               system.debug('**** AA - Actual ID Key : ' + newRevTermId +productKey);
                Id tempActualId =  revIdToActualDetailMap.get(newRevTermId +productKey);
               system.debug('**** BA - Actual ID Key : ' + tempActualId);
                
                
                if(null != tempActualId && null != actualDetIdToDateMap){
               		Date tempActRevDate = actualDetIdToDateMap.get(tempActualId);
                    system.debug('Actual Revenue Date--------->'+tempActRevDate);
                if(null != tempActRevDate ){
                	actualDetailId = (tempActRevDate == revDate ? tempActualId : null);
				}
        	}
       }
    }
	        return actualDetailId;
        
    }
  // UTIL METHOD : 7
  public void populatePrdtmap(){
			productType = new List<String>();
        	productType.add(ASYMMETRIX);
        	productType.add(DROPTHOUGHT);
        	productType.add(RETINA);
        	productType.add(PULSE);
        	productType.add(CUETRACK);
        	productType.add(CUETRANS);
            productType.add(GEODATAFY);
			
		}
  
  // Main Method : 1
    public void processRevenueDetails(){
         //system.debug('SHIFT SUBSEQUENT AND QVA TRIGGER : BOOLEAN ALRREADY INSIDE TRIGGER VALUE :::: ' + blnAlreadyInsideTrigger);
        
   
  		
        
        if (blnAlreadyInsideTrigger) {
      return;
    }

	/**************************************************************************Shift Sub sequent Trigger ****************/
	
	 //system.debug('shiftSubsequentRevDates Trigger is ACTIVE');
		date oldRevdate;
        integer revTermCycle = 30;
 		boolean isSubsequentSelected = false;
        if(null != mapNewRevTerms){
      	  for (Revenue_Term__c neRevTerm : mapNewRevTerms.values()){
              if(neRevTerm.Shift_Subsequent_Revenue_Dates__c== true){
                  isSubsequentSelected =  true;
                  break;
              }
          	}
    }
        IF(Trigger.isUpdate && Trigger.isAfter){
        List<Revenue_Term__c> RevTermListToUpdate = new List<Revenue_Term__c>();
           //system.debug('Shift Subsequent date - Trigger New values  : '+ trigger.new);
            for (Revenue_Term__c nwRevTerm : mapNewRevTerms.values()){

              if(nwRevTerm.Shift_Subsequent_Revenue_Dates__c== true){
                 system.debug('Shift Date set to True -Trigger New Value with subsequent shift  : '+ nwRevTerm.name);
                  revIdToResetFlag = nwRevTerm.ID;
                  for (Revenue_Term__c oldRevTerm : mapOldRevTerms.values()){
						oldRevdate = oldRevTerm.revenue_date__c;
						//system.debug('Old Revenue date in dateshift trigger old : ' + oldRevdate);
        		}
	
				if(nwRevTerm.Revenue_Term__c.containsIgnoreCase('30')){
                       revTermCycle = 30;
                    }else if (nwRevTerm.Revenue_Term__c.containsIgnoreCase('45')){
                     revTermCycle = 45;
                        }else if(nwRevTerm.Revenue_Term__c.containsIgnoreCase('60')){
                     revTermCycle = 60;
                    }else if(nwRevTerm.Revenue_Term__c.containsIgnoreCase('90')){
                     revTermCycle = 90;
                    }
	
				//system.debug('New Values with subsequent option selected : '+ nwRevTerm.name + ' Old Rev date : '+oldRevdate +'New Revenue Date : '+ nwRevTerm.revenue_date__c);
		   		    String soqlQuery = 'select name,' +
        				' line_id__c, Revenue_Date__c  from Revenue_Term__c where (Opportunity_Line_Item_id__c IN '+  nwRevTerm.Opportunity_Line_Item_id__c +' AND revenue_date__c > = '+oldRevdate +')OR (Opportunity_Line_Item_id__c= '+ nwRevTerm.Opportunity_Line_Item_id__c + 'AND revenue_date__c  = '+ nwRevTerm.revenue_date__c +')';
                   String soqlQuery1 = 'select name,' + ' line_id__c, Revenue_Date__c  from Revenue_Term__c where (Opportunity_Line_Item_id__c IN '+  nwRevTerm.Opportunity_Line_Item_id__c +' AND revenue_date__c > = '+oldRevdate +' name <> '+nwRevTerm.name +')';
      			system.debug('=======> query = ' + soqlQuery1);
                  
           List<Revenue_Term__c> RevTermList = [select name , line_id__c, Revenue_Date__c  from Revenue_Term__c where (Opportunity_Line_Item_id__c= :nwRevTerm.Opportunity_Line_Item_id__c AND revenue_date__c > :oldRevdate AND name <> : nwRevTerm.name )];
          // system.debug('RevTermList to shift date size:'+ RevTermList.size());
          // system.debug('RevTermList:'+ RevTermList);
		  // if(false){
           if(null != RevTermList.size() && RevTermList.size() >0){
           
           Date tempDate = nwRevTerm.Revenue_Date__c;
           
               for(Revenue_Term__c RevTerm : RevTermList){
                
                if(RevTerm.name.equalsIgnoreCase(nwRevTerm.name)){
                   system.debug('Updating Shift_subsequent_milestone_dates__c as FALSE - ' + nwRevTerm.name );
                   RevTerm.Shift_Subsequent_Revenue_Dates__c= false;
                   if(null != nwRevTerm.Change_Reason__c){
                    	RevTerm.Change_Reason__c = nwRevTerm.Change_Reason__c;       
                    }else{
                        RevTerm.Change_Reason__c = 'Date Changed';
                    }
                   RevTermListToUpdate.add(RevTerm);
                
                }else{          
                    Date temp = tempDate + revTermCycle;
                    system.debug('Shift revenue dates from : '+ RevTerm.Revenue_Date__c +' TO : '+ temp );

                    RevTerm.Revenue_Date__c = tempDate + revTermCycle ;
                   //system.debug('Shift revenue dates from : '+ RevTerm );
                    tempDate = RevTerm.Revenue_Date__c;
                    if(null != nwRevTerm.Change_Reason__c){
                    	RevTerm.Change_Reason__c = nwRevTerm.Change_Reason__c;       
                    }else{
                        RevTerm.Change_Reason__c = 'Date Changed';
                    }
                 
                   // system.debug('Adding shifted rev dates : '+ RevTerm );
                    RevTermListToUpdate.add(RevTerm);
                    }
                }
            
            }
                  
              }   
           }   
            
             if(RevTermListToUpdate.size() > 0){
        
        try{
            // system.debug('Updating Subsequent Revenue dates SIZE : ' + RevTermListToUpdate.size());
         	// system.debug('Updating Subsequent Revenue dates' + RevTermListToUpdate);
          
         update RevTermListToUpdate;
          
         //system.debug('Updating Subsequent Revenue dates done');
        }
        Catch(DMLexception dmle){
            //system.debug('Error while Updating Subsequent Revenue dates' + dmle); 
          //  trigger.new[1].addError('Please provide reason for change in milestone details');
            
                }
    
           }
	
    }
        
        
	
					/*************** END OF SHIFT SUBSEQUENT TRIGGER **********************/
	
	
	 
	    List<QuotaDetail__c> qtObj;
       // List<Actual_Detail__c> actObjListToInsert = new List<Actual_Detail__c>();
        List<Actual_Detail__c> actObjListToUpdate = new List<Actual_Detail__c>();
        List<Revenue_Term__c> revIdsList = new List<Revenue_Term__c>();
        Actual_detail__c qtActualtoInsert;
		List<ID> revenueTermWithoutQuota = new List<ID>();
		populatePrdtmap();
      //if (false) {
        if ((Trigger.isInsert && Trigger.isAfter) || (Trigger.isUpdate && Trigger.isAfter)) {
            //system.debug('In QVA Insert or Update Trigger');
            
            if(null != mapNewRevTerms && mapNewRevTerms.size() > 0){
            if(null == revOpportunityOwnerMap){
                 //system.debug('Calling populateOpportunityOwnerMap ');
            	 populateOpportunityOwnerMap(mapNewRevTerms.keySet());    
            	}
                 if(null == actualDetIdToDateMap){
                 //system.debug('Calling populateActualToRevDateMap ');
            	 populateActualToRevDateMap();    
            	}
                 if(null == actIdToQuotaDetailIdMap){
                 system.debug('Calling populateQuotaIdsForActuals ');
            	 populateQuotaIdsForActuals();    
            	}
                 if(null == oppOwnerIDToMangerId){
                // system.debug('Calling populateQuotaManagerId ');
            	 populateQuotaManagerId();    
            	}
			}
            
             
        /*system.debug('1 revOpportunityOwnerMap' + revOpportunityOwnerMap);
        system.debug('2 actualDetIdToDateMap' + actualDetIdToDateMap);
        system.debug('3 revIdToActualDetailMap' + revIdToActualDetailMap);
        system.debug('4 newRevMonths' + newRevMonths);
        system.debug('5 newRevYears' + newRevYears);
        system.debug('6 newOwnerIds' + newOwnerIds); */
       for (ID newRevTerm : mapNewRevTerms.keySet()) {
        		//system.debug('Start ****************************Iterating for  :  ' +  mapNewRevTerms.get(newRevTerm).name );
          	//revIdsList.add(mapNewRevTerms.get(newRevTerm));
            List<Actual_Detail__c> actObj ;
            Id actualRecId ;
			Id actualPrdtRecId;
       
            if(mapOldRevTerms != null){
           // 	actObj = [SELECT ID, NAME,Actual_Revenue_Date__c from actual_detail__c where RevenueTermRef__c =:newRevTerm and Actual_Revenue_Date__c =: mapOldRevTerms.get(newRevTerm).Revenue_Date__c];
					//Getting old revenue date for the new rev term id from the map Old Rev terms - This is for overall actual id
                    actualRecId = getActualIdforOldRevDate(newRevTerm, OVERALL, mapOldRevTerms.get(newRevTerm).Revenue_Date__c);
					//this call is for product actual id
					String tempPdtOrCompetency = (null != mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c && mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c.equalsIgnoreCase('none')) ? mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c : mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c;
					system.debug('tempPdtOrCompetency----------->'+tempPdtOrCompetency);
					system.debug('Rev Term New product : ' + getProductCodeFromProduct(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c));
                    system.debug('**New product in oppLineitem**' + getProductCodeFromProduct(tempPdtOrCompetency)); 
                    system.debug('***REvenue id*'+ newRevTerm);  
                    system.debug('**Old Map REvenue Dates**'+ mapOldRevTerms.get(newRevTerm).Revenue_Date__c);
					actualPrdtRecId = getActualIdforOldRevDate(newRevTerm, getProductCodeFromProduct(tempPdtOrCompetency), mapOldRevTerms.get(newRevTerm).Revenue_Date__c);
                    system.debug('Is Actual detail available for old rev date and rev id combination  : ' + mapOldRevTerms.get(newRevTerm).Revenue_Date__c+'--> actualRecId : '+ actualRecId  +' Actual Product ID : '+ actualPrdtRecId);
        		}
             	
            	if( null != actualRecId || null != actualPrdtRecId ){
                //update flow
                 system.debug('Actual Detail available for the revenue Id changed actualRecId :  ' + actualRecId +' -- actualPrdtRecId : '+actualPrdtRecId);
                 //Check if just the revenue date has been changed or just the revenue recognized amount has chagned
                 //If Just the date then update the existing row with corresponding quotaId
                 //If just the amount then create a new row with current date as revenue recognised date
                 //If both has changed then update the existing row in the actual detail obj.
               
                if(mapNewRevTerms.get(newRevTerm).Revenue_Date__c == mapOldRevTerms.get(newRevTerm).Revenue_Date__c && mapNewRevTerms.get(newRevTerm).Recognized_Amount__c == mapOldRevTerms.get(newRevTerm).Recognized_Amount__c){
                     system.debug('Dates are same and same revenue recognized amount. Do nothing ');
                }else if(mapNewRevTerms.get(newRevTerm).Revenue_Date__c != mapOldRevTerms.get(newRevTerm).Revenue_Date__c && mapNewRevTerms.get(newRevTerm).Recognized_Amount__c != mapOldRevTerms.get(newRevTerm).Recognized_Amount__c){
                     	system.debug('Both Revenue recognized amt and Dates are changed. So updating the existing Actual detail object row.');
                    	//This call is for Overall rev actual data
                    	actObjListToUpdate.add(prepareActualObjToUpdate(actualRecId, newRevTerm, OVERALL, false, revOpportunityOwnerMap));
						//this call is for product 
						if(null != actualPrdtRecId){
						actObjListToUpdate.add(prepareActualObjToUpdate(actualPrdtRecId, newRevTerm, mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c, false, revOpportunityOwnerMap));
						}
                    	//actObjListToUpdate = prepareActualObjToUpdate(actualRecId, newRevTerm, true, revOpportunityOwnerMap);
                     	//system.debug('Actual Object to update after processing :'+ actObjListToUpdate);
                
                }else if(mapNewRevTerms.get(newRevTerm).Revenue_Date__c != mapOldRevTerms.get(newRevTerm).Revenue_Date__c){
                     system.debug('Only revenue Date is changed . So updating the existing row with newly entered date and updating with current correspoding quota Id');
                    	Id newQtId; 
                    	Id newQtIdPdt;
						boolean diffMonthFlag = false;
                     if(!(mapNewRevTerms.get(newRevTerm).Revenue_Month__c == mapOldRevTerms.get(newRevTerm).Revenue_Month__c && mapNewRevTerms.get(newRevTerm).Revenue_Year__c == mapOldRevTerms.get(newRevTerm).Revenue_Year__c)){
                           
						   String tempPdtOrCompetency = (null != mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c && mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c.equalsIgnoreCase('none')) ? mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c : mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c;
						   
						   system.debug('Revenue mon and yr are different. So Fetching correspoding Quota Id for New Actual Rev Recog date :'+ mapNewRevTerms.get(newRevTerm).Revenue_Month__c +'Year : '+mapNewRevTerms.get(newRevTerm).Revenue_Year__c +'Product Key : '+ mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c + ' getProductCodeFromProduct Name : ' + getProductCodeFromProduct(tempPdtOrCompetency));
                   	 
						  newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c), revOpportunityOwnerMap.get(newRevTerm), OVERALL, OVERALL, mapNewRevTerms.get(newRevTerm).Revenue_SBU__c);
                        //system.debug('Checking new Quota ID-------------------->'+newQtId);
                         
                         if(null != mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c){
						 newQtIdPdt = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c), revOpportunityOwnerMap.get(newRevTerm) ,String.valueOf(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c), String.valueOf(mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c),  mapNewRevTerms.get(newRevTerm).Revenue_SBU__c );
						 }
						  diffMonthFlag = true;
                         system.debug('Revenue month and year are different. Quota ID for  New Actual Revenue Recognized date  newQtId :'+ newQtId +'newQtIdPdt : '+newQtIdPdt +'actualRecId : '+ actualRecId +'actualPrdtRecId : '+ actualPrdtRecId);
                     }
                    
						Actual_Detail__c tempActDetbj = new Actual_Detail__c(); 
						Actual_Detail__c tempActDetobjPdt = new Actual_Detail__c(); 						
                        tempActDetbj.id = actualRecId;
                     // system.debug('Actual Record Id------------>'+ actualRecId);
                        tempActDetbj.Actual_Revenue_Date__c = mapNewRevTerms.get(newRevTerm).Revenue_Date__c;
						
						tempActDetobjPdt.id = actualPrdtRecId;
						tempActDetobjPdt.Actual_Revenue_Date__c = mapNewRevTerms.get(newRevTerm).Revenue_Date__c;
						
                 if(!diffMonthFlag){
							if(null != tempActDetbj.id){
								actObjListToUpdate.add(tempActDetbj);
							}
							if(null != tempActDetobjPdt.id){
								actObjListToUpdate.add(tempActDetobjPdt);
							}
							
							
						  }else{
							if(newQtId != null){
							   // system.debug('111 - A Setting New Quota Id for Actual :'+ newQtId);
								tempActDetbj.QuotaDetail__c = newQtId;
								actObjListToUpdate.add(tempActDetbj);
                        }else{
							//system.debug('Adding revenue term without quota : ' + newRevTerm);
							revenueTermWithoutQuota.add(newRevTerm);
							//system.debug('Adding Actual ids to delete : ' + actualRecId);
							revIdsToDelete.add(actualRecId);
						}
						
						if(newQtIdPdt != null){
                       //   system.debug('111 - B Setting New Quota Id for Actual Product :'+ newQtIdPdt);
                            tempActDetobjPdt.QuotaDetail__c = newQtIdPdt;
							actObjListToUpdate.add(tempActDetobjPdt);
                        }else{
								system.debug('Adding Actual ids of product to delete : ' + actualPrdtRecId);
								revIdsToDelete.add(actualPrdtRecId);
						}
						}
                   
                         system.debug('updated Actual object list to udpate :' +actObjListToUpdate );
                                      
                }else if(mapNewRevTerms.get(newRevTerm).Recognized_Amount__c != mapOldRevTerms.get(newRevTerm).Recognized_Amount__c){
                    system.debug('Only revenue recognized amount is changed. So inserting a new row for this revenue id to capture different date');
                    //checking if month and year are same 
                    if(mapNewRevTerms.get(newRevTerm).Revenue_Month__c == mapOldRevTerms.get(newRevTerm).Revenue_Month__c && mapNewRevTerms.get(newRevTerm).Revenue_Year__c == mapOldRevTerms.get(newRevTerm).Revenue_Year__c){
                        //Since old and new month,year are same , Updating the exisiting Actual detail row.
                      //  actObjListToUpdate = prepareActualObjToUpdate_Old(actualRecId, newRevTerm, true, revOpportunityOwnerMap);
						//This call is for Overall rev actual data
						if(null != actualRecId){
                    	actObjListToUpdate.add(prepareActualObjToUpdate(actualRecId, newRevTerm, OVERALL, false, revOpportunityOwnerMap));
						}
						//this call is for product 
						if(null != actualPrdtRecId){
							actObjListToUpdate.add(prepareActualObjToUpdate(actualPrdtRecId, newRevTerm, mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c, false, revOpportunityOwnerMap));
						}
                    	//actObjListToUpdate = prepareActualObjToUpdate(actualRecId, newRevTerm, true, revOpportunityOwnerMap);
                     	system.debug('Actual Object to update after processing :'+ actObjListToUpdate);
						
						
                    } /*  Commenting this code as its not required for now. This is functionality for creating a new actual with current date as the revenue date. Used for partial rev recog on date and remaining on other date
					else{
                     //  system.debug('**** 1 -Calling getQuotaIdForActual : Old and new month  , year are different , so inserting new actual row with current date as revenue recognised date ' + revOpportunityOwnerMap.get(newRevTerm));
                        //CAll for revenue's pdt
                        Id newQtIdForPdt = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c), revOpportunityOwnerMap.get(newRevTerm), String.valueOf(mapNewRevTerms.get(newRevTerm).	Product_Type_Rev__c));
						//	system.debug(' 1 - New Prodced based quota Id ' + newQtIdForPdt);
                    	if(null != newQtIdForPdt){
                            qtActualtoInsert = new Actual_detail__c();
                            
                            qtActualtoInsert.Actual_Revenue_Date__c = date.today();
                        
                            if(mapOldRevTerms.get(newRevTerm).Recognized_Amount__c == null){
                             	qtActualtoInsert.Actual_Revenue_RecognizedAmount__c = mapNewRevTerms.get(newRevTerm).Recognized_Amount__c;
                        	}else{
                            	qtActualtoInsert.Actual_Revenue_RecognizedAmount__c =  mapNewRevTerms.get(newRevTerm).Recognized_Amount__c - mapOldRevTerms.get(newRevTerm).Recognized_Amount__c;
                        	}
                                qtActualtoInsert.QuotaDetail__c = newQtIdForPdt;
                                qtActualtoInsert.RevenueTermRef__c = newRevTerm;
                            	//qtActualtoInsert.CurrencyIsoCode = corporateCurrency;
                                actObjListToInsert.add(qtActualtoInsert);
                    // Normal Flow for overall quota
                    	    
							}else{
							 // TODO: create new quota with zero quota amout for that month.
								//system.debug('*** 1A - Preparing Quota Master record for revenue : ' + newRevTerm);
								revenueTermWithoutQuota.add(newRevTerm);
							}
                        //call for OVERALL
							Id newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), OVERALL);
							//system.debug('New Overall Quota object ' + newQtId);
							if(null != newQtId){
								qtActualtoInsert = new Actual_detail__c();
                            
								qtActualtoInsert.Actual_Revenue_Date__c = date.today();
                        
								if(mapOldRevTerms.get(newRevTerm).Recognized_Amount__c == null){
									qtActualtoInsert.Actual_Revenue_RecognizedAmount__c = mapNewRevTerms.get(newRevTerm).Recognized_Amount__c;
									}else{
										qtActualtoInsert.Actual_Revenue_RecognizedAmount__c =  mapNewRevTerms.get(newRevTerm).Recognized_Amount__c - mapOldRevTerms.get(newRevTerm).Recognized_Amount__c;
                        	}
									qtActualtoInsert.QuotaDetail__c = newQtId;
									qtActualtoInsert.RevenueTermRef__c = newRevTerm;
									//qtActualtoInsert.CurrencyIsoCode = corporateCurrency;
									actObjListToInsert.add(qtActualtoInsert);
                        
                    	}else{
                         // TODO: create new quota with zero quota amout for that month.
                         //	system.debug('*** Preparing Quota Master record for revenue : ' + newRevTerm);
                         	revenueTermWithoutQuota.add(newRevTerm);
                            //prepareNewQuotaMaster(newRevTerm, revOpportunityOwnerMap.get(newRevTerm));
                        	//actObjListToInsert.add(createActualWithQuota(newRevTerm, getQuotaIdForActual(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm))));
                    		}
                    	}*/
                }else{system.debug('Nothing important changed in revenue');}
                }else{ //********************************************************************
                
                //insert actual object flow - No Actual Detail available Flow
                //system.debug('Actual Detail Not available for  Month '+ mapNewRevTerms.get(newRevTerm).Revenue_Month__c +' ---> revenue year'+mapNewRevTerms.get(newRevTerm).Revenue_Year__c +'-->Oppor Owner--->'+ revOpportunityOwnerMap.get(newRevTerm));
                //system.debug('Revenue Product Code A::  ' + mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c);
				//system.debug('Calling getQuotaIdForActual from New Actual insert flow. New quota Id - Main flow' + getProductCodeFromProduct(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c));
               	 Id newQtId ;
				 Id newPdtQtId;
				
				//IF(getProductCodeFromProduct(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c).equalsIgnoreCase(OVERALL)){
					//system.debug('OVERALL PRODUCT ---> 1 ');
					 // newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), OVERALL);
				
				//}else{
					//system.debug('OVERALL PRODUCT ---> 2');
					newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), OVERALL, OVERALL, mapNewRevTerms.get(newRevTerm).Revenue_SBU__c );
					
					if(null != mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c){
					newPdtQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), String.valueOf(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c), String.valueOf(mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c),  mapNewRevTerms.get(newRevTerm).Revenue_SBU__c  );				
					}
				
				//}
             //  system.debug('This is insert flow===================>');
				//system.debug('New quota Id ' + newQtId);
				//system.debug('New Product quota Id ' + newPdtQtId);
                //Check if there's quota set for this sales person , for this financial year- 
            	//if its set then create new Actual detail with this quota detail id	
            	//if(null != newQtId || null != newPdtQtId ){
				if(null != newQtId){
                 	//system.debug('quota details available . So creating new actual row and inserting it : ' + newQtId);
					//system.debug('Overall pdt Quota Detail avaiable . So adding this rev to rev withoutquota : newQtId ' + newQtId) ;
                    //TODO
                    actObjListToInsert.add(createActualWithQuotaPdt(newRevTerm,newQtId));
						if(null != newPdtQtId){
							 //system.debug('Actual Obj preparation for Product: ' + mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c );	
							actObjListToInsert.add(createActualWithQuotaPdt(newRevTerm,newPdtQtId));
						}
                	}else {
                      // Actual Detail and Quota Detail not available.
                      // create new quota with zero quota amount for that month and then create the actual detail row.
                      // Id repId, Date sp, Date ep, String qPeriod, String currCode
						//system.debug('Quota Detail not avaiable. So adding this rev to rev withoutquota');
                     	revenueTermWithoutQuota.add(newRevTerm);
					
					}
					 system.debug('Actual Object prepared to insert: ' + actObjListToInsert);	
				//}
   		 }
		 //system.debug('End ****************************Iterating for  :  ' + mapNewRevTerms.get(newRevTerm).name );
		}
    }else if(Trigger.isDelete && Trigger.isBefore) {
         //system.debug('In QVA Delete Trigger');
        // list<id> revIdsToDelete = new list<id>();
         for (ID newRevTerm : mapOldRevTerms.keySet()) {
             revIdsToDelete.add(newRevTerm);
         }
        removeRevenuesFromActualDetails(revIdsToDelete);
    }
		
        
        if(null != revenueTermWithoutQuota && revenueTermWithoutQuota.size() > 0){
			//system.debug('prepareNewQuotaMaster for quota not available revenue data' + revenueTermWithoutQuota);	
            prepareNewQuotaMaster(revenueTermWithoutQuota);
			//system.debug('prepareNewQuotaMaster Done- Create QVA Records now');	            	
           	createQVAforWithoutQuotaRecords(revenueTermWithoutQuota);
            //system.debug('Create QVA Records - Done');	            	
            
		}
        
		
         if(actObjListToInsert.size() > 0){
            try{
                    system.debug('Inserting Actual detail obj list' + actObjListToInsert);
                  	insert actObjListToInsert;
                	}Catch(DMLexception dmle){
                    //system.debug('Error while Updating Subsequent Billing dates' + dmle); 
                }
         }
        if(actObjListToUpdate.size() > 0){
                try{
                     system.debug('Actual detail obj list size : ' + actObjListToUpdate.size());
               	  	 //system.debug('Update Query to update Actual detail obj list' + actObjListToUpdate);
                	 update actObjListToUpdate;
                    	 system.debug('Update Query to update Actual detail obj list' + actObjListToUpdate);
               }Catch(DMLexception dmle){
                    //system.debug('Error while Updating Actual Object ' + dmle); 
                }
    		}
			if(null != revIdsToDelete){
				removeActualsFromActualDetails(revIdsToDelete);
			}
        //Reseting the flag
        //revIdToResetFlag
        if(null != revIdToResetFlag){
            List<Revenue_Term__c> revListToUpdate = new List<Revenue_Term__c>();
            Revenue_Term__c revTerm = new Revenue_Term__c();
            	revTerm.id = revIdToResetFlag;
            	revTerm.Shift_Subsequent_Revenue_Dates__c = false;
            revListToUpdate.add(revTerm);
            //system.debug('------------------------- Revenue Term ID to Reset the flag :  ' + revListToUpdate);
            blnAlreadyInsideTrigger = true;
            update revListToUpdate;
            blnAlreadyInsideTrigger = false;
         }
         
    }
    
	
	// New Method : To prepare actual object mapping with the respective quota Id
	
     public  Actual_Detail__c   prepareActualObjToUpdate(Id actualId, id newRevTerm, String pdtType, boolean onlyRevRecogAmtChange, Map<ID, ID> revOpportunityOwnerMap){
        //List<Actual_Detail__c> actObjListToUpdate = new List<Actual_Detail__c>();
        Actual_Detail__c actObjListTemp = new Actual_Detail__c();
        Id newQtId ;
      		actObjListTemp.id = actualId;
         	actObjListTemp.Actual_Revenue_Date__c = mapNewRevTerms.get(newRevTerm).Revenue_Date__c;
            actObjListTemp.Actual_Revenue_RecognizedAmount__c = mapNewRevTerms.get(newRevTerm).Recognized_Amount__c;
         	
         	actObjListTemp.Is_Huringa__c = isHuringaPdt(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c) ;
			actObjListTemp = appendIncentiveRevToActualRec(actObjListTemp, newRevTerm);
			
            if(!onlyRevRecogAmtChange){
				 //system.debug('Getting new quota id for :' +mapNewRevTerms.get(newRevTerm).Revenue_Month__c + '--'+ mapNewRevTerms.get(newRevTerm).Revenue_Year__c +'--'+ getProductCodeFromProduct(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c));
				 if(pdtType.equalsIgnoreCase(OVERALL)){
					
					newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), OVERALL, OVERALL, mapNewRevTerms.get(newRevTerm).Revenue_SBU__c );
				 
				 }else{
				 
					newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(newRevTerm), String.valueOf(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c), String.valueOf(mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c), mapNewRevTerms.get(newRevTerm).Revenue_SBU__c );
				}
				// newQtId = getQuotaIdForActual(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c), revOpportunityOwnerMap.get(newRevTerm));
            }
            if(newQtId != null ){
            //    //system.debug('Setting New Quota Id for Actual :'+ newQtId);
                actObjListTemp.QuotaDetail__c = newQtId;
            }                         
          //  actObjListToUpdate.add(actObjListTemp);
            //system.debug('Returning prepared actual object to udpate :' + actObjListTemp );
        return actObjListTemp;
    }
    
    public boolean isHuringaPdt(String productName){
         //system.debug('Revenue Product Code ::  ' + productName);
		String pdtType = getProductCodeFromProduct(productName);
        IF(null != pdtType && pdtType.equalsIgnoreCase(ASYMMETRIX)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(RETINA)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(DROPTHOUGHT)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(PULSE)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(CUETRACK)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(CUETRANS)){
            return true;
        }else if(null != pdtType && pdtType.equalsIgnoreCase(GEODATAFY)){
            return true;
        }else if(null == pdtType || pdtType.equalsIgnoreCase('') || pdtType.equalsIgnoreCase('OVERALL')){
            return false;
        }
        
        return false;
        
    }
    
    public void createQVAforWithoutQuotaRecords(List<ID> revenueTermWithoutQuota){
        
			   //insert actual object flow
               
        		//system.debug('Repopulating Quota ids that have been created now');
        		rePopulateQuotaIdsForActuals();
				//system.debug('Iterating through the  revenueTermWithoutQuota List' + revenueTermWithoutQuota.size());
        		for(ID revTerm : revenueTermWithoutQuota){
                     //system.debug('new revenue obj month '+mapNewRevTerms.get(revTerm).Revenue_Month__c +'---> revenue year'+mapNewRevTerms.get(revTerm).Revenue_Year__c +'-->Oppor Owner--->'+ revOpportunityOwnerMap.get(revTerm) +'  Product from Rev Term : '+ mapNewRevTerms.get(revTerm).Product_Type_Rev__c + '-- Getting Product Key is  : '+ getProductCodeFromProduct(mapNewRevTerms.get(revTerm).Product_Type_Rev__c));
            		
					Id newPdtQtId;
					
					Id newQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(revTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(revTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(revTerm), OVERALL, OVERALL, mapNewRevTerms.get(revTerm).Revenue_SBU__c );
				
					if(null != mapNewRevTerms.get(revTerm).Product_Type_Rev__c)	{
					newPdtQtId = getQuotaIdForActualProduct(Integer.valueOf(mapNewRevTerms.get(revTerm).Revenue_Month__c), Integer.valueOf(mapNewRevTerms.get(revTerm).Revenue_Year__c),  revOpportunityOwnerMap.get(revTerm), String.valueOf(mapNewRevTerms.get(revTerm).Product_Type_Rev__c) ,String.valueOf(mapNewRevTerms.get(revTerm).Competency_in_Revenue__c), mapNewRevTerms.get(revTerm).Revenue_SBU__c );
					 }
									
					//system.debug('New quota Id --> ' + newQtId);
                    if(null != newQtId ){
                 	//system.debug('quota details available . So creating new actual row and adding it to Actaul insert list : ' + newQtId);
                    //TODO
                   	  	actObjListToInsert.add(createActualWithQuotaPdt(revTerm,newQtId));
						//system.debug('Actual object added to insert : '+ actObjListToInsert);
                	}else {
                      
                	}
					
					if(null != newPdtQtId ){
                 	//system.debug('Product quota details available . So creating new actual row and inserting it : ' + newPdtQtId);

                     actObjListToInsert.add(createActualWithQuotaPdt(revTerm,newPdtQtId));
                	
                	}else {
					//This else part is not possible because all the missing quotas are created.
					}
					
        		}
                //system.debug('createQVAforWithoutQuotaRecords actObjListToInsert : '+ actObjListToInsert);
				
                //Check if there's quota set for this sales person , for this financial year- 
            	//if its set then create new Actual detail with this quota detail id	
    }
  
  
		public Actual_detail__c appendIncentiveRevToActualRec(Actual_detail__c qtActualObj, Id newRevTmId ){
			 Map<String, Integer> ICRevMap = new map<String, Integer>();
			 ICRevMap = calnGroupRevForIncetive(newRevTmId);
			 //system.debug('Actual Object Supplied :' + qtActualObj); 
			 qtActualObj.BCT_IP_L0_L0_X_Rev_WF__c = ICRevMap.get('BCTIPL0L0X') != null ? ICRevMap.get('BCTIPL0L0X'): 0;
			 qtActualObj.BCT_IP_L1_Rev_WF__c = ICRevMap.get('BCTIPL1') != null ? ICRevMap.get('BCTIPL1'): 0;
			 qtActualObj.BCT_IP_L2_L3_Rev_WF__c = ICRevMap.get('BCTIPL2L3') != null ? ICRevMap.get('BCTIPL2L3'): 0;
			 
			 qtActualObj.BCT_Digital_TIBCO_Svcs_L0_L0_X_Rev__c = ICRevMap.get('BCTDigiTibcoSvcsL0L0X') != null ? ICRevMap.get('BCTDigiTibcoSvcsL0L0X'): 0;
			 qtActualObj.BCT_Digital_TIBCO_Svcs_L1_Rev__c = ICRevMap.get('BCTDigiTibcoSvcsL1') != null ? ICRevMap.get('BCTDigiTibcoSvcsL1'): 0;
			 qtActualObj.BCT_Digital_TIBCO_Svcs_L2_L3_Rev__c = ICRevMap.get('BCTDigiTibcoSvcsL2L3') != null ? ICRevMap.get('BCTDigiTibcoSvcsL2L3'): 0;
			 
			 qtActualObj.BCT_C_F_Ent_Svcs_L0_L0_X_Rev__c = ICRevMap.get('BCTCFENTSvcsL0') != null ? ICRevMap.get('BCTCFENTSvcsL0'): 0;
			 qtActualObj.BCT_C_F_Ent_Svcs_L1_Rev__c = ICRevMap.get('BCTCFENTSvcsL1') != null ? ICRevMap.get('BCTCFENTSvcsL1'): 0;
			 qtActualObj.BCT_C_F_Ent_Svcs_L2_L3_Rev__c = ICRevMap.get('BCTCFENTSvcsL2L3') != null ? ICRevMap.get('BCTCFENTSvcsL2L3'): 0;
			 
			 qtActualObj.TIBCO_Product_License_L0_L0_X_Rev__c = ICRevMap.get('TibcoPdtLicL0L0X') != null ? ICRevMap.get('TibcoPdtLicL0L0X'): 0;
			 qtActualObj.TIBCO_Product_License_L1_Rev__c = ICRevMap.get('TibcoPdtLicL1') != null ? ICRevMap.get('TibcoPdtLicL1'): 0;
			 qtActualObj.TIBCO_Product_License_L2_L3_Rev__c = ICRevMap.get('TibcoPdtLicL2L3') != null ? ICRevMap.get('TibcoPdtLicL2L3'): 0;
			 
			 qtActualObj.Professional_Services_L0_L0_X_Rev_WF__c = ICRevMap.get('PSL0L0X') != null ? ICRevMap.get('PSL0L0X'): 0;
			 qtActualObj.Professional_Services_L1_Rev_WF__c = ICRevMap.get('PSL1') != null ? ICRevMap.get('PSL1'): 0;
			 qtActualObj.Professional_Services_L2_L3_Rev_WF__c = ICRevMap.get('PSL2L3') != null ? ICRevMap.get('PSL2L3'): 0;
			 
			 qtActualObj.SI_Products_L0_L0_X_Rev_WF__c = ICRevMap.get('SIPRODUCTSL0') != null ? ICRevMap.get('SIPRODUCTSL0'): 0;
			 qtActualObj.SI_Products_L1_Rev_WF__c = ICRevMap.get('SIPRODUCTSL1') != null ? ICRevMap.get('SIPRODUCTSL1'): 0;
			 qtActualObj.SI_Products_L2_L3_Rev_WF__c = ICRevMap.get('SIPRODUCTSL2L3') != null ? ICRevMap.get('SIPRODUCTSL2L3'): 0;
			 
			 system.debug('Append Actual Object with Qualifiers Revs :' + qtActualObj); 
			 
		 return qtActualObj;
			
  }
  
	
	 public Actual_detail__c createActualWithQuotaPdt(Id newRevTerm, Id newQtaId){
        //system.debug('create Actual With Quota info :' + newRevTerm +'-- new Quota Id :'+newQtaId); 
	    Actual_detail__c qtActual = new Actual_detail__c();	
        qtActual.Actual_Revenue_Date__c = mapNewRevTerms.get(newRevTerm).Revenue_date__c;
        qtActual.Actual_Revenue_RecognizedAmount__c = mapNewRevTerms.get(newRevTerm).Recognized_Amount__c;
        qtActual.QuotaDetail__c = newQtaId;
        qtActual.Is_Huringa__c = (null != mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c && mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c.equalsIgnoreCase('none') ? isHuringaPdt(mapNewRevTerms.get(newRevTerm).Competency_in_Revenue__c) : isHuringaPdt(mapNewRevTerms.get(newRevTerm).Product_Type_Rev__c)) ;
        qtActual.RevenueTermRef__c = newRevTerm;
        qtActual.CurrencyIsoCode = mapNewRevTerms.get(newRevTerm).CurrencyIsoCode;
		qtActual = appendIncentiveRevToActualRec(qtActual, newRevTerm);
		
		// Adding incentive revenues
		//qtActual.CurrencyIsoCode = mapNewRevTerms.get(newRevTerm).CurrencyIsoCode;
		
		//system.debug('++++++++++ Returning new quota Actual information' + qtActual); 
        return qtActual;
    }
    
   /* Public Double overallRevAmount { get;set; }
    Public Double recognizedAmount { get;set; }
    Public Double totalRawRev { get;set; }
    Public Double wAvgTotalRev { get;set; }
    Public String probabilityRev { get;set; }*/
    
     
    
    public Integer getfunnelRevenue (Id newRevTermId){
		 Decimal recognizedAmount = mapNewRevTerms.get(newRevTermId).Recognized_Amount__c ;
		 Decimal wAvgTotalRev;
		 Integer overallRevAmount ;
		 Decimal lineItemAmount = mapNewRevTerms.get(newRevTermId).Opp_Line_Amount__c ;
         system.debug('line item amount ------>'+lineItemAmount);
       
        String milestoneBasis = mapNewRevTerms.get(newRevTermId).Milestone_Basis__c ;
        if(milestoneBasis == 'Fixed Amount'){
         overallRevAmount =( null == recognizedAmount  ? Integer.valueOf(mapNewRevTerms.get(newRevTermId).Percentage__c) :  0 );  

        }
        else  if(milestoneBasis == '%')
        {
          overallRevAmount =( null == recognizedAmount  ? Integer.valueOf((mapNewRevTerms.get(newRevTermId).Percentage__c)/100 * lineItemAmount):  0 );

         }

        Decimal totalRawRev = overallRevAmount + ( null != recognizedAmount ? recognizedAmount : 0  ) ;
        Decimal revProbability = Integer.valueOf(mapNewRevTerms.get(newRevTermId).Probability_In_Rev__c);
        String revStage  = mapNewRevTerms.get(newRevTermId).Opp_Stage_Rev__c; 

		wAvgTotalRev = !revStage.equalsIgnoreCase('Hold') && !revStage.equalsIgnoreCase('Closed Lost')  ? (revProbability /100) * totalRawRev : 0;   
		return integer.valueOf(wAvgTotalRev);   
     
    }
  
    
    public Map<String, Integer> calnGroupRevForIncetive(Id newRevTermId){
				
			String incetiveQualifer = mapNewRevTerms.get(newRevTermId).Incentive_Category__c;
			String customerCategory = mapNewRevTerms.get(newRevTermId).Customer_Type__c;
			String revFunnelCode = mapNewRevTerms.get(newRevTermId).Funnel_Code_Rev__c;
			Date OppCloseDate =  mapNewRevTerms.get(newRevTermId).Opp_Close_Date__c;
			Date milestoneDate =  mapNewRevTerms.get(newRevTermId).Revenue_Date__c;
			system.debug('Incentive module -->incetiveQualifer :- ' + incetiveQualifer + ' customerCategory :- '+customerCategory+'-revFunnelCode :- '+revFunnelCode+'--OppCloseDate :- '+OppCloseDate+'-milestoneDate :- '+milestoneDate);
			Map<String, Integer> incetiveRevMap = new Map<String, Integer>();
       if(null != incetiveQualifer){	
	   if(incetiveQualifer.equalsIgnoreCase(BCTIP) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('BCTIPL0L0X', getfunnelRevenue(newRevTermId));
           system.debug('BCTIP L0 revenue :'+getfunnelRevenue(newRevTermId));
           
		}else if(incetiveQualifer.equalsIgnoreCase(BCTIP) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('BCTIPL1',  getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(BCTIP) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('BCTIPL2L3',  getfunnelRevenue(newRevTermId));
        }
        else if(incetiveQualifer.equalsIgnoreCase(DIGITIBCOSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('BCTDigiTibcoSvcsL0L0X', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(DIGITIBCOSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('BCTDigiTibcoSvcsL1', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(DIGITIBCOSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('BCTDigiTibcoSvcsL2L3', getfunnelRevenue(newRevTermId));
        }
        else if(incetiveQualifer.equalsIgnoreCase(BCTCFENTSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('BCTCFENTSvcsL0', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(BCTCFENTSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('BCTCFENTSvcsL1',  getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(BCTCFENTSVCSEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('BCTCFENTSvcsL2L3',  getfunnelRevenue(newRevTermId));
        }
        
        else if(incetiveQualifer.equalsIgnoreCase(PS) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('PSL0L0X', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(PS) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('PSL1',  getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(PS) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('PSL2L3',  getfunnelRevenue(newRevTermId));
        }
        else if(incetiveQualifer.equalsIgnoreCase(SIPRODUCTS) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('SIPRODUCTSL0', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(SIPRODUCTS) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('SIPRODUCTSL1',  getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(SIPRODUCTS) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('SIPRODUCTSL2L3',  getfunnelRevenue(newRevTermId));
        }
		else if(incetiveQualifer.equalsIgnoreCase(TIBCOPRODUCTLICENSEEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L0') || revFunnelCode.equalsIgnorecase('L0-X'))){
			incetiveRevMap.put('TibcoPdtLicL0L0X', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(TIBCOPRODUCTLICENSEEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L1'))){
			incetiveRevMap.put('TibcoPdtLicL1', getfunnelRevenue(newRevTermId));
		}else if(incetiveQualifer.equalsIgnoreCase(TIBCOPRODUCTLICENSEEXECUTIVE) &&(revFunnelCode.equalsIgnorecase('L2') || revFunnelCode.equalsIgnorecase('L3'))){
            incetiveRevMap.put('TibcoPdtLicL2L3',  getfunnelRevenue(newRevTermId));
        }
		
    }
	
	system.debug('incetiveRevMap : ' + incetiveRevMap);
	return incetiveRevMap;
	}
    
/*	public boolean isOppCloseDateInSameFY(Date oppCloseDate, Date milestoneDate){
			Date currrDate = milestoneDate;
			String currFYPeriod;
			String closeDateFYPeriod;
			String startFY;
			String endFY;
			Integer currMonth = currrDate.month();
			Integer currYear =  currrDate.year();
			Integer closeDateMonth = oppCloseDate.month();
			Integer closeDateYear =  currrDate.year();
			
			 
			if(currMonth > 3 ){
						startFY = String.valueOf(currYear);
						endFY = String.valueOf(currYear + 1);
					
					}else{
						startFY = String.valueOf(currYear -1);
						endFY = String.valueOf(currYear);
					}
					
					currFYPeriod = startFY +'-'+ endFY;
					system.debug('fyPeriod current year: ' + currFYPeriod);
					
			if(closeDateMonth > 3 ){
						startFY = String.valueOf(closeDateYear);
						endFY = String.valueOf(closeDateYear + 1);
					
					}else{
						startFY = String.valueOf(closeDateYear -1);
						endFY = String.valueOf(closeDateYear);
					}
					
					closeDateFYPeriod = startFY +'-'+ endFY;
					system.debug('fyPeriod opp close date : ' + closeDateFYPeriod);
			
			system.debug('isOppCloseDateInSameFY  -->MilestoneDate :- ' + currrDate + ' currFYPeriod :- '+currFYPeriod+' -closeDateFYPeriod :- '+closeDateFYPeriod +' Is same FY :'+closeDateFYPeriod.equalsIgnoreCase(currFYPeriod));
			
			return closeDateFYPeriod.equalsIgnoreCase(currFYPeriod);
			
	}*/
	
    public Id getQuotaIdForActualProduct(Integer revMonth, Integer revYear, String quotaOwner, String product, String competency, String revSbu){
        Id quotaIdforActual;
//        List<QuotaDetail__c> qtDetailObjs = [SELECT ID, NAME, Quota_Amount__c, Quota_Date__c, QuotaMasterNew__r.id from QuotaDetail__c where Quota_Month__c=:revMonth and QuotaYear__c =:revYear and QuotaMasterNew__r.Quota_Owner_Name__r.id=:quotaOwner];
		String tempPdtOrCompetency = (null != product && product.equalsIgnoreCase('none')) ? competency : product;
						  
		String pdt = getProductCodeFromProduct(tempPdtOrCompetency);  
		if(null != pdt)	{	
		//system.debug('*** 1- product to Get quota detail id :' + product +'  is -->' +pdt );
        String QuotaKey = quotaOwner+revMonth+revYear+pdt+revSbu;
       // system.debug('*** 2- Quota Key to Get quota detail id :' +QuotaKey );
        if(null != actIdKeyToPrdtQtaDetIdMap && actIdKeyToPrdtQtaDetIdMap.size() > 0 ){
            quotaIdforActual = actIdKeyToPrdtQtaDetIdMap.get(QuotaKey);
            if(null!= quotaIdforActual ){
               // system.debug('*** 3- Returning new quota detail id for :' +QuotaKey  +'Quota ID : '+quotaIdforActual);
						return	quotaIdforActual;
						} 
					}
				}
        		return null;
            }
			

    

     public void rePopulateQuotaIdsForActuals(){
        Id quotaIdforActual;
         if(null == actIdToQuotaDetailIdMap || actIdToQuotaDetailIdMap.size() <= 0){
            actIdToQuotaDetailIdMap = new Map<String, ID>(); 
			actIdKeyToPrdtQtaDetIdMap = new Map<String, ID>();
         }
       
        system.debug('Printing newowner ids : ' + newOwnerIds +' Years : '+ newRevYears +' Months: '+ newRevMonths);  
        List<QuotaDetail__c> qtDetailObjs = [select Id, Quota_Date__c, Quota_month__c,QuotaMasterNew__r.SBU__C, QuotaYear__c,QuotaMasterNew__r.id, QuotaMasterNew__r.Quota_Owner_Name__r.id, Quota_Amount__c , QuotaKey__c, Product_Type_QDET__c from QuotaDetail__c 
        where 
        (QuotaMasterNew__r.Quota_Owner_Name__r.id = :newOwnerIds and
        Quota_Month__c in :newRevMonths and QuotaYear__c in :newRevYears and 
		Product_Type_QDET__c in ('ASYMMETRIX', 'RETINA', 'CUETRACK','CUETRANS','DROPTHOUGHT','PULSE','GEODATAFY','OVERALL'))
        order by QuotaMasterNew__r.Quota_Owner_Name__r.id, Quota_Date__c];
        
		system.debug('Quota Details for Quota month, year and owner  : ' + qtDetailObjs);        
        if(qtDetailObjs != null && qtDetailObjs.size()>0){
          
            for(QuotaDetail__c eachQdet : qtDetailObjs){
                    quotaIdforActual = eachQdet.id;
                    String tempQKey = String.valueOf(eachQdet.QuotaMasterNew__r.Quota_Owner_Name__r.id) + String.valueOf(eachQdet.Quota_month__c) + String.valueOf(eachQdet.QuotaYear__c);
                    actIdToQuotaDetailIdMap.put(tempQKey , eachQdet.Id );
					
					String tempQKeyPdt = String.valueOf(eachQdet.QuotaMasterNew__r.Quota_Owner_Name__r.id) + String.valueOf(eachQdet.Quota_month__c) + String.valueOf(eachQdet.QuotaYear__c)+String.valueOf(eachQdet.Product_Type_QDET__c)+ eachQdet.QuotaMasterNew__r.SBU__C;
					actIdKeyToPrdtQtaDetIdMap.put(tempQKeyPdt, eachQdet.Id);
            	}
                        }
        system.debug('Actual to Quota Details map   : ' + actIdToQuotaDetailIdMap);  
     //   return quotaIdforActual;
         
        
    }
    
	// This method will create the new quota for sales person if its not creted yet.
	
    public void prepareNewQuotaMaster(List<ID> revenueTermWithoutQuota){
        //Id repId = mapNewRevTerms.get(newRevTerm).CreatedById;
        Date sp;
        Date ep;
		List<String> quotaMasterDetailsList;
		Map<String, List<String>> quotaMasterList = new Map<String, List<String>>();
		for(ID newRevTerm : revenueTermWithoutQuota){
		
					if(mapNewRevTerms.get(newRevTerm).Revenue_Month__c >=4 ){
						sp = getStartDatePeriod(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c));
						ep = getEndDatePeriod(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c) + 1);
					}else{
						sp = getStartDatePeriod(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c) -1);
						ep = getEndDatePeriod(Integer.valueOf(mapNewRevTerms.get(newRevTerm).Revenue_Year__c)) ;
						}
				String qPeriod = String.valueOf(sp.year())+'-'+String.valueOf(ep.year());
				String curCode =  'USD';
			//  system.debug('Create new quota master values Owner ID : '+revOpportunityOwnerMap.get(newRevTerm) +'Start: '+sp+' End :'+ep+' qperiod :'+qPeriod+' curCode : '+ curCode);
				quotaMasterDetailsList = new List<String>();
				quotaMasterDetailsList.add(revOpportunityOwnerMap.get(newRevTerm));
				quotaMasterDetailsList.add(String.valueOf(sp));
				quotaMasterDetailsList.add(String.valueOf(ep));
				quotaMasterDetailsList.add(qPeriod);
				quotaMasterDetailsList.add(curCode);
				quotaMasterDetailsList.add(oppOwnerIDToMangerId.get(revOpportunityOwnerMap.get(newRevTerm)));
				String tempKey =  String.valueOf(revOpportunityOwnerMap.get(newRevTerm))+'~'+ qPeriod;
				quotaMasterList.put(tempKey, quotaMasterDetailsList);
				
			}
				  createQuotaMaster(quotaMasterList);
       	}    
	
	
	  public void createQuotaMaster(Map<String, List<String>> QuotaMasterMapToInsert){
        //system.debug('Preparing Quota master record To insert  : '+QuotaMasterMapToInsert);
         List<QuotaMasterNew__c> qmToInsert = new List<QuotaMasterNew__c>();
         Set<ID> quotaOwnerIds = new Set<ID>();
          Set<Date> startPeriods = new Set<Date>();
          Set<Date> endPeriods = new Set<Date>();
          for(List<String> qMasterKey : QuotaMasterMapToInsert.values()){
              for(String eachKey : qMasterKey){
                    // //system.debug('Quota Master each Key  : '+eachKey);
                  
              		}
                 //system.debug('Quota Master Key  : '+qMasterKey);
                 QuotaMasterNew__c qmNew  = new QuotaMasterNew__c();
                  	qmNew.SBU__c = getUsersSBU(qMasterKey[0]);
                    qmNew.Quota_Start_Period__c = Date.valueOf(qMasterKey[1]);
                    qmNew.Quota_End_Period__c = Date.valueOf(qMasterKey[2]);
                    qmNew.Quota_Owner_Name__c = qMasterKey[0];
					qmNew.OwnerId = qMasterKey[0];
                    qmNew.Quota_Period__c = qMasterKey[3];
                    qmNew.CurrencyIsoCode = qMasterKey[4];
					qmNew.Quota_Owner_Manager__c =qMasterKey[5]; 
					qmNew.Product_Type__c = OVERALL;
                   // //system.debug('Adding Quota Master To insert  : '+qmNew);
                  	qmToInsert.add(qmNew);
             		quotaOwnerIds.add(qMasterKey[0]);
              		startPeriods.add(Date.valueOf(qMasterKey[1]));
              		endPeriods.add(Date.valueOf(qMasterKey[2]));
					
					
			for(String eachProduct : productType ){
					QuotaMasterNew__c qmNew1  = new QuotaMasterNew__c();
					qmNew1.SBU__c = getUsersSBU(qMasterKey[0]);
					qmNew1.Quota_Start_Period__c = Date.valueOf(qMasterKey[1]);
					qmNew1.Quota_End_Period__c = Date.valueOf(qMasterKey[2]);
					qmNew1.Quota_Owner_Name__c = qMasterKey[0];
					qmNew1.OwnerId = qMasterKey[0];
					qmNew1.Quota_Period__c = qMasterKey[3];
					qmNew1.CurrencyIsoCode = qMasterKey[4];
					qmNew1.Quota_Owner_Manager__c =qMasterKey[5]; 
					qmNew1.Product_Type__c = eachProduct;
				
					qmToInsert.add(qmNew1);
				}
              
          		}
          		//system.debug('Quota Details Prepared : '+ quotaOwnerIds + ' Start periods : '+ startPeriods +'endPeriods : '+endPeriods);
      		 	////system.debug('Quota master record inserted : '+ JSON.serializePretty(qmToInsert));
				//system.debug('Quota master record inserted : '+ qmToInsert[0].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[1].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[2].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[3].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[4].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[5].Product_Type__c);
				system.debug('Quota master record inserted : '+ qmToInsert[6].Product_Type__c);
        		insert qmToInsert;
          
        List<QuotaMasterNew__c> insertedQM = [SELECT id, name, Quota_Owner_Name__r.firstname, Quota_Period__c, Quota_Owner_Name__r.Name,Quota_Owner_Name__r.ID,Quota_Start_Period__c, Quota_End_Period__c, CurrencyIsoCode, Product_Type__c from QuotaMasterNew__c where Quota_Owner_Name__r.ID IN :quotaOwnerIds and Quota_Start_Period__c IN :startPeriods and Quota_End_Period__c IN :endPeriods ];
       		//system.debug('New Quota master record(s) inserted record: ');
        
            createQuotaDetails(insertedQM);
       
 	  }
    
    
    
    public void createQuotaDetails(List<QuotaMasterNew__c> insertedQmstr){
        //system.debug('Preparing quota details for :' + insertedQmstr);
        List<QuotaDetail__c> newQuotaDetails2Insert = new List<QuotaDetail__c>();
        QuotaDetail__c qDet;

        
        for(QuotaMasterNew__c qMst : insertedQmstr){
           // system.debug('For Quota master period : '+ qMst.Quota_Period__c);
			integer localCount = 1;
            	FOR(integer i=4; i<=15; i++){
                
				qDet = new QuotaDetail__c();
             	qDet.QuotaMasterNew__c = qMst.id;
             	if(i <= 12 ){
                    		qDet.QuotaYear__c = qMst.Quota_Start_Period__c.year();
                    	}else{
                        	 qDet.QuotaYear__c = qMst.Quota_End_Period__c.year();
                        }
				if(i>12){
                      	qDet.Quota_Month__c = i-(i-localCount);
            			localCount =  localCount+1;
                    	}else{
                        	qDet.Quota_Month__c = i;
                        }
            			qDet.Quota_Quarter__c = getQuotaQuarter(i);
            			qDet.Quota_Amount__c = 0;
            			Date qtDate = Date.newInstance(Integer.valueOf(qDet.QuotaYear__c),Integer.valueOf(qDet.Quota_Month__c),Integer.valueOf(1));
            			qDet.Quota_Date__c = qtDate;
            			qDet.CurrencyIsoCode = corporateCurrency;
                    	qDet.COE_Target__c = 0;
                		qDet.Huringa_Target__c =  0;
                		qDet.Tibco_Target__c =  0;
						qDet.Product_Type_QDET__c = qMst.Product_Type__c;
                    	qDet.Product_Quota__c = 0;
            		//	system.debug('Adding new Quota Details to insert :  ' + qDet);
            			newQuotaDetails2Insert.add(qDet);
                    	
            		}
           
        }	
        	 //system.debug('Printing new Quota Details  List values to insert :  ' + newQuotaDetails2Insert);
        	insert newQuotaDetails2Insert;
    }
	
    public void removeRevenuesFromActualDetails(List<id> revIds){
        //system.debug('Revenue Ids to delete -->'+ JSON.serializePretty(revIds));
       List<Actual_Detail__c>  actualObj = [SELECT ID from actual_detail__c WHERE RevenueTermRef__c IN :revIds];
        //system.debug('Acutal Details rows to delete -->'+ JSON.serializePretty(actualObj));
    //TODO Delete part    
     if(actualObj.size() > 0){
                try{
                 delete actualObj;
                	}Catch(DMLexception dmle){
                    //system.debug('Error while deleting Actual details ' + dmle); 
                }
    		}
    }
	
	 public void removeActualsFromActualDetails(List<id> actualIds){
        //system.debug('Revenue Ids to delete -->'+ JSON.serializePretty(actualIds));
       List<Actual_Detail__c>  actualObj = [SELECT ID from actual_detail__c WHERE id IN :actualIds];
        //system.debug('Acutal Details rows to delete -->'+ JSON.serializePretty(actualObj));
    //TODO Delete part    
     if(actualObj.size() > 0){
                try{
                 delete actualObj;
                	}Catch(DMLexception dmle){
                    //system.debug('Error while deleting Actual details ' + dmle); 
                }
    		}
    }
    
    
    public Date getStartDatePeriod(Integer Quotayear){
        return date.newInstance(Quotayear, 04, 1);
    }
    
    public Date getEndDatePeriod(Integer Quotayear){
        return date.newInstance(Quotayear, 03, 31);
    }
    
	public String getUsersSBU(ID userId){
		List<User> reportingMgrs = [Select FirstName, LastName, Id, Country, User_s_SBU__c, currencyIsoCode from user where id =:userId AND isActive = true];
		for(User repMgr : reportingMgrs){
//                system.debug('Get Reporting managers country' + repMgr.User_s_SBU__c);
              
               if(null != repMgr.User_s_SBU__c && repMgr.User_s_SBU__c != '') {
              		return repMgr.User_s_SBU__c;      
                   
               		}else{
                   		return 'Others';		
               		}
               	} 
		return 'Others';
	}
    
    public integer getQuotaQuarter(integer y){
        
        if(y >= 4 && y <=6){
            return 1;
        }else if(y >= 7 && y <=9){
            return 2;
        }else if(y >= 10 && y <=12){
            return 3;
        }else{
            return 4;
        }
     }
}