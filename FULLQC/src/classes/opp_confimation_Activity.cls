/*
Created by    : Premanath Reddy
Date          : 3/1/2013
pupose        : Adding the inline Vf page in Opportnity for Confirmation Activity , Confirmation Activity Notes fields and their Help Notes
                should be visible on changing the Confirmation Activity pick list value.
              
Modified By   : Prem (22/7/2013) SFSUP-637 , When a confirmation activity is created, we need to set the due date to 'today' by default.
                And Testmethod written in Test class , because current api version(28.0) not supported testmothods in class.
Test Class    : opp_confimation_Activity_test
Modified by   : Prem 29/10/2013 Replaced with RecordTypeHelper class instead of using the Query for Record Type for getting id.
Modified By   : Anil.B on 27/11/2013 -JIRA no::::SFSUP-672
                Anil.B on 6/march/2013::::added stagenames=Accepted and Conditionally Accepted in line 42 and added code in 163 and 166.
                
Developer     : Anil.B 
Date          : 22/4/2014 ,11/07/2014-(SFSUP-751) ,8/10/2014
Enhancement   : [Alias :: bba_crct_accomdtn] 
                Removed validation rule  :: BIBAs_should_choose_the_right_accomm_act 
                Added it in this vf page (as this validation should fire from this vf page only.) 
                Changed program parsed from BIBA to BBA.  

Modified by   : Prem 25/06/2014 (SFSUP-744)
*/
public class opp_confimation_Activity {
    Public Opportunity opp{get;set;}
    public Boolean showblock{get;set;}
    public Boolean hidebutton{get;set;}
    public Boolean hidelable{get;set;}
    public Boolean fildblock{get;set;}
    public boolean refreshPage{get;set;}
    public String Confirmation_Activity_Help_Note_c{get;set;}
    public String Confirmation_Activity_c{get;set;}
    public Decimal Engagement{get;set;}
    public Opportunity op {get;set;}
    Public list<Task> vartsk{get;set;}
    String str;
    //Task Record Type 
    //RecordType Rec = [Select id, name From RecordType where Name='Confirmation'];
    String rec = RecordTypeHelper.getRecordTypeId('Task','Confirmation');
    public opp_confimation_Activity(ApexPages.StandardController controller) {
        fildblock=false;
        refreshPage=false;
        opp=new Opportunity();
        str=ApexPages.CurrentPage().getParameters().get('id');
        String s=userinfo.getUserEmail();
        //System.Debug('**************1234**'+str);
        if(str==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        }
        // New Button should be visible if opportunity StageName is Confirmed or Conditionally Confirmed or Admissions Endorsed Confirmed only.
        else{
            op=[select id,Name,stagename,Confirmation_Activity__c,Program_Parsed__c,Accommodation_Status__c,Engagement1__c,Campus_parsed_from_Program__c,Confirmation_Activity_Notes__c from Opportunity where id=:str];
             //System.debug('**************'+op.engagement1__c);
            if(op.stagename=='Confirmed' || op.stagename=='Conditionally Confirmed' || op.stagename=='Admissions Endorsed Confirmed'
                ||op.stagename=='Soft Rejected Confirmed'||op.stagename=='Accepted'||op.stagename=='Conditionally Accepted'){
                hidebutton=true;
                hidelable=true;
            }
            if(op.Confirmation_Activity__c==null){
                hidelable=false;
            }
            Confirmation_Activity_c=op.Confirmation_Activity__c;            
            vartsk=[select id,Subject,Description,CreatedDate,CreatedBy.Name from task where Status='Completed' and whatId=:str and RecordTypeId=:rec ORDER BY Createddate DESC limit 5];
        }
    }
    //This method is for New Button
    public void cusnew(){
        if(str==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        }
        fildblock=true;
        hidebutton=false;
        hidelable=false; 
    }
    //This method is for GoBack Link
    Public Void CustCancel(){ 
        hidebutton=true; 
        hidelable=true;
        fildblock=false;
    }
    //This method is for Save Button
    public void cussave(){

        try{
            System.Debug('========i==========>'+op.Accommodation_Status__c+'==='+opp.Accommodation_Status__c+'---------'+op.Campus_parsed_from_Program__c);
            if(opp.Confirmation_Activity_Notes__c==null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'please add a comment before you save'));
            }
            else if(opp.Confirmation_Activity__c==null){
                hidelable=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Confirmation Activity picklist cannot be set back to -none-!'));
            }   /*start :: bba_crct_accomdtn*/    
            //Modified by   : Prem 25/06/2014 (SFSUP-744)  
             //Modified by   : Anil 11/07/2014 (SFSUP-751)  
            else if(opp.Confirmation_Activity__c!=NULL && opp.Confirmation_Activity__c=='LDN Accommodation booking form for Confirmed'&& (op.Program_Parsed__c==custom_lables.Bachelor_Pgm_abvtn || op.Program_Parsed__c =='Masters'||op.Program_Parsed__c =='MBA')&& op.Campus_parsed_from_Program__c =='San Francisco' ){
               
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select the right activity/campus for this student'));
            }
            else if(opp.Confirmation_Activity__c!=NULL && opp.Confirmation_Activity__c=='SFO Accomodation booking form for Confirmed'&& (op.Program_Parsed__c==custom_lables.Bachelor_Pgm_abvtn || op.Program_Parsed__c =='Masters'||op.Program_Parsed__c =='MBA')&& op.Campus_parsed_from_Program__c =='London' ){
               
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please select the right activity/campus for this student'));
            }/*End :: bba_crct_accomdtn*/
            else{
                op.Confirmation_Activity__c=opp.Confirmation_Activity__c;
                op.Confirmation_Activity_Notes__c=opp.Confirmation_Activity_Notes__c;   
                //op.Accommodation_Status__c=(opp.Accommodation_Status__c=='LDN BBA accomodation booking form for Confirmed'||opp.Accommodation_Status__c=='SFO BBA accomodation booking form for Confirmed')&& op.Program_Parsed__c=='BBA'?'1. Recruiter presented Hult accom.':op.Accommodation_Status__c;
                System.Debug('==========5========>'+opp.Confirmation_Activity__c+'===='+op.Program_Parsed__c);            
                refreshPage=true;
                update op;
                if(op.Confirmation_Activity__c!=null){
                    Task t=New Task();
                    t.RecordTypeId=rec;
                    t.OwnerID=userInfo.getUserId();
                    t.Status='Completed';
                    t.WhatId=op.id;
                    t.whoId=op.contact__c;
                    t.Priority='Normal';
                    t.Description=op.Confirmation_Activity_Notes__c;
                    t.Comments_RL__c=op.Confirmation_Activity_Notes__c;
                    t.subject=op.Confirmation_Activity__c;
                    t.ActivityDate=System.Today();
                    insert t;
                }
            }
            
            //System.Debug('========4r==========>'+opp.Confirmation_Activity__c+'==='+opp.Program_Parsed__c+'---------'+opp.Campus_parsed_from_Program__c);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
        }
    }
    //for onchanging the Confirmation Activity field the Related Help Notes should be visible.
    public void notes(){
        try{
            //System.Debug('**************123**'+opp.Confirmation_Activity__c);
            if(opp.Confirmation_Activity__c=='Connect candidate with a great Alum/Student'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: Contact Shareena Hatta for Alumni lists';
            }
            else if(opp.Confirmation_Activity__c=='Invite candidate to an Event'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: e.g. Open House Meet & Greet, Flying Professor';
            }
            else if(opp.Confirmation_Activity__c=='Give candidate a MyHult refresher over the phone'){
                Confirmation_Activity_Help_Note_c='';
            }
            else if(opp.Confirmation_Activity__c=='Send relevant one pagers'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: e.g. Global rotation, specialization, rankings, etc (with follow up call)';
            }
            else if(opp.Confirmation_Activity__c=='Send candidate the Alumni Testimonial booklet'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: With Follow up Call';
            }
            else if(opp.Confirmation_Activity__c=='Send candidate the Global Careers booklet'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: With Follow up Call';
            }
            else if(opp.Confirmation_Activity__c=='Encourage candidate to take the Culture Active Quiz'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: share your results with them (0.5)';
            }
            else if(opp.Confirmation_Activity__c=='Send a video to your candidate'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: Pick a video you think your candidate will like and send them the link (so many to choose from – LEAP method with Mukul, Get Connected with Yousuf, etc)';
            }
            else if(opp.Confirmation_Activity__c=='Let your candidate know about his/her nearest test center'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: AEC only- If your candidate has not taken the TOEFL/GMAT yet- Do research for them and send them the contact information of the closest test center to their home';
            }
            else if(opp.Confirmation_Activity__c=='Financial planning call'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: Set up session for the candidate with your PH to go over their financial planning and ensure they have a plan in place to pay for their tuition and in time for the first payment deadline';
            }
            else if(opp.Confirmation_Activity__c=='Housing planning call'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: Call with candidate to make sure they have a plan for housing- redirect them to myHult for suggestions or connect them with other confirmed students for a potential house/apt sharing opportunity (Candidates who secure housing earlier have a lesser chance of canceling)';
            }
            else if(opp.Confirmation_Activity__c=='Mandatory Originals (communicated by recruiter)'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: It is mandatory that you bring all your original documents or notarized copies before program start';
            }
            else if(opp.Confirmation_Activity__c=='Mandatory Originals (communicated by converter)'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: It is mandatory that you bring all your original documents or notarized copies before program start';
            }
            else if(opp.Confirmation_Activity__c=='Send Candidate CR/CS Newsletter'){
                Confirmation_Activity_Help_Note_c='[OPTIONAL]: With Follow up Call';
            }
            else if(opp.Confirmation_Activity__c=='Invite Candidate to a dinner'){
                Confirmation_Activity_Help_Note_c='[OPTIONAL]: With Follow up Call';
            }
            else if(opp.Confirmation_Activity__c=='Invite Candidate to a Webinar'){
                Confirmation_Activity_Help_Note_c='[OPTIONAL]: e.g. Life in Boston, Visa Process, Current students talking about their experiences, etc.';
            }
            else if(opp.Confirmation_Activity__c=='Introduce your candidate to other Confirmed Students'){
                Confirmation_Activity_Help_Note_c='';
            }
            else if(opp.Confirmation_Activity__c=='Share the results of the Hult Prize with your candidate'){
                Confirmation_Activity_Help_Note_c='';
            }
            else if(opp.Confirmation_Activity__c=='Offer your candidate to pay for his gmat prep course'){
                Confirmation_Activity_Help_Note_c='[MANDATORY]: up to USD xxx/propose USD 1000, or less.';
            }
            else if(opp.Confirmation_Activity__c=='Invite your candidate to a happy call'){
                Confirmation_Activity_Help_Note_c='with Dean, ED, Stephen, PF, Mukul, Ahmad, Tanja etc.';
            }            
            else{
                Confirmation_Activity_Help_Note_c='';
            }
        }
        Catch(Exception e){}
    }
    
    
  
}