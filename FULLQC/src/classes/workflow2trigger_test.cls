@isTest
    private class workflow2trigger_test{

        
        
        public static testMethod void workflow2trigger() {
        
       
        Program__c objPgm = new Program__c(Name = 'Bachelor of Business Administration-UK-London',Campus__c='London');
        insert objPgm;
        
        String recdtypeid=RecordTypeHelper.getRecordTypeId('Opportunity','Accepted & R');
    
        Contact contact = new Contact();
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        objcon.Applicant_Email__c='test@test1234email.com';
        objcon.Program_Primary__c=objPgm.Id;
        insert objCon;      
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName';
        opp.StageName = 'Confirmed';
        opp.Contact__c=objCon.id;
        opp.CloseDate = System.today();
        opp.Primary_Campus__c='London';
        opp.Program__c =objPgm.Id;
        opp.recordtypeid=recdtypeid;
        insert opp;
       
        
        
        opp.Confirmation_Activity__c='LDN Accommodation booking form for Confirmed';
        opp.Accommodation_Student_Status__c='Hult Prospective Student';        
        update opp;
        
        Test.Starttest();
        opp.StageName = 'Partial Application';
        opp.Application_Substage__c='Completed Application';
        update opp;
        
       /* opp.StageName='Qualified Lead';
        opp.Program_and_Location_Tab_Complete__c=True;        
        update opp;
        
        opp.StageName='Conditionally Accepted';
        Opp.Application_Substage__c='Notified';
        Update opp;
        
        opp.StageName='Waitlisted Confirmed';
        update opp;*/    
        
        
        test.stopTest();
        
        }
    }