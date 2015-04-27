@isTest(SeeAllData=true)
private class Test_Update_lead_stage {

    static testMethod void myUnitTest() {
         Country__c country1 = new Country__c();
         country1.Name='India';
         country1.Calling_Code__c=91;
         insert country1;
         
        Program__c pro =new Program__c();
        pro.name='MBA';
        insert pro;
        Test.StartTest();
        Lead l=new Lead();
        l.FirstName='Harsha';
        l.LastName='Simha';
        l.email='harsha.09364as@ef.com';
        l.Status='Open';
        l.Applicant_Email__c='harsha.09364as@ef.com';
        l.Company='Hult';
        l.Country_Of_Residence__c = country1.Id; //Added by Mahesh G
        l.LeadSource = 'GMASS';//Added by Mahesh G
        l.Program_Primary__c = pro.id;
        l.HasOptedOutOfEmail=false;
        insert l;
        System.Debug('============='+l.Applicant_Email__c);
        list<user> u=new list<user>();
        u=[select id,Name,username from User limit 20];
        Task t=new Task();
        t.Status='Completed'; 
        t.Five9__Five9SessionId__c='test';
        t.Five9__Five9CallType__c='Outbound';
        t.WhoId=l.id;
        t.CallDisposition='Not Reached';
        if(!u.Isempty()){
            for(user us:u){
                string usn=us.Username;
                if(usn.length()<50){
                t.Five9__Five9Agent__c=usn;
                system.debug('--------------'+usn);
                break;
                }               
            }
        }system.debug('++++++'+t);
        insert t;
        
        t.Status='Inprogress';
        update t;
        
        t.Status='Completed';
        update t;
        
        Account A1 =TestDataUtil.createAccount(pro.Name, 'Candidate');// new Account(Name = pro.name);//,ownerid=userAccount.id);
        insert A1;
                
        Contact contact = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User', email = 'test-user@fakeemail.com');
        contact.Firstname = 'Test name';
        contact.Gender__c = 'Male';
        contact.Country_Of_Citizenship__c = country1.Id;
        contact.Country_Of_Origin__c = country1.Id;
        contact.Country_Of_Residence__c = country1.Id;
        contact.Birthdate = Date.today();
        contact.LeadSource = 'Alumni';
        contact.mailingstreet = 'test';
        contact.mailingcity = 'New York';
        contact.mailingstate = 'Test';
        contact.mailingpostalcode = '1W2E4R';
        contact.Home_Phone_Country_Code__c = '011';
        contact.Home_Phone_Area_Code__c = '292';
        contact.Home_Phone_Main_Number__c = '2153648';
        contact.Language__c = 'English';
        contact.Language_English_Speaking__c = 'Fluently';
        contact.Language_English_Listening__c = 'Fluently';
        contact.Language_English_Writing__c = 'Fluently';
        contact.Language_English_Reading__c = 'Fluently';
        insert contact;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity';
        opp1.Contact__c = contact.id;
        opp1.StageName ='Accepted';
        opp1.CloseDate = Date.today();
        opp1.Primary_Program_Choice__c = 'Bachelor of Business Administration';
        opp1.Secondary_Program_Choice__c = 'Bachelor of Business Administration';
        opp1.Primary_Campus__c = 'Boston';
        opp1.Secondary_Campus__c = 'Boston';
        opp1.Start_Term__c= 'September 2011';
        opp1.Global_Campus_Rotation_Program__c = false;
        insert opp1;
        Test.StopTest();
        t.Status='Inprogress';
        update t;
        
        t.Status='Completed';
        t.WhoId=contact.Id;
        t.WhatId=opp1.Id;
        update t;
        
        task t1=new task();
        t1.Status='Completed'; 
        t1.Five9__Five9SessionId__c='test';
        t1.Five9__Five9CallType__c='Outbound';
        t1.WhoId=t.WhoId;
        t1.WhatId=t.WhatId;
        t1.CallDisposition='Not Reached';
        t1.Five9__Five9Agent__c=t.Five9__Five9Agent__c;
        insert t1;
    }
}