global class QuotaProcessor implements Schedulable {

    global void execute (SchedulableContext sc){
        system.debug('1 - Printing Quota Slippage processor ');
        QuotaSlippageProcessorEngine qpe = new QuotaSlippageProcessorEngine();
      
        qpe.processQuotaSlippage();
    }
}