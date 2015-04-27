/****************************************************
Class Name     : Contact_Duplicate_Email_Checker_Test
Developer      : Anil.B - 11/feb/2015
Test class for : Contact_Duplicate_Email_Checker
Code coverage  : 85%
******************************************************/

@isTest
public class  Contact_Duplicate_Email_Checker_Test{
    public static testmethod void methodname(){        
    
    
        id App_rectype=RecordTypeHelper.getRecordTypeId('Contact','Applicant');
        
        Contact c=New Contact();        
        C.lastname='Test123'; 
        C.email='test123mostxyz@gmail.com';  
        c.recordtypeid= App_rectype;     
        try{
            insert c;       
        }catch (DmlException ex) {
            system.debug(ex);
        } 
        
        Contact c1=New Contact();        
        C1.lastname='Test123'; 
        C1.email='test123mostxyz@gmail.com';  
        c1.applicant_email__c='test123mostxyz@gmail.com';   
        c1.Recordtypeid=App_rectype;   
        try{
            insert c1;       
        }catch (DmlException ex) {
            system.debug(ex);
        } 
        
        
        Country__c ctry=TestDataUtil.createCountry();
        insert ctry;
        
        Department__c dep=TestDataUtil.createDepartment();
        insert dep;
        
        Program__c pgm=TestDataUtil.createProgram(ctry.Id, dep.Id);
        insert pgm; 
        
        Lead led=TestDataUtil.createLead(ctry.Id,pgm.Id);
        led.Email='testasdfasdf123@test.com';
        led.Applicant_Email__c='testasdfasdf123@test.com';
        led.leadSource='SAT';
        led.Isconverted=false;
        insert led;    
        
        
        Contact c2=New Contact();        
        C2.lastname='Test123'; 
        C2.email='testasdfasdf1231@test.com';  
        c2.applicant_email__c='testasdfasdf1231@test.com';      
        try{
            insert c2;       
        }catch (DmlException ex) {
            system.debug(ex);
        } 
    
    
  }
}