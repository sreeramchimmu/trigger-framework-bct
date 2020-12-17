@isTest
public class IncentiveMonthlyProcessorTestCls {
 		public static String CRON_EXP = '0 7 2 6 11 ? 2020';  
      
    static testMethod void processMonthlyIncentive(){
     
       List<TriggerSwitch__c> trigList =  new List<TriggerSwitch__c>();
        TriggerSwitch__c trigObj1 = new TriggerSwitch__c(Name='QuotaVsActual', 	IS_ACTIVE__c=true);
        TriggerSwitch__c trigObj2 = new TriggerSwitch__c(Name='OppTotalValueCheckTrigger', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj3 = new TriggerSwitch__c(Name='updateLineItemStages', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj4 = new TriggerSwitch__c(Name='shiftSubsequentRevDates', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj5 = new TriggerSwitch__c(Name='shiftSubsequentDates', 	IS_ACTIVE__c=false);
        TriggerSwitch__c trigObj6 = new TriggerSwitch__c(Name='OppStageChangeListenerTrigger', 	IS_ACTIVE__c=true);
        
        trigList.add(trigObj1);
        trigList.add(trigObj2);
        trigList.add(trigObj3);
        trigList.add(trigObj4);
        trigList.add(trigObj5);
         trigList.add(trigObj6);
        insert trigList;
        
        // QuotaMasterNew__c newQmst = new QuotaMasterNew__c(SBU__c= 'USA', Quota_Start_Period__c = date.newInstance(2018, 04, 01), Quota_End_Period__c= date.newInstance(2019,03,31), Quota_Owner_Name__c='0050x000000HfW4', OwnerId='0050x000000HfW4', Quota_Period__c='2018-2019', CurrencyIsoCode='USD', Product_Type__c='OVERALL');
        // insert newQmst;
        	QuotaMasterNew__c newQmstProd = new QuotaMasterNew__c(SBU__c= 'USA', Quota_Start_Period__c = date.newInstance(2018, 04, 01), Quota_End_Period__c= date.newInstance(2019,03,31), Quota_Owner_Name__c='00515000006ML4D', OwnerId='00515000006ML4D', Quota_Period__c='2018-2019', CurrencyIsoCode='USD', Product_Type__c='OVERALL');
        	insert newQmstProd;
        List<QuotaMasterNew__c> insertedQmsts = [select id from quotaMasterNew__c  where Quota_Period__c='2018-2019'];
       // for(QuotaMasterNew__c insertedQmst: insertedQmsts){
            QuotaDetail__c newQDet1 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 04, 01), QuotaYear__c =2018 , Quota_Month__c =4 , Quota_Quarter__c=1, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet2 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 05, 01), QuotaYear__c =2018 , Quota_Month__c =5 , Quota_Quarter__c=1, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet3 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 06, 01), QuotaYear__c =2018 , Quota_Month__c =6 , Quota_Quarter__c=1, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet4 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 07, 01), QuotaYear__c =2018 , Quota_Month__c =7 , Quota_Quarter__c=2, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet5 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 08, 01), QuotaYear__c =2018 , Quota_Month__c =8 , Quota_Quarter__c=2, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet6 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 09, 01), QuotaYear__c =2018 , Quota_Month__c =9 , Quota_Quarter__c=2, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet7 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 10, 01), QuotaYear__c =2018 , Quota_Month__c =10 , Quota_Quarter__c=3, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet8 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 11, 01), QuotaYear__c =2018 , Quota_Month__c =11 , Quota_Quarter__c=3, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet9 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2018, 12, 01), QuotaYear__c =2018 , Quota_Month__c =12 , Quota_Quarter__c=3, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet10 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2019, 01, 01), QuotaYear__c =2019 , Quota_Month__c =1 , Quota_Quarter__c=4, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet11 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2019, 02, 01), QuotaYear__c =2019 , Quota_Month__c =2 , Quota_Quarter__c=4, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
            QuotaDetail__c newQDet12 = new QuotaDetail__c(QuotaMasterNew__c = insertedQmsts[0].id , Quota_Date__c = date.newInstance(2019, 03, 01), QuotaYear__c =2019 , Quota_Month__c =3 , Quota_Quarter__c=4, Revised_L0L0XL1_Quota__c = 1000, Revised_L0L0XL1L2L3_Quota__c = 1000, New_Quota__c = 1000, Quota_Amount__c = 1000, CurrencyIsoCode='USD',  Product_Type_QDET__c='OVERALL', Asymmetrix_Quota__c=100, Cuetrack_Quota__c=100, Cuetrans_Quota__c=100, Dropthought_Quota__c=100, Pulse_Quota__c=100,Retina_Qutoa__c=100);
        			insert newQDet1;
                    insert newQDet2;
                    insert newQDet3;
                    insert newQDet4;
                    insert newQDet5;
                    insert newQDet6;
                    insert newQDet7;
                    insert newQDet8;
                    insert newQDet9;
                    insert newQDet10;
                    insert newQDet11;
                    insert newQDet12;
               //   }
            Incentive_Scheme__c incentiveScheme1 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='PRODUCTS', IC_REVENUE_STREAM__C='TIBCO Product License', INCENTIVE_SCHEME_TYPE__C='Executive VC', R31TO50__C = 0.45 , R51TO75__C = 0.9 , R76TO90__C = 1.35 , R91TO100__C = 1.8 , R101TO110__C = 2.25 , R110PLUS__C = 3 , INCENTIVE_TERM__C='Quarterly',	 INCENTIVE_PERIOD__C='2018-2019');
			Incentive_Scheme__c incentiveScheme2 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='PRODUCTS', IC_REVENUE_STREAM__C='SI Products',	INCENTIVE_SCHEME_TYPE__C='Executive VC', R31TO50__C = 0.09 , R51TO75__C = 0.18 , R76TO90__C = 0.27 , R91TO100__C = 0.36 , R101TO110__C = 0.45 , R110PLUS__C = 0.6 , INCENTIVE_TERM__C='Quarterly', INCENTIVE_PERIOD__C='2018-2019');
            Incentive_Scheme__c incentiveScheme3 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='PRODUCTS',	IC_REVENUE_STREAM__C='BCT IP', INCENTIVE_SCHEME_TYPE__C='Executive VC', R31TO50__C = 0.68 , R51TO75__C = 1.35 , R76TO90__C = 2.03 , R91TO100__C = 2.7 , R101TO110__C = 3.38 , R110PLUS__C = 4.5 , INCENTIVE_TERM__C='Quarterly', INCENTIVE_PERIOD__C='2018-2019');
            Incentive_Scheme__c incentiveScheme4 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='SERVICES', IC_REVENUE_STREAM__C='BCT Enterprise Services', INCENTIVE_SCHEME_TYPE__C='Executive VC', R31TO50__C = 0.38 , R51TO75__C = 0.75 , R76TO90__C = 1.13 , R91TO100__C = 1.5 , R101TO110__C = 1.88 ,	 R110PLUS__C = 2.5 , INCENTIVE_TERM__C='Quarterly',	INCENTIVE_PERIOD__C='2018-2019');
            Incentive_Scheme__c incentiveScheme5 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='SERVICES',	IC_REVENUE_STREAM__C='Professional Services', INCENTIVE_SCHEME_TYPE__C='Executive VC',	R31TO50__C = 0.09 ,	R51TO75__C = 0.18 ,	R76TO90__C = 0.27 ,	R91TO100__C = 0.36 , R101TO110__C = 0.45 , R110PLUS__C = 0.6 , INCENTIVE_TERM__C='Quarterly', INCENTIVE_PERIOD__C='2018-2019');
            Incentive_Scheme__c incentiveScheme6 = new Incentive_Scheme__c(IC_BUSINESS_CATEGORY__C='SERVICES',	IC_REVENUE_STREAM__C='BCT approved Digital & TIBCO Services',	INCENTIVE_SCHEME_TYPE__C='Executive VC', R31TO50__C = 0.23 , R51TO75__C = 0.45 , R76TO90__C = 0.68 , R91TO100__C = 0.9 , R101TO110__C = 1.13 ,	R110PLUS__C = 1.5 ,	INCENTIVE_TERM__C='Quarterly',	INCENTIVE_PERIOD__C='2018-2019' );
           
        			insert incentiveScheme1;
                    insert incentiveScheme2;
                    insert incentiveScheme3;
                    insert incentiveScheme4;
                    insert incentiveScheme5;
                    insert incentiveScheme6;
        
        Incentive_Master__c incmstQ1 = new Incentive_Master__c(SBU__c = 'USA',Incentive_Quarter__c=1, Incentive_Start_Period__c = date.newInstance(2018, 04, 01), Quarterly_Overall_Quota__c = 3000, Quarterly_IP_Quota__c = 1800, Quarterly_Overall_Actual__c = 0 , BCT_IP_L0L0X_QtrActualsRev__c = 0, BCTIP_L1_Qtr_Rev__c = 0, BCTIP_L2L3_QtrRev__c = 0, BCT_Svcs_L0L0X_Qtr_Rev__c = 0,	BCT_Svcs_L1_Qtr_Rev__c = 0, BCT_Svcs_L2_Qtr_Rev__c = 0, Ext_Contracts_L0L0X_Qtr_Rev__c = 0, Ext_Contracts_L1_Qtr_Rev__c = 0,  Ext_Contracts_L2L3_Qtr_Rev__c = 0, New_Logo_L0L0X_Qtr_Rev__c = 0, New_Logo_L1_Qtr_Rev__c = 0, New_Logo_L2L3_Qtr_Rev__c = 0, PSvc_L0L0X_Qtr_Rev__c = 0, PSvc_L1_Qtr_Rev__c = 0, PSvc_L2L3_Qtr_Rev__c = 0, SI_Products_L0L0X_Qtr_Rev__c = 0, SI_Products_L1_Qtr_Rev__c = 0, SI_Products_L2L3_Qtr_Rev__c = 0, Incentive_BCT_IP__c = 0, Incentive_BCT_Services__c = 0, Incentive_ExistingContract__c = 0, Incentive_SI_Products__c = 0, 	Incentive_ProfSvcs__c = 0, Yearly_IP_Incentive__c = 0, Yearly_Net_New_Business_Incentive__c = 0, Quota_Period__c = '2018-2019');
        Incentive_Master__c incmstQ2 = new Incentive_Master__c(SBU__c = 'USA',Incentive_Quarter__c=2, Incentive_Start_Period__c = date.newInstance(2018, 07, 01), Quarterly_Overall_Quota__c = 3000, Quarterly_IP_Quota__c = 1800, Quarterly_Overall_Actual__c = 0 , BCT_IP_L0L0X_QtrActualsRev__c = 0, BCTIP_L1_Qtr_Rev__c = 0, BCTIP_L2L3_QtrRev__c = 0, BCT_Svcs_L0L0X_Qtr_Rev__c = 0,	BCT_Svcs_L1_Qtr_Rev__c = 0, BCT_Svcs_L2_Qtr_Rev__c = 0, Ext_Contracts_L0L0X_Qtr_Rev__c = 0, Ext_Contracts_L1_Qtr_Rev__c = 0,  Ext_Contracts_L2L3_Qtr_Rev__c = 0, New_Logo_L0L0X_Qtr_Rev__c = 0, New_Logo_L1_Qtr_Rev__c = 0, New_Logo_L2L3_Qtr_Rev__c = 0, PSvc_L0L0X_Qtr_Rev__c = 0, PSvc_L1_Qtr_Rev__c = 0, PSvc_L2L3_Qtr_Rev__c = 0, SI_Products_L0L0X_Qtr_Rev__c = 0, SI_Products_L1_Qtr_Rev__c = 0, SI_Products_L2L3_Qtr_Rev__c = 0, Incentive_BCT_IP__c = 0, Incentive_BCT_Services__c = 0, Incentive_ExistingContract__c = 0, Incentive_SI_Products__c = 0, 	Incentive_ProfSvcs__c = 0, Yearly_IP_Incentive__c = 0, Yearly_Net_New_Business_Incentive__c = 0, Quota_Period__c = '2018-2019');
        Incentive_Master__c incmstQ3 = new Incentive_Master__c(SBU__c = 'USA',Incentive_Quarter__c=3, Incentive_Start_Period__c = date.newInstance(2018, 10, 01), Quarterly_Overall_Quota__c = 3000, Quarterly_IP_Quota__c = 1800, Quarterly_Overall_Actual__c = 0 , BCT_IP_L0L0X_QtrActualsRev__c = 0, BCTIP_L1_Qtr_Rev__c = 0, BCTIP_L2L3_QtrRev__c = 0, BCT_Svcs_L0L0X_Qtr_Rev__c = 0,	BCT_Svcs_L1_Qtr_Rev__c = 0, BCT_Svcs_L2_Qtr_Rev__c = 0, Ext_Contracts_L0L0X_Qtr_Rev__c = 0, Ext_Contracts_L1_Qtr_Rev__c = 0,  Ext_Contracts_L2L3_Qtr_Rev__c = 0, New_Logo_L0L0X_Qtr_Rev__c = 0, New_Logo_L1_Qtr_Rev__c = 0, New_Logo_L2L3_Qtr_Rev__c = 0, PSvc_L0L0X_Qtr_Rev__c = 0, PSvc_L1_Qtr_Rev__c = 0, PSvc_L2L3_Qtr_Rev__c = 0, SI_Products_L0L0X_Qtr_Rev__c = 0, SI_Products_L1_Qtr_Rev__c = 0, SI_Products_L2L3_Qtr_Rev__c = 0, Incentive_BCT_IP__c = 0, Incentive_BCT_Services__c = 0, Incentive_ExistingContract__c = 0, Incentive_SI_Products__c = 0, 	Incentive_ProfSvcs__c = 0, Yearly_IP_Incentive__c = 0, Yearly_Net_New_Business_Incentive__c = 0, Quota_Period__c = '2018-2019');
        Incentive_Master__c incmstQ4 = new Incentive_Master__c(SBU__c = 'USA',Incentive_Quarter__c=4, Incentive_Start_Period__c = date.newInstance(2019, 01, 01), Quarterly_Overall_Quota__c = 3000, Quarterly_IP_Quota__c = 1800, Quarterly_Overall_Actual__c = 0 , BCT_IP_L0L0X_QtrActualsRev__c = 0, BCTIP_L1_Qtr_Rev__c = 0, BCTIP_L2L3_QtrRev__c = 0, BCT_Svcs_L0L0X_Qtr_Rev__c = 0,	BCT_Svcs_L1_Qtr_Rev__c = 0, BCT_Svcs_L2_Qtr_Rev__c = 0, Ext_Contracts_L0L0X_Qtr_Rev__c = 0, Ext_Contracts_L1_Qtr_Rev__c = 0,  Ext_Contracts_L2L3_Qtr_Rev__c = 0, New_Logo_L0L0X_Qtr_Rev__c = 0, New_Logo_L1_Qtr_Rev__c = 0, New_Logo_L2L3_Qtr_Rev__c = 0, PSvc_L0L0X_Qtr_Rev__c = 0, PSvc_L1_Qtr_Rev__c = 0, PSvc_L2L3_Qtr_Rev__c = 0, SI_Products_L0L0X_Qtr_Rev__c = 0, SI_Products_L1_Qtr_Rev__c = 0, SI_Products_L2L3_Qtr_Rev__c = 0, Incentive_BCT_IP__c = 0, Incentive_BCT_Services__c = 0, Incentive_ExistingContract__c = 0, Incentive_SI_Products__c = 0, 	Incentive_ProfSvcs__c = 0, Yearly_IP_Incentive__c = 0, Yearly_Net_New_Business_Incentive__c = 0, Quota_Period__c = '2018-2019');
        			
        			insert incmstQ1;
                    insert incmstQ2;
                    insert incmstQ3;
                    insert incmstQ4;
      
		Account nAcc = new Account(Name='IncentiveTestAccount',SBU__c='USA',CurrencyIsoCode ='USD');
        System.debug('New Test Revenue Account :' + nAcc);
        insert nAcc;
        Account createdAcc = [SELECT id,name From Account WHERE Name='IncentiveTestAccount' LIMIT 1];
        System.debug('Test Revenue Account Created' + createdAcc);
        //Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Car',CurrencyIsoCode='USD',CloseDate=System.today(),StageName='Lead Identification',Amount=500000, SBU_OP__c = 'USA');
		Opportunity nOpp = new Opportunity( Accountid=createdAcc.id, Name='Tesla-Caar',CurrencyIsoCode='USD',CloseDate=System.today(), contract_po_number__c='12345', contract_po_sign_date__c=System.today(), project_start_date__c=System.today()+30, project_end_date__c=System.today()+365, Project_Manager__c='XYZ', sales_channel__c='', StageName='Proposal Submission', Amount=500000, Type='Existing Customer - New Business', Probability__c='100', Funnel_Code__c='L0' );
        	System.debug('New Test Revenue Opportunity :' + nOpp);
        	insert nOpp;
        	Opportunity createdOpp = [SELECT id From Opportunity WHERE Name='Tesla-Caar' LIMIT 1];
        	System.debug('Test Opportunity Revenue Created' + createdOpp);
        opportunity_line_item__c nOppLn = new Opportunity_Line_Item__c(Opportunity_ID__c=createdOpp.id, Total_Value__c=30000, Pillar__c='DIGITAL JOURNEY MGMT', Competency__c='CueTrans', product__c='CueTrans', Revenue_Stream__c ='AMC SUPPORT',  Project_Category__c='Onsite', Project_Type__c='Fixed Bid', Incentive_Qualifier__c='BCT IP',Project_ID__c='12345');
        			System.debug('New Test Revenue Opportunity Line :' + nOppLn);
            		insert nOppLn;
        			List<opportunity_line_item__c> myTestOL = [SELECT id,name From opportunity_line_item__c where Total_Value__c=30000 and Pillar__c='Huringa' and Practice__c='PULSE'];
        			System.debug('New Test Revenue Opportunity Line Created :' + myTestOL); 
       			 for(opportunity_line_item__c insertedOppLn : myTestOL){
            		Revenue_Term__c nRt1  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()-60, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt2  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()-30, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt3  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today(), Recognized_Amount__c= 0);
                    Revenue_Term__c nRt4  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+30, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt5  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+60, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt6  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+90, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt7  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+120, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt8  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+150, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt9  = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+180, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt10 = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+210, Recognized_Amount__c= 0);
                    Revenue_Term__c nRt11 = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+240, Recognized_Amount__c= 0);
        			Revenue_Term__c nRt12 = new Revenue_Term__c( Opportunity_Line_Item_id__c=insertedOppLn.id, Milestone__c='AMC Support',Percentage__c=5000,Revenue_Date__c=System.today()+270, Recognized_Amount__c= 0);
                     List<Revenue_Term__c> toInsertList = new List<Revenue_Term__c>();
        			
                    	toInsertList.add(nRt1);
                        toInsertList.add(nRt2);
                        toInsertList.add(nRt3);
                        toInsertList.add(nRt4);
                        toInsertList.add(nRt5);
                        toInsertList.add(nRt6);
                        toInsertList.add(nRt7);
                        toInsertList.add(nRt8);
                        toInsertList.add(nRt9);
                        toInsertList.add(nRt10);
                        toInsertList.add(nRt11);
                        toInsertList.add(nRt12);
                    
                    	insert toInsertList;
                     
                     	List<Revenue_Term__c> myTestRevTerm = [SELECT id, Revenue_Date__c, Percentage__c, Recognized_Amount__c From Revenue_Term__c where Opportunity_Line_Item_id__c =: insertedOppLn.id];
        				System.debug('New Test Revenue Term Created :' + myTestRevTerm); 
        		}
        					
        
        Test.startTest();
        IncentiveMonthlyProcessor qp = new IncentiveMonthlyProcessor();
        String jobId = System.schedule('IncentiProcessor', CRON_EXP, qp);
        system.debug('printing Scheduler job id :  ' +jobId);
        Test.stopTest();
    }
 }