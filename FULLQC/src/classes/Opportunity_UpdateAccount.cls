public without sharing class Opportunity_UpdateAccount extends OpportunityTrigger {
    public Opportunity_UpdateAccount(Opportunity[] opportunityOldList, Opportunity[] opportunityNewList) {
        super(opportunityOldList, opportunityNewList);
    }
    
    public virtual override void execute() {
    	system.debug('6'+opportunityNewList);
        Map<Id, Program__c> opportunityProgramMap = new Map<Id, Program__c> {};
        list<string> ownrs=new list<string>();
        for(Opportunity opportunityNew : opportunityNewList) {system.debug('7'+opportunityNew);
        	if(!RecordTypeHelper.isapplicationprocessrecordtype(opportunityNew.recordtypeid))//by shs on 7/2/2014 SFSUP-745
        		continue;
            opportunityProgramMap.put(opportunityNew.Program__c, null);
            ownrs.add(opportunityNew.OwnerId);
        }
        
        if(ownrs.IsEmpty())//by shs on 7/2/2014 SFSUP-745
        	return;
        //shs :added to update recruiter
        list<user> usrs=new list<user>();
        usrs=[select id,Name from user where id IN:ownrs];
        Map<id,String> ownrmap=new map<id,string>();
        for(user u:usrs)
        {
            ownrmap.put(u.id,u.Name);
        }
        
        // Select them now
        opportunityProgramMap = new Map<Id, Program__c>([
            select Name
              from Program__c
             where Id in :opportunityProgramMap.keySet()
        ]);
        
        // Build a map of names to account ids
        Map<String, Id> programAccountMap = new Map<String, Id> {};
        
        for(Program__c program : opportunityProgramMap.values())
            programAccountMap.put(program.Name, null);
        
        for(Account acc :[select Name from Account where Name in :programAccountMap.keySet() and Recordtypeid=:RecordTypeHelper.getRecordTypeId('Account','Candidate')])
        {	
        	 programAccountMap.put(acc.Name, acc.Id);
        }
        // Finally, remap to the opp
        for(Opportunity opportunityNew : opportunityNewList) {
            Program__c program = opportunityProgramMap.get(opportunityNew.Program__c);
            
            opportunityNew.Recruiter__c=ownrmap.get(opportunityNew.ownerId);
            
            if (program == null) continue;
            if (programAccountMap.containsKey(program.Name) == false) continue;
            
            opportunityNew.AccountId = programAccountMap.get(program.Name);
        }
    }
}