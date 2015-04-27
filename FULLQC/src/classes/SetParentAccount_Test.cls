/*********************************
Class Name:SetparentAccount_Test
Trigger :SetparentAccount
**********************************/


@isTest
public class SetParentAccount_Test{
    public static testmethod void methodname(){    
       
        Contact ct = new Contact();       
        ct.LastName = 'LastName';  
        ct.RecordtypeId=RecordTypeHelper.getRecordTypeId('Contact','Parent');              
        insert ct;     
     }
  }