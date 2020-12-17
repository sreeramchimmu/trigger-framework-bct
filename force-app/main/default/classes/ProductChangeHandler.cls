public class ProductChangeHandler {
    
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
    
    private Map<Id, opportunity_line_item__c> mapNewOppLine;
	private	Map<Id, opportunity_line_item__c> mapOldOppLine; 
    
    Date currrDate = Date.today();
    Integer currMonth = currrDate.month();
    Integer currYear =  currrDate.year();
    String fyPeriod;
    String startFY;
    String endFY;
    List<Integer> incentiveMonths;
    List<Integer> slippageQuarters;
    List<Integer> quotaSlipageMonths;
    Integer incentiveYear;
    Integer currQtr ;
    String newProduct ;   
    String oldProduct ;
    String newCompetency ;
    String oldCompetency ;
    ID oppLineID ;
    String oppLineSBU ;
    Id OwnerId ;
    String newProductCode;
    String oldProductCode;
    String actDetKey;
    String quotaDetKey;
    String oplNewCompetency;
    String oplOldCompetency;
   
    
    List<Actual_Detail__c> actDetObjToUpdate = new List<Actual_Detail__c>();
    List<QuotaDetail__c> quotaDetObjToUpdate = new List<QuotaDetail__c>();
    private  Map<String, QuotaDetail__c> quotaDetMap ;
    private  Map<String, Actual_Detail__c> actDetMap ;
        

    
  public ProductChangeHandler(Map<Id, opportunity_line_item__c> mapNewOppLine, Map<Id, opportunity_line_item__c> mapOldOppline) {
        this.mapNewOppLine = mapNewOppLine;
		this.mapOldOppline = mapOldOppline;   
      
      
      for(ID newOplId : mapNewOppLine.keyset()){
          oplNewCompetency = mapNewOppLine.get(newOplId).Competency__c;
      }

        if(currMonth > 3 ){
            startFY = String.valueOf(currYear);
            endFY = String.valueOf(currYear + 1);
           
        }else{
            startFY = String.valueOf(currYear -1);
            endFY = String.valueOf(currYear);
         
        }
        
        fyPeriod = startFY +'-'+ endFY;
        system.debug('fyPeriod   : ' + fyPeriod);
        
       
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
    
    
     public String getIPProductCode(String product, Map<String, List<String>> productMap){
        for(String pdtCode : productMap.keySet()){
            for(String eachPdt : productMap.get(pdtCode)){
               if(product.equalsIgnoreCase(eachPdt)) {
                   system.debug('Product Code in Opl: ' + pdtCode);                      
                	return pdtCode;
                // break;
            	} 
            }
         }
        return 'NOTMATCHING';
    }

    
    
     public String getProductCodeFromProduct(String productName){
		system.debug('Opplineitem Product Code ::  ' + productName);
        IF(null != productName && (productName.equalsIgnoreCase(ASYMMETRIX)|| ASYMMETRIX.equalsIgnoreCase(getIPProductCode(productName,ASYMMETRIX_PDTMAP )))){
		system.debug('ASYMMETRIX Product Found in OPL');
            return ASYMMETRIX;
        }else if(null != productName && (productName.equalsIgnoreCase(RETINA)|| RETINA.equalsIgnoreCase(getIPProductCode(productName,RETINA_PDTMAP )))){
			system.debug('Retina Product Found in OPL');
            return RETINA;
        }else if(null != productName && (productName.equalsIgnoreCase(DROPTHOUGHT) || DROPTHOUGHT.equalsIgnoreCase(getIPProductCode(productName,DROPTHOUGHT_PDTMAP )))){
		system.debug('DROPTHOUGHT Product Found in OPL');
            return DROPTHOUGHT;
        }else if(null != productName && (productName.equalsIgnoreCase(PULSE) || PULSE.equalsIgnoreCase(getIPProductCode(productName,PULSE_PDTMAP )))){
		system.debug('PULSE Product Found in OPL');
            return PULSE;
        }else if(null != productName && (productName.equalsIgnoreCase(CUETRACK) || CUETRACK.equalsIgnoreCase(getIPProductCode(productName,CUETRACK_PDTMAP )))){
		system.debug('CUETRACK Product Found in OPL');
            return CUETRACK;
        }else if(null != productName && (productName.equalsIgnoreCase(CUETRANS)|| CUETRANS.equalsIgnoreCase(getIPProductCode(productName,CUETRANS_PDTMAP )))){
		system.debug('CUETRANS Product Found in OPL');
            return CUETRANS;
        }else if(null != productName && (productName.equalsIgnoreCase(GEODATAFY)|| GEODATAFY.equalsIgnoreCase(getIPProductCode(productName,GEODATAFY_PDTMAP )))){
		system.debug('GEODATAFY Product Found');
            return GEODATAFY;
        }else if(null == productName || productName.equalsIgnoreCase('') || productName.equalsIgnoreCase('OVERALL')){
		system.debug('OVERALL Product Found in OPL');
            return OVERALL;
        }
                 
        return null;
        
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
    
    Public Void shiftProductRevenue (Map<Id, opportunity_line_item__c> mapNewOppLine, Map<Id, opportunity_line_item__c> mapOldOppline) {
            
        this.mapNewOppLine = mapNewOppLine;
		this.mapOldOppline = mapOldOppline;   
      
      
      for(ID newOplId : mapNewOppLine.keyset()){

           newProduct = mapNewOppLine.get(newOplId).Product__c ;
           oppLineID = mapNewOppLine.get(newOplId).Id ;  
           oppLineSBU = mapNewOppLine.get(newOplId).SBU_OppLine__c ;
           OwnerId = mapNewOppLine.get(newOplId).Owner_ID_OppLine__c ;
          newCompetency =mapNewOppLine.get(newOplId).Competency__c;
      } 
        
         String tempNewPdtOrCompetency = (null != newProduct && newProduct.equalsIgnoreCase('none')) ? newCompetency : newProduct;
          
         newProductCode = getProductCodeFromProduct(tempNewPdtOrCompetency);
                 system.debug('getNewProductCode---------->'+newProductCode);
        
      for(ID oldOplId : mapOldOppline.keyset()){
          oldProduct = mapOldOppline.get(oldOplId).Product__c ;
          oldCompetency =  mapOldOppline.get(oldOplId).Competency__c ;
      }
        
        String tempOldPdtOrCompetency = (null != oldProduct && oldProduct.equalsIgnoreCase('none')) ? oldCompetency : oldProduct;
        oldProductCode = getProductCodeFromProduct(tempOldPdtOrCompetency);
        system.debug('getOldProductCode---------->'+oldProductCode);

      if(!(oldProduct.equalsIgnoreCase(newProduct)) || !(newCompetency.equalsIgnoreCase(oldCompetency) ) ){
          system.debug('Product values are different');
		List <Actual_Detail__c> actDetList	;  
        List <QuotaMasterNew__c> quotaMstList	;  
       
		actDetList  = [SELECT Product_Code_QuotaDet__c, Id, RevenueTermRef__c, QuotaDetail__r.QuotaMasterNew__r.SBU__c ,QuotaDetail__r.QuotaMasterNew__r.OwnerId, QuotaDetail__r.QuotaMasterNew__r.Quota_Period__c, QuotaDetail__r.Quota_Month__c, QuotaDetail__r.QuotaYear__c FROM Actual_Detail__c  where 
					 RevenueTermRef__r.Opportunity_line_item_id__r.id =:oppLineID and
					 QuotaDetail__r.QuotaMasterNew__r.SBU__c =:oppLineSBU and
                     QuotaDetail__r.QuotaMasterNew__r.OwnerId =:OwnerId 
                      ]; 
           
          if( null != actDetList && actDetList.size()>0){
			delete actDetList;
		
		}
		
		List<revenue_term__c> revTermList =  [SELECT Id, ChangeIndicator__c  FROM Revenue_Term__c where Opportunity_Line_Item_id__c =: oppLineID];

		List<revenue_term__c> revTermListToUpdate = new List<revenue_term__c>();
		for(revenue_term__c eachRevTerm : revTermList ){
			
			eachRevTerm.ChangeIndicator__c = math.random() ;
			revTermListToUpdate.add(eachRevTerm);
		
		}
		
		 if(revTermListToUpdate.size() > 0){
              try
              {
				  system.debug('actual object to nullify qdet------>'+revTermListToUpdate);
                  update revTermListToUpdate;
              }
              
              catch(DMLexception dmle){
                  system.debug('Error while shifting the product' + dmle); 
              }
		}
		
		/*quotaDetMap = new Map<String, QuotaDetail__c> ();
          List <QuotaDetail__c> quotaDetList = [SELECT Id, Quota_Month__c, QuotaYear__c,Product_Type_QDET__c,QuotaMasterNew__r.SBU__c,QuotaMasterNew__r.OwnerId,QuotaMasterNew__r.Quota_Period__c FROM QuotaDetail__c  where 
                      QuotaMasterNew__r.SBU__c = :oppLineSBU and 
                      QuotaMasterNew__r.OwnerId = :OwnerId and 
                      QuotaMasterNew__r.Quota_Period__c =:fyPeriod AND
                      Product_Type_QDET__c = : newProductCode 
                      ];
          system.debug('quotaDetList----> ' +quotaDetList);
		  for(QuotaDetail__c eachQObj :quotaDetList){
        
            quotaDetKey = eachQObj.QuotaMasterNew__r.OwnerId + eachQObj.QuotaMasterNew__r.SBU__c + 
            Integer.valueOf(eachQObj.Quota_Month__c) + Integer.valueOf(eachQObj.QuotaYear__c) + newProductCode ;
			system.debug('quotaDetKey-------->'+quotaDetKey);
			quotaDetMap.put(quotaDetKey, eachQObj);            
		} 

          actDetMap = new Map<String, Actual_Detail__c> (); 
          Actual_Detail__c updatedActObj;
		 List <Actual_Detail__c> actDetList	;
		  if(null != oldProductCode){
           actDetList  = [SELECT Product_Code_QuotaDet__c, Id, RevenueTermRef__c, QuotaDetail__r.QuotaMasterNew__r.SBU__c ,QuotaDetail__r.QuotaMasterNew__r.OwnerId, QuotaDetail__r.QuotaMasterNew__r.Quota_Period__c, QuotaDetail__r.Quota_Month__c, QuotaDetail__r.QuotaYear__c FROM Actual_Detail__c  where 
					 RevenueTermRef__r.Opportunity_line_item_id__r.id =:oppLineID and
					 QuotaDetail__r.QuotaMasterNew__r.SBU__c =:oppLineSBU and
                     QuotaDetail__r.QuotaMasterNew__r.OwnerId =:OwnerId and
                     QuotaDetail__r.QuotaMasterNew__r.Quota_Period__c = :fyPeriod and
                     Product_Code_QuotaDet__c != :'OVERALL' and
                     Product_Code_QuotaDet__c  = : oldProductCode  
 				    ]; 
					
				}	else{
				actDetList  = [SELECT Product_Code_QuotaDet__c, Id, RevenueTermRef__c, QuotaDetail__r.QuotaMasterNew__r.SBU__c ,QuotaDetail__r.QuotaMasterNew__r.OwnerId, QuotaDetail__r.QuotaMasterNew__r.Quota_Period__c, QuotaDetail__r.Quota_Month__c, QuotaDetail__r.QuotaYear__c FROM Actual_Detail__c  where 
					 RevenueTermRef__r.Opportunity_line_item_id__r.id =:oppLineID and
					 QuotaDetail__r.QuotaMasterNew__r.SBU__c =:oppLineSBU and
                     QuotaDetail__r.QuotaMasterNew__r.OwnerId =:OwnerId and
                     QuotaDetail__r.QuotaMasterNew__r.Quota_Period__c = :fyPeriod and
                     Product_Code_QuotaDet__c != :'OVERALL'
                     ]; 
				}
		  Actual_Detail__c actDetObjToRemoveQdetRefList = new List<Actual_Detail__c>(); 
          for (Actual_Detail__c eachActobj : actDetList) {
		  // IP or NON IP check
		  if(null != newProductCode){
		  // IP product
          actDetKey = OwnerId + oppLineSBU + Integer.valueOf(eachActobj.QuotaDetail__r.Quota_Month__c) +
          Integer.valueOf(eachActobj.QuotaDetail__r.QuotaYear__c ) + newProductCode;
          system.debug('actDetKey----->'+actDetKey);
          
		  actDetMap.put(actDetKey, eachActobj);
          
           system.debug('each actual object----->'+eachActobj);
           updatedActObj = new Actual_Detail__c(id=eachActobj.Id);
              for(String actKey :actDetMap.keySet() ){
					
                   eachActobj.QuotaDetail__c =  null != quotaDetMap.get(actKey) ? quotaDetMap.get(actKey).id : null ;
                   system.debug('final quota id----->'+eachActobj.QuotaDetail__c);
                   updatedActObj.QuotaDetail__c = eachActobj.QuotaDetail__c ;

              }
               actDetObjToUpdate.add(updatedActObj);
		}else{
				// NON IP 
				eachActobj.QuotaDetail__c = null;
				actDetObjToRemoveQdetRefList.add(eachActobj);
				
		}
     }
          if(actDetObjToUpdate.size() > 0){
              try
              {
				  system.debug('actual object to update------>'+actDetObjToUpdate);
                  update actDetObjToUpdate;
              }
              
              catch(DMLexception dmle){
                  system.debug('Error while shifting the product' + dmle); 
              }
          }
		  if(actDetObjToRemoveQdetRefList.size() > 0){
              try
              {
				  system.debug('actual object to nullify qdet------>'+actDetObjToRemoveQdetRefList);
                  update actDetObjToRemoveQdetRefList;
              }
              
              catch(DMLexception dmle){
                  system.debug('Error while shifting the product' + dmle); 
              }
          }*/
      }
      else {
          system.debug('Oppline item product is not Changed');
      }
        }
 }