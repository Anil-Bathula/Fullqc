/***************************************************************************************
Trigger Name    : Contact_AfterInsertRouting
Author          : Niket Chandane
Created Date    : Aug 7, 2012
Usage           : HULT-184 (When applicant get created Message need to be created for routing purpose)
Revision History: 
-------------------------------------------------------------------------------------------------------------
    Date            Owner               Comment
    8 Aug 2012      Niket Chandane      Added Comment
-------------------------------------------------------------------------------------------------------------
****************************************************************************************/
trigger Contact_AfterInsertRouting on Contact (after insert){
    new Contact_AfterInsertRouting(trigger.new, trigger.new).execute();
}