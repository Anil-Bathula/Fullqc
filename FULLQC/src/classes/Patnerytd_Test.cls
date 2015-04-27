@isTest
public class Patnerytd_Test{
    public static testmethod void methodname(){
        
        String rec=RecordTypeHelper.getRecordTypeId('Account','Partner');
         String rec1=RecordTypeHelper.getRecordTypeId('Opportunity','Accepted & R');
         Country__c c=new country__c();
         c.name='India';
         insert c;
         
          city__c ct=new city__c();
          ct.name='Mysore';
          ct.Country__c=c.id;
          insert ct;
         
        Program__c pro =new Program__c();
        pro.name='MBA-UK-London';
        insert pro;
        
        account a=new account();
        a.name='business account';
        a.type='Hult Educational Agent';
        a.Recordtypeid=rec;
        a.city__c=ct.id;
        insert a;
        
        Partner_Business__c acs= new Partner_Business__c();
        acs.Partner_Business__c=a.id;
        acs.Recruitment_Year__c='2014';
        insert acs;
        
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName125';
        contact.Start_Term__c = 'September 2014';
        contact.LastName = 'LastName125';
        contact.Program_Primary__c = pro.Id;
        insert contact;
        
        Integer curr_year=system.today().year();
        if(System.today().month()>9)
        curr_year=system.today().year()+1;
        
        Opportunity opp=new opportunity();
        opp.name='Patnerytd';
        opp.Stagename='Confirmed';
        opp.Contact__c = contact.Id;
        opp.program__c=pro.id;
        opp.partner__c=a.id;
        opp.start_term__c='September '+curr_year;
        opp.closedate=system.today();
        insert opp;      
        
        
        
        PageReference pageRef = Page.partnerYTD;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',a.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(a);
        partnerYTD py=new partnerYTD(ctrlr);
        py.loaddata();      
      
    }
}