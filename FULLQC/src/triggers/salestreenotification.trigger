/*
  Trigger   : salestreenotification 
  Events    : After Update on Opportunity 
  Test Class : salestreenotification_Test
  Developer : Anil.B
  Date      : 21/5/2013  
  Comment   : To send email notifications to the opportunity owners superiors(reporting to)
  and their reporting to heads when a stage name is changed to Partial Application,Confirmed,
  Admissions Endorsed Confirmed. 
  Modified   :  Anil.B - Added owner.email to the senders list in the code at line 85 on 17/7/13
                 On 15/11/2013---JIRA No:SFSUP-672.
                 on 8/10/2014 ----Changed from BIBA to BBA in If condition.
                 on 17/07/2014---Modified the if condition at line 52 added or condition for field confirmed_date__c=sytem.today()
      Added if condition to stop Recursion of trigger by using (avoid_recursive_syncctctopp_trigg) class. 
      Added Program_Parsed__c in the if condition om 22/07/2014.       
 
  Developer : Harsha Simha S
  Date      : 28/10/2013  
  Enhancement: SFSUP-667::      
              Add extra functionality to the sales tree notifications.
                Fields on User
                No Partial Notifications - Check box
                No Confirmation Notifications - Check box
                1)If No Partial Notifications is true then this user wont be copied in the partial notifications
                2)If No Confirmation Notifications is true then this user wont be copied in the confirmation notifications
               
  Developer : Harsha Simha S
  Date      : 22/4/2014  
  Enhancement: SFSUP-724::      
              The email needs to be triggered when
                1) the ‘Accommodation Stage’ is changed to 2b. Not Interested (Alternative accom.)
                2) The field Hult Fin Aid+Merit % of Tuition is less than 25% (0.25)             
    
    Changes by SHS on 7/3/2014 for SFSUP-745
 
 */

trigger salestreenotification on Opportunity (after update) { 
    
    map<string,String> stnmap=new map<string,String>();
    map<Id,String>Reporting2Ids =new map<ID,String>();     
    map<string,set<string>> owner_relmailids=new map<string,set<string>>();
    map<string,set<string>> sub_owners=new map<string,set<string>>();  
    Map<String,String>sub=new map<String,String>();    
    /*Start SFSUP-667*/ 
    map<string,Boolean> No_Part_Notifications=new map<string,Boolean>();
    map<String,Boolean> No_conf_Notifications =new map<String,Boolean>(); 
    String task_rectype=RecordTypeHelper.getRecordTypeId('Task','Referral');
    /*End SFSUP-667*/
    for(Opportunity op:trigger.new) 
    {
        If(!RecordTypeHelper.isapplicationprocessrecordtype(op.recordtypeid))
            continue;
                
           if(Trigger.IsUpdate ){
                If((Trigger.oldMap.get(op.Id).Stagename!=Trigger.NewMap.get(op.Id).Stagename &&(Trigger.NewMap.get(op.Id).Stagename =='Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Admissions Endorsed Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Conditionally Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Soft Rejected Confirmed')&&(Trigger.NewMap.get(op.Id).Confirmed_Date__c==null ||Trigger.NewMap.get(op.Id).Confirmed_Date__c==system.today()))
                ||
                ((Trigger.oldMap.get(op.Id).Stagename!=Trigger.NewMap.get(op.Id).Stagename) &&Trigger.NewMap.get(op.Id).Stagename=='Partial Application' && (Trigger.NewMap.get(op.Id).Partial_Application_Date__c==System.Today() || Trigger.NewMap.get(op.Id).Partial_Application_Date__c==null)) //(Trigger.oldMap.get(op.Id).Partial_Application_Date__c!=Trigger.NewMap.get(op.Id).Partial_Application_Date__c)
                ||
                Trigger.oldMap.get(op.Id).Stagename=='Withdrawn'&&Trigger.NewMap.get(op.Id).Stagename=='Partial Application'
                ||
                ((Trigger.oldMap.get(op.Id).Accommodation_Status__c!=op.Accommodation_Status__c || op.Hult_Fin_Aid_Merit_of_Tuition__c!=Trigger.oldMap.get(op.Id).Hult_Fin_Aid_Merit_of_Tuition__c) && (op.Accommodation_Status__c=='2b. Not Interested (Financial reasons)' && op.Hult_Fin_Aid_Merit_of_Tuition__c<=25 && op.Program_Parsed__c==custom_lables.Bachelor_Pgm_abvtn))
                ||
                (Trigger.oldMap.get(op.Id).Stagename=='Deferral'||Trigger.oldMap.get(op.Id).Stagename=='Cancellation')&&(Trigger.NewMap.get(op.Id).Stagename=='Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Admissions Endorsed Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Conditionally Confirmed'||Trigger.NewMap.get(op.Id).Stagename=='Soft Rejected Confirmed'))
                {/*SFSUP-724 added condition regarding Accommodation_Status__c,Hult_Fin_Aid_Merit_of_Tuition__c*/                     
                     if(Trigger.oldMap.get(op.Id).Stagename!=Trigger.NewMap.get(op.Id).Stagename)
                     {
                         if(!avoid_recursive_syncctctopp_trigg.has_salestree_opp_alreadyfired('salestree_stage',op.Id) )
                         {
                             stnmap.put(op.ownerid,op.id);
                             owner_relmailids.put(op.ownerid,new set<string>()); 
                             avoid_recursive_syncctctopp_trigg.set_salestree_opp_fired('salestree_stage',op.Id);
                         }
                     }                     
                     else
                     {//else cond. says trigger fired for accomodation status not on stage change
                         if(!avoid_recursive_syncctctopp_trigg.has_salestree_opp_alreadyfired('salestree_accstatus',op.Id) )
                         {
                             stnmap.put(op.ownerid,op.id);
                             owner_relmailids.put(op.ownerid,new set<string>()); 
                             avoid_recursive_syncctctopp_trigg.set_salestree_opp_fired('salestree_accstatus',op.Id);
                         }
                     }
                         
                 }     
                 /******Start of SFSUP-951 ******/
                 if(Trigger.oldMap.get(op.Id).Referred_By__c==NULL && op.Referred_By__c!=NULL){
                     stnmap.put(op.ownerid,op.id);
                 }             
            }
    }
       
    if(!stnmap.isEmpty()){    
         Set<String> ids = new Set<String>();                
         ids.addall(stnmap.keySet());       
         System.debug('&&&&&&->'+ids.size());
         System.debug(ids);
         
        for (Integer i = 0; i < 4; i++) {  
             if(!ids.IsEmpty()){          
                list <Sales_Tree__c> lstst= [select id,Subordinate__c,Subordinate__r.Email,Reporting_To__c,Reporting_To__r.Email,Subordinate__r.No_Partial_Notifications__c,Reporting_To__r.No_Partial_Notifications__c,Subordinate__r.No_Confirmation_Notifications__c,Reporting_To__r.No_Confirmation_Notifications__c from Sales_Tree__c where Subordinate__c IN : ids];
                ids.clear(); 
                       
                for (Sales_Tree__c s :lstst) { 
                    if(s.reporting_to__c!=null){
                       Reporting2Ids.put(s.reporting_to__c, s.reporting_to__r.Email);                                
                       sub.put(s.Subordinate__c,s.Reporting_To__r.Email);
                       System.debug('---)))->'+sub);
                       /*SHS :: 25/10/2013 :: start SFSUP-667*/
                       No_Part_Notifications.put(s.Reporting_To__r.Email,s.Reporting_To__r.No_Partial_Notifications__c);
                       No_conf_Notifications.put(s.Reporting_To__r.Email,s.Reporting_To__r.No_Confirmation_Notifications__c);
                       No_Part_Notifications.put(s.Subordinate__r.Email,s.Subordinate__r.No_Partial_Notifications__c);
                       No_conf_Notifications.put(s.Subordinate__r.Email,s.Subordinate__r.No_Confirmation_Notifications__c);
                       /*SHS :: 25/10/2013 :: End SFSUP-667*/
                       ids.add(s.reporting_to__c);
                       set<String> temp=sub_owners.containsKey(s.reporting_to__c)?sub_owners.get(s.reporting_to__c):new set<string>();
                           if(i!=0){
                                if(sub_owners.containsKey(s.Subordinate__c))
                                    temp.addAll(sub_owners.get(s.Subordinate__c));
                           }    
                           else{
                                temp.add(s.Subordinate__c);
                           }
                           sub_owners.put(s.reporting_to__c,temp);
                           for(string onrs:temp){
                                set<string> mids=owner_relmailids.containsKey(onrs)?owner_relmailids.get(onrs):new set<string>();                       
                                mids.add(s.Reporting_To__r.Email);
                               // mids.add(s.Subordinate__r.Email);
                                owner_relmailids.put(onrs,mids);                                         
                           }
                    }             
                }   
             }
        }
            System.debug(')))-->'+sub_owners);
            System.debug(')))-->'+owner_relmailids);    
    }    
    list<task>ts=[select id,Subject,whatid,I_am_a__c from task where recordtypeid=:task_rectype AND whatid In:stnmap.values()];
    map<id,task>task_map=new Map<id,task>();
    
    for(task t:ts){
        task_map.put(t.id,t);
    }
    
    List<messaging.Singleemailmessage> sendmails=new List<messaging.Singleemailmessage>();
    for(String oppOwnerId : owner_relmailids.keySet()){ 
        List<string>s =new List<String>();   
            if (stnmap.containsKey(oppOwnerId)) {                 
                s.addAll( owner_relmailids.get(oppOwnerId));  
                s.add( Trigger.NewMap.get(stnmap.get(oppOwnerId)).Owner_Email__c);                
                System.debug('**************************>>'+s); 
            }  
        
            If(!s.IsEmpty()) 
            {                     
                messaging.Singleemailmessage mail=new messaging.Singleemailmessage();                  
                String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + Trigger.NewMap.get(stnmap.get(oppOwnerId)).ID;       
                
                 mail.setSenderDisplayName('Hult');
                 List<String> toadds=new List<string>();
                 
                /*Start SFSUP-724*/
                 if((Trigger.oldMap.get(stnmap.get(oppOwnerId)).Accommodation_Status__c!=Trigger.NewMap.get(stnmap.get(oppOwnerId)).Accommodation_Status__c || Trigger.NewMap.get(stnmap.get(oppOwnerId)).Hult_Fin_Aid_Merit_of_Tuition__c!=Trigger.oldMap.get(stnmap.get(oppOwnerId)).Hult_Fin_Aid_Merit_of_Tuition__c) && (Trigger.NewMap.get(stnmap.get(oppOwnerId)).Accommodation_Status__c=='2b. Not Interested (Financial reasons)' && Trigger.NewMap.get(stnmap.get(oppOwnerId)).Hult_Fin_Aid_Merit_of_Tuition__c<=25))
                 {
                    mail.setSubject('Hult accommodation – Financial issues');
                    toadds.addAll(s);                   
                    //list<string> myid=new list<string>{'harsha.simha@hult.edu'};
                    mail.setToAddresses(toadds);    
                    // mail.setToAddresses(myid);  
                    mail.setHtmlBody('Hi All,<br/><p>The student '+Trigger.NewMap.get(stnmap.get(oppOwnerId)).First_Name_from_Contact__c+ '  '  +Trigger.NewMap.get(stnmap.get(oppOwnerId)).Last_Name_from_Contact__c+' '+ 'does not want to book the Hult accommodation because of financial issues. His/her Scholarship & Fin Aid package is currently at '+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Hult_Fin_Aid_Merit_of_Tuition__c+'%'+'. Please contact student/parent again to discuss finances and /or convince student to book Hult accommodation. </p> <br/><br/>Thanks<br/>Hult Management');
                     sendmails.add(mail);    
                 }
                 else if(Trigger.oldMap.get(stnmap.get(oppOwnerId)).stagename!=Trigger.NewMap.get(stnmap.get(oppOwnerId)).stageName)
                 {/*End SFSUP-724*/
                     if(Trigger.NewMap.get(stnmap.get(oppOwnerId)).StageName=='Confirmed'||Trigger.NewMap.get(stnmap.get(oppOwnerId)).StageName=='Admissions Endorsed Confirmed'||Trigger.NewMap.get(stnmap.get(oppOwnerId)).StageName=='Conditionally Confirmed'||Trigger.NewMap.get(stnmap.get(oppOwnerId)).StageName=='Soft Rejected Confirmed')
                     {
                         mail.setSubject('New Confirmation! Student ID: '+Trigger.NewMap.get(stnmap.get(oppOwnerId)).App_ID__c+' '+ '('+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Start_Term__c+')');
                        /*Start SFSUP-667*/
                        for(string s1:s)
                        {
                            if(No_conf_Notifications.containskey(s1) && No_conf_Notifications.get(s1)==false)
                            {
                                toadds.add(s1);
                            }
                        }
                        /*End SFSUP-667*/
                     }
                     Else 
                     {
                         mail.setSubject('New Partial! Student ID: '+Trigger.NewMap.get(stnmap.get(oppOwnerId)).App_ID__c+' '+ '('+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Start_Term__c+')');
                         /*Start SFSUP-667*/
                         for(string s1:s)
                         {                      
                            if(No_Part_Notifications.containskey(s1) && No_Part_Notifications.get(s1)==false)
                            {
                                toadds.add(s1);
                            }
                         }  
                         /*End SFSUP-667*/
                     }
                     /*Start SFSUP-667*/
                     if(toadds.IsEmpty())
                        continue;
                    system.debug('>>>>>>>>>'+toadds);   
                    mail.setToAddresses(toadds);    
                    /*End SFSUP-667*/
                    system.debug('>>'+mail.getToAddresses());
                    mail.setHtmlBody('Congratulations...  '+'\n'+'<br></br>'+
                    '<a href='+fullRecordURL+'>'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Applicant_First_Name__c+' '+ Trigger.NewMap.get(stnmap.get(oppOwnerId)).Last_Name_from_Contact__c+'</a>'+''+' has become '+'\''+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Stagename+'\''+'!'+'<br></br>'+
                    'Owner:'+' '+ Trigger.NewMap.get(stnmap.get(oppOwnerId)).Recruiter__c);
                     sendmails.add(mail);
                     system.debug('>------>'+sendmails); 
                     /*Start SFSUP-724*/             
                 }   /*End SFSUP-724*/      
                /*Start SFSUP-951*/
                System.debug('===>'+Trigger.oldMap.get(stnmap.get(oppOwnerId)).Referred_By__c+'===>'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Referred_By__c);
                if(Trigger.oldMap.get(stnmap.get(oppOwnerId)).Referred_By__c==NULL&&Trigger.NewMap.get(stnmap.get(oppOwnerId)).Referred_By__c!=Null){
                    mail.setSubject('This is a notification that the below person was just referred to Hult by an applicant/ alumni. ');
                    s.add('franktoanil@gmail.com');  
                    toadds.addAll(s);  
                    mail.setToAddresses(toadds);    
                    mail.setHtmlBody('Hi All,<br/><br/>'+
                    '<b><u>Referred Person</b></u><br/>'+                    
                    '<br/>Name :'+'<a href='+fullRecordURL+'>'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Applicant_First_Name__c+' '+ Trigger.NewMap.get(stnmap.get(oppOwnerId)).Last_Name_from_Contact__c+'</a>'+
                    '<br/>Email :'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Applicant_Email__c+
                    '<br/>Phone :'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Phone__c+
                    '<br/>Country :'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Country_Of_Residence__c+
                    '<br/>Program:'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Program_pre_parsed__c+
                    
                    '<br/><br/><b><u>Person making the referral:</b></u><br/>'+
                    '<br/>Name :'+Trigger.NewMap.get(stnmap.get(oppOwnerId)).Referred_By__c+
                    '<br/><br/>Thanks<br/>Hult Management');                   
                     sendmails.add(mail); 
                   
                   
                } 
                System.debug('==mails==>'+sendmails);
                         
            }
    }
    /*Start SFSUP-667*/
    if(!sendmails.Isempty())
    {
        try
        {             
            messaging.sendEmail(sendmails);
            system.debug('==>'+sendmails.size()+'>---1--->'+sendmails);                 //messaging.sendEmail(new messaging.Singleemailmessage[]{mail});               
        }
         catch(Exception e)
        { 
             List<Runtime_Errors__c> ins_errs=new List<Runtime_Errors__c>(); 
            Runtime_Errors__c re=new Runtime_Errors__c();
            re=Exception_Handler.Collect_exceptions('Opportunity_UpdateRequirements', e.getTypeName(), e.getMessage()+'---------------'+'opportunityNewList='+Trigger.new,e.getStackTraceString());
            if(re!=null)
            {   
                ins_errs.add(re);  
                Exception_Handler.insert_exceptions(ins_errs);
            }
            /*system.debug('ERROR SENDING EMAIL:'+e); 
            messaging.Singleemailmessage err_mail=new messaging.Singleemailmessage();
            err_mail.setToAddresses(new list<String>{'harsha.simha@hult.edu'});
            err_mail.setSenderDisplayName('Hult Saletree Mails error');
            err_mail.setSubject('Hult Saletree Mails errors ');
            string mailbdy='<br/>';
            for(integer i=0;i<sendmails.size();i++)
            {
                mailbdy+='<br/><h1><u>Email 1</u></h1> <br/><br/> <b><u>Subject</u></b> '+sendmails[i].getSubject()+' <br/><br/>Error :: '+e+'<br/><hr/><br/>'+sendmails[i].getPlainTextBody()+'<br/><hr/><hr/><br/>';              
            }
            err_mail.setHtmlBody(mailbdy);
            messaging.sendEmail(new messaging.Singleemailmessage[]{err_mail});           */    
        }
    }/*End SFSUP-667*/
}