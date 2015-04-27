/*
Author          : Premanath Reddy
Created Date    : 05 Nov 2013
Purpose         : This class is for Acceptance Letter Generations Project Based on Stage ,Program Name and Campus.
Modified By     : Anil.B on 8/10/2014 Changed program name from BIBA to BBA.
*/
public class Acceptanceletters_project{
    String var;
    public Opportunity opp{get;set;}
    public String fin{get;set;}
    public String stage{get;set;}
    public boolean firstblock{get;set;}
    public boolean lastblock{get;set;}
    public boolean congratsblock{get;set;}
    public string street{get;set;}
    public string addr{get;set;}
    public String ph{get;set;}
    public String[] condpick{get;set;}
    public String[] adminpick{get;set;}
    public String[] rejectpick{get;set;}
    public String ispdf{get;set;}
    public String isword{get;set;}
    public boolean isVF{get;set;}
    public boolean block1{get;set;}
    public boolean block2{get;set;}
    public boolean block3{get;set;}
    public boolean block4{get;set;}
    public boolean block5{get;set;}
    public boolean block6{get;set;}
    public boolean block7{get;set;}
    public boolean block8{get;set;}
    public boolean block9{get;set;}
    public boolean block10{get;set;}
    public boolean block11{get;set;}
    public boolean block12{get;set;}
    public boolean block13{get;set;}
    public String logoURL{get;set;}
    public String signURL{get;set;}
    public String signURL1{get;set;}
    public boolean henriksign{get;set;}
    public boolean iansign{get;set;}
    public boolean buttons{get;set;}
    public boolean footer_bool{get;set;}
    public String conf_deposit{get;set;}
    public String london_footerURL{get;set;}
    public String dubai_footerURL{get;set;}
    public String footerURL{get;set;}
    public boolean cond_accept{get;set;}
    public String prog_name{get;set;}
    public String curr_date{get;set;}
    public String Paragraph{get;set;}
    public String Paragraph2{get;set;}
    public String Paragraph3{get;set;}
    public String Para_age{get;set;}
    public String buttontype{get;set;}
    public boolean logo_disp{get;set;}
    Public boolean conf_paid{get;set;}
    public String conf_dpstpara{get;set;}
    public String note{get;set;}
    public boolean exceed{get;set;}
    Public String FallvsSpring{get;set;}
    Map<String,String> aemap=new Map<String,String>();
    Map<String,String> camap=new Map<String,String>();
    Map<String,String> rejmap=new Map<String,String>();
    public Acceptanceletters_project() {
        try{
            buttons=true;
            ispdf=null;
            isword=null;
            isvf=false;
            cond_accept=false;
            buttontype=Apexpages.Currentpage().getParameters().get('button');
            if(buttontype=='magicpack'){
                logo_disp=false;
            }
            else{
                logo_disp=true;
            }
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
            //System.Debug('******************'+curr_date);
            
            var=Apexpages.Currentpage().getParameters().get('id');
            opp=[select id,Contact__c,Contact__r.Applicant_Email__c,Contact__r.Name,Contact__r.MailingCountry,Contact__r.Mailingcity,Contact__r.MailingState
                ,Contact__r.Mailingpostalcode,Contact__r.Mailingstreet,Contact__r.FirstName,Contact__r.Birthdate,StageName,Primary_Campus__c,Start_Term__c
                ,Admission_Endorsed_reasons__c,Conditionally_Accepted_Reasons__c,BBA_Student_Type__c,Admission_Endorsed__c,Conditionally_Accepted__c
                ,Program__r.Department__r.Name,Program__r.Name,BBA_Transfer_Credits__c,Start_Year__c,Program_Parsed__c,Program_formatted_for_emails_letters__c
                ,Rejected_Reason__c,Age__c
                ,(Select Id,Opportunity__c,OP_Confirmation_Deposit__c,CurrencyIsoCode,Confirmation_Deposit_Paid__c From Opportunity_Finances__r) 
                from Opportunity where id=:var];
            for(Opportunity_Finance__c f:opp.Opportunity_Finances__r){
                integer num=integer.ValueOf(f.OP_Confirmation_Deposit__c);
                fin=f.CurrencyIsoCode+' '+String.ValueOf(num);
                conf_paid=f.Confirmation_Deposit_Paid__c;
                //System.Debug('***************'+fin);
            }
            if(conf_paid==null){
                conf_paid=false;
            }
            if(fin==null){
                fin='0';
            }
            //This is for to get the Extended pick list values from Custom Settings
            for(opp_Admission_Endorsed_Reasons__c ae:opp_Admission_Endorsed_Reasons__c.getall().values()){
                aemap.put(ae.Pick_List_Value__c,ae.Extended_Text__c);
            }
            for(opp_Conditionally_Accepted_Reasons__c ca:opp_Conditionally_Accepted_Reasons__c.getall().values()){
                camap.put(ca.Pick_List_Value__c,ca.Extended_Text__c);
            }
            for(opp_Rejected_Reason__c rej:opp_Rejected_Reason__c.getall().values()){
                rejmap.put(rej.Pick_List_Value__c,rej.Extended_Text__c);
            }
            if(opp.Start_Term__c.startsWith('January')){
                FallvsSpring='Spring';
            }
            else{
                FallvsSpring='Fall';
            }
            //If Program is BBA
            if(opp.Program__r.Department__r.Name=='BBA' 
                && (opp.StageName=='Accepted' || opp.StageName=='Conditionally Accepted' || opp.StageName=='Rejected'
                    || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Confirmed')){
                henriksign=false;
                iansign=true;
                if(opp.BBA_Transfer_Credits__c==null || opp.BBA_Transfer_Credits__c==null){
                    opp.BBA_Transfer_Credits__c='0';
                }
                //Letters for candidates who have paid their Confirmation deposit - the deposit line should be removed from the letters.
                if(!conf_paid){
                    conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                }
                if(opp.StageName=='Accepted'||opp.StageName=='Confirmed'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null || opp.Conditionally_Accepted__c==true){
                        cond_accept=true;
                    }
                }
                if(opp.StageName=='Conditionally Accepted'||opp.StageName=='Conditionally Confirmed'){
                    cond_accept=true;
                }
                // For Under Age Letters
                Integer age=0;
                if(opp.Contact__r.Birthdate!=null){
                    Date myDate =date.newinstance(2014, 9, 15);
                    Integer temp = opp.Contact__r.Birthdate.daysBetween(myDate);
                    age= Integer.valueOf(temp/365);
                }
                
                conf_dpstpara='';
                if(!conf_paid){
                    conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                }
                if(age<18 && cond_accept!=true){
                    Para_age='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, '+conf_dpstpara+' Please ensure you read our "Appendix B - Guidance notes for Students and Parents of Students under the age of 18" sent to you via email from your Recruiter. You will need to submit your signed "Parental Consent Form for a Student Under-18 on Entry" the day you arrive in order to be able to join Hult International Business School.<br/><br/>';
                }
                else if(age<18 && cond_accept==true){
                    Para_age='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. Please ensure you read our "Appendix B - Guidance notes for Students and Parents of Students under the age of 18" sent to you via email from your Recruiter. You will need to submit your signed "Parental Consent Form for a Student Under-18 on Entry" the day you arrive in order to be able to join Hult International Business School.'+conf_dpstpara+'<br/><br/>';
                }
                else if(age>=18 && cond_accept!=true && !conf_paid){
                    Para_age='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, We ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.<br/><br/>';
                }
                else if(age>=18 && cond_accept==true){
                    Para_age='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. '+conf_dpstpara+'<br/><br/>';
                }
                
                /* Full Accepted - UG */
                if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept!=true && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){//(opp.BBA_Student_Type__c=='First Year' || opp.BBA_Student_Type__c==null)){
                    block1=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    exceed=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                }
                /*Accepted with AP Credits/Trnsfer Credits - UG */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept!=true && (opp.BBA_Student_Type__c=='First Year Advanced' || opp.BBA_Student_Type__c=='Transfer')){
                    if(opp.BBA_Student_Type__c=='First Year Advanced'){
                        Paragraph3='The Admissions Committee has determined that your educational record allows you direct entry onto the program and to be awarded up to '+opp.BBA_Transfer_Credits__c+' US semester hours of academic credit for work successfully completed beyond US 12th grade standard, subject to receipt of official transcripts documenting evidence of success at required grade levels.';
                    }
                    else {
                        Paragraph3='The Admissions Committee has determined that your educational record allows you direct entry on to the program and to transfer up to '+opp.BBA_Transfer_Credits__c+' academic credits for your previous work in higher education, subject to receipt of official transcripts documenting successful completion of these credits.';
                    }
                    block2=True;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    exceed=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                }
                /* Accepted with Conditions - UG */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid))&& cond_accept==true && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){ //(opp.BBA_Student_Type__c=='First Year' || opp.BBA_Student_Type__c==null)){
                    block3=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                /*Accepted with Conditions and AP Credits/Trnsfer Credits - UG  */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept==true && (opp.BBA_Student_Type__c=='First Year Advanced' || opp.BBA_Student_Type__c=='Transfer')){
                    if(opp.BBA_Student_Type__c=='First Year Advanced'){
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry onto the program and to be awarded up to '+opp.BBA_Transfer_Credits__c+' US semester hours of academic credit for work successfully completed beyond US 12th grade standard, subject to receipt of official transcripts documenting evidence of success at required grade levels.';
                    }
                    else {
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry on to the program and to transfer up to '+opp.BBA_Transfer_Credits__c+' academic credits for your previous work in higher education, subject to receipt of official transcripts documenting successful completion of these credits. ';
                    }
                    block4=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                /* Conditionally Accepted - UG and EF Pathway Conditional Acceptance - UG*/
                else if(opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)){
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    exceed=true;
                    prog_name='Bachelor Conditional Acceptance '+opp.Start_Year__c;
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        /*EF Pathway Conditional Acceptance - UG*/
                        if(str.contains('Offcl University Foundation Year Diploma') || str.contains('Official Diploma in Business Management') || str.contains('Cert of UPiBT with 60-63') ){
                            block7=True;
                            Para_age='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. <br/><br/>';
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                        /* Conditionally Accepted - UG */
                        else{
                            note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                            block5=True;
                            if(!conf_paid){
                                conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide the satisfactory test results by August 15th 2014, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                            }
                            if(age<18 && cond_accept==true){
                                Para_age='Please ensure you read our "Appendix B - Guidance notes for Students and Parents of Students under the age of 18" sent to you via email from your Recruiter. You will need to submit your signed "Parental Consent Form for a Student Under-18 on Entry" the day you arrive in order to be able to join Hult International Business School.<br/><br/>';
                            }
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                    }
                    else{
                        note='<br/><br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                        block5=True;
                        if(!conf_paid){
                            conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide the satisfactory test results by August 15th 2014, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                        }
                        if(age<18 && cond_accept==true){
                            Para_age='Please ensure you read our "Appendix B - Guidance notes for Students and Parents of Students under the age of 18" sent to you via email from your Recruiter. You will need to submit your signed "Parental Consent Form for a Student Under-18 on Entry" the day you arrive in order to be able to join Hult International Business School.<br/><br/>';
                        }
                    }
                }
                /* Rejected - UG */
                else if(opp.StageName=='Rejected'){
                    block6=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=true;
                    henriksign=false;
                    iansign=true;
                    if(opp.Rejected_Reason__c!=null){
                        String str=opp.Rejected_Reason__c;
                        rejectpick= str.split(';');
                        pickvals(rejectpick);
                    }
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'You have Entered wrong Information!');
                    ApexPages.addMessage(myMsg);
                    firstblock=false;
                    congratsblock=false;
                    lastblock=false;
                    henriksign=false;
                    iansign=false;
                    ispdf=null;
                    isword=null;
                    isvf=false;
                }
            }
           
            //If Program is Not BBA
            else if((opp.Program__r.Department__r.Name=='MBA' || opp.Program__r.Department__r.Name=='EMBA' || opp.Program__r.Department__r.Name=='MIB'
                    || opp.Program__r.Department__r.Name=='MFIN' || opp.Program__r.Department__r.Name=='MIM' || opp.Program__r.Department__r.Name=='MSE')
                    && (opp.StageName=='Accepted' || opp.StageName=='Conditionally Accepted' || opp.StageName=='Rejected'
                        || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Confirmed' || opp.StageName=='Soft Rejected Confirmed'
                        || opp.StageName=='Soft Rejected')){
               stage=opp.StageName;
               conf_dpstpara='';
                if(opp.Program__r.Department__r.Name=='EMBA' || opp.Program__r.Department__r.Name=='MBA'){
                    Paragraph='As you know, Hult International Business School is ranked among the best in the world by both the Financial Times and the Economist. The Hult '+opp.Program_formatted_for_emails_letters__c+' Program will help you realize your leadership potential by strengthening your managerial skills and sharpening your business acumen. It will also give you confidence as a decision-maker in a global business environment. The Hult student body is unique, talented, and culturally diverse which makes our classroom discussions engaging and enriching. Our graduates are eminently qualified to work and communicate across communities, countries, and cultures.';
                }
                else {
                    Paragraph='As you know, Hult International Business School is ranked among the best in the world by both the Financial Times and the Economist. Hult\'s '+opp.Program_formatted_for_emails_letters__c+' Program will help you realize your leadership potential and will also give you confidence as a decision-maker in a global environment. The Hult student body is unique, talented and culturally diverse making classroom discussions engaging and enriching. Our graduates are qualified to work and communicate across communities, countries, and cultures. ';
                }
                if(opp.StageName=='Accepted'||opp.StageName=='Confirmed'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        cond_accept=true;
                    }
                }
                
                /*Full Acceptance - PG*/
                if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && !cond_accept){
                    block8=True;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=true;
                    iansign=false;
                    if(!conf_paid){
                        conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/. <br/><br/>';
                    }
                    if(opp.Program__r.Department__r.Name=='EMBA'){
                        prog_name='Executive MBA Full Acceptance '+opp.Start_Year__c;
                    }
                    else{
                        prog_name=opp.Program__r.Department__r.Name+' Full Acceptance '+opp.Start_Year__c;
                    }
                }
                /*Accepted with Conditions - PG*/
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept){
                    block9=True;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=true;
                    iansign=false;
                    if(!conf_paid){
                        conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                    }
                    conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. '+conf_dpstpara+'<br/><br/>';
                    if(opp.Program__r.Department__r.Name=='EMBA'){
                        prog_name='Executive MBA Acceptance '+opp.Start_Year__c;
                    }
                    else{
                        prog_name=opp.Program__r.Department__r.Name+' Acceptance '+opp.Start_Year__c;
                    }
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                /* Conditionally Accepted - PG and EF Pathway Conditional Acceptance - PG */
                else if(opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)){
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    henriksign=true;
                    iansign=false;
                    exceed=true;
                    if(opp.Program__r.Department__r.Name=='EMBA'){
                        prog_name='Executive MBA Conditional Acceptance '+opp.Start_Year__c;
                    }
                    else{
                        prog_name=opp.Program__r.Department__r.Name+' Conditional Acceptance '+opp.Start_Year__c;
                    }
                    if(!conf_paid){
                        conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                    }
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        /* EF Pathway Conditional Acceptance - PG */
                        if(str.contains('Cert of the EF Pre-Master’s Prog') || str.contains('Cert of UPiBT with 60-63')){
                            block13=True;
                            conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. <br/><br/>';
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                        /* Conditionally Accepted - PG */
                        else{
                            note=conf_paid+'<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                            block10=True;
                            if(!conf_paid){
                                //conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+' As long as you provide satisfactory test results within 120 days from the date of this letter, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                                conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide satisfactory test results by August 1, 2014, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                            }
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                    }
                    else{
                        note='<br/><br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                        block10=True;
                        if(!conf_paid){
                            conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide satisfactory test results by August 1, 2014, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                        }
                    }
                }
                /*Soft Rejected - PG*/
                else if(opp.StageName=='Soft Rejected' || (opp.StageName=='Soft Rejected Confirmed' && conf_paid)){
                    block11=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=false;
                    henriksign=true;
                    iansign=false;
                    note='<br/><br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                    if(!conf_paid){
                        conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide satisfactory test results by August 1, 2014, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                    }
                    if(opp.Rejected_Reason__c!=null){
                        String str=opp.Rejected_Reason__c;
                        rejectpick= str.split(';');
                        pickvals(rejectpick);
                    }
                }
                /* Rejected - PG */
                else if(opp.StageName=='Rejected'){
                    block12=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=false;
                    henriksign=true;
                    iansign=false;
                    
                    if(opp.Rejected_Reason__c!=null){
                        String str=opp.Rejected_Reason__c;
                        rejectpick= str.split(';');
                        pickvals(rejectpick);
                    }
                }
                
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You have Entered wrong Information!');
                    ApexPages.addMessage(myMsg);
                    firstblock=false;
                    congratsblock=false;
                    lastblock=false;
                    henriksign=false;
                    iansign=false;
                    ispdf=null;
                    isword=null;
                    isvf=false;
                }
            }
            else{
                if(opp.Program__r.Department__r.Name=='Undecided'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Invalid Program Name!');
                    ApexPages.addMessage(myMsg);
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Invalid Stage Name!');
                    ApexPages.addMessage(myMsg);
                }
                firstblock=false;
                congratsblock=false;
                lastblock=false;
                henriksign=false;
                iansign=false;
                ispdf=null;
                isword=null;
                isvf=false;
            }
            
            List<document> documentList=[select id,name from document where Name='Hult Logo for Web' or Name='Henrik sign' or Name='London_footer' or Name='Dubai_footer' or Name='Ian Dougal sign'];
            for(integer i=0;i<documentList.size();i++){ 
                if(documentList[i].Name=='Hult Logo for Web'){
                    String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    logoURL= URL.getSalesforceBaseUrl().toExternalForm()+s;
                    if(logoURL.contains('visual')){
                        logoURL=logoURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Henrik sign'){
                    String s1='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s1;
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Ian Dougal sign'){
                    String s4='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL1= URL.getSalesforceBaseUrl().toExternalForm()+s4;
                    if(signURL1.contains('visual')){
                        signURL1=signURL1.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='London_footer'){
                    String s2='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    london_footerURL= URL.getSalesforceBaseUrl().toExternalForm()+s2;
                    if(london_footerURL.contains('visual')){
                        london_footerURL=london_footerURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Dubai_footer'){
                    String s3='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    dubai_footerURL= URL.getSalesforceBaseUrl().toExternalForm()+s3;
                    if(dubai_footerURL.contains('visual')){
                        dubai_footerURL=dubai_footerURL.replace('visual','content');
                    }
                }
            }
            if(opp.Primary_Campus__c=='Boston'){
                street='1 Education Street';
                addr='Cambridge, MA 02141, US';
                ph='+1 617 746 1990';
            }
            else if(opp.Primary_Campus__c=='Dubai'){
                street='Dubai Internet City';
                addr='PO Box 502988, UAE';
                ph='+971 4 4395600';
                footer_bool=true;
                footerURL=dubai_footerURL;
            } 
            else if(opp.Primary_Campus__c=='London' && opp.Program__r.Department__r.Name=='BBA'){
                street='46 - 47 Russell Square - Bloomsbury';
                addr='London WC 1B 4JP, UK';
                ph='+44 (0) 207 636 5667';
                footer_bool=true;
                footerURL=london_footerURL;
            }
            else if(opp.Primary_Campus__c=='London' && opp.Program__r.Department__r.Name!='BBA'){
                street='37 - 38 John Street';
                addr='London WC1N 2AT';
                ph='+44 (0) 207 636 5667';
                footer_bool=true;
                footerURL=london_footerURL;
            }
            else if(opp.Primary_Campus__c=='San Francisco'){
                street='1355 Sansome Street';
                addr='San Francisco, CA 94111, US';
                ph='+1 415 869 2900';
            }
            else if(opp.Primary_Campus__c=='Shanghai'){
                street='Jinling Hai Xin Building';
                addr='666 Fu Zhou Road, Shanghai, China';
                ph='+852 2111 2370 ';
            }
            else if(opp.Primary_Campus__c=='Undecided'){
                street='Undecided';
                addr='Undecided';
                ph='';
            }
            /*contact=[select id,Name,OP_Program__c,MailingCountry,Mailingcity,MailingState,Mailingpostalcode
                         ,Program_formatted_for_letters__c,Campus__c,FirstName
                        from Contact where id=:opp.contact__c];*/
        }
        Catch(Exception e){
            buttons=false;
            if(var==null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Application ID!');
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
    //This method is for Update/hard code the picklist values
    public void pickvals(String[] pick){
        for(integer i=0;i<pick.size();i++){
            // for Admission_Endorsed_reasons__c field
            if(aemap.containsKey(pick[i])){
                adminpick[i]=aemap.get(pick[i]);
            }
            
            // for Conditionally_Accepted_Reasons__c field
            if(camap.containsKey(pick[i])){
                condpick[i]=camap.get(pick[i]);
            }
            
            // for Rejected_Reason__c field
            if(rejmap.containsKey(pick[i])){
                rejectpick[i]=rejmap.get(pick[i]);
            }
            
        }
    }
}