/* 
 Created by   :Anil.B 
 Test class for UpdatePrimarycampus Trigger*/
@IsTest
public class UpdatePrimarycampus_Test {
    static testmethod void methodname(){
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        objcon.Applicant_Email__c='test@test1234email.com';
        insert objCon;
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName';
        opp.StageName = 'Confirmed';
        opp.Contact__c=objCon.id;
        opp.CloseDate = System.today();
        opp.Primary_Campus__c='London';
        insert opp;
      
   }
   }