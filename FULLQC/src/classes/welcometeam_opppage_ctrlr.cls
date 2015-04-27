/*
    Class     : welcometeam_opppage_ctrlr
    Page      : welcometeam_opportunitypage
    Developer : Harsha Simha S
    Date      : 22/7/2013
    Comment   : SFSUP-602 Extension for welcometeam_opportunitypage (standard controller :: opportunity) this class logic is to check the user's  Welcome_Team_Campus__c value.
                and to show/hide few sections in the page
    Test Class: Test_various_classes.test_welcometeam_vfpage() [100%]
*/
public with sharing class welcometeam_opppage_ctrlr {
    public string user_loc{get;set;}
    public boolean show_edit{get;set;}
    public welcometeam_opppage_ctrlr(ApexPages.StandardController controller) 
    {
        user_loc=[select id,Name,Welcome_Team_Campus__c from user where id=:userinfo.getuserid()].Welcome_Team_Campus__c;        
        show_edit=false;
    }
    public void edit()
    {
        show_edit=true;
    }
    /*
    public void cancel_sec()
    {
        show_edit=true;
    }*/
}