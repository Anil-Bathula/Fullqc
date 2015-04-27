/****************
Class Name:HMAT_validation_Test
Test Class for: HMAT_validation.trigger
Code coverage:90%
Developer :Anil.B
****************/


@isTest
public class  HMAT_validation_Test{
    public static testmethod void methodname(){ 
      
        Program__c prog=new Program__c();
        prog.Name='un-decided';
        insert prog;
        
        Opportunity op=new opportunity();
        op.Name='firstname1';
        op.StageName='Accepted';
        op.program__c=prog.id;
        op.CloseDate=System.today();       
        insert op; 
        
        Exam__c e=New Exam__c();        
        e.Application__c=op.id;
        e.Exam_Type__c='HMAT';
        try{
        insert e;       
        }catch (DmlException ex) {
        system.debug(ex);
        } 
        
        Exam__c e1=New Exam__c();        
        e1.Application__c=op.id;
        e1.Exam_Type__c='HMAT';
        try{
        insert e1;       
        }catch (DmlException ex) {
        system.debug(ex);
        } 
        
     }
   }