/*
Author :    Premanath Reddy
Usage  :    Test class for Contact_formatedPhone Trigger on Contact object.
*/
@isTest
public class  Contact_formatedPhoneTest{
    static testmethod void methodname(){
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        insert ctry;
       
        Contact con=new Contact();
        con.LastName='test';
        con.Phone='12345';
        con.MobilePhone='98745';
        con.Country_Of_Residence__c=ctry.id;
        insert con;
        
        Country__c ctry1=new Country__c();
        ctry1.name='India';
        ctry1.Calling_Code__c=91;
        ctry1.MSN__c=null;
        ctry1.Prefix_011_not_required_for_five9__c=true;
        ctry1.Calling_Code_secondary__c=1;
        insert ctry1;
       
        Contact con1=new Contact();
        con1.LastName='test';
        con1.Phone='12345';
        con1.MobilePhone='98745';
        con1.Country_Of_Residence__c=ctry1.id;
        insert con1;
        
        formatedphone ph=new formatedphone();
        formatedphone.phnresp pc=new formatedphone.phnresp();
        pc=ph.formatedphone('+91-(0)-9874506789','91',10,false);
        System.assertEquals('011919874506789',pc.Fphcode);

    }
}