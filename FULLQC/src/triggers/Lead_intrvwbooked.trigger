/*
Author        :- Premanath Reddy
Date          :- 9/13/2012
purpose       :- When we create an Event, if it reprasents Lead , 
                 This trigger updates Interview_Date__c on Lead When StartDateTime field is inserted on Event.
*/
trigger Lead_intrvwbooked on Event (before insert,before delete,after insert,after delete) {
  //on insert updates lead/contact (based on whoid value) with interview status.
  if(Trigger.isAfter){
      if(Trigger.isInsert){
          Map<id,Date> varmap = new Map<id,Date>();
           Map<id,Event> evmap = new Map<id,Event>();
          set<Id> ownrids=new set<Id>();
          for(Event e:Trigger.New){
              if(e.StartDateTime!=null&&(e.subject=='Phone Interview'||e.subject=='In Person Interview')){
                  varmap.put(e.WhoId,Date.ValueOf(e.StartDateTime));
                  evmap.put(e.whoId,e);
                  ownrids.add(e.ownerid);                     
              }
          }
          list<Lead> ledlist=new list<Lead>();
          list<Lead> led = [select id,Interview_Date__c,Interview_Date_Booked__c,Interview_Status__c,LBR_d_once__c,Do_Not_Route__c from Lead where id in:varmap.keyset() and isConverted=:false and isDeleted=:false];
          if(!led.IsEmpty()){
            for(Lead a:led){
                a.Interview_Date__c=varmap.get(a.id);
                a.Interview_Date_Booked__c =system.today();
                a.Interview_Status__c='Booked';
                /*if( a.Interview_Status__c=='Booked' || a.Interview_Status__c=='Rescheduled'){  //Added extra condition by Anil.B
                    a.Do_Not_Route__c=true;                                                    //purpose to update Do_Not_Route__c field to true
                } */                                                                             //End of condition // shs:12/13/2012 removed complete condition as LBR_d_once__c over took it
                ledlist.add(a);
            }
            update ledlist;
          }
          list<contact> conlist=new list<contact>();
          list<contact> con = [select id,Interview_Status__c,Interview_Date__c,Interview_Type__c,Interview_Assigned_to__c,Interview_Date_Booked__c from contact where id in:varmap.keyset()];
         if(!con.Isempty()){
            map<id,string> usrs=NEW Map<Id,string>();
            for(user u:[select id,Name from user where id IN:ownrids])
            {usrs.put(u.Id,u.Name);}
            for(contact a:con){
                a.Interview_Date__c=varmap.get(a.id);
                a.Interview_Date_Booked__c =system.today();
                a.Interview_Status__c='Booked';
                a.Interview_Assigned_to__c=usrs.get(evmap.get(a.Id).OwnerId);    
                Event e1=new Event();
                e1=evmap.get(a.Id);                
                if(e1.subject=='Phone Interview'||e1.subject=='In Person Interview')//||e1.subject=='Admissions Interview'||e1.subject=='Follow Up Call')
                {a.Interview_Type__c=e1.subject;}             
                conlist.add(a);
            }
            update conlist;
        }
      }
      /*on delete updates lead/contact (based on whoid value) interview status to null .
      if there are no more events in open activities*/
      if(Trigger.isDelete)
      {
        list<string> updatelist = new list<string>();
        Map<string,string> varmap = new Map<string,string>();
          for(Event e:Trigger.old){  
              if(e.Interview_Status__c!='Cancelled')        
                  varmap.put(e.WhoId,e.Id);          
          }
          List<event> evnt=[select id,Subject,whoid,StartDateTime from Event where whoid IN:varmap.Keyset() and StartDateTime>:system.Now() and (subject='Phone Interview' or subject='In Person Interview')];
          if(!evnt.IsEmpty())
          {
            set<string> setleads = new set<string>();      
            for(event e:evnt)
            {
              setleads.add(e.Id);
            }
            if(setleads.IsEmpty())
            {
              updatelist.addAll(varmap.Keyset());
            }
            else
            {
              for(string s:varmap.Keyset())
              {
                if(!setleads.Contains(s))
                {
                  updatelist.add(s);
                }
              }
            }
          }
          else
          {
            updatelist.addAll(varmap.Keyset());
          }
          if(!updatelist.ISempty())
          {
            List<lead> l=[select id,Name,Interview_Date__c,LBR_d_once__c,Interview_Date_Booked__c,Interview_status__c from lead 
                          where id IN :updatelist  and isConverted=:false and isDeleted=:false];
            if(!l.IsEmpty())
            {
              for(integer i=0;i<l.size();i++)
              {
                l[i].Interview_Date__c=null;
                  l[i].Interview_Date_Booked__c =null;
                  l[i].Interview_Status__c=null;
                  //l[i].Do_Not_Route__c=false;   /*Added extra field by Anil.B*/
              }
              try{
              update l;
              }
              catch(Exception e){system.debug(e);}
            }
            
            List<contact> c=[select id,Name,Interview_Date__c,Interview_Date_Booked__c,Interview_status__c from contact where id IN :updatelist];
            if(!c.IsEmpty())
            {
              for(integer i=0;i<c.size();i++)
              {
                c[i].Interview_Date__c=null;
                  c[i].Interview_Date_Booked__c =null;
                  c[i].Interview_Status__c=null;
              }
              try{
              update c;
              }
              catch(Exception e){system.debug(e);}
            }
          }
       }
    }
    /*When we create new Event/Interview ,If Application has not provided in WhatId(Related To) field,while saving it should update 
      with related Application.*/
    if(Trigger.isbefore && Trigger.isInsert){
        List<id> varid=new List<id>();
        for(Event e:Trigger.New){
            string whoid=e.WhoId;
            if(whoid!=null && whoid.startsWith('003') && e.Whatid==null)
            {
                varid.add(whoid);
            }
        }
        if(!varid.isEmpty()){
            List<Opportunity> opp=[select id,Name,Contact__c from Opportunity where Contact__c IN:varid];
            if(!opp.IsEmpty()){
                for(opportunity o:opp){
                    for(Event e:Trigger.New){
                        e.WhatId=o.Id;
                    }
                }
            } 
        }
    }
    
    /*When we create new Event/Interview ,If Applicant has not provided in whoId(Name) field,while saving it should update 
      with related Applicant.*/
    if(Trigger.isbefore && Trigger.isInsert){
        List<id> varid=new List<id>();
        for(Event e:Trigger.New){
            string WhatId=e.WhatId;
            if(WhatId!=null)
            {
                varid.add(WhatId);
            }
        }
        if(!varid.isEmpty()){
            List<id> conid=new List<id>();
            List<Opportunity> opp=[select id,Name,Contact__c from Opportunity where id IN:varid];
            for(Opportunity o:opp){
                conid.add(o.Contact__c);
            }
            //List<Contact> con=[select id from Contact where id in:conid];
            if(!conid.IsEmpty()){
                for(Integer i=0;i<conid.size();i++){
                    for(Event e:Trigger.New){
                        e.WhoId=conid[i];
                    }
                }
            }  
        }
    }
    //Only admins can delete Event on Contact! 
    if(Trigger.isbefore && Trigger.isdelete){
        List<id> varid=new List<id>();
        for(Event e:Trigger.Old){
            string whoid=e.WhoId;
            if(whoid!=null && whoid.startsWith('003'))
            {
                varid.add(whoid);
            }
        }
        if(!varid.isEmpty()){
            String s = [select id,Profile.Name from User where id = :Userinfo.getUserId()].Profile.Name;
            //System.Debug('===================='+s);
            if(s!='System Administrator'){
                for(Event e:Trigger.Old){
                	if(e.Interview_Status__c!='Cancelled')
                    e.addError('Sorry you does not have privileges to delete this record! Only System Admin can delete');
                }
            }
        }
    }
    
    
}