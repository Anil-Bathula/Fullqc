/*
    Class     : create_cams_user_ctrlr
    Developer : Harsha Simha S
    Date      : 9/23/2013
    Comment   : This class is an extension for class create_cams_user VF Page and it'll check the opportunity stage and Start Term,
                if they are matched then creates/Updates a user record in CAMS.
    TestClass : contact2opportunity_test
              
*/
public with sharing class create_cams_user_ctrlr {
public Opportunity opp{get;set;}
    public create_cams_user_ctrlr(ApexPages.StandardController controller) 
    {
        opp=new opportunity();
       
    }
    public pagereference init()
    {
        try
        {
            opp = [select id,Name,Start_Term__c,StageName from Opportunity where id=:ApexPAges.CurrentPage().getParameters().get('id')];
        }
        catch(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,''+e);
            ApexPages.addMessage(myMsg);  
            return null;                    
        }
        if(opp.Id!=null)
        {     
        string sterm=HultAPI_calls_from_trigger.CAMS_Start_term; 
            set<string> unames  =new set<string>();/*{'harsha.simha@ef.com.fullqc','daniel.mora@ef.com','harsha.simha@ef.com','anilbathula@ef.com','suresh.babu@ef.com','paolo.castiglione@hult.edu','matthew.spencer@hult.edu','ewelina.oleszek@hult.edu'};            */
             for(CAMS_user_btn_Access__c usrs:CAMS_user_btn_Access__c.getall().values() )
             {
                 unames.add(usrs.name);
             }
             if(opp.Start_Term__c==sterm && (opp.StageName=='Confirmed'||opp.StageName=='Conditionally Confirmed'||opp.StageName=='Soft Rejected Confirmed'))
             {
                 if(!unames.contains(Userinfo.getUserName()))
                 {
                     string err='You are not authorised to use this Process';
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err+' <br/> <a href="/'+opp.Id+'"> Back</a>');
                    ApexPages.addMessage(myMsg);   
                    return null;
                 }
                 try
                 {
                     HultAPI_calls_from_trigger.CreateApplicant_inCAMS_nofuture(new list<string>{opp.Id});    
                     pagereference p=new pagereference('/'+opp.Id);
                     p.setRedirect(true);
                     return p; 
                 }
                 catch(Exception e)
                 {
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,''+e+'<br/> <a href="/'+opp.Id+'">Back</a>');
                    ApexPages.addMessage(myMsg);   
                    return null;                                
                 }
             }
             else
             {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Either Opportunity Start Term is not '+sterm+' or StageName doesnot contain Confirmed. <br/> <a href="/'+opp.Id+'">Back</a>');
                ApexPages.addMessage(myMsg);    
                return null;                   
             }
         }
         return null;
    }
}