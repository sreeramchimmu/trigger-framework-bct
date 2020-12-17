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
                //console.log("Pre Sales -  Apex");
                //console.log(obj);
                //component.set("v.incentives",conts);
                
                if(!helper.isEmpty(obj)){
                    if(obj.PreSales.length>1){
                        let userName=[];
                        let incentive=[];
                        obj.PreSales.forEach(function(v,i){
                            if(i!=(obj.PreSales.length-1)){
                                userName.push(v.Team_Member_Name__c);
                                incentive.push(v.Incentive_Qualifier__c);
                            }
                        });
                        let userNameSet = Array.from(new Set(userName));
                        let incentiveSet = Array.from(new Set(incentive));
                        let preSalesList = [];
                        userNameSet.forEach(function(val,ind){
                            //console.log('Name-->'+val);
                            let preSalesListTemp = [];
                            let colSpan = incentiveSet.length;
                            let userCount = userNameSet.length;
                            //console.log('userCount-->'+userCount);
                            //console.log('colSpan-->'+colSpan);
                            obj.PreSales.forEach(function(v,i){
                                if(val==v.Team_Member_Name__c){
                                    preSalesListTemp.push(helper.assignValue(v,colSpan,userCount));
                                    preSalesList.push(helper.assignValue(v,colSpan,userCount));
                                    colSpan='';
                                }
                            });
                            preSalesList.push(helper.subTotalCalculation(preSalesListTemp,incentiveSet.length,userCount));
                        });
                        preSalesList.push(obj.PreSales[obj.PreSales.length-1]);
                        console.log('::::::::::preSalesList::::::::::::::::');
                        let CFIarray = [];
                        CFIarray.push({"Is_CFI__c":obj.IsCFI[0].Is_CFI__c});
                        let role ={"PreSales":preSalesList,"IsCFI":CFIarray};                   
                        console.log(role);
                        component.set("v.incentives",role);
                    }else{
                        //console.log('::::::::::Single preSalesList::::::::::::::::');
                        //console.log(obj);
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