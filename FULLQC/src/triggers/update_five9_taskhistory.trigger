trigger update_five9_taskhistory on Task (before insert, before update) {	
	
	map<string,string> ctctopps=new map<string,string>();	
	
	list<recordtype> rectype=[Select SobjectType, Name, Id From RecordType where sobjectType='Task' and Name='Log Results of Calls'];
	for(Task t:trigger.New)
	{
		if(Trigger.isInsert && t.Status=='Completed' && (t.Five9__Five9SessionId__c!=null && t.Five9__Five9SessionId__c.trim()!=''))// && t.Five9__Five9CallType__c=='Outbound')// && t.RecordTypeId=='')//use record type id if status should be updated only for a particular record type
		{
				t.RecordTypeId=rectype[0].Id;
				string twhoid=t.WhoId;				
				if(twhoid!=null && twhoId.startsWith('003'))
				{
					ctctopps.put(twhoid,t.whatid);
				}				
			
		}
		if(Trigger.isUpdate && (t.Status=='Completed' && t.Status!=Trigger.oldMap.get(t.Id).Status ) && (t.Five9__Five9SessionId__c!=null && t.Five9__Five9SessionId__c.trim()!='' ))// && t.Five9__Five9CallType__c=='Outbound')
		{			
				t.RecordTypeId=rectype[0].Id;
				string twhoid=t.WhoId;
				if(twhoid!=null && twhoId.startsWith('003'))
				{
					ctctopps.put(twhoid,t.whatid);
				}		
		}
	}
	
	if(!ctctopps.Keyset().IsEmpty())
	{
		list<opportunity> opplst=[select id,Name,Contact__c from opportunity where Contact__c IN:ctctopps.Keyset()];
		if(!opplst.IsEmpty())
		{
			for(opportunity o:opplst)
			{
				ctctopps.put(o.Contact__c,o.Id);								
			}
			for(Task t:Trigger.new)
			{				
				t.WhatId=ctctopps.get(t.whoid);
			}
		}		
	}
	
}