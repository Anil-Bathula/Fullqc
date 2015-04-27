/*
Trigger    : Addcomments2finance
Written By : Anil.B
Purpose    : When ever a new Finance is created and linked with any Application
             if the Application have any comments then those comments will be attached to this Finance record.
*/



trigger Addcomments2finance on Opportunity_Finance__c  (after insert,after update) {

Set<Id> sobjectSetOfIds = new Set<Id>(); 
map<string,String> smap=new map<string,string>();
 for(Opportunity_Finance__c fs:trigger.new) {
    if(fs.Opportunity__c!=null)
    {  
        if(Trigger.IsInsert)
        {
            smap.put(fs.opportunity__c,fs.id);
            sobjectSetOfIds.add(fs.Opportunity__c);
        }
        if(Trigger.IsUpdate && fs.Opportunity__c!=Trigger.oldMap.get(fs.Id).Opportunity__c )
        {
            smap.put(fs.opportunity__c,fs.id);
            sobjectSetOfIds.add(fs.Opportunity__c);
        }
     }
 } 
  
/*Querying for  Comments which are linked with Application and attaching them with Finance*/    
    if(!sobjectSetOfIds.IsEmpty())
    {
        list<Comments__c> comlist = [select id,Application__c,Applicant__c,Finance__c from Comments__c where Application__c in :sobjectSetOfIds]; 
        list<Comments__c> updatedcomlist = new list<Comments__c>(); 
        for(Comments__c cm: comlist) 
        {   
            if(smap.containsKey(cm.Application__c))  {
                cm.Finance__c=smap.get(cm.Application__c);   
            }        
            updatedcomlist.add(cm); 
         }
         system.debug(updatedcomlist.size()+'Comments to insert is -----------------------------------'+updatedcomlist);
         update updatedcomlist;
    }
}