@istest

public class TestTimeTradeBookingService{

     static testMethod void testTimeTradeBookservi(){
     
         User u=createUser('System Administrator','tealaext');
         insert u;
     
         Account acc=new Account();
         acc.Name='test';
         insert acc;
         
         contact c=new contact();
         c.AccountId=acc.id;
         c.lastname='test';
         insert c;
         
         TimeTradeService.Appt app=new TimeTradeService.Appt();
         app.confirmationNumber='AHSHHSHS';
         app.scheduledEndTime=137665980;
         app.scheduledStartTime=13766598;
         app.timeZone='America/New_York';
         
         TimeTradeService.CustomValues_Z cz=new TimeTradeService.CustomValues_Z();
         cz.Answer0=c.id;
         
         List<TimeTradeService.Attendees> lstattendess=new List<TimeTradeService.Attendees>();
         List<TimeTradeService.Resources> lstresources=new List<TimeTradeService.Resources>();
         
         TimeTradeService.Attendees trds=new TimeTradeService.Attendees();
         trds.customValues=cz;
         lstattendess.add(trds);
         
         TimeTradeService.Resources rs=new TimeTradeService.Resources();
         rs.emailAddress=u.Email;
         lstresources.add(rs);
         
         
         TimeTradeService.ApptType apptype=new TimeTradeService.ApptType();
         apptype.name='Event';
         
         
         
         TimeTradeService.Address add=new TimeTradeService.Address();
         add.addressA='Cambridge';
         add.addressB='Seatle';
         add.city='Mumbai';
         
         TimeTradeService.Location tls=new TimeTradeService.Location();
         tls.address=add;
         tls.name='Cambridge';
         
     
         TimeTradeService timetrade=new TimeTradeService();
         timetrade.appt=app;
         timetrade.eventName='appointmentBooked';
         timetrade.apptType=apptype;
         timetrade.attendees=lstattendess;
         timetrade.resources=lstresources;
         timetrade.location=tls;
         
         String JsonMsg=JSON.serialize(timetrade);
   
         Test.startTest();
   
       //As Per Best Practice it is important to instantiate the Rest Context 
   
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = '/services/apexrest/hultttradeservice';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;

 
       TimeTradeBookingService.createTimeTradeEvent(); //Call the Method of the Class with Proper  Constructor 
  
       Test.stopTest();
       
       List<Assessment_un__c> lstass=[Select Id from Assessment_un__c];
       
       system.assert(lstass.size()>0);
     
     }
     
      public static User createUser(String profilename,String alias){
        
        //Create a User Record in Test Class
        Profile p = [SELECT Id FROM Profile WHERE Name=:profilename]; 
        User u = new User(Alias =alias, Email='test@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing'+profilename, LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=alias+'@testorg.com',FirstName='testr',City='Mysore',State='USA',Country='America');
        return u;
    
    }


    static testMethod void testTimeTradeWrapper(){
      
      TimeTradeService  t=new TimeTradeService();
      TimeTradeService.PreviousApptType tp=new TimeTradeService.PreviousApptType();
      TimeTradeService.ApptType app=new  TimeTradeService.ApptType();
      TimeTradeService.PreviousAppt pr=new TimeTradeService.PreviousAppt();
      TimeTradeService.PreviousAttendees prv=new TimeTradeService.PreviousAttendees();
      
      TimeTradeService.PreviousResources prvr=new TimeTradeService.PreviousResources();
      TimeTradeService.PreviousLicensee prvl=new TimeTradeService.PreviousLicensee();
      TimeTradeService.PreviousLocation prvlo=new TimeTradeService.PreviousLocation();
      TimeTradeService.Producer pro=new TimeTradeService.Producer();
      TimeTradeService.CustomValues cv=new TimeTradeService.CustomValues();    
      TimeTradeService.Licensee li=new TimeTradeService.Licensee();
      TimeTradeService.FulfillmentLog fl=new TimeTradeService.FulfillmentLog();
      TimeTradeService.EventToken et=new TimeTradeService.EventToken();
    
    }



}