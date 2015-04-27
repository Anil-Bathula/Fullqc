trigger Opportunity_UpdateAccount on Opportunity (before insert, before update) {
/*
	//shs : added code to update recruiter field with owner Name
	Modified By : Harsha Simha
	Date		: 7/16/2014
	Changes		: Previously trigger runs every time(recursively) and queries in its related class. 
				  Now added logic to run only when program/owner is changed and update its related Account.	
*/
	List<Opportunity> newopplist=new List<Opportunity>();
	List<Opportunity> oldopplist=new List<Opportunity>();
	for(Opportunity newopp:Trigger.new)
	{
		Opportunity oldopp=Trigger.isUpdate?Trigger.oldmap.get(newopp.Id):new Opportunity();
		if(!RecordTypeHelper.isapplicationprocessrecordtype(newopp.recordtypeid))
        	continue;     	
        if(newopp.program__c!=oldopp.Program__c || newopp.OwnerId!=oldopp.OwnerId)
        {        	
        	newopplist.add(newopp);
        	oldopplist.add(oldopp);
        }		
	}
	if(!newopplist.IsEmpty())
	{
		new Opportunity_UpdateAccount(oldopplist, newopplist).execute();
	}
    //new Opportunity_UpdateAccount(trigger.old, trigger.new).execute();    
}