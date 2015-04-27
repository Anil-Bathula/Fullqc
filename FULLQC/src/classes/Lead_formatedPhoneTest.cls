/*
Author :    Premanath Reddy
Usage  :    Test class for Lead_formatedPhone Trigger on Lead object.
*/
@isTest
public class  Lead_formatedPhoneTest{
    static testmethod void methodname(){
            
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        insert ctry;
        
        Program__c pro =new Program__c();
        pro.name='MBA';
        insert pro;
        
        Setting_Disabled__c obj=new Setting_Disabled__c();
        obj.Lead_OverrideCountries__c=false;
        insert obj;
       
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
        insert led;
        
        Country__c ctry1=new Country__c();
        ctry1.name='India';
        ctry1.Calling_Code__c=91;
        ctry1.MSN__c=null;
        ctry1.Prefix_011_not_required_for_five9__c=true;
        ctry1.Calling_Code_secondary__c=1;
        insert ctry1;
       
        Lead led1 = new Lead();
        led1.Company = 'Company';
        led1.FirstName = 'FirstName';
        led1.LastName = 'LastName';
        led1.Status='Open';
        led1.Email = 'lead23@testmail.com';
        led1.Applicant_Email__c = 'lead23@testmail.com';
        led1.Phone='123456';
        led1.MobilePhone='987456';
        led1.Country_Of_Residence__c = ctry1.Id;
        led1.LeadSource = 'GMASS';
        led1.Program_Primary__c = pro.id;
        insert led1;
        formatedphone ph=new formatedphone();
        formatedphone.phnresp pc=new formatedphone.phnresp();
        pc=ph.formatedphone('+91-(0)-9874506789','91',10,false);
        System.assertEquals('011919874506789',pc.Fphcode);
     }
}