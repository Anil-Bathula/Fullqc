public class new_lead_ui_event_ctrlr
{   
/*
      Developer : Harsha Simha
      Extension for new_lead_ui_event VF page on contact.  
      Modified by:Anil.B 19/7/2013 Added profile names in place of:
       6. HULT Global and Regional Heads  Now it will be:-
       6. HULT Global Heads
       6.1 HULT Regional Heads
       
       Test Class    : lead_newdetailpagectrlr_Test
       
       Developer     : Harsha Simha
       Date          : 23/9/2013  
       Modification  : Added links Set interview Status and Edit Closed Interview , Replicated same functionality as of Contact 
                       and this functionality will should be available to Telesales and System Admins.
       
       Modified Prem : SFSUP-767
       
       Developer     : Harsha Simha
       Date          : 11/19/2014
       Modification  : SFSUP-791 'Assign to different user?'. The profile Sales-Telesales Head cannot see this right now. need to fix it.
*/
    public string currleadid{get;set;}
    public Lead currlead_rec{get;set;}
    public string curr_profilename{get;set;}
    public boolean editlead{get;set;}
    public string flagurl{get;set;}
    public boolean other_owner{get;set;}    
    public boolean showownerchk{get;set;}    
    public string owner_name{get;set;}
    public string def_owner_name{get;set;}
    public string set_subject{get;set;}
    
     /*interview section variables*/
    public list<schdtbls> lst_interview_schdls{get;set;}
    public list<Event> disp_events{get;set;}
    public Date disp_intrvw_date{get;set;}
    public string set_intrvw_time{get;set;}
    public Date set_intrvw_date{get;set;}
    public string selectedt_intrvw_time{get;set;}
    public set<double> get_exist_intrvw_times{get;set;}
    public map<string,Event> mapevents=new map<string,Event>();
    public Event event_intvw{get;set;}
    public string editeventid{get;set;}
    public boolean showintvw{get;set;}
    public boolean showstatus{get;set;}
    public boolean reminderset{get;set;}
    public boolean show_event_rel_btns{get;set;}
    public boolean show_inter_stats_table{get;set;}
    public boolean show_inter_stats_savebtn{get;set;}
    public boolean show_description{get;set;}
    public boolean prof_admin_rec{get;set;}
    public string remtime{get;set;}
    public boolean confirmdel{get;set;}  
    public boolean save_cancel_intrvws;//by shs: for saving cancel intrviews if it is false for jira 645
    /*prof names for adding another owner*/
     public set<string> ownerprofnames=new set<string>();
     
    public new_lead_ui_event_ctrlr(ApexPages.StandardController controller)
    {   
        reminderset=true;
        show_event_rel_btns=false;
        show_inter_stats_table=false;
        show_inter_stats_savebtn=false;
        show_description=false;
        prof_admin_rec=false;
        confirmdel=false;
        curr_profilename=RecordTypeHelper.getprofilename(Userinfo.getProfileId());
        ownerprofnames.add('Sales-Telesales');
        ownerprofnames.add('Sales-Recruiter and Converter');
        ownerprofnames.add('Sales-Product Head');
        ownerprofnames.add('Sales-Global Product Head'); 
        ownerprofnames.add('Sales-Regional Head');        
        ownerprofnames.add('Sales-Indirect');
        ownerprofnames.add('Sales-Telesales Head');//-- SFSUP-791
      //  ownerprofnames.add('9.2 HULT Outsource Call Center TS'); Commented by anil.b on 25/10/2013--- SFSUP-666
      //  ownerprofnames.add('9.2.1 HULT Outsource Call Center Manager'); Commented by anil.b on 25/10/2013--- SFSUP-666         
        ownerprofnames.add('System Administrator');         
        if(ownerprofnames.Contains(curr_profilename))
        {                
                showownerchk=true;
        }
        
        set<string> profnames=new set<string>{'System Administrator','Sales-Telesales','Sales-Telesales Head','Sales-Indirect'};//{'Sales-Recruiter and Converter','Sales-Telesales','Sales-Telesales Head','Sales-Product Head','Sales-Regional Head','Sales-Global Product Head','9.2 HULT Outsource Call Center TS','System Administrator'};
        if(profnames.contains(curr_profilename)){show_event_rel_btns=true;}
       system.debug(show_event_rel_btns);
       /*To Hide  Edit closed Interview Status link */  
       //Removed profile :-'9.2 HULT Outsource Call Center TS' from prof_hide_closedintrvs_link by anil.b on 25/10/2013-SFSUP-666
        set<string> prof_hide_closedintrvs_link=new set<string>{'Sales-Telesales'};
        show_description=true;
        if(prof_hide_closedintrvs_link.contains(curr_profilename))
        {
                show_description=false;
        }
        else
        {
                show_description=true;
        }
        
        /*To show  Edit closed Interview Status link */         
        set<string> prof_show_closedintrvs_link=new set<string>{'Sales-Recruiter and Converter','System Administrator','Sales-Telesales Head','Sales-Product Head','Sales-Global Product Head','Sales-Regional Head','Sales-Indirect'};
        if(prof_show_closedintrvs_link.contains(curr_profilename)){prof_admin_rec=true;}
        
        
        
    }
    
    public void ownerchngd()
    {
        if(currlead_rec.OwnerId!=null)
        {
                list<user> usr=[select id,Name from user where id=:currlead_rec.OwnerId];
                if(!usr.IsEmpty())
                {
                        owner_name=usr[0].Name;
                        date d=System.today();
                        if(set_intrvw_date!=null){d=set_intrvw_date;}
                        get_exist_intrvw_times=init_interviewscdules(d);
                }
        }
    }
    
    public void uncheckuser()
    {
        init_lead();        
    }
    /*pageload method retrives the lead record and makes lead record interview status 
    field to null if there are no open Events */
    public void init_lead()
    {
        confirmdel=false;
        currleadid=Apexpages.currentPage().getparameters().get('id');
        currlead_rec=new Lead();
        save_cancel_intrvws=false;//by shs:for jira 645
        if(currleadid!=null){
            showstatus=false;
            currlead_rec=[select id,Name,Owner.Name,OwnerId,Interview_status__c,interview_Date_Booked__c,Interview_Date__c from Lead where id=:currleadid];
            owner_name=currlead_rec.Owner.Name;            
            def_owner_name=currlead_rec.Owner.Name;
            get_exist_intrvw_times=init_interviewscdules(system.today());
            if(currlead_rec.Interview_Status__c=='Booked')
            {
                showstatus=true;
                boolean updlead=true;
                for(event e:[select id, Subject,StartDateTime,EndDateTime,WhoId From Event where WhoId=:currlead_rec.Id and StartDateTime>=:System.Now()])
                {
                    if(e.StartDateTime>=system.Now())
                    {updlead=false;}                    
                }
                if(updlead)
                {
                    currlead_rec.Interview_status__c=null;
                    currlead_rec.interview_Date_Booked__c=null;
                    currlead_rec.Interview_Date__c=null;
                    try{
                        update currlead_rec;
                        init_lead();        
                    }
                    catch(Exception e){system.debug(e);}
                }
            }
       }
    }
    /*returns set of events-time exist for the date passed in parameter and highlights the event table on that time*/
   public set<double> init_interviewscdules(date dt)
    {        
          
        selectedt_intrvw_time='0.3';
         lst_interview_schdls=new list<schdtbls>();
         event_intvw=new Event();
         disp_events=new list<Event>();
         disp_intrvw_date=dt;
         showintvw=true;
         confirmdel=false;
        datetime sdt=Datetime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
        datetime edt=Datetime.newInstance(dt, Time.newInstance(23, 59, 59, 0));
        disp_events=[select id, Subject,StartDateTime,Description,EndDateTime,OwnerId ,phone__c,WhoId,Who.Name From Event where OwnerID=:currlead_rec.OwnerId and StartDateTime>=:sdt and EndDateTime<=:edt];
        set<double> x=new set<double>();
        for(Event e:disp_events)
        {
                mapevents.put(e.Id,e);
                system.debug(e.StartDateTime.hour()+'---------'+e.StartDateTime.minute()+'----------'+e.EndDateTime.hour()+'----------'+e.EndDateTime.minute());
            double stime=Double.valueOf(e.StartDateTime.hour()+'.'+e.StartDateTime.minute());
            double etime=Double.valueOf(e.EndDateTime.hour()+'.'+e.EndDateTime.minute());
            system.debug(stime+'======='+etime);
            for(double i=stime;i<etime;i=i+0.30)
            {system.debug('*****'+i);
                decimal l=i-i.intvalue();
                l=l.setScale(1);    
                if(l==.6)
                {
                   i=i+0.40;
                }
                if(i<etime)
                {x.add(i);}
            }
        }
        for(integer i=8;i<=22;i++)
        {
        string tblebgcol='images/img_full.png';

            double d=double.valueof(i);
            string tooltip='Available';
            System.debug(x);
            if(x.contains(d))
            {tooltip='Busy';
                if(x.contains(d+.3))
                {

                        tooltip=i+' - '+(i+1)+' Busy';          
                        tblebgcol='images/img_full.png';                
                }
                else
                {

                    tooltip=i+' - '+i+'.30 Busy \n';
                        tooltip+=i+'.30 - '+(i+1)+' Available.';    
                        tblebgcol='images/img_slft.png';
                }
            }
            else
            {
                if(x.contains(d+.3))
                {

                    tooltip=i+' - '+i+'.30 Available \n';
                        tooltip+=i+'.30 - '+(i+1)+' Busy.';
                        tblebgcol='images/img_srt.png';
                }               
                else
                {

                    tooltip=i+' - '+(i+1)+' Available';   
                    tblebgcol='images/img_blnk.png';
                }
            }
            lst_interview_schdls.add(new schdtbls(''+i,tblebgcol,tooltip));
        }
        /*
        for(event e:[select id, Subject,StartDateTime,EndDateTime,WhoId From Event where WhoId=:currlead_rec.Id and StartDateTime>=:System.Now()])
        {
            if(e.StartDateTime>system.Now())
            {showstatus=true;}
        }*/
        
        return x;
    }
    
    /*inner class for interview schedules*/    
    public class schdtbls
    {
         public string bgcol{get;set;}
         public string value{get;set;}
         public string tooltip{get;set;}
         public string tbleid{get;set;}         
         public schdtbls(String num,string bgcolurl,string tooltip)
         {
             this.bgcol=bgcolurl;
             this.value=num;
             this.tbleid='tb'+num;
             this.tooltip=tooltip;
            // this.apexval=val;
         }
    }
    /*on interview date change in Date field calls init_interviewscdules method*/
    public void intrvw_datechange()
    {
       if(set_intrvw_date!=null){
        get_exist_intrvw_times=init_interviewscdules(set_intrvw_date);}
    }
    
    /*to delete selected event*/
    public void del_intervw()
    {event_intvw=new Event();
        if(editeventid!=null && editeventid.trim()!='' && mapevents.containsKey(editeventid))
        {               
                event_intvw=mapevents.get(editeventid);
                try{
                    Delete event_intvw;
                     if(set_intrvw_date!=null){
                        get_exist_intrvw_times=init_interviewscdules(set_intrvw_date);
                     }else{get_exist_intrvw_times=init_interviewscdules(System.today());}
                    
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error : '+e));
                }
        }
    }
/*   schedules event on selected Date Time if there is no open event for the Lead record 
    and if the selected time is less than current date time */    
    public Pagereference schedule_intrvw()
    {
        if(set_intrvw_date==null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select a date...'));    //disp error
        }
        else
        {
            list<Event> et=[select id,whoid,Subject,StartDateTime from Event where whoid=:currlead_rec.Id and StartDateTime>=:System.now()];
            if(!et.IsEmpty())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There is already an interview scheduled on '+et[0].StartDateTime.Month()+'/'+et[0].StartDateTime.Day()+'/'+et[0].StartDateTime.year()+' '+et[0].StartDateTime.hour()+':'+et[0].StartDateTime.Minute()));    //disp error
                return null;
            } 
                if(set_intrvw_date<System.today())
                {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'The date you have selected is in the past!'));    //disp error
                        return null;
                }
                if(set_intrvw_date==System.today())
                {
                        double temp0=double.valueOf(set_intrvw_time);                   
                        double temp01=system.now().hour()+(0.01*System.now().minute());
                        if(temp0<temp01)
                        {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Time already crossed!'));    //disp error
                                return null;
                        }
                }
                Decimal etime=0;
                Decimal stime=double.valueOf(set_intrvw_time);
                stime=stime.setScale(1);
                etime=etime.setscale(1);
                boolean createschedule=false;
                
                //check if time slot is already scheduled or not
                if(selectedt_intrvw_time=='0.3')
                {
                        if(!get_exist_intrvw_times.contains(double.valueof(stime)))
                        {
                                createschedule=true;
                                if(stime-stime.intValue()==0.3 )
                                {
                                        etime=stime.intvalue()+1;                               
                                }       
                                else
                                {
                                        etime=stime.intvalue()+0.3;
                                }
                        }               
                }
                else
                {
                        if(!get_exist_intrvw_times.contains(double.valueof(stime)))
                        {                                               
                                if(stime-stime.intValue()==0.3 )
                                {                               
                                        if(!get_exist_intrvw_times.contains(stime.intvalue()+1))
                                        {
                                                etime=stime+1;
                                                createschedule=true;
                                        }                                       
                                }
                                else
                                {
                                        if(!get_exist_intrvw_times.contains(stime.intvalue()+1))
                                        {
                                                etime=stime+1;
                                                createschedule=true;
                                        }
                                }
                        }               
                }
                system.debug(etime);
                //if time slot is not scheduled then create event else display error
                if(createschedule)
                {
                        Event eobj=new Event();
                         eobj.StartDateTime= Datetime.newInstance(set_intrvw_date,Time.newInstance(stime.intValue(), stime-stime.intValue()==0.3?30:0, 0, 0));
                     eobj.EndDateTime=Datetime.newInstance(set_intrvw_date,Time.newInstance(etime.intValue(), etime-etime.intValue()==0.3?30:0, 0, 0));
                     eobj.WhoId=currleadid;
                     eobj.OwnerId=currlead_rec.OwnerId;
                     eobj.subject=set_subject;
                     eobj.Event_RequiredField__c=true;
                     if(reminderset)
                     {    
                         eobj.ReminderDateTime=eobj.StartDateTime.addminutes(-15);
                         eobj.IsReminderSet=true;
                        /*DateTime strttime=eobj.StartDateTime;
                        if(remtime.contains('m'))
                        {
                                integer t=Integer.valueOf(remtime.replace('m',''));
                                eobj.ReminderDateTime=strttime.addminutes(-t);
                                eobj.IsReminderSet=true;
                        }
                        else
                        {   
                                integer t=Integer.valueOf(remtime);                     
                                eobj.ReminderDateTime=strttime.addHours(-t);
                                eobj.IsReminderSet=true;
                        }*/
                     }
                     try{
                        insert eobj;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info ,'An interview has been scheduled!'));
                        date d=set_intrvw_date;
                        get_exist_intrvw_times=init_interviewscdules(set_intrvw_date);
                       
                        //get_exist_intrvw_times=init_interviewscdules(d);
                     }
                     catch(Exception e)
                     {                          
                        system.debug(e);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error ,''+e));
                     }
                }
                else
                {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'There is a slot already scheduled with in the selected time!'));   //disp msg
                }
        }/*
        PageReference acctPage = new PageReference('/'+currlead_rec.Id+'?inline=0');
        acctPage.setRedirect(true);
        return acctPage;
        */
        //init_lead();
        return null;
    }
 /*Time slot picklist values between 9am and 8pm*/   
    public List<SelectOption> getstimeslot() {
         List<selectOption> options=new List<selectOption>();
         for(integer i=8;i<=22;i++)
         {
                options.add(new selectOption(i+'.0',i+':00'));
                //if(i!=20){//SHS :29/4/2013 SFSUP-577 "The 20:30 time slot is missing"
                options.add(new selectOption(i+'.30',i+':30'));
                //}
         }
         return options;
     }
     
     /*Subject picklist values*/
    public List<SelectOption> getsubvals() {
         List<selectOption> options=new List<selectOption>();
         //list<profile> p=[select id,Name from Profile where id=:Userinfo.getprofileId() and (Name='Sales-Telesales' OR Name='9.2 HULT Outsource Call Center TS')]; //Added OR Condition for Name Field By Anil.B
         //if(!p.IsEmpty()) removed profile name from below if condition:- curr_profilename=='9.2 HULT Outsource Call Center TS'
         if(curr_profilename=='Sales-Telesales' )
         {
             options.add(new selectOption('Phone Interview','Phone Interview'));
             options.add(new selectOption('In Person Interview','In Person Interview'));
         }
         else
         {
             options.add(new selectOption('Phone Interview','Phone Interview'));
             options.add(new selectOption('Admissions Interview','Admissions Interview'));         
             options.add(new selectOption('In Person Interview','In Person Interview'));
             options.add(new selectOption('Follow Up Call','Follow Up Call'));
         }
         return options;
     }
     
     /*Reminder time values*/
    public List<SelectOption> getremaindertime() {
         List<selectOption> options=new List<selectOption>();
         options.add(new selectOption('5m','5 minutes'));
         options.add(new selectOption('10m','10 minutes'));
         options.add(new selectOption('15m','15 minutes'));      
         options.add(new selectOption('30m','30 minutes'));   
         options.add(new selectOption('1','1 hour'));
         options.add(new selectOption('2','2 hours'));
         options.add(new selectOption('3','3 hours'));
         options.add(new selectOption('4','4 hours'));
         options.add(new selectOption('5','5 hours'));
         options.add(new selectOption('6','6 hours'));
         options.add(new selectOption('7','7 hours'));
         options.add(new selectOption('8','8 hours'));
         options.add(new selectOption('9','9 hours'));
         options.add(new selectOption('10','10 hours'));
         options.add(new selectOption('11','11 hours'));
         options.add(new selectOption('12','0.5 day'));
         options.add(new selectOption('18','18 hours'));
         options.add(new selectOption('24','1 day'));
         options.add(new selectOption('48','2 days'));
         options.add(new selectOption('72','3 days'));
         options.add(new selectOption('96','4 days'));
         options.add(new selectOption('168','1 week'));
         options.add(new selectOption('336','2 weeks'));
         return options;
     }
     
 /*selected Time slot picklist values */     
     public List<SelectOption> getselectedtimeslot() {
         List<selectOption> options=new List<selectOption>();         
         options.add(new selectOption('0.3','Half an hour'));
         options.add(new selectOption('1','One hour'));         
         return options;
     }   
     /* detail view of selected event*/    
     public void viewintrvw()
     {event_intvw=new Event();
        if(editeventid!=null && editeventid.trim()!='' && mapevents.containsKey(editeventid))
        {               
                event_intvw=mapevents.get(editeventid);
                showintvw=false;
        }
     }
     /*donothing*/
     public void donothing()
     {
         showintvw=true;
         confirmdel=false;
     }
     
     
     public list<interview_Status_table> intstatsset{get;set;}
     
     public class interview_Status_table
     {
        public event evt{get;set;}
        public string evttype{get;set;}
        public string intstats{get;set;}
        public list<Selectoption> optns{get;set;}
        public interview_Status_table(Event e,string etype)
        {
                evt=new event();
                evt=e;
                evttype=etype;
                optns=new list<Selectoption>();
                optns.add(new selectOption('','--None--'));
                //list<profile> p=[select id,Name from Profile where id=:Userinfo.getprofileId() and (Name='Sales-Telesales' OR Name='9.2 HULT Outsource Call Center TS')]; //Added OR Condition for Name Field By Anil.B
                //Removed profile name:|| RecordTypeHelper.getprofilename(Userinfo.getprofileId())=='9.2 HULT Outsource Call Center TS' from below if condition by anil.b-25/10/2013-SFSUP-666
                if(RecordTypeHelper.getprofilename(Userinfo.getprofileId())=='Sales-Telesales' )
                {
                        optns.add(new selectOption('Cancelled','Cancelled'));
                        if(e.Interview_Status__c=='Cancelled')
                        {
                            intstats=e.Interview_Status__c;
                        }
                }
                else
                {
                        optns.add(new selectOption('Completed','Completed'));
                        optns.add(new selectOption('Cancelled','Cancelled'));
                        optns.add(new selectOption('Non-Attendance' ,'Non-Attendance' ));
                        optns.add(new selectOption('Re-Booked','Re-Booked'));
                        if(e.Interview_Status__c=='Cancelled'||e.Interview_Status__c=='Completed'||e.Interview_Status__c=='Non-Attendance'||e.Interview_Status__c=='Re-Booked')
                        {
                            intstats=e.Interview_Status__c;
                        }
                }
        }
     }
     
     public void init_interview_Status_table()
     {  
        show_inter_stats_table=true;
        intstatsset=new list<interview_Status_table>();
        
        List<string> listsub =new list<string>();
        if(show_description){
                 listsub.add('Phone Interview');
                 listsub.add('Admissions Interview');         
                 listsub.add('In Person Interview');
                 listsub.add('Follow Up Call');
        }
        else
        {
                 listsub.add('Phone Interview');         
                 listsub.add('In Person Interview');
        }
        for(event e:[select id, Subject,StartDateTime,whatid,Interview_Status__c,EndDateTime,WhoId,Description From Event where WhoId=:currlead_rec.Id and (Interview_Status__c=null or Interview_Status__c='Booked') and subject IN:listsub])
        {
                if(e.StartDateTime>=system.Now())
                {
                        intstatsset.add(new interview_Status_table(e,'Open'));                  
                }
                else
                {
                        intstatsset.add(new interview_Status_table(e,'Close'));
                }           
                show_inter_stats_savebtn=true;         
        }
        
     }
     
     public void edit_closed_interviews()
     {
        confirmdel=false;
        show_inter_stats_table=true;
        intstatsset=new list<interview_Status_table>();        
        List<string> listsub =new list<string>();
        listsub.add('Phone Interview');
        listsub.add('Admissions Interview');         
        listsub.add('In Person Interview');
        listsub.add('Follow Up Call');
        for(event e:[select id, ShowAs,Subject,StartDateTime,whatid,Event_Start_Time__c,Event_Close_Time__c,Event_RequiredField__c,Interview_Status__c,EndDateTime,WhoId,Description From Event where WhoId=:currlead_rec.Id  and subject IN:listsub and StartDateTime<=:system.Now()])
        {       
            intstatsset.add(new interview_Status_table(e,'Close'));
            show_inter_stats_savebtn=true;         
        }
     }
     
     
     public void ask_save_interview_Status_table()
     {
        boolean contains_cancel=false;
        confirmdel=false; 
        //code for saving interview status. checking to display delete or keep message?
        for(interview_Status_table ievt:intstatsset)
        {
                if(ievt.intstats=='Cancelled')
                        contains_cancel=true;
        }       
        if(contains_cancel)
        {
                confirmdel=true;        
        }
        else
        {
                save_interview_Status_table();
        }
     }
     
     
     public void save_canceledintrvs()
     {
        save_cancel_intrvws=true;
        save_interview_Status_table();
     }
     
     
     public Pagereference save_interview_Status_table()
     {
        Map<id,Event> map_ctct_evt_upds=new Map<id,Event>();
        List<Event> lstevt_upds=new List<Event>();
        List<Event> lstevt_dels=new List<Event>();
        for(interview_Status_table ievt:intstatsset)
        {
                if(ievt.intstats!=null&&ievt.intstats!='')
                {
                        ievt.evt.Event_Start_Time__c=ievt.evt.StartDateTime;
                        ievt.evt.Event_Close_Time__c=ievt.evt.EndDateTime;
                    if(ievt.evttype=='Open')
                    {
                        ievt.evt.StartDateTime=System.now().addMinutes(-1);
                        ievt.evt.EndDateTime=System.now();
                    }   
                    if(ievt.evt.EndDateTime>System.now())
                    {
                        ievt.evt.EndDateTime=System.now();
                    }
                        ievt.evt.Interview_Status__c=ievt.intstats;
                        ievt.evt.Event_RequiredField__c=true;
                        ievt.evt.ShowAs='Free';
                        lstevt_upds.add(ievt.evt);
                        //to delete canceled interviews.
                        if(ievt.intstats=='cancelled' && !save_cancel_intrvws)
                        {
                            lstevt_dels.add(ievt.evt);
                        }
                }               
                map_ctct_evt_upds.put(ievt.evt.whoid,ievt.evt);
        }
        if(!lstevt_upds.IsEmpty())
        {
                try
                { 
                        update lstevt_upds;
                        show_inter_stats_table=false;
                        show_inter_stats_savebtn=false;
                        list<string> leadids=new list<String>();
                        for(Event e:lstevt_upds)
                        {    if(e.Subject=='Phone Interview'||e.subject=='In Person Interview')
                                leadids.add(e.whoid);   
                        }
                        /*if(!leadids.ISEmpty())                        
                        {
                            list<contact> ctctupds=[select id,Name,Interview_Follow_Up_Date__c,Interview_Status__c,Interview_Date__c,(select id,Contact__c,Name,Interview_Follow_Up_Date__c  from Opportunities__r) from Contact where id IN:leadids];
                            List<Opportunity> updopps=new List<Opportunity>();
                            if(!ctctupds.IsEmpty())
                            {    
                                for(integer i=0;i<ctctupds.size();i++)
                                {
                                    ctctupds[i].Interview_Follow_Up_Date__c=System.now();
                                    ctctupds[i].Interview_Status__c=map_ctct_evt_upds.get(ctctupds[i].Id).Interview_Status__c;
                                    Datetime dt=map_ctct_evt_upds.get(ctctupds[i].Id).StartDateTime;
                                    if(dt!=null)
                                        ctctupds[i].Interview_Date__c=dt.date();
                                    for(Opportunity op:ctctupds[i].Opportunities__r)
                                    {
                                        op.Interview_Follow_Up_Date__c=system.now();//ctctupds[i].Interview_Follow_Up_Date__c;
                                        updopps.add(op);
                                    }
                                }
                                try{ update ctctupds;}
                                catch(Exception e1){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error : '+e1));}
                                If(!updopps.IsEmpty())
                                {
                                    try{ update updopps;}
                                    catch(Exception e1){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error : '+e1));}
                                }
                            }   
                                
                        }*/
                }
                catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error : '+e));}
        }
        
        if(!lstevt_dels.ISEmpty())
        {
            try{delete lstevt_dels;}
            catch(Exception e){System.Debug(e);}            
        }
        init_lead();
        return null;
     }
}