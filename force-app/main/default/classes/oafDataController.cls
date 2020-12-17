public class oafDataController {
    public static Integer ROWS_PER_PAGE = 1000; 
    public List<Opportunity> opmQuery{get;set;}
    public List<Contact> cntLst{get;set;}
    public List<Revenue_Term__c> RevenueLst{get;set;}
    public String account_ID{get;set;}
    public List<opportunity> opmlst{get;set;}
    public List<opportunity_line_item__c> opplinelst{get;set;}
    public id[] accountids = new id[]{};
    public String contactName{get;set;}
    public integer mCogs_Bctpl{get;set;}
    public integer mCogs_Others{get;set;}
    public integer mGeo_margin{get;set;}
    public integer mtot_Geo_margin_perc{get;set;}
    public integer mTotal_value{get;set;}
    public String mCurrencyIsoCode{get;set;}
   //public oafDataController() 
   public oafDataController(ApexPages.StandardController controller)
    {
        opmlst = new list<opportunity>();
        opmlst = [SELECT Opportunity_number_new__c,createdDate,account.name,account.industry,sbu__c,name,owner.name,owner.employeenumber,owner.phone,owner.email
                     ,account.BillingStreet, account.billingCity, account.BillingState, account.BillingPostalCode, account.BillingCountry
                     ,contract_po_number__c,contract_po_sign_date__c,LINE_ITEM_TOTAL__C, Line_Balance_Amount__c 
                     ,CurrencyIsoCode,amount,project_start_date__c,project_end_date__c
                     ,Project_Duration__c,sales_channel__c,accountID, Project_manager__c
                     ,Recognized_Revenue__c, Total_COGS_BCTPL_Opp__c, Total_COGS_Others_Opp__c 
                     ,Total_Gross_Margin__c,Total_Gross_Margin_Percent__c 
                 FROM Opportunity where id =:ApexPages.currentPage().getParameters().get('id')];
                 //'006g000000FFnIa'];   
        
      // cntLst = new list<contact>(); '001g000001imELr'
       account_ID = opmlst.get(0).accountID;
       cntLst = [SELECT Name, account.name from CONTACT where accountid = :account_ID ];
                                                 //WHERE accountid = :ApexPages.currentPage().getParameters().get('accountid') Limit 1]; 
            
        opplinelst = [SELECT Revenue_Stream__c,Practice__c,Total_Value__c,
                      Geo_Margin__c,Total_GEO_Margin__c, COGS_Others__c, COGS_BCTPL__c,CurrencyIsoCode  FROM Opportunity_line_item__c 
                     WHERE Opportunity_ID__c =:ApexPages.currentPage().getParameters().get('id') ORDER BY Practice__c];
                      //'006g000000FFnIa'
        mTotal_value = 0; 
        mGeo_margin = 0;
        mCogs_Others = 0;
        mCogs_Bctpl = 0;
        mtot_Geo_margin_perc=0;
        mCurrencyIsoCode='';
        if(opplinelst.size()>0)                     
                      {
                          for (Opportunity_line_item__c opplinelsts: opplinelst)
                          {
                            mTotal_value=mTotal_value+integer.valueof(opplinelsts.Total_Value__c); 
                            mCurrencyIsoCode = opplinelsts.CurrencyIsoCode;
                            if(opplinelsts.COGS_BCTPL__c == null )  
                            {
                                mCogs_Bctpl= mCogs_Bctpl+0; 
                            }
                             else
                             {
                               mCogs_Bctpl= mCogs_Bctpl+integer.valueof(opplinelsts.COGS_BCTPL__c);    
                             }
                            if(opplinelsts.COGS_Others__c == null )  
                            {
                                mCogs_Others= mCogs_Others+0; 
                            }
                             else
                             {
                              mCogs_Others=mCogs_Others+integer.valueof(opplinelsts.COGS_Others__c); 
                             }
                             if(opplinelsts.Geo_margin__c == null )  
                            {
                                mGeo_margin = mGeo_margin + 0; 
                            }
                             else
                             {
                               mGeo_margin=mGeo_margin+integer.valueof(opplinelsts.Geo_margin__c); 
                             } 
                            /* if(opplinelsts.Total_GEO_Margin__c == null ) 
                             {
                               mtot_Geo_margin_perc = 0; 
                             }
                             else
                             {
                               mtot_Geo_margin_perc=integer.valueof(opplinelsts.Total_GEO_Margin__c); 
                             }*/
                          }
                      }
        system.debug('Total Value : Opportunity line item '+mCurrencyIsoCode+mTotal_value);                     
        RevenueLst = [SELECT Milestone__c, opportunity_line_item_id__r.revenue_stream__c,opportunity_line_item_id__r.Practice__c
                      ,Revenue_Date__c, Milestone_Amount__c 
                      FROM Revenue_Term__c where Opportunity_item_id__c=:ApexPages.currentPage().getParameters().get('id')
                      //'006g000000FFnIa'
                      ORDER BY opportunity_line_item_id__r.Practice__c];
        //             account_id = oplst.add(accountID);
        //              opportunity_line_item__c.Revenue_Stream__c
        //cntLst = [SELECT Name, account.name from CONTACT WHERE accountid IN :oplst.accountid Limit 1]; 
     
        
     /*FOR (Opportunity opp : oplst)  
       {
         account_ID = opp.accountID;
         //accountids.add(opp.accountID);
          // account_ID = oplst.accountID;              
       }
        cntLst = [SELECT Name, account.name from CONTACT WHERE accountid = :account_ID Limit 1]; 
         //cntLst = [SELECT firstName from CONTACT WHERE accountid='001g000001imELr']; */
      
    }
    /*
    public pageReference close()
    {
        PageReference pageRef = new PageReference('/apex/test');
        pageRef.setRedirect(true);
        return pageRef;   

    }*/
    public PageReference page1()
    {
    return Page.ThankYouPG;   
    }
}