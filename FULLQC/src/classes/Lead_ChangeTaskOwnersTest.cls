/*
    Test Class: Lead_ChangeTaskOwnersTest
    
    Coverage  : Contact_Update_LeadSource_Category(75%)
          
    Changes   : Harsha 10/30/'14
          Lead_Update_LeadSource_Category(75%) 
            
*/
@IsTest
private class Lead_ChangeTaskOwnersTest {
    public static User[] userList = [
        select Id 
          from User 
         where IsActive = true
           and Id != :UserInfo.getUserId()
           and ProfileId = :UserInfo.getProfileId()
         limit 3
    ];
    
    @IsTest
    public static void test() {
        Country__c country = [select Id from Country__c limit 1];
        Program__c program = [select Id from Program__c limit 1];
        
        Lead lead = new Lead();
        lead.FirstName = 'FirstName';
        lead.LastName = 'LastName';
        lead.Company = 'Company';
        lead.LeadSource = 'Undecided';
        lead.Email = 'cccded1d8f725170a1aad6a8147af7a8@example.com';
        lead.Applicant_Email__c = 'cccded1d8f725170a1aad6a8147af7a8@example.com'; // Added by Mahesh G, 3/12
        lead.Do_Not_Route__c = true;
        lead.Program_Primary__c = program.Id;
        lead.Country_of_Residence__c = country.Id;
        insert lead;
        
         set<string> tsk_rectypes=new set<String>{'eBrochure Request','Brochure Request','Contact Us','Event Signup','GMAT Test','SAT Test'};
          
        List<RecordType> lsttsk_rectyps=[select id,Name,sobjectType from RecordType where sobjectType='task' and Name IN:tsk_rectypes];
        
        Lead_Source_Category__c lsc=new Lead_Source_Category__c();
        lsc.Name='Internet';
        insert lsc;
        
        List<Lead_Source__c> lscat=new List<Lead_Source__c>();
        Lead_Source__c ls=new Lead_Source__c();
        ls.Name='web';     
        ls.Lead_Source_Category__c=lsc.Id;
        
        Lead_Source__c ls1=new Lead_Source__c();
        ls1.Name='unknown';
        
        
        lscat.add(ls);
        lscat.add(ls1);
        insert lscat;
        
        lead.LeadSource='web';
        update lead;
        
        string rtpe=RecordTypeHelper.getRecordTypeId('Contact','Applicant');
       //List<Lead_Source__c> lscat=[select id,Name,Weighting__c,Lead_Source_Category__r.Name from Lead_Source__c where Name!=null limit 5];
        Contact ctct = new Contact();
        ctct.FirstName = 'FirstName';
        ctct.LastName = 'LastName';
        //ctct.Company = 'Company';
        ctct.LeadSource = 'web';
        ctct.Email = 'cccded1d8f725170a1aad6a8147af7a8@example.com';
        ctct.Applicant_Email__c = 'cccded1d8f725170a1aad6a8147af7a8@example.com'; // Added by Mahesh G, 3/12
        ctct.Do_Not_Route__c = true;
        ctct.Program_Primary__c = program.Id;
        ctct.Country_of_Residence__c = country.Id;
        if(rtpe!=null)
            ctct.RecordTypeId =rtpe;     
        insert ctct;
        
        Task[] taskList = new Task[] {
            new Task(WhoId = lead.Id, OwnerId = UserInfo.getUserId(),subject='Email:asd'),
            new Task(WhoId = ctct.Id, OwnerId = UserInfo.getUserId(),RecordTypeId=lsttsk_rectyps[0].Id,subject='eBrochure Request'),
            new Task(WhoId = lead.Id, OwnerId = UserInfo.getUserId(),RecordTypeId=lsttsk_rectyps[2].Id,subject='Email verified: by me')
        };
        
        insert taskList;
   
        for(Task task : [
            select OwnerId
              from Task
             where Id in :taskList
        ]) system.assertEquals(UserInfo.getUserId(), task.OwnerId);
        
        system.assert(UserInfo.getUserId() != userList[0].Id);
        system.assertEquals(UserInfo.getUserId(), [
            select OwnerId
              from Lead
             where Id = :lead.Id
        ].OwnerId);
        
        system.debug('*** lead update: START');
        lead.OwnerId = userList[0].Id;
        update lead;
        system.debug('*** lead update: END');
        
        system.assertEquals(userList[0].Id, [
            select OwnerId
              from Lead
             where Id = :lead.Id
        ].OwnerId);
        
        for(Task task : [
            select OwnerId
              from Task
             where Id in :taskList and Whoid=:lead.Id
        ]) system.assertEquals(userList[0].Id, task.OwnerId);
        
        
        taskList[0].RecordTypeId= lsttsk_rectyps[3].Id;
        taskList[0].subject='eBrochure Request';
        taskList[1].RecordTypeId= lsttsk_rectyps[4].Id;
        taskList[0].subject='Email:as';
        taskList[2].RecordTypeId= lsttsk_rectyps[1].Id;
        taskList[0].subject='Email Viewed:sa';      
        update taskList;   
        delete taskList[1];
        ctct.Lead_Source_Category__c=null;
        ctct.LeadSource='unknown';
        update ctct;
        
        ctct.Lead_Source_Category__c=null;
        ctct.LeadSource='asdfsdother';
        update ctct;
        
    }
}