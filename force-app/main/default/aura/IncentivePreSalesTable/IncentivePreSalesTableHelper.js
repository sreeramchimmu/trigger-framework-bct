({
	subTotalCalculation : function(lst,colSpan,userCount) {
        //console.log("::subTotalCalculation::");
        let q1 = 0;
        let q2 = 0;
        let q3 = 0;
        let q4 = 0;
        let qSum = 0;
        lst.forEach(function(v,i){
            q1 += Number(v.Q1__c);//console.log('q1-->'+q1);
            q2 += Number(v.Q2__c);//console.log('q2-->'+q2);
            q3 += Number(v.Q3__c);//console.log('q3-->'+q3);
            q4 += Number(v.Q4__c);//console.log('q4-->'+q4);
            qSum += Number(v.QuarterSum__c);//console.log('qSum-->'+qSum);
        });
        lst.forEach(function(v,i){
            if(i==0){
               lst[i].Is_CFI__c = 'subTotal';
               lst[i].Q1__c = q1;
               lst[i].Q2__c = q2;
               lst[i].Q3__c = q3;
               lst[i].Q4__c = q4;
               lst[i].QuarterSum__c = qSum;
            }
        });
        return this.assignValue(lst[0],colSpan,userCount);
	},
    
    assignValue : function(v,colSpan,userCount){
    	//console.log("::assignValue::");
    	let incVal;
    	 incVal = {
    		'Team_Member_Name__c'		:v.Team_Member_Name__c,
            'Team_Member_Involvement__c':v.Team_Member_Involvement__c,
    		'Incentive_Qualifier__c'	:v.Incentive_Qualifier__c,
    		'Team_Member_Role__c'		:v.Team_Member_Role__c,
    		'CurrencyIsoCode'			:v.CurrencyIsoCode,
    		'Is_CFI__c'					:v.Is_CFI__c,
    		'Q1__c'						:v.Q1__c,
    		'Q2__c'						:v.Q2__c,
    		'Q3__c'						:v.Q3__c,
    		'Q4__c'						:v.Q4__c,
    		'QuarterSum__c'				:v.QuarterSum__c,
            'colSpan'                   :colSpan,
            'userCount'					:userCount
		}
 		return incVal;
 	},
    
     isEmpty :function (obj) {
        for(var prop in obj) {
            if(obj.hasOwnProperty(prop))
                return false;
        }
        return true;
    }		
})