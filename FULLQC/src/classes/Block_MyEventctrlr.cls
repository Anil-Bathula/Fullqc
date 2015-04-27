/*
    Developer : Harsha Simha S
    Created   : 1/17/2013
    Comments  : Custom Controller for the Block_MYEvent VF page, where this is a custom link on home page. 
    Using which users can block  time for specific hours or days with out using any contact/Lead
    Test Class: self (80%) 
*/
public with sharing class Block_MyEventctrlr 
{
    Public Event evt{get;set;}
    Public Block_MyEventctrlr()
    {
        evt=new Event();
    }
    Public Pagereference Save_event()
    {
    system.debug(evt+'-------'+evt.Startdatetime+'   &&   '+evt.Enddatetime);
        if(evt.Startdatetime!=null && evt.Enddatetime!=null)
        {
            if(evt.Startdatetime>=evt.Enddatetime)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Start Time Should Be Less Than End Time'));
            }
            else
            {
                if(evt.Startdatetime<=System.Now())
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Time is already Crossed!'));
                }
                else
                {
                    evt.Event_RequiredField__c=true;
                    evt.OwnerId=Userinfo.getUserId();
                    try
                    {
                        insert evt;
                         return new Pagereference('/home/home.jsp');
                    }
                    catch(Exception e)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,''+e));
                    }
                }
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Start time or End time shouldnot be null'));
        }
        return null;
    }
    
    Public Pagereference cancel()
    {
        return new Pagereference('/home/home.jsp');
    }
    
    static testmethod void Test_BlockEventctrlr()
    {
        Block_MyEventctrlr blk=new Block_MyEventctrlr();
        blk.evt.StartDateTime=System.Now();
        blk.evt.EndDateTime=System.Now().AddHours(4);
        blk.Save_event();
        blk.Cancel();
        blk.evt.StartDateTime=System.Now().AddMinutes(10);
        blk.evt.EndDateTime=System.Now().AddHours(4);
        blk.Save_event();
    }   
}