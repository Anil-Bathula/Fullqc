/*******************************************************
Trigger   : workflow2trigger
Developer : Anil.B
Purpose   : To deactivate some workflows and use those 
workflow functionality in this trigger becoz of workflow
limits reached to maximum.
Test Class :workflow2trigger_Test(100%)
Modified by   : Prem 25/06/2014 (SFSUP-744)
Modified By    : Anil.B 11/07/2014   (SFSUP-751)
Modified By    : Anil.B 15/07/2014   (SFSUP-753)
Modified By    : Anil.B 09/10/2014  changed program parsed from BIBA to BBA by using custom_lables class.
Modified By    : Anil.B 18/02/2015    (SFSUP-897),(SFSUP-894),(SFSUP-892),(SFSUP-893),(SFSUP-896 WF),
(SFSUP-898 no action required)
Updateprimarycampus need to be put in this code

Modified By    : Harsha 14/07/2014   (alias : extrec)
When Opportunity of external Housing record type is created/Updated then
it should contain a contact and then it's contact should also be of External Housing Record Type.
Test class for extrec functionality  :: TestClass    : Test_Ext_Housing(33%)
********************************************************/


trigger Workflow2trigger on Opportunity (before insert,before update) 
{       
    list<string> oppids_check_ctct_rectype=new list<String>();//extrec 7/14/2014  
    
    String API_user=userinfo.getfirstname();
    
     for(Opportunity opp:Trigger.New){
        //If(!RecordTypeHelper.isapplicationprocessrecordtype(opp.recordtypeid))
        //continue;
        
        
        Opportunity oldopp=trigger.isUpdate?Trigger.oldmap.get(opp.id):new Opportunity(); 
        
        if(trigger.isUpdate && trigger.Isbefore)
        {system.debug('*********'+opp.Accommodation_Student_Status__c);
            System.debug('--->'+opp.Program_Parsed__c +'---->'+opp.Accommodation_Status__c+'--->'+oldopp.Confirmation_Activity__c);
            /*Workflow::Set Accommodation Stage to 1*/
            //Modified by   : Prem 25/06/2014 (SFSUP-744)
            //Changed program parsed from "Masters" to "MBA" --SFSUP-751
            //Here we are opening accomidation status for MBA and BIBA Programs
          If(RecordTypeHelper.isapplicationprocessrecordtype(opp.recordtypeid)){
            
            if(opp.Confirmation_Activity__c!=oldopp.Confirmation_Activity__c &&
              (opp.Program_Parsed__c ==custom_lables.Bachelor_Pgm_abvtn ||opp.Program_Parsed__c =='Masters'|| opp.Program_Parsed__c =='MBA') &&
              (opp.Confirmation_Activity__c=='LDN Accommodation booking form for Confirmed'||
               opp.Confirmation_Activity__c=='SFO Accomodation booking form for Confirmed') ){
               
                        opp.Accommodation_Status__c='1. Recruiter presented Hult accom.';
                        opp.Accom_Stage_1_date_time__c=system.now();            
            }

             /*Workflow::Set Accommodation Stage to 3 */
          /* if((opp.Accommodation_Student_Status__c!=Null && opp.Accommodation_Student_Status__c!=''  )&& (opp.Accommodation_Student_Status__c!=oldopp.Accommodation_Student_Status__c) && 
                (opp.Program_Parsed__c ==custom_lables.Bachelor_Pgm_abvtn||opp.Program_Parsed__c=='Masters'||opp.Program_Parsed__c=='MBA')){
                        opp.Accommodation_Status__c='3. Accom. booked (not paid yet)'; 
                        opp.Accom_Stage_3_date_time__c=system.now();  
            }*/
            
            If(opp.Program__c!=oldopp.Program__c && opp.Campus_parsed_from_Program__c!=NULL && opp.Program_pre_Parsed__c!=NULL){
                opp.Campus_Program__c=opp.Campus_parsed_from_Program__c+'-'+opp.Program_pre_Parsed__c;
            }
            //Start of SFSUP-753.
            /*Workflow:: Application Complete Application*/
           /* if((opp.StageName!=oldopp.StageName ||opp.Application_Substage__c!=oldopp.Application_Substage__c)&&
                opp.StageName=='Partial Application'&&opp.Application_Substage__c=='Completed Application'&&
                opp.Completed_Application_Date__c==NULL ){
                
                        opp.Completed_Application_Date__c=System.today();
                        opp.date_time_Completed_Application_del__c=System.Now();
            }*/
            
            /*Start of SFSUP-898*/
            if(trigger.isUpdate && trigger.isBefore && opp.stageName=='Qualified Lead' && opp.Q_Lead_Date_N__c==NULL ){
                Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                DateTime D = DateTime.newInstance(opp.createdDate.getTime() + tz.getOffset(opp.createdDate));
                opp.Q_Lead_Date_N__c=date.valueof(d); 
                
            }
            /*End of SFSUP-898*/
            
            /*Start of SFSUP-1012 -SFSUP-1013 (5 condition-- 10 condition)*/
            if((opp.stageName=='Cancellation'||opp.stageName=='Deferral'||opp.stageName=='Withdrawn') && Oldopp.Application_Substage__c!=opp.Application_Substage__c &&
                 (opp.Application_Substage__c=='Reactivated – Paid' ||opp.Application_Substage__c=='Reactivated – Waived' )){
                 
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));  
                        if((opp.stageName=='Cancellation'||opp.stageName=='Deferral')){                         
                            opp.Confirmed_Date__c=date.valueof(d); 
                            opp.Confirmed_date_time__c=System.Now();    
                        }
                        
                       else if(opp.stageName=='Withdrawn'&&(opp.Application_Substage__c=='Reactivated – Paid' ||opp.Application_Substage__c=='Reactivated – Waived' )){
                            opp.stageName='Partial Application';
                            opp.Application_Substage__c=Null;                            
                            opp.Partial_Application_Date__c=date.valueof(d); 
                            opp.Partial_Application_date_time__c=System.Now();                       
                            opp.Deferred_Date__c=Null;
                            opp.Deferred_date_time__c=Null;
                            opp.Cancellation_Date__c=Null;
                            opp.Date_Time_Cancellation__c=Null;
                            opp.Confirmed_Date__c=Null;
                            opp.Confirmed_date_time__c=Null;
                            opp.Withdrawn_Date__c=Null;
                        }           
                        
                
            }
            /*End of SFSUP-1012*/
            
            /*Workflow:: Application In Progress  SFSUP-897*/
            if((opp.Program_and_Location_Tab_Complete__c!=oldopp.Program_and_Location_Tab_Complete__c ||
                opp.StageName!=oldopp.StageName)&&
                opp.Program_and_Location_Tab_Complete__c==True && opp.StageName=='Qualified Lead' && API_user=='S4S' ){
                
                    If(opp.In_Progress_Date__c==NULL){
                    
                            System.debug('==>'+opp.In_Progress_Date__c);          
                          
                            Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                            DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                            opp.In_Progress_Date__c=date.valueof(d); 
                            System.debug('==>'+opp.In_Progress_Date__c);                
                            opp.In_Progress_date_time__c=System.Now();
                     }
                    opp.StageName='In Progress';
                    /*Start SFSUP-897*/
                    opp.Deferred_Date__c=NULL;
                    opp.Deferred_date_time__c=NULL;
                    opp.Cancellation_Date__c=NULL;
                    opp.Date_Time_Cancellation__c=NULL;
                    opp.Confirmed_Date__c=NULL;
                    opp.Confirmed_date_time__c=NULL;
                    opp.Withdrawn_Date__c=NULL;
                    opp.Partial_Application_Date__c=NULL;
                    opp.Partial_Application_date_time__c=NULL;
                     /*END SFSUP-897*/
            }else if(opp.StageName!=oldopp.StageName && opp.StageName=='In Progress' && API_user!='S4S' &&opp.In_Progress_Date__c==NULL){
                    
                    Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                    DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                    opp.In_Progress_Date__c=date.valueof(d); 
                    System.debug('==>'+opp.In_Progress_Date__c);                
                    opp.In_Progress_date_time__c=System.Now();
                     
            } //end of SFSUP-897
            
            /*Workflow:: Application Notified Date Stamp*/
           /* if((opp.StageName!=oldopp.StageName ||opp.Application_Substage__c!=oldopp.Application_Substage__c)&&
               (opp.StageName=='Conditionally Accepted'||Opp.StageName=='Accepted'||Opp.StageName=='Soft Rejected')&&
                Opp.Application_Substage__c=='Notified'&&opp.Notified_Date__c==Null){
                
                        opp.Notified_Date__c=System.today();
                        opp.Notified_date_time__c=system.Now();                   
                
            }*/
            
            /*Workflow::Datestamp Partial Application */
            if(opp.StageName!=oldopp.StageName && opp.StageName=='Partial Application'){
                
                     If(opp.Partial_Application_Date__c==Null){   
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                        opp.Partial_Application_Date__c=date.valueof(d); 
                        opp.Partial_Application_date_time__c=System.Now();                        
                        
                        /*start of SFSUP-895*/
                        opp.Deferred_Date__c=Null;
                        opp.Deferred_date_time__c=Null;
                        opp.Cancellation_Date__c=Null;
                        opp.Date_Time_Cancellation__c=Null;
                        opp.Confirmed_Date__c=Null;
                        opp.Confirmed_date_time__c=Null;
                        opp.Withdrawn_Date__c=Null;
                        /*END of SFSUP-895*/
                     }else if(oldopp.StageName=='Withdrawn'){
                         /*start of SFSUP-895*/
                        opp.Deferred_Date__c=Null;
                        opp.Deferred_date_time__c=Null;
                        opp.Cancellation_Date__c=Null;
                        opp.Date_Time_Cancellation__c=Null;
                        opp.Confirmed_Date__c=Null;
                        opp.Confirmed_date_time__c=Null;
                        opp.Withdrawn_Date__c=Null;
                        /*END of SFSUP-895*/
                         
                     }

                
            }/*Workflow::Application Confirmed*/
            else if(opp.StageName!=oldopp.StageName && 
                    (opp.StageName=='Admissions Endorsed Confirmed'||
                     opp.StageName=='Waitlisted Confirmed'||
                     opp.StageName=='Conditionally Confirmed'||
                     opp.StageName=='Confirmed'||
                     opp.StageName=='Soft Rejected Confirmed')){
                    
                        IF(opp.Confirmed_Date__c==NULL){
                            Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                            DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                            opp.Confirmed_Date__c=date.valueof(d); 
                            opp.Confirmed_date_time__c=System.Now();
                            /*Start SFSUP-894*/
                            opp.Deferred_Date__c=Null;
                            opp.Deferred_date_time__c=Null;
                            opp.Cancellation_Date__c=Null;
                            opp.Date_Time_Cancellation__c=Null;
                            opp.Withdrawn_Date__c=Null;
                            /*End SFSUP-894*/
                        }else if((oldopp.StageName=='Cancellation'||oldopp.StageName=='Deferral')&& opp.StageName=='Confirmed'){
                            opp.Deferred_Date__c=Null;
                            opp.Deferred_date_time__c=Null;
                            opp.Cancellation_Date__c=Null;
                            opp.Date_Time_Cancellation__c=Null;
                            opp.Withdrawn_Date__c=Null;
                        }

                    
            }/*Workflow::Application Accepted*/
             else if(opp.StageName!=oldopp.StageName &&                    
                    (opp.StageName=='Conditionally Accepted'||
                     opp.StageName=='Accepted'||
                     opp.StageName=='Soft Rejected')&&
                     opp.Accepted_Date__c==NULL){                         
                     
                         Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                         DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                         opp.Accepted_Date__c=date.valueof(d); 
                         opp.date_time_Accepted__c=System.now();
                         
             }/*Workflow::Application Cancelled*/
             else if(opp.StageName!=oldopp.StageName &&                     
                     opp.StageName=='Cancellation'&&
                     opp.Cancellation_Date__c==NULL){
                     
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                        opp.Cancellation_Date__c=date.valueof(d); 
                        opp.Date_Time_Cancellation__c=System.Now();
                        /*Start -SFSUP-893*/
                        opp.Deferred_Date__c=Null;
                        opp.Deferred_date_time__c=Null;
                        opp.Withdrawn_Date__c=Null;                        
                        /*Start -SFSUP-893*/
                     
              }/*Workflow::Application Deferred*/
              else if(opp.StageName!=oldopp.StageName &&                      
                      opp.StageName=='Deferral'&&
                      opp.Deferred_Date__c==NULL){
                     
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                        opp.Deferred_Date__c=date.valueof(d); 
                        opp.Deferred_date_time__c=System.Now();
                        opp.Deferred__c=True;
                        /*Start -SFSUP-892*/
                        opp.Cancellation_Date__c=Null;
                        opp.Date_Time_Cancellation__c=Null;
                        opp.Withdrawn_Date__c=Null;                        
                        /*End -SFSUP-892*/
                         
              }/*Workflow::Application Withdrawn*/
              else if(opp.StageName!=oldopp.StageName &&                      
                      opp.StageName=='Withdrawn'&&
                      opp.Withdrawn_Date__c==NULL){                      
                     
                        Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                        DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                        opp.Withdrawn_Date__c=date.valueof(d); 
                        
                        /*Start SFSUP-896*/
                        opp.Deferred_Date__c=Null;
                        opp.Deferred_date_time__c=Null;
                        opp.Cancellation_Date__c=Null;
                        opp.Date_Time_Cancellation__c=Null;
                        opp.Confirmed_Date__c=Null;
                        opp.Confirmed_date_time__c=Null;
                        /*End SFSUP-896*/
                         
              }
              
              
              /*Workflow::Waiting for Review Date Stamp*/
             /* else if(opp.StageName!=oldopp.StageName &&                      
                      opp.StageName=='Waiting for Review'&&
                      opp.Waiting_for_Review_Date__c==NULL){
                      
                      Timezone tz = Timezone.getTimeZone('America/Los_Angeles');
                      DateTime D = DateTime.newInstance(System.Now().getTime() + tz.getOffset(System.Now()));
                      opp.Waiting_for_Review_Date__c=date.valueof(d); 
                      opp.Waiting_for_Review_date_time__c=System.Now();
              }*/
              //End of SFSUP-753.
            }
            
         }    
         
       
       
      
        //Start : extrec 7/14/2014
         if(Trigger.isBefore)
         {
            if(Trigger.isUpdate && opp.Contact__c==null && opp.RecordTypeId==RecordTypeHelper.getRecordTypeId('Opportunity','Housing External Opportunity'))
            {
                opp.addError('Opportunity should have contact.');
            }
            if(opp.RecordTypeId!=oldopp.RecordTypeId && opp.RecordTypeId==RecordTypeHelper.getRecordTypeId('Opportunity','Housing External Opportunity'))
            {
                oppids_check_ctct_rectype.add(opp.Id);
            }
            if(opp.RecordTypeId!=oldopp.RecordTypeId && oldopp.RecordTypeId==RecordTypeHelper.getRecordTypeId('Opportunity','Housing External Opportunity'))//8/7/2014
            {
                opp.AddError('Opportunity and Contact Record Types need to be same for External Housing : '+opp.Id);
            }
            
         }//End : extrec 7/14/2014
         
     }      
     
     //Start: extrec 7/14/2014
     if(!oppids_check_ctct_rectype.isEmpty())
     {
        string ctct_ext_hsng_recid=RecordTypeHelper.getRecordTypeId('Contact', 'Housing External Customer');
        for(opportunity o:[select id,contact__c,Contact__r.RecordTypeId from Opportunity where id IN:oppids_check_ctct_rectype])
        {
            if(o.Contact__r.RecordTypeId!=ctct_ext_hsng_recid)
            {
                o.AddError('Opportunity and Contact Record Types are not same for Housing External Opportunity : '+o.Id);
            }
        }
            
     }
     //End: extrec 7/14/2014
     
     
     
}