@isTest
//For Hult Project, to integrate with TimeTrade : 082013
private class TestAssessment_replicate{
    static testMethod void testAssestmentReplicat(){ 
  
        //get the initial details
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        RecordType rectype = [SELECT Id,Name FROM RecordType WHERE Name = 'Appointment'];  
        RecordType stdType = [SELECT Id,Name FROM RecordType WHERE Name = 'Applicant'];
 
        //creating RunAs User Record
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'user';
        u.Email = 'testuser@test123456789.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test user';
        u.Username = 'testuser@test123456789.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        insert u;

        system.runAs(u){

            // Creating Advisor User Record
            User a = new User();
            a.FirstName = 'Test';
            a.LastName = 'Advisor';
            a.Email = 'testAdvisor@test123456789.com';
            a.CompanyName = 'test.com';
            a.Title = 'Test Advisor';
            a.Username = 'testAdvisor@test123456789.com';
            a.Alias = 'testuser';
            a.CommunityNickname = 'Test Advisor';
            a.TimeZoneSidKey = 'America/Chicago';
            a.LocaleSidKey = 'en_US';
            a.EmailEncodingKey = 'ISO-8859-1';
            a.ProfileId = pf.Id;
            a.LanguageLocaleKey = 'en_US';
            insert a;    
            
            // Creating Student Record
            
            Contact s = new Contact();
            s.FirstName = 'Test';
            s.LastName = 'Advisor';
            s.Email = 'teststudent@test123456789.com';
            s.RecordTypeId = stdType.Id;
            insert s; 
    
            // Set up the Assessment_un__c record for new Appoinment.
            Assessment_un__c  assmnt_un = new Assessment_un__c (User_Email__c ='testAdvisor@test123456789.com', Contact_Id_Text__c = s.Id, Appointment_Type__c='Career Strategy', TimeTrade_Event_ID__c ='test123',TT_Event_Type__c='appointmentBooked');
            insert assmnt_un;

            // Verify that the initial state is as expected.
            assmnt_un = [SELECT Campus__c,Appointment_Type__c,Id,TimeTrade_Event_ID__c,TT_Event_Type__c FROM Assessment_un__c
                WHERE Id = :assmnt_un.Id];
            System.assertEquals(null, assmnt_un.Campus__c);
            System.assertEquals('Career Strategy', assmnt_un.Appointment_Type__c);

            // Verify that the results are as expected after the insert trgger fires off.
            ts2__Assessment__c assmnt = [SELECT RecordTypeId, Appointment_Type__c,Campus__c,Id,TimeTrade_Event_ID__c FROM ts2__Assessment__c 
                WHERE TimeTrade_Event_ID__c = :assmnt_un.TimeTrade_Event_ID__c];
            System.assertEquals(assmnt_un.Campus__c, assmnt.Campus__c);
            System.assertEquals(assmnt_un.Appointment_Type__c, assmnt.Appointment_Type__c);
            System.assertEquals(rectype.Id, assmnt.RecordTypeId);
            
           
           // update Appoinment
           Assessment_un__c  assmnt_un1 = [SELECT Processed__c , TT_Event_Type__c, Appointment_Type__c,TimeTrade_Event_ID__c ,Id FROM Assessment_un__c  WHERE Id = :assmnt_un.Id];
           assmnt_un1.TT_Event_Type__c='appointmentChanged';
           assmnt_un1.Appointment_Type__c= 'Resume Help';
           assmnt_un1.Processed__c = false;
           
            Update assmnt_un1;
            
            // Verify that the results are as expected after the update trgger fires off.
            ts2__Assessment__c assmntUpd = [SELECT RecordTypeId, Appointment_Type__c,Campus__c,Id,TimeTrade_Event_ID__c FROM ts2__Assessment__c 
                WHERE TimeTrade_Event_ID__c = :assmnt_un1.TimeTrade_Event_ID__c];
            System.assertEquals(assmnt_un1.Campus__c, assmntUpd.Campus__c);
            System.assertEquals(assmnt_un1.Appointment_Type__c, assmntUpd.Appointment_Type__c);
          //  System.assertEquals(rectype.Id, assmntUpd.RecordTypeId);
        }
    }
}