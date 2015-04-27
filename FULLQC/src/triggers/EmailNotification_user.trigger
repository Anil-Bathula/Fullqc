/*
Author         : Premanath Reddy
Created Date   : 3/13/2013
Purpose        : To send a Email Notification to the Wynn Team .
                 when a new user is created in SF or every time an existing user is de-activated
                 or profile/role changes in SF
Modified by    : Anil.B -28/8/2013 
Test class     : EmailNotification_user_Test

Last Modified Prem:- SFSUP-670 :: Added Ruth Loftus(ruth.loftus@hult.edu) to the email distribution list of the email alerts.
                And Email alerts do not send for these profiles aslo 'Hult Career Point Student Profile' and 'Student Portal'.
Modified by prem :SFSUP-671(11/11/2013) ::"I have added these three new fields to the email template that gets sent out to us when a record is changed (activation, termination, updated).
1. RegionOfficeWorkIn__c
2. Product__c
3. Manager
And updated senders Name from Hult to "noreply@salesforce.com On Behalf Of Hult"
*/
trigger EmailNotification_user on User (after insert,after update) {
    String activeuser;
    String profilechange;
    String rolechange;
    String inactiveuser;
    String activated;
    Boolean boolvar;
    if(Trigger.isInsert){
        Map<String,String> varmap=new Map<String,String>();
        List<User> usr=[Select id,Name,Manager.Name from User where id in:Trigger.New];
        for(User u1:usr){
            varmap.put(u1.id,u1.Manager.Name);
        }
        for(User u:Trigger.New){
            if(Trigger.NewMap.get(u.id).Profile_Name__c!='Applicant Customer Portal User'
               && Trigger.NewMap.get(u.id).Profile_Name__c!='Hult Career Point Student Profile'
               && Trigger.NewMap.get(u.id).Profile_Name__c!='Student Portal'){
                //User usr=[Select id,Name from User where id=:u.ManagerId];
                String emailBody;
                           //'Dear Wynn Team'+ ',\n\n' +
                           // Subject+'\n\n'+
                emailBody=  'Name:'+' '+u.FirstName+' '+u.LastName+'\n'+
                            'Email:'+' '+u.Email+ '\n' +
                            'Profile:'+' '+u.Profile_Name__c+'\n'+
                            'Role:'+' '+u.Role_Name__c+'\n'+
                            'Manager:'+' '+varmap.get(u.id)+ '\n'+
                            'Regional Office Work In:'+' '+u.RegionOfficeWorkIn__c+'\n'+
                            'Product:'+' '+u.Product__c;
                            //'HULT Admin'+''; 
                if(activeuser==null){
                    activeuser=emailBody;
                }
                else{
                    activeuser+=emailBody;
                }
                boolvar=true;
            }
        }
    }
    if(Trigger.isUpdate){
        Map<String,String> varmap=new Map<String,String>();
        List<User> usr=[Select id,Name,Manager.Name from User where id in:Trigger.New];
        for(User u1:usr){
            varmap.put(u1.id,u1.Manager.Name);
        }
        for(User u:Trigger.New){
            //System.Debug(u.FirstName+'*****'+u.LastName+'*******'+u.ManagerId);
            if(((Trigger.NewMap.get(u.id).IsActive!=Trigger.OldMap.get(u.id).IsActive)
                || (Trigger.NewMap.get(u.id).Profile_Name__c!=Trigger.OldMap.get(u.id).Profile_Name__c && Trigger.NewMap.get(u.id).IsActive==true) 
                || (Trigger.NewMap.get(u.id).Role_Name__c!=Trigger.OldMap.get(u.id).Role_Name__c && Trigger.NewMap.get(u.id).IsActive==true))
                && Trigger.NewMap.get(u.id).Profile_Name__c!='Applicant Customer Portal User'
                && Trigger.NewMap.get(u.id).Profile_Name__c!='Hult Career Point Student Profile'
                && Trigger.NewMap.get(u.id).Profile_Name__c!='Student Portal'){
                //User usr=[Select id,Name from User where id=:u.ManagerId];
                String emailBody;
                if(Trigger.NewMap.get(u.id).Profile_Name__c!=Trigger.OldMap.get(u.id).Profile_Name__c && Trigger.NewMap.get(u.id).IsActive==true){
                    emailBody = 'Status: ACTIVE'+'\n'+
                                'Name:'+' '+u.FirstName+' '+u.LastName+'\n'+
                                'Email:'+' '+u.Email+ '\n' +        
                                'Profile:'+' '+u.Profile_Name__c+'\n'+
                                'Role:'+' '+u.Role_Name__c+'\n'+
                                'Manager:'+' '+varmap.get(u.id)+ '\n'+
                                'Regional Office Work In:'+' '+u.RegionOfficeWorkIn__c+'\n'+
                                'Product:'+' '+u.Product__c+'\n\n';
                    if(profilechange==null){
                        profilechange=emailBody;
                    }
                    else{
                        profilechange+=emailBody;
                    }
                }
                if(Trigger.NewMap.get(u.id).Role_Name__c!=Trigger.OldMap.get(u.id).Role_Name__c && Trigger.NewMap.get(u.id).IsActive==true){
                    emailBody = 'Status: ACTIVE'+'\n'+
                                'Name:'+' '+u.FirstName+' '+u.LastName+'\n'+
                                'Email:'+' '+u.Email+ '\n' +        
                                'Profile:'+' '+u.Profile_Name__c+'\n'+
                                'Role:'+' '+u.Role_Name__c+'\n'+
                                'Manager:'+' '+varmap.get(u.id)+ '\n'+
                                'Regional Office Work In:'+' '+u.RegionOfficeWorkIn__c+'\n'+
                                'Product:'+' '+u.Product__c+'\n\n';
                    if(rolechange==null){
                        rolechange=emailBody;
                    }
                    else{
                        rolechange+=emailBody;
                    }
                }
                if(Trigger.NewMap.get(u.id).IsActive!=Trigger.OldMap.get(u.id).IsActive && Trigger.NewMap.get(u.id).IsActive==false){
                    emailBody = 'Status: INACTIVE'+'\n'+
                                'Name:'+' '+u.FirstName+' '+u.LastName+'\n'+
                                'Email:'+' '+u.Email+ '\n' +        
                                'Profile:'+' '+u.Profile_Name__c+'\n'+
                                'Role:'+' '+u.Role_Name__c+'\n'+
                                'Manager:'+' '+varmap.get(u.id)+ '\n'+
                                'Regional Office Work In:'+' '+u.RegionOfficeWorkIn__c+'\n'+
                                'Product:'+' '+u.Product__c+'\n\n';
                    if(inactiveuser==null){
                        inactiveuser=emailBody;
                    }
                    else{
                        inactiveuser+=emailBody;
                    }
                }
                if(Trigger.NewMap.get(u.id).IsActive!=Trigger.OldMap.get(u.id).IsActive && Trigger.NewMap.get(u.id).IsActive==True){
                    emailBody = 'Status: ACTIVE'+'\n'+
                                'Name:'+' '+u.FirstName+' '+u.LastName+'\n'+
                                'Email:'+' '+u.Email+ '\n' +        
                                'Profile:'+' '+u.Profile_Name__c+'\n'+
                                'Role:'+' '+u.Role_Name__c+'\n'+
                                'Manager:'+' '+varmap.get(u.id)+ '\n'+
                                'Regional Office Work In:'+' '+u.RegionOfficeWorkIn__c+'\n'+
                                'Product:'+' '+u.Product__c+'\n\n';
                    if(activated==null){
                        activated=emailBody;
                    }
                    else{
                        activated+=emailBody;
                    }
                }
                boolvar=true;
            }
        }
    }
    if(boolvar==true){
        List<User> usr=[select id,Name,Email,Notify_on_user_create__c from user where Notify_on_user_create__c=true];
        if(!usr.isEmpty()){
            List<String> emaillst=new List<String>();
            for(User u:usr){
                emaillst.add(u.Email);                
            }
            //emaillst.add('ruth.loftus@hult.edu');
            //emaillst.add('premanatha.m@gmail.com'); 
            String str='Dear Wynn Team'+'\n\n';
            String Subject;
            if(activeuser!=null){
                Subject='A new User has been created';
                str+='A new User has been created'+'\n\n';
                str+=activeuser;
            }
            if(profilechange!=null){
                Subject='The following user has been updated:';
                str+='A following user Profile has been changed'+'\n\n';
                str+=profilechange;
            }
            if(rolechange!=null){
                Subject='The following user has been updated:';
                str+=' A following user Role has been changed'+'\n\n';
                str+=rolechange;
            }
            //Changed the wording Inactivated to deactivated Anil.B on 28/8/2013
            if(inactiveuser!=null){
                Subject='The following user has been Deactivated:';  
                str+='The following user has been Deactivated:'+'\n\n';
                str+=inactiveuser;
            }
            if(activated!=null){
                Subject='The following user has been Activated:';
                str+='The following user has been Activated:'+'\n\n';
                str+=activated;
                
            }
             //Added Action performed line in the mail body by Anil.B on 28/8/2013
            str+='Action Performed by: '+UserInfo.getName();
            str+='\n\n\nHULT Admin';
            if(str.contains('null')){
                str=str.replace('null','');
            }
            
            messaging.Singleemailmessage mail=new messaging.Singleemailmessage();
            //String[] toAddresses = new String[] {'sophie.daunais@hult.edu','daniel.mora@hult.edu','charlotte.pandraud@hult.edu','meghan.shoemaker@hult.edu'};
            mail.setToAddresses(emaillst);
            mail.setSenderDisplayName('noreply@salesforce.com On Behalf Of Hult');
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSubject(subject);
            mail.setPlainTextBody(str);
            try{ 
                messaging.sendEmail(new messaging.Singleemailmessage[]{mail}); 
            }
            catch(DMLException e){ 
                system.debug('ERROR SENDING EMAIL:'+e); 
            } 
        }
    }
}