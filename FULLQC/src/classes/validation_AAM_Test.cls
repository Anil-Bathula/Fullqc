@isTest
public class  validation_AAM_Test{
    public static testmethod void methodname(){ 
      
        Program__c prog=new Program__c();
        prog.Name='un-decided';
        insert prog;
        
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.StageName='Accepted';
        op.program__c=prog.id;
        op.CloseDate=System.today();
        op.Undergrad_Validated_GPA__c=2;
        insert op; 
        
        Education__c e=New Education__c();        
        e.Application__c=op.id;
        e.Highest_Degree_Attained__c='Bachelor\'s Degree';
        e.AAM_Validated__c=True;
        e.Application__c=op.id;
        e.Converted_GPA__c=1;
        try{
        insert e;       
        }catch (DmlException ex) {
        system.debug(ex);
        } 
        
        Education__c es=New Education__c();        
        es.Application__c=op.id;
        es.Highest_Degree_Attained__c='Bachelor\'s Degree';
        es.AAM_Validated__c=True;
        es.Application__c=op.id;
        es.Converted_GPA__c=1;
        try{
        insert es;       
        }catch (DmlException ex) {
        system.debug(ex);
        } 
             
        
        
        /*test scenario for the  Exam object Validations. By SHS*/
        Exam__c ex=new Exam__c();        
        ex.Exam_Type__c='Apply for test waiver';
        ex.Application__c=op.Id;
        ex.AAM_Validated__c=true;
        //scenario 1 : insert exam with examtype= 'Apply for test waiver' or 'no test required' o/p:error
        try{insert ex;}catch(Exception exc){system.debug(exc);}
        //scenario 2 :insert exam with examtype= GRE o/p inserted
        ex.Exam_Type__c='GRE';
        try{insert ex;}catch(Exception exc){system.debug(exc);}        
        
        Exam__c ex1=new Exam__c();        
        ex1.Exam_Type__c='TOEFL';
        ex1.Application__c=op.Id;
        ex1.AAM_Validated__c=false;
        //scenario 3 : Normal insert and no error.
        try{insert ex1;}catch(Exception exc){system.debug(exc);}
        ex1.AAM_Validated__c=true;
         //scenario 4 : insert exam with examtype= TOEFL o/p inserted
        try{update ex1;}catch(Exception exc){system.debug(exc);}
        ex1.AAM_validated__c=false;     
        try{update ex1;}catch(Exception exc){system.debug(exc);}
        
        
        /*test scenario for the  Employment trigger :: Calculate_Experience . By SHS*/
        Employment__C emp=new Employment__c();
        emp.Application__c=op.id;
        emp.DateFrom__c=system.today().addYears(-1);
        emp.DateTo__c=system.Today();
        insert emp;
    }
}