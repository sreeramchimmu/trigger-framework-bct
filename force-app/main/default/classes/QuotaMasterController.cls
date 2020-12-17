public class QuotaMasterController {
    
    public String fiscalYear {get;set;}
    public Id repId {get;set;}
    List<SelectOption> options;
    public map<String, String> usermap{get;set;}
    
    public QuotamasterNew__c quotaMaster 
		{get;set;}
    
    
    public QuotaMasterController(){
        
        
        String uRoleId = UserInfo.getUserRoleId();
        System.debug('uRoleId' + UserInfo.getUserRoleId());
        
    }
    

    /*public List<SelectOption> getGeoLocation() {
      		options = new List<SelectOption>();
        	options.add(new SelectOption('India','India'));
	        options.add(new SelectOption('Bahrain','Bahrain'));
	        options.add(new SelectOption('Brunei','Brunei'));        
        	options.add(new SelectOption('Egypt','Egypt'));
        	options.add(new SelectOption('Ghana','Ghana'));
        	options.add(new SelectOption('India','India'));
            options.add(new SelectOption('Kenya','Kenya'));
            options.add(new SelectOption('Kuwait','Kuwait'));
        	options.add(new SelectOption('Oman','Oman'));
        	options.add(new SelectOption('Singapore','Singapore'));
            options.add(new SelectOption('Sri Lanka','Sri Lanka'));
            options.add(new SelectOption('Tanzania','Tanzania'));
            options.add(new SelectOption('UAE','UAE'));
            options.add(new SelectOption('USA','USA'));
        	options.add(new SelectOption('IVMS','IVMS'));
        	
        return options;
	    }*/
   public List<SelectOption> getItems() {
      		options = new List<SelectOption>();
            options.add(new SelectOption('0', '--None--'));
        	options.add(new SelectOption('2012-2013','FY2012-2013'));
	        options.add(new SelectOption('2013-2014','FY2013-2014'));
	        options.add(new SelectOption('2014-2015','FY2014-2015'));        
        	options.add(new SelectOption('2015-2016','FY2015-2016'));
        	options.add(new SelectOption('2016-2017','FY2016-2017'));
            options.add(new SelectOption('2017-2018','FY2017-2018'));
            options.add(new SelectOption('2018-2019','FY2018-2019'));
        	options.add(new SelectOption('2019-2020','FY2019-2020'));
        	options.add(new SelectOption('2020-2021','FY2020-2021'));
            options.add(new SelectOption('2021-2022','FY2021-2022'));
            options.add(new SelectOption('2022-2023','FY2022-2023'));
            options.add(new SelectOption('2023-2024','FY2023-2024'));
            options.add(new SelectOption('2024-2025','FY2024-2025'));
        	
        return options;
	    }
    
    
 	public List<SelectOption> getReportees() {
        system.debug('Get LOV items');
        String geolocChosen;
        List<SelectOption> reps;
       	List<User> reportingMgrs = [Select FirstName, LastName, Id, Country, User_s_SBU__c, currencyIsoCode from user where managerid =:UserInfo.getUserId() AND isActive = true];
            system.debug('Get Reporting managers' + reportingMgrs);
          if(null != reportingMgrs && reportingMgrs .size() > 0){
               reps = new List<SelectOption>();
               reps.add(new SelectOption('', '--None--'));
              usermap = new Map<String, String>();
           for(User repMgr : reportingMgrs){
                system.debug('Get Reporting managers country' + repMgr.Country);
              
               if(null != repMgr.User_s_SBU__c && repMgr.User_s_SBU__c != '') {
              		geolocChosen = repMgr.User_s_SBU__c;      
                   
               		}else{
                   		geolocChosen = getCountry(repMgr.currencyIsoCode);		
               		}
               	
              		usermap.put(repMgr.Id, repMgr.FirstName + ' ' + repMgr.LastName+'~'+geolocChosen);
              		reps.add(new SelectOption(repMgr.Id, repMgr.FirstName + ' ' + repMgr.LastName));
               
          		} 
              
          }else{
               reps = new List<SelectOption>();
               reps.add(new SelectOption('0', '--None--'));
          }
        return reps;
	    }    
    
    public String getCountry(String currenyCode){
        if(currenyCode == 'USD'){
            return 'USA';
        }else if(currenyCode == 'AED'){
             return 'UAE';
        }else if(currenyCode == 'BND'){
             return 'Brunei';
        }else if(currenyCode == 'INR'){
             return 'India';
        }else if(currenyCode == 'OMR'){
             return 'Oman';
        }else if(currenyCode == 'QAR'){
             return 'Qatar';
        }else if(currenyCode == 'SGD'){
             return 'Singapore';
        }
        
        return 'India';
    }
    
      public PageReference setOrFetchQuota() {
         System.debug('fiscalYear -----'+ fiscalYear);
           System.debug('Repid -----'+ repId);
          if(fiscalYear.equalsIgnoreCase('0') || repId ==null ){
             ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Please provide values to continue.');
             ApexPages.addMessage(errMsg);
             return null; 
          }   
       String userdet =  usermap.get(repId);
          String country;
          String quotaOwner;
          System.debug('Userdet -----'+ userdet);
          if(userdet!=null){
              	country = userdet.subString(userdet.indexOf('~')+1, userdet.length());       
                         System.debug('User SBU -----'+ country);
              /*if(country.equalsIgnoreCase('103 - LOGISTICS')){
                  country = 'IVMS';
              }*/
              	quotaOwner = userdet.substring(0, userdet.indexOf('~'));
          }
		
       //String url = '/apex/QvaDataFetch?qtaowner='+repId+'&qtaPeriod='+fiscalYear+'&qowner='+quotaOwner+'&geoLoc='+country; 
         
       //-------------------Gowtham-introduced for conformation message-------------
       String url = '/apex/QvaDataFetch?qtaowner='+repId+'&qtaPeriod='+fiscalYear+'&qowner='+quotaOwner+'&geoLoc='+country+'&action=create';
          
       System.debug('URL -----'+ url);
       PageReference pageRef = new PageReference(url);
       pageRef.setRedirect(false);
       return pageRef;
      }
}