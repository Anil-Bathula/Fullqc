/*
Author          : Premanath Reddy   
Purpouse        : Test class for AdmissionsEndorsedConfirmed_validation Trigger.
                  And updatestage Trigger
                  And Opp_Activity_history Trigger.
Modified By     : Anil.B 19/11/2013---JIRA No:SFSUP-672 in line 70,82.
                  
*/
@isTest
private class AdmissionsEndorsedConf_Test{
    static testmethod void methodname(){
        Opportunity opp= new Opportunity();
        //opp.Contact__c = contact.Id;
        opp.Name='OpportunityName';
        opp.StageName = 'Admissions Endorsed Confirmed';
        opp.Application_Substage__c='AEC Quality - Low - Missing test date/proof of test';
        opp.Test_date_proof_of_test_not_submitted__c=false;
        opp.Accepted_Date__c=System.Today()+5;
        opp.CloseDate = System.today();
        insert opp;
            
        Exam__c ex=new Exam__c();    
        ex.Application__c=opp.id;
        ex.Planned_Test_Date__c=System.Today();
        insert ex;
        
        //opp.StageName ='Admissions Endorsed Confirmed';
        //update opp;
        
        try{System.debug('************'+opp.Visa_Related_Sub_Stages__c);
            opp.Application_Substage__c='AEC Quality - Low';
            opp.Visa_Related_Sub_Stages__c='2. Visa Docs with Student Services';
            update opp;
            //System.Debug('************************test class1234****');
            System.debug('************'+opp.Visa_Related_Sub_Stages__c);
        }
        catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('A Planned Test Date must be entered in the relevant field under Exams before you can change the sub-stage from AEC – Quality – Low –missing test date/proof of test') ? true : false;
             system.assertEquals(expectedExceptionThrown,true);       
        }
        Contact contact = new Contact();
        contact.FirstName='FirstName';
        contact.Start_Term__c = 'Jan 2011';
        contact.LastName = 'LastName';
        contact.Applicant_Email__c='test123@test9.com';
        insert contact;
        
        Opportunity opp1= new Opportunity();
        //opp1.Contact__c = contact.Id;
        opp1.Name='OpportunityName';
        opp1.StageName = 'Admissions Endorsed';
        opp1.Application_Substage__c='sub stage';
        opp1.Test_date_proof_of_test_not_submitted__c=false;
        opp1.Accepted_Date__c=System.Today()+3;
        opp1.CloseDate = System.today();
        insert opp1;
        
        Exam__c ex1=new Exam__c();    
        ex1.Application__c=opp1.id;
        ex1.Planned_Test_Date__c=System.Today()-1;
        insert ex1;
        
        opp1.StageName='Admissions Endorsed Confirmed';
        update opp1;
        opportunity oppquery=[select id,Application_Substage__c,Test_date_proof_of_test_not_submitted__c from Opportunity where id=:opp1.Id];
        //System.Debug([select id,Application_Substage__c from Opportunity where id=:opp1.Id]+'************************test class****'+oppquery);
        system.assertEquals(oppquery.Application_Substage__c,'AEC Quality - Low - Missing test date/proof of test');
        system.assertEquals(oppquery.Test_date_proof_of_test_not_submitted__c,True);
        test.startTest();
        Opportunity opp2= new Opportunity();
        opp2.Name='OpportunityName';
        opp2.StageName = 'Conditionally Accepted';
        opp2.Application_Substage__c='sub stage';
        opp2.Test_date_proof_of_test_not_submitted__c=false;
        opp2.Accepted_Date__c=System.Today()+1;
        opp2.CloseDate = System.today();
        insert opp2;
        
        Exam__c ex2=new Exam__c();    
        ex2.Application__c=opp2.id;
        ex2.Planned_Test_Date__c=System.Today()+5;
        insert ex2;
        test.stopTest();
        opp2.StageName='Conditionally Confirmed';
       // update opp2;
        
        opportunity oppquery1=[select id,Application_Substage__c,Product_Head_interview_has_not_happened__c from Opportunity where id=:opp2.Id];
       // system.assertEquals(oppquery1.Application_Substage__c,'AEC Quality - Low');
       // system.assertEquals(oppquery1.Product_Head_interview_has_not_happened__c,True);
    
    }
}