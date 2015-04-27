// test class for ApplicantPaymentController
@IsTest
private class TestForApplicantPaymentController {
    static testMethod void testPayment() 
    {  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        // insert program
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
        test.starttest();
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
        test.stoptest();
          // Insert User 
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1;
        Recordtype rectype=[select id from recordType where name='Other' and sobjecttype='Requirement__c'];
                Opportunity opp1 = new Opportunity();
                opp1.Name = 'Test Opportunity';
                opp1.Contact__c = C1.Id;
                opp1.StageName ='Accepted';
                opp1.CloseDate = Date.today();
                opp1.Program__c=pro.id;
                opp1.Attachments_Tab_Complete__c=false;
                insert opp1;
              
                // CReate finace Record
                Opportunity_Finance__c fin = new Opportunity_Finance__c();
               // fin.CurrencyIsoCode = 'USD';
                fin.Opportunity__c = opp1.id;
                insert fin;
             // Insert URL
                SixCards_Gateway_URL__c sc = new SixCards_Gateway_URL__c();
                sc.Gateway_URL__c = 'http://www.salesforce.com';
                sc.Payment_Currency__c = 'USD';
                insert sc;
                
        System.runAs(u1) 
        {
                
          ApplicantPaymentController contr= new ApplicantPaymentController();
          contr.createFinaceRecord();
          contr.ccode = sc.name;          
          contr.gettxnUrl();
          contr.I_agree_to_Hult_Terms_and_Conditions_c = true;          
          contr.gettncURL();
          contr.createFinancetxn();     
          contr.saveandcontinue();
          contr.saveandcontinueandlogout();     
                 
        }  

     }
     static testMethod void testnagtivePayment() 
    {  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        // insert program
        Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
        test.starttest();
         // insert account
        Account A1 = new Account(Name = pro.name,ownerid=userAccount.id);
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
         // insert contact for CPM user
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'TestForApplicantPaymentController@fakeemail.com' );
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
        // Create application
                Opportunity opp1 = new Opportunity();
                opp1.Name = 'Test Opportunity';
                opp1.Contact__c = C1.Id;
                opp1.StageName ='Accepted';
                opp1.CloseDate = Date.today();
                opp1.Program__c=pro.id;
                opp1.Attachments_Tab_Complete__c=false;
                opp1.Primary_Program_Choice__c='Bachelor of International Business Administration';
                insert opp1;

              // insert contact for CPM user
        Contact C2 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'TestForApplicantPaymentController123@fakeemail.com' );
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
         test.stoptest();
        // Insert User
        User u2 = new User( email='test-user1@fakeemail.com', contactid = c2.id, profileid = profileid, 
        UserName='test-user1@fakeemail.com', alias='tuser1', CommunityNickName='tuser11', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test1', LastName = 'User11' );
        insert u2;
       
       // get current user
        User currentUser2 = [select id,contact.id, title, firstname, lastname, email FROM User WHERE id=:u2.id ];      
        
           // insert opportunity
           Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test Opportunity';
            opp2.Contact__c = currentUser2.Contact.Id;
            opp2.StageName ='Accepted';
            opp2.CloseDate = Date.today();
            opp2.Education_Tab_Complete__c=false;
            opp2.Primary_Program_Choice__c = 'Executive MBA';
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
     
            
                
        System.runAs(u1) 
        {
                
          ApplicantPaymentController contr= new ApplicantPaymentController();     
          contr.createFinaceRecord();
          contr.saveandcontinue();
          contr.createFinancetxn();
          contr.geturl();
          contr.getproblemURL();
          contr.getapplicationtncURL();         
          contr.applicationTerm();
          contr.saveandcontinueandlogout();     
          contr.getpaymentValues();  
           
            /*Opportunity opp3 = new Opportunity();
            opp3.Name = 'Test Opportunity';
            opp3.Contact__c = currentUser3.Contact.Id;
            opp3.StageName ='Accepted';
            opp3.CloseDate = Date.today();
            opp3.Education_Tab_Complete__c=false;
            opp3.Primary_Program_Choice__c = 'Master of Business Administration';
            insert opp3;
        
          ApplicantPaymentController contr1= new ApplicantPaymentController();  
          contr1.getapplicationtncURL(); */
          
          
        }  

     }
}