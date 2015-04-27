/*
    Class     : contact2opportunity_test
    Developer : Harsha Simha S
    Date      : 29/8/2013
    Comment   : Test class for contact2opportunity Trigger.
    Triggers  : contact2opportunity_test(87%)
         
         Method2 coverage :
         
         Triggers : Contact2Opportunity (pre-university)
         Contact_set_RecordType
         opp_recordtype
         
*/ 
@isTest(seealldata=true)
private class contact2opportunity_test {

    static testMethod void contact2oppsync() 
    {
        Country__c ctry=TestDataUtil.createCountry();
        insert ctry;
          
        Department__c dep=TestDataUtil.createDepartment();
        insert dep;
      
        Program__c pgm=TestDataUtil.createProgram(ctry.Id, dep.Id);
        insert pgm; 
        
        Program__c pgm1=TestDataUtil.createProgram(ctry.Id, dep.Id);        
        insert pgm1; 
        
        contact ctct=TestDataUtil.createContact(pgm.Id);
        ctct.Applicant_Email__c='contact2opportunity_test1@test.com';
        insert ctct;    
        
        List<user> u=[select Id, Name from User where Id != :UserInfo.getUserId() and IsActive = true and ContactId = null limit 3];
        
        Opportunity opportunity = new Opportunity();
        opportunity.Contact__c = ctct.Id;
        opportunity.Name = 'OpportunityName';
        opportunity.StageName = 'StageName';
        opportunity.CloseDate = Date.today();
        opportunity.Program__c = pgm.Id;
        insert opportunity;
        
        ctct.Program_Primary__c=pgm1.id;
        ctct.Linked_In_Status__c='test';
        if(!u.Isempty())
            ctct.OwnerId=u[0].Id;
        ctct.Start_Term__c='September 2014';
        ctct.LastName='test';
        update ctct;
        
        /* 
        string query= 'select id,Admission_Test_Waiver__c,App_ID__c,Applicant_Email__c,Birthdate_from_Contact__c,Country_Of_Citizenship__c,Country_Of_Origin__c,'+
                            'First_Name_from_Contact__c,Gender__c,Highest_Degree_Attained__c,Industry_Sector__c,Language_Test_Waived__c,Language_Test_Waiver__c,'+
                            'Last_Name_from_Contact__c,Mailing_Address_Application__c,Mailing_Address__c,Mailing_City_from_Contact__c,Mailing_Country_from_contact__c,'+
                            'Mailing_Postal_Code_from_Contact__c,Mailing_State_from_Contact__c,Mailing_Street_from_Contact__c,Matriculated__c,Name,Owner_Email__c,'+
                            'Owner_Name__c,Primary_Campus__c,Program_pre_Parsed__c,Start_Term__c,Type_of_Validated_Admission_Test__c,Type_of_Validated_Language__c,'+
                            'Validated_Admission_Test_Score__c,Validated_Language_Test_Score__c,Work_Experience_Total__c from Opportunity where Start_Term__c=:sterm and StageName IN:stages limit 1';                
        
       try{ 
       test.startTest(); 
        BatchupdateCams_createApplicant bca=new BatchupdateCams_createApplicant();
        database.executebatch(bca);
        test.stopTest();
        }catch(Exception e){System.debug(e+'');}*/
    
    
    
    
    ALL_API.SFImporterDeclaration impd=new ALL_API.SFImporterDeclaration();
      impd.ApplicantId='12345';
      impd.FirstName='test';
      impd.LastName='test';
      //impd.PreferredName=opp.Name;//blank
      impd.Campus='London';
      impd.StartTerm='tb2013';
      impd.Gender='test';
      //impd.GpaGroup=opp.Program_pre_Parsed__c;//
      //impd.AttendanceType=opp.Program_pre_Parsed__c;
      impd.ProgramPreParsed='MBA';
     ALL_API.apiresponse result=new ALL_API.apiresponse();
          
          opportunity.Activate_My_Hult__c=true;
          opportunity.Primary_Campus__c='Dubai';
          opportunity.Reset_Password__c='yes';
          try
          {            string ept='http://54.86.247.117/apis/student';
            result=ALL_API.Hult_API_callout(Json.serialize(impd),opportunity.Id+'',ept);
          }catch(Exception e){System.debug(e);}
    }
    static testMethod void Junior_Program() 
    {
        Program__c pgm;
        try{
            pgm=[select id,Name from Program__c where name='Junior' limit 1];
        }
        catch(Exception e)
        {
            pgm=[select id,Name from Program__c limit 1];    
        }
        
        contact ctct=TestDataUtil.createContact(pgm.Id);
        ctct.Applicant_Email__c='contact2opportunity_test_2@test.com';
        insert ctct;  
        
        Opportunity opportunity = new Opportunity();
        opportunity.Contact__c = ctct.Id;
        opportunity.Name = 'OpportunityName';
        opportunity.StageName = 'StageName';
        opportunity.CloseDate = Date.today();
        opportunity.Program__c = pgm.Id;
        insert opportunity;
        
        ctct.Linked_In_Status__c='test';
        ctct.Start_Term__c='September 2014';
        update ctct;
    }
}