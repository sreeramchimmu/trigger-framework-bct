/*
		 * Class Name 	: QvaDataFetchController
		 * Description 	: This class Set the quota for the user and fetches the quota information for the user whose quota is already had set.
		 * 				  This class also update the quota information that has already set.
		 * Author 		: Arun Rajendran
		 * Date 		: 12-Dec-2016
		 * 
		 * Modified by  : Sreeram. V
		 * Modification : Changes made to introduce new Products and Geo Head wise quotas.
		 */
public class QvaDataFetchController {
   
     
   public Id repId {get;set;}
   //Public Id navId {get; set;}
   public String qtaPeriod {get;set;}
   public Date startPeriod {get;set;}
   public Date endPeriod {get;set;}
   public String qtaOwnerFullName {get;set;}
   public innerClsQuota InnerClsObj;
   public List<QuotaDetail__c> qDetail;
   public List<QuotaMasterNew__c> qmstN;
    	
   public QuotaMasterNew__c qmNew;
   public decimal yearlySum {get;set;}
   public boolean isNew {get; set;}
   public boolean isCreate {get; set;} 
   public boolean isExisting {get; set;}
   public boolean isUpdate {get; set;}
   public String geoLocation {get;set;}
    public decimal totAsymetrixQuota {get; set;}
    public decimal totCueTrTkQuota {get; set;}
    public decimal totDTPulQuota {get; set;}
    public decimal totRetinaQuota {get; set;}
    public decimal totGeoDataFYQuota {get; set;}
    public decimal overallQuota {get; set;}
    public decimal overallHurQuota {get; set;}
    public decimal overallCoeQuota {get; set;}
    public decimal totDropthoughtCuetrackPulseQuota {get; set;}
    public decimal totCueTransFSAPGeoDataFYQuota  {get; set;}
    
    public List<String> productType {get; set;}
    
    private static String ASYMMETRIX ='ASYMMETRIX';
    private static String PULSE ='PULSE';
    private static String DROPTHOUGHT ='DROPTHOUGHT';
    private static String RETINA ='RETINA';
    private static String CUETRACK ='CUETRACK';
    private static String CUETRANS ='CUETRANS';  
    private static String GEODATAFY ='GEODATAFY';
    private static String FSAP ='FSAP';
    private static String OVERALL ='OVERALL';
	   
   	List<QuotaMasterNew__c> qmToInsert;
   	public List<innerClsQuota> innerRwlst {get;set;}
   	public List<innerClsQuota> innerRwlstProduct {get;set;}
    
   
   	public String usrRole {get; set;}
   	public id qmgrId {get; set;}
	public id qmgr2ndLevelId {get; set;}
   
    public boolean isUserGEOHead {get; set;}
    
    //-------------------Gowtham-introduced for conformation message-------------
    public	String country;
    public  String quotaOwner;
	public  String fiscalYear;
    public  String reprID;
    //-------------------Gowtham-introduced for conformation message-------------
    
    public String param_value2;
    public String param_value3;
    public String param_value4;
    
    public QvaDataFetchController(){
        
        isUserGEOHead = false;
        
 		String param_value1 = String.valueOf(ApexPages.currentPage().getParameters().get('qtaowner').trim());
         param_value2 = String.valueOf(ApexPages.currentPage().getParameters().get('qtaPeriod').trim());
         param_value3 = String.valueOf(ApexPages.currentPage().getParameters().get('qowner').trim());
         param_value4 = String.valueOf(ApexPages.currentPage().getParameters().get('geoLoc').trim());
         
        //-------------------Gowtham-introduced for conformation message-------------
        String param_value5 = String.valueOf(ApexPages.currentPage().getParameters().get('action').trim());
        //-------------------Gowtham-introduced for conformation message-------------
        
        //String param_value4 = String.valueOf(ApexPages.currentPage().getParameters().get('srcid').trim());
        
          system.debug('Fetching quota for :  ' + param_value1  +'--->' +param_value2+'--->' +param_value3 );
          repId = Id.valueOf(param_value1);
          startPeriod = getStartDatePeriod(integer.valueOf(param_value2.substring(0,4)));
          endPeriod = getEndDatePeriod(integer.valueOf(param_value2.substring(5,9)));
          qtaOwnerFullName = param_value3;
          geoLocation = param_value4;
          qtaPeriod = param_value2;
     	  getQuotaManagerId(repId);
        system.debug('User Role  :  ' + usrRole);
        if(null != usrRole & (usrRole.contains('GEO Head') || usrRole.equalsIgnorecase('Head - IVMS, OMAN, UAE & TIBCO'))){
            system.debug('User Role has GEO HEAD  . So setting IsuserGeoHead to True');
            isUserGEOHead = true;
        }
        
         	productType = new List<String>();
        	productType.add(ASYMMETRIX);
        	productType.add(DROPTHOUGHT);
        	productType.add(RETINA);
        	productType.add(PULSE);
        	productType.add(CUETRACK);
        	productType.add(CUETRANS);
            productType.add(GEODATAFY);
        	productType.add(FSAP);
        
          system.debug('Fetching quota for :  ' + repId  +'--->'+ qtaOwnerFullName+'-->'+startPeriod +'--> '+ endPeriod);
          
        //	qmst = [SELECT id, name, Quota_Owner_Name__c,Quota_Owner_Id__c, QuotaYear__c, Quota_Month__c, Quota_Quarter__c, Quota_Amount__c,CurrencyIsoCode from QuotaMaster__c where Quota_Owner_Id__c =:repId AND( (QuotaYear__c =:startPeriod AND Quota_Month__c >= 4 ) OR (QuotaYear__c =:endPeriod AND Quota_Month__c <= 3 ))];
        	qmstN = [SELECT id, name, Quota_Owner_Name__r.firstname, Product_Type__c, Total_Dropthought_Cuetrack_Pulse__c,Total_CueTrans_FSAP_GeoData_FY__c,Overal_Huringa_Target__c, Overall_COE_Target__c, Total_Retina__c, Total_DT_Pulse__c, Total_CueTrack_CueTrans__c,Total_Asymetrix_Quota__c, Total_GeoDataFY_Quota__c,Quota_Owner_Name__r.Name,Quota_Owner_Name__r.ID,Quota_Start_Period__c, Quota_End_Period__c, CurrencyIsoCode, Quota_Yearly_Amount__c from QuotaMasterNew__c where Quota_Owner_Name__r.ID =:repId AND Quota_Period__c =:param_value2 and SBU__c =:geoLocation and Product_Type__c IN ('ASYMMETRIX', 'RETINA', 'CUETRACK','CUETRANS','DROPTHOUGHT','PULSE','GEODATAFY','FSAP','OVERALL')];
        	
        	system.debug('Quota query result '+ qmstN.size());
        ID masterRecId = null;
          for(QuotaMasterNew__c qlst: qmstN){
              system.debug('ID : '+ qlst.id);
              system.debug('name : '+ qlst.name);
              system.debug('Quota_Owner_Name__r.firstname : '+ qlst.Quota_Owner_Name__r.firstname);
              system.debug(' Quota_Owner_Name__r.Name : '+  qlst.Quota_Owner_Name__r.Name);
              system.debug('Quota_Owner_Name__r.ID : '+ qlst.Quota_Owner_Name__r.ID);
              system.debug('Quota_Start_Period__c : '+ qlst.Quota_Start_Period__c);
              system.debug('Quota rpoduct Type  : '+ qlst.Product_Type__c);
              if(qlst.Product_Type__c.equalsIgnoreCase('OVERALL')){
                  masterRecId = qlst.id;
                  totAsymetrixQuota = qlst.Total_Asymetrix_Quota__c;
                  totDropthoughtCuetrackPulseQuota = qlst.Total_Dropthought_Cuetrack_Pulse__c;
                  totCueTransFSAPGeoDataFYQuota = qlst.Total_CueTrans_FSAP_GeoData_FY__c;
                  //totCueTrTkQuota = qlst.Total_CueTrack_CueTrans__c;
                  //totDTPulQuota = qlst.Total_DT_Pulse__c;
                  totRetinaQuota = qlst.Total_Retina__c;
                  totGeoDataFYQuota =qlst.Total_GeoDataFY_Quota__c;
                  overallQuota = qlst.Quota_Yearly_Amount__c;              
                  overallHurQuota = qlst.Overal_Huringa_Target__c;
                  overallCoeQuota = qlst.Overall_COE_Target__c;
              }
              
            }
        system.debug('Quota Master Type  : '+ masterRecId);
      
       if(null != qmstN && qmstN.size() > 0){
              system.debug('Master Record Quota Already existing. So fetching quota details');
           qDetail = [SELECT id, name, Quota_Date__c,Quota_Month__c, Sales_Executive_Base_Quota__c, Sales_Manager_Base_Quota__c,Geo_Head_Asymmetrix_Quota__c,Geo_Head_Dropthought_Quota__c,Geo_Head_DSCM_Quota__c,Geo_Head_GeodataFY_Quota__c,Geo_Head_Retina_Quota__c,Geo_Head_TIBCO_Quota__c, Geo_Head_IP_Base_Quota__c,Product_Head_Base_Quota__c, DJM_Product_Head_Base_Quota__c,Asymmetrix_Product_Head_Base_Quota__c,Hidden_Quota_2__c, Hidden_Quota__c, Quota_Quarter__c,QuotaYear__c,COE_Target__c,Huringa_Target__c,Tibco_Target__c, Revenue_Recognized_Amount__c,QuotaMasterNew__r.Quota_Owner_Name__r.Name, Quota_Variance__c, Quota_Amount__c, CurrencyIsoCode, Asymmetrix_Quota__c, Cuetrack_Quota__c, Cuetrans_Quota__c, Dropthought_Quota__c, Pulse_Quota__c, Retina_Qutoa__c,GeoDataFY_Quota__c,FSAP_Quota__c from QuotaDetail__c where QuotaMasterNew__c =:masterRecId];
           system.debug('Quota details Already existing'+ JSON.serializePretty(qDetail));
           	if(null != qDetail && qDetail.size() > 0){
               system.debug('Quota details Already existing. So fetching quota details');
              		isCreate = false;
			  		fetchQuotaDetails(qDetail,startPeriod, endPeriod);
                
                 //--------------Gowtham-introduced for conformation message---------------------
                	if(param_value5!=''&& param_value5!=null){
                        if(param_value5.equalsIgnoreCase('update')){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM ,'quota has been update to the quotaowner '+qmstN[0].Quota_Owner_Name__r.Name+' for FY-'+param_value2));  
                        }
                        if(param_value5.equalsIgnoreCase('submit')){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM ,'New quota has been set to the quotaowner '+qmstN[0].Quota_Owner_Name__r.Name+' for FY-'+param_value2));  
                        }
                    }
                 //--------------Gowtham-introduced for conformation message---------------------
                
            	}else{
                	system.debug('Quota Detail Record  not existing. So creating new quota ');
                    isCreate = true;
                    createQuotaDetails(repId,startPeriod, endPeriod,masterRecId); 
            }
           	  
        }else{
               system.debug('Master Record Quota not existing. So creating new quota Master ');
               isCreate = true;
               createQuotaMaster(repId,startPeriod, endPeriod, qtaPeriod); 
			  
		  }
        
    }
    
    public Date getStartDatePeriod(Integer Quotayear){
        return date.newInstance(Quotayear, 04, 1);
    }
    
    public Date getEndDatePeriod(Integer Quotayear){
        return date.newInstance(Quotayear, 03, 31);
    }
    
    
    public void createQuotaMaster(Id repId, Date sp, Date ep, String qPeriod){
         
       
        	qmNew  = new QuotaMasterNew__c();
          	qmToInsert = new List<QuotaMasterNew__c>();
        	
        	qmNew.SBU__c = geoLocation;
        	qmNew.Quota_Start_Period__c = sp;
        	qmNew.Quota_End_Period__c = ep;
        	qmNew.Quota_Owner_Name__c = repId;
        	qmNew.OwnerId = repId;
        	qmNew.Quota_Period__c = qPeriod;
        	qmNew.CurrencyIsoCode = 'USD';
        	qmNew.Quota_Owner_Manager__c = qmgrId; 
        	qmNew.Product_Type__c = OVERALL;
        	qmToInsert.add(qmNew);
        
       for(String eachProduct : productType ){
                qmNew  = new QuotaMasterNew__c();
                qmNew.SBU__c = geoLocation;
                qmNew.Quota_Start_Period__c = sp;
                qmNew.Quota_End_Period__c = ep;
                qmNew.Quota_Owner_Name__c = repId;
                qmNew.OwnerId = repId;
                qmNew.Quota_Period__c = qPeriod;
                qmNew.CurrencyIsoCode = 'USD';
                qmNew.Quota_Owner_Manager__c = qmgrId; 
                qmNew.Product_Type__c = eachProduct;
            
            qmToInsert.add(qmNew);
        }
        
        	//system.debug('Quota master record inserted.'+ qmToInsert);
       		id	qotaMasterId ;
       	     createQuotaDetails(repId,sp,ep,qotaMasterId);
   }
    
    public id getQuotaManagerId(Id qtaOwner){
       // id qmgrId;
        List<User> reportingMgr = [Select managerid, UserRole.name from user where id =:qtaOwner AND isActive = true];
          if(null != reportingMgr && reportingMgr .size() > 0){
               for(User repMgr : reportingMgr){
					  qmgrId = repMgr.managerid;
			    List<User> secondLevelMgr = [Select managerid, UserRole.name from user where id =:repMgr.managerid AND isActive = true LIMIT 1];
                   for(User mgr2ndLevel : secondLevelMgr){
					   qmgr2ndLevelId = mgr2ndLevel.managerid;
					   usrRole = String.valueOf(mgr2ndLevel.UserRole.name);
				   }
               }
          }
        system.debug('Quota owners manager id '+ qmgrId  +'  User Role---> '+ usrRole);
        if(qmgrId != null){
            return qmgrId;
        }
        return '';
    }
    
    public void createQuotaDetails(Id repId, Date sp, Date ep, id parId){
        system.debug('Preparing quota details :'+ repid +'-->SP'+sp+'-->EP'+ep+'-->Parent Id :'+parId);
        innerRwlst = new List<innerClsQuota>();
        innerRwlstProduct = new List<innerClsQuota>();
        integer localCount = 1;
        
        isNew =  true;
        isExisting =  false;
        FOR(integer i=4; i<=15; i++){
				InnerClsObj = new innerClsQuota();
              	InnerClsObj.quotaOwnerName = qtaOwnerFullName;
            	InnerClsObj.geolocation = geoLocation;
             	InnerClsObj.qDet.QuotaMasterNew__c = parId;
            	if(i <= 12 ){
                		InnerClsObj.qDet.QuotaYear__c = startPeriod.year();
                    }else{
                        InnerClsObj.qDet.QuotaYear__c = endPeriod.year();
                    }
				if(i>12){
                    	InnerClsObj.qDet.Quota_Month__c = i-(i-localCount);
            			localCount =  localCount+1;
                    	InnerClsObj.monthName = getQuotaMonthName(i);
                    }else{
                        InnerClsObj.qDet.Quota_Month__c = i;
                        InnerClsObj.monthName = getQuotaMonthName(i);
                    }
            			InnerClsObj.qDet.Quota_Quarter__c = getQuotaQuarter(i);
            			InnerClsObj.quarterName = getQuotaQuarterName(i);
            			InnerClsObj.qDet.Quota_Amount__c = 0;
            			InnerClsObj.qDet.Hidden_Quota__c = 0;
            			InnerClsObj.qDet.Hidden_Quota_2__c = 0;
            			InnerClsObj.qDet.Sales_Executive_Base_Quota__c = 0;
            			InnerClsObj.qDet.Sales_Manager_Base_Quota__c = 0;
            			InnerClsObj.qDet.Geo_Head_IP_Base_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_TIBCO_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Asymmetrix_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Dropthought_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_DSCM_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Retina_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_GeodataFY_Quota__c = 0;
            			InnerClsObj.qDet.Product_Head_Base_Quota__c = 0;
            			InnerClsObj.qDet.DJM_Product_Head_Base_Quota__c = 0;
                        InnerClsObj.qDet.Asymmetrix_Product_Head_Base_Quota__c = 0; 
     			        //InnerClsObj.qDet.DT_Product_Base_Quota__c = 0;
            		    //InnerClsObj.qDet.DSCM_Product_Base_Quota__c = 0;
            		    
            
            
            			Date qtDate = Date.newInstance(Integer.valueOf(InnerClsObj.qDet.QuotaYear__c),Integer.valueOf(InnerClsObj.qDet.Quota_Month__c),Integer.valueOf(1));
            			InnerClsObj.qDet.Quota_Date__c = qtDate;
            			InnerClsObj.qDet.CurrencyIsoCode = 'USD';
						InnerClsObj.qDet.Product_Type_QDET__c = 'OVERALL';            			
            			
            		innerRwlst.add(InnerClsObj);
        }
       FOR(String eachProduct : productType ){
            integer localCountPdt = 1;
        FOR(integer i=4; i<=15; i++){
				InnerClsObj = new innerClsQuota();
              	InnerClsObj.quotaOwnerName = qtaOwnerFullName;
            	InnerClsObj.geolocation = geoLocation;
             	InnerClsObj.qDet.QuotaMasterNew__c = parId;
            	if(i <= 12 ){
                		InnerClsObj.qDet.QuotaYear__c = startPeriod.year();
                    }else{
                        InnerClsObj.qDet.QuotaYear__c = endPeriod.year();
                    }
				if(i>12){
                    	InnerClsObj.qDet.Quota_Month__c = i-(i-localCountPdt);
            			localCountPdt =  localCountPdt+1;
                    	InnerClsObj.monthName = getQuotaMonthName(i);
                    }else{
                        InnerClsObj.qDet.Quota_Month__c = i;
                        InnerClsObj.monthName = getQuotaMonthName(i);
                    }
            			InnerClsObj.qDet.Quota_Quarter__c = getQuotaQuarter(i);
            			InnerClsObj.quarterName = getQuotaQuarterName(i);
            			InnerClsObj.qDet.Quota_Amount__c = 0;
            			InnerClsObj.qDet.Hidden_Quota__c = 0;
            			InnerClsObj.qDet.Hidden_Quota_2__c = 0;
            			InnerClsObj.qDet.Sales_Executive_Base_Quota__c = 0;
            			InnerClsObj.qDet.Sales_Manager_Base_Quota__c = 0;
            			InnerClsObj.qDet.Geo_Head_IP_Base_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_TIBCO_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Asymmetrix_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Dropthought_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_DSCM_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_Retina_Quota__c = 0;
            InnerClsObj.qDet.Geo_Head_GeodataFY_Quota__c = 0;
          			    InnerClsObj.qDet.Product_Head_Base_Quota__c = 0;
            			InnerClsObj.qDet.DJM_Product_Head_Base_Quota__c = 0;
          				InnerClsObj.qDet.Asymmetrix_Product_Head_Base_Quota__c = 0; 
           			   // InnerClsObj.qDet.DT_Product_Base_Quota__c = 0;
                       // InnerClsObj.qDet.DSCM_Product_Base_Quota__c = 0;

            
            
            			Date qtDate = Date.newInstance(Integer.valueOf(InnerClsObj.qDet.QuotaYear__c),Integer.valueOf(InnerClsObj.qDet.Quota_Month__c),Integer.valueOf(1));
            			InnerClsObj.qDet.Quota_Date__c = qtDate;
            			InnerClsObj.qDet.CurrencyIsoCode = 'USD';
            
            			InnerClsObj.qDet.Product_Type_QDET__c = eachProduct;
            			InnerClsObj.qDet.Product_Quota__c = 0;
            		
            			innerRwlstProduct.add(InnerClsObj);
        		}
             system.debug('Quota details for product preppared for rows:' + innerRwlstProduct.size());
    	}
        
    }
    
    
    
    
    public void fetchQuotaDetails(List<QuotaDetail__c> quotalist, Date sp, Date ep){
        	innerRwlst = new List<innerClsQuota>();
            integer localCount = 4;
        	isNew =  false;
            isExisting =  true;
        	isUpdate = false;
        	yearlySum = 0.00;
           for(QuotaDetail__c qlst: quotalist){
               	InnerClsObj = new innerClsQuota();
               	InnerClsObj.qDet.Id = qlst.Id;
               	InnerClsObj.geolocation = geoLocation;
               	InnerClsObj.quotaOwnerName = qlst.QuotaMasterNew__r.Quota_Owner_Name__r.Name;
             	InnerClsObj.qDet.QuotaYear__c = qlst.QuotaYear__c;
               	InnerClsObj.qDet.Quota_Month__c = qlst.Quota_Month__c;
            	InnerClsObj.monthName = getQuotaMonthName(integer.valueOf(qlst.Quota_Month__c));
                InnerClsObj.qDet.Quota_Quarter__c = qlst.Quota_Quarter__c;
                InnerClsObj.quarterName = getQuotaQuarterName(integer.valueOf(qlst.Quota_Month__c));
            	InnerClsObj.qDet.Quota_Amount__c = qlst.Quota_Amount__c;
                InnerClsObj.qDet.Hidden_Quota__c = qlst.Hidden_Quota__c;
                InnerClsObj.qDet.Hidden_Quota_2__c = qlst.Hidden_Quota_2__c;
                InnerClsObj.qDet.Sales_Executive_Base_Quota__c = qlst.Sales_Executive_Base_Quota__c;
                InnerClsObj.qDet.Sales_Manager_Base_Quota__c = qlst.Sales_Manager_Base_Quota__c;
                InnerClsObj.qDet.Geo_Head_IP_Base_Quota__c = qlst.Geo_Head_IP_Base_Quota__c;
                InnerClsObj.qDet.Geo_Head_TIBCO_Quota__c = (qlst.Geo_Head_TIBCO_Quota__c != null ? qlst.Geo_Head_TIBCO_Quota__c : 0 );
                InnerClsObj.qDet.Geo_Head_Asymmetrix_Quota__c = (qlst.Geo_Head_Asymmetrix_Quota__c != null ? qlst.Geo_Head_Asymmetrix_Quota__c : 0 );
                InnerClsObj.qDet.Geo_Head_Dropthought_Quota__c = (qlst.Geo_Head_Dropthought_Quota__c != null ? qlst.Geo_Head_Dropthought_Quota__c : 0 );
                InnerClsObj.qDet.Geo_Head_DSCM_Quota__c = (qlst.Geo_Head_DSCM_Quota__c != null ? qlst.Geo_Head_DSCM_Quota__c : 0 );
                InnerClsObj.qDet.Geo_Head_Retina_Quota__c = (qlst.Geo_Head_Retina_Quota__c != null ? qlst.Geo_Head_Retina_Quota__c : 0 );
                InnerClsObj.qDet.Geo_Head_GeodataFY_Quota__c = (qlst.Geo_Head_GeodataFY_Quota__c != null ? qlst.Geo_Head_GeodataFY_Quota__c : 0 );
                InnerClsObj.qDet.Product_Head_Base_Quota__c = qlst.Product_Head_Base_Quota__c;
                InnerClsObj.qDet.DJM_Product_Head_Base_Quota__c = qlst.DJM_Product_Head_Base_Quota__c;
              	InnerClsObj.qDet.Asymmetrix_Product_Head_Base_Quota__c = qlst.Asymmetrix_Product_Head_Base_Quota__c; 
               
               // InnerClsObj.qDet.DT_Product_Base_Quota__c = qlst.DT_Product_Base_Quota__c ;
               // InnerClsObj.qDet.DSCM_Product_Base_Quota__c = qlst.DSCM_Product_Base_Quota__c ;

                
                InnerClsObj.qDet.COE_Target__c = qlst.COE_Target__c;
                InnerClsObj.qDet.Huringa_Target__c =  qlst.Huringa_Target__c;
                InnerClsObj.qDet.Tibco_Target__c =  qlst.Tibco_Target__c;
               
               InnerClsObj.qDet.Asymmetrix_Quota__c =qlst.Asymmetrix_Quota__c;
               InnerClsObj.qDet.Cuetrack_Quota__c=qlst.Cuetrack_Quota__c;
               InnerClsObj.qDet.Cuetrans_Quota__c=qlst.Cuetrans_Quota__c;
               InnerClsObj.qDet.Dropthought_Quota__c=qlst.Dropthought_Quota__c;
               InnerClsObj.qDet.Pulse_Quota__c=qlst.Pulse_Quota__c;
               InnerClsObj.qDet.Retina_Qutoa__c=qlst.Retina_Qutoa__c;
               InnerClsObj.qDet.GeoDataFY_Quota__c =qlst.GeoDataFY_Quota__c ;
               InnerClsObj.qDet.FSAP_Quota__c =(qlst.FSAP_Quota__c != null ? qlst.FSAP_Quota__c : 0 );
             	
               innerRwlst.add(InnerClsObj);
   
               if(null != qlst.Quota_Amount__c){
                   yearlySum = yearlySum + double.valueOf(qlst.Quota_Amount__c);
               }else{
                   yearlySum = 0;
               }
                
            }
    }
    
    
      public PageReference submitQuota(){
       list<QuotaDetail__c> newQuotas = new List<QuotaDetail__c>();
          
        try{
             	system.debug('1- Inserting Quota Master Object.');
             	insert qmToInsert;
        	
        }catch(Exception e){
            system.debug('Unable to Insert Quota master.' + e);
        	}
        	 List<QuotaMasterNew__c> insertedQM = [SELECT id, name, Quota_Owner_Name__r.firstname, Quota_Owner_Name__r.Name,Quota_Owner_Name__r.ID,Quota_Start_Period__c, Quota_End_Period__c,Product_Type__c, CurrencyIsoCode from QuotaMasterNew__c where Quota_Owner_Name__r.ID =:repId and Quota_Start_Period__c=:startPeriod and Quota_End_Period__c=:endPeriod and SBU__c =:geoLocation ];
          id	qotaMasterId;
          id	qotaMasterIdAssy;
          id	qotaMasterIdRetina;
          id	qotaMasterIdPulse;
          id	qotaMasterIdDT;
          id	qotaMasterIdCuetrack;
          id	qotaMasterIdCuetrans; 
          id	qotaMasterIdGeoDataFY;
          id    qotaMasterIdFSAP;
          Map<String,decimal>  	qotaOvl;
          Map<String,decimal>	qotaAssy;
          Map<String,decimal>	qotaRetina;
          Map<String,decimal>	qotaPulse;
          Map<String,decimal>	qotaDT;
          Map<String,decimal>	qotaCuetrack;
          Map<String,decimal>	qotaCuetrans;
          Map<String,decimal>	qotaGeoDataFY;
          Map<String,decimal>	qotaFSAP;
          
          system.debug('2- After inserting Quota Master Object');
          	 for(QuotaMasterNew__c qlst: insertedQM){
             /* system.debug('ID : '+ qlst.id);
              system.debug('name : '+ qlst.name);
              system.debug('Quota_Owner_Name__r.firstname : '+ qlst.Quota_Owner_Name__r.firstname);
              system.debug('Quota_Owner_Name__r.Name : '+  qlst.Quota_Owner_Name__r.Name);
              system.debug('Quota_Owner_Name__r.ID : '+ qlst.Quota_Owner_Name__r.ID);
              system.debug('Quota_Start_Period__c : '+ qlst.Quota_Start_Period__c);*/
              //system.debug('Quota Product type : '+ qlst.Product_Type__c);
                
                 if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(ASYMMETRIX)){
                     qotaMasterIdAssy = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(RETINA)){
                     qotaMasterIdRetina = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(CUETRACK)){
                     qotaMasterIdCuetrack = qlst.id;
                }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(CUETRANS)){
                     qotaMasterIdCuetrans = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(PULSE)){
                     qotaMasterIdPulse = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(DROPTHOUGHT)){
                     qotaMasterIdDT = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(GEODATAFY)){
                     qotaMasterIdGeoDataFY = qlst.id;
                 }else if(null != qlst.Product_Type__c && qlst.Product_Type__c.equalsIgnoreCase(FSAP)){
                     qotaMasterIdFSAP = qlst.id;
                 }
                 else{
                       qotaMasterId = qlst.id;
                 }
            
             }   
       
          populateProductInQuotaDetail();
          
          qotaOvl = new Map<String, decimal>();
          qotaAssy = new Map<String, decimal>();
          qotaRetina = new Map<String, decimal>();
          qotaPulse = new Map<String, decimal>();
          qotaDT = new Map<String, decimal>();
          qotaCuetrack = new Map<String, decimal>();
          qotaCuetrans = new Map<String, decimal>();
          qotaGeoDataFY = new Map<String, decimal>();
          qotaFSAP = new Map<String, decimal>();
          
          for(innerClsQuota eachQuotaDetail : innerRwlst){
              IF(eachQuotaDetail.qDet.Product_Type_QDET__c.equalsIgnoreCase('OVERALL')){
                  qotaOvl.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c)+ String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Quota_Amount__c != null ? eachQuotaDetail.qDet.Quota_Amount__c : 0 );
                 // qotaOvl.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c)+ String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Hidden_Quota__c != null ? eachQuotaDetail.qDet.Hidden_Quota__c : 0 );
                  qotaAssy.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Asymmetrix_Quota__c != null ? eachQuotaDetail.qDet.Asymmetrix_Quota__c : 0);
                  qotaRetina.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Retina_Qutoa__c != null ? eachQuotaDetail.qDet.Retina_Qutoa__c : 0);
                  qotaPulse.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Pulse_Quota__c != null ? eachQuotaDetail.qDet.Pulse_Quota__c : 0 );
                  qotaDT.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Dropthought_Quota__c != null ? eachQuotaDetail.qDet.Dropthought_Quota__c : 0);
                  qotaCuetrack.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Cuetrack_Quota__c != null ? eachQuotaDetail.qDet.Cuetrack_Quota__c : 0);
                  qotaCuetrans.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.Cuetrans_Quota__c != null ? eachQuotaDetail.qDet.Cuetrans_Quota__c : 0);
                  qotaGeoDataFY.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.GeoDataFY_Quota__c != null ? eachQuotaDetail.qDet.GeoDataFY_Quota__c : 0);
                  qotaFSAP.put(String.valueOf(eachQuotaDetail.qDet.Quota_Month__c) + String.valueOf(eachQuotaDetail.qDet.QuotaYear__c) , eachQuotaDetail.qDet.FSAP_Quota__c != null ? eachQuotaDetail.qDet.FSAP_Quota__c : 0);
                }
              
          }
        for(innerClsQuota eachQDet : innerRwlst)
		{
            if( eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(ASYMMETRIX)){
                 //system.debug('Setting ASSYMETRIX Product quota for   ' + String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdAssy;
                 //system.debug('Setting ASSYMETRIX Product Quota  :  ' +qotaAssy.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c))) ;
                 eachQDet.qDet.Product_Quota__c = qotaAssy.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
               }else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(RETINA)){
                //system.debug('Setting RETINA Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdRetina;
                //system.debug('Setting RETINA Product Quota for :  ' + String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaRetina.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(CUETRACK)){
                 //system.debug('Setting CUETRACK Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdCuetrack;
                 //system.debug('Setting CUETRACK Product Quota :  ' + String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaCuetrack.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(CUETRANS)){
                //system.debug('Setting CUETRANS Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdCuetrans;
                 //system.debug('Setting CUETRANS Product Quota :  ' + String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaCuetrans.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(PULSE)){
                //system.debug('Setting PULSE Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdPulse;
                 //system.debug('Setting PULSE Product Quota for :  ' +String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaPulse.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(DROPTHOUGHT)){
                //system.debug('Setting DROPTHOUGHT Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdDT;
                 //system.debug('Setting DROPTHOUGHT Product Quota for :  ' +String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaDT.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }
            else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(GEODATAFY)){
                //system.debug('Setting GEODATAFY Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdGeoDataFY;
                 //system.debug('Setting GEODATAFY Product Quota for :  ' +String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaGeoDataFY.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }
            else if (eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase(FSAP)){
                //system.debug('Setting FSAP Product ID  ');
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterIdFSAP;
                 //system.debug('Setting FSAP Product Quota for :  ' +String.valueOf(eachQDet.qDet.Quota_Month__c)+' '+ String.valueOf(eachQDet.qDet.QuotaYear__c));
                 eachQDet.qDet.Product_Quota__c = qotaFSAP.get(String.valueOf(eachQDet.qDet.Quota_Month__c)+ String.valueOf(eachQDet.qDet.QuotaYear__c));
				 newQuotas.add(eachQDet.qDet);
            }
            else if(eachQDet.qDet.Product_Type_QDET__c.equalsIgnoreCase('OVERALL')){
                 eachQDet.qDet.QuotaMasterNew__c = qotaMasterId ;
                 newQuotas.add(eachQDet.qDet);
            }
           
		}
         try{
             	system.debug('Inserting Quota Detail and PRODUCT QUOTA DETAIL Object .' + newQuotas);
                insert newQuotas;
             
            }catch(DMLException dmle){
                system.debug('DML Error during new quota insert  ---->'+dmle);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Something went wrong during insert. Please contact application administrator or try again later.'));  
                return null;
            }
       // return new PageReference('/apex/QuotaMasterNew');
        //-------------------Gowtham-introduced for conformation message-------------
        reprID=apexpages.currentpage().getparameters().get('qtaowner');
        fiscalYear=apexpages.currentpage().getparameters().get('qtaPeriod');
        quotaOwner=apexpages.currentpage().getparameters().get('qowner');
        country=apexpages.currentpage().getparameters().get('geoLoc');
        String url = '/apex/QvaDataFetch?geoLoc='+country+'&qowner='+quotaOwner+'&qtaowner='+reprID+'&qtaPeriod='+fiscalYear+'&action=submit';
       	PageReference pageRef = new PageReference(url);
       	pageRef.setRedirect(true);
       	return pageRef;
        //-------------------Gowtham-introduced for conformation message-------------
          
          
    }
    
    public void populateProductInQuotaDetail(){
        System.debug('3 - Appending Product rows to Quota Detail --> ' + innerRwlst.size());
        for(innerClsQuota eachProductRow : innerRwlstProduct) {
            innerRwlst.add(eachProductRow);
        }
           System.debug('4 - Added product quota total size: '+ innerRwlst.size());
   }
    
    public class innerClsQuota{
         
        public QuotaDetail__c qdet {get;set;}
        public String monthName {get;set;}
        public String quarterName {get;set;}
        public String quotaOwnerName {get;set;}
        public String geolocation {get;set;}
        
        
        public innerClsQuota(){
            
			qDet = new QuotaDetail__c();            
        }
        
    }
    
    public String getQuotaMonthName(integer x){
        if(x==1 || x==13){
            return 'January';
        }else if(x==2 || x==14){
            return 'Febuary';
        }else if(x==3 || x==15){
            return 'March';
        }else if(x==4){
            return 'April';
        }else if(x==5){
            return 'May';
        }else if(x==6){
            return 'June';
        }else if(x==7){
            return 'July';
        }else if(x==8){
            return 'August';
        }else if(x==9){
            return 'September';
        }else if(x==10){
            return 'October';
        }else if(x==11){
            return 'November';
        }else{
            return 'December';
        }
       
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
    public String getQuotaQuarterName(integer y){
        
        if(y >= 4 && y <=6){
            return 'FY-Q1';
        }else if(y >= 7 && y <=9){
            return 'FY-Q2';
        }else if(y >= 10 && y <=12){
            return 'FY-Q3';
        }else{
            return 'FY-Q4';
        }
            
    }
    
    public void makeEdit(){
        	isNew =  true;
            isExisting =  false;
        	isUpdate = true;
    }
    
    
  
    
    public PageReference updateQuota(){
      list<QuotaDetail__c> newQuotas = new List<QuotaDetail__c>();
        String country;
        String quotaOwner;
        String fiscalYear;
        String reprID;
        for(Integer j = 0;j<innerRwlst.size();j++)
		{
			newQuotas.add(innerRwlst[j].qDet);
		}
         try{
                update newQuotas;
             
            }catch(DMLException dmle){
                system.debug('DML Error during new quota update  ---->'+dmle);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Something went wrong during update. Please contact application administrator or try again later.'));  
                return null;
            }
        //return new PageReference('/apex/QuotaMasterNew?sfdc.tabName=01rR000000055N7');
        //return new PageReference('/apex/QuotaMasterNew');
         //-------------------Gowtham-introduced for conformation message-------------
        reprID=apexpages.currentpage().getparameters().get('qtaowner');
        fiscalYear=apexpages.currentpage().getparameters().get('qtaPeriod');
        quotaOwner=apexpages.currentpage().getparameters().get('qowner');
        country=apexpages.currentpage().getparameters().get('geoLoc');
        String url = '/apex/QvaDataFetch?geoLoc='+country+'&qowner='+quotaOwner+'&qtaowner='+reprID+'&qtaPeriod='+fiscalYear+'&action=update';
       	System.debug('After Update URL -----'+ url);
       	PageReference pageRef = new PageReference(url);
       	pageRef.setRedirect(true);
       	return pageRef;
        //-------------------Gowtham-introduced for conformation message-------------
       	
    }
    
    public PageReference navback(){
          PageReference pr = new PageReference('/apex/QuotaMasterNew');
        return pr;
        
    }
    
}