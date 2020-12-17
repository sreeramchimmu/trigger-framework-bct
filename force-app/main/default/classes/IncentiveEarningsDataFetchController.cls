public class IncentiveEarningsDataFetchController { 
 
    public static List<Incentive_Earnings__c> IncList = new List<Incentive_Earnings__c>();
    public static Map<String,List<Incentive_Earnings__c>> QualifierMap = new Map<String,List<Incentive_Earnings__c>>();
    public static Map<String,List<Incentive_Earnings__c>>  IncentiveMap= new Map<String,List<Incentive_Earnings__c>>();
    public static Set<string> IncSet   = new Set<string>();
    public static List<Incentive_Earnings__c> SalesList = new List<Incentive_Earnings__c>();
    public static List<Incentive_Earnings__c> SalesManagerList = new List<Incentive_Earnings__c>();
    public static List<Incentive_Earnings__c> PreSalesList = new List<Incentive_Earnings__c>();
    public static List<Incentive_Earnings__c> RevenueSplitList = new List<Incentive_Earnings__c>();
    public static List<Incentive_Earnings__c> IsCFIList = new List<Incentive_Earnings__c>();
    
    public static Double[] SalesTotal = new Double[]{0,0,0,0,0,0};
    public static Double[] SalesManagerTotal = new Double[]{0,0,0,0,0,0};
    public static Double[] PreSalesTotal = new Double[]{0,0,0,0,0,0};
	public static Double[] RevenueSplitTotal = new Double[]{0,0,0,0,0,0};
     
    public static Double[] SalesQuarterData;
    public static Double[] SalesManagerQuarterData;
    public static Double[] PreSalesQuarterData;
    public static Double[] RevenueSplitQuarterData;
    public static Double[] PreSalesSubTotalData;

    
    @AuraEnabled
    public static Map<String,List<Incentive_Earnings__c>> getIncentiveEarnings(Id oppId){
        
        IncList = [SELECT id,Act_Fct_Revenue_amount__c,CurrencyIsoCode,Incentive_Qualifier__c,Is_CFI__c,Opportunity_Id__c,Opportunity_Line_Item__c,PreSales_Incentives__c,Revenue_Date__c,Revenue_Id__c,SE_Incentives__c,SM_Incentives__c,Total_Incentives__c,Project_Delivery_Model__c,Team_Member_Involvement__c,Team_Member_Name__c,Team_Member_Role__c,Opportunity_Line_Item__r.Opportunity_ID__r.Owner_Full_Name__c
                   FROM Incentive_Earnings__c WHERE Opportunity_Id__c = :oppId];
        //system.debug('IncSet-->'+IncSet.size());
        if(IncList.size()>0){
            for(Incentive_Earnings__c s:IncList){
                IncSet.add(s.Incentive_Qualifier__c);
            }
            //Aggrigate the revenues based on Incentive Qualifiers name
            for(String incName:IncSet){
                List<Incentive_Earnings__c> QualifierList = new List<Incentive_Earnings__c>();
                for(Incentive_Earnings__c incE:IncList){
                    if(incName.equalsIgnoreCase(incE.Incentive_Qualifier__c)){
                        QualifierList.add(incE);            
                    }
                }
                QualifierMap.put(incName, QualifierList);
            }
            //system.debug('QualifierMap-->'+QualifierMap);
            
            splitRevenueByIncentiveQualifier(QualifierMap,oppId);
            IncentiveMap.put('IsCFI',new List<Incentive_Earnings__c>{new Incentive_Earnings__c(Is_CFI__c=(String)IncList[0].Is_CFI__c)});
            IncentiveMap.put('Sales', SalesList);
            IncentiveMap.put('SalesManager', SalesManagerList);
            //IncentiveMap.put('PreSales', getUserWiseCalculation(PreSalesList));
            IncentiveMap.put('PreSales', PreSalesList);
            IncentiveMap.put('RevenueSplit', RevenueSplitList);
            
        }
        return IncentiveMap;
    }
    
    public static void splitRevenueByIncentiveQualifier(Map<String,List<Incentive_Earnings__c>> QualifierMap,Id oppId){
        double Involvement = 0;
        List<OpportunityTeamMember> oppPreSalesTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,User.name FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Pre-Sales - Onsite','Pre-Sales - Offshore')];
        List<OpportunityTeamMember> oppSalesManagerTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,User.name FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Sales Manager')];
        List<OpportunityTeamMember> oppSalesExecutiveTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,User.name FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Account Manager')];
        for(String Q : QualifierMap.keySet()){
            system.debug('Qualifier Name-->'+Q);
            /*//As per the business request ,Project delivery model split is only applicable for PreSales List
            Map<String,List<Incentive_Earnings__c>> IncMapByPDM = splitRevenueByProjectDeliveryModel(QualifierMap.get(Q));
            for(String P:IncMapByPDM.keySet()){
                splitIncentiveByQuarterWise(IncMapByPDM.get(P));
                AssingQuarterDataToList(Q,P,PreSalesQuarterData,PreSalesList,PreSalesTotal);
            }*/
            
            
            splitIncentiveByQuarterWise(QualifierMap.get(Q));
            
            //Pre-Sales assignment
            if(oppPreSalesTeamList.size()>0){
                for(OpportunityTeamMember oppPS:oppPreSalesTeamList){
                     Involvement = oppPS.Involvement__c!=null ? (Double)oppPS.Involvement__c : 0 ;
                     AssingQuarterDataToList(Q, oppPS.TeamMemberRole, oppPS.user.name, Involvement, PreSalesQuarterData,PreSalesList,PreSalesTotal);
                }
            }
            //Sales Manager assignment
            if(oppSalesManagerTeamList.size()>0){
                for(OpportunityTeamMember oppSM:oppSalesManagerTeamList){
                    AssingQuarterDataToList(Q,oppSM.TeamMemberRole,oppSM.user.name,100,SalesManagerQuarterData,SalesManagerList,SalesManagerTotal);
                }
            }
            //Sales Executive assignment
            double SEsumOfInvolvement=0;
            if(oppSalesExecutiveTeamList.size()>0){
                //incentive for Opportunity team account manager
                for(OpportunityTeamMember oppSM:oppSalesExecutiveTeamList){
                    Involvement = oppSM.Involvement__c!=null ? (Double)oppSM.Involvement__c : 0 ;
                    AssingQuarterDataToList(Q,oppSM.TeamMemberRole,oppSM.user.name,Involvement,SalesQuarterData,SalesList,SalesTotal);
                    SEsumOfInvolvement += Involvement;
                }
            }
            //Sales Execuive incentive for Opportunity owner
			AssingQuarterDataToList(Q,'',IncList[0].Opportunity_Line_Item__r.Opportunity_ID__r.Owner_Full_Name__c,(100-SEsumOfInvolvement),SalesQuarterData,SalesList,SalesTotal);
            
            //Sales, SalesManger & Revenue splits are based on the Incentive qualifier split
            //splitIncentiveByQuarterWise(QualifierMap.get(Q));
            //AssingQuarterDataToList(Q,'','',100,SalesQuarterData,SalesList,SalesTotal);
             AssingQuarterDataToList(Q,'','',100,RevenueSplitQuarterData,RevenueSplitList,RevenueSplitTotal);
        }
        ColumnWiseSummation(SalesList,SalesTotal);
        ColumnWiseSummation(SalesManagerList,SalesManagerTotal);
        ColumnWiseSummation(PreSalesList,PreSalesTotal);
        ColumnWiseSummation(RevenueSplitList,RevenueSplitTotal);
    }
    
    
    /*public static Map<String,List<Incentive_Earnings__c>> splitRevenueByProjectDeliveryModel(List<Incentive_Earnings__c> incPDM){
        Map<String,List<Incentive_Earnings__c>> incPDMMap = new Map<String,List<Incentive_Earnings__c>>();
        Set<String> PDM = new Set<String>();
        for(Incentive_Earnings__c incGet:incPDM){
            PDM.add(incGet.Project_Delivery_Model__c);
        }
        for(String pdmValue:PDM){
            List<Incentive_Earnings__c> incPDMList = new List<Incentive_Earnings__c>();
            for(Incentive_Earnings__c incP : incPDM){
                if(pdmValue.equalsIgnoreCase(incP.Project_Delivery_Model__c)){
                    incPDMList.add(incP);
                }
            }
            incPDMMap.put(pdmValue,incPDMList);
        }
        return incPDMMap;
    }*/
    
    public static void splitIncentiveByQuarterWise(List<Incentive_Earnings__c> IncLists){
        SalesQuarterData 		= new Double[]{0,0,0,0,0};
    	SalesManagerQuarterData = new Double[]{0,0,0,0,0};
    	PreSalesQuarterData 	= new Double[]{0,0,0,0,0};
    	RevenueSplitQuarterData = new Double[]{0,0,0,0,0};
            
        for(Incentive_Earnings__c i : IncLists){
            if(i.Revenue_Date__c.month() >=4 && i.Revenue_Date__c.month()<=6){
                //system.debug('Qarter - 1');
                SalesQuarterData[1] 		+= i.SE_Incentives__c;
                SalesManagerQuarterData[1] 	+= i.SM_Incentives__c;
                PreSalesQuarterData[1] 		+= i.PreSales_Incentives__c;
                RevenueSplitQuarterData[1] 	+= i.Act_Fct_Revenue_amount__c;
            }
            else if(i.Revenue_Date__c.month() >=7 && i.Revenue_Date__c.month()<=9){
                //system.debug('Qarter - 2');
                SalesQuarterData[2] 		+= i.SE_Incentives__c;
                SalesManagerQuarterData[2] 	+= i.SM_Incentives__c;
                PreSalesQuarterData[2] 		+= i.PreSales_Incentives__c;
                RevenueSplitQuarterData[2] 	+= i.Act_Fct_Revenue_amount__c;
            } 
            else if(i.Revenue_Date__c.month() >=10 && i.Revenue_Date__c.month()<=12){
                //system.debug('Qarter - 3');
                SalesQuarterData[3] 		+= i.SE_Incentives__c;
                SalesManagerQuarterData[3] 	+= i.SM_Incentives__c;
                PreSalesQuarterData[3] 		+= i.PreSales_Incentives__c;
                RevenueSplitQuarterData[3] 	+= i.Act_Fct_Revenue_amount__c;
            }
            else if(i.Revenue_Date__c.month() >=1 && i.Revenue_Date__c.month()<=3){
                //system.debug('Qarter - 4');
                SalesQuarterData[4] 		+= i.SE_Incentives__c;
                SalesManagerQuarterData[4] 	+= i.SM_Incentives__c;
                PreSalesQuarterData[4] 		+= i.PreSales_Incentives__c;
                RevenueSplitQuarterData[4] 	+= i.Act_Fct_Revenue_amount__c;
            }
        } 
    }
    
    public static void AssingQuarterDataToList(String QualifierName,String teamRole,String userName,Double split,Double[] QuarterWiseData,List<Incentive_Earnings__c> teamList, Double[] TotalList){
        Incentive_Earnings__c S = new Incentive_Earnings__c();
        S.Incentive_Qualifier__c=QualifierName;
        //S.Project_Delivery_Model__c=pdmName;
        S.Team_Member_Role__c=teamRole;
        S.Team_Member_Name__c=userName;
        S.Team_Member_Involvement__c=split;
        S.Q1__c=percentageCal(QuarterWiseData[1],split);
        S.Q2__c=percentageCal(QuarterWiseData[2],split);
        S.Q3__c=percentageCal(QuarterWiseData[3],split);
        S.Q4__c=percentageCal(QuarterWiseData[4],split);
        S.QuarterSum__c=percentageCal((QuarterWiseData[1]+QuarterWiseData[2]+QuarterWiseData[3]+QuarterWiseData[4]),split);
        S.CurrencyIsoCode=IncList[0].CurrencyIsoCode;
        S.Is_CFI__c=IncList[0].Is_CFI__c;
        //Column wise Total Calculation
        TotalList[1] += percentageCal(QuarterWiseData[1],split);
        TotalList[2] += percentageCal(QuarterWiseData[2],split); 
        TotalList[3] += percentageCal(QuarterWiseData[3],split);
        TotalList[4] += percentageCal(QuarterWiseData[4],split);
        TotalList[5] += percentageCal((QuarterWiseData[1]+QuarterWiseData[2]+QuarterWiseData[3]+QuarterWiseData[4]),split);
        teamList.add(S);
    }
    
    public static void ColumnWiseSummation(List<Incentive_Earnings__c> teamList,Double[] totalList){
		Incentive_Earnings__c S = new Incentive_Earnings__c();
        S.Team_Member_Name__c='Total ('+IncList[0].CurrencyIsoCode+')';
        S.Q1__c=totalList[1];
        S.Q2__c=totalList[2];
        S.Q3__c=totalList[3];
        S.Q4__c=totalList[4];
        S.QuarterSum__c=(totalList[1]+totalList[2]+totalList[3]+totalList[4]);
        teamList.add(S);
        //Column wise Total Calculation     
    }
    
    public static double percentageCal(Double actualValue,Double percentageValue){
        return actualValue * (percentageValue/100);
    }

}