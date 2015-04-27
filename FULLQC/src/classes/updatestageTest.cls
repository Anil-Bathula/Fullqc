@isTest
public class updatestageTest{
    public static testMethod void test() {   
        Contact contact = new Contact();
        contact.FirstName='FirstName';
        contact.Start_Term__c = 'Jan 2011';
        contact.LastName = 'LastName';
        //contact.OwnerId = userList[0].Id;
        insert contact;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Contact__c = contact.Id;
        opportunity.Name = 'OpportunityName';
        opportunity.StageName = 'StageName';
        opportunity.CloseDate = Date.today();
        //opportunity.OwnerId = userList[0].Id;
        insert opportunity;
        
        opportunity.StageName = 'modifiedStageName';
        update opportunity;
        
        contact.Stage__c=opportunity.StageName;
        update contact;
    }
}