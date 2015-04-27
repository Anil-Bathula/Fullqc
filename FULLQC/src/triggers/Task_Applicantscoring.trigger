trigger Task_Applicantscoring on Task (after delete, after insert, after update) 
{
	/*
		Trigger   : Task_Applicantscoring
		Events	  : After Insert, Update and Delete on Task
		Developer : Harsha Simha S
		Date	  : 12/19/2012
		Comment   : When task is created or deleted then check the task record type and 
					set above checkbox values  as true or false based on the record type 
					and DML action (insert –true ,delete –false)
					
		Changes	  : Added logic to consider Website Visit,Email Viewed:, Email Click Thru:, 
					Email: counts based on task subjects and Their record type should be interview!
		Developer : Harsha Simha S
		Date	  : 1/9/2013							
		
		Changes	  : Added logic to consider Campus visit Record type,and set Last_campus_Visit__c,
					Last_Downloaded_Brouchure__C ,...with the current time when taskis inserted with their respective values.
		Developer : Harsha Simha S
		Date	  : 1/30/2013
					
		Test Class: Lead_ChangeTaskOwnersTest.cls(74%)
		
	*/
	
	List<string> ctctids=new list<String>();
	map<string,List<string>> addmap=new map<String,List<string>>();
	map<string,List<string>> remmap=new map<String,List<string>>();
	map<string,List<string>> submap=new map<String,List<string>>();
	set<string> tsksubjcts=new set<String>{'eBrochure Request','Website Visit'};
	set<string> tsk_rectypes=new set<String>{'eBrochure Request','Brochure Request','Contact Us','Event Signup','GMAT Test','SAT Test','Interview','Campus Visit'};
	List<RecordType> lsttsk_rectyps=[select id,Name,sobjectType from RecordType where sobjectType='task' and Name IN:tsk_rectypes];
	map<String,String>  tsk_rectyps=new map<String,String>();
	for(RecordType r:lsttsk_rectyps)
	{
		tsk_rectyps.put(r.Id,r.Name);
	}	
	if(Trigger.isInsert)
	{
		for(Task t:Trigger.New)
		{
			if(tsk_rectyps.containsKey(t.RecordtypeId) && tsk_rectyps.get(t.RecordtypeId)!='Interview')
			{
				ctctids.add(t.WhoId);
				list<string> temp;
				temp=addmap.ContainsKey(t.whoId)?addmap.get(t.whoId):new list<string>();
				temp.add(t.RecordTypeId);
				addmap.put(t.whoid,temp);
			}
			if(t.Subject!=null && (tsksubjcts.Contains(t.Subject)||t.subject.startsWith('Email click through:')||t.subject.startsWith('Email Viewed:')||t.subject.startsWith('Email:')))
			{
				ctctids.add(t.WhoId);
				list<string> temp;
				temp=submap.ContainsKey(t.whoId)?submap.get(t.whoId):new list<string>();
				if(tsksubjcts.Contains(t.Subject))				
				{
					if(t.Subject=='Website Visit')
					{
						if(tsk_rectyps.get(t.RecordtypeId)=='Interview')
							temp.add(t.subject);
					}
					else
					{
						temp.add(t.subject);
					}
				}
				else
				{
					if(tsk_rectyps.get(t.RecordtypeId)=='Interview')
					{
						if(t.subject.startsWith('Email click through:'))
							temp.add('Email click through:');
						if(t.subject.startsWith('Email Viewed:'))
							temp.add('Email Viewed:');
						if(t.subject.startsWith('Email:'))
							temp.add('Email:');
					}
				}					
				submap.put(t.whoid,temp);
				
				//x.startsWith('Email click through:','Email Viewed:','Email:')				
			}
		}
		if(!ctctids.IsEmpty())
		{
			List<Contact> ctct=[select id,Name,Campus_Visits__c,Downloaded_Brochure__c,Website_Visits__c,Clicked_Thr__c,Emails_Received__c,
								Emails_Viewed__c,Requested_Brochure__c,Event_SignUps__c,Contact_US__c,Hult_GMAT__c,Hult_SAT__c,
								Last_Downloaded_Brochure__c,Last_Website_Visit__c,Last_Email_Clicked_Through__c,Last_Email_Viewed__c,
								Last_Email_Received__c,Last_Requested_Brochure__c,Last_Event_SignUp__c,Last_Hult_GMAT__c,Last_Hult_SAT__c,
								Last_Campus_Visit__c,Last_Contact_us__c from Contact where id IN: ctctids and isDeleted=false];
			if(!ctct.IsEmpty())
			{
				for(integer i=0;i<ctct.size();i++)
				{
					if(submap.containskey(ctct[i].Id))
					{
						for(string s:submap.get(ctct[i].id))
						{
							if(s=='eBrochure Request')
							{								
								ctct[i].Downloaded_Brochure__c=true;
								ctct[i].Last_Downloaded_Brochure__c=system.Now();
							}
							else if(s=='Website Visit')	
							{
								ctct[i].Website_Visits__c=ctct[i].Website_Visits__c==null?1:ctct[i].Website_Visits__c+1;
								ctct[i].Last_Website_Visit__c=system.Now();
							}
							else if(s=='Email click through:')
							{	
								ctct[i].Clicked_Thr__c=ctct[i].Clicked_Thr__c==null?1:ctct[i].Clicked_Thr__c+1;
								ctct[i].Last_Email_Clicked_Through__c=system.Now();
							}
							else if(s=='Email Viewed:')	
							{	
								ctct[i].Emails_Viewed__c=ctct[i].Emails_Viewed__c==null?1:ctct[i].Emails_Viewed__c+1;
								ctct[i].Last_Email_Viewed__c=system.Now();								
							}
							else if(s=='Email:')
							{
								ctct[i].Emails_Received__c=ctct[i].Emails_Received__c==null?1:ctct[i].Emails_Received__c+1;
								ctct[i].Last_Email_Received__c=system.Now();
							}								
						}
						
					}
					if(addmap.containsKey(ctct[i].Id))
					{
						for(string s:addmap.get(ctct[i].Id))
						{
							if(tsk_rectyps.get(s)=='eBrochure Request')
							{
								ctct[i].Downloaded_Brochure__c=true;
								ctct[i].Last_Downloaded_Brochure__c=system.Now();
							}
							if(tsk_rectyps.get(s)=='Brochure Request')
							{
								ctct[i].Requested_Brochure__c=true;
								ctct[i].Last_Requested_Brochure__c=system.now();
							}
							if(tsk_rectyps.get(s)=='Event Signup')
							{	
								ctct[i].Event_SignUps__c=true;
								ctct[i].Last_Event_SignUp__c=system.Now();
							}
							if(tsk_rectyps.get(s)=='Contact Us')
							{
								ctct[i].Contact_US__c=true;
								ctct[i].Last_Contact_us__c=system.Now();
							}
							if(tsk_rectyps.get(s)=='GMAT Test')
							{
								ctct[i].Hult_GMAT__c=true;
								ctct[i].Last_Hult_GMAT__c=system.Now();
							}
							if(tsk_rectyps.get(s)=='SAT Test')
							{	
								ctct[i].Hult_SAT__c	=true;
								ctct[i].Last_Hult_SAT__c=system.Now();
							}
							if(tsk_rectyps.get(s)=='Campus Visit')
							{	
								ctct[i].Campus_Visits__c=true;
								ctct[i].Last_Campus_Visit__c=system.Now();
							}	
						}
					}
				}
				try
				{
					update ctct;
				}
				catch(Exception e)
				{system.debug(e);}	
			}	
		}
	}
	if(Trigger.isUpdate || Trigger.isDelete)
	{
		List<String> contids=new list<string>();
		if(Trigger.isUpdate)
		{			
			for(Task t:Trigger.new)
			{
				if(t.RecordTypeId!=Trigger.oldMap.get(t.Id).RecordTypeId)				
				{
					contids.add(t.WhoId);
				}	system.debug(t.Subject+'!='+Trigger.oldMap.get(t.Id).Subject);
				if(t.Subject!=Trigger.oldMap.get(t.Id).Subject)
				{					
					contids.add(t.WhoId);
				}		
			}			
		}
		if(Trigger.isDelete)
		{
			for(Task t:Trigger.old)
			{	
				if(tsk_rectyps.containsKey(t.RecordtypeId) && tsk_rectyps.get(t.RecordtypeId)!='Interview')
				{	
					contids.add(t.WhoId);
				}
				if(t.Subject!=null && (tsksubjcts.Contains(t.Subject)||t.subject.startsWith('Email click through:')||t.subject.startsWith('Email Viewed:')||t.subject.startsWith('Email:')))
				{
					contids.add(t.WhoId);								
				}
			}			
		}
		if(!contids.Isempty())
		{
			List<Contact> ctct=[select id,Name,Website_Visits__c,Campus_Visits__c,Clicked_Thr__c,Emails_Received__c,
								Emails_Viewed__c,Downloaded_Brochure__c,Requested_Brochure__c,Event_SignUps__c,
								Contact_US__c,(Select Subject,RecordTypeId From Tasks),
								Hult_GMAT__c,Hult_SAT__c from Contact where id IN: contids and isDeleted=false];
			if(!ctct.Isempty())
			{
				for(Integer i=0;i<ctct.size();i++)
				{
					ctct[i].Downloaded_Brochure__c=false;
					ctct[i].Requested_Brochure__c=false;
					ctct[i].Event_SignUps__c=false;
					ctct[i].Contact_US__c=false;
					ctct[i].Hult_GMAT__c=false;
					ctct[i].Hult_SAT__c	=false;
					ctct[i].Website_Visits__c=0;
					ctct[i].Clicked_Thr__c=0;
					ctct[i].Emails_Viewed__c=0;
					ctct[i].Emails_Received__c=0;
					ctct[i].Campus_Visits__c=false;
					for(Task t:ctct[i].Tasks)
					{
						String s=t.RecordtypeId;
						if(tsk_rectyps.get(s)=='eBrochure Request'||t.Subject=='eBrochure Request')
							ctct[i].Downloaded_Brochure__c=true;
						if(tsk_rectyps.get(s)=='Brochure Request')
							ctct[i].Requested_Brochure__c=true;
						if(tsk_rectyps.get(s)=='Event Signup')
							ctct[i].Event_SignUps__c=true;
						if(tsk_rectyps.get(s)=='Contact Us')
							ctct[i].Contact_US__c=true;
						if(tsk_rectyps.get(s)=='GMAT Test')
							ctct[i].Hult_GMAT__c=true;
						if(tsk_rectyps.get(s)=='SAT Test')
							ctct[i].Hult_SAT__c	=true;
						if(tsk_rectyps.get(s)=='Campus Visit')
							ctct[i].Campus_Visits__c=true;
									
						if(tsk_rectyps.get(s)=='Interview')
						{	
							if(t.subject.startsWith('Website Visit'))	
								ctct[i].Website_Visits__c=ctct[i].Website_Visits__c==null?1:ctct[i].Website_Visits__c+1;
							if(t.subject.startsWith('Email click through:'))
								ctct[i].Clicked_Thr__c=ctct[i].Clicked_Thr__c==null?1:ctct[i].Clicked_Thr__c+1;
							if(t.subject.startsWith('Email Viewed:'))	
								ctct[i].Emails_Viewed__c=ctct[i].Emails_Viewed__c==null?1:ctct[i].Emails_Viewed__c+1;
							if(t.subject.startsWith('Email:'))
								ctct[i].Emails_Received__c=ctct[i].Emails_Received__c==null?1:ctct[i].Emails_Received__c+1;
							system.debug(ctct[i].Website_Visits__c+'--'+ctct[i].Clicked_Thr__c+'----'+ctct[i].Emails_Viewed__c+'---'+ctct[i].Emails_Received__c);
						}
					}
				}
				try
				{
					update ctct;
				}
				catch(Exception e)
				{system.debug(e);}
			}			 
		}
	}	
	
}