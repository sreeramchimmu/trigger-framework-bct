({
    doinit : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getIncentiveEarnings");
        action.setParams({
            oppId : oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                var obj = response.getReturnValue();
                //console.log("Sales Executive - Apex");
                //console.log(obj);
                //component.set("v.incentives",conts);
                
                if(!helper.isEmpty(obj)){
                    if(obj.Sales.length>1){
                        let userName=[];
                        let incentive=[];
                        obj.Sales.forEach(function(v,i){
                            if(i!=(obj.Sales.length-1)){
                                userName.push(v.Team_Member_Name__c);
                                incentive.push(v.Incentive_Qualifier__c);
                            }
                        });
                        let userNameSet = Array.from(new Set(userName));
                        let incentiveSet = Array.from(new Set(incentive));
                        let SalesList = [];
                        userNameSet.forEach(function(val,ind){
                            //console.log('Name-->'+val);
                            let SalesListTemp = [];
                            let colSpan = incentiveSet.length;
                            let userCount = userNameSet.length;
                            //console.log('colSpan-->'+colSpan);
                            obj.Sales.forEach(function(v,i){
                                if(val==v.Team_Member_Name__c){
                                    SalesListTemp.push(helper.assignValue(v,colSpan,userCount));
                                    SalesList.push(helper.assignValue(v,colSpan,userCount));
                                    colSpan='';
                                }
                            });
                            SalesList.push(helper.subTotalCalculation(SalesListTemp,incentiveSet.length,userCount));
                        });
                        SalesList.push(obj.Sales[obj.Sales.length-1]);
                        //console.log(':::::::::SalesList::::::::');
                        let role ={"Sales":SalesList};                   
                        //console.log(role);
                        component.set("v.incentives",role);
                    }else{
                        component.set("v.incentives",obj);
                    }
                }else{
                    component.set("v.incentives",obj);
                }
            } 
        });           
        $A.enqueueAction(action);
    }
})