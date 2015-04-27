/*
    Class     : HultAPI_calls_from_trigger
    Developer : Harsha Simha S
    Date      : 6/10/2013
    Comment   : This class contains future method which is called from trigger which gathers 
                all the opp/contact ids and gathers opportunity values and calls ALL_API.createApplicant method to make API callout    
    TestClass : Hult_Apicalls_Test(91%)
              
    Note      : We can make only 10 callouts in 1 run and only 1 record fires in a trigger.                 
    
    *********************************************************************************************************************************************************************
    EndPint type             ======                             DEV URL                                         ======                PRODUCTION URL
    *********************************************************************************************************************************************************************
    camsapplicant_endpoint   ======  http://54.86.247.117/apis/Student                                          ======    http://209.196.29.102/apis/Student
    Activatemyhult_endpoint  ======  http://myhultdevservices.hult.edu/apis/RestApi/ActivateMyHult              ======
    resetpwd_endpoint        ======  http://myhultdevservices.hult.edu/apis/RestApi/ResetApplicantPassword      ======
    stagechange_endpoint     ======  http://myhultdevservices.hult.edu/apis/RestApi/StudentAppStageChange       ======
    omlistener_endpoint      ======  http://myhultdevservices.hult.edu/apis/RestApi/OMListener                  ======
    tcas_endpoint            ======  http://myhultqaservices.hult.edu/apis/RestApi/UpdatePayment                ======    http://54.85.153.47:8001/apis/restapi/updatepayment
    
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
*/
public with sharing class HultAPI_calls_from_trigger 
{
    public static final string CAMS_Start_term =getvalue('CAMS_Start_term');//'September 2015';    
    public static final string camsapplicant_endpoint=getvalue('camsapplicant_endpoint');//'http://54.86.247.117/apis/Student';
    public static final string Activatemyhult_endpoint=getvalue('Activatemyhult_endpoint');//'http://myhultdevservices.hult.edu/apis/RestApi/ActivateMyHult';
    public static final string resetpwd_endpoint=getvalue('resetpwd_endpoint');//'http://myhultdevservices.hult.edu/apis/RestApi/ResetApplicantPassword';
    public static final string stagechange_endpoint=getvalue('stagechange_endpoint');//'http://myhultdevservices.hult.edu/apis/RestApi/StudentAppStageChange';
    public static final string omlistener_endpoint=getvalue('omlistener_endpoint');//'http://myhultdevservices.hult.edu/apis/RestApi/OMListener';
    public static final string separator='!!Endpoint_Seperator!!';
    public static final string tcas_endpoint=getvalue('tcas_endpoint');//'http://myhultqaservices.hult.edu/apis/RestApi/UpdatePayment';
    
    public static string getvalue(string key){
        //As custom settings are not accessible from Test class unless seealldata, used this method in the code
        //instead of in test class as this method can be called from any test class that fires the related trigger.
        string retval;
        if(Test.isRunningTest()){
            retval=Key=='CAMS_Start_term'?'September 2015':'http://54.86.247.117/apis/Student';
        }else{
            HULT_API_CALL__c ha=HULT_API_CALL__c.getInstance(key);
            retval=ha.value__c;
        }
        return retval;
    }
    
    @future(callout=true)
    public static void CreateApplicant_inCAMS(list<string> oppids)
    {
        CreateApplicant_inCAMS_nofuture(oppids);
    }
    public static void CreateApplicant_inCAMS_nofuture(list<string> oppids)
    {
        List<HULT_API_Log__c> logs=new List<HULT_API_Log__c>();
        
        string sterm=CAMS_Start_term;//'September 2014';
        list<string> stages=new List<String>{'Confirmed','Conditionally Confirmed','Soft Rejected Confirmed'};
            
        list<Opportunity> opps=[select id,Admission_Test_Waiver__c,App_ID__c,Applicant_Email__c,Birthdate_from_Contact__c,Country_Of_Citizenship__c,Country_Of_Origin__c,
                            First_Name_from_Contact__c,Gender__c,Highest_Degree_Attained__c,Industry_Sector__c,Language_Test_Waived__c,Language_Test_Waiver__c,
                            Last_Name_from_Contact__c,Mailing_Address_Application__c,Mailing_Address__c,Mailing_City_from_Contact__c,Mailing_Country_from_contact__c,
                            Mailing_Postal_Code_from_Contact__c,Mailing_State_from_Contact__c,Mailing_Street_from_Contact__c,Matriculated__c,Name,Owner_Email__c,
                            Owner_Name__c,Primary_Campus__c,Program_pre_Parsed__c,Start_Term__c,Type_of_Validated_Admission_Test__c,Type_of_Validated_Language__c,
                            Validated_Admission_Test_Score__c,Validated_Language_Test_Score__c,
                            Work_Experience_Total__c from Opportunity where (id IN:oppids or Contact__c IN:oppids) and (Start_Term__c=:sterm and StageName IN: stages)];
        for(Opportunity opp:opps)
        {
            ALL_API.SFImporterDeclaration impd=new ALL_API.SFImporterDeclaration();
            impd.ApplicantId=opp.App_ID__c;
            impd.FirstName=opp.First_Name_from_Contact__c;
            impd.LastName=opp.Last_Name_from_Contact__c;
            impd.PreferredName=opp.First_Name_from_Contact__c;
            impd.Campus=opp.Primary_Campus__c;      
            impd.StartTerm=opp.Start_Term__c;//'tb2013';
            impd.Gender=opp.Gender__c;
            //impd.GpaGroup=opp.Program_pre_Parsed__c;//
            //impd.AttendanceType=opp.Program_pre_Parsed__c;
            impd.ProgramPreParsed=opp.Program_pre_Parsed__c;
            //impd.Degree=opp.Program_pre_Parsed__c;
            impd.BirthDate=opp.Birthdate_from_Contact__c;
            impd.CountryOfOrigin=opp.Country_Of_Origin__c   ;        
            impd.MailingStreet=opp.Mailing_Street_from_Contact__c;
            impd.ApplicantEmail=opp.Applicant_Email__c;
            impd.MailingCountry=opp.Mailing_Country_from_contact__c;
            impd.MailingCity=opp.Mailing_City_from_Contact__c;
            impd.MailingPostalCode=opp.Mailing_Postal_Code_from_Contact__c;
            impd.AdmissionTestType=opp.Type_of_Validated_Admission_Test__c;
            impd.LanguageType=opp.Type_of_Validated_Language__c;
            impd.AdmissionTestScore=opp.Validated_Admission_Test_Score__c;
            impd.AdmissionTestWaiver=opp.Admission_Test_Waiver__c;
            impd.LanguageTestScore=opp.Validated_Language_Test_Score__c;
            impd.LanguageTestWaiver=opp.Language_Test_Waiver__c;
            impd.HighestDegreeAttained=opp.Highest_Degree_Attained__c;
            impd.IndustrySector=opp.Industry_Sector__c;
            impd.WorkExperience=opp.Work_Experience_Total__c;
            impd.RecruiterName=opp.Owner_Name__c;
            impd.RecruiterEmail=opp.Owner_Email__c;
            impd.CountryOfCitizenship=opp.Country_Of_Citizenship__c;
            impd.Matriculated=opp.Matriculated__c;
            
            ALL_API.apiresponse result=new ALL_API.apiresponse();
           // string endpoint='http://54.86.247.117/apis/student';//dev server url
           //string endpoint='http://209.196.29.102/apis/Student';//production server url
            try
            {
                
                result=ALL_API.Hult_API_callout(Json.serialize(impd), ''+opp.Id, camsapplicant_endpoint);             
                //result=ALL_API.createApplicant(impd,opp.Id+'');   
               // if(result.statuscode!=200)
                //{
                    logs.add(return_log(result.reqtime,result.endpointurl,''+opp.Id,result.status,''+result.statuscode));
                //}
            }
            catch(Exception e)
            {
                if(result==null || result.statuscode==null )
                {
                    logs.add(return_log(System.now(),camsapplicant_endpoint,''+opp.Id,''+e,'0'));                                 
                }
            }           
            
            System.debug('---------============='+result);
        }
        
        if(!logs.IsEmpty())
        {
            try
            {
                insert logs;
            }catch(Exception e){}
        }
    }
    
    /*tcas*/
    @future(callout=true)
    public static void tcaspayment_APIcall(list<string> list_ftt)
    {
        //map<string,set<string>> oppidsmap =new map<string,set<string>>();
        List<HULT_API_Log__c> logs=new List<HULT_API_Log__c>();
        
        List<Finance_Transactions__c> lft=[select id,Name,Amount_Received_New__c,Finance__c,Finance__r.Accommodation_weeks__c,Finance__r.Housing_Accommodation__c,Amount_Received__c,
                                            LastModifiedDate,Finance__r.Opportunity__c,Finance__r.Opportunity__r.App_ID__c from Finance_Transactions__c where id IN:list_ftt and 
                                            Finance__r.Accommodation_weeks__c!=null and Finance__r.Housing_Accommodation__c!=null];
        if(lft.isEmpty())
            return;
            
        for(Finance_Transactions__c ft:lft)
        {
            ALL_API.TCASPaymentInfo tcas=new ALL_API.TCASPaymentInfo();
            tcas.StudentId=ft.Finance__r.Opportunity__r.App_ID__c;
            tcas.Balance =ft.Amount_Received_New__c;
            tcas.TransactionDate=ft.LastModifiedDate;   
            ALL_API.apiresponse result=new ALL_API.apiresponse(); 
            string oppid=ft.Finance__r.Opportunity__c;
            try
            {     
                result=ALL_API.Hult_API_callout(Json.serialize(tcas), oppid, tcas_endpoint);             
                    //result=ALL_API.ActivateMyHult(decl,opp.Id+'');    
               // if(result.statuscode!=200)
                //{
                        logs.add(return_log(result.reqtime,result.endpointurl,''+oppId,result.status,''+result.statuscode));
                //}
            }
            catch(Exception e)
            {               
                logs.add(return_log(System.now(),tcas_endpoint,''+oppId,''+e,'0'));
            }           
                
        }
        if(!logs.IsEmpty())
        {
            try
            {
                insert logs;
            }catch(Exception e){}
        }
    
        
    }
    
    /*
    @future(callout=true)
    public static void myHult_APIcall(map<Id,string> oppidsmap)
    {
        //map<string,set<string>> oppidsmap =new map<string,set<string>>();
        List<HULT_API_Log__c> logs=new List<HULT_API_Log__c>();
        list<Opportunity> opps=[select id,App_ID__c,Activate_My_Hult__c,Contact__c,Name,Work_Experience_Total__c from Opportunity where id IN:oppidsmap.keyset()];
        for(Opportunity opp:opps)
        {
            ALL_API.ActivateMyHult_Declaration decl=new ALL_API.ActivateMyHult_Declaration();
            decl.ActivateMyHult=opp.Activate_My_Hult__c;
            decl.ActivateMyHultSpecified=opp.Activate_My_Hult__c;
            decl.StudentId=opp.App_Id__c;
            decl.ContactId=opp.Contact__c;
            
            string temp=oppidsmap.get(opp.Id);
            List<string> endpoints=(temp!=null&&temp.contains(separator))?temp.split(separator):new list<string>();
            
            for(string endpoint:endpoints)
            {
                
                ALL_API.apiresponse result=new ALL_API.apiresponse();   
                //string endpoint=endpoints.get(i); //'http://myhultdevservices.hult.edu/apis/RestApi/ActivateMyHult';
                endpoint=endpoint!=null?endpoint.trim():endpoint;        
                try
                {     
                    result=ALL_API.Hult_API_callout(Json.serialize(decl), ''+opp.Id, endpoint);             
                    //result=ALL_API.ActivateMyHult(decl,opp.Id+'');    
                    if(result.statuscode!=200)
                    {
                        logs.add(return_log(result.reqtime,result.endpointurl,''+opp.Id,result.status,''+result.statuscode));
                    }
                }
                catch(Exception e)
                {               
                    logs.add(return_log(System.now(),endpoint,''+opp.Id,''+e,'0'));
                }           
                
                System.debug('---------============='+result);
            }
        }
        
        
        if(!logs.IsEmpty())
        {
            try
            {
                insert logs;
            }catch(Exception e){}
        }
    }*/
    /**/
    /*
    @future(callout=true)
    public static void StudentVisa_APIcall(list<string> oppids)
    {
        List<HULT_API_Log__c> logs=new List<HULT_API_Log__c>();
        list<Opportunity> opps=[select id,Admission_Test_Waiver__c,App_ID__c,Applicant_Email__c,Birthdate_from_Contact__c,Country_Of_Citizenship__c,Country_Of_Origin__c,
                                First_Name_from_Contact__c,Gender__c,Highest_Degree_Attained__c,Industry_Sector__c,Language_Test_Waived__c,Language_Test_Waiver__c,
                                Given_Names_passport__c,JW_202_Number__c,CAS_Number__c,Dependents_Joining__c,Language__c,Passport_Expiration_China_bound__c,Visa_Expiration_Date__c,
                                Passport_Number__c,Reason_No_Visa_Required__c,Student_Visa_Status_China_Bound__c,Student_Visa_Status_UK_Bound_Only__c,Student_Visa_Status__c,
                                Last_Name_from_Contact__c,Mailing_Address_Application__c,Mailing_Address__c,Mailing_City_from_Contact__c,Mailing_Country_from_contact__c,
                                Mailing_Postal_Code_from_Contact__c,Mailing_State_from_Contact__c,Mailing_Street_from_Contact__c,Matriculated__c,Name,Owner_Email__c,
                                Owner_Name__c,Primary_Campus__c,Program_pre_Parsed__c,Start_Term__c,Type_of_Validated_Admission_Test__c,Type_of_Validated_Language__c,
                                Validated_Admission_Test_Score__c,Validated_Language_Test_Score__c,Work_Experience_Total__c from Opportunity where (id IN:oppids or Contact__c IN:oppids)];
        for(Opportunity opp:opps)
        {
            ALL_API.Studentvisainfo decl=new ALL_API.Studentvisainfo();
            decl.AppID=opp.App_Id__c;
            decl.Birthdatefromcontact=opp.Birthdate_from_Contact__c;
            decl.CASNumber=opp.CAS_Number__c;
            decl.CountryOfcitizenship=opp.Country_Of_Citizenship__c;
            decl.DependentsJoining=opp.Dependents_Joining__c;
            decl.FamilyNamepassport=opp.Family_Name_passport__c;
            decl.FirstNamefromcontact=opp.First_Name_from_Contact__c;
            decl.GivenNamespassport=opp.Given_Names_passport__c;
            decl.JW202Number=opp.JW_202_Number__c;
            decl.Language=opp.Language__c;
            decl.PassportExpirationchinabound=opp.Passport_Expiration_China_bound__c;
            decl.PassportNumber=opp.Passport_Number__c;
            decl.Primarycampus=opp.Primary_Campus__c;
            decl.ReasonNoVisaRequired=opp.Reason_No_Visa_Required__c;
            decl.SEVISNumber=opp.SEVIS_Number__c;
            decl.StudentVisaStatuschinaBound=opp.Student_Visa_Status_China_Bound__c;
            decl.StudentVisaStatusUKBoundOnly=opp.Student_Visa_Status_UK_Bound_Only__c;
            decl.StudentVisaStatus=opp.Student_Visa_Status__c;
            decl.VisaExpirationDate=opp.Visa_Expiration_Date__c;
            ALL_API.apiresponse result=new ALL_API.apiresponse();   
            string endpoint='http://54.86.247.117/apis/StudentVisa';        
            try
            {     
                result=ALL_API.Hult_API_callout(Json.serialize(decl), ''+opp.Id, endpoint);             
                //result=ALL_API.ActivateMyHult(decl,opp.Id+'');    
                if(result.statuscode!=200)
                {
                    logs.add(return_log(result.reqtime,result.endpointurl,''+opp.Id,result.status,''+result.statuscode));
                }
            }
            catch(Exception e)
            {               
                logs.add(return_log(System.now(),endpoint,''+opp.Id,''+e,'0'));
            }           
            
            System.debug('---------============='+result);
        }
        
        if(!logs.IsEmpty())
        {
            try
            {
                insert logs;
            }catch(Exception e){}
        }
    }
    */
    public static HULT_API_Log__c return_log(DateTime dtime,string endpoint,string recid,string status,string scode)
    {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.allowFieldTruncation = true;    
        
        HULT_API_Log__c log=new HULT_API_Log__c();                  
        log.Callout_Time__c=dtime;
        log.EndPoint_URL__c=endpoint;               
        log.Opportunity__c=recId;
        log.Status__c=status;     
        log.Status_Code__c=scode;
        log.setOptions(dml);
        return log;
    }
    
    private static set<string> fired_recs = new set<string>();
    public static boolean has_rec_alreadywaived(string recid) 
    {
        return fired_recs.contains(recid);
    }
    public static void set_rec_waived(string recid) 
    {
        fired_recs.add(recid);
    }
}