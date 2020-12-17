global class IncentiveProcessor implements Schedulable {
    
     global void execute (SchedulableContext sc){
        system.debug('2 -In I-C processor ');
        IncentiveProcessingEngine icpe = new IncentiveProcessingEngine();
        icpe.processIncentive();
      //  IncentiveProcessorMonthly icpmly = new IncentiveProcessorMonthly();
         
     	  
    }


    
}