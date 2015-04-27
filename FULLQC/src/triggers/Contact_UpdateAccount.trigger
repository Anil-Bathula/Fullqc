/***************************************************************************************
Revision History: 
-------------------------------------------------------------------------------------------------------------
    Date            Owner               Comment
    8 Aug 2012      Niket Chandane      Commented the trigger execution because account 
                                        assignment is happing with routig engine it self. 
-------------------------------------------------------------------------------------------------------------
****************************************************************************************/
trigger Contact_UpdateAccount on Contact (before insert, before update) {
    //new Contact_UpdateAccount(trigger.old, trigger.new).execute();
}