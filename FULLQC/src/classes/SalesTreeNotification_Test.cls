/*
  Test Class : salestreenotification_Test
  Trigger   : salestreenotification  
  Developer : Anil.B
  Date      : 29/5/2013
  
  Last Modified : Prem 29/10/2013  Replaced with RecordTypeHelper class instead of using the Query for Profile to get the user Profile Id.
*/


@isTest
public class SalesTreeNotification_Test{
    public static testmethod void methodname(){ 
    
      //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      String p=RecordTypeHelper.getprofileid('System Administrator');
      User u = new User(Alias = 'Test', Email='test@hult.edu', 
      EmailEncodingKey='UTF-8', LastName='Bathula_Test', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p, 
      TimeZoneSidKey='America/Los_Angeles', UserName='Test@ef.com.fullqc'); 
      Insert u;
      
        Sales_Tree__c s=new Sales_Tree__c();
        s.Name='Test';
        s.Reporting_To__c=u.id;
        s.Subordinate__c=u.id;
        insert s;
        System.assertEquals(s.Reporting_To__c, u.id);
      
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.ownerid=u.id;
        op.StageName='Accepted';
        op.CloseDate=System.today();        
        insert op; 
        
        op.StageName='Confirmed';
        Update op;
        
        op.Accommodation_Status__c='2b. Not Interested (Financial reasons)';
        op.Hult_Fin_Aid_Merit_of_Tuition__c=23;
        Update op;     
            
    }
}