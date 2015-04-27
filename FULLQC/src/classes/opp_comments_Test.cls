@isTest

/*************
Test Class for:-opp_applicantpage(85%),opp_comments(84%)
*************/
public class opp_comments_Test{
    public static testmethod void methodname(){    
       
        Contact ct = new Contact();       
        ct.LastName = 'LastName';        
        insert ct;    
        
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.Contact__c=ct.id;
        op.StageName='Accepted';
        op.CloseDate=System.today();
        insert op;    
        
        Comments__c c=new Comments__c();        
        c.Application__c=op.id;
        insert c;
        
        
        PageReference pageRef = Page.Opportunitycomments;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',op.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(op);
        opp_comments opp=new opp_comments(ctrlr);
        opp.CustNew();
        opp.CustSave();
        opp.CustEdit();
        opp.custDel();
        opp.CustCancel();     
        
        Apexpages.currentpage().getparameters().put('id',op.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(op);
        opp_applicantpage app=new opp_applicantpage(sc);
        app.custEdit();
        app.custSave();
        app.custCancel();   
      
    }
}