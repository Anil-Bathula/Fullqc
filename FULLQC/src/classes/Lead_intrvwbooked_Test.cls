/*
Author    :- Premanath Reddy
Date      :- 9/14/2012
Usage     :- Test class for Lead_intrvwbooked Trigger
Modified Prem : SFSUP-767
*/
@isTest
public class Lead_intrvwbooked_Test{
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
        led.Email = 'Lead_intrvwbooked_Test@testmail.com';
        led.Applicant_Email__c = 'Lead_intrvwbooked_Test@testmail.com';
        led.Phone='123456';
        led.MobilePhone='+91-(0)-9874506789';
        led.Country_Of_Residence__c = ctry.Id;
        led.LeadSource = 'GMASS';
        led.Program_Primary__c = pro.id;
        insert led;
        
        Test.StartTest();
        Event e2=new Event();
        e2.whoId=led.id;
        e2.Subject='meeting';
        datetime myDateTime2 = System.now().addDays(2);
        e2.StartDateTime=myDateTime2;
        e2.EndDateTime=myDateTime2.addHours(1);
        e2.Event_RequiredField__c=true;
        insert e2;
        
        
        Event e1=new Event();
        e1.whoId=led.id;
        e1.Subject='meeting';
        datetime myDateTime = System.now().addDays(2);
        e1.StartDateTime=myDateTime;
        e1.EndDateTime=myDateTime.addHours(1);
        e1.Event_RequiredField__c=true;
        insert e1;
        delete e1;
        
        Test.StopTest();
        Contact con=new Contact();
        con.FirstName='test';
        con.LastName='name';
        con.Interview_Date__c=System.Today()+5;
        con.Email = 'con_intrvwbooked_Test@testmail.com';
        con.Applicant_Email__c = 'con_intrvwbooked_Test@testmail.com';
        con.Country_Of_Residence__c = ctry.Id;
        con.Program_Primary__c = pro.id;
        insert con;
        
        Opportunity opp1= new Opportunity();
        opp1.Contact__c = con.Id;
        opp1.Name='OpportunityName';
        opp1.StageName = 'stage';
        opp1.CloseDate = System.today();
        insert opp1;
        
        Event e=new Event();
        e.whoId=con.id;
        e.Subject='meeting';
        datetime myDateTime1 = System.now().addDays(2);
        e.StartDateTime=myDateTime1;
        e.EndDateTime=myDateTime1.addHours(1);
        e.Event_RequiredField__c=true;
        insert e;
        delete e;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Sales-Recruiter and Converter']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='mytestuser@testorg.com');
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            Contact contact = new Contact();
            contact.FirstName='FirstName';
            contact.Start_Term__c = 'Jan 2011';
            contact.LastName = 'LastName';
            insert contact;
            
            Opportunity opp= new Opportunity();
            opp.Contact__c = contact.Id;
            opp.Name='OpportunityName';
            opp.StageName = 'stage';
            opp.CloseDate = System.today();
            insert opp;
            
            Event e3=new Event();
            e3.WhatId=opp.id;
            e3.Subject='meeting';
            datetime myDateTime3= System.now().addDays(2);
            e3.StartDateTime=myDateTime3;
            e3.EndDateTime=myDateTime3.addHours(1);
            insert e3;
            
            try{
                delete e3;
            }
            catch(Exception ex){
                 Boolean expectedExceptionThrown =  ex.getMessage().contains('Sorry you does not have privileges to delete this record! Only System Admin can delete') ? true : false;
                 system.assertEquals(expectedExceptionThrown,True);       
            }
        }
        
    }
}