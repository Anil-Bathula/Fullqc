/* 
 Created by   : Premanath Reddy
 Date         : 9/4/2014
 purpose      : Test class for financesupport_letter and finance_supportletters_proj classes
*/
@isTest
public class financesupport_letter_test{
    static testmethod void methodname(){
        
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.StageName='Accepted';
        op.Application_Substage__c='Notified';
        op.CloseDate=System.today();
        insert op;    
        
        opportunity_Finance__c f=new Opportunity_finance__c();        
        f.Opportunity__c=op.id;
        f.Hult_Financial_Aid__c=455;
        f.CurrencyIsoCode='USD';
        insert f;
                
        List<Document> doclst = new List<Document>();
        Document document = new Document();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        document.Name='Hult Logo for Web';
        doclst.add(document);
        
        Document document1 = new Document();
        document1.AuthorId = UserInfo.getUserId();
        document1.FolderId = UserInfo.getUserId();
        document1.Name='mukulsign';
        doclst.add(document1);
        
        insert doclst;
        
        Apexpages.Currentpage().getParameters().put('id',f.id);
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(f);
        financesupport_letter fin_letr=new financesupport_letter(ctrlr);
        fin_letr.donothing();
        finance_supportletters_proj fin_letrpro=new finance_supportletters_proj();
        
        Apexpages.Currentpage().getParameters().put('type','pdf');
        fin_letr=new financesupport_letter(ctrlr);
        
        f.Hult_Financial_Aid__c=0;
        update f;
        Apexpages.Currentpage().getParameters().put('type','word');
        fin_letr=new financesupport_letter(ctrlr);
        fin_letrpro=new finance_supportletters_proj();
        
        // This is for catch block
        Apexpages.Currentpage().getParameters().put('id',null);
        fin_letr=new financesupport_letter(ctrlr);
        fin_letrpro=new finance_supportletters_proj();
        
        op.Application_Substage__c=null;
        update op;
        Apexpages.Currentpage().getParameters().put('id',f.id);
        fin_letrpro=new finance_supportletters_proj();
    }
}