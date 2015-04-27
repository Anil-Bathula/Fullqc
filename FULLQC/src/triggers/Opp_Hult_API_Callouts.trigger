/*
	 Developer : Harsha Simha S
    Date      : 6/10/2014
    Comment   : This trigger fires when ever there is a change in the opportunity Campus,program,Start Term,Stage for 2014 start term and confirmed/.. stages. 
                And checks if any records exist then pass the values to HultAPI_calls_from_trigger.CreateApplicant_inCAMS class.(added after update to trigger )
    TestClass : contact2opportunity_test(75%)	
*/
trigger Opp_Hult_API_Callouts on Opportunity (after update) 
{
	list<string> CreateApplicant_inCAMS_oppids=new list<string>();
	map<Id,string> opp_endpointsmap=new map<Id,string>();
	
	for(Opportunity opp:Trigger.New)
	{	
		//runs only for Application process
		if(!RecordTypeHelper.isapplicationprocessrecordtype(opp.RecordTypeId))
            continue;
            
		Opportunity oldopp=trigger.Isafter?Trigger.oldmap.get(opp.id):new Opportunity(); 
		
		if(trigger.Isafter)
        {
        	/*6/10/2014 by shs Start Hult cams APIcallout Logic*/
        	if(opp.Start_Term__c=='September 2014' && (opp.StageName=='Confirmed'||opp.StageName=='Conditionally Confirmed'||opp.StageName=='Soft Rejected Confirmed'))
            {
            	if(opp.Primary_Campus__c!=oldopp.Primary_Campus__c || opp.StageName!=oldopp.StageName || opp.Start_Term__c!=oldopp.Start_Term__c || opp.Program__c!=oldopp.Program__c)
                 {
                 	  if(!HultAPI_calls_from_trigger.has_rec_alreadywaived(opp.Contact__c+':'+HultAPI_calls_from_trigger.camsapplicant_endpoint))
                      {                      	
                 	   		CreateApplicant_inCAMS_oppids.add(opp.Id);
                 	   		HultAPI_calls_from_trigger.set_rec_waived(opp.Contact__c+':'+HultAPI_calls_from_trigger.camsapplicant_endpoint);
                      }
                 }
            }/*End Hult cams APIcallout Logic*/        
        	
        	
        	/*if((opp.Activate_My_Hult__c!=oldopp.Activate_My_Hult__c && opp.Activate_My_Hult__c) || (opp.Matriculated__c && opp.Matriculated__c!=oldopp.Matriculated__c))
        	{
        		string temp=opp_endpointsmap.containsKey(opp.Id)?opp_endpointsmap.get(opp.Id):' ';
        		opp_endpointsmap.put(opp.Id,temp+' '+HultAPI_calls_from_trigger.Activatemyhult_endpoint+''+HultAPI_calls_from_trigger.separator);        		
        	}
        	if(opp.Activate_My_Hult__c && (opp.StageName!=oldopp.StageName || opp.Primary_Campus__c!=oldopp.Primary_Campus__c || opp.Program__c!=oldopp.Program__c || opp.Applicant_Email__c!=oldopp.Applicant_Email__c) )
        	{
        		string temp=opp_endpointsmap.containsKey(opp.Id)?opp_endpointsmap.get(opp.Id):' ';
        		opp_endpointsmap.put(opp.Id,temp+' '+HultAPI_calls_from_trigger.omlistener_endpoint+''+HultAPI_calls_from_trigger.separator);
        	}
        	if(opp.Reset_Password__c!=null && opp.Reset_Password__c!=oldopp.Reset_Password__c)
        	{
        		string temp=opp_endpointsmap.containsKey(opp.Id)?opp_endpointsmap.get(opp.Id):' ';
        		opp_endpointsmap.put(opp.Id,temp+' '+HultAPI_calls_from_trigger.resetpwd_endpoint+''+HultAPI_calls_from_trigger.separator);
        	}        	
        	if(opp.Last_Log_In1__c!=null && opp.StageName!=oldopp.StageName)
        	{
        		string temp=opp_endpointsmap.containsKey(opp.Id)?opp_endpointsmap.get(opp.Id):' ';
        		opp_endpointsmap.put(opp.Id,temp+' '+HultAPI_calls_from_trigger.stagechange_endpoint+''+HultAPI_calls_from_trigger.separator);        		
        	}*/
        }  
        //if(Trigger.isInsert)
        //{        	
        	//if(opp.Reset_Password__c!=null && opp.Reset_Password__c!=oldopp.Reset_Password__c)
        	//{
        		//string temp=opp_endpointsmap.containsKey(opp.Id)?opp_endpointsmap.get(opp.Id):' ';
        		//opp_endpointsmap.put(opp.Id,temp+' '+HultAPI_calls_from_trigger.resetpwd_endpoint+''+HultAPI_calls_from_trigger.separator);        		
        	//}
        //}  
        
        
	}     
	
	if(!CreateApplicant_inCAMS_oppids.IsEmpty())
    {
        HultAPI_calls_from_trigger.CreateApplicant_inCAMS(CreateApplicant_inCAMS_oppids);    
    }   
/*
	if(!opp_endpointsmap.isEmpty())
    { 
    	HultAPI_calls_from_trigger.myHult_APIcall(opp_endpointsmap);
    	//HultAPI_calls_from_trigger.Activate_myHult(activate_myhult_oppids);
    }*/
    
    System.debug(opp_endpointsmap);    
   
}