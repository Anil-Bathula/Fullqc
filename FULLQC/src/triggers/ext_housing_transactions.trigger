/*
    Trigger   : ext_housing_transactions
    Developer : Harsha Simha S
    Purpose   : When any transaction is created for external housing of type Accommodation Fee/ Accocommdation deposit 
                and its status is success/Manually processed then send info to Tcas.
    Test Class: Hult_Apicals_Test(100%)
*/
trigger ext_housing_transactions on Finance_Transactions__c (after insert,after update) 
{
    list<string> sel_ftt=new list<string>();
    for(Finance_Transactions__c ftt : trigger.new)
    {
        Finance_Transactions__c oldftt=Trigger.isUpdate?Trigger.oldMap.get(ftt.Id):new Finance_Transactions__c();
        system.debug(RecordTypehelper.getRecordTypeName(ftt.Finance_RecordTypeId__c)+'-------->'+ftt.Finance_RecordTypeId__c);
        //if(RecordTypehelper.getRecordTypeName(ftt.Finance_RecordTypeId__c)=='Housing External Finance')
        //{   
            system.debug(ftt.Transaction_Status__c+'---------->'+oldftt.Transaction_Status__c);
            system.debug(ftt.Transaction_Type__c+'---------->'+oldftt.Transaction_Type__c);
            
            if(((ftt.Transaction_Status__c=='Success' || ftt.Transaction_Status__c=='Manually Processed')&&
            (ftt.Transaction_Type__c=='Accommodation Deposit' || ftt.Transaction_Type__c=='Accommodation Fee'))&&(ftt.Transaction_Status__c!=oldftt.Transaction_Status__c || ftt.Transaction_Type__c!=oldftt.Transaction_Type__c) )
            {    system.debug('--->'+ftt.Id);
            	sel_ftt.add(ftt.Id);
            	
            }
            if(trigger.isupdate && ftt.Run_Ext_API__c && !oldftt.Run_Ext_API__c)
            {
            	sel_ftt.add(ftt.Id);
            }
        //}
    }   
    if(!sel_ftt.IsEmpty())
    {   
        HultAPI_calls_from_trigger.tcaspayment_APIcall(sel_ftt);                                    
    }    
}