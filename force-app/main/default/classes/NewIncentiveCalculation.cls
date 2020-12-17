/* Class Name   : IncentiveQualifiersByRevenueSplit
 * Created Date : 16-June-2020 
 * Created by   : Gowtham Kumar 
 * Description  : This class is used to calculate incentives of opportunity by revenue wise
 */
public class NewIncentiveCalculation {
    
    public  string bctIp='BCT IP';
    public  string siProducts='SI Products';
    public  string professionalServices='Professional Services';
    public  string TIBCOProductLicense='TIBCO Product License';
    public  string BCTApprovedDigitalTIBCOServices ='BCT approved Digital & TIBCO Services';
    public  string BCTEnterpriseServices='BCT Enterprise Services';
    
    public String BCTDigitalTIBCOServices = 'BCT Digital & TIBCO Services';
    public string salesTeam = 'Sales';
    public string salesManager = 'SM';
    public string preSales = 'PS';
    
    public  Map<Id,List<Revenue_Term__c>> revMap = new Map<Id,List<Revenue_Term__c>>();
    public  List<Opportunity> oppList = new List<Opportunity>();
    public  List<Opportunity_Line_Item__c> lineItemList = new List<Opportunity_Line_Item__c>();
    public  List<Revenue_Term__c> revList = new List<Revenue_Term__c>();
    public  List<Incentive_Earnings__c> incList = new List<Incentive_Earnings__c>();
    public  List<Incentive_Earnings__c> incExsistingList = new List<Incentive_Earnings__c>();
    public  List<Incentive_Qualifier_Percentage__mdt> incentivePercentage = new List<Incentive_Qualifier_Percentage__mdt>();
    public  Map<String,Incentive_Qualifier_Percentage__mdt> incMap= new Map<String,Incentive_Qualifier_Percentage__mdt>();
    public  Map<Id,Id> incExsistingMap = new Map<Id,Id>();
    public Double sumOfInvolvement=0;
    
    public NewIncentiveCalculation(id oppId){ //006e000000LkV65AAF
         
        system.debug(':::::::::::::::::::::Apex class - NewIncentiveCalculation - Start:::::::::::::::::::');
        system.debug('oppId -->'+oppId);
        oppList = [select id,name,Type,CurrencyIsoCode,Owner_Full_Name__c,OwnerId from opportunity where id =:oppId];
        lineItemList = [select id,Incentive_Qualifier__c,Revenue_Count__c,Total_Value__c from Opportunity_Line_Item__c WHERE Opportunity_ID__c = :oppId];
        revList = [select Id,Actual_Forecast_Rev__c,Current_FY_Act_Fst_Raw_Rev__c,Total_Revenue_Raw_Fcst__c,Opportunity_item_id__c,Opportunity_line_item_id__c,Percentage__c,Business_Category_Revenue__c,Revenue_Date__c,Overall_Act_Forecast_Revenue__c,Opportunity_line_item_id__r.Opportunity_ID__r.id,Opportunity_line_item_id__r.id,Opportunity_line_item_id__r.Incentive_Qualifier__c,Opportunity_line_item_id__r.Project_Category__c
                   from revenue_term__c where Opportunity_line_item_id__r.Opportunity_ID__r.id = :oppId AND Business_Category_Revenue__c LIKE '%New business%' and Revenue_Date__c >=2020-04-01]; 
        incentivePercentage = [SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Incentive_Product__c, Team__c, Quarter__c, Percentage__c FROM Incentive_Qualifier_Percentage__mdt];
        //assing value to incMap of incentive qualifier lable with List of incentive qualifiers
        //Note: get parameter value in incMap is Lable of Incentive_Qualifier_Percentage__mdt & we have to pass the same lable as parameter
        for(Incentive_Qualifier_Percentage__mdt incP:incentivePercentage){
	   		incMap.put(incP.Label,incP);
		}
        
        deletingExsistingRevenues(oppId);
        
        if(revList.size()>0){ 
            
            //assing value to revMap of LineItem id with List of revenues
        	for(Opportunity_Line_Item__c line: lineItemList){
            	List<Revenue_Term__c> newRevList = new List<Revenue_Term__c>();
            	for(Revenue_Term__c r: revList){
                	if(r.Opportunity_line_item_id__c==line.id){
                    	newRevList.add(r);
                	}
            	}
            	revMap.put(line.id,newRevList);
        	}
            
            //Sales Executive Incentive computation
            List<OpportunityTeamMember> oppSalesExecutiveTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Account Manager')];
            if(oppSalesExecutiveTeamList.size()>0){
                double involve;
                for(OpportunityTeamMember s: oppSalesExecutiveTeamList){
                    involve = s.Involvement__c!=null ? (double)s.Involvement__c : 0;
                    splitRevenueByIncentiveQualifier(revMap, lineItemList, salesTeam, s.UserId, involve);
                    sumOfInvolvement += involve;
                }
			}
            splitRevenueByIncentiveQualifier(revMap, lineItemList, salesTeam, oppList[0].OwnerId, (100-sumOfInvolvement));
            
            //Sales Manager Incentive computation
            List<OpportunityTeamMember> oppSalesManagerTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Sales Manager')];
            if(oppSalesManagerTeamList.size()>0){
                for(OpportunityTeamMember sm:oppSalesManagerTeamList){
                    splitRevenueByIncentiveQualifier(revMap, lineItemList, salesManager, sm.UserId, 100);
                }    
            }
            
            //Pre Sales Incentive computation
            List<OpportunityTeamMember> oppPreSalesTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Pre-Sales - Onsite','Pre-Sales - Offshore')];
            if(oppPreSalesTeamList.size()>0){
                for(OpportunityTeamMember ps:oppPreSalesTeamList){
                    splitRevenueByIncentiveQualifier(revMap, lineItemList, preSales, ps.UserId, (double)ps.Involvement__c);
                }   
            }
            
            InsertingRevenues(oppId);
       }
      
       system.debug(':::::::::::::::::::::Apex class - NewIncentiveCalculation - End:::::::::::::::::::');
    }
    
    public  void splitRevenueByIncentiveQualifier(Map<Id,List<Revenue_Term__c>> revMapParm,List<Opportunity_Line_Item__c> lineItemListParm,String teamName, id owner, double Involvement){
        for(Opportunity_Line_Item__c l:lineItemListParm){
            if(l.Incentive_Qualifier__c==bctIp){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), bctIp, teamName, owner, Involvement);
            }
            if(l.Incentive_Qualifier__c==siProducts){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), siProducts, teamName, owner, Involvement);
            }
            if(l.Incentive_Qualifier__c==professionalServices){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), professionalServices, teamName, owner, Involvement);
            }
            if(l.Incentive_Qualifier__c==TIBCOProductLicense){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), TIBCOProductLicense, teamName, owner, Involvement);
            }
            if(l.Incentive_Qualifier__c==BCTApprovedDigitalTIBCOServices){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), BCTDigitalTIBCOServices, teamName, owner, Involvement);
            }
            if(l.Incentive_Qualifier__c==BCTEnterpriseServices){
                system.debug(l.Incentive_Qualifier__c);
                IncentiveCalucationRevenueWise(revMapParm.get(l.id), BCTEnterpriseServices, teamName, owner, Involvement);
            }
        }
    }
    
    public void IncentiveCalucationRevenueWise(List<Revenue_Term__c> revParm, String product, String teamName, id owner, double Involvement){
         if(revParm.size()>0){
             system.debug('revList size-->'+revParm.size());
             for(Revenue_Term__c r : revParm){
                 Incentive_Earnings__c i = new Incentive_Earnings__c();
                 i.Opportunity_Id__c 			= r.Opportunity_line_item_id__r.Opportunity_ID__r.id;
                 i.Opportunity_Line_Item__c		= r.Opportunity_line_item_id__r.id;
                 i.Revenue_Id__c				= r.id;                 
                 i.Incentive_Qualifier__c		= r.Opportunity_line_item_id__r.Incentive_Qualifier__c;
                 i.Project_Delivery_Model__c    = r.Opportunity_line_item_id__r.Project_Category__c;
                 i.Revenue_Date__c				= r.Revenue_Date__c;
                 i.Is_CFI__c					= 'N';
                 i.CurrencyIsoCode				= oppList[0].CurrencyIsoCode;
                 i.Incentive_Owner__c			= owner;
				 i.Team_Member_Involvement__c   = Involvement/revList.size();
                 if(teamName.equalsIgnoreCase(salesTeam)){
                     if(owner == oppList[0].ownerId){
                        i.Act_Fct_Revenue_amount__c	= r.Total_Revenue_Raw_Fcst__c; 
                     }
                 	 i.SE_Incentives__c		 		= involvementCalculation(getTeamWiseIncentives(r,product,salesTeam),Involvement);
                 }
                 if(teamName.equalsIgnoreCase(salesManager)){
                     i.SM_Incentives__c 			= involvementCalculation(getTeamWiseIncentives(r,product,salesManager),Involvement);
                 }
                 if(teamName.equalsIgnoreCase(preSales)){
                     i.PreSales_Incentives__c 		= involvementCalculation(getTeamWiseIncentives(r,product,preSales),Involvement);
                 }
                 incList.add(i);
             }
         }
    }
    
    public double getTeamWiseIncentives(Revenue_Term__c revData,String productName,String team){
        return revData.Total_Revenue_Raw_Fcst__c * (getIncentivePercentage(productName, team, getIncentiveQuarter(revData.Revenue_Date__c)));
    }
    
    public double getIncentivePercentage(String product,String team,String quarter){
        return Double.valueOf(incMap.get(product+'-'+team+'-'+quarter).get('percentage__c'))/100;
    }
    
    public double involvementCalculation(double val,double inv){
		return val * (inv/100);
    }
    
    public string getIncentiveQuarter(Date RevenueDate){
        if(RevenueDate.month() >=4 && RevenueDate.month()<=6){
			return 'Q1';
        }
        else if(RevenueDate.month() >=7 && RevenueDate.month()<=9){
			return 'Q2';
        }
        else if(RevenueDate.month() >=10 && RevenueDate.month()<=12){
			return 'Q3';
        }
        else {//if(RevenueDate.month() >=1 && RevenueDate.month()<=3)
			return 'Q4';
        }
	}
    
    public void InsertingRevenues(id oppId){
        try{
            insert incList;
            system.debug('Incentive qualifiers are inserted sucessfully..!');
        }catch(DMLexception e){         
            system.debug(e);
        }
    }
    
    public void deletingExsistingRevenues(id oppId){
        //fetching exsisting revenue datas based on opportunity Id from Incentive_Earnings__c & deleting it
        incExsistingList = [select id,Revenue_Id__c from Incentive_Earnings__c where Opportunity_Id__c =:oppId];
        if(incExsistingList.size()>0){
            List<Incentive_Earnings__c> deleteList = new List<Incentive_Earnings__c>();
            deleteList.addAll(incExsistingList);
            try{
                delete deleteList;		
                system.debug('Incentive qualifiers are deleted sucessfully..!');
            }catch(DMLexception e){         
                system.debug(e);
            }
        }
    }

}