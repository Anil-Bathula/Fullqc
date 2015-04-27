/********************************************************************************
Trigger    : Addcomments2Application
Written By : Anil.B
Purpose    : When ever a new Application is created and linked with any Applicant
             if the Applicant have any comments then those comments will be attached to this Application
*********************************************************************************/

trigger Addcomments2Application on Opportunity (after insert,after update) {

Set<Id> sobjectSetOfIds = new Set<Id>(); 
map<string,String> smap=new map<string,string>();
    for(Opportunity fs:trigger.new) {
        if(fs.Contact__c!=null)
        {  
            if(Trigger.IsInsert)
            {
                smap.put(fs.Contact__c,fs.id);
                sobjectSetOfIds.add(fs.Contact__c);
            }
            if(Trigger.IsUpdate && fs.Contact__C!=Trigger.oldMap.get(fs.Id).Contact__c)
            {
                smap.put(fs.Contact__c,fs.id);
                sobjectSetOfIds.add(fs.Contact__c);
            }
         }
    }
 /*Querying for the comments which are linked with Applicant and attaching them with new created Applicant*/     
     If(!sobjectSetOfIds.IsEmpty())
     {
        list<Comments__c> comlist = [select id,Application__c,Applicant__c,Finance__c from Comments__c where Applicant__c in :sobjectSetOfIds]; 
        list<Comments__c> updatedcomlist = new list<Comments__c>(); 
        for(Comments__c cm: comlist) 
        {   
            if(smap.containsKey(cm.Applicant__c)){
                cm.Application__c=smap.get(cm.Applicant__c);   
            }        
            updatedcomlist.add(cm); 
         }    
         update updatedcomlist;
     }
}