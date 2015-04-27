/*
    Developer    : Harsha Simha
    Date         : 7/17/2014
    Purpose      : Test Class
    Method       : Ext_acc_triggers_test
                        ext_acc_triggers.trg(100%)
                        workflow2trigger.trg(33%) [Tests only opp N ctct rec. Type match for ext. housing customers.]
                    
*/
@isTest
private class Test_Ext_Housing 
{
    static testMethod void Ext_acc_triggers_test() 
    {
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
        // insert program
        Program__c pro=new Program__c(name='Accommodation-UK-London');
        insert pro;
        
        // insert contact for CPM user
        Contact C1 = new Contact( FirstName = 'Test', LastName = 'ext_User', 
        email = 'test-user@fakeemail.com',Country_Of_Residence__c = country.Id, MobilePhone='9999999999');
        c1.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact', 'Housing External Customer');
        insert C1;  
        
         Opportunity opp = new Opportunity();
         opp.Name = 'Test Opportunity';
         opp.Contact__c = c1.Id;
         opp.StageName ='Accommodation Chosen';
         opp.CloseDate = Date.today().addYears(10);
         opp.RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity', 'Housing External Opportunity');
         opp.Program__c=pro.id;
         insert opp;
    }
}