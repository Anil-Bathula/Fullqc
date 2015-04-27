@isTest(SeeAllData=true)
    private class UpdateInstallmentPlan_TestClass {

        public static final Program__c program1 = [select Id from Program__c limit 1]; 
        
        public static testMethod void validate_UpdateInstallmentPlan() {
    
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
        
        Opportunity_Finance__c fin = new Opportunity_Finance__c();
        fin.Opportunity__c = opportunity.id;                
        insert fin;
        
        opportunity.StageName ='Admissions Endorsed';
        
        update opportunity;
        
        update fin;
        }
    }