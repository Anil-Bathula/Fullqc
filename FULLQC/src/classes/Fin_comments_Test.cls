@isTest
public class Fin_comments_Test{
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
        
        opportunity_Finance__c f=new Opportunity_finance__c();        
        f.Opportunity__c=op.id;
        f.CurrencyIsoCode='USD';
        insert f;
        
        Comments__c c=new Comments__c();        
        c.Finance__c=f.id;
        insert c;
        
        
        PageReference pageRef = Page.Financecomments;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',f.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(f);
        fin_comments fin=new fin_comments(ctrlr);
        fin.CustNew();
        fin.CustSave();
        fin.CustEdit();
        fin.custDel();
        fin.CustCancel();        
      
    }
}