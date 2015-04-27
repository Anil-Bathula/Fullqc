/**************
written By : Prem
Purpose    : (SFSUP-816) To send a Email alert to the contact owner when the students enters detais in Campus Visit brocher.
Date       : 3/12/2014
Test class : Taskowneremail_Test(100%)
********************************/
trigger campus_visit_emailalert on Task (after insert) {
    Map<Task,id> tsk=new Map<Task,Id>();
    String rectyepid=RecordTypeHelper.getRecordTypeId('Task','Campus Visit');
    for(Task t:trigger.New){
        if(t.subject!=null){
            if(t.subject.contains('Campus Visit') && t.whoid!=null && t.recordTypeId==rectyepid){
                String s=t.whoid;
                if(s.startsWith('003')){
                    tsk.put(t,t.whoid);
                }
            }
        }
    }
    if(!tsk.isEmpty()){
        Map<Id,Contact> conmap=new Map<Id,Contact>();
        List<Contact> conlst=[Select id,Email,FirstName,LastName,phone,Owner.Name,Owner.Email,Country_Of_Residence_Name__c
                             from Contact where id in:tsk.values()];
        for(Contact c:conlst){
            conmap.put(c.id,c);
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Task t1: tsk.keyset()){
            if(conmap.containsKey(tsk.get(t1))){
                Contact con=conmap.get(tsk.get(t1));
                String campus=t1.Subject.contains('Campus Visit')?t1.Subject.replace('Campus Visit',''):t1.Subject;
                String firstname=con.FirstName==null?'':con.FirstName;
                String lastname=con.LastName==null?'':con.LastName;
                String email=con.Email==null?'':con.Email;
                String phone=con.phone==null?'':con.phone;
                String country=con.Country_Of_Residence_Name__c==null?'':con.Country_Of_Residence_Name__c;
                String city=t1.City__c==null?'':t1.City__c;
                String program=t1.Program__c==null?'':t1.Program__c;
                String description=t1.Description==null?'':t1.Description;
                
                Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                String emailBody = '<html><body><b>Hi ' + con.Owner.Name + '</b>,<br/><br/>' +
                                        'One of your candidates has signed up for a campus visit with the details below:'+'<br/><br/>'+
                                        '<b>Campus:               </b>'+campus+'<br/>'+
                                        '<b>Campus date tour:     </b>'+t1.Campus_Visit_Date__c+'<br/>'+
                                        '<b>First name:           </b>'+firstname+'<br/>'+
                                        '<b>Last name:            </b>'+lastname+'<br/>'+
                                        '<b>Email:                </b>'+email+'<br/>'+
                                        '<b>Contact number:       </b>'+phone+'<br/>'+
                                        '<b>Country of residence: </b>'+country+'<br/>'+
                                        '<b>City:                 </b>'+city+'<br/>'+
                                        '<b>Program of interest:  </b>'+program+'<br/>'+
                                        '<b>Recruiter\'s name:    </b>'+con.Owner.Name+'<br/>'+
                                        '<b>Comments:             </b>'+description+'<br/><br/>'+
                                        'To ensure that your candidate has the best possible experience at the campus visit, please make sure to call him/her beforehand to:<br/><br/>'+
                                        '<ul> <li>Answer any questions on application, fee, and scholarships the prospective student might have. Campus staff cannot respond to any questions on these topics, so it is important that the candidate discusses any queries with you or another member of admission/recruitment staff.</li>'+
                                        '<li> Encourage the prospective student to be on time for the campus tour. If a candidate is late, they are likely to miss parts of the tour, and may not be able to meet all of the campus staff.</li> </ul>'+
                                        'After the campus visit has taken place, the campus will update Salesforce to reflect ‘attended’ or ‘no-show’—please ensure to make a follow-up call with the candidate around two days after the campus visit.<br/><br/>'+
                                        '<b>Thank you,'+'<br/>'+
                                        'Marketing team </b></body></html>'; 
                
                singleMail.setSubject('Campus visit signed up');
                singleMail.setHtmlBody(emailBody);
                singleMail.setToAddresses(new String[]{con.Owner.Email});
                singleMail.setSaveAsActivity(false);
                if(con.Owner.Name!='S4S APIUSER')
                    emails.add(singleMail);
            }
        }
        //send mail
        if(!emails.isEmpty())
            Messaging.sendEmail(emails);
    }
}