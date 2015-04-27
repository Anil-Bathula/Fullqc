/*
Create By    :- Premanath Reddy
Created Date :- 07/05/13
Purpose      :- Test class for opp_Acceptanceletters class
*/
@isTest
public class opp_Acceptanceletters_Test{
    // This Test method is for BIBA
    static testmethod void biba_method(){
        
        Department__c dept=new Department__c();
        dept.Name='BBA';
        insert dept;
        
        Program__c pro =new Program__c();
        pro.name='Bachelor of Business Administration-UK-London';
        pro.Department__c=dept.id;
        insert pro;
        
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.StageName = 'Admissions Endorsed';
        opp.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score;Officl Inst/School copy of GMAT/GRE;Cert IEMA 3 mo. Intensive English Prog;Cert IEMA 6 mo. Intensive English Prog;Cert of the EF Pre-Master’s Prog;Cert of UPiBT with 60-63;Official copy of SHL score report;Official copy of BEST score report;Transcripts with GPA of at least 2.5;Offcl University Foundation Year Diploma;Officl Diploma in Business Management;Additional academic/prof ref letter;';
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Start_Term__c='September'+' '+system.today().year();
        opp.Primary_Campus__c='Boston';
        insert opp;
        
        Apexpages.Currentpage().getParameters().put('id',opp.id);
        opp_Acceptanceletters o=new opp_Acceptanceletters();
        o.donothing();
        
        opp.StageName='Admissions Endorsed Confirmed';
        opp.Primary_Campus__c='Dubai';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','pdf');
        o=new opp_Acceptanceletters();
        
        test.startTest();
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='London';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','word');
        o=new opp_Acceptanceletters();
        
        opp.StageName='Confirmed';
        opp.Primary_Campus__c='San Francisco';
        update opp;
        o=new opp_Acceptanceletters();
        
        opp.StageName='Accepted';
        opp.BBA_Student_Type__c='First Year Advanced';
        opp.Primary_Campus__c='Shanghai';
        update opp;
        o=new opp_Acceptanceletters();
        
        opp.StageName='Confirmed';
        opp.BBA_Student_Type__c='First Year Advanced';
        opp.Primary_Campus__c='Undecided';
        update opp;
        o=new opp_Acceptanceletters();
        
        opp.StageName='Accepted';
        opp.BBA_Student_Type__c='Transfer';
        update opp;
        o=new opp_Acceptanceletters();
        
        /*opp.StageName='Confirmed';
        opp.BBA_Student_Type__c='Transfer';
        update opp;
        o=new opp_Acceptanceletters();*/
        
        opp.StageName='Accepted';
        opp.BBA_Student_Type__c='';
        opp.Conditionally_Accepted_Reasons__c='Official HS trans/ diploma;Official University trans/diploma;Ofcl English translat of transcr/degree;Official Inst/School TOEFL/ IELTS score;Official Inst/School GMAT/ GRE score;Cert of successful compl 3 mo IEMA prog;Cert of successful compl 6 mo IEMA prog;Additional prof/ academic reference;';
        update opp;
        
        test.stopTest();
    } 
    
    // This test method is for Non-BIBA
    static testmethod void nonbiba_method(){
        Department__c dept1=new Department__c();
        dept1.Name='MBA';
        insert dept1;
        
        Program__c pro1 =new Program__c();
        pro1.name='MBA-US-Boston';
        pro1.Department__c=dept1.id;
        insert pro1;
        
        Opportunity opp1= new Opportunity();
        opp1.Name = 'OpportunityName';
        opp1.StageName = 'Admissions Endorsed Confirmed';
        opp1.Admission_Endorsed__c=True;
        opp1.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score';
        opp1.CloseDate = Date.today();
        opp1.Program__c = pro1.Id;
        opp1.Start_Term__c='September'+' '+system.today().year();
        opp1.Primary_Campus__c='Boston';
        insert opp1;
        
        Test.startTest();
        Apexpages.Currentpage().getParameters().put('id',opp1.id);
        opp_Acceptanceletters op=new opp_Acceptanceletters();
        
        opp1.StageName='Admissions Endorsed';
        update opp1;
        op=new opp_Acceptanceletters();
        
        opp1.StageName='Accepted';
        opp1.Primary_Campus__c='London';
        update opp1;
        op=new opp_Acceptanceletters();
        
        opp1.StageName='Confirmed';
        update opp1;
        op=new opp_Acceptanceletters();
        
        opp1.StageName='Accepted';
        opp1.BBA_Student_Type__c='';
        opp1.Conditionally_Accepted_Reasons__c='Official HS trans/ diploma';
        update opp1;
        op=new opp_Acceptanceletters();
        
        opp1.StageName='Confirmed';
        opp1.Conditionally_Accepted_Reasons__c='Official HS trans/ diploma;Official University trans/diploma;;Ofcl English translat of transcr/degree;Official Inst/School TOEFL/ IELTS score;Official Inst/School GMAT/ GRE score;Cert of successful compl 3 mo IEMA prog;Cert of successful compl 6 mo IEMA prog;Additional prof/ academic reference;';
        update opp1;
        op=new opp_Acceptanceletters();
        
        
        Test.stopTest();
    } 
}