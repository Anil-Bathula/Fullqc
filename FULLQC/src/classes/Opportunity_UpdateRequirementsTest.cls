/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Opportunity_UpdateRequirementsTest 
{

    static testMethod void UpdateRequirementsTest() 
    {
    	Test.startTest();
    	// TO DO: implement unit test
    
        //Create Country Data
        Country__c objCountry = new Country__c( Name = 'DemoCountry',Calling_Code__c = 00,Country_Code__c  = 'pp',Region__c = 'MEA11'); //,CurrencyIsoCode = 'USD-U.S. Dollar'
        insert objCountry;
        
        //Create Requirements for Country Data
        Requirement__c objReqCountry = new Requirement__c(Name = 'CR',Country__c = objCountry.Id);
        insert objReqCountry;
        
        Requirement__c objReqCountry2 = new Requirement__c(Name = 'CR2',Country__c = objCountry.Id);
        insert objReqCountry2;
        
        //Create Department Data
        Department__c objDept = new Department__c(Name = 'Dept1');
        insert objDept;
        
        //Create Requirements for Department Data
        Requirement__c objReqDept = new Requirement__c(Name = 'CR01',Department__c = objDept.Id);
        insert objReqDept;
        
        Requirement__c objReqDept1 = new Requirement__c(Name = 'CR02',Department__c = objDept.Id);
        insert objReqDept1;
        
        //Create Program Data
        Program__c objProgram = new Program__c(Name = 'Program1',Country__c= objCountry.Id,Department__c = objDept.Id);
        insert objProgram;
        
        Program__c objProgramUpdate = new Program__c(Name = 'Program2',Department__c = objDept.Id);
        insert objProgramUpdate;
        
        Requirement__c objReqProUpdate = new Requirement__c(Name = 'CR01',Department__c = objDept.Id);
        insert objReqProUpdate;
        
        Requirement__c objReqProUpdate2 = new Requirement__c(Name = 'CR02',Department__c = objDept.Id);
        insert objReqProUpdate2;
        
        //Create Requirements for Program Data
        Requirement__c objReqPro = new Requirement__c(Name = 'CR111',Program__c = objProgram.Id);
        insert objReqPro;
        
        //Create Opportunity which contains above Three Data
        Account objAccount =TestDataUtil.createAccount('ORG1', 'Candidate');// new Account(Name = 'ORG1');
        insert objAccount;
        
        Opportunity opp = new Opportunity(StageName = 'Confirmed',Name = 'abc',CloseDate = System.today(),Program__c = objProgram.Id,AccountId = objAccount.Id); 
        insert opp;
        
        Requirement__c objReqDeptDumy1 = new Requirement__c(Name = 'CR012',Parent__c = objReqDept.Id,Opportunity__c = opp.Id);
        insert objReqDeptDumy1;
        
        Requirement__c objReqDeptDumy2 = new Requirement__c(Name = 'CR023',Parent__c = objReqDept1.Id,Opportunity__c = opp.Id);
        insert objReqDeptDumy2;
        
        List<Requirement__c> lstReq = [Select r.Program__c, r.Opportunity__c From Requirement__c r where r.Opportunity__c =: opp.ID and r.Parent__c != null];
        
        List<Attachment> lstNewAttach = new List<Attachment>();
        List<Note> lstNewNote = new List<Note>();
        
        for(Requirement__c objTest : lstReq)
        {
        	Blob b = Blob.valueOf('Blah blah blah');
        	Attachment attachment = new Attachment(Name='An attachment',body=b,parentId = objTest.Id);
        	lstNewAttach.add(attachment);
        	Note objNote = new Note(IsPrivate = true,Title = 'Test', body = 'Body', parentid = objTest.Id);
        	lstNewNote.add(objNote);
        }
        
        insert lstNewAttach;
        insert lstNewNote;
        
        opp.Program__c = objProgramUpdate.Id;
        update opp;
        Test.stopTest();
    }
}