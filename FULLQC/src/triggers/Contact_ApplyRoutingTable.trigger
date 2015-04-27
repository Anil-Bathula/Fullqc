trigger Contact_ApplyRoutingTable on Contact (before update) {
    //new Contact_ApplyRoutingTable(trigger.old, trigger.new).execute(trigger.isInsert);
   try{ new Contact_ApplyRoutingTable(trigger.old, trigger.new).executeFromTriggerUpdateAsQueueMessage();
   }catch(Exception e){}
   /*
   		Developer	: Harsha Simha
   		Date		: 29/8/2013
   		Summary		: Added logic : To set AccountId based on the program. when program changes or Account=null
   */
   
	Map<string,List<string>> ctct2pgmid =new map<String,List<string>>();
	//string Recid=RecordTypeHelper.getRecordTypeId('Contact', 'Applicant');
    for(contact c:Trigger.new)
    {
    	if(RecordTypeHelper.isapplicationprocessrecordtype(c.RecordTypeId) && c.Program_Primary__c!=Trigger.oldMap.get(c.Id).Program_Primary__c || c.AccountId==null)
    	{
    		List<string> cids=ctct2pgmid.containsKey(c.Program_Primary__c)?ctct2pgmid.get(c.Program_Primary__c):new List<string>();
    		cids.add(c.Id);
    		ctct2pgmid.put(c.Program_Primary__c,cids);
    	}
    }
    if(!ctct2pgmid.IsEmpty())
	{
		map<string,string> pgmname2id=new map<string,string>();
		List<Program__c> pgms=[select id,Name from Program__c where id IN:ctct2pgmid.keySet()];
		if(!pgms.IsEmpty())
		{
			for(Program__c p:pgms)
			{
				pgmname2id.put(p.Name,p.Id);
			}
			for(Account a:[select id,Name from Account Where Name IN:pgmname2id.Keyset()])
			{
				if( pgmname2id.containsKey(a.Name) && ctct2pgmid.containsKey(pgmname2id.get(a.Name)) )
				{
					for(string s:ctct2pgmid.get(pgmname2id.get(a.Name)))
					{
						Trigger.newMap.get(s).AccountId=a.Id;
					}
				}
			}
		}
	}
}