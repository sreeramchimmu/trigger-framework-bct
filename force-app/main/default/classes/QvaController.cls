public class QvaController {

    public String fiscalYear {get;set;}
    public Id repId {get;set;}
    List<SelectOption> options;
    //public boolean resultdisp {get;set;}
    //public List<QVA__c> qvaResultList;
    public map<String, String> usermap;
    
    
    public void QvaController(){
      	system.debug('Conrtoller Class Constructor Called 1---->');
	  }
    
    public List<SelectOption> getItems() {
      		options = new List<SelectOption>();
	        options.add(new SelectOption('2013-2014','FY13-14'));
	        options.add(new SelectOption('2014-2015','FY14-15'));        
        	options.add(new SelectOption('2015-2016','FY15-16'));
        	options.add(new SelectOption('2016-2017','FY16-17'));
            options.add(new SelectOption('2017-2018','FY17-18'));
            options.add(new SelectOption('2018-2019','FY18-19'));
        	options.add(new SelectOption('2019-2020','FY19-20'));
        return options;
	    }
    
    public PageReference fetchQVA() {
       String url = '/apex/QvaDataFetch?qtaowner='+repId+'&qtaPeriod='+fiscalYear+'&qowner='+usermap.get(repId);
       PageReference pageRef = new PageReference(url);
       pageRef.setRedirect(false);
       return pageRef;
      }
    
    
      public List<SelectOption> getReportingManagers() {
        system.debug('Get LOV items');
        List<SelectOption> reps;
       	List<User> reportingMgrs = [Select FirstName, LastName, Id from user where managerid =:UserInfo.getUserId()];
            system.debug('Get Reporting managers' + reportingMgrs);
          if(null != reportingMgrs && reportingMgrs .size() > 0){
              reps = new List<SelectOption>();
               reps.add(new SelectOption('0', '--None--'));
              usermap = new Map<String, String>();
           for(User repMgr : reportingMgrs){
              usermap.put(repMgr.Id, repMgr.FirstName + ' ' + repMgr.LastName);
              reps.add(new SelectOption(repMgr.Id, repMgr.FirstName + ' ' + repMgr.LastName));
               
          		} 
              
          }else{
               reps = new List<SelectOption>();
               reps.add(new SelectOption('0', '--None--'));
          }
        return reps;
	    }
   /* public PageReference retrieveQVA (){
        
        String url = '/apex/QuotaVsActualScr?qtaowner='+repId+'&qtaPeriod='+fiscalYear+'&qowner='+usermap.get(repId);
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(false);
        return pageRef;        
    }*/
    
}