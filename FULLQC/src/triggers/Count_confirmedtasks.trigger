trigger Count_confirmedtasks on Task (after delete, after insert, after update) 
{   
    string conf_recid=RecordTypeHelper.getRecordTypeId('Task', 'Confirmation'); 
    list<string> oppids=new list<string>();
    
    if(trigger.isdelete)
    {
        for(task t:trigger.old)
        {
            if(conf_recid==t.RecordTypeId)
            {
                oppids.add(t.whatid);   
            }
        
        }
    }
    else
    {
        for(Task t:Trigger.New)
        {
            Task oldtask=Trigger.isupdate?Trigger.oldMap.get(t.Id):new Task();
            if((conf_recid==t.RecordTypeId || oldtask.RecordTypeId==conf_recid)&&(t.RecordTypeId!=oldtask.RecordTypeId))
            {   
                oppids.add(t.whatid);                           
            }
        }
    }
    
    if(!oppids.IsEmpty())
    {   Date d=Date.newInstance(2014, 3, 1);
        List<Opportunity> opps=[select id,Name,(select id,Subject,RecordTypeId,createdDate from Tasks where RecordTypeId=:conf_recid and createdDate>=:d),Confirmed_Tasks_Count__c from Opportunity where id IN:oppids];
        if(!opps.IsEmpty())
        {
            for(integer i=0;i<opps.Size();i++)
            {
                System.debug(opps[i].Tasks.Size());
                opps[i].Confirmed_Tasks_Count__c=opps[i].Tasks.Size();
            }
            try
            {
                update opps;
            }
            catch(Exception e)
            {
                system.debug(e+'');
            }
        }
    }
    
}