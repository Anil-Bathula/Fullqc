/*
Create By    :- Premanath Reddy
Created Date :- 04/24/13
Purpose      :- Test class for visarequirements class
*/
@isTest
public class visarequirements_Test{
    static testmethod void methodname(){
        
        List<Program__c> prolst=new List<Program__c>();
        
        Program__c pro =new Program__c();
        pro.name='Bachelor of Business Administration-UK-London';
        prolst.add(pro);
        
        Program__c pro1 =new Program__c();
        pro1.name='MFIN-US-Boston';
        prolst.add(pro1);
        
        Program__c pro2 =new Program__c();
        pro2.name='MBA-China-Shanghai';
        prolst.add(pro2);
        
        Program__c pro3 =new Program__c();
        pro3.name='MBA-UAE-Dubai';
        prolst.add(pro3);
        
        insert prolst;
        
        Country__c ctry=new Country__c();
        ctry.name='India';
        insert ctry;
        
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        objcon.Applicant_Email__c='test@reqtest123.com';
        insert objCon;
        
        User u=[select id,Name from user where Visa_Coordinator__c=:true limit 1];
        
        Opportunity opp= new Opportunity();
        opp.Contact__c = objcon.Id;
        opp.Name = 'OpportunityName';
        opp.StageName = 'Partial Application';
        opp.CloseDate = Date.today();
        opp.Program__c = prolst[0].Id;
        opp.VC_Team_Member__c=u.id;
        opp.Start_Term__c='September'+' '+system.today().year();
        opp.Visa_Related_Sub_Stages__c='1a. Initial VC Notification Sent';
        insert opp;
        
        List<Requirement__c> reqlst=new List<Requirement__c>();
        
        Requirement__c req=new Requirement__c();
        req.name='Declaration of Finances';
        req.Approved__c=True;
        req.Supplied__c=True;
        insert req;
        
        Requirement__c req1=new Requirement__c();
        req1.name='Proof of Funds - Bank Statements';
        req1.Opportunity__c=opp.id;
        req1.Parent__c=req.id;
        req1.Approved__c=True;
        reqlst.add(req1);
        
        Requirement__c req2=new Requirement__c();
        req2.name='Proof of Funds - Loan Letter';
        req2.Opportunity__c=opp.id;
        req2.Parent__c=req.id;
        req2.Approved__c=True;
        reqlst.add(req2);
        
        Requirement__c req3=new Requirement__c();
        req3.name='Proof of Funds - Sponsorship Letter';
        req3.Opportunity__c=opp.id;
        req3.Parent__c=req.id;
        req3.Approved__c=True;
        reqlst.add(req3);
        
        Requirement__c req4=new Requirement__c();
        req4.name='Scan of current passport';
        req4.Opportunity__c=opp.id;
        req4.Parent__c=req.id;
        req4.Approved__c=True;
        reqlst.add(req4);
        
        Requirement__c req5=new Requirement__c();
        req5.name='SEVIS Transfer form';
        req5.Opportunity__c=opp.id;
        req5.Parent__c=req.id;
        req5.Approved__c=True;
        reqlst.add(req5);
        
        Requirement__c req6=new Requirement__c();
        req6.name='CAS Request Form';
        req6.Opportunity__c=opp.id;
        req6.Parent__c=req.id;
        req6.Approved__c=True;
        reqlst.add(req6);
        
        Requirement__c req7=new Requirement__c();
        req7.name='Student Enrollment Contract';
        req7.Opportunity__c=opp.id;
        req7.Parent__c=req.id;
        req7.Approved__c=True;
        reqlst.add(req7);
        
        Requirement__c req8=new Requirement__c();
        req8.name='Visa Registration Form';
        req8.Opportunity__c=opp.id;
        req8.Parent__c=req.id;
        req8.Approved__c=True;
        reqlst.add(req8);
        
        Requirement__c req9=new Requirement__c();
        req9.name='Personal Details for Visa';
        req9.Opportunity__c=opp.id;
        req9.Parent__c=req.id;
        req9.Approved__c=True;
        reqlst.add(req9);
        
        insert reqlst;
        
        visarequirements varreq=new visarequirements();
        varreq.getroles();
        varreq.getcampus();
        varreq.vcUserChange();
        varreq.rolevals=u.id;
        varreq.campusvals='London';
        varreq.Search();
        
        Test.startTest();
        
        opp.Program__c = prolst[1].Id;
        update opp;
        varreq=new visarequirements();
        varreq.rolevals=UserInfo.getUserId();
        varreq.campusvals='Boston';
        varreq.Search();
        
        opp.Program__c = prolst[2].Id;
        update opp;
        varreq=new visarequirements();
        varreq.rolevals=UserInfo.getUserId();
        varreq.campusvals='Shanghai';
        varreq.Search();
        
        opp.Program__c = prolst[3].Id;
        update opp;
        varreq=new visarequirements();
        varreq.rolevals=u.id;
        varreq.campusvals='Dubai';
       //Apexpages.currentPage().getParameters().put('rec','Owner.Name');
        varreq.Search();
        test.stopTest();
    } 
}