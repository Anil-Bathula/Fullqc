@RestResource(urlMapping='/hultttradeservice/*')
global  class TimeTradeBookingService {
    
//NUAGE GROUP:082013: For Hult Project, to integrate with TimeTrade 
//NUAGE GROUP:082013: Uses TimeTradeService class to consume external TT data from TimeTrade Prod 

@HttpPost
    global static string createTimeTradeEvent() {
    
        //Extracting the data from the JSON HTTP request object sent from Timetrade
        
        RestRequest req = RestContext.request;
        RestResponse res=RestContext.response;
        Blob body=req.requestBody;
        String jsonToParse=body.toString();  
        
        jsonToParse=jsonToParse.replace('class','classx'); 
        jsonToParse=jsonToParse.replace('limit','limitx');
        jsonToParse=jsonToParse.replace('_externalIDs','externalIDs');    
            
        try{
        //Deserializing the data sent into concrete SFDC objects
                TimeTradeService var =(TimeTradeService)JSON.deserialize(jsonToParse,TimeTradeService.class);
       // Map<string, string> strEndpointurl =    new Map<String, String>();
                system.debug('value'+var );
                string strEndpointurl = req.remoteAddress;
                system.debug('HEADER MAP'+ req.headers);
                         
                Datetime d=(datetime.newInstance(var.appt.scheduledEndTime));   
                String formatteddate=d.format('yyyy-MM-dd HH:mm:ss',var.appt.timeZone); 
                Datetime d2=(datetime.valueof(formatteddate));        
                Assessment_un__c ts=new Assessment_un__c();
            
                ts.Date__c=(Date.newInstance(d2.year(),d2.month(),d2.day())); 
                if (var.eventName == 'appointmentBooked'){
                    ts.Status_c__c='Scheduled';
                }
                else if (var.eventName == 'appointmentCanceled'){
                    ts.Status_c__c='Cancelled';
                }        
                else if (var.eventName == 'appointmentChanged'){
                    ts.Status_c__c='Re-scheduled';
                }

                ts.User_Email__c = var.Resources[0].emailAddress;
                ts.Contact_Id_Text__c = var.attendees[0].customValues.Answer0;
                ts.TimeTrade_Event_ID__c=var.appt.confirmationNumber;
                ts.Appointment_Type__c=var.ApptType.name;
                ts.Campus__c=var.location.name;
                ts.Location__c=var.location.address.addressA+' '+var.location.address.addressB+' '+var.location.address.city;
                ts.TT_Event_Type__c=var.eventName;
                ts.End_Time__c=(datetime.newInstance(var.appt.scheduledEndTime)).format('HH:mm a',var.appt.timeZone);
                ts.Start_Time__c=(datetime.newInstance(var.appt.scheduledStartTime)).format('HH:mm a',var.appt.timeZone);
                ts.Request_Endpoint__c =  strEndpointurl;
                ts.Processed__c = false;
        
                upsert ts TimeTrade_Event_ID__c;
                
                return '200: Success';        
          }catch(exception e){
                system.debug(e.getmessage());
                return  e.getMessage();
          }        
     }
}