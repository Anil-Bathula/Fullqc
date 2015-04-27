/* 
 Created by   : Premanath Reddy
 Date         : 18/10/2013
 Test class for opp_contactpage class*/
@IsTest
public class opp_contactpage_test {
    static testmethod void methodname(){
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        objcon.Applicant_Email__c='test@test132email.com';
        insert objCon;
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName';
        opp.StageName = 'Confirmed';
        opp.Contact__c=objCon.id;
        opp.CloseDate = System.today();
        insert opp;
        
        Apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        opp_contactpage app=new opp_contactpage(sc);
        app.custEdit();
        app.custSave();
        app.custCancel();
        app.init();
        
    }
}