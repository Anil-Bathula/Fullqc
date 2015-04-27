/*
    * FinancialForce.com, inc. claims copyright in this software, its screen display designs and
    * supporting documentation. FinancialForce and FinancialForce.com are trademarks of FinancialForce.com, inc.
    * Any unauthorized use, copying or sale of the above may constitute an infringement of copyright and may
    * result in criminal or other legal proceedings.
    *
    * Copyright FinancialForce.com, inc. All rights reserved.
*/

/**
     * Converts  new trigger collection  to generic sobject collection  and forwards to Helper 
     * Note this trigger is installed as a post deployment step to avoid package dependencies
     *                      
*/

trigger TransactionEvent on Finance_Transactions__c (after insert) 
{
    if ( (trigger.isInsert) &&  (trigger.isAfter) )
    {
    
        List<SObject>  transactions = new List<SObject> ();
        for (Finance_Transactions__c o : trigger.New)
        {
            transactions.Add( (SObject) o);
        }
        
         ffps_hult.TriggerHelper.ExecuteFinanceTransactionEvents(transactions);
    }
}