/*
    Trigger   : Contact2Opportunity
    Events    : After Update on Contact  
    Developer : Harsha Simha S
    Date      : 21/8/2013
    Comment   : This Trigger will sync some of the Contact fields with opportunity 
                fields: Program, Start Term, Stage, Linked In Status.
    Test Class: Contact2Opportunity_Test(87%)     
    
 Enhancements :SFSUP-746 even both conditions r same i added if coz in future if new recordtype is added to Application process then no need to change this class.
                byshs on 7/1/2014
                
 Enhancements :SFSUP-989 Added exception to allow pre-university record type to sync opportunity.
                byshs on 7/1/2014                
*/   
trigger Contact2Opportunity on Contact (after update) 
{   
    List<string> ctctid=new List<string>();
    rC_Messaging__Message__c[] messageInsertList = new rC_Messaging__Message__c[] {};
    //string Recid=RecordTypeHelper.getRecordTypeId('Contact', 'Applicant');
    for(contact newctct:Trigger.New)
    {
        //if(newctct.RecordTypeId!=Recid)//SFSUP-746
        if(!RecordTypeHelper.isapplicationprocessrecordtype(newctct.recordtypeid) && RecordTypeHelper.getRecordTypeId('Contact','Pre-University')!=newctct.recordtypeid)  
            continue;
        boolean createmsg=false;
        Contact oldctct=new Contact();      
        if(Trigger.isUpdate)
            oldctct=Trigger.oldMap.get(newctct.Id);
        if(newctct.Program_Primary__c!=oldctct.Program_Primary__c)
            createmsg=true;
        else if(newctct.OwnerId!=oldctct.OwnerId)
            createmsg=true;
        else if(newctct.Start_Term__c!=oldctct.Start_Term__c)
            createmsg=true;
        else if(newctct.Linked_In_Status__c!=oldctct.Linked_In_Status__c)
            createmsg=true; 
        if(createmsg)    
        {   
            ctctid.add(newctct.Id);
            /*
            rC_Messaging__Message__c message = new rC_Messaging__Message__c();
            message.rC_Messaging__Endpoint__c = 'hult://Contact_syncProgramServicer';
            message.rC_Messaging__Effective_Date__c = DateTime.now();
            message.rC_Messaging__Related_Method__c = null;
            message.rC_Messaging__Related_Record__c = newctct.Id;
            message.rC_Messaging__Data__c='new message';
            messageInsertList.add(message); */
        }
    }
    //if (messageInsertList.size() == 0)
    //        return;
     
    //contact2opportunity_servicer.processmessages(messageInsertList);    
    /*// If the servicer is "disabled", then run the code immediately, otherwise use the delayed
    // async aspect of the servicer. This can also be toggled in unit tests.
    if (Setting_Disabled__c.getInstance().Contact_syncProgramServicer__c == true) 
    {
        Contact_syncProgramServicer contactServicer = new Contact_syncProgramServicer();
        contactServicer.processMessageBatch(messageInsertList);
        contactServicer.processDML();
    } 
    else 
    {
        insert messageInsertList;
    }*/
    
    if(!ctctid.IsEmpty())
    {
        
        
        List<Opportunity> oppupdatelist=new List<opportunity>();
        Opportunity[] opportunityList = [select Contact__r.Program_Primary__c,Contact__r.OwnerId,Contact__r.Start_Term__c,Contact__r.Linked_In_Status__c, 
                                        Program__c,OwnerId,Start_Term__c,Linked_In_Status_New__c from Opportunity where Contact__c in :ctctid 
                                        and Contact__c != null and IsClosed = false];
        
        for(opportunity opp:opportunityList)
        {
            boolean addopp=false;
            if(opp.Program__c!=opp.Contact__r.Program_Primary__c && opp.Contact__r.Program_Primary__c!=null)
            {   
                opp.Program__c=opp.Contact__r.Program_Primary__c;
                System.debug('---pppp->'+opp.Program__c);
                addopp=true;
            }
            if(opp.OwnerId!=opp.Contact__r.OwnerId)
            {   
                opp.OwnerId=opp.Contact__r.OwnerId;
                addopp=true;
            }
            if(opp.Start_Term__c!=opp.Contact__r.Start_Term__c && opp.Contact__r.Start_Term__c!=null)
            {   
                opp.Start_Term__c=opp.Contact__r.Start_Term__c;
                addopp=true;
            }
            if(opp.Linked_In_Status_New__c!=opp.Contact__r.Linked_In_Status__c && opp.Contact__r.Linked_In_Status__c!=null)
            {   
                opp.Linked_In_Status_New__c=opp.Contact__r.Linked_In_Status__c;
                addopp=true;
            }
            if(addopp)
                oppupdatelist.add(opp);
        }
        
        if(!oppupdatelist.IsEmpty())
        {
            try
            {
                update oppupdatelist;
            }
            catch(Exception e)
            {               
                Trigger.new[0].adderror('Error :: '+e.getMessage());
                System.debug(e);
            }
        }
    }
}