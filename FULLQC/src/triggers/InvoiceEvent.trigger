/*
    * FinancialForce.com, inc. claims copyright in this software, its screen display designs and
    * supporting documentation. FinancialForce and FinancialForce.com are trademarks of FinancialForce.com, inc.
    * Any unauthorized use, copying or sale of the above may constitute an infringement of copyright and may
    * result in criminal or other legal proceedings.
    *
    * Copyright FinancialForce.com, inc. All rights reserved.
*/

/**prod code
     * Converts old and new trigger maps to generic sobject collections and forwards to Helper 
     * Note this trigger is installed as a post deployment step to avoid package dependencies
     *                      
*/
trigger InvoiceEvent on Opportunity_Finance__c (after update) 
{
    //system.debug('.......................'+ffps_hult.ReEntrant.IsRunning_InvoiceEvent);
    
    if ( !ffps_hult.ReEntrant.IsRunning_InvoiceEvent)
    {
        ffps_hult.ReEntrant.IsRunning_InvoiceEvent = true;
        
        if ( (trigger.isUpdate) &&  (trigger.isAfter) )
        {
            Map<id, SObject > idToOldFinance   =  new Map<id, SObject > ();
            Map<id ,SObject > idToNewFinance   =  new Map<id, SObject > (); 
            
          
            for (Opportunity_Finance__c o :  trigger.Old )
            {
                idToOldFinance.put(o.Id, (SObject) o);
            }
            for (Opportunity_Finance__c o :  trigger.New)
            {
                idToNewFinance.put(o.Id, (SObject) o);
            }
            
            
            ffps_hult.TriggerHelper.ExecuteFinanceTransactionEvents( idToOldFinance ,    idToNewFinance  );
        }
    }
}