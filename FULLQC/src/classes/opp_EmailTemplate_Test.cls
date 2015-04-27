/*
Author    :- Premanath Reddy
Date      :- 1/30/2013
Usage     :- Test class for opp_EmailTemplate class
*/
@isTest
public class opp_EmailTemplate_Test {
    static testmethod void methodname(){
        
        Contact ct = new Contact();       
        ct.LastName = 'LastName';        
        insert ct;    
        
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.Contact__c=ct.id;
        op.StageName='Admissions Endorsed';
        op.CloseDate=System.today();
        op.Admission_Endorsed_reasons__c='Admission Endorsed';
        op.Primary_Campus__c='Boston';
        insert op;
        
        opportunity_Finance__c f=new Opportunity_finance__c();        
        f.Opportunity__c=op.id;
        f.CurrencyIsoCode='USD';
        insert f;
        
        Apexpages.Currentpage().getParameters().put('type','pdf');
        Apexpages.currentPage().getparameters().put('id',op.id);
        opp_EmailTemplate et=new opp_EmailTemplate();
        et.donothing();
        
        Department__c dept=new Department__c();
        dept.Name='BBA';
        insert dept;
        
        Program__c objPgm = new Program__c(Name = 'Program1',Department__c = dept.Id);
        insert objPgm;
        Test.startTest();
  
        Opportunity op2=new opportunity();
        op2.Name='firstname';
        op2.StageName='StageName';        
        op2.CloseDate=System.today();
        op2.Primary_Campus__c='Shanghai';
        op2.BBA_Student_Type__c='First Year Advanced';
        insert op2;
        Apexpages.currentPage().getparameters().put('id',op2.id);
        opp_EmailTemplate ett1=new opp_EmailTemplate();
        
        op2.Program__c=objPgm.id;
        op2.Primary_Campus__c='London';
        op2.StageName='Conditionally Accepted';
        op2.Conditionally_Accepted_Reasons__c='Conditionally Accepted';
        update op2;
        Apexpages.Currentpage().getParameters().put('type','word');
        opp_EmailTemplate ett2=new opp_EmailTemplate();
        
        op2.BBA_Student_Type__c='Transfer';
        op2.Primary_Campus__c='San Francisco';
        update op2;
        Apexpages.Currentpage().getParameters().put('type','type');
        opp_EmailTemplate ett3=new opp_EmailTemplate();
        
        op2.BBA_Student_Type__c='';
        op2.Primary_Campus__c='Undecided';
        update op2;
        opp_EmailTemplate ett4=new opp_EmailTemplate();
        
        op2.StageName='Accepted';
        op2.Primary_Campus__c='Dubai';
        op2.BBA_Student_Type__c='First Year Advanced';
        update op2;
        opp_EmailTemplate ett5=new opp_EmailTemplate();
        
        op2.StageName='Accepted';
        op2.BBA_Student_Type__c='Transfer';
        update op2;
        opp_EmailTemplate ett6=new opp_EmailTemplate();
        
        Test.stopTest();
        
    }
}