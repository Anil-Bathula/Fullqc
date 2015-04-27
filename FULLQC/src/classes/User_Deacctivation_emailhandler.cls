global class User_Deacctivation_emailhandler implements Messaging.InboundEmailHandler  
{ 
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env)
	{
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	    system.debug(email.plainTextBody+'==================='+email.subject);
	    if((email.subject=='User Deactivation Mail'||email.subject=='Sandbox: User Deactivation Mail') && email.plainTextBody!=null && email.plainTextBody.contains('start::user_subuser'))
	    {
	    	String myPlainText='';     
	    	myPlainText = email.plainTextBody;
	    	map<string,string> uids=new map<string,string>();
	    	map<string,string> ruids=new map<string,string>();
	    	
	    	string temp1=myPlainText.substring(myPlainText.indexOf('start::user_subuser'),myPlainText.indexOf('end::user_subuser'));
	    	if(temp1.contains('{')&&temp1.contains('}')&&temp1.contains(','))
	    	{
		    	string temp2=temp1.substring(temp1.indexOf('{')+1,temp1.indexOf('}'));
		    	for(string s:temp2.split(','))
				{
					if(s.split('=').size()>1) 
						uids.put(s.split('=')[0],s.split('=')[1]);
				}
	    	}
	    	
	    	if(myPlainText.contains('start::route_subuser') && myPlainText.contains('end::route_subuser'))
	    	{
	    		string temp3=myPlainText.substring(myPlainText.indexOf('start::route_subuser'),myPlainText.indexOf('end::route_subuser'));
		    	if(temp3.contains('{')&&temp3.contains('}')&&temp3.contains(','))
	    		{
	    			string temp4=temp3.substring(temp1.indexOf('{')+1,temp3.indexOf('}'));
			    	for(string s:temp4.split(','))
					{
						if(s.split('=').size()>1) 
							ruids.put(s.split('=')[0],s.split('=')[1]);
					}
	    		}
	    	}
	    	
	    	if(!uids.IsEmpty() || !ruids.IsEmpty())
            {
            	Owner_updater o_upd=new Owner_updater(uids,ruids);        
                database.executebatch(o_upd,20);
                    
                lead_owner_updater lo_upd=new lead_owner_updater(uids);        
                database.executebatch(lo_upd,200);
            }
	    
	    }
	    result.success = true;
	   
	    // Return the result for the Apex Email Service
	    return result;
	}	
}