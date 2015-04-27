trigger CancelInvoiceViaApplicationEvent on Opportunity  (after update) 
{
 

    if ( (trigger.isUpdate) &&  (trigger.isAfter) )
    {
        if ( !ffps_hult.ReEntrant.IsRunning)
        {
            ffps_hult.ReEntrant.IsRunning = true;
            
 
            Map<id, Sobject>  applicantionIdToApplicationNew = trigger.newMap;
            Map<id, Sobject>  applicantionIdToApplicationOld = trigger.oldMap;
          
            ffps_hult.TriggerHelper.BufferJournalIds( applicantionIdToApplicationNew,  applicantionIdToApplicationOld);
 
            //// // Cancellation Event [1] - Stage Change to cancellation or similar
            //// List<id> journalIds001  = EventHelper.getJournalIdsFromApplicationsForCancellation(   applicantionIdToApplicationNew    );
            //// 
            //// // Cancellation Event [2] - Program name changes 
            //// List<id> journalIds002  = EventHelper.getJournalIdsFromApplicationsForCourseChange(   applicantionIdToApplicationNew ,   applicantionIdToApplicationOld  ); 
            //// 
            //// List<id> journalIds =  new  List<id>();
            //// for (Id journalId : journalIds001)
            //// {
            ////     journalIds.Add(journalId);  
            //// }
            //// for (Id journalId : journalIds002)
            //// {
            ////     journalIds.Add(journalId);  
            //// }
            //// 
            //// List<c2g__codaJournal__c> reversalJournals = JournalHelper.reverseJournals(  journalIds);
        }
    }
 
}