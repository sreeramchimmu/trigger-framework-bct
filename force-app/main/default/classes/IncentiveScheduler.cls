global class IncentiveScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
        //New Incentive Computation
        NewIncentiveBatch inc = new NewIncentiveBatch();
        Database.executeBatch(inc, 1);
        
        //Carry Forward Incentive Computation
        CarryForwardIncentiveBatch cfi = new CarryForwardIncentiveBatch();
        Database.executeBatch(cfi, 1); 
    }
    
  /*Below code is used to Schedule IncentiveScheduler class in 30 mins intervel,through the anonymous block
   * 
   * IncentiveScheduler inc = new IncentiveScheduler();
    String cronExp = '0 30 * * * ?';
    String jodId = system.schedule('Incentive Computation 1hr once', cronExp, inc);
	*
	*/
}