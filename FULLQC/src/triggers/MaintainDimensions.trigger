trigger MaintainDimensions on Program__c (after update , after insert) 
{
    ffps_hult.MaintainDimensions maintainDimensions  = new  ffps_hult.MaintainDimensions ();
    try
    {
        maintainDimensions.InsertOrUpdateAfter() ;      
    }
    catch(Exception e)
    {
        system.debug(e);
    }
}