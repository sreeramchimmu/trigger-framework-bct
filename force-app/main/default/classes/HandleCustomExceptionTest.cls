@isTest
public class HandleCustomExceptionTest {
    static testmethod void testMyException()
    {
        
        DmlException d = new DmlException();
        d.setMessage('Test Exception');
        
        Test.startTest(); 
        HandleCustomException.LogException(d);
        Test.stopTest();  
    }
}