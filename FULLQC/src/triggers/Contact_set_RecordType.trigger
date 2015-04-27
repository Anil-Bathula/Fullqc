/*
Developer 	 : Harsha Simha  
Date  	 	 : 5/mar/2015
Synopsis 	 : If Program pre-parsed is "Junior" set Record Type as "Pre-university" 
				else if "Accommodation" set "Housing External customer". 
*/
trigger Contact_set_RecordType on Contact (before insert, before update) 
{
	for(Contact con:Trigger.New)
	{
		Contact oldcon=trigger.isUpdate?Trigger.oldMap.get(con.Id):new Contact();
		
		if(con.Program_preParsed__c=='Junior' && RecordTypeHelper.getRecordTypeId('Contact','Pre-University')!=con.RecordTypeId)
		{
				con.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact','Pre-University');		
		}
		if(con.Program_preParsed__c=='Accommodation' && RecordTypeHelper.getRecordTypeId('Contact','Housing External Customer')!=con.RecordTypeId)	
		{
				con.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact','Housing External Customer');
		}		
		
	}
}