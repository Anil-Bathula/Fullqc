/*
Author          : Premanath Reddy
Created Date    : 16/08/2013
Purpose         : Jira case :-SFSUP-646
                  It will display some contact fields and display an edit button.
                  Edit button should allow to edit the fields and save/cancel them.
Modified By     : Anil.B on 27/11/2013 --Jira no: SFSUP-672
Test class      : opp_comments_test(85%)
Code coverage   : 84%
*/
public class opp_applicantpage {
    public String oppid{get;set;}
    public String conid{get;set;}
    public Opportunity opp{get;set;}
    public Contact con{get;set;}
    public boolean editmode{get;set;}
    public boolean viewmode{get;set;}
    public string bcolor{get;set;}
    public opp_applicantpage(ApexPages.StandardController controller) {
        viewmode=true;
        opp = (Opportunity)controller.getRecord();
        conid=((Opportunity)controller.getRecord()).Contact__C;
        bcolor='black';
        //System.Debug('--------------'+conid);
        if(conid==null)
        { 
            viewmode=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Opportunity does not have contact value!'));
        }
        else
        {
            init();
                if(opp .StageName=='Qualified Lead'){bcolor='#DCDCDC';}   
                if(opp .StageName=='In Progress'){bcolor='#E1D8C7';}
                if(opp .StageName=='Waiting for Review' || opp .StageName=='Partial Application'){bcolor='#FFFEC4';}
                if(opp .StageName=='Admissions Endorsed'|| opp .StageName=='Conditionally Accepted'|| opp .StageName=='Accepted'){bcolor='#DBFFC8';}
                if(opp .StageName=='Admissions Endorsed Confirmed'|| opp .StageName=='Conditionally Confirmed'||opp .StageName=='Soft Rejected Confirmed'|| opp .StageName=='Confirmed'){bcolor='#D8E7FF';}
                if(opp .StageName=='Deferral' || opp .StageName=='Rejected'||opp .StageName=='Soft Rejected'|| opp .StageName=='Withdrawn'|| opp .StageName=='Cancellation'){bcolor='#FFD7D7';}
                if(opp .StageName=='Enrolled'){bcolor='#7A7A7A';}
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
            if(conid!=null){
                update con;
            }
        }
        catch(Exception e){
            viewmode=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,''+e.getMessage()));
        }
    }
    
    public void custCancel(){
        editmode=false;
        viewmode=true;
    }
    
    public void init(){
        if(conid!=null){
            con=[Select Id,Name,Email,Phone,MobilePhone,Country_Of_Origin__c,Country_Of_Citizenship__c
                        ,Region__c,Date_of_Birth_c__c,Gender__c,Telesales_Caller__c
                        ,Country_Of_Residence__c,Age__c,Student_ID__c
                        ,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry from Contact Where id=:conid];
           
        }
    }
}