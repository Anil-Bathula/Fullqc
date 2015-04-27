/*
    Modified By : Harsha Simha
    Date        : 7/16/2014
    Changes     : Previously trigger runs every time(recursively) and queries in its related class. 
                  Now added logic to run only when contact is changed and update its related contactroles. 
    Test Class  : Opportunity_UpdateContactRolesTest(90%)
*/
trigger Opportunity_UpdateContactRoles on Opportunity (after insert, after update) 
{
    List<Opportunity> newopplist=new List<Opportunity>();
    List<Opportunity> oldopplist=new List<Opportunity>();
    for(Opportunity newopp:Trigger.new)
    {
        Opportunity oldopp=Trigger.isUpdate?Trigger.newmap.get(newopp.Id):new Opportunity();
        if(!RecordTypeHelper.isapplicationprocessrecordtype(newopp.recordtypeid))
            continue;
       // if(newopp.Contact__c  !=oldopp.Contact__c && newopp.Contact__c!=null)
        //{
            newopplist.add(newopp);
            oldopplist.add(oldopp);
        //}
        system.debug(newopplist+'==========='+oldopplist);
        
    }
    new Opportunity_UpdateContactRoles(oldopplist, newopplist).execute();
    //new Opportunity_UpdateContactRoles(trigger.old, trigger.new).execute();
}