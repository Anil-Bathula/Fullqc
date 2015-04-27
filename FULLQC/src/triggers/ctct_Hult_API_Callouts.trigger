/*
    Trigger   : ctct_Hult_API_Callouts 
    Developer : Harsha Simha S
    Date      : 6/10/2014
    Comment   : This trigger fires when ever there is a change in the contact First Name,Last Name, Date of birth, 
                country of citizen ship,NickName for 2014 start term and confirmed/.. stages. 
                And checks if any records exist then pass the values to HultAPI_calls_from_trigger.CreateApplicant_inCAMS class.
    TestClass : contact2opportunity_test(100%)
                
             
*/ 
trigger ctct_Hult_API_Callouts on Contact (after update) 
{
    list<string> conids=new list<string>();
    for(Contact con:Trigger.New)
    {
        //runs only for Application process
        if(!RecordTypeHelper.isapplicationprocessrecordtype(con.RecordTypeId))
            continue;
            
        Contact oldcon=Trigger.oldmap.get(con.id); 
        
        System.debug(con.Start_Term__c+'========'+oldcon.LastName+'!='+con.LastName); 
        string sterm=HultAPI_calls_from_trigger.CAMS_Start_term; 
        if(con.OP_Start_Term__c==sterm || con.Start_Term__c==sterm)
        {
            if(oldcon.FirstName!=con.FirstName || oldcon.LastName!=con.LastName || 
                con.Date_of_Birth_c__c!=oldcon.Date_of_Birth_c__c || con.Nickname__c!=oldcon.Nickname__c ||
                con.Country_Of_Citizenship__c!=oldcon.Country_Of_Citizenship__c)
                {
                	if(!HultAPI_calls_from_trigger.has_rec_alreadywaived(con.id+':'+HultAPI_calls_from_trigger.camsapplicant_endpoint))
                    {
                    	conids.add(con.Id);
                    	HultAPI_calls_from_trigger.set_rec_waived(con.id+':'+HultAPI_calls_from_trigger.camsapplicant_endpoint);
                    }
                }
        }
    }
    System.debug(conids.IsEmpty()+'=========='+conids);
    if(!conids.IsEmpty())
    {
        System.debug(conids.IsEmpty()+'=========='+conids);
        HultAPI_calls_from_trigger.CreateApplicant_inCAMS(conids);    
    }
}