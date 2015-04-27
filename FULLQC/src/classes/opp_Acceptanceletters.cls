/*
Author          : Premanath Reddy
Created Date    : 25/04/2013
Purpose         : This class is for Acceptance Letter Generations Project Based on Stage and Program Name.
Test class      : opp_Acceptanceletters_Test
Modified By     : Anil.B 15/11/2013,9/10/2014 and 27/11/2013----JIRA No:::SFSUP-672
                     Changed program parsed from BIBA to BBA by using custom_lables class. 
*/
public class opp_Acceptanceletters {
    String var;
    public Opportunity opp{get;set;}
    public String fin{get;set;}
   // public Contact contact{get;set;}
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
    public boolean block6{get;set;}
    public boolean block7{get;set;}
    public boolean block8{get;set;}
    public boolean block9{get;set;}
    public boolean block10{get;set;}
    public boolean block11{get;set;}
    public boolean block12{get;set;}
    public boolean block13{get;set;}
    public boolean block14{get;set;}
    public boolean block15{get;set;}
    public boolean block16{get;set;}
    public boolean block17{get;set;}
    public boolean block18{get;set;}
    public boolean block19{get;set;}
    public boolean block20{get;set;}
    public String logoURL{get;set;}
    public String signURL{get;set;}
    public boolean buttons{get;set;}
    public boolean footer_bool{get;set;}
    public String conf_deposit{get;set;}
    public String london_footerURL{get;set;}
    public String dubai_footerURL{get;set;}
    public String footerURL{get;set;}
    public boolean cond_accept{get;set;}
    public String prog_name{get;set;}
    public String curr_date{get;set;}
    public opp_Acceptanceletters() {
        try{
            buttons=true;
            ispdf=null;
            isword=null;
            isvf=false;
            cond_accept=false;
            
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
                ,Contact__r.Mailingpostalcode,Contact__r.Mailingstreet,Contact__r.FirstName,StageName,Primary_Campus__c,Start_Term__c
                ,Admission_Endorsed_reasons__c,Conditionally_Accepted_Reasons__c,BBA_Student_Type__c,Admission_Endorsed__c,Conditionally_Accepted__c
                ,Program__r.Department__r.Name,Program__r.Name,BBA_Transfer_Credits__c,Start_Year__c,Program_Parsed__c,Program_formatted_for_emails_letters__c
                ,(Select Id,Opportunity__c,OP_Confirmation_Deposit__c,CurrencyIsoCode From Opportunity_Finances__r) 
                from Opportunity where id=:var];
            //If Program is BBA
            if(opp.Program__r.Department__r.Name==custom_lables.Bachelor_Pgm_abvtn
                && (opp.StageName=='Admissions Endorsed' || opp.StageName=='Admissions Endorsed Confirmed'
                    || opp.StageName=='Accepted'
                    || opp.StageName=='Confirmed'
                    || opp.StageName=='Conditionally Confirmed'
                    || opp.StageName=='Conditionally Accepted'
                    || opp.StageName=='Soft Rejected Confirmed')){
                bbacredits=opp.BBA_Transfer_Credits__c;//System.Debug(opp.StageName+'======================='+opp.BBA_Student_Type__c);
                if(opp.StageName=='Accepted'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null || opp.Conditionally_Accepted__c==true){
                        cond_accept=true;
                    }
                }
                if(opp.StageName=='Confirmed'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null || opp.Conditionally_Accepted__c==true){
                        cond_accept=true;
                    }
                }
                if(opp.StageName=='Admissions Endorsed'||opp.StageName=='Conditionally Accepted'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Admission Endorsement '+opp.Start_Year__c;
                    block1=True;
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                else if(opp.StageName=='Admissions Endorsed Confirmed'||opp.StageName=='Conditionally Confirmed'||opp.StageName=='Soft Rejected Confirmed'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Admission Endorsement '+opp.Start_Year__c;
                    block2=True;
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                else if(opp.StageName=='Accepted' && cond_accept==false && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block3=true;
                }
                else if(opp.StageName=='Confirmed'&& cond_accept==false && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block4=True;
                }
                else if(opp.StageName=='Accepted' && cond_accept==true && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block5=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Confirmed' && cond_accept==true && opp.BBA_Student_Type__c!='First Year Advanced' && opp.BBA_Student_Type__c!='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block6=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Accepted' && cond_accept==false && opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block7=True;
                }
                else if(opp.StageName=='Confirmed'&& cond_accept==false && opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block8=True;
                }
                else if(opp.StageName=='Accepted' && cond_accept==false && opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block9=True;
                }
                else if(opp.StageName=='Confirmed'&& cond_accept==false && opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Program Full Acceptance '+opp.Start_Year__c;
                    block10=True;
                }
                else if(opp.StageName=='Accepted' && cond_accept==True &&opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block11=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Confirmed' && cond_accept==True &&opp.BBA_Student_Type__c=='First Year Advanced'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block12=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Accepted'&& cond_accept==true &&opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block13=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Confirmed' && cond_accept==True &&opp.BBA_Student_Type__c=='Transfer'){
                    firstblock=true;
                    lastblock=true;
                    prog_name='Bachelor Acceptance '+opp.Start_Year__c;
                    block14=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'You have Entered wrong Information!');
                    ApexPages.addMessage(myMsg);
                }
            }
           
            //If Program is Not BBA
            else if((opp.Program__r.Department__r.Name=='MBA' || opp.Program__r.Department__r.Name=='EMBA' || opp.Program__r.Department__r.Name=='Masters'
                    || opp.Program__r.Department__r.Name=='MFIN' || opp.Program__r.Department__r.Name=='MIM' || opp.Program__r.Department__r.Name=='MSE'
                    || opp.Program__r.Department__r.Name=='MIB')
                    && (opp.StageName=='Accepted' || opp.StageName=='Admissions Endorsed'
                       || opp.StageName=='Confirmed' || opp.StageName=='Admissions Endorsed Confirmed'
                       ||opp.StageName=='Conditionally Confirmed'||opp.StageName=='Conditionally Accepted'||opp.StageName=='Soft Rejected Confirmed')){
                stage=opp.StageName;
                if(opp.StageName=='Accepted'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null || opp.Conditionally_Accepted__c==true){
                        cond_accept=true;
                    }
                }
                if(opp.StageName=='Confirmed'){
                    if(opp.Conditionally_Accepted_Reasons__c!=null || opp.Conditionally_Accepted__c==true){
                        cond_accept=true;
                    }
                }
                if(opp.StageName=='Admissions Endorsed Confirmed'||opp.StageName=='Conditionally Confirmed'||opp.StageName=='Soft Rejected Confirmed'){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Admission Endorsement '+opp.Start_Year__c;
                    block15=True;
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                else if(opp.StageName=='Confirmed' && cond_accept==false){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Full Acceptance '+opp.Start_Year__c;
                    block16=True;
                }
                else if(opp.StageName=='Confirmed' && cond_accept==true){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Acceptance '+opp.Start_Year__c;
                    block17=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else if(opp.StageName=='Admissions Endorsed'||opp.StageName=='Conditionally Accepted'){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Admission Endorsement '+opp.Start_Year__c;
                    block18=True;
                    if(opp.Admission_Endorsed_reasons__c!=null){
                        String str=opp.Admission_Endorsed_reasons__c;
                        adminpick= str.split(';');
                        pickvals(adminpick);
                    }
                }
                else if(opp.StageName=='Accepted' && cond_accept==false){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Full Acceptance '+opp.Start_Year__c;
                    block19=True;
                }
                else if(opp.StageName=='Accepted' && cond_accept==true){
                    firstblock=true;
                    lastblock=true;
                    prog_name=opp.Program__r.Department__r.Name+' Acceptance '+opp.Start_Year__c;
                    block20=True;
                    if(opp.Conditionally_Accepted_Reasons__c!=null){
                        String str=opp.Conditionally_Accepted_Reasons__c;
                        condpick= str.split(';');
                        pickvals(condpick);
                    }
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'You have Entered wrong Information!');
                    ApexPages.addMessage(myMsg);
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
                lastblock=false;
                ispdf=null;
                isword=null;
                isvf=false;
            }
            
            List<document> documentList=[select id,name from document where Name='Hult Logo for Web' or Name='testsign' or Name='London_footer' or Name='Dubai_footer'];
            for(integer i=0;i<documentList.size();i++){ 
                if(documentList[i].Name=='Hult Logo for Web'){
                    String s='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    logoURL= URL.getSalesforceBaseUrl().toExternalForm()+s;
                    if(logoURL.contains('visual')){
                        logoURL=logoURL.replace('visual','content');
                    }
                }
                else if(documentList[i].Name=='testsign'){
                    String s1='/servlet/servlet.ImageServer?id='+documentList[i].id+'&oid='+UserInfo.getOrganizationId();
                    signURL= URL.getSalesforceBaseUrl().toExternalForm()+s1;
                    if(signURL.contains('visual')){
                        signURL=signURL.replace('visual','content');
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
            else if(opp.Primary_Campus__c=='London'){
                street='46-47 Russell Square - Bloomsbury';
                addr='London WC 1B 4JP, UK';
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
            for(Opportunity_Finance__c f:opp.Opportunity_Finances__r){
                integer num=integer.ValueOf(f.OP_Confirmation_Deposit__c);
                fin=f.CurrencyIsoCode+' '+String.ValueOf(num);
                //System.Debug('***************'+fin);
            }  
        }
        Catch(Exception e){
            buttons=false;
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
    //This method is for Update/hard code picklist values for Conditionally_Accepted_Reasons__c and Admission_Endorsed_reasons__c
    public void pickvals(String[] pick){
        for(integer i=0;i<pick.size();i++){
            // for Admission_Endorsed_reasons__c field
            if(pick[i]=='Officl Inst/School cop TOEFL/IELTS score'){
                adminpick[i]='Official Institution/ School copy of TOEFL/ IELTS score report';
            }
            if(pick[i]=='Officl Inst/School copy of GMAT/GRE'){
                adminpick[i]='Official Institution/ School copy of GMAT/GRE';
            }
            if(pick[i]=='Cert IEMA 3 mo. Intensive English Prog'){
                adminpick[i]='Certificate of successful completion of 3-Month IEMA program';
            }
            if(pick[i]=='Cert IEMA 6 mo. Intensive English Prog'){
                adminpick[i]='Certificate of successful completion of 6-Month IEMA program';
            }
            if(pick[i]=='Cert of the EF Pre-Master’s Prog'){
                adminpick[i]='Certificate of completion of EF Pre Master\'s program';
            }
            if(pick[i]=='Cert of UPiBT with 60-63'){
                adminpick[i]='Certificate of completion of UPiBT with a score of 60 – 63';
            }
            if(pick[i]=='Official copy of SHL score report'){
                adminpick[i]='Official copy of SHL score report';
            }
            if(pick[i]=='Official copy of BEST score report'){
                adminpick[i]='Official copy of BEST score report';
            }
            if(pick[i]=='Transcripts with GPA of at least 2.5'){
                adminpick[i]='Transcripts with GPA of at least 2.5';
            }
            if(pick[i]=='Offcl University Foundation Year Diploma'){
                adminpick[i]='Official University Foundation Year Diploma';
            }
            if(pick[i]=='Officl Diploma in Business Management'){
                adminpick[i]='Official Diploma in Business Management';
            }
            if(pick[i]=='Additional academic/prof ref letter'){
                adminpick[i]='Additional academic/ professional reference letter';
            }
            
            // for Conditionally_Accepted_Reasons__c field
            if(pick[i]=='Official HS trans/ diploma'){
                condpick[i]='Official High School transcript/ Diploma';
            }
            if(pick[i]=='Official University trans/diploma'){
                condpick[i]='Official University transcript/ Diploma';
            }
            if(pick[i]=='Ofcl English translat of transcr/degree'){
                condpick[i]='Official English translation of transcripts/degree';
            }
            if(pick[i]=='Official Inst/School TOEFL/ IELTS score'){
                condpick[i]='Official Institution/School copy of TOEFL/ IELTS score report';
            }
            if(pick[i]=='Official Inst/School GMAT/ GRE score'){
                condpick[i]='Official Institution/ School copy of GMAT/GRE score report';
            }
            if(pick[i]=='Cert of successful compl 3 mo IEMA prog'){
                condpick[i]='Certificate of successful completion of 3-Month IEMA program';
            }
            if(pick[i]=='Cert of successful compl 6 mo IEMA prog'){
                condpick[i]='Certificate of successful completion of 6-Month IEMA program';
            }
            if(pick[i]=='Additional prof/ academic reference'){
                condpick[i]='Additional academic/professional reference letter';
            }
            
        }
    }
}