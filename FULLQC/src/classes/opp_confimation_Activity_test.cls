/* 
 Created by   : Premanath Reddy
 Date         : 22/7/2013
 Test class for opp_confimation_Activity class*/
@IsTest
public class opp_confimation_Activity_test {
    static testmethod void methodname(){
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        objcon.Applicant_Email__c='test@testemail.com';
        insert objCon;
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName';
        opp.StageName = 'Confirmed';
        opp.Confirmation_Activity_Notes__c='test';
        opp.Visa_Related_Sub_Stages__c='test trigger';
        opp.Confirmation_Activity__c='Connect candidate with a great Alum/Student';
        opp.CloseDate = System.today();
        insert opp;
        
        Apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        opp_confimation_Activity act=new opp_confimation_Activity(sc);
        act.opp=opp;
        act.cusnew();        
        act.CustCancel();
        act.op=opp;
        act.cussave();
        act.notes();
        
        act.opp.Confirmation_Activity__c='Give candidate a MyHult refresher over the phone';  
        act.notes();
        
        act.opp.Confirmation_Activity__c='Invite candidate to a dinner';        
        act.notes();
        
        act.opp.Confirmation_Activity__c='Invite candidate to an event';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Invite candidate to a webinar';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Send Candidate CR/CS Newsletter';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Send relevant one pagers';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Send candidate the Alumni Testimonial booklet';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Send candidate the Global Careers booklet';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Encourage candidate to take the Culture Active Quiz';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Send a video to your candidate';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Let your candidate know about his/her nearest test center';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Housing planning Call';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Financial planning call';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Mandatory Originals (communicated by recruiter)';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Mandatory Originals (communicated by converter)';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Introduce your candidate to other Confirmed Students';
        act.notes();
        
        act.opp.Confirmation_Activity__c='Share the results of the Hult Prize with your candidate';
        act.notes();
        
        act.opp.Confirmation_Activity__c='';
        act.notes();
        
        opp.Visa_Related_Sub_Stages__c='4a. Visa Check Call';
        update opp;
    }
}