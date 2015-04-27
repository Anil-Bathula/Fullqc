/*
Create By    :- Premanath Reddy
Created Date :- 10/18/12
Purpose      :- Test class for requirementsmatrix class
*/
@isTest
public class requirementsmatrix_Test{
    static testmethod void methodname(){
        //requirementsmatrix varreq=new requirementsmatrix();
       // varreq.getroles();             
        
        Program__c pro =new Program__c();
        pro.name='MBA';
        insert pro;
        
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        ctry.Flags__c='richtext<img src="asdfsafd"/>';
        insert ctry;
        
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        insert objCon;
        
        Account account =TestDataUtil.createAccount('TestMBA-Asia', 'Candidate');// new Account();
        //account.Name = 'Account';
        insert account;
        
        Opportunity opp= new Opportunity();
        opp.AccountId = account.Id;
        opp.Contact__c = objcon.Id;
        opp.Name = 'OpportunityName';
        opp.StageName = 'Partial Application';
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Conversion_Team_Member__c=UserInfo.getUserId();
        opp.Start_Term__c='September 2013';
        insert opp;
        
        Requirement__c req=new Requirement__c();
        req.name='Current Resume';
        req.Approved__c=True;
        req.Supplied__c=True;
        insert req;
        
        Requirement__c req12=new Requirement__c();
        req12.name='Current Resume';
        req12.Opportunity__c=opp.id;
        req12.Parent__c=req.id;
        req12.Approved__c=True;
        insert req12;
       
        Requirement__c req1=new Requirement__c();
        req1.name='Essay/Personal Statement';
        req1.Opportunity__c=opp.id;
        req1.Parent__c=req.id;
        req1.Approved__c=True;
        insert req1;
        
        Requirement__c req2=new Requirement__c();
        req2.name='Undergrad-Postgrad Transcript';
        req2.Opportunity__c=opp.id;
        req2.Parent__c=req.id;
        req2.Approved__c=True;
        insert req2;
        
        Requirement__c req3=new Requirement__c();
        req3.name='High School Transcript';
        req3.Opportunity__c=opp.id;
        req3.Parent__c=req.id;
        req3.Approved__c=True;
        insert req3;
        
        Requirement__c req4=new Requirement__c();
        req4.name='High School Diploma';
        req4.Opportunity__c=opp.id;
        req4.Parent__c=req.id;
        req4.Approved__c=True;
        insert req4;
        
        Requirement__c req5=new Requirement__c();
        req5.name='Professional Recommendation (1 of 2)';
        req5.Opportunity__c=opp.id;
        req5.Parent__c=req.id;
        req5.Approved__c=True;
        insert req5;
        
        Requirement__c req6=new Requirement__c();
        req6.name='Professional Recommendation (2 of 2)';
        req6.Opportunity__c=opp.id;
        req6.Parent__c=req.id;
        req6.Approved__c=True;
        insert req6;
        
        Requirement__c req7=new Requirement__c();
        req7.name='Language Proficiency, English';
        req7.Opportunity__c=opp.id;
        req7.Parent__c=req.id;
        req7.Approved__c=True;
        insert req7;
        
        Requirement__c req8=new Requirement__c();
        req8.name='Graduate Test';
        req8.Opportunity__c=opp.id;
        req8.Parent__c=req.id;
        req8.Approved__c=True;
        insert req8;
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(opp);
        requirementsmatrix varreq=new requirementsmatrix(ctrl);
        varreq.getroles();
        varreq.Search();
       // Verified is True
        
        req12.Approved__c=false;
        req12.Verified__c=true;
        update req12;
        
        req1.Approved__c=false;
        req1.Verified__c=true;
        update req1;
        
        req2.Approved__c=false;
        req2.Verified__c=true;
        update req2;
        
        req3.Approved__c=false;
        req3.Verified__c=true;
        update req3;
        
        req4.Approved__c=false;
        req4.Verified__c=true;
        update req4;
        
        req5.Approved__c=false;
        req5.Verified__c=true;
        update req5;
        
        req6.Approved__c=false;
        req6.Verified__c=true;
        update req6;
        
        req7.Approved__c=false;
        req7.Verified__c=true;
        update req7;
        
        req8.Approved__c=false;
        req8.Verified__c=true;
        update req8;
        
        ctrl = new ApexPages.StandardController(opp);
        varreq=new requirementsmatrix(ctrl);
        varreq.getroles();
        varreq.Search();
        
        req12.Verified__c=false;
        req12.Supplied__c=true;
        update req12;
        
        req1.Verified__c=false;
        req1.Supplied__c=true;
        update req1;
        
        req2.Verified__c=false;
        req2.Supplied__c=true;
        update req2;
        
        req3.Verified__c=false;
        req3.Supplied__c=true;
        update req3;
        
        req4.Verified__c=false;
        req4.Supplied__c=true;
        update req4;
        
        req5.Verified__c=false;
        req5.Supplied__c=true;
        update req5;
        
        req6.Verified__c=false;
        req6.Supplied__c=true;
        update req6;
        
        req7.Verified__c=false;
        req7.Supplied__c=true;
        update req7;
        
        req8.Verified__c=false;
        req8.Supplied__c=true;
        update req8;
        
        ctrl = new ApexPages.StandardController(opp);
        varreq=new requirementsmatrix(ctrl);
        varreq.getroles();
        varreq.Search();
        // Documents need
        req12.Approved__c=false;
        req8.Verified__c=false;
        req12.Supplied__c=false;
        update req12;
        
        req1.Approved__c=false;
        req1.Verified__c=false;
        req1.Supplied__c=false;
        update req1;
        
        req2.Approved__c=false;
        req2.Verified__c=false;
        req2.Supplied__c=false;
        update req2;
        
        req3.Approved__c=false;
        req3.Verified__c=false;
        req3.Supplied__c=false;
        update req3;
        
        req4.Approved__c=false;
        req4.Verified__c=false;
        req4.Supplied__c=false;
        update req4;
        
        req5.Approved__c=false;
        req5.Verified__c=false;
        req5.Supplied__c=false;
        update req5;
        
        req6.Approved__c=false;
        req6.Verified__c=false;
        req6.Supplied__c=false;
        update req6;
        
        req7.Approved__c=false;
        req7.Verified__c=false;
        req7.Supplied__c=false;
        update req7;
        
        req8.Approved__c=false;
        req8.Verified__c=false;
        req8.Supplied__c=false;
        update req8;
        
        ctrl = new ApexPages.StandardController(opp);
        varreq=new requirementsmatrix(ctrl);
        varreq.getroles();
        varreq.Search();
        
        
        Apexpages.currentPage().getParameters().put('returl',req8.Id);      
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(req8);        
        Requirement_blockdelete delreq1=new Requirement_blockdelete(ctrlr);
        delreq1.del();
        delreq1.back();
        
        Apexpages.currentPage().getParameters().put('id',req8.Id);      
        ApexPages.StandardController ctrlr1=new ApexPages.StandardController(req8);        
        Requirement_blockdelete delreq=new Requirement_blockdelete(ctrlr1);
        delreq.del();
        delreq.back();
        
           
        
       
    } 
}