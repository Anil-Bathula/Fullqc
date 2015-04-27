/***************************************************************************************
Trigger  Name   : Opportunity_syncOwner
Author          : Mahesh Gaddam; Ian Zepp
Created Date    : November 28, 2011
Usage           : This trigger updates Owner field in Contact when Owner field on Opportunities is updated .                 
Revision History: 
****************************************************************************************/
trigger Opportunity_syncOwner on Opportunity (after update) {
    new Opportunity_syncOwner(trigger.old, trigger.new).execute();
}