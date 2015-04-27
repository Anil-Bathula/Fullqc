@isTest
public class con_comments_Test{
    public static testmethod void methodname(){    
       
        Contact ct = new Contact();       
        ct.LastName = 'LastName';        
        insert ct;        
        
        Comments__c c=new Comments__c();        
        c.Applicant__c=ct.id;
        insert c;
        
         
        PageReference pageRef = Page.Contactcomments;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',ct.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(ct);
        Con_comments con=new Con_comments(ctrlr);
        con.CustNew();
        con.CustSave();
        con.CustEdit();
        con.custDel();
        con.CustCancel();        
      
    }
}