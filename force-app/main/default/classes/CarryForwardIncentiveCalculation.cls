public class CarryForwardIncentiveCalculation {
    
    public string BCTApprovedDigitalTIBCOServices ='BCT approved Digital & TIBCO Services';
    public String BCTDigitalTIBCOServices = 'BCT Digital & TIBCO Services';
    public set<ID> oppid = new set<ID>();
    public List<Revenue_Term__c> revList = new List<Revenue_Term__c>();
    public List<Incentive_Earnings__c> incEarngsList = new List<Incentive_Earnings__c>();
    public List<Incentive_Earnings__c> inctempList = new List<Incentive_Earnings__c>();
    public List<Sales_person_wise_achievement__mdt> achivementList = new List<Sales_person_wise_achievement__mdt>();
    public List<FY19_20_Incentive_scheme__mdt> incValueList = new List<FY19_20_Incentive_scheme__mdt>();
    public Map<id,Opportunity> oppMap = new Map<id,Opportunity>();
    public Map<String,double> achivementMap = new Map<String,double>();
    public Map<String,double> incValueMap = new Map<String,double>();
    
    public Double sumOfInvolvement=0;
    public String salesOwnerName;
    public String currencyCode;
    
    public string salesTeam = 'S';
    public string salesManager = 'SM';
    
       
    public void CarryForwardIncentiveCalculation_dataFetch(Id oppIds){
		  //List<opportunity> op = [select Opportunity_number_new__c from opportunity where id=:oppIds];
          //String oppNumber = op[0].Opportunity_number_new__c;
        //List<Actual_Forecast_Report_Snapshot__c> actFctList =[SELECT Id, Opportunity_Number__c FROM Actual_Forecast_Report_Snapshot__c where Opportunity_Number__c=:oppNumber];
        
        //if(actFctList.size()>0){
            
        system.debug(':::::::::::Apex class - CarryForwardIncentiveCalculation - Start::::::::::::::::'); 
        Date dt = Date.today();
        Date closedDataLimit = Date.newInstance(2020, 02, 29);
        Date revStartDate = Date.newInstance(2020, 04, 01);
        Date revEndDate = Date.newInstance(2021, 03, 31);
        
        //oppMap = new Map<id,Opportunity>([select id,Owner_Full_Name__c,Owner_id__c,CurrencyIsoCode from Opportunity where Opportunity_number_new__c=:oppNumber and CloseDate <=:closedDataLimit]);
        //oppMap = new Map<id,Opportunity>([select id,Owner_Full_Name__c,Owner_id__c,CurrencyIsoCode from Opportunity where Opportunity_number_new__c=:oppNumber]);
        oppMap = new Map<id,Opportunity>([select id,Owner_Full_Name__c,Owner_id__c,CurrencyIsoCode from Opportunity where id=:oppIds]);
        system.debug('Opplist-->'+oppMap.size());
        
        //oppLineList = [select id,Incentive_Qualifier__c,Opportunity_ID__c from Opportunity_Line_Item__c where Opportunity_ID__r.id=:oppMap.keySet()];
        //system.debug('oppLineList-->'+oppLineList.size());
        
        //oppLineitemMap=new Map<id,Opportunity_Line_Item__c>([select id, Incentive_Qualifier__c,Opportunity_ID__c  from Opportunity_Line_Item__c where Opportunity_ID__r.id=:oppMap.keySet()]);
        
        revList = [select id,name,Overall_Act_Forecast_Revenue__c,Opportunity_item_id__c,Opportunity_line_item_id__c,Total_Revenue_Raw_Fcst__c,Revenue_Date__c,Opportunity_line_item_id__r.Incentive_Qualifier__c,Opportunity_line_item_id__r.Opportunity_ID__r.id,Opportunity_line_item_id__r.Project_Category__c,Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId from Revenue_Term__c where Opportunity_line_item_id__r.Opportunity_ID__r.id in:oppMap.keySet() and revenue_Date__c>=:revStartDate and revenue_Date__c<=:revEndDate and Business_Category_Revenue__c='Existing Customer - Existing Business'];
        system.debug('revList-->'+revList.size());
           
        achivementList = [SELECT Achievementpercent__c,Label,Sales_person_name__c FROM Sales_person_wise_achievement__mdt];
        for(Sales_person_wise_achievement__mdt achList:achivementList){
            achivementMap.put(achList.Sales_person_name__c,achList.Achievementpercent__c);
        }
        system.debug('achivementMap size-->'+achivementMap.size());
        
        incValueList = [SELECT Label,Achievement_Level__c,Percentage__c,Product__c FROM FY19_20_Incentive_scheme__mdt];
        for(FY19_20_Incentive_scheme__mdt incL:incValueList){
            incValueMap.put(incL.Label, incL.Percentage__c);  
        }
        system.debug('incValueMap size-->'+incValueMap.size());
        
        if(revList.size()>0){
            //Setting Opportunities related Lineitems into oppLineMap
            for(Id oppSetValue:oppMap.keySet()){
                salesOwnerName=(String) oppMap.get(oppSetValue).get('Owner_Full_Name__c');
                currencyCode=(String) oppMap.get(oppSetValue).get('CurrencyIsoCode');
                oppid.add(oppSetValue);
            }
            //system.debug('oppid size()---->'+oppid.size()+' oppid-->'+oppid);
            
            deleteExistingRecords();
            
            //Sales Executive Incentive computation
            List<OpportunityTeamMember> oppSalesExecutiveTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Account Manager')];
            if(oppSalesExecutiveTeamList.size()>0){
                double involve;
                for(OpportunityTeamMember s: oppSalesExecutiveTeamList){
                    involve = s.Involvement__c!=null ? (double)s.Involvement__c : 0;
                    //splitRevenueByIncentiveQualifier(revMap, lineItemList, salesTeam, s.UserId, involve);
                    carryForwardRevenueComputation(salesTeam, s.UserId, involve);
                    sumOfInvolvement += involve;
                }
			}
            carryForwardRevenueComputation(salesTeam, revList[0].Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId, (100-sumOfInvolvement));
            
            //Sales Manager Incentive computation
            List<OpportunityTeamMember> oppSalesManagerTeamList = [SELECT Id,Involvement__c,OpportunityAccessLevel,OpportunityId,TeamMemberRole,Title,UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppId AND TeamMemberRole IN ('Sales Manager')];
            if(oppSalesManagerTeamList.size()>0){
                for(OpportunityTeamMember sm:oppSalesManagerTeamList){
                    carryForwardRevenueComputation(salesManager, sm.UserId, 100);
                }    
            }
            InsertingNewEarnings(inctempList); 
            }
       //}
        system.debug(':::::::::::Apex class - CarryForwardIncentiveCalculation - End::::::::::::::::');
    }
    
    public void carryForwardRevenueComputation(String teamName,String owner,double involvement){
        Incentive_Earnings__c tempInc;
        String Incentivequalifier;
        for(Revenue_Term__c rev:revList){
            tempInc = new Incentive_Earnings__c(Opportunity_Line_Item__c=rev.Opportunity_line_item_id__c);
            tempInc.Opportunity_Id__c = rev.Opportunity_line_item_id__r.Opportunity_ID__r.id;
            tempInc.Incentive_Qualifier__c=rev.Opportunity_line_item_id__r.Incentive_Qualifier__c;
            tempInc.Project_Delivery_Model__c = rev.Opportunity_line_item_id__r.Project_Category__c;
            Incentivequalifier=rev.Opportunity_line_item_id__r.Incentive_Qualifier__c;
            if(Incentivequalifier.equalsIgnoreCase(BCTApprovedDigitalTIBCOServices)){
                Incentivequalifier=BCTDigitalTIBCOServices;
            }
            tempInc.Revenue_Id__c = String.valueof(rev.id);
            tempInc.Revenue_Date__c=rev.Revenue_Date__c;
            tempInc.Is_CFI__c='Y';
            tempInc.CurrencyIsoCode=currencyCode;
            tempInc.Incentive_Owner__c = owner;
            tempInc.Team_Member_Involvement__c = involvement/revList.size();
            System.debug('::::::::::::::Inc calculation::::::::::');
            system.debug('Total_Revenue_Raw_Fcst__c-->'+rev.Total_Revenue_Raw_Fcst__c);
            if(teamName.equalsIgnoreCase(salesTeam)){
                if(owner == revList[0].Opportunity_line_item_id__r.Opportunity_ID__r.OwnerId){ 
                   tempInc.Act_Fct_Revenue_amount__c	= rev.Total_Revenue_Raw_Fcst__c; 
                }
                tempInc.SE_Incentives__c = involvementCalculation(fetchFY19_20IncByQualifier(Incentivequalifier, salesTeam, (double)rev.Total_Revenue_Raw_Fcst__c),involvement);
            }
            if(teamName.equalsIgnoreCase(salesManager)){
                tempInc.SM_Incentives__c = involvementCalculation(fetchFY19_20IncByQualifier(Incentivequalifier, salesManager, (double)rev.Total_Revenue_Raw_Fcst__c),involvement);
            }
            tempInc.Salesperson_Prev_FY_Achievement__c=fetchAchivementPecentage();
            inctempList.add(tempInc);
        }
    }
    
    //This method will fetch incentive percentage for FY19-20 from the custom metadata [FY19_20_Incentive_scheme__mdt]
    public double fetchFY19_20IncByQualifier(String qualifierName,String team,double revenue){
        double incVal=0;
        system.debug('qualifierName-->'+qualifierName);
        if(achivementPecentageLimit(fetchAchivementPecentage())!=null && achivementPecentageLimit(fetchAchivementPecentage())!=''){
            string level = qualifierName+'-'+team+'-'+achivementPecentageLimit(fetchAchivementPecentage());
        	incVal = Double.valueOf(incValueMap.get(level));
        }
        return revenue*(incVal/100); 
    }
    
    //This method is used to fetch percentage limit text
    public string achivementPecentageLimit(double achivement){
        String ach='';
        if(achivement>=31 && achivement<=50){
            ach='31to50';
        }else if(achivement>=51 && achivement<=75){
            ach='51to75';
        }else if(achivement>=76 && achivement<=90){
            ach='76to90';
        }else if(achivement>=91 && achivement<=100){
            ach='91to100';
        }else if(achivement>=101 && achivement<=110){
            ach='101to110';
        }else if(achivement>110){
            ach='grt110';
        }
        return ach;
    }
    
    //This Method will fetch achivementPercentage of a salesperson from the custom metadata [Sales_person_wise_achievement__mdt]
    //Achivement will calculate if its more than 50% or else 0%
    public double fetchAchivementPecentage(){
        return achivementMap.get(salesOwnerName)>=50 ? achivementMap.get(salesOwnerName) : 0;
    }
    
    public double involvementCalculation(double val,double inv){
		return val * (inv/100);
    }
    
    //Inserting new incentive earnings records
    public void InsertingNewEarnings(List<Incentive_Earnings__c> inctempList){
        if(inctempList.size()>0){
            try{ 
                insert inctempList;
                system.debug('Carry forward Incentives are inserted sucessfully..!');
            }catch(DMLexception e){         
                system.debug(e);
            }
        } 
    }
    
    //Delete existing records in Incentive Earnings object
    public void deleteExistingRecords(){
        incEarngsList = [select id, Opportunity_Line_Item__c from Incentive_Earnings__c where Opportunity_Id__c in:oppid];
        system.debug('delete incEarngsList size()---->'+incEarngsList.size());
            if(incEarngsList.size()>0){
                try{ 
                    delete incEarngsList;
                    system.debug('Carry forward Incentives are deleted sucessfully..!');
                }catch(DMLexception e){         
                    system.debug(e);
                }
            }
    }

}