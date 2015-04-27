/*
Author          : Premanath Reddy
Purpose         : This class is for to Generate Finance support letter in Opportunity finance.
Test class      : financesupport_letter_test (76% covered)
Created Date    : 23/04/2014
Last modified   : Prem (9/1/2015) : I have added a different Start Term – February 2015 for EMBA Shanghai
*/
public class finance_supportletters_proj {

    Public String finid{get;set;}
    public String logoURL{get;set;}
    public String signURL{get;set;}
    public boolean firstblock{get;set;}
    public Opportunity_Finance__c oppfin{get;set;}
    public String curr_date{get;set;}
    public boolean buttons{get;set;}
    public boolean disp_block{get;set;}
    public String start_term{get;set;}
    public Decimal finaid_hotel{get;set;}
    
    public finance_supportletters_proj(){
        try{
            buttons=true;
            finid=Apexpages.Currentpage().getParameters().get('id');
            //System.Debug('**************'+finid);
            DateTime d = datetime.now();
            string monthname= d.format('MMMMM');
            string day = String.valueOf(d.day());
            if (day.endsWith('1'))
            {
                if(day.StartsWith('1') && day != '1') 
                    day=day+'th';
                else 
                    day=day+'st';
            }
            else if (day.endsWith('2'))
            {
                if(day.StartsWith('1') && day != '1') 
                    day=day+'th';
                else 
                    day=day+'nd';
            }
            else if (day.endsWith('3'))
            {
                if(day.StartsWith('1') && day != '1') 
                    day=day+'th';
                else 
                    day=day+'rd';
            }
            else 
                day=day+'th';
            
            curr_date=monthname+' '+day+', '+d.Year();
            
            oppfin=[Select id,Name,Opportunity__r.Contact__c,Opportunity__r.Contact__r.Name,Opportunity__r.Name
                    ,Opportunity__r.Contact__r.MailingCountry,Opportunity__r.Contact__r.Mailingcity
                    ,Opportunity__r.Contact__r.MailingState,Opportunity__r.Contact__r.Mailingpostalcode,Opportunity__r.Contact__r.Mailingstreet
                    ,Opportunity__r.Contact__r.FirstName,Opportunity__r.Primary_Campus__c,Opportunity__r.Program_formatted_for_emails_letters__c
                    ,Opportunity__r.Start_Year__c,Opportunity__r.StageName,Opportunity__r.Application_Substage__c,Opportunity__r.February_2015_EMBA_intake__c
                    ,Start_Term__c,Scholarship_Amount__c,Hult_Financial_Aid__c,OP_Program__c,CurrencyIsoCode,Fin_Aid_Hotel_and_Flight__c
                    ,Opportunity__r.Program_Parsed__c,Opportunity__r.Campus_parsed_from_Program__c
                    from Opportunity_Finance__c where id=:finid];
            if((((oppfin.Opportunity__r.StageName=='Accepted' || oppfin.Opportunity__r.StageName=='Conditionally Accepted' || oppfin.Opportunity__r.StageName=='Soft Rejected') && oppfin.Opportunity__r.Application_Substage__c=='Notified')
                || (oppfin.Opportunity__r.StageName=='Confirmed' || oppfin.Opportunity__r.StageName=='Conditionally Confirmed' || oppfin.Opportunity__r.StageName=='Soft Rejected Confirmed'))
                && ((oppfin.Scholarship_Amount__c!=null && oppfin.Scholarship_Amount__c>0) || (oppfin.Hult_Financial_Aid__c!=null && oppfin.Hult_Financial_Aid__c>0) || (oppfin.Fin_Aid_Hotel_and_Flight__c!=null && oppfin.Fin_Aid_Hotel_and_Flight__c>0 && oppfin.Opportunity__r.Program_Parsed__c=='EMBA')))
            {
                disp_block=true;
                if(oppfin.Opportunity__r.February_2015_EMBA_intake__c && oppfin.Opportunity__r.Program_Parsed__c=='EMBA' && oppfin.Opportunity__r.Campus_parsed_from_Program__c=='Shanghai'){
                    start_term='February '+oppfin.Opportunity__r.Start_Year__c;
                }
                else{
                    start_term=oppfin.Start_Term__c;
                }
                if(oppfin.Opportunity__r.Program_Parsed__c=='EMBA'){
                    Decimal finaid=oppfin.Hult_Financial_Aid__c==null?0:oppfin.Hult_Financial_Aid__c;
                    Decimal finhotel=oppfin.Fin_Aid_Hotel_and_Flight__c==null?0:oppfin.Fin_Aid_Hotel_and_Flight__c;
                    finaid_hotel=finaid+finhotel;
                }
                else{
                    finaid_hotel=oppfin.Hult_Financial_Aid__c;
                }
            }
            else{
                disp_block=false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Page cannot be displayed!');
                ApexPages.addMessage(myMsg);
                return;
            } 
        }
        Catch(Exception e){
            disp_block=false;
            firstblock=false;
            buttons=false;
            if(finid==null || finid==''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Page cannot be displayed!');
                ApexPages.addMessage(myMsg);
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error while loading page!');
                ApexPages.addMessage(myMsg);
            }
        }
    }
}