@IsTest
public class IncentiveSchedulerTestCls {
    @IsTest
    public static void testIncentiveScheduler(){
        String cronExp = '0 0 * * * ?';
        
        Test.startTest();
        
    	String jobId = system.schedule('Incentive Computation 1hr once', cronExp, new IncentiveScheduler());
        CronTrigger ct = [select id,CronExpression,TimesTriggered,NextFireTime from CronTrigger where id=:jobId];
        system.assertEquals(cronExp, ct.CronExpression);
        system.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}