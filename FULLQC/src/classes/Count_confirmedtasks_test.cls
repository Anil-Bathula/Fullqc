/***************************************************************************************
Class Name      : Count_confirmedtasks_test
Trigger Name    : Count_confirmedtasks
Author          : Anil.B
Usage           : This test class is for Count_confirmedtasks trigger.  
Code Coverage   : 95% 
****************************************************************************************/

@isTest 
private class Count_confirmedtasks_test  { 

  static testMethod void Count_confirmedtasks()  {   
    
    String rectyp=RecordTypeHelper.getRecordTypeId('Task','Confirmation');
    String p=RecordTypeHelper.getprofileid('System Administrator');
    User usr = new User(alias = 'standt1', email = 'test@98761test.com', 
                                  emailencodingkey = 'UTF-8', lastname = 'TestLasName1', languagelocalekey = 'en_US', 
                                  localesidkey = 'en_US',
                                  timezonesidkey = 'America/Los_Angeles', Profileid=p, username = 'testUniqudeName1@test.com');
                                  insert usr;       
              
        Contact Con = new contact(LastName='Testing11',FirstName='Apex1'); 
        insert con; 
        
        Opportunity opp= new Opportunity();
        opp.Contact__c = con.Id;
        opp.Name='OpportunityName';
        opp.StageName = 'In Progress';       
        opp.CloseDate = System.today();       
        insert opp;
        
        Task testTask = new Task(Subject='AD First Mailing General question +email',Whatid=opp.id,Ownerid=usr.id,recordtypeid=rectyp);              
        insert testTask; 
        delete testTask; 
  } 
 }