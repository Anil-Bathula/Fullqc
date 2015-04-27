/*
    Class     : SATgrouping_test
    Developer : Anil.B
    Date      : 28/10/2014
    Comment   : Test class for SATgrouping trigger
    Triggers  : SATgrouping_test(94%)
         
*/   
@isTest(seealldata=True)
private class SATgrouping_test{

    static testMethod void test_SAT() {
        Country__c ctry=TestDataUtil.createCountry();
        insert ctry;
        
        Department__c dep=TestDataUtil.createDepartment();
        insert dep;
        
        Program__c pgm=TestDataUtil.createProgram(ctry.Id, dep.Id);
        insert pgm; 
        
        Lead led=TestDataUtil.createLead(ctry.Id,pgm.Id);
        led.Applicant_Email__c='testasdfasdf@test.com';
        led.leadSource='SAT';
        insert led;   
        
        SATgrouping__c st=new SATgrouping__c();
        st.name='test';    
        st.SAT_grouping_name__c='other';
        insert st;
        
        led.Undergraduate_Major__c='other';
        update led;
  }
  }