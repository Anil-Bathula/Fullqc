public with sharing class new_opp_headers_ctrlr {
/*
    Developer : Harsha Simha
        Extension for  new_opp_headers VF page.
        Modified by :Anil.B on 14/8/2013 Added field Total_Tuition_Fees_Amount_Paid_AR__c in oppfin query.
        Modified by : Prem 22/10/13 changed the bgcolor for Qualified Lead stage from #DCDCDC to #EEE0E5
                      And for In progress Stage from #E1D8C7 to #FFECBF
        Modified by:Anil.B on 27/11/2013 JIRA No:---SFSUP-672 added or condition 49,50 lines.
*/
    public string currleadid{get;set;}
    public opportunity currlead_rec{get;set;}
    public boolean editlead{get;set;}
    public string flagurl{get;set;}
    public string bgcolor{get;set;}
    public string hdr_fntcolor{get;set;}
    public string txt_fntcolor{get;set;}
    public boolean showpaymentbar{get;set;}
    public Double pcntpaid{get;set;}
    
    public new_opp_headers_ctrlr(ApexPages.StandardController controller) {        
        
    }
    /* page load  method which extracts the current opportunity record values 
    and sets flag and status bar for payment and Application status */
    public void init()
    {
        pcntpaid=0.0;
        showpaymentbar=false;
        bgcolor='#D8D8D8';
        hdr_fntcolor='#414141';
        txt_fntcolor='#727272';
        currleadid=Apexpages.currentPage().getparameters().get('id');
        currlead_rec=new Opportunity();
        if(currleadid!=null)
        {//Lead.
            editlead=false;
                currlead_rec=[select id,Name,Interview_Status__c,Program_pre_Parsed__c,Campus_parsed_from_Program__c,
                                Application_Substage__c,Conversion_Team_Member__c,StageName,Conversion_Team_Member__r.Name,
                                Interview_Date__c,Interview_Date_Booked__c,Program_Parsed__c,Region__c ,Country_Of_Residence__c,
                                Contact__c,Contact__r.Country_Of_Origin__r.Flags__c,Contact__r.Country_Of_Origin__r.Name,
                                Contact__r.Country_Of_Citizenship__r.Flags__c,Contact__r.Country_Of_Citizenship__r.Name,                                 
                                Contact__r.Program_Primary__r.Name,Owner.Name,Contact__r.Program_Primary__c,Telesales_Caller__c,
                                OwnerId,LeadSource,Start_Term__c,Percentage_Complete_Application__c,Percent_Complete__c from Opportunity where id=:currleadid];
                
                if(currlead_rec.StageName=='Qualified Lead'){bgcolor='#EEE0E5';hdr_fntcolor='#414141';txt_fntcolor='#727272';}   
                if(currlead_rec.StageName=='In Progress'){bgcolor='#FFECBF';hdr_fntcolor='#414141';txt_fntcolor='#727272';}
                if(currlead_rec.StageName=='Waiting for Review' || currlead_rec.StageName=='Partial Application'){bgcolor='#FFFEC4';hdr_fntcolor='#414141';txt_fntcolor='#727272';}
                if(currlead_rec.StageName=='Admissions Endorsed'|| currlead_rec.StageName=='Conditionally Accepted'|| currlead_rec.StageName=='Accepted'){bgcolor='#DBFFC8';hdr_fntcolor='#414141';txt_fntcolor='#727272';}
                if(currlead_rec.StageName=='Admissions Endorsed Confirmed'|| currlead_rec.StageName=='Conditionally Confirmed'|| currlead_rec.StageName=='Confirmed'||currlead_rec.StageName=='Soft Rejected Confirmed'){bgcolor='#D8E7FF';hdr_fntcolor='#414141';txt_fntcolor='#727272';showpaymentbar=true;}
                if(currlead_rec.StageName=='Deferral' || currlead_rec.StageName=='Rejected'||currlead_rec.StageName=='Soft Rejected'|| currlead_rec.StageName=='Withdrawn'|| currlead_rec.StageName=='Cancellation'){bgcolor='#FFD7D7';hdr_fntcolor='#414141';txt_fntcolor='#727272';}
                if(currlead_rec.StageName=='Enrolled'){bgcolor='#7A7A7A';hdr_fntcolor='#FFFFFF';txt_fntcolor='#FFFFFF';showpaymentbar=true;}
                boolean flagset=false;
                string flag=currlead_rec.Contact__r.Country_Of_Origin__r.Flags__c;
                if(flag!=null && flag.contains('<img '))
                {
                    list<string> s=flag.split('src="');
                    if(s.size()>1)
                    {    
                        flagurl=s[1].substring(0,s[1].indexOf('"'));
                        flagurl=flagurl.replace('&amp;','&');
                        flagset=true;
                    }
                
                }
                
                if(!flagset)
                {
                    string flag1=currlead_rec.Contact__r.Country_Of_Citizenship__r.Flags__c;
                    if(flag1!=null && flag1.contains('<img '))
                    {
                        list<string> s=flag1.split('src="');
                        if(s.size()>1)
                        {    
                            flagurl=s[1].substring(0,s[1].indexOf('"'));
                            flagurl=flagurl.replace('&amp;','&');
                            flagset=true;
                        }
                    
                    }
                }
                
                if(showpaymentbar)
                {
                                        
                    List<Opportunity_Finance__c> oppfin=[Select Id, Total_Tuition_Fees_Amount_Paid__c,Total_Tuition_Fees_Amount_Paid_AR__c,Total_Balance_Due_FS__c,Deposit_Balance__c From Opportunity_Finance__c where Opportunity__c=:currleadid];
                    if(!oppfin.Isempty())
                    {
                        if(oppfin[0].Total_Tuition_Fees_Amount_Paid__c==null ||oppfin[0].Deposit_Balance__c==null || oppfin[0].Deposit_Balance__c==0 )
                        {
                            pcntpaid=0;
                        }
                        else
                        {
                            try
                            {
                                system.debug(oppfin[0].Total_Tuition_Fees_Amount_Paid__c+'---------------'+oppfin[0].Deposit_Balance__c);
                                pcntpaid=((oppfin[0].Total_Tuition_Fees_Amount_Paid_AR__c+oppfin[0].Total_Tuition_Fees_Amount_Paid__c/oppfin[0].Deposit_Balance__c)*100);//Added field Total_Tuition_Fees_Amount_Paid_AR__c by anil.b on 14/8/2013::Jira SFSUP::644
                                system.debug(pcntpaid);
                            }
                            catch(Exception e)
                            {
                                system.debug(e);
                                pcntpaid=0;
                            }
                        }                        
                    }
                    else
                    {pcntpaid=0;}                   
                }                
                
                                       
        }
    }
}