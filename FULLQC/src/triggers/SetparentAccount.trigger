/*******************************************
Trigger Name: SetParentAccount
Written By  :Anil.B
Purpose : To set AccountName for contacts 
which are with record Type==Parent.
Test class :SetparentAccount_test(100%)
*********************************************/

trigger SetparentAccount on Contact (before Insert) {   
    for(Contact c:Trigger.New){
        if(c.RecordtypeID==RecordTypeHelper.getRecordTypeId('Contact','Parent')){
            c.AccountID='001U0000003CaoZ';
        }
    }

}