// test class for ApplicantEducationController
@IsTest
private class TestForApplicantEducationController {
     /*by SHS 25/4/2013:Modified the code as per the new logic(use MasterDEtail relation b/n Education& Opportunity)
          removed Syste.runas(portaluser) as portal user dont have access to opportunity and due to masterdetail 
          Educationalso dont have access to Opportunity.(As old portal is not using any more no need to worry about portal users)
      */  
      static testMethod void testPosativeEducation() 
    {  
        //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
        
        // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        Test.StartTest();  
        // insert program
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
        
        // insert account
        Account A1 = new Account(Name = pro.name,ownerid=userAccount.id);
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
       // insert u1;
       
       // get current user
     //   User currentUser = [select id,contact.id, title, firstname, lastname, email FROM User WHERE id=:u1.id ];      
        
      
           // insert opportunity
           Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Contact__c = c1.Id;
            opp.StageName ='Accepted';
            opp.CloseDate = Date.today();
            opp.Program__c=pro.id;
            opp.Education_Tab_Complete__c=false;
            opp.Primary_Program_Choice__c = 'Master of Business Administration';
            insert opp;
            
            /*23/10/2013 shs: commented below 2 fields >> DegreeDateFrom__c,DegreeDateTo__c
        src::RE: fields to be deleted in SB and Prod
        */
            Education__c edu = new Education__c(
            Undergraduate_School_Attended__c='test',
            GraduateDateFrom__c=date.today(),
            GraduateDateTo__c=date.today(),
            application__c=opp.id,
            //DegreeDateFrom__c=date.today(),
            //DegreeDateTo__c=date.today(),
            Date_Graduated__c=date.today());
            insert edu;

       
            
            //  System.runAs(currentUser) 
        //{ 
           
            ApplicantEducationController controller = new ApplicantEducationController();
                 System.currentPagereference().getParameters().put('messageFlag','add');
                 
                 controller.proName='Bachelor of International Business Administration-UK-London';
                 controller.Undergraduate.Undergraduate_School_Attended__c='2010';
                 controller.GraduateDateFrom_year='2000';
                 controller.GraduateDateFrom_month='1';
                 controller.GraduateDateFrom_day='1';
                 controller.Undergraduate.EducationSpeciality__c = 'New Delhi';
                 controller.GraduateDateTo_year = '2000';
                 controller.GraduateDateTo_month = '1';
                 controller.GraduateDateTo_day = '1';
                 controller.Undergraduate.Highest_Degree_Attained__c = 'Doctoral Degree';
                 controller.Undergraduate.School_attended_for_Highest_Degree__c = 'Doctoral Degree';
                 controller.DegreeDateFrom_year  = '2000';
                 controller.DegreeDateFrom_month  = '1';
                 controller.DegreeDateFrom_day  = '1';
                 controller.Undergraduate.EducationSpeciality__c  = 'test';
                 controller.DegreeDateTo_year = '2000';
                 controller.DegreeDateTo_month = '1';
                 controller.DegreeDateTo_day = '1';
                 controller.Undergraduate.DegreeSpeciality__c='test';
                 controller.Date_Graduated_year='2000';
                 controller.Date_Graduated_month='2';
                 controller.Date_Graduated_day='2';                 
                 controller.saveUndergraduate();
                 controller.saveandcontinue();
                 controller.is_Cancel();
                 controller.getUndergraduate();
            controller.getItems();
            controller.geteList();
            Education__c edu1=new Education__c(
            Application__c=opp.id,
            GraduateDateTo__c=date.today(),
            GraduateDateFrom__c=date.today()
            );
            insert edu1;
            System.currentPagereference().getParameters().put('id',edu1.id);
            controller.edit();
            controller.is_delete();
            
            Test.stopTest();
            // Check for Education_Tab_Complete__c flag
         //   opportunity oppCheck = [select Education_Tab_Complete__c from opportunity where id=:opp.id];
        //    system.assert(oppcheck.Education_Tab_Complete__c==true);
            
            // Check insert history
           // Education__c his=[select id from Education__c where EducationSpeciality__c=:controller.hist.EducationSpeciality__c limit 1 ];
           // system.assert(his.id==controller.hist.id);
            controller.saveandcontinueandlogout();
            controller.Undergraduate.Undergraduate_School_Attended__c=null;
                 controller.Undergraduate.GraduateDateFrom__c=null;
                 controller.Undergraduate.EducationSpeciality__c = null;
                 controller.Undergraduate.GraduateDateTo__c =null;
                 controller.Undergraduate.Highest_Degree_Attained__c = null;
                 controller.Undergraduate.School_attended_for_Highest_Degree__c =null;
                // controller.Undergraduate.DegreeDateFrom__c  = null;
                 controller.Undergraduate.EducationSpeciality__c  = null;
                 //controller.Undergraduate.DegreeDateTo__c = null;
                 controller.Undergraduate.DegreeSpeciality__c=null;             
                 System.currentPagereference().getParameters().put('messageFlag','delete');
                 controller.saveUndergraduate();
       // }  
       /* 
           // insert contact for CPM user
        Contact C2 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c2.Firstname = 'Test name';
        c2.Gender__c = 'Male';
        c2.Country_Of_Citizenship__c = country.Id;
        c2.Country_Of_Origin__c = country.Id;
        c2.Country_Of_Residence__c = country.Id;
        c2.Birthdate = Date.today();
        c2.LeadSource = 'Alumni';
        c2.mailingstreet = 'test';
        c2.mailingcity = 'New York';
        c2.mailingstate = 'Test';
        c2.mailingpostalcode = '1W2E4R';
        c2.Home_Phone_Country_Code__c = '011';
        c2.Home_Phone_Area_Code__c = '292';
        c2.Home_Phone_Main_Number__c = '2153648';
        c2.Language__c = 'English';
        c2.Language_English_Speaking__c = 'Fluently';
        c2.Language_English_Listening__c = 'Fluently';
        c2.Language_English_Writing__c = 'Fluently';
        c2.Language_English_Reading__c = 'Fluently';
        insert c2;
 
        // Insert User
        User u2 = new User( email='test-user1@fakeemail.com', contactid = c2.id, profileid = profileid, 
        UserName='test-user1@fakeemail.com', alias='tuser1', CommunityNickName='tuser11', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test1', LastName = 'User11' );
        insert u2;
       
       // get current user
     //   User currentUser2 = [select id,contact.id, title, firstname, lastname, email FROM User WHERE id=:u2.id ];      
        Program__c pro1=new Program__c(name='EMBA-China-Shanghai');
        insert pro1;
        
           // insert opportunity
           Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opportunity';
            opp2.Contact__c = currentUser2.Contact.Id;
            opp2.StageName ='Accepted';
            opp2.CloseDate = Date.today();
            opp2.Education_Tab_Complete__c=false;
            opp2.Primary_Program_Choice__c = 'Executive MBA';
            opp2.Program__c=pro1.id;
            insert opp2;
            
            
                // insert contact for CPM user
        Contact C3 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c3.Firstname = 'Test name';
        c3.Gender__c = 'Male';
        c3.Country_Of_Citizenship__c = country.Id;
        c3.Country_Of_Origin__c = country.Id;
        c3.Country_Of_Residence__c = country.Id;
        c3.Birthdate = Date.today();
        c3.LeadSource = 'Alumni';
        c3.mailingstreet = 'test';
        c3.mailingcity = 'New York';
        c3.mailingstate = 'Test';
        c3.mailingpostalcode = '1W2E4R';
        c3.Home_Phone_Country_Code__c = '011';
        c3.Home_Phone_Area_Code__c = '292';
        c3.Home_Phone_Main_Number__c = '2153648';
        c3.Language__c = 'English';
        c3.Language_English_Speaking__c = 'Fluently';
        c3.Language_English_Listening__c = 'Fluently';
        c3.Language_English_Writing__c = 'Fluently';
        c3.Language_English_Reading__c = 'Fluently';
        insert c3;  
        
          // Insert User
        User u3 = new User( email='test-user11@fakeemail.com', contactid = c3.id, profileid = profileid, 
        UserName='test-user11@fakeemail.com', alias='tuser1', CommunityNickName='tuser111', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test11', LastName = 'User111' );
        insert u3;
        
       User currentUser3 = [select id,contact.id, title, firstname, lastname, email FROM User WHERE id=:u3.id ];      
     

         // System.runAs(currentUser2 ){
            
            ApplicantEducationController controller2 = new ApplicantEducationController();
            System.currentPagereference().getParameters().put('messageFlag','delete');
            System.currentPagereference().getParameters().put('saveandc','save');
            controller2.proName='Bachelor of International Business Administration-UK-London';
            controller2.saveUndergraduate();
            
            
             Program__c pro2=new Program__c(name='BIBA-UK-London');
            insert pro2;
        
            Opportunity opp3 = new Opportunity();
            opp3.Name = 'Test Opportunity';
            opp3.Contact__c = currentUser3.Contact.Id;
            opp3.StageName ='Accepted';
            opp3.CloseDate = Date.today();
            opp3.Education_Tab_Complete__c=false;
            opp3.Primary_Program_Choice__c = 'Bachelor of International Business Administration';
            opp3.Program__c=pro2.Id;
            insert opp3;
            
            ApplicantEducationController contr3= new ApplicantEducationController();
            System.currentPagereference().getParameters().put('messageFlag','add');
            contr3.proName='Bachelor of International Business Administration-UK-London';
            contr3.GraduateDateFrom_day='';
            contr3.GraduateDateFrom_month='';
            contr3.saveUndergraduate();
            ApplicantEducationController contr4= new ApplicantEducationController();
            System.currentPagereference().getParameters().put('messageFlag','edit');
            
            Test.StopTest();
          //  ApplicantEducationController contr5= new ApplicantEducationController();
         //   string hdegree='Master';
        //    contr4.getrecordtype(hdegree);
          //  hdegree='Bachelor';
         //   contr4.getrecordtype(hdegree); 
         //   hdegree='High School';
         //   contr4.getrecordtype(hdegree); 
            
        //  }
            */
     } 
        
  
}