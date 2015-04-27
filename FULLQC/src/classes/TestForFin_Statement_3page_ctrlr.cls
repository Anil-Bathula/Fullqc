/*Test class for Fin_Statement_3page_ctrlr and Fin_Statement_bba_ctrlr classes*/
@IsTest
private class TestForFin_Statement_3page_ctrlr{
    //test method for Non-BBA Finance PDF buttons
    static testMethod void testApplicant() 
    {  
         //get a user with System Administrator profile and with any role
        User userAccount = [ Select id,userroleid from user where profile.name = 'System Administrator' and userroleid!=null and isactive=true limit 1];
         // get profile id for 'Applicant Customer Portal User'
        ID ProfileID = [ Select id from Profile where name = 'Applicant Customer Portal User'].id;
        test.startTest();
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
        c1.Salutation='Mr';
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
        Recordtype rectype=[select id from recordType where name='Other' and sobjecttype='Requirement__c'];
            Opportunity opp1 = new Opportunity();
            opp1.Name = 'Test Opportunity';
            opp1.Contact__c = C1.Id;
            opp1.StageName ='Confirmed';
            opp1.CloseDate = Date.today();
            opp1.Program__c=pro.id;                
            opp1.Attachments_Tab_Complete__c=false;
            opp1.Confirmation_Deadline__c = Date.today();
            insert opp1;
            
            Opportunity_Finance__c fin = new Opportunity_Finance__c();
            fin.Opportunity__c = opp1.id;                
            insert fin;
            
            Finance_Transactions__c fts=new Finance_Transactions__c();
            fts.Finance__c=fin.id;
            insert fts;
            
            Fin_Statement_3page_ctrlr controller = new Fin_Statement_3page_ctrlr();              
            Apexpages.currentPage().getparameters().put('contactid',c1.id);       
     
            controller = new Fin_Statement_3page_ctrlr();           
            controller.currencyConvert(100,'USD',Date.today());
            controller.getInstallmentPlan();
            controller.getfTransactionList();
            controller.isSubmit();
            controller.PayToStudy1();
            controller.PayToStudy2();
            controller.setnumber('9');
            ApexPages.currentPage().getParameters().put('payid',null);
            ApexPages.currentPage().getParameters().put('ins','1');
            double paytostudyAmount=0;
            controller.getDatePrinted(); 
            controller.getpaytoStudyURL();
            Test.stopTest();
            Program__c pro1=new Program__c(name='MIB-UK-London');
            insert pro1;
            opp1.Program__c=pro1.id;
            update opp1;
            controller = new Fin_Statement_3page_ctrlr(); 
     
     }
     //test method for BBA Finance PDF buttons
     static testMethod void Fin_Statement_bba_ctrlr_test(){  
        // insert program
        Program__c pro=new Program__c(name='Bachelor of Business Administration-UK-London');
        insert pro;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
         // insert contact for CPM user
        Contact C1 = new Contact(FirstName = 'Test', LastName = 'User', 
        email = 'test-user@fakeemail.com' );
        c1.Salutation='Mr';
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
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';
        opp1.Contact__c = C1.Id;
        opp1.StageName ='Confirmed';
        opp1.CloseDate = Date.today();
        opp1.Program__c=pro.id;                
        opp1.Attachments_Tab_Complete__c=false;
        opp1.Confirmation_Deadline__c = Date.today();
        insert opp1;
        
        Opportunity_Finance__c fin = new Opportunity_Finance__c();
        fin.Opportunity__c = opp1.id;
        fin.BBA_Unlock_Student_Financial_Information__c='Year1;Year2;Year3;Year4;Year5;';
        insert fin;
        
        Finance_Transactions__c fts=new Finance_Transactions__c();
        fts.Finance__c=fin.id;
        fts.Transaction_Type__c='Year 1;Year 2;Year 3;Year 4;Year 5;';
        fts.Transaction_Status__c='Success';
        insert fts;
        test.startTest();
        Apexpages.currentPage().getparameters().put('buttn','bba_yr1');
        Apexpages.currentPage().getparameters().put('contactid',c1.id);
        Fin_Statement_bba_ctrlr fincntlr = new Fin_Statement_bba_ctrlr();
        fincntlr.currencyConvert(100,'USD',Date.today());
        fincntlr.getfTransactionList();
        double paytostudyAmount=0;
        fincntlr.getDatePrinted();
        
        Test.stopTest();
        //Apexpages.currentPage().getparameters().put('buttn_name','bba_yr2');
        Apexpages.currentPage().getparameters().put('buttn','bba_yr2');
        fincntlr = new Fin_Statement_bba_ctrlr(); 
        
        Apexpages.currentPage().getparameters().put('buttn','bba_yr3');
        fincntlr = new Fin_Statement_bba_ctrlr(); 
        
        Apexpages.currentPage().getparameters().put('buttn','bba_yr4');
        fincntlr = new Fin_Statement_bba_ctrlr(); 
        
        Apexpages.currentPage().getparameters().put('buttn','bba_yr5');
        fincntlr = new Fin_Statement_bba_ctrlr(); 
     
     }
}