@isTest(SeeAllData=True)
public class CEO_Dashboard_Test {
    @isTest
    Static void testMethod1(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
    }
   @isTest
    Static void testMethod2(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Q1';
        List<String> sbu = new List<String>();
        sbu.add('USA');
        db.sbu = sbu;
        List<String> bu = new List<String>();
        bu.add('Dropthought');
        db.bu = bu;
        List<String> OppOwner = new List<String>();
        OppOwner.add('Kalirajan M');
        db.oppOwner = OppOwner;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
       @isTest
    Static void testMethod3(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Q2';
        List<String> OppOwner = new List<String>();
        OppOwner.add('Kalirajan M');
        db.oppOwner = OppOwner;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
    @isTest
    Static void testMethod4(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Q3';
        List<String> bu = new List<String>();
        bu.add('Dropthought');
        db.bu = bu;
        List<String> OppOwner = new List<String>();
        OppOwner.add('Kalirajan M');
        db.oppOwner = OppOwner;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
    @isTest
    Static void testMethod5(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Q4';
        List<String> sbu = new List<String>();
        sbu.add('USA');
        db.sbu = sbu;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
    @isTest
    Static void testMethod6(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'H1';
        List<String> sbu = new List<String>();
        sbu.add('USA');
        db.sbu = sbu;
        List<String> bu = new List<String>();
        bu.add('Dropthought');
        db.bu = bu;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
    @isTest
    Static void testMethod7(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'H2';
        List<String> sbu = new List<String>();
        sbu.add('USA');
        db.sbu = sbu;
        List<String> OppOwner = new List<String>();
        OppOwner.add('Kalirajan M');
        db.oppOwner = OppOwner;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
        @isTest
    Static void testMethod8(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Current FY';
        List<String> bu = new List<String>();
        bu.add('Dropthought');
        db.bu = bu;
        List<String> OppOwner = new List<String>();
        OppOwner.add('Kalirajan M');
        db.oppOwner = OppOwner;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
    
            @isTest
    Static void testMethod9(){
        CEO_Dashboard db = new CEO_Dashboard();
        db.fromMonth = 'Current FY';
        List<String> bu = new List<String>();
        bu.add('Dropthought');
        db.bu = bu;
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getMonths();
        db.getQuaters();
        db.getXAxis();
        db.getRegions();
        db.getBusinessUnits();
        db.getopportunityOwners();
        db.getData();
        db.xAxisVal = 'mon';
        db.getData1();
        db.xAxisVal = 'bu';
        db.getData2();
        db.xAxisVal = 'oppOwner';
        db.getData3();
        db.currentYear = 2021;
        db.currentMonth = 2;
        db.getData();
        db.getData1();
        db.getData2();
        db.getData3();
    } 
}