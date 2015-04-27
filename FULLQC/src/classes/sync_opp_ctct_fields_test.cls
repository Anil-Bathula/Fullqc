@isTest
public with sharing class sync_opp_ctct_fields_test 
{
	public static testmethod void test() 
	{
		Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 = TestDataUtil.createAccount(pro.name, 'Candidate');//new Account(Name = pro.name);
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
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
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';
        opp1.Contact__c = C1.Id;
        opp1.StageName ='Accepted';
        opp1.CloseDate = Date.today();
        opp1.Program__c=pro.id;
        opp1.Attachments_Tab_Complete__c=false;
        opp1.Linked_In_Status_New__c='Connected';
        insert opp1;
	}
	
	public static testmethod void test1() 
	{
		Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 =TestDataUtil.createAccount(pro.Name, 'Candidate');// new Account(Name = pro.name);
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';        
        opp1.StageName ='Accepted';
        opp1.CloseDate = Date.today();
        opp1.Program__c=pro.id;
        opp1.Attachments_Tab_Complete__c=false;        
        insert opp1;
        
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
        c1.Linked_In_Status__c='Connected';
        insert C1;	
        
        
        
        opp1.Contact__c = C1.Id;
        //opp1.Linked_In_Status_New__c='Connected';
        update opp1;
        
        c1.Linked_In_Status__c='Mailed In';
        update c1;
        
       
	}
	
	public static testmethod void test2() 
	{
		Program__c pro=new Program__c(name='MIB-US-Boston');
        insert pro;
         // insert account
        Account A1 =TestDataUtil.createAccount(pro.Name, 'Candidate');// new Account(Name = pro.name);
        insert A1;
         //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';        
        opp1.StageName ='Accepted';
        opp1.CloseDate = Date.today();
        opp1.Program__c=pro.id;
        opp1.Attachments_Tab_Complete__c=false;        
        insert opp1;
        
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
        c1.Linked_In_Status__c='Connected';
        insert C1;	
        
        
        
        opp1.Contact__c = C1.Id;
        opp1.Linked_In_Status_New__c='Connected';
        update opp1;
             
       
	}
}