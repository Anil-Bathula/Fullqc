/*
    Class     : ALL_API
    Developer : Harsha Simha S
    Date      : 6/10/2013
    Comment   : This class has innerclass of values to be passed to API and response captured from api.
                 createApplicant method Makes api callout and response is returned back. 
                 If error error response is sent back and those values are stored in HULT_API_Log__c object.   
    TestClass : Hult_Apicalls_Test(89%) 
              
    Note      : We can make only 10 callouts in 1 run and only 1 record fires in a trigger.                 
*/
public with sharing class ALL_API 
{
 
   /*Inner class for CreateApplicant in cams Parameters to be passed.*/ 
    public class SFImporterDeclaration
    {
        public string ApplicantId{get;set;}
        public string FirstName{get;set;}
        public string LastName{get;set;}
        public string PreferredName{get;set;}
        public string Gender{get;set;}
        public date BirthDate{get;set;}
        public string Campus{get;set;}
        public string ProgramPreParsed{get;set;}
        public string StartTerm{get;set;}
        public string GpaGroup{get;set;}
        public string Degree{get;set;}
        public string CountryOfOrigin{get;set;}
        public string AttendanceType{get;set;}
        public string MailingStreet{get;set;}
        public string MailingCountry{get;set;}
        public string MailingCity{get;set;}
        public string MailingPostalCode{get;set;}
        public string ApplicantEmail{get;set;}
        public string AdmissionTestType{get;set;}
        public string LanguageType{get;set;}
        public string AdmissionTestWaiver{get;set;}
        public string AdmissionTestScore{get;set;}
        public string LanguageTestScore{get;set;}
        public string LanguageTestWaiver{get;set;}
        public string IndustrySector{get;set;}
        public double WorkExperience{get;set;}
        public string HighestDegreeAttained{get;set;}
        public string RecruiterName{get;set;}
        public string RecruiterEmail{get;set;}
        public string CountryOfCitizenship{get;set;}  
        public boolean Matriculated{get;set;}    
    }
    
    /*Inner class for common response to be passed back for all api callouts*/
    public class apiresponse
    {
        public boolean iserror{get;set;}
        public integer statuscode{get;set;}
        public string status{get;set;}
        public string recid{get;set;}
        public string endpointurl{get;set;}
        public datetime reqtime{get;set;}
    }
    
    //http://myhultdevservices.hult.edu/apis/RestApi/UpdatePayment
    public class TCASPaymentInfo
    {
        public string StudentId { get; set; }
        public double Balance { get; set; }
        public DateTime TransactionDate { get; set; }
    }
   /* 
    //Inner class for ActivateMyHult,omlistener,stagechange,resetpassword API
    public class ActivateMyHult_Declaration
    {
        public string StudentId{ get; set; }
        public boolean ActivateMyHult { get; set; }
        public boolean ActivateMyHultSpecified { get; set; }
        public string ContactId { get; set; }
    }
    
    
    
    //http://54.86.247.117/apis/StudentVisa
    public class Studentvisainfo
    {
        public string AppID{get;set;} 
        public DateTime  Birthdatefromcontact{get;set;} 
        public string CASNumber{get;set;}
        public string CountryOfcitizenship{get;set;} 
        public string DependentsJoining{get;set;} 
        public string FamilyNamepassport{get;set;}
        public string FirstNamefromcontact{get;set;} 
        public string GivenNamespassport{get;set;}
        public double JW202Number{get;set;} 
        public string Language{get;set;} 
        public DateTime PassportExpirationchinabound{get;set;} 
        public string PassportNumber{get;set;}
        public string Primarycampus{get;set;} 
        public string ReasonNoVisaRequired{get;set;} 
        public string SEVISNumber{get;set;} 
        public string StudentVisaStatuschinaBound{get;set;} 
        public string StudentVisaStatusUKBoundOnly{get;set;} 
        public string StudentVisaStatus{get;set;} 
        public DateTime VisaExpirationDate{get;set;}        
    }*/
    
    /*API Callout method which recives endpoint,body and record for which callout is done */
    public static apiresponse Hult_API_callout(string bdy,string recid,string endpoint)
    {
        apiresponse returnval=new apiresponse(); 
         
        Http h=new Http();
        Httprequest req=new Httprequest();
       // req.setEndpoint('http://myhultdevservices.hult.edu/apis/RestApi/ResetApplicantPassword');
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setTimeout(120000 );
        req.setHeader('Content-Type', 'application/Json'); 
        req.setBody(bdy);
        Httpresponse res=new Httpresponse();
        system.debug(bdy);
        System.debug(req);
        try
        {
            if(!test.isRunningTest())
            {
                res =h.send(req);
            }
            else
            {
                res.setStatusCode(330);
                res.setStatus('Testing from Test class');
            }
            System.debug(res+'---'+res.getBody());
            returnval =geterror_responses(res.getStatusCode()!=200,recid, res.getStatus()+'---'+res.getBody(),res.getStatusCode(),req.getEndpoint(),System.now());
            
            
        }
        catch(Exception e)
        {
            String err=''+e;
            system.debug(e);
            returnval =geterror_responses(true,recid, ''+e,0, req.getEndpoint(), system.now());            
        }
        
        return returnval;
    }
    
    /*This method returns apiresponse class with values.*/
    public static apiresponse geterror_responses(boolean iserr,string recid,string err_Status,integer err_StatusCode,string endpoint,Datetime dtime)
    {
        apiresponse returnval=new apiresponse(); 
        returnval.iserror=iserr;
        returnval.recid=recid;
        returnval.status=err_Status;
        returnval.statuscode=err_StatusCode;
        returnval.endpointurl=endpoint;
        returnval.reqtime=dtime;
        
        return returnval;
    }
}