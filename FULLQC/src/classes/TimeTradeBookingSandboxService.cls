@RestResource(urlMapping='/hultttradesandboxservice/*')
global  class TimeTradeBookingSandboxService {
    
//NUAGE GROUP:082013: For Hult Project, to integrate with TimeTrade 
//NUAGE GROUP:082013: Uses TimeTradeService class to consume external TT data from TimeTrade Staging

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
             
               Datetime d=datetime.newInstance(var.appt.scheduledEndTime);
        
                Assessment_un_Sandbox__c tss=new Assessment_un_Sandbox__c();
            
                tss.Date__c=Date.newInstance(d.year(),d.month(),d.day());
                if (var.eventName == 'appointmentBooked'){
                    tss.Status_c__c='Scheduled';
                }
                else if (var.eventName == 'appointmentCanceled'){
                    tss.Status_c__c='Cancelled';
                }        
                else if (var.eventName == 'appointmentChanged'){
                    tss.Status_c__c='Re-scheduled';
                }

                tss.User_Email__c = var.Resources[0].emailAddress;
                tss.Contact_Id_Text__c = var.attendees[0].customValues.Answer0;
                tss.TimeTrade_Event_ID__c=var.appt.confirmationNumber;
                tss.Appointment_Type__c=var.ApptType.name;
                tss.Campus__c=var.location.name;
                tss.Location__c=var.location.address.addressA+' '+var.location.address.addressB+' '+var.location.address.city;
                tss.TT_Event_Type__c=var.eventName;
                tss.End_Time__c=(datetime.newInstance(var.appt.scheduledEndTime)).format('HH:mm a',var.appt.timeZone);
                tss.Start_Time__c=(datetime.newInstance(var.appt.scheduledStartTime)).format('HH:mm a',var.appt.timeZone);
                tss.Request_Endpoint__c =  strEndpointurl;
        
                upsert tss TimeTrade_Event_ID__c;
        
                return '200: Success';        
         }catch(exception e){
                system.debug(e.getmessage());
                return  e.getMessage();
         }        
    }
}