// test class for ApplicantaccountDetails 
@IsTest
private class TestForApplicantaccountDetails {
    static testMethod void testPosativeApplicantFinal() 
    {  
        //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
        
        // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        
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
        c1.Language_English_Speaking__c = 'Advanced';
        c1.Language_English_Listening__c = 'Advanced';
        c1.Language_English_Writing__c = 'Advanced';
        c1.Language_English_Reading__c = 'Advanced';
        c1.Start_Term__c='sekhar';
        insert C1;
        
        Contact C2 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail2.com' );
        C2.Firstname = 'Test name2';
        C2.Gender__c = 'Male';
        C2.Country_Of_Citizenship__c = country.Id;
        C2.Country_Of_Origin__c = country.Id;
        C2.Country_Of_Residence__c = country.Id;
        C2.Birthdate = Date.today();
        C2.LeadSource = 'Alumni';
        C2.mailingstreet = 'test';
        C2.mailingcity = 'New York';
        C2.mailingstate = 'Test';
        C2.mailingpostalcode = '1W2E4R';
        C2.Home_Phone_Country_Code__c = '011';
        C2.Home_Phone_Area_Code__c = '292';
        C2.Home_Phone_Main_Number__c = '2153648';
        C2.Language__c = 'English';
        C2.Language_English_Speaking__c = 'Advanced';
        C2.Language_English_Listening__c = 'Advanced';
        C2.Language_English_Writing__c = 'Advanced';
        C2.Language_English_Reading__c = 'Advanced';
        insert c2;
 
        // Insert User
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
        UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
          
        User u2 = new User( email='test-user@fakeemail2.com', contactid = c2.id, profileid = profileid, 
        UserName='test-user@fakeemail2.com', alias='tuser12', CommunityNickName='tuser12', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test2', LastName = 'User2' );
        insert u2;  
          
        Opportunity opp1 = new Opportunity();
            opp1.Name = 'Test Opportunity';
            opp1.Contact__c = C1.Id;
            opp1.StageName ='Partial Application';
            opp1.Application_Substage__c='Completed Application';
            opp1.Applicant_Confirmation__c='Yes';
            opp1.Confirmation_Deadline__c=date.today();
            opp1.CloseDate = Date.today();
            opp1.Primary_Campus__c='Boston';
            insert opp1;
              
        System.runAs(u1) 
        {
            
            
            ApplicantaccountDetails controller = new ApplicantaccountDetails();
         //   controller.welcomeMessage('Partial Application' ,'Pending Test(s)');
         //   controller.welcomeMessage('Partial Application' ,'Not Completing App');
            controller.welcomeMessage('Accepted' ,'Notified');
            controller.welcomeMessage('Conditionally Accepted','Notified');
            controller.welcomeMessage('Accepted','Pending Interview');
            controller.welcomeMessage('Accepted','Interviewed');
            controller.welcomeMessage('Enrolled','');
            controller.welcomeMessage('Endorsed','Notified');
            controller.welcomeMessage('Confirmed','');
            controller.welcomeMessage('Conditionally Confirmed','');
            controller.welcomeMessage('Admissions Endorsed Confirmed','');
            controller.welcomeMessage('Endorsed Confirmed','');
            controller.welcomeMessage('Waitlisted Confirmed','');
            controller.welcomeMessage('Withdrawn','');
            controller.welcomeMessage('','');
            controller.getisCDeadline();
                       
           
        } 
        
        Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opportunity';
            opp2.Contact__c = C2.Id;
            opp2.StageName ='Admissions Endorsed';
            opp2.Application_Substage__c='Notified';
            opp2.Applicant_Confirmation__c='Yes';
            opp2.Confirmation_Deadline__c=date.today();
            opp2.CloseDate = Date.today();
            insert opp2;
            
            
         System.runAs(u2) 
        {
            
            ApplicantaccountDetails controller = new ApplicantaccountDetails();
          //  controller.welcomeMessage('Partial Application' ,'Pending Test(s)');
          //  controller.welcomeMessage('Partial Application' ,'Not Completing App');
            controller.welcomeMessage('Accepted' ,'Notified');
            controller.welcomeMessage('Conditionally Accepted','Notified');
            controller.welcomeMessage('Accepted','Pending Interview');
            controller.welcomeMessage('Accepted','Interviewed');
            controller.welcomeMessage('Enrolled','');
            controller.welcomeMessage('Endorsed','Notified');
            controller.welcomeMessage('Confirmed','');
            controller.welcomeMessage('Conditionally Confirmed','');
            controller.welcomeMessage('Endorsed Confirmed','');
            controller.welcomeMessage('Waitlisted Confirmed','');
            controller.welcomeMessage('Withdrawn','');
            controller.welcomeMessage('','');
            controller.getisCDeadline();
                       
           
        }   

     }
}