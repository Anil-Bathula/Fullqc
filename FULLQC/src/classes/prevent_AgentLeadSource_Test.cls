/*
Author    :- Premanath Reddy
Date      :- 12/14/2012
Usage     :- Test class for prevent_AgentLeadSource Trigger
Modified Prem : SFSUP-767
*/
@isTest
private class prevent_AgentLeadSource_Test{
    static testmethod void methodname(){
        //Profile p = [select id from profile where name='Sales-Recruiter and Converter'];
        String p = RecordTypeHelper.getprofileid('Sales-Recruiter and Converter');
        User u = new User(alias = 'standt', email='standarduser2134@testorg.com', 
        lastname='Testing', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p,TimeZoneSidKey='America/Los_Angeles',
        username='standarduser2134@testorg.com');
        
        System.runAs(u) {
            Contact contact = new Contact(FirstName='FirstName',LastName = 'LastName',Applicant_Email__c='test123@test129.com',Email='test123@test129.com');
            Contact contact2 = new Contact(FirstName='FirstName',LastName = 'LastName',LeadSource='Agent',Applicant_Email__c='test123@test545.com',Email='test123@test545.com');
            List<Contact> con=New List<Contact>();
            con.add(contact);
            con.add(contact2);
            insert con;
            
            Opportunity opp= new Opportunity(Name='OpportunityName',Contact__c = contact.Id
                                            ,StageName = 'stage Name',CloseDate = System.today()
                                            ,Primary_Program_Choice__c='Bachelor of Business Administration');
           
            Opportunity opp2= new Opportunity(Name='OpportunityName',Contact__c = contact2.Id
                                            ,StageName = 'stage Name',CloseDate = System.today()
                                            ,Primary_Program_Choice__c='Bachelor of Business Administration');
            List<Opportunity> prb=New List<Opportunity>();
            prb.add(opp);
            prb.add(opp2);
            
            insert prb;
            try{
                contact.LeadSource='Agent';
                update contact;
            }
            catch(Exception e){
                 Boolean expectedExceptionThrown =  e.getMessage().contains('In order to select Agent as Lead Source you must contact your Regional or Global Head and confirm the relationship with the agent.') ? true : false;
                 system.assertEquals(expectedExceptionThrown,true);       
            }
            
            try{
                contact2.LeadSource='Website';
                update contact2;
            }
            catch(Exception e){
                 Boolean expectedExceptionThrown4 =  e.getMessage().contains('You cannot unselect Lead Source = Agent.  Please contact your Regional or Global Head.') ? true : false;
                 system.assertEquals(expectedExceptionThrown4,true);       
            }
        }
        //Profile p1 = [select id from profile where name='6. HULT Global and Regional Heads' or name='Sales-Global Product Head'];
        String p1 = RecordTypeHelper.getprofileid('Sales-Global Product Head');
        User u1 = new User(alias = 'tenttt', email='standardusertest@testorgtest.com', 
        lastname='orgtest', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1,TimeZoneSidKey='America/Los_Angeles',
        username='standardusertest@testorgtest.com');
        System.runAs(u1) {
        
            Contact contact1 = new Contact();
            contact1.FirstName='FirstName';
            contact1.LastName = 'LastName';
            contact1.Applicant_Email__c='test123@test13429.com';
            contact1.I_confirm_proof_of_Agent_relationship__c=false;
            contact1.Region__c='Africa';
            insert contact1;
            
            Opportunity opp1= new Opportunity();
            opp1.Contact__c = contact1.Id;
            opp1.Name='OpportunityName';
            opp1.StageName = 'stage Name';
            opp1.CloseDate = System.today();
            opp1.Primary_Program_Choice__c = 'Bachelor of Business Administration';
            insert opp1;
            
            try{
                contact1.LeadSource='Agent';
                contact1.Region__c='South Asia';
                update contact1;
            }
            catch(Exception e){
                 Boolean expectedExceptionThrown1 =  e.getMessage().contains('In order to select Agent as Lead Source you must contact your Regional or Global Head and confirm the relationship with the agent.') ? true : false;
                 system.assertEquals(expectedExceptionThrown1,true);       
            }
        }
    }
}