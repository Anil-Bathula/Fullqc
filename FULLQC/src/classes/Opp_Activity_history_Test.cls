/*
Author          : Premanath Reddy   
Purpouse        : Test class for Opp_Activity_history Trigger and OPP_ActivityHistory class.
*/
@isTest
Private class Opp_Activity_history_Test{
    public static testmethod void methodname(){
    
        Program__c objPgm = new Program__c(Name = 'Bachelor of Business Administration-UK-London',Campus__c='London');
        insert objPgm;
        
        String recdtypeid=RecordTypeHelper.getRecordTypeId('Opportunity','Accepted & R');
        String tsk_interrt=RecordTypeHelper.getRecordTypeId('Task','Interview');
        String tsk_brort=RecordTypeHelper.getRecordTypeId('Task','Brochure Request');
        String tsk_confrt=RecordTypeHelper.getRecordTypeId('Task','Confirmation');
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName';
        opp.StageName = 'Accepted';
        opp.CloseDate = System.today();
        opp.Primary_Campus__c='London';
        opp.Program__c =objPgm.Id;
        opp.recordtypeid=recdtypeid;
        opp.Visa_Related_Sub_Stages__c='5a. Visa Approved';
        insert opp;
        
        Task testTask = new Task(Subject='AD Email First Mailing General question email',Whatid=opp.id,Description='Body:test',status='Completed',RecordTypeid=tsk_interrt);              
        insert testTask;
        
        Event e2=new Event();
        e2.Whatid=opp.id;
        e2.Subject='meeting';
        datetime myDateTime2 = System.now().addDays(2);
        e2.StartDateTime=myDateTime2;
        e2.EndDateTime=myDateTime2.addHours(30);
        e2.Event_RequiredField__c=true;
        insert e2;
        
        opp.StageName = 'Confirmed';
        opp.Visa_Related_Sub_Stages__c='7c. Arrived according to recruiting';
        Test.startTest();
        update opp;
        Test.stopTest();
        
        Apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OPP_ActivityHistory oppact= new OPP_ActivityHistory(sc);
        oppact.currentTab='name1';
        oppact.Data();
        oppact.pagerd();
        oppact.Del();
        oppact.sub();
        
        testTask.RecordTypeid=tsk_brort;
        update testTask;
        oppact= new OPP_ActivityHistory(sc);
        oppact.currentTab='name2';
        oppact.Data();
        
        oppact= new OPP_ActivityHistory(sc);
        oppact.currentTab='name3';
        oppact.Data();
        
        testTask.RecordTypeid=tsk_confrt;
        update testTask;
        oppact= new OPP_ActivityHistory(sc);
        oppact.currentTab='name4';
        oppact.Data();
        
    }
}