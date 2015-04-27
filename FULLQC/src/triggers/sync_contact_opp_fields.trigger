/*
    Trigger   : sync_contact_opp_fields
    Events    : After Insert and Update on Contact  
    Developer : Harsha Simha S
    Date      : 10/31/2012
    Comment   : To avoid recursive exceution of triggers using avoid_recursive_syncctctopp_trigg class. 
                Updates Linked in satatus field in Opportunity with the Linked in satatus field value in Contact    
     
*/
trigger sync_contact_opp_fields on Contact (after insert, after update) 
{
    if (!avoid_recursive_syncctctopp_trigg.hastriggfiredalready()) 
    {
        list<contact> ctctlist=new list<contact>();
        Map<Id,contact> ctctmap=new map<Id,contact>();
        for(contact c:trigger.New)
        {
            if(Trigger.isInsert && c.Linked_In_Status__c!=null )
            {
                ctctlist.add(c);
                ctctmap.put(c.Id,c);
            }
            if(Trigger.isUpdate && c.Linked_In_Status__c!= Trigger.oldMap.get(c.Id).Linked_In_Status__c)
            {
                ctctlist.add(c);
                ctctmap.put(c.Id,c);
            }
        }
        if(!ctctlist.IsEmpty())
        {
            list<opportunity> opp=[select id,Name,Contact__c,Linked_In_Status_New__c from opportunity where Contact__c IN:ctctlist];
            if(!opp.IsEmpty())
            {
                for(integer i=0;i<opp.Size();i++)
                {
                    if(ctctmap.ContainsKey(opp[i].Contact__C))
                        opp[i].Linked_In_Status_New__c=ctctmap.get(opp[i].Contact__C).Linked_In_Status__c;
                }
                avoid_recursive_syncctctopp_trigg.settriggfiredalready();
                update opp;
            }
        }
    }
}