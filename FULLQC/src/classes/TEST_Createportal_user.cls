/*
	Developer	: Harsha Simha
	Date	 	: 9/10/2014
	Purpose		: Test class for	
					create_Portaluser_onMatriculated.trg(75%)
					create_portaluser_onmatriculated.cls(79%)
*/
@isTest
private class TEST_Createportal_user {

    static testMethod void CreatePortaluser() {
      
        Program__c pro=new Program__c(name='MBA-US-Boston');
        insert pro;
        
        // insert account
        Account A1 = new Account(Name = pro.name);
        insert A1;
        
        //insert country
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
        // insert contact for CPM user
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', 
        email = 'test-user'+System.now().day()+''+System.now().hour()+''+System.now().minute()+''+System.now().second()+'@student.hult.edu' );
        c1.Firstname = 'Testy name';
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
       // c1.Program_Parsed__c='MBA';
        insert C1;
              
        // insert opportunity
           Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Contact__c = c1.Id;
            opp.StageName ='Accepted';
            opp.CloseDate = Date.today();
            opp.Program__c=pro.id;
            opp.Primary_Program_Choice__c = 'Master of Business Administration';
            insert opp;
    	  Test.StartTest();  
        		opp.Matriculated__c=true;
         	update opp;
         	List<string> Contactids=new list<String>{c1.Id};
         	create_portaluser_onmatriculated.create_portaluser(Contactids);
          Test.stopTest();			
    }
}