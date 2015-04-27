trigger Update_lead_stage on Task (after insert, after update)//,before insert,before update) 
{
	/*
	  Harsha Simha
	  Date 7/20/2012
	  for each triggered task if the condition satisfies and isbefore insert/update then set task recordtypeid to Log Results of Call  
	  if Afterinsert/update and condition satisfies then 
	     - if task contains lead then update the lead stage and Telesales caller from task 	
		 - if task contains contact then update the Contact with Telesales caller from task
		 - if task contains Opportunity then update the Opportunity sub-stagewith stage from task
	*/
	string Error;
	boolean iserr=false;
	list<Five9_Calls__c> insfive9=new list<Five9_Calls__c>();
	map<id,Lead> leadsmap=new map<id,Lead>();
	map<id,Contact> ctctsmap=new map<id,Contact>(); 
	map<id,Opportunity> ctctsoppmap=new map<id,Opportunity>(); 
	list<string> leadids=new list<string>();
	list<string> oppids=new list<string>();
	map<string,string> leadstatus=new map<string,string>();
	map<string,string> oppstatus=new map<string,string>(); 
	list<string> usermailids=new list<string>();
	map<string,string> userdetail=new map<string,string>();
	map<string,string> leadusers=new map<string,string>();
	//extracts recordtype id of Log Results of Call 
	/*if(Trigger.isBefore)
	list<recordtype> rectype=[Select SobjectType, Name, Id From RecordType where sobjectType='Task' and Name='Log Results of Calls'];	
	*/
	for(Task t:Trigger.new)
	{
		system.debug(t.Five9__Five9CallType__c+'-----'+t.Five9__Five9SessionId__c+'----'+t.status);
		if(Trigger.isInsert && t.Status=='Completed' && (t.Five9__Five9SessionId__c!=null && t.Five9__Five9SessionId__c.trim()!=''))// && t.Five9__Five9CallType__c=='Outbound')// && t.RecordTypeId=='')//use record type id if status should be updated only for a particular record type
		{
				if(t.WhoId!=null)
				{
					Five9_Calls__c fc=new Five9_Calls__c();
					string twhoid=t.WhoId;				
					fc.After_Call_Work_time__c=t.Five9__Five9WrapTime__c;
					fc.Call_Date__c=t.CreatedDate;
					fc.Call_Duration__c=t.CallDurationInSeconds;
					fc.Call_Result__c=t.CallDisposition;
					fc.Handle_Time__c=t.Five9__Five9HandleTime__c;
					fc.Telesales_Caller__c=t.Five9__Five9AgentName__c;
					fc.task_whoid__c=t.WhoId;
					fc.Five9_campaign__c=t.Five9__Five9Campaign__c;
					insfive9.add(fc);
				}
				//etract lead/contact ids with their respective Agent and Call Disposition
				leadids.add(t.WhoId);
				leadstatus.put(t.WhoId,t.CallDisposition);
				usermailids.add(t.Five9__Five9Agent__c);
				leadusers.put(t.whoId,t.Five9__Five9Agent__c);
				if(t.WhatId!=null)
				{
					//etract Opportunity ids with their Call Disposition
					oppids.add(t.whatid);
					oppstatus.put(t.whatid,t.CallDisposition);
					/*list<string> stats=new list<string>();
					if(oppstatus.containsKey(t.Whatid))
					{
						stats=oppstatus.get(t.Whatid);
					}
					stats.add(t.CallDisposition);
					oppstatus.put(t.whatid,stats);*/
				}
			//}			
		}
		if(Trigger.isUpdate && (t.Status=='Completed' && t.Status!=Trigger.oldMap.get(t.Id).Status ) && (t.Five9__Five9SessionId__c!=null && t.Five9__Five9SessionId__c.trim()!='' ))// && t.Five9__Five9CallType__c=='Outbound')
		{
			
				if(t.WhoId!=null)
				{
					Five9_Calls__c fc=new Five9_Calls__c();
					string twhoid=t.WhoId;				
					fc.After_Call_Work_time__c=t.Five9__Five9WrapTime__c;
					fc.Call_Date__c=t.CreatedDate;
					fc.Call_Duration__c=t.CallDurationInSeconds;
					fc.Call_Result__c=t.CallDisposition;
					fc.Handle_Time__c=t.Five9__Five9HandleTime__c;
					fc.Telesales_Caller__c=t.Five9__Five9AgentName__c;
					fc.task_whoid__c=t.WhoId;
					fc.Five9_campaign__c=t.Five9__Five9Campaign__c;
					insfive9.add(fc);
				}
			//etract lead/contact ids with their respective Agent and Call Disposition
				leadids.add(t.WhoId);
				leadstatus.put(t.WhoId,t.CallDisposition);
				usermailids.add(t.Five9__Five9Agent__c);
				leadusers.put(t.whoId,t.Five9__Five9Agent__c);
				if(t.WhatId!=null)
				{
					oppids.add(t.whatid);
				}
				if(t.WhatId!=null)
				{
					//etract Opportunity ids with their Call Disposition
					oppids.add(t.whatid);
					oppstatus.put(t.whatid,t.CallDisposition);
					/*list<string> stats=new list<string>();
					if(oppstatus.containsKey(t.Whatid))
					{
						stats=oppstatus.get(t.Whatid);
					}
					stats.add(t.CallDisposition);
					oppstatus.put(t.whatid,stats);*/
				}
			
		}
	}	
	system.debug(leadids);
	//if lead/contacts ids (who)is not empty and after trigger extract telesales caller id for each lead/contact	
	if(!leadids.IsEmpty() && Trigger.isAfter)
	{
		if(!usermailids.IsEmpty())
		{
			for(user u:[select id,Name,UserName from User where userName in :usermailids])
			{
				userdetail.put(u.UserName,u.Id);
			}
		}
		system.debug('===='+leadids);
		//if extracted ids are of lead type then query return records and perform mapping and update leads
		List<lead> leadslist=[select id,Name,Lead_Stage__c,Telesales_Caller__c,Country_Of_Residence__c,
								FirstName,LastName,Campus_parsed_from_Program__c,Region__c,Applicant_Email__c,
								Program_Parsed__c,Country_Of_Residence_Name__c,Outsource_Telemarketer__c,
								Outsource_Telemarketer_Company__c,LeadSource,SFGA__Web_Source__c,
								Marketing_Source__c,Interview_Date__c,Interview_Date_Booked__c,
								Interview_Status__c from Lead where id IN: leadids];			
		system.debug('====>>'+leadslist);
		if(!leadslist.IsEmpty())
		{
			for(integer i=0;i<leadslist.size();i++)
			{
				string umail=leadusers.get(leadslist[i].Id);
				string stage=leadstatus.get(leadslist[i].Id);			
				leadslist[i].Lead_Stage__c=stage;
				leadslist[i].Telesales_Caller__c=userdetail.GET(umail);
				leadsmap.put(leadslist[i].Id,leadslist[i]);
			}
			try{
			update leadslist;
			}
			catch(Exception e)
			{
				//Trigger.new[0].adderror(e);
				if(iserr)
					error+='\n'+e;
				else
				{error=''+e;iserr=true;}
			}
		}
		//if extracted ids are of Contact type then query return records and perform mapping and update Contacts
		List<contact> ctctlist=[select id,Name,Telesales_Caller__c,Country_Of_Residence_Name__c,Country_Of_Residence__c,
								FirstName,LastName,Campus_parsed_from_Program__c,Lead_Stage__c,Region__c,Applicant_Email__c,
								Program_Parsed__c,(select id,Name,StageName from opportunities__r) from Contact where id IN: leadids];
		if(!ctctlist.IsEmpty())
		{
			for(integer i=0;i<ctctlist.size();i++)
			{
				string umail=leadusers.get(ctctlist[i].Id);				
				ctctlist[i].Telesales_Caller__c=userdetail.GET(umail);
				ctctsmap.put(ctctlist[i].Id,ctctlist[i]);
				for(Opportunity o:ctctlist[i].Opportunities__r)
				{
					ctctsoppmap.put(ctctlist[i].Id,o);
				}
			}
			try{
			update ctctlist;
			}
			catch(Exception e)
			{
				//Trigger.new[0].adderror(e);
				if(iserr)
					error+='\n'+e;
				else
				{error=''+e;iserr=true;}
			}
		}
		
		//
		
		for(integer i=0;i<insfive9.size();i++)
		{
			if(leadsmap.containskey(insfive9[i].task_whoid__c))
			{
				lead l=new lead();
				l=leadsmap.get(insfive9[i].task_whoid__c);				
				insfive9[i].Country_of_Residence__c=l.Country_of_Residence_Name__c;
				insfive9[i].First_Name__c=l.FirstName;
				insfive9[i].Last_Name__c=l.LastName;
				insfive9[i].Program__c=l.program_Parsed__c;
				insfive9[i].Stage__c='Lead';
				insfive9[i].Email__c=l.Applicant_Email__c;
				insfive9[i].Region__c=l.Region__c;
				insfive9[i].Campus__c=l.Campus_parsed_from_Program__c;
				insfive9[i].Outsource_Telemarketer__c=l.Outsource_Telemarketer__c;
				insfive9[i].Outsource_Telemarketer_Company__c=l.Outsource_Telemarketer_Company__c;
				insfive9[i].Leadsource__C=l.LeadSource;
				insfive9[i].Web_Source__c=l.SFGA__Web_Source__c;
				insfive9[i].Marketing_Source__c=l.Marketing_Source__c;
				insfive9[i].Interview_Date__c=l.Interview_Date__c;
				insfive9[i].Interview_Date_Booked__c=l.Interview_Date_Booked__c;
				insfive9[i].Interview_Status__c=l.Interview_Status__c;
			}
			else if(ctctsmap.containskey(insfive9[i].task_whoid__c))
			{
				Contact c=new Contact();
				c=ctctsmap.get(insfive9[i].task_whoid__c);				
				insfive9[i].Country_of_Residence__c=c.Country_of_Residence_Name__c;
				insfive9[i].First_Name__c=c.FirstName;
				insfive9[i].Last_Name__c=c.LastName;
				insfive9[i].Program__c=c.program_Parsed__c;
				if(ctctsoppmap.containsKey(insfive9[i].task_whoid__c))
					insfive9[i].Stage__c=ctctsoppmap.get(insfive9[i].task_whoid__c).StageName;//c.Lead_Stage__c;
				insfive9[i].Email__c=c.Applicant_Email__c;
				insfive9[i].Region__c=c.Region__c;
				insfive9[i].Campus__c=c.Campus_parsed_from_Program__c;
			}
		}
		if(!insfive9.IsEmpty())
		{
			try{
			insert insfive9;
			}
			catch(Exception e)
			{
				
			}
		}
		
	}	
	//if Opportunity ids (what)is not empty and after trigger then extract opps and do mapping.
	if(!oppids.IsEmpty()&& Trigger.isAfter)
	{
		//if extracted ids are of Opportunity type then query return records and perform mapping and update Opportunities.
		List<Opportunity> oppslist=[select id,Name,Application_Substage__c  from Opportunity where id IN: oppids];
		if(!oppslist.IsEmpty())
		{
			for(integer i=0;i<oppslist.size();i++)
			{	
				string stage=oppstatus.get(oppslist[i].Id);
				oppslist[i].Application_Substage__c=stage;
			}
			try{
			update oppslist;			
			}
			catch(Exception e)
			{
				//Trigger.new[0].adderror(e);
				if(iserr)
					error+='\n'+e;
				else
				{error=''+e;iserr=true;}
			}
		}
	}	
	//in dml opperation if error ocurs captures that error in a string and display it.
	if(Trigger.isAfter && iserr )
	{
		Trigger.new[0].adderror(error);
	}
}