@isTest
private class oppty_newdetailpage_test {
/*
    Developer : Harsha Simha
        Test class for : New_opp_headers_ctrlr , new_fin_attachments_ctrlr,new_oppty_attachments_ctrlr
*/
    static testMethod void test_oppty_inlinevfs() 
    {
    	Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        ctry.Flags__c='richtext<img src="asdfsafd"/>';
        insert ctry;
        
        Department__c objDept = TestDataUtil.createDepartment();
        Database.insert(objDept);
        
        Program__c objPro = TestDataUtil.createProgram(ctry.Id, objDept.Id);
        Database.insert(objPro);
        
        Account objAcc = TestDataUtil.createAccount();
        Database.insert(objAcc);
        
        Contact objCon = TestDataUtil.createContact(objPro.id);
        Database.insert(objCon);
        
        Opportunity opp= new Opportunity();
        opp.Contact__c = objcon.Id;
        opp.Name = 'OpportunityName';
        opp.StageName = 'StageName';
        opp.CloseDate = Date.today();
        opp.Program__c = objpro.Id;
        insert opp;
        
        
        Opportunity_Finance__c oppfin=new Opportunity_Finance__c();
        oppfin.Opportunity__c=opp.id;        
        insert oppfin;
        /*
        Event ev=new Event();
        datetime myDateTime = System.Today().addDays(5);
        ev.StartDateTime=myDateTime;
        ev.EndDateTime=myDateTime.addHours(1);
        ev.WhoId=objcon.id;
        insert ev;
        
        Task ts=new Task();
        ts.whoId=objcon.ID;
        ts.Program__c=objpro.id;
        ts.Phone__c=objcon.Phone;
        ts.Status='Completed';
        insert ts;
        
        Task ts1=new Task();
        ts1.whoId=objcon.ID;
        ts1.Program__c=objpro.id;
        ts1.Phone__c=objcon.Phone;
        ts1.Status='Progress';
        insert ts1;
        */
        Attachment attch= new Attachment();
        attch.ParentId=opp.id;
        attch.Name='name';
        attch.Body=Blob.valueof('myBlob');
        attch.ContentType='text/plain';
        insert attch;
        
        Attachment attch1= new Attachment();
        attch1.ParentId=oppfin.id;
        attch1.Name='name';
        attch1.Body=Blob.valueof('myBlob');
        attch1.ContentType='text/plain';
        insert attch1;
        
        Test.startTest();
        
        objcon.Country_Of_Origin__c=ctry.Id;
        update objcon;
        
        //for opportunity Headers controller
        PageReference pageRef = Page.new_opp_headers;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',opp.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(opp);
        new_opp_headers_ctrlr opphdrs=new new_opp_headers_ctrlr(ctrlr);
        opp.StageName='Enrolled';update opp;
        opphdrs.init();
        
        objcon.Country_Of_Origin__c=null;
        objcon.Country_Of_Citizenship__c=ctry.Id;
        update objcon;
        opphdrs.init();
        System.assertEquals(opphdrs.showpaymentbar,true);
        
        
        //for opportunity Attachments controller
         new_oppty_attachments_ctlr opptyattch=new new_oppty_attachments_ctlr(ctrlr);
        opptyattch.newattach();
        opptyATTCH.cancelattach();        
        string bdy='tetstattchmnt';
        opptyattch.newattach();
        
        opptyattch.attchmnt.name='tetstattchmnt.txt';
        opptyattch.attchmnt.body=blob.valueof(bdy);
        opptyattch.attchmnt.ContentType='.txt';        
        opptyattch.upattach();
        opptyattch.editattchid=attch.id;
        opptyattch.editattach();
        opptyattch.saveattach();
        opptyattch.delattach();   
        
        //for opportunity Finance Attachments controller
        Apexpages.currentPage().getParameters().put('id',oppfin.Id);
        new_fin_attachments_ctlr opfinattch=new new_fin_attachments_ctlr(ctrlr);
        opfinattch.newattach();
        opfinATTCH.cancelattach();        
        
        opfinattch.newattach();
        
        opfinattch.attchmnt.name='tetstattchmnt.txt';
        opfinattch.attchmnt.body=blob.valueof(bdy);
        opfinattch.attchmnt.ContentType='.txt';
        //ldattch.attchmnt.BodyLength=bdy.length;
        opfinattch.upattach();
        opfinattch.editattchid=attch1.id;
        opfinattch.editattach();
        opfinattch.saveattach();
        opfinattch.delattach();   
        Test.stopTest();
    }
}