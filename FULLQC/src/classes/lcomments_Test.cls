/*********************
Class Name: lcomments_test
Test class for:-Leadscoring.tgr (93%),
                sub_region_logic.cls(85%) 
**********************/

@isTest
public class lcomments_Test{
    public static testmethod void methodname(){
        
        List<Country__c> cntylst=new List<Country__c>();
        
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        ctry.Flags__c='richtext<img src="asdfsafd"/>';
        cntylst.add(ctry);
        
        Country__c ctry1=new Country__c();
        ctry1.name='United States';
        ctry1.Calling_Code__c=040;
        ctry1.MSN__c=10;
        ctry1.Prefix_011_not_required_for_five9__c=false;
        ctry1.Calling_Code_secondary__c=1;
        ctry1.Flags__c='richtext<img src="asdfsafd1"/>';
        cntylst.add(ctry1);
        
        Country__c ctry2=new Country__c();
        ctry2.name='China';
        ctry2.Calling_Code__c=0401;
        ctry2.MSN__c=10;
        ctry2.Prefix_011_not_required_for_five9__c=false;
        ctry2.Calling_Code_secondary__c=1;
        ctry2.Flags__c='richtext<img src="asdfsafd2"/>';
        cntylst.add(ctry2);
        
        Country__c ctry3=new Country__c();
        ctry3.name='Brazil';
        ctry3.Calling_Code__c=0401;
        ctry3.MSN__c=10;
        ctry3.Prefix_011_not_required_for_five9__c=false;
        ctry3.Calling_Code_secondary__c=1;
        ctry3.Flags__c='richtext<img src="asdfsafd2"/>';
        cntylst.add(ctry3);
        
        Country__c ctry4=new Country__c();
        ctry4.name='Japan';
        ctry4.Calling_Code__c=0401;
        ctry4.MSN__c=10;
        ctry4.Prefix_011_not_required_for_five9__c=false;
        ctry4.Calling_Code_secondary__c=1;
        ctry4.Flags__c='richtext<img src="asdfsafd2"/>';
        cntylst.add(ctry4);
        
        insert cntylst;
        
        Program__c pro =new Program__c();
        pro.name='EMBAm-China-Shanghai';
        insert pro;
        
        Program__c pro1 =new Program__c();
        pro1.name='Bachelor of Business Administration-US-San Francisco';
        insert pro1;
        
        Setting_Disabled__c obj=new Setting_Disabled__c();
        obj.Lead_OverrideCountries__c=false;
        insert obj;
        
        List<Lead> ledlst=new List<Lead>();
         
        Lead led = new Lead();
        led.Company = 'Company';
        led.FirstName = 'FirstName';
        led.LastName = 'LastName';
        led.Status='Open';
        led.Email = 'lead11123@testmail.com';
        led.Applicant_Email__c = 'lead11123@testmail.com';
        led.Phone='123456';
        led.MobilePhone='+91-(0)-9874506789';
        led.Country_Of_Residence__c = ctry.Id;
        led.LeadSource = 'GMASS';
        led.Program_Primary__c = pro.id;
        led.Region__c='Africa';
        ledlst.add(led);        
        
        Lead led1 = new Lead();
        led1.Company = 'Company12';
        led1.FirstName = 'FirstName12';
        led1.LastName = 'LastName12';
        led1.Status='Open';
        led1.Email = 'lead11123re@testmail.com';
        led1.Applicant_Email__c = 'lead11123re@testmail.com';
        led1.Phone='123456';
        led1.MobilePhone='+91-(0)-9874566789';
        led1.Country_Of_Residence__c = ctry.Id;
        led1.LeadSource = 'SAT';
        led1.Program_Primary__c = pro.id;
        led1.Region__c='Asia';
        ledlst.add(led1);    
        
        Lead led2 = new Lead();
        led2.Company = 'Company122';
        led2.FirstName = 'FirstName122';
        led2.LastName = 'LastName122';
        led2.Status='Open';
        led2.Email = 'lead111232re@testmail.com';
        led2.Applicant_Email__c = 'lead111232re@testmail.com';
        led2.Phone='1234562';
        led2.MobilePhone='+91-(0)-98745667892';
        led2.Country_Of_Residence__c = ctry.Id;
        led2.LeadSource = 'SAT';
        led2.Program_Primary__c = pro.id;
        led2.Region__c='South Asia';
        ledlst.add(led2);     
        
        Lead led3 = new Lead();
        led3.Company = 'Company121';
        led3.FirstName = 'FirstName121';
        led3.LastName = 'LastName121';
        led3.Status='Open';
        led3.Email = 'lead111231re@testmail.com';
        led3.Applicant_Email__c = 'lead111231re@testmail.com';
        led3.Phone='1234561';
        led3.MobilePhone='+91-(0)-98745667891';
        led3.Country_Of_Residence__c = ctry1.Id;
        led3.LeadSource = 'SAT';
        led3.Program_Primary__c = pro.id;
        led3.Region__c='LatAm';
        led3.state='Nevada';
        ledlst.add(led3);  
        
        Lead led4 = new Lead();
        led4.Company = 'Company1211';
        led4.FirstName = 'FirstName1211';
        led4.LastName = 'LastName1211';
        led4.Status='Open';
        led4.Email = 'lead1112311re@testmail.com';
        led4.Applicant_Email__c = 'lead1112311re@testmail.com';
        led4.Phone='12345611';
        led4.MobilePhone='+91-(0)-987456678911';
        led4.Country_Of_Residence__c = ctry1.Id;
        led4.state='Nevada';
        led4.LeadSource = 'SAT';
        led4.Program_Primary__c = pro1.id;
        led4.Region__c='North Am';
        ledlst.add(led4); 
        
        Lead led5 = new Lead();
        led5.Company = 'Company12112';
        led5.FirstName = 'FirstName12112';
        led5.LastName = 'LastName12112';
        led5.Status='Open';
        led5.Email = 'lead11123112re@testmail.com';
        led5.Applicant_Email__c = 'lead11123112re@testmail.com';
        led5.Phone='123456112';
        led5.MobilePhone='+91-(0)-987456678912';
        led5.Country_Of_Residence__c = ctry.Id;
        led5.LeadSource = 'SAT';
        led5.Program_Primary__c = pro.id;
        led5.Region__c='North Am BOS';
        ledlst.add(led5);
        
        Lead led6 = new Lead();
        led6.Company = 'Company121121';
        led6.FirstName = 'FirstName121121';
        led6.LastName = 'LastName121121';
        led6.Status='Open';
        led6.Email = 'lead111231121re@testmail.com';
        led6.Applicant_Email__c = 'lead111231121re@testmail.com';
        led6.Phone='1234561121';
        led6.MobilePhone='+91-(0)-987456678913';
        led6.Country_Of_Residence__c = ctry.Id;
        led6.LeadSource = 'SAT';
        led6.Program_Primary__c = pro.id;
        led6.Region__c='North Am SFO';
        ledlst.add(led6);
        
        insert ledlst;
        
        Comments__c c=new Comments__c();        
        c.Lead__c=led.id;
        insert c;
        
        List<Lead> ledupdt=new List<Lead>();
        
        led1.Undergraduate_Major__c='other';
        led1.Country_Of_Residence__c =ctry2.id;
        led1.Program_Primary__c = pro1.id;
        ledupdt.add(led1);       
        
        led2.Program_Primary__c = pro1.id;
        ledupdt.add(led2);
        
        led3.Program_Primary__c = pro1.id;
        led3.Country_Of_Residence__c =ctry3.id;
        ledupdt.add(led3);
        
        led4.Region__c='LON EUR';
        ledupdt.add(led4);
        
        led5.Region__c='LUZ EUR';
        ledupdt.add(led5);
        
        led6.Region__c='Middle East';
        ledupdt.add(led6);
        
        update ledupdt;
        
        led1.Country_Of_Residence__c =ctry4.id;
        update led1;
        
        PageReference pageRef = Page.leadcomments;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',led.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(led);
        lcomments ld=new lcomments(ctrlr);
        ld.CustNew();
        ld.CustSave();
        ld.CustEdit();
        ld.custDel();
        ld.CustCancel();        
      
    }
}