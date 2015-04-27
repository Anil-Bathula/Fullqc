/*
Author          : Premanath Reddy
Created Date    : 26/09/2013
Purpose         : Jira case :-SFSUP-658
                  It will display some related contact fields and display an edit button.
                  Edit button should allow to edit the fields and save/cancel them.
Test class      : opp_contactpage_test
Code coverage   : 87%

Modified By Prem: 23/10/2013 Added some fields into VF page ,those are Do Not Route?, Mailing Country and Email Opt Out.
                  25/10/2013 Added one more field 'Do Not Call' to vf page and modified code for to Edit the fields FirstName and LastName.
Modified By     : Anil.B on 27/11/2013---Jira No:SFSUP-672.
Modified By Prem: 5/6/2014 :: Added Applicant_s_Parent__c field.
*/
public class opp_contactpage {
    public String oppid{get;set;}
    public String conid{get;set;}
    public Opportunity opp{get;set;}
    public Contact con{get;set;}
    public boolean editmode{get;set;}
    public boolean viewmode{get;set;}
    public string bcolor{get;set;}
    public Boolean refreshPage {get; set;}
    public opp_contactpage(ApexPages.StandardController controller) {
        viewmode=true;
        refreshPage=false;
        opp = (Opportunity)controller.getRecord();
        conid=((Opportunity)controller.getRecord()).Contact__C;
        bcolor='white';
        //System.Debug('--------------'+conid);
        if(conid==null)
        { 
            viewmode=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Opportunity does not have contact value!'));
        }
        else
        {
            init();
                if(opp.StageName=='Qualified Lead'){bcolor='#EEE0E5';}   
                if(opp.StageName=='In Progress'){bcolor='#FFECBF';}
                if(opp.StageName=='Waiting for Review' || opp.StageName=='Partial Application'){bcolor='#FFFEC4';}
                if(opp.StageName=='Admissions Endorsed'|| opp.StageName=='Conditionally Accepted'|| opp .StageName=='Accepted'){bcolor='#DBFFC8';}
                if(opp.StageName=='Admissions Endorsed Confirmed'|| opp.StageName=='Conditionally Confirmed'|| opp.StageName=='Confirmed'|| opp.StageName=='Soft Rejected Confirmed' ){bcolor='#D8E7FF';}
                if(opp.StageName=='Deferral' || opp.StageName=='Rejected' || opp.StageName=='Soft Rejected' || opp.StageName=='Withdrawn'|| opp.StageName=='Cancellation'){bcolor='#FFD7D7';}
                if(opp.StageName=='Enrolled'){bcolor='#7A7A7A';}
        }
    }
    
    public void custEdit(){
        editmode=true;
        viewmode=false;
        //init();
    }
    
    public void custSave(){
        try{
            editmode=false;
            viewmode=true;
            refreshPage=true;
            if(conid!=null){
                update con;
                update con.opportunities__r;
            }
        }
        catch(Exception e){
            viewmode=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,''+e.getMessage()));
        }
    }
    
    public void custCancel(){
        init();
        editmode=false;
        viewmode=true;
    }
    public void init(){
        if(conid!=null){
            con=[Select Id,Name,FirstName,LastName,Email,Phone,MobilePhone,Country_Of_Origin__c,Country_Of_Origin__r.Name,Country_Of_Citizenship__c,
                        Country_Of_Citizenship__r.Name,Region__c,Date_of_Birth_c__c,Birthdate,Gender__c,Telesales_Caller__c
                        ,Country_Of_Residence__c,Country_Of_Residence__r.Name,Age__c,Student_ID__c
                        ,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry
                        ,HasOptedOutOfEmail,Do_Not_Route__c,DoNotCall,Program_Parsed__c
                        ,(select id,Contact__c,Applicant_s_Parent__c,Applicant_s_Parent__r.Name from opportunities__r) from Contact Where id=:conid];
            
        }
    }
}