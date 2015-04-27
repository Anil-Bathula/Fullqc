/*
  Modified By : Anil.B on 11/11/2014 to delete this field Sub_region__c removed this field from query
*/

@IsTest
private class Contact_RouteByRecruitingTest 
{
    static Contact objCon;
    static Contact_RouteByRecruiting Con_roteController;
    
    static testmethod void AnalysContact_RouteByRecrutingTest()
    {
        test.startTest();
        
        ID ProfileID = [ Select id from Profile][0].id;
         User objUser = new User( email='test-user@fakeemail.com', profileid = profileid, 
                            UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
                            TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                            LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert objUser;
        
        // Create Country 
        Country__c objCountry = new Country__c( Name = 'DemoCountry',Calling_Code__c = 00,Country_Code__c  = 'pp',Region__c = 'MEA11');
        insert objCountry;
        
        //Create Department Data
        Department__c objDept = new Department__c(Name = 'TestMBA');
        insert objDept;
        
        // Created Country Requirement 
        Requirement__c objReqCountry = new Requirement__c(Name = 'CR',Country__c = objCountry.Id);
        insert objReqCountry;
        
        // Created Program
        Program__c objProgram = new Program__c(Name = 'TestProgram',Country__c= objCountry.Id,Department__c = objDept.Id);
        insert objProgram;
        
        Routing_Table__c objRoute = new Routing_Table__c(Routed_To__c='test-user@fakeemail.com', 
                                                         Department__c = objDept.Id, 
                                                         Priority__c = 'High',Routed_By__c ='User Name',
                                                         Region__c ='Asia');
        insert objRoute;
        
        Id ApplicantRecordTypeId = [Select Id From RecordType where Name =: Label.HultApplicant_Record_Type limit 1].Id;
        
        Account  objTest =TestDataUtil.createAccount('TestMBA-Asia', 'Candidate');// new Account(Name ='TestMBA-Asia');
        insert objTest;
        
        objCon = new Contact(LastName='TestContact',Program_Primary__c = objProgram.Id, RecordTypeId = ApplicantRecordTypeId);
        insert objCon;
        
        Contact objConDntRoute = new Contact(LastName='Contact',Program_Primary__c = objProgram.Id, RecordTypeId = ApplicantRecordTypeId,Do_Not_Route__c = true);
        insert objConDntRoute;
        
        ApexPages.StandardController conStdController = new ApexPages.StandardController(objCon);
        Con_roteController = new Contact_RouteByRecruiting(conStdController);
        Con_roteController.execute();
        
        List<Contact> lstCon = [select Name, Age_Range__c, Apply_Routing_Type__c, Department_Name_Primary__c, Department_Name_Secondary__c, Department_Name_Third__c, 
                                Country_Of_Residence_Name__c, Country_Of_Residence__c, Do_Not_Route__c, MailingPostalCode, MailingCity, MailingCountry, MailingState, 
                                OwnerId, OtherPostalCode, OtherCity, OtherCountry, OtherState, Program_Primary__c, Program_Secondary__c, Program_Third__c, Region__c,
                                Work_Load__c,RecordTypeId from Contact where Id =: objCon.Id];
        
        Contact_RouteByRecruiting.applyRouting(lstCon);
        
        /*
         Chanage By : Niket Chandane
         Change At  : May-16-2012
         Summary    : Updated The test method to increase the test code coverage
        */
        lstCon.Clear();
        Contact_RouteByRecruiting.applyRouting(lstCon);
        
        test.stopTest();
    }
}