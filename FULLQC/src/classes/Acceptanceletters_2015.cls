/*
Author          : Premanath Reddy
Created Date    : 07/11/2014
Purpose         : This class is for Acceptance Letter Generations Project Based on Stage ,Program Name and Campus.
Test class      : Acceptanceletters_project_test - 81%
Modified        : (SFSUP-934) - 27/1/2015 - Added Miami Acceptance Letters and overall SF Letter font size changed.
Modified        : SFSUP-1005 - Prem - Updated Letterhead 
*/
public class Acceptanceletters_2015 {
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
    public List<String> condpick{get;set;}
    public List<String> adminpick{get;set;}
    public List<String> rejectpick{get;set;}
    public List<String> waitlstpick{get;set;}
    public String ispdf{get;set;}
    public String isword{get;set;}
    public boolean isVF{get;set;}
    public boolean block1{get;set;}
    public boolean block2{get;set;}
    public boolean block3{get;set;}
    public boolean block4{get;set;}
    public boolean block5{get;set;}
    public boolean block5a{get;set;}
    public boolean block5b{get;set;}
    public boolean block6{get;set;}
    public boolean block7w{get;set;}
    public boolean block7{get;set;}
    public boolean block8{get;set;}
    public boolean block9{get;set;}
    public boolean block10{get;set;}
    //public boolean block11{get;set;}
    public boolean block12{get;set;}
    //public boolean block13{get;set;}
    public String logoURL{get;set;}
    public String signURL{get;set;}
    public String sign_name{get;set;}
    public boolean sign_bool{get;set;}
    public boolean buttons{get;set;}
    public boolean footer_bool{get;set;}
    public String london_footerURL{get;set;}
    public String dubai_footerURL{get;set;}
    public String footerURL{get;set;}
    public String watermark{get;set;}
    public boolean cond_accept{get;set;}
    public String curr_date{get;set;}
    public String Paragraph{get;set;}
    public String Paragraph2{get;set;}
    public String Paragraph3{get;set;}
    public String Para_age{get;set;}
    public String buttontype{get;set;}
    public boolean logo_disp{get;set;}
    Public boolean conf_paid{get;set;}
    public String conf_dpstpara{get;set;}
    Public String FallvsSpring{get;set;}
    Public String janvssep{get;set;}
    public Integer age{get;set;}
    public boolean ef_bool{get;set;}
    Public String rej_para{get;set;}
    public String note{get;set;}
    Map<String,String> aemap=new Map<String,String>();
    Map<String,String> camap=new Map<String,String>();
    Map<String,String> rejmap=new Map<String,String>();
    public String eflogo{get;set;}
    public boolean eflogo_bool{get;set;}
    public String baclogo{get;set;}
    public boolean baclogo_bool{get;set;}
    public String efpara{get;set;}
    public String space_logo{get;set;}
    
    public Acceptanceletters_2015() {
        try{
            condpick =new List<String>();
            adminpick =new List<String>();
            rejectpick =new List<String>();
            waitlstpick =new List<String>();
            sign_bool=true;
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
                ,Rejected_Reason__c,Age__c,Early_Application__c,Waitlisted_Reasons__c
                ,(Select Id,Opportunity__c,OP_Confirmation_Deposit__c,CurrencyIsoCode,Confirmation_Deposit_Paid__c From Opportunity_Finances__r) 
                from Opportunity where id=:var];
            for(Opportunity_Finance__c f:opp.Opportunity_Finances__r){
                integer num=integer.ValueOf(f.OP_Confirmation_Deposit__c);
                fin=f.CurrencyIsoCode+' '+String.ValueOf(num);
                conf_paid=f.Confirmation_Deposit_Paid__c;
                //System.Debug('***************'+fin);
            }
            if(conf_paid==null || (opp.StageName!='Conditionally Confirmed' && opp.StageName!='Confirmed')){
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
            if(opp.Start_Term__c.startsWith('January') && !opp.Early_Application__c){
                FallvsSpring='Spring';
                janvssep=' by December 7th 2014. If you have not confirmed on December 7th then your place cannot be guaranteed.';
            }
            else{
                FallvsSpring='Fall';
                janvssep=' by May 1st '+opp.Start_Year__c+'. If you have not confirmed on May 1st then your place cannot be guaranteed and will be opened to waitlisted candidates.';
            }
            //If Program is BBA
            if(opp.Program__r.Department__r.Name=='BBA' 
                && (opp.StageName=='Accepted' || opp.StageName=='Conditionally Accepted' || opp.StageName=='Rejected'
                    || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Confirmed' || opp.StageName=='Waitlisted')){
                if(opp.BBA_Transfer_Credits__c==null || opp.BBA_Transfer_Credits__c==null){
                    opp.BBA_Transfer_Credits__c='0';
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
                age=0;
                if(opp.Contact__r.Birthdate!=null){
                    Date myDate;
                    if(FallvsSpring=='Spring')
                        myDate=date.newinstance(2015, 1, 15);
                    else
                        myDate=date.newinstance(2015, 9, 15);
                    Integer temp = opp.Contact__r.Birthdate.daysBetween(myDate);//Date.Today()
                    age= Integer.valueOf(temp/365);
                }
                //Letters for candidates who have paid their Confirmation deposit - the deposit line should be removed from the letters.
                conf_dpstpara='';
                if(age<18){
                    Para_age='Please also ensure you read our "Appendix B - Guidance notes for Students and Parents of Students under the age of 18" sent to you via email from your Recruiter. You will need to submit your signed "Parental Consent Form for a Student Under-18 on Entry" the day you arrive in order to be able to join Hult International Business School.<br/><br/>';
                }
                if(!conf_paid){
                    if(opp.Early_Application__c){
                        conf_dpstpara='As per the early decision application conditions, we ask you to submit a '+fin+' non-refundable deposit through the www.hult.edu/en/apply-now/ <b>in the next month</b>. We also ask that you notify any other institutions where you have applications pending so that they can release their seats to other prospective students.<br/><br/>';
                    }
                    else if(age<18 && !cond_accept){
                        conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, we also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/'+janvssep+'<br/><br/>'+Para_age;
                    }
                    else{
                        conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, we also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/'+janvssep+'<br/><br/>';
                    }
                }
                
                /* Full Accepted - UG */
                if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept!=true && opp.BBA_Student_Type__c=='First Year'){//(opp.BBA_Student_Type__c=='First Year' || opp.BBA_Student_Type__c==null)){
                    block1=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                }
                /*Accepted with AP Credits/Trnsfer Credits - UG */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept!=true && (opp.BBA_Student_Type__c=='First Year Advanced' || opp.BBA_Student_Type__c=='Transfer')){
                    if(opp.BBA_Student_Type__c=='First Year Advanced'){
                        Paragraph3='The Admissions Committee has determined that your educational record allows you direct entry onto the program, and to be awarded up to '+opp.BBA_Transfer_Credits__c+' US semester hours of academic credit for work successfully completed beyond US 12th grade standard, subject to receipt of official transcripts documenting evidence of success at required grade levels.';
                    }
                    else {
                        Paragraph3='The Admissions Committee has determined that your educational record allows you direct entry on to the program, and to transfer up to '+opp.BBA_Transfer_Credits__c+' academic credits for your previous work in higher education, subject to receipt of official transcripts documenting successful completion of these credits.';
                    }
                    block2=True;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                }
                /* Accepted with Conditions - UG */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid))&& cond_accept==true && opp.BBA_Student_Type__c=='First Year'){ //(opp.BBA_Student_Type__c=='First Year' || opp.BBA_Student_Type__c==null)){
                    block3=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                /*Accepted with Conditions and AP Credits/Trnsfer Credits - UG  */
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept==true && (opp.BBA_Student_Type__c=='First Year Advanced' || opp.BBA_Student_Type__c=='Transfer')){
                    if(opp.BBA_Student_Type__c=='First Year Advanced'){
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry onto the program, and to be awarded up to '+opp.BBA_Transfer_Credits__c+' US semester hours of academic credit for work successfully completed beyond US 12th grade standard, subject to receipt of official transcripts documenting evidence of success at required grade levels.';
                    }
                    else {
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry on to the program, and to transfer up to '+opp.BBA_Transfer_Credits__c+' academic credits for your previous work in higher education, subject to receipt of official transcripts documenting successful completion of these credits. ';
                    }
                    block4=true;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                /* Conditionally Accepted - Early Decision - UG */
                else if((opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)) && opp.Early_Application__c){
                    note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    String str=opp.Admission_Endorsed_reasons__c;
                    block5b=True;
                    
                   if(opp.Admission_Endorsed_reasons__c!=null){
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                    
                    if(!conf_paid){
                        conf_dpstpara='As per the early decision application conditions, we ask you to submit a '+fin+' non-refundable deposit through the www.hult.edu/en/apply-now/ <b>in the next month</b>. Once you provide satisfactory test results your conditional acceptance will become unconditional. As long as you provide the satisfactory test results not later than May 1st '+opp.Start_Year__c+', your place will be guaranteed and the deposit will become non-refundable. If, however, you fail to meet the standards required, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                    }
                    
                }
                /* Conditionally Accepted (English) - UG - for September*/
                else if((opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)) && FallvsSpring=='Fall'){
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    ef_bool=false;
                    String str=opp.Admission_Endorsed_reasons__c;
                    Set<String> ef_bundle=new Set<String>{'Certificate of EFSET w/ a score of 58+','Cert of EFSET w/ a score of at least 54','Pre-Master program w/B- grade','Pre-MBA program w/B- grade','UFY Diploma w/ C grade'};
                    block5a=True;
                    
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        adminpick= str.split(';');
                        for(String s:adminpick){
                            if(ef_bundle.contains(s)){
                                ef_bool=true;
                                eflogo_bool=true;
                                space_logo='<br/>';
                                //efpara=' following successful completion of your EF program.<br/><br/>';
                                if(opp.Primary_Campus__c=='London')
                                    baclogo_bool=true;
                            }
                        }
                        pickvals(adminpick);
                    }
                    //for BBA EF Bundle - Conditional Acceptance
                    if(ef_bool){
                        if(!conf_paid){
                            conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible and before the start of the program. If you have not confirmed on May 1st then your place cannot be guaranteed and will be opened to waitlisted candidates.<br/><br/>Once you provide satisfactory results from EF your conditional acceptance will become unconditional. If you fail to meet the standards required, your seat will be automatically released. <br/><br/>';
                        }
                    }
                    else if(!conf_paid){
                        conf_dpstpara='<br/><br/>Once you provide satisfactory test results your conditional acceptance will become unconditional. As long as you provide the satisfactory test results and submit a deposit of '+fin+' not later than May 1st 2015, your place will be guaranteed and the deposit will become non-refundable. If, however, you fail to meet the standards required, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                        note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                    }
                    
                }
                /* Conditionally Accepted (English) - UG*/
                else if((opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)) && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){
                    note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    String str=opp.Admission_Endorsed_reasons__c;
                    block5=True;
                    if(!conf_paid){
                        conf_dpstpara='Once you provide satisfactory test results your conditional acceptance will become unconditional. As long as you provide the satisfactory test results and submit a deposit of '+fin+' not later than December 7th your place will be guaranteed and the deposit will become non-refundable. If, however, you fail to meet the standards required, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                    }
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                /*Conditional Acceptance (English) + AP Credits and Transfer Credits - UG*/
                else if((opp.StageName=='Conditionally Accepted' || (opp.StageName=='Conditionally Confirmed' && conf_paid)) && (opp.BBA_Student_Type__c=='First Year Advanced' || opp.BBA_Student_Type__c=='Transfer')){
                    note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                    if(opp.BBA_Student_Type__c=='First Year Advanced'){
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry onto the program, and to be awarded up to '+opp.BBA_Transfer_Credits__c+' US semester hours of academic credit for work successfully completed beyond US 12th grade standard, subject to receipt of official transcripts documenting evidence of success at required grade levels.';
                    }
                    else {
                        Paragraph2='The Admissions Committee has determined that your educational record allows you direct entry on to the program, and to transfer up to '+opp.BBA_Transfer_Credits__c+' academic credits for your previous work in higher education, subject to receipt of official transcripts documenting successful completion of these credits. ';
                    }
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    String str=opp.Admission_Endorsed_reasons__c;
                    block6=True;
                    if(!conf_paid){
                        conf_dpstpara='Once you provide satisfactory test results your conditional acceptance will become unconditional. As long as you provide the satisfactory test results and submit a deposit of '+fin+' not later than December 7th your place will be guaranteed and the deposit will become non-refundable. If, however, you fail to meet the standards required, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                    }
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                /* Waitlisted - UG */
                else if(opp.StageName=='Waitlisted'){
                    waitlstpick=new List<String>();
                    block7w=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=true;
                    if(opp.Waitlisted_Reasons__c!=null){
                        if(opp.Waitlisted_Reasons__c=='GPA'){
                            waitlstpick.add('Official High School transcript/ Diploma confirming your current/final cumulative grades');
                            //waitlstpick.add('Official University transcript showing your current/final GPA (if applicable)');
                        }
                        else if(opp.Waitlisted_Reasons__c=='English & GPA'){
                            waitlstpick.add('Official High School transcript/ Diploma confirming your current/final cumulative grades');
                            waitlstpick.add('Official Institution/School copy of TOEFL/IELTS score report');
                            //waitlstpick.add('Official University transcript showing your current/final GPA (if applicable)');
                        }
                    }
                }
                
                /* Rejected - UG */
                else if(opp.StageName=='Rejected'){
                    block7=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=true;
                    if(opp.Rejected_Reason__c!=null){
                        if(opp.Rejected_Reason__c.contains('Unsatisfactory TOEFL score')){
                            rej_para='Your application was unsuccessful because your official English language test score was insufficient. The Hult BBA is an intensive and interactive program that requires strong command of English. As a candidate who currently lacks sufficient English competency, we encourage you to work on your English language skills. You are welcome to reapply to Hult once you are able to demonstrate a level of English at or above IELTS 6.0 (TOEFL 80).<br/><br/>';
                        }
                    }
                }
                else{
                    if((opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed') && !conf_paid){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Confirmation Deposit is not paid!');
                        ApexPages.addMessage(myMsg);
                    }
                    else if(opp.BBA_Student_Type__c==null){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please check BBA Section - Student Type!');
                        ApexPages.addMessage(myMsg);
                    }
                    else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'You have Entered wrong Information!');
                        ApexPages.addMessage(myMsg);
                    }
                    firstblock=false;
                    sign_bool=false;
                    congratsblock=false;
                    lastblock=false;
                    ispdf=null;
                    isword=null;
                    isvf=false;
                }
            }
           
            //If Program is Non-BBA
            else if((opp.Program__r.Department__r.Name=='MBA' || opp.Program__r.Department__r.Name=='EMBA' || opp.Program__r.Department__r.Name=='MIB'
                    || opp.Program__r.Department__r.Name=='MFIN' || opp.Program__r.Department__r.Name=='MIM' || opp.Program__r.Department__r.Name=='MSE')
                    && (opp.StageName=='Accepted' || opp.StageName=='Conditionally Accepted' || opp.StageName=='Rejected'
                        || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Confirmed' || opp.StageName=='Soft Rejected Confirmed'
                        || opp.StageName=='Soft Rejected')){
               stage=opp.StageName;
               conf_dpstpara='';
                Paragraph='As you know, Hult International Business School is ranked among the best in the world by <i>The Economist</i> and <i>Bloomberg Businessweek</i>. The Hult '+opp.Program_formatted_for_emails_letters__c+' Program will help you realize your leadership potential by strengthening your managerial skills and sharpening your business acumen. It will also give you confidence as a decision-maker in a global business environment. The Hult student body is unique, talented, and culturally diverse which makes our classroom discussions engaging and enriching. Our graduates are eminently qualified to work and communicate across communities, countries, and cultures.';
                
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
                    if(!conf_paid){
                        conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, we ask you to submit the non-refundable deposit of '+fin+' online at www.hult.edu/apply-now/.<br/><br/>';
                    }
                }
                /*Accepted with Conditions - PG*/
                else if((opp.StageName=='Accepted' || (opp.StageName=='Confirmed' && conf_paid)) && cond_accept){
                    block9=True;
                    firstblock=true;
                    congratsblock=true;
                    lastblock=true;
                    if(!conf_paid){
                        conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                    }
                    conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible. '+conf_dpstpara+'<br/><br/>';
                    
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
                    block10=True;
                    if(!conf_paid){
                        conf_dpstpara='We also ask you to submit a '+fin+' non-refundable deposit online at www.hult.edu/en/apply-now/.';
                    }
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        /* EF Pathway Conditional Acceptance - PG */
                        if(str.contains('Pre-Master program w/B- grade') || str.contains('Pre-MBA program w/B- grade') || str.contains('UFY Diploma w/ C grade') || str.contains('Certificate of EFSET w/ a score of 58+') || str.contains('Cert of EFSET w/ a score of at least 54')){
                            conf_dpstpara='To confirm your place in the '+FallvsSpring+' '+opp.Start_Year__c+' class, please submit the original documents mentioned above as soon as possible and before the start of the program. <br/><br/>';
                            eflogo_bool=true;
                            space_logo='<br/><br/><br/><br/><br/>';
                            efpara=' following successful completion of your EF program.<br/><br/>';
                            if(opp.Primary_Campus__c=='London')
                                baclogo_bool=true;
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                        /* Conditionally Accepted - PG */
                        else{
                            note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                            if(!conf_paid){
                                //conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+' As long as you provide satisfactory test results within 120 days from the date of this letter, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                                conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide the original documents mentioned above by August 15, 2015, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                            }
                            if(opp.Admission_Endorsed_reasons__c!=null){
                                adminpick= str.split(';');
                                pickvals(adminpick);
                            }
                        }
                    }
                    else{
                        note='<br/><br/><br/>*Please note that your seat is guaranteed at your preferred campus only as long as you meet our payment deadlines.';
                        block10=True;
                        if(!conf_paid){
                            conf_dpstpara='To reserve a seat on the program and campus of your choice whilst you prepare for the required tests, you may submit a deposit of '+fin+'. As long as you provide the original documents mentioned above by August 15, 2015, your seat will be guaranteed* and the deposit will become non-refundable. If, however, you do not supply the test results or fail to meet the standards required on time, your seat will be automatically released and 50% of the deposit will be refunded to you.<br/><br/>';
                        }
                    }
                }
                /* Rejected - PG */
                else if(opp.StageName=='Rejected'){
                    block12=True;
                    firstblock=true;
                    congratsblock=false;
                    lastblock=false;
                    
                }
                
                else{
                    if((opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed') && !conf_paid){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Confirmation Deposit is not paid!');
                        ApexPages.addMessage(myMsg);
                    }
                    else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You have Entered wrong Information!');
                        ApexPages.addMessage(myMsg);
                    }
                    firstblock=false;
                    sign_bool=false;
                    congratsblock=false;
                    lastblock=false;
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
                sign_bool=false;
                congratsblock=false;
                lastblock=false;
                ispdf=null;
                isword=null;
                isvf=false;
            }
            
            List<document> documentList=[select id,name from document where Name='HCP Hult Logo' or Name='Henrik sign' or Name='London_footer' 
                                        or Name='Dubai_footer' or Name='Ian Dougal sign' or Name='HultWaterMark' or Name='Nawtej Sign' or Name='Shaun Sign'
                                        or Name='Larry Sign' or Name='Amanda Sign' or Name='Margaret Sign' or Name='EF Logo' or Name='BAC Logo'];
                                        
            for(integer i=0;i<documentList.size();i++){
                
                if(documentList[i].Name=='HCP Hult Logo'){
                    String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    logoURL= URL.getSalesforceBaseUrl().toExternalForm()+s;
                    if(logoURL.contains('visual')){
                        logoURL=logoURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='EF Logo'){
                    String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    eflogo= URL.getSalesforceBaseUrl().toExternalForm()+s;
                    if(eflogo.contains('visual')){
                        eflogo=eflogo.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='BAC Logo'){
                    String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    baclogo= URL.getSalesforceBaseUrl().toExternalForm()+s;
                    if(baclogo.contains('visual')){
                        baclogo=baclogo.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Henrik sign' && opp.Primary_Campus__c=='Boston' && opp.Program__r.Department__r.Name!='BBA'){
                    String s1='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s1;
                    sign_name='Henrik Totterman<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Ian Dougal sign' && opp.Program__r.Department__r.Name=='BBA'){
                    String s2='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s2;
                    sign_name='Dr. Ian Dougal<br/><br/>Global Dean, BBA Program<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Nawtej Sign' && opp.Primary_Campus__c=='London' && opp.Program__r.Department__r.Name!='BBA'){
                    String s6='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s6;
                    sign_name='Nawtej Dosanjh<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Shaun Sign' && opp.Primary_Campus__c=='Shanghai' && opp.Program__r.Department__r.Name!='BBA'){
                    String s7='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s7;
                    sign_name='Shaun Carver<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Larry Sign' && opp.Primary_Campus__c=='San Francisco' && opp.Program__r.Department__r.Name!='BBA'){
                    String s8='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s8;
                    sign_name='Larry Louie<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Amanda Sign' && opp.Primary_Campus__c=='Dubai' && opp.Program__r.Department__r.Name!='BBA'){
                    String s10='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s10;
                    sign_name='Amanda Nimon Peters<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Margaret Sign' && opp.Primary_Campus__c=='Miami' && opp.Program__r.Department__r.Name!='BBA'){
                    String s11='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s11;
                    sign_name='Margaret Andrews<br/>Vice Provost<br/>';
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
                    }
                }
                /*else if(documentList[i].Name=='London_footer'){
                    String s3='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    london_footerURL= URL.getSalesforceBaseUrl().toExternalForm()+s3;
                    if(london_footerURL.contains('visual')){
                        london_footerURL=london_footerURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='Dubai_footer'){
                    String s4='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    dubai_footerURL= URL.getSalesforceBaseUrl().toExternalForm()+s4;
                    if(dubai_footerURL.contains('visual')){
                        dubai_footerURL=dubai_footerURL.replace('visual','content');
                    }
                }*/
                else if(documentList[i].Name=='HultWaterMark'){
                    String s5='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    watermark= URL.getSalesforceBaseUrl().toExternalForm()+s5;
                    if(watermark.contains('visual')){
                        watermark=watermark.replace('visual','content');
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
                street='33 Commercial Road';
                addr='London E1 1LD';
                ph='+44 207 636 5667';
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
            else if(opp.Primary_Campus__c=='Miami'){
                street='3390 Mary Street';
                addr='Suite 250, Coconut Grove<br/>Miami, FL 33133';
                ph='+1 305 648 9746';
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
                sign_bool=false;
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