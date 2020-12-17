//Created By Rameez on 24/10/2019
@isTest
public class RunTriggerOnceTestcls {
	static testMethod void validateTest()
    {
        Test.startTest();
        boolean calledOnceflag = true;
        RunTriggerOnce testrun= new RunTriggerOnce();
        test.stopTest();
    }  
    
}