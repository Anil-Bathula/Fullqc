// test class for ApplicantExamController 
@IsTest
private class TestForApplicantExamController  {
// Test Method
/*******************************************
Changes Made By :Anil.B
Date:25/4/2013
Purpose:- Changed the relationship between
Exam and opportunity previous it was lookup
Now Master detail so added applicant__c field
in exam object test method
********************************************/

    
   static testMethod void testExamBBA(){  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 =TestDataUtil.createAccount(pro.name, 'Candidate');// new Account(Name = pro.name,ownerid=userAccount.id);
        A1.ownerid=userAccount.id;
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        // insert contact for CPM user
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c1.Firstname = 'Test name';
        c1.Gender__c = 'Male';
        c1.Country_Of_Citizenship__c = country.Id;
        c1.Country_Of_Origin__c = country.Id;
        c1.Country_Of_Residence__c = country.Id;
        c1.Birthdate = Date.today();
        c1.LeadSource = 'Alumni';
        c1.mailingstreet = 'test';
        c1.mailingcity = 'New York';
        c1.mailingstate = 'Test';
        c1.mailingpostalcode = '1W2E4R';
        c1.Home_Phone_Country_Code__c = '011';
        c1.Home_Phone_Area_Code__c = '292';
        c1.Home_Phone_Main_Number__c = '2153648';
        c1.Language__c = 'English';
        c1.Language_English_Speaking__c = 'Fluently';
        c1.Language_English_Listening__c = 'Fluently';
        c1.Language_English_Writing__c = 'Fluently';
        c1.Language_English_Reading__c = 'Fluently';
        c1.isEnglishNative__c=true;
        insert C1;
          // Insert User
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
          // insert opportunity
         Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Contact__c = C1.Id;
            opp.StageName ='Accepted';
            opp.CloseDate = Date.today();
            opp.Primary_Program_Choice__c='Bachelor of International Business Administration';
            opp.Program__c=pro.id;
            opp.Education_Tab_Complete__c=false;
            insert opp;
       // get current user
       ApplicantExamController controller;
         System.runAs(u1) 
        {
                
                 RecordType recid=[select id from recordtype where name='Exam' and sobjectType='History__c'];
                  controller = new ApplicantExamController();
                 
                 controller.hist.Exam_Type__c='Test';
                 controller.hist.Planned_Test_Date__c=date.today();
                 controller.hist.Planned_Test_Location__c='test';
                 controller.hist.Exam_Location__c='test';
                 controller.hist.Exam_Score__c='100';
                 controller.hist.NeedofTest__c=true;
                 controller.Planned_Test_Date_day='01';
                 controller.Planned_Test_Date_month='01';
                 controller.Planned_Test_Date_year='2020';                 
                 system.assert(controller.saveandcontinue()!=null);
                 
                 //controller.hist.TakenTest__c=true;
                 controller.hist.Exam_Type__c='Test';
                 controller.hist.Planned_Test_Date__c=date.today();
                 controller.hist.Planned_Test_Location__c='test';
                 controller.hist.Exam_Location__c='test';
                 controller.hist.Exam_Score__c='100';
                 controller.hist.NeedofTest__c=true;
                 controller.Exam_Date_day='01';
                 controller.Exam_Date_month='01';
                 controller.Exam_Date_year='1900';
                 system.assert(controller.saveandcontinue()!=null);
                 
                 controller.hist.TakenTest__c=true;
                 controller.hist.Exam_Type__c=null;                 
                 controller.hist.Planned_Test_Location__c=null;
                 controller.hist.Exam_Location__c=null;
                 controller.hist.Exam_Score__c=null;
                 controller.Exam_Date_day='';
                 controller.Exam_Date_month='';
                 controller.Exam_Date_year='';
                 system.assert(controller.saveandcontinue()==null);
                 system.assert(controller.saveandcontinueandlogout()==null);               
                 controller.allrecord();
               }  Exam__c his=new Exam__c(
                 Planned_Test_Date__c=date.today(),
                 Exam_Date__c=date.today(),NotScheduledTest__c=true,Application__c=opp.id
                 );
                 insert his;
                
                System.currentPagereference().getParameters().put('hid',his.id);
                System.currentPagereference().getParameters().put('messageFlag','add');
                
                controller.edit();
                system.assert(controller.isedit==true);
                controller.hisdelete();
                system.assert(controller.isedit==false);
                controller.cancel();
                system.assert(controller.isedit==false);
                controller.saveandsave();
                controller.Onlinesaveandcontinue();
                controller.getExamType();
                controller.getradioval();
                controller.checkExamType();
              // ApplicantExamController controller2 = new ApplicantExamController();
         
}


static testMethod void testExamMBA(){  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 = TestDataUtil.createAccount(pro.name, 'Candidate');// new Account(Name = pro.name,ownerid=userAccount.id);
        A1.ownerid=userAccount.id;
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        // insert contact for CPM user
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c1.Firstname = 'Test name';
        c1.Gender__c = 'Male';
        c1.Country_Of_Citizenship__c = country.Id;
        c1.Country_Of_Origin__c = country.Id;
        c1.Country_Of_Residence__c = country.Id;
        c1.Birthdate = Date.today();
        c1.LeadSource = 'Alumni';
        c1.mailingstreet = 'test';
        c1.mailingcity = 'New York';
        c1.mailingstate = 'Test';
        c1.mailingpostalcode = '1W2E4R';
        c1.Home_Phone_Country_Code__c = '011';
        c1.Home_Phone_Area_Code__c = '292';
        c1.Home_Phone_Main_Number__c = '2153648';
        c1.Language__c = 'English';
        c1.Language_English_Speaking__c = 'Fluently';
        c1.Language_English_Listening__c = 'Fluently';
        c1.Language_English_Writing__c = 'Fluently';
        c1.Language_English_Reading__c = 'Fluently';
        insert C1;
          // Insert User
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
          // insert opportunity
         Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Contact__c = C1.Id;
            opp.StageName ='Accepted';
            opp.CloseDate = Date.today();
            opp.Primary_Program_Choice__c='Master of Business Administration';
            opp.Program__c=pro.id;
            opp.Education_Tab_Complete__c=false;
            insert opp;
       // get current user
       ApplicantExamController controller3 ;
         System.runAs(u1) 
        {
                
                RecordType recid=[select id from recordtype where name='Exam' and sobjectType='History__c'];
               controller3  = new ApplicantExamController();
                System.currentPagereference().getParameters().put('messageFlag','edit');
            }     Exam__c his3=new Exam__c(
                 Planned_Test_Date__c=date.today().addyears(2),
                 Exam_Date__c=date.today(),TakenTest__c=true,Application__c=opp.id
                 );
                 
                insert his3;
                controller3.testradiovaluetype='2';
                controller3.Planned_Test_Date_year='';  
                controller3.getExamType();
                controller3.getradioval();
                controller3.checkExamType();
                controller3.Planned_Test_Date_day='01';
                controller3.Planned_Test_Date_month='01';
                controller3.Planned_Test_Date_year='2020';   
                controller3.Exam_Date_day='01';
                controller3.Exam_Date_month='01';
                controller3.Exam_Date_year='1900';
                controller3.isedit=true;
                Date pdate=date.today().addyears(2);
                controller3.saveandcontinue();
                System.currentPagereference().getParameters().put('hid',his3.id);
                controller3.edit();
                controller3.hisdelete();
             //  ApplicantExamController controller4 = new ApplicantExamController();
         
}



static testMethod void testExamEMBA(){  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 = TestDataUtil.createAccount(pro.name, 'Candidate');// new Account(Name = pro.name,ownerid=userAccount.id);
        A1.ownerid=userAccount.id;
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        // insert contact for CPM user
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c1.Firstname = 'Test name';
        c1.Gender__c = 'Male';
        c1.Country_Of_Citizenship__c = country.Id;
        c1.Country_Of_Origin__c = country.Id;
        c1.Country_Of_Residence__c = country.Id;
        c1.Birthdate = Date.today();
        c1.LeadSource = 'Alumni';
        c1.mailingstreet = 'test';
        c1.mailingcity = 'New York';
        c1.mailingstate = 'Test';
        c1.mailingpostalcode = '1W2E4R';
        c1.Home_Phone_Country_Code__c = '011';
        c1.Home_Phone_Area_Code__c = '292';
        c1.Home_Phone_Main_Number__c = '2153648';
        c1.Language__c = '';
        c1.Language_English_Speaking__c = '';
        c1.Language_English_Listening__c = '';
        c1.Language_English_Writing__c = '';
        c1.Language_English_Reading__c = '';
        insert C1;
          // Insert User
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
          // insert opportunity
         Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Contact__c = C1.Id;
            opp.StageName ='Accepted';
            opp.CloseDate = Date.today();
            opp.Primary_Program_Choice__c='Executive MBA';
            opp.Program__c=pro.id;
            opp.Education_Tab_Complete__c=false;
            insert opp;
       // get current user
      ApplicantExamController controller2; 
         System.runAs(u1) 
        {
                  
                RecordType recid=[select id from recordtype where name='Exam' and sobjectType='History__c'];
                 controller2 = new ApplicantExamController();
                System.currentPagereference().getParameters().put('messageFlag','delete');
              }  
                 Exam__c his2=new Exam__c(
                 Planned_Test_Date__c=date.today().addyears(2),
                 Exam_Date__c=date.today(),NeedofTest__c=true,Application__c=opp.id
                 );
                insert his2;
                controller2.testradiovaluetype='1';
                controller2.getExamType();
                controller2.getradioval();
                controller2.checkExamType();
                controller2.Planned_Test_Date_day='01';
                controller2.Planned_Test_Date_month='01';
                controller2.Planned_Test_Date_year='2020';
                controller2.Exam_Date_day='01';
                controller2.Exam_Date_month='01';
                controller2.Exam_Date_year='1900';   
                controller2.saveandcontinue();
                System.currentPagereference().getParameters().put('hid',his2.id);
                controller2.edit();
               // ApplicantExamController controller3 = new ApplicantExamController();
        
}



}