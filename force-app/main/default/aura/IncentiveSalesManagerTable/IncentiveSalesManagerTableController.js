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
                //console.log("SalesManager Executive - Apex");
                //console.log(obj);
                //component.set("v.incentives",conts);
                
                if(!helper.isEmpty(obj)){
                    if(obj.SalesManager.length>1){
                        let userName=[];
                        let incentive=[];
                        obj.SalesManager.forEach(function(v,i){
                            if(i!=(obj.SalesManager.length-1)){
                                userName.push(v.Team_Member_Name__c);
                                incentive.push(v.Incentive_Qualifier__c);
                            }
                        });
                        let userNameSet = Array.from(new Set(userName));
                        let incentiveSet = Array.from(new Set(incentive));
                        let SalesManagerList = [];
                        userNameSet.forEach(function(val,ind){
                            //console.log('Name-->'+val);
                            let SalesManagerListTemp = [];
                            let colSpan = incentiveSet.length;
                            let userCount = userNameSet.length;
                            //console.log('colSpan-->'+colSpan);
                            obj.SalesManager.forEach(function(v,i){
                                if(val==v.Team_Member_Name__c){
                                    SalesManagerListTemp.push(helper.assignValue(v,colSpan,userCount));
                                    SalesManagerList.push(helper.assignValue(v,colSpan,userCount));
                                    colSpan='';
                                }
                            });
                            SalesManagerList.push(helper.subTotalCalculation(SalesManagerListTemp,incentiveSet.length,userCount));
                        });
                        SalesManagerList.push(obj.SalesManager[obj.SalesManager.length-1]);
                        //console.log('SalesManagerList');
                        let role ={"SalesManager":SalesManagerList};                   
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