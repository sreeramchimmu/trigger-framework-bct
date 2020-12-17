/*
Name		: RevenueMutiLineEdit
Description : To edit a mutiple revenue terms in one action
Date		: 4-Nov-2019
Created By  : Gowthamkumar 
*/
public  class RevenueMutiLineEdit { 
    
    public List<Opportunity> oppList{get;set;}
    public List<Opportunity_Line_Item__c> oppLineList{get;set;}
    public List<Revenue_term__c> revList;
    public List<wrapRevenue> wrapRevenueList{get;set;}
    public boolean showPopup {get;set;}
    public String popupButtonAction {get;set;}
    public boolean noRecords{get;set;}
    public String isSplitEqually{get;set;}

    public String userCurrency{get;set;}
    
    // public boolean isCheckedInividual
    public static String oppLineId;
    public double availableAmtSum=0;
    public String action='';
	
    //wrapper class -  http://www.sfdcpoint.com/salesforce/wrapper-class-in-apex/
    public class wrapRevenue{
        public Revenue_term__c rev {get;set;}
        public boolean isChecked{get;set;}
        public double availableAmt{get;set;}
        public double balanceAmt{get;set;}
        public wrapRevenue(Revenue_term__c r){
            rev = r;
            isChecked = false;
        }
    }   

    
    public RevenueMutiLineEdit(){
       
        if(wrapRevenueList==null){
            wrapRevenueList = new List<wrapRevenue>();
            oppLineId = String.valueOf(ApexPages.currentPage().getParameters().get('id'));
            //system.debug('oppLineId------>'+oppLineId);
          
            List<Revenue_term__c> revList=[select id,CurrencyIsoCode,Actual_Forecast_Rev__c,Current_FY_Act_Fst_Raw_Rev__c,Overall_Act_Forecast_Revenue__c,Total_Revenue_Raw_Fcst__c,name,Milestone__c,Percentage__c,Opportuntiy_Stage__c,Opp_Line_Amount__c,Revenue_Date__c,Funnel_Code_Rev__c,Probability_In_Rev__c,Change_Reason__c,Milestone_Basis__c,Amount__c,Total_COGS_BCTPL_Rev__c,Total_COGS_Others_Rev__c,Geo_Margin__c,Recognized_Amount__c,Actual_COGS_BCTPL__c,Actual_COGS_Others__c,Actual_GM__c from Revenue_term__c where Opportunity_line_item_id__c = :oppLineId order by Revenue_Date__c ASC];
            noRecords=false;
            
        
            if(revList.size()>0){
                
                 //added by sreeram on 13-Jul-2020 for displaying currencycode in RevenueMultiEdit page's column(Milestone Amount) :::STARTS::: 
            		userCurrency  = revList[0].CurrencyIsoCode;
            		//system.debug('userCurrency::: '+userCurrency);
         		//added by sreeram on 13-Jul-2020 for displaying currencycode in RevenueMultiEdit page's column(Milestone Amount) :::ENDS::: 
            
                
                for(Revenue_term__c r:revList){                    
                    wrapRevenueList.add(new wrapRevenue(r));
                    availableAmtSum += r.Percentage__c;
                }
                wrapRevenueList[0].availableAmt= availableAmtSum;
                wrapRevenueList[0].balanceAmt  = wrapRevenueList[0].rev.Opp_Line_Amount__c - availableAmtSum;
                //system.debug('Recognized_Amount__c------>'+wrapRevenueList[0].rev.Recognized_Amount__c);
                //system.debug('Percentage__c------>'+wrapRevenueList[0].rev.Percentage__c);
                showPopup = false;
                
                action = String.valueOf(ApexPages.currentPage().getParameters().get('action'));
                if(action.equalsIgnoreCase('update')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Revenues are updated successfully...'));
                }else if(action.equalsIgnoreCase('delete')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Revenues are deleted successfully...'));
                }else if(action.equalsIgnoreCase('splitEqually')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Revenues values are splited equally based on Total Opp.Line amount '+wrapRevenueList[0].rev.Opp_Line_Amount__c+'...'));
                }
                    
            }
      
            else{             
               noRecords=true;                      
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There are no Revenues...'));
                
            }
        }
    }

    public pageReference saveRevenue(){ 
        try{
            revList = new List<Revenue_term__c>();
            for(wrapRevenue wrapRevenueObj:wrapRevenueList){                
                revList.add(wrapRevenueObj.rev);
                wrapRevenueObj.isChecked=false;
            }
            
           	update revList;
           
            PageReference pageRef = new PageReference('/apex/RevenueMutiEdit');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('id',String.valueOf(ApexPages.currentPage().getParameters().get('id')));
            pageRef.getParameters().put('action','update');
            return pageRef; 
            
        }catch(Exception e){         
            ApexPages.addMessages(e);
            return null;
        }
    }

    public pageReference deleteRevenue(){ 
        try{
            string a='';
            revList = new List<Revenue_term__c>();
            for(wrapRevenue wrapRevenueObj:wrapRevenueList){
                if(wrapRevenueObj.isChecked){ 
                    revList.add(wrapRevenueObj.rev);
                }
            }
           delete revList;
            PageReference pageRef = new PageReference('/apex/RevenueMutiEdit');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('id',String.valueOf(ApexPages.currentPage().getParameters().get('id')));
            pageRef.getParameters().put('action','delete');
            return pageRef;
        }catch(Exception e){            
            ApexPages.addMessages(e);
            return null;
        }
    }
    

    public PageReference openPopup()
    {   
       
        String popupAction = ApexPages.currentPage().getParameters().get('actionParam');
        if(popupAction.equalsIgnoreCase('delete')){
            for(wrapRevenue wrapRevenueObj:wrapRevenueList){
                if(wrapRevenueObj.isChecked){
                    showPopup = true;
                    popupButtonAction='delete';
                    break;
                }
            }
            if(!showPopup){ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the Revenues..'));}
        }else if(popupAction.equalsIgnoreCase('splitValues')){
            popupButtonAction='splitValues';
            showPopup = true;
        }
        
        return null;
    }

      public pageReference splitValuesEqually(){
        try{
            revList = new List<Revenue_term__c>();
            Integer oppLineValue = Integer.valueOf(wrapRevenueList[0].rev.Opp_Line_Amount__c); 
            Integer revListCount = Integer.valueOf(wrapRevenueList.size());  
            Integer splitValues  = oppLineValue/revListCount; 
            Integer remainingValues = oppLineValue-(splitValues*revListCount);
        
            for(Integer i=0;i<revListCount;i++){
                if(i==(revListCount-1)){splitValues+=remainingValues;} 
                wrapRevenueList[i].rev.Percentage__c=splitValues;
                String commends = 'Total Opp.Line amount('+oppLineValue+') has been divided equally.';
                //if(wrapRevenueList[i].rev.Change_Reason__c!=null && wrapRevenueList[i].rev.Change_Reason__c.contains(commends)){
                if(wrapRevenueList[i].rev.Change_Reason__c!=null){
                    wrapRevenueList[i].rev.Change_Reason__c= wrapRevenueList[i].rev.Change_Reason__c+';'+commends;
                }else if(wrapRevenueList[i].rev.Change_Reason__c==null){
                    wrapRevenueList[i].rev.Change_Reason__c= commends;
                }
                //wrapRevenueList[i].isChecked=true;              
                revList.add(wrapRevenueList[i].rev);
            }
            update revList;
            PageReference pageRef = new PageReference('/apex/RevenueMutiEdit');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('id',String.valueOf(ApexPages.currentPage().getParameters().get('id')));
            pageRef.getParameters().put('action','splitEqually');
            return pageRef;
        }catch(Exception e){          
            ApexPages.addMessages(e);
            return null; 
        }
    }

    public pageReference resetPage(){
        PageReference pageRef = new PageReference('/apex/RevenueMutiEdit');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('id',String.valueOf(ApexPages.currentPage().getParameters().get('id')));
        pageRef.getParameters().put('action','');
        return pageRef;
    }

    public pageReference navBack(){
        PageReference pr =  new PageReference('/'+String.valueOf(ApexPages.currentPage().getParameters().get('id')));
        return pr;
    }
    
    public PageReference Cancel()
    {
        showPopup = false;
        return null;
    }  
    public PageReference addSplitRev()
    {    noRecords=true;       
         PageReference pr =  new PageReference('/apex/SplitRevTermIntermed?scontrolCaching=1&id='+String.valueOf(ApexPages.currentPage().getParameters().get('id')));
        return pr;
   
    }
 
}