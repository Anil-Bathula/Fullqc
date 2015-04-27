@IsTest 
public class AAM_Team_Memeber_Test {
  
   
  
      public static testmethod void Test1() {
          
        List<user> user1=[select id from user where AAM__c=True limit 1];
        if(!user1.IsEmpty()){
        
        Program__c pr=new program__c();
        pr.Name='EMBA-UK-London';
        insert pr;
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName12';
        contact.Start_Term__c = 'September 2014';
        contact.LastName = 'LastName12';
        contact.Program_Primary__c = pr.Id;
        insert contact;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Contact__c = contact.Id;
        opportunity.Name = 'OpportunityName12';
        opportunity.StageName = 'StageName';
        opportunity.CloseDate = Date.today();
        opportunity.Program__c = pr.Id;
        insert opportunity;
        
        opportunity.StageName = 'Accepted';
        opportunity.AAM_Team_Member__c=user1[0].id;
        update opportunity;
       }
        
     }



}