@istest
public class Hult_Apicalls_Test {
/*
    Class     : Hult_Apicalls_Test
    Developer : Harsha Simha S
    Date      : 2/4/2015
    Comment   : Test class for Hult API calls.
    Coverage  : All_Api(89%)
				ext_housing_transactions.apxt(100%)
				HultApi_calls_from_trigger(91%)
         
*/ 
    @testSetup static void DataArrange(){   
        Country__c country=TestDataUtil.createCountry();
        insert country;
        
        City__c city=new City__c();
        city.Name='testCity';
        city.Country__c=country.Id;
        insert city;
        
        Department__c department=TestDataUtil.createDepartment();
        insert department;
        
        Program__c program=TestDataUtil.createProgram(country.id, department.Id);
        program.Program_pre_Parsed__c='MBA';
        program.Campus__c='London';
        insert program;
        
        Contact c=TestDataUtil.createContact(Program.Id);
        c.FirstName='c';
        c.LastName='ctct_Hult_APICalls_Test';
        c.Applicant_Email__c='ctct_Hult_APICalls_Test@test.com';
        c.Email='ctct_Hult_APICalls_Test@test.com';
        c.Country_Of_Residence__c=country.Id;
        insert c;
        
        Opportunity o=new Opportunity(Name='test',contact__c=c.Id);
        o.program__c=program.Id;
        o.stageName='Confirmed';
        o.Start_Term__c=HultAPI_calls_from_trigger.CAMS_Start_term;
        o.CloseDate=System.today().addYears(1);
        insert o;
        
        Opportunity_Finance__c fin=new Opportunity_Finance__c(Opportunity__c=o.Id,Accommodation_weeks__c='36',
                                                              Housing_Accommodation__c='Single');
        insert fin;
        
        Finance_Transactions__c ft=new Finance_Transactions__c(Finance__c=fin.Id,Transaction_Type__c='Accommodation Deposit',
        Transaction_Status__c='Success');
        insert ft;
    }
    static testMethod void Test_Hult_Api_Calls_CAMS_N_Tcas()
    {
        list<Finance_Transactions__c> ftt=[select id,Name,Run_Ext_API__c,Finance__c,
                                    Finance__r.Opportunity__c,Finance__r.Opportunity__r.contact__c  from Finance_Transactions__c 
                                    where Finance__r.Opportunity__r.contact__r.LastName='ctct_Hult_APICalls_Test'];
        //Finance_Transactions__c ftt=(Finance_Transactions__c)objs.get('Finance_Transactions__c');
    	ftt[0].Run_Ext_API__c=true;
        update ftt[0];
        HultAPI_calls_from_trigger.CreateApplicant_inCAMS(new list<string>{ftt[0].Finance__r.Opportunity__c});
        HultAPI_calls_from_trigger.has_rec_alreadywaived(ftt[0].Finance__r.Opportunity__r.contact__c);
        HultAPI_calls_from_trigger.set_rec_waived(ftt[0].Finance__r.Opportunity__r.contact__c);
    }
}