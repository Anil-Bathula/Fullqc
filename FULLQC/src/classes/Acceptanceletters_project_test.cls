/*
Create By    :- Premanath Reddy
Created Date :- 08/01/14
Purpose      :- Test class for Acceptanceletters_project and Acceptanceletters_2015 classes
*/
@isTest
public class Acceptanceletters_project_test{
    // This Test method is for BIBA
    static testmethod void biba_method(){
        
        Department__c dept=new Department__c();
        dept.Name='BBA';
        insert dept;
        
        Program__c pro =new Program__c();
        pro.name='Bachelor of Business Administration-UK-London';
        pro.Program_pre_Parsed__c='BBA';
        pro.Campus__c='London';
        pro.Department__c=dept.id;
        insert pro;
        
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.StageName = 'Accepted';
        opp.BBA_Student_Type__c='First Year';
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Start_Term__c='September'+' '+system.today().year();
        opp.Primary_Campus__c='Boston';
        insert opp;
        
        Opportunity_Finance__c fin=new Opportunity_Finance__c();
        fin.Opportunity__c=opp.id;
        insert fin;
        
        Apexpages.Currentpage().getParameters().put('id',opp.id);
        Acceptanceletters_project o=new Acceptanceletters_project();
        Acceptanceletters_2015 acl=new Acceptanceletters_2015();
        o.donothing();
        acl.donothing();
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='Dubai';
        opp.BBA_Student_Type__c='First Year Advanced';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','pdf');
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        test.startTest();
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='London';
        opp.BBA_Student_Type__c='transfer';
        opp.Conditionally_Accepted_Reasons__c='Official HS trans/ diploma;Official University trans/diploma;Ofcl English translat of transcr/degree;Official Inst/School TOEFL/ IELTS score;Official Inst/School GMAT/ GRE score;Cert of successful compl 3 mo IEMA prog;Cert of successful compl 6 mo IEMA prog;Additional prof/ academic reference;';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','word');
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='San Francisco';
        opp.BBA_Student_Type__c='First Year';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Early_Application__c=true;
        opp.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score;Officl Inst/School copy of GMAT/GRE;Cert IEMA 3 mo. Intensive English Prog;Cert IEMA 6 mo. Intensive English Prog;Cert of the EF Pre-Master’s Prog;Cert of UPiBT with 60-63;Official copy of SHL score report;Official copy of BEST score report;Transcripts with GPA of at least 2.5;Offcl University Foundation Year Diploma;Officl Diploma in Business Management;Additional academic/prof ref letter;';
        opp.Primary_Campus__c='Shanghai';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Early_Application__c=false;
        opp.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score;Cert IEMA 6 mo. Intensive English Prog;Cert of the EF Pre-Master’s Prog;Official copy of SHL score report;Official copy of BEST score report;Transcripts with GPA of at least 2.5;Additional academic/prof ref letter;';
        opp.Primary_Campus__c='Undecided';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Start_Term__c='january'+' '+system.today().year();
        opp.BBA_Student_Type__c='First year';
        opp.Primary_Campus__c='San Francisco';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Start_Term__c='january'+' '+system.today().year();
        opp.BBA_Student_Type__c='First year Advanced';
        opp.Primary_Campus__c='San Francisco';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Waitlisted';
        opp.Waitlisted_Reasons__c='GPA';
        opp.Primary_Campus__c='San Francisco';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Rejected';
        opp.Rejected_Reason__c='Insufficient work experience;No Bachelor degree;Unsatisfactory TOEFL score;';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Confirmed';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        List<Document> doclst = new List<Document>();
        Document document = new Document();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        document.Name='Hult Logo for Web';
        doclst.add(document);
        
        Document document4 = new Document();
        document4.AuthorId = UserInfo.getUserId();
        document4.FolderId = UserInfo.getUserId();
        document4.Name='Ian Dougal sign';
        doclst.add(document4);
        
        Document document1 = new Document();
        document1.AuthorId = UserInfo.getUserId();
        document1.FolderId = UserInfo.getUserId();
        document1.Name='Henrik sign';
        doclst.add(document1);
        
        Document document5 = new Document();
        document5.AuthorId = UserInfo.getUserId();
        document5.FolderId = UserInfo.getUserId();
        document5.Name='Nawtej Sign';
        doclst.add(document5);
        
        Document document6 = new Document();
        document6.AuthorId = UserInfo.getUserId();
        document6.FolderId = UserInfo.getUserId();
        document6.Name='Shaun Sign';
        doclst.add(document6);
        
        Document document7 = new Document();
        document7.AuthorId = UserInfo.getUserId();
        document7.FolderId = UserInfo.getUserId();
        document7.Name='Larry Sign';
        doclst.add(document7);
        
        Document document8 = new Document();
        document8.AuthorId = UserInfo.getUserId();
        document8.FolderId = UserInfo.getUserId();
        document8.Name='Amanda Sign';
        doclst.add(document8);
        
        Document document9 = new Document();
        document9.AuthorId = UserInfo.getUserId();
        document9.FolderId = UserInfo.getUserId();
        document9.Name='HultWaterMark';
        doclst.add(document9);
        
        Document document10 = new Document();
        document10.AuthorId = UserInfo.getUserId();
        document10.FolderId = UserInfo.getUserId();
        document10.Name='HCP Hult Logo';
        doclst.add(document10);
        
        Document document11 = new Document();
        document11.AuthorId = UserInfo.getUserId();
        document11.FolderId = UserInfo.getUserId();
        document11.Name='EF Logo';
        doclst.add(document11);
        
        Document document12 = new Document();
        document12.AuthorId = UserInfo.getUserId();
        document12.FolderId = UserInfo.getUserId();
        document12.Name='BAC Logo';
        doclst.add(document12);
        
        insert doclst;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        test.stopTest();
    }
    // This test method is for Non-BIBA
    static testmethod void nonbiba_method(){
        List<Document> doclst = new List<Document>();
        Document document = new Document();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        document.Name='Hult Logo for Web';
        doclst.add(document);
        
        Document document4 = new Document();
        document4.AuthorId = UserInfo.getUserId();
        document4.FolderId = UserInfo.getUserId();
        document4.Name='Ian Dougal sign';
        doclst.add(document4);
        
        Document document1 = new Document();
        document1.AuthorId = UserInfo.getUserId();
        document1.FolderId = UserInfo.getUserId();
        document1.Name='Henrik sign';
        doclst.add(document1);
        
        Document document5 = new Document();
        document5.AuthorId = UserInfo.getUserId();
        document5.FolderId = UserInfo.getUserId();
        document5.Name='Nawtej Sign';
        doclst.add(document5);
        
        Document document6 = new Document();
        document6.AuthorId = UserInfo.getUserId();
        document6.FolderId = UserInfo.getUserId();
        document6.Name='Shaun Sign';
        doclst.add(document6);
        
        Document document7 = new Document();
        document7.AuthorId = UserInfo.getUserId();
        document7.FolderId = UserInfo.getUserId();
        document7.Name='Larry Sign';
        doclst.add(document7);
        
        Document document8 = new Document();
        document8.AuthorId = UserInfo.getUserId();
        document8.FolderId = UserInfo.getUserId();
        document8.Name='Amanda Sign';
        doclst.add(document8);
        
        Document document9 = new Document();
        document9.AuthorId = UserInfo.getUserId();
        document9.FolderId = UserInfo.getUserId();
        document9.Name='HultWaterMark';
        doclst.add(document9);
        
        insert doclst;
    
        Department__c dept=new Department__c();
        dept.Name='MBA';
        insert dept;
        
        Program__c pro =new Program__c();
        pro.name='MBA-UK-London';
        pro.Program_pre_Parsed__c='MBA';
        pro.Campus__c='London';
        pro.Department__c=dept.id;
        insert pro;
        
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.StageName = 'Accepted';
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Start_Term__c='September'+' '+system.today().year();
        insert opp;
        
        Opportunity_Finance__c fin=new Opportunity_Finance__c();
        fin.Opportunity__c=opp.id;
        insert fin;
        
        Apexpages.Currentpage().getParameters().put('id',opp.id);
        Acceptanceletters_project o=new Acceptanceletters_project();
        Acceptanceletters_2015 acl=new Acceptanceletters_2015();
        o.donothing();
        acl.donothing();
        
        pro.name='MBA-US-Boston';
        pro.Campus__c='Boston';
        update pro;
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='Boston';
        opp.Conditionally_Accepted_Reasons__c='Official HS trans/ diploma;Official University trans/diploma;Ofcl English translat of transcr/degree;Official Inst/School TOEFL/ IELTS score;Official Inst/School GMAT/ GRE score;Cert of successful compl 3 mo IEMA prog;Cert of successful compl 6 mo IEMA prog;Additional prof/ academic reference;';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','word');
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        pro.name='MBA-Dubai';
        pro.Campus__c='Dubai';
        update pro;
        
        opp.StageName='Accepted';
        opp.Primary_Campus__c='Dubai';
        opp.BBA_Student_Type__c='First Year Advanced';
        update opp;
        Apexpages.Currentpage().getParameters().put('type','pdf');
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score;Officl Inst/School copy of GMAT/GRE;Cert IEMA 3 mo. Intensive English Prog';
        opp.Primary_Campus__c='Shanghai';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.StageName='Conditionally Accepted';
        opp.Admission_Endorsed_reasons__c='Officl Inst/School cop TOEFL/IELTS score;Cert IEMA 6 mo. Intensive English Prog;Cert of the EF Pre-Master’s Prog;Official copy of SHL score report;Official copy of BEST score report;Transcripts with GPA of at least 2.5;Additional academic/prof ref letter;';
        opp.Primary_Campus__c='Shanghai';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        pro.name='MBA-UK-San Francisco';
        pro.Campus__c='San Francisco';
        update pro;
        
        opp.StageName='Soft Rejected';
        opp.Rejected_Reason__c='Insufficient work experience;No Bachelor degree;';
        opp.Primary_Campus__c='San Francisco';
        opp.BBA_Student_Type__c='First Year';
        update opp;
        o=new Acceptanceletters_project();
        
        test.startTest();
        
        opp.StageName='Rejected';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        opp.Program__c = pro.Id;
        opp.Primary_Campus__c='Shanghai';
        opp.StageName='Confirmed';
        update opp;
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        
        Department__c dept1=new Department__c();
        dept1.Name='Undecided';
        insert dept1;
        
        Program__c pro1 =new Program__c();
        pro1.name='Undecided-US-San Francisco';
        pro1.Department__c=dept1.id;
        insert pro1;
        
        opp.Program__c = pro1.Id;
        opp.StageName='Undecided';
        update opp;
                
        o=new Acceptanceletters_project();
        acl=new Acceptanceletters_2015();
        test.stopTest();
    } 
}