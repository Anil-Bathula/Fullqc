@isTest(SeeAllData=true)
    private class UpdateChildTest_TestClass {
        
        public static final Program__c program1 = [select Id from Program__c limit 1]; 
        
        public static testMethod void updateChildTest() {  
    
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        contact.Start_Term__c = 'Jan 2011';
        contact.LastName = 'LastName';
        contact.Program_Primary__c = program1.Id;
        insert contact;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Contact__c = contact.Id;
        opportunity.Name = 'OpportunityName';
        opportunity.StageName = 'StageName';
        opportunity.CloseDate = Date.today();
        opportunity.Program__c = program1.Id;
        insert opportunity;
                
        Exam__c exam = New Exam__c();
        exam.Application__c = opportunity.id;
        insert exam;
        
        opportunity.StageName ='Admissions Endorsed';
        
        update opportunity;
        }
    }