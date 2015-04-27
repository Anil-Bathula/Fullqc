@IsTest
public class opp_Accomodation_Status_test {
    static testmethod void methodname(){
        Contact objCon = new Contact();
        objcon.LastName='LastName1';
        objcon.Applicant_Email__c='test@test1email.com';
        insert objCon;
        
        Opportunity opp= new Opportunity();
        opp.Name='OpportunityName1';
        opp.StageName = 'Confirmed';        
        opp.Visa_Related_Sub_Stages__c='test trigger';
        opp.Accommodation_status__c='2a. Happy with Hult accommodation';
        opp.CloseDate = System.today();
        insert opp;
        
        /*Attachment attachment = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.Body = bodyBlob;
        attachment.Name =  'caseAttachment';
        attachment.ParentId = opp.id;
        insert attachment;*/
        
        Apexpages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        opp_Accomodation_Status act=new opp_Accomodation_Status(sc);
        act.opp=opp;
        act.loaddata();
        act.cusnew();        
        act.CustCancel();       
        act.cussave();
        
        opp.Accommodation_status__c='2c. Not Interested (Alternative accom.)';
        update opp;
        act=new opp_Accomodation_Status(sc);
        act.cussave();
    }
}