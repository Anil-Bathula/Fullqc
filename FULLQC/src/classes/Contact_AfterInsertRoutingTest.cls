/***************************************************************************************
Class Name      : Contact_AfterInsertRouting
Author          : Niket Chandane
Created Date    : Aug 8, 2012
Usage           : HULT-184 (When applicant get created Message need to be created for routing purpose)
Revision History: 
-------------------------------------------------------------------------------------------------------------
    Date            Owner               Comment
    8 Aug 2012      Niket Chandane      Added Comment
-------------------------------------------------------------------------------------------------------------
****************************************************************************************/
@isTest
private class Contact_AfterInsertRoutingTest {

    static testMethod void Contact_AfterInsertRoutingTest_UnitTest() {
        // TO DO: implement unit test
        // Create Country 
        Country__c objCountry = new Country__c( Name = 'DemoCountry',Calling_Code__c = 00,Country_Code__c  = 'pp',Region__c = 'MEA11');
        insert objCountry;
        
        //Create Department Data
        Department__c objDept = new Department__c(Name = 'TestMBA');
        insert objDept;
        
        // Created Program
        Program__c objProgram = new Program__c(Name = 'TestProgram',Country__c= objCountry.Id,Department__c = objDept.Id);
        insert objProgram;
        
        Id ApplicantRecordTypeId = [Select Id From RecordType where Name =: Label.HultApplicant_Record_Type limit 1].Id;
        
        Account  objTest = new Account(Name ='TestMBA-Asia');
        insert objTest;
        
        Contact objCon = new Contact(LastName='TestContact',Program_Primary__c = objProgram.Id, RecordTypeId = ApplicantRecordTypeId);
        insert objCon;
        
        Contact objConDntRoute = new Contact(LastName='Contact',Program_Primary__c = objProgram.Id, RecordTypeId = ApplicantRecordTypeId,Do_Not_Route__c = true);
        insert objConDntRoute;
        list<contact> lcon=new list<contact>();
        lcon.add(objConDntRoute);
        lcon.add(objCon);
        new Contact_AfterInsertRouting(new list<contact>(),lcon).execute(); 
    }
}