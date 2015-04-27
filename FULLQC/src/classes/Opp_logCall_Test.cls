@isTest
public class Opp_logCall_Test{
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
        
        
        PageReference pageRef = Page.Opp_LogCall;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',op.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(op);
        Opp_logCall opp=new Opp_logCall(ctrlr);
        opp.CustNew();
        opp.CustSave();
        opp.CustSave1();        
        opp.CustCancel();        
      
    }
}