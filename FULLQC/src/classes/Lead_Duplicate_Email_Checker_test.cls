/*
    Class     : Lead_Duplicate_Email_Checker_Test
    Developer : Harsha Simha S
    Date      : 28/8/2013
    Comment   : Test class for Lead_Duplicate_Email_Checker_Test.
    Triggers  : Lead_Duplicate_Email_Checker_Test(94%)
         
*/   
@isTest(seealldata=false)
private class Lead_Duplicate_Email_Checker_test {

    static testMethod void test_email() {
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
               
        Lead led1=TestDataUtil.createLead(ctry.Id,pgm.Id);
        led1.Email='testasdfasdf@test.com'; 
        led1.Applicant_Email__c='testasdfasdf@test.com';        
        try{insert led1;
        }catch(EXception e){}
        
        contact ctct=TestDataUtil.createContact(pgm.Id);
        ctct.Applicant_Email__c='test@test1.com';
        try{insert ctct;
        }catch(Exception e){}
        
        Lead led2=TestDataUtil.createLead(ctry.Id,pgm.Id);
        led2.Applicant_Email__c='test@test1.com';        
        try{
            insert led2;
        }
        catch(Exception e){}
        
    }
}