/*
Author           : Premanath Reddy
Created Date     : January 28, 2013
Usage            : This class is for to create Button on Opportunity. When we click,Email Templates should visible 
                   based on Application stage and program. 
Test class       : opp_EmailTemplate_Test
code coverage    : 95%
Modified By      : Anil.B on 27/11/2013 ---JIRA No::SFSUP-672.
*/
public class opp_EmailTemplate {
    String var;
    public Opportunity opp{get;set;}
    public String fin{get;set;}
    public Contact contact{get;set;}
    public String stage{get;set;}
    public String bbacredits{get;set;}
    public boolean firstblock{get;set;}
    public boolean lastblock{get;set;}
    public string street{get;set;}
    public string addr{get;set;}
    public String ph{get;set;}
    public String[] condpick{get;set;}
    public String[] adminpick{get;set;}
    public String ispdf{get;set;}
    public String isword{get;set;}
    public boolean isVF{get;set;}
    public boolean block1{get;set;}
    public boolean block2{get;set;}
    public boolean block3{get;set;}
    public boolean block4{get;set;}
    public boolean block5{get;set;}
    public opp_EmailTemplate() {
        try{
            ispdf=null;
            isword=null;
            isvf=false;
            if(Apexpages.Currentpage().getParameters().get('type')=='pdf')
            {
                ispdf='pdf';
                isword=null;
                isvf=false;
            }
            else if(Apexpages.Currentpage().getParameters().get('type')=='word')
            {
                ispdf=null;
                isword='application/msWord';
                isvf=false;
            }
            else
            {
                ispdf=null;
                isword=null;
                isvf=true;
            }
            var=Apexpages.Currentpage().getParameters().get('id');
            opp=[select id,Contact__c,Contact__r.Applicant_Email__c,StageName,Primary_Campus__c
                ,Admission_Endorsed_reasons__c,Conditionally_Accepted_Reasons__c,BBA_Student_Type__c
                ,Program__r.Department__r.Name,Program__r.Name,BBA_Transfer_Credits__c
                ,(Select Id,Opportunity__c,OP_Confirmation_Deposit__c,CurrencyIsoCode From Opportunity_Finances__r) 
                from Opportunity where id=:var];
            //If Program is BBA
            if(opp.Program__r.Department__r.Name=='BBA' && (opp.StageName=='Conditionally Accepted'|| opp.StageName=='Accepted')){
                bbacredits=opp.BBA_Transfer_Credits__c;
                if(opp.StageName=='Conditionally Accepted'&& opp.BBA_Student_Type__c==null){
                    firstblock=true;
                    lastblock=true;
                    block1=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                    }
                }
                else if(opp.StageName=='Conditionally Accepted'&&opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    block2=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                    }
                }
                else if(opp.StageName=='Conditionally Accepted'&&opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    block3=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                    }
                }
                else if(opp.StageName=='Accepted'&&opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    block4=True;
                }
                else if(opp.StageName=='Accepted'&&opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    block5=True;
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'You have Entered wrong Information!Check with Biba_Student Type!');
                    ApexPages.addMessage(myMsg);
                }
            }
            //If Program is Not BBA
            else if(opp.Program__r.Department__r.Name!='BBA' && (opp.StageName=='Conditionally Accepted'|| opp.StageName=='Accepted' || opp.StageName=='Admissions Endorsed'
                        || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Confirmed' || opp.StageName=='Admissions Endorsed Confirmed'|| opp.StageName=='Soft Rejected Confirmed')){
                stage=opp.StageName;
                firstblock=true;
                lastblock=true;
                if(opp.StageName=='Conditionally Accepted' && opp.Conditionally_Accepted_Reasons__c!=null){
                    String str=opp.Conditionally_Accepted_Reasons__c;
                    condpick= str.split(';');
                }
                if((opp.StageName=='Admissions Endorsed'||opp.StageName=='Conditionally Accepted')&&opp.Admission_Endorsed_reasons__c!=null){
                    String str=opp.Admission_Endorsed_reasons__c;
                    adminpick= str.split(';');
                }
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Invalid Stage Name!');
                ApexPages.addMessage(myMsg);
                firstblock=false;
                lastblock=false;
                ispdf=null;
                isword=null;
                isvf=false;
            }
            if(opp.Primary_Campus__c=='Boston'){
                street='1 Education Street,';
                addr='Cambridge, MA 02141,US';
                ph='+1 617 746 1990';
            }
            else if(opp.Primary_Campus__c=='Dubai'){
                street='Dubai Internet City,';
                addr='PO Box 502988,UAE';
                ph='+971 4 4395600';
            } 
            else if(opp.Primary_Campus__c=='London'){
                street='46-47 Russell Square - Bloomsbury,';
                addr='London WC 1B 4JP,UK';
                ph='+44 (0) 207 636 5667';
            }
            else if(opp.Primary_Campus__c=='San Francisco'){
                street='1355 Sansome Street,';
                addr='San Francisco, CA 94111,US';
                ph='+1 415 869 2900';
            }
            else if(opp.Primary_Campus__c=='Shanghai'){
                street='Jinling Hai Xin Building,';
                addr='666 Fu Zhou Road,Shanghai,China';
                ph='+852 2111 2370 ';
            }
            else if(opp.Primary_Campus__c=='Undecided'){
                street='Undecided';
                addr='Undecided';
                ph='';
            }
            contact=[select id,Name,OP_Program__c,MailingCountry,Mailingcity,MailingState,Mailingpostalcode
                         ,Program_formatted_for_letters__c,Campus__c,FirstName
                        from Contact where id=:opp.contact__c];
            for(Opportunity_Finance__c f:opp.Opportunity_Finances__r){
                
                fin=f.CurrencyIsoCode+' '+String.ValueOf(f.OP_Confirmation_Deposit__c);
                System.Debug('***************'+fin);
            }  
                    
        }
        Catch(Exception e){
            if(var==null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Appication ID!');
                ApexPages.addMessage(myMsg);
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'-->'+e);
                ApexPages.addMessage(myMsg);   
            }
        } 
    }
    public void donothing()
    {    
    }
    
}