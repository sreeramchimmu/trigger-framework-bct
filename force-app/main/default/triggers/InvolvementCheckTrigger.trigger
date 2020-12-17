trigger InvolvementCheckTrigger on OpportunityTeamMember (after insert,after update,after delete) {
    if(Trigger.IsAfter && (Trigger.IsUpdate || Trigger.IsInsert)){
        System.debug('::::::::::::::InvolvementCheckTrigger - Trigger class - Start:::::::::::::');
        //system.debug('Opp Id-->'+Trigger.New[0].OpportunityId);
        //system.debug('Opp Id-->'+Trigger.New.size());
        OpportunityTeamMember oppTeam = Trigger.New[0];
        double involvementTotal = 0;
        String teamMember = oppTeam.TeamMemberRole;
        //Presales - grouped by Pre-Sales - Onsite & Pre-Sales - Offshore
        if(teamMember.equalsIgnoreCase('Pre-Sales - Onsite')||teamMember.equalsIgnoreCase('Pre-Sales - Offshore')){
            teamMember='Pre-Sales';
		}
        List<OpportunityTeamMember> oppTeamList = [SELECT Involvement__c,TeamMemberRole FROM OpportunityTeamMember WHERE OpportunityId = :oppTeam.OpportunityId and TeamMemberRole LIKE :('%'+teamMember+'%')];
        if(oppTeamList.size()>0){
            for(OpportunityTeamMember opp: oppTeamList){
                involvementTotal += opp.Involvement__c==null ? 0 : opp.Involvement__c;
            }
        }
        system.debug('involvementTotal-->'+involvementTotal);
        if(involvementTotal>100){
              double yetToAdd = 100-(involvementTotal - oppTeam.Involvement__c);
              oppTeam.AddError ('Sum of all Involvement for '+teamMember+' is exceeding 100%. Please provide involvement percentage less than or equal to '+yetToAdd);
        }else{
            //Incentive calculation based on Opportunity team
            List<Incentive_Earnings__c> inc = [SELECT Id,Is_CFI__c FROM Incentive_Earnings__c WHERE Opportunity_Id__c =:oppTeam.OpportunityId];
            if(inc.size()>0){
                if(inc[0].Is_CFI__c=='Y'){
					CarryForwardIncentiveCalculation cf = new CarryForwardIncentiveCalculation();
                    cf.CarryForwardIncentiveCalculation_dataFetch(oppTeam.OpportunityId);
                }else{
                   NewIncentiveCalculation n = new NewIncentiveCalculation(oppTeam.OpportunityId);
                }
            }
        }
        System.debug('::::::::::::::InvolvementCheckTrigger - Trigger class - End:::::::::::::');
    }
}