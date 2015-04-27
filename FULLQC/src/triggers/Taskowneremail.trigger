trigger Taskowneremail on Task (after insert) { 

/************************************************************************
Trigger    : Taskowneremail
written By : Anil.B
Purpose    : To send a Email alert to the opportunity owner .
when a task is created under opportunity with subject general question,one to one consultaion,
Student application support request.
*************************************************************************/

Set<Id> sobjectSetOfIds = new Set<Id>();

//checking for conditions
 if(Trigger.IsInsert){
     for(Task tk:Trigger.New){          
        if(tk.Whatid!=null && tk.status!='Completed' && tk.Subject!=null &&(tk.Subject.Contains('General question') || tk.Subject.Contains('One to one consultation') || tk.Subject.Contains('Student Application Support Request'))){
           String s=tk.whatid;
           if(s.Startswith('006')){
            sobjectSetOfIds.add(tk.whatid);
           }           
        }    
     }
     if(!sobjectSetOfIds.IsEmpty()){
          Opportunity opp=[Select id,Name,StageName,Owner.Name,Contact__r.Name,Contact__c,Contact__r.EMail,Contact__r.Phone from Opportunity where Id in : sobjectSetOfIds];
           String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Contact__c;
           System.debug('+++>'+fullRecordURL );
            for(Task t:trigger.new)      {                
                 
                   // sending email with subject and body  
                        messaging.Singleemailmessage mail=new messaging.Singleemailmessage();       
                        String Subject='A candidate has a query for you';
                        String emailBody = 'Dear ' + opp.Owner.Name + ',\n\n' +
                                        'Your Applicant:'+' '+Opp.Contact__r.Name+' with Stage'+'-'+ opp.StageName+' has requested a subject of the task through hult.edu.' + '\n' +
                                        'Question from the applicant: '+' '+t.Description+'\n\n'+
                                        'Subject:'+' '+t.Subject+'\n'+
                                        'Email:'+' '+opp.Contact__r.EMail+ '\n' +
                                        'Phone:'+' '+Opp.Contact__r.Phone+' \n'+                                         
                                        'URL:'+' '+fullRecordURL+'\n\n\n' +                                   
                                        'Thanks'+'\n'+
                                        'HULT'+''; 
                        
                        
                     
                        mail.setSenderDisplayName('Hult');     
                        mail.setSubject(subject);
                        mail.setPlainTextBody(emailBody);   
                        mail.setTargetObjectId(opp.Ownerid); 
                        mail.saveAsActivity = false;
                       
                        try{ 
                            messaging.sendEmail(new messaging.Singleemailmessage[]{mail}); 
                        }catch(DMLException e){ 
                            system.debug('ERROR SENDING FIRST EMAIL:'+e.getDMLMessage(0)); 
                        } 
                
                
                    
                

          }                      
     }
    
}      
}