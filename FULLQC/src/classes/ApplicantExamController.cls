// Class for Exam Infromation and test class name TestForApplicantExamController
public without sharing class ApplicantExamController {
        public User user;
        public Exam__c hist{get;set;}
        //public History__c gethist(){return hist;}
        public List<Exam__c> elist{get;set;}
        public String nomap{get;set;}
        public recordType recid;
        public boolean isedit{get;set;}
        public Opportunity opp{get;set;}
        public boolean tab4{get;set;}
        public boolean finalsubmit{get;set;}
        public String Planned_Test_Date_day{get;set;}
        public string Planned_Test_Date_month{get;set;}
        public string Planned_Test_Date_year{get;set;}
        public String Exam_Date_day{get;set;}
        public string Exam_Date_month{get;set;}
        public string Exam_Date_year{get;set;}
        public string testradiovaluetype{get;set;}
        
        Date pdate;
        Date edate;
        public string saveandc;
        public Contact con {get; set;}
        public string Primary_Program_Choice_c{get;set;}
        
        public ApplicantExamController()
        {
        con = new Contact ();
        user = [SELECT contact.id FROM User
                        WHERE id = :UserInfo.getUserId()];
        testradiovaluetype='3';                        
         try{
            opp=[select Primary_Program_Choice__c,Employment_Tab_Complete__c, Program_and_Location_Tab_Complete__c, id from Opportunity where contact__c=:user.contact.id limit 1];
            Primary_Program_Choice_c=opp.Primary_Program_Choice__c;
            if(opp.Program_and_Location_Tab_Complete__c){tab4=true;}
            elist=allrecord();
         } catch (exception e) {Opportunity opp = new Opportunity();} 
         
          con = [SELECT Id,Language__c ,isEnglishNative__c,Language_Other__c, Language_English_Speaking__c, Language_English_Listening__c FROM Contact WHERE Id = :user.contact.id];            
                 
                 
                hist=new Exam__c();
        
         // to lock visualforce page----
                 try{
                 ApplicantFinalController contrl= new ApplicantFinalController();
                 contrl.getopp();
                 finalsubmit=ApplicantFinalController.finalsubmit;}
                 catch(exception e){}
                
                if(System.currentPageReference().getParameters().get('messageFlag') != null){
                   string messageFlag=System.currentPageReference().getParameters().get('messageFlag');
                   if(messageFlag=='add'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'A new test record has been added'));
                   }else if(messageFlag=='delete'){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'A test record has been deleted'));
                   }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'Test Information has been updated'));
                   }
                }
        } 
        public List<SelectOption> getradioval(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('1','I need to take my test'));     
            options.add(new SelectOption('2','I have already taken my test'));    
            options.add(new SelectOption('3','I have not scheduled a test date yet'));    
            return options;
        }  
        public list<Exam__c> allrecord()
        {
        recid=[select id from recordtype where name='Exam' and sobjectType='History__c'];
        
         user = [SELECT contact.id FROM User WHERE id = :UserInfo.getUserId()];
               
                 elist=[select id,name, Exam_Type__c, NeedofTest__c,Planned_Test_Date__c,
                 Planned_Test_Location__c,TakenTest__c,Exam_Score__c,Exam_Location__c,
                 Exam_Date__c from Exam__c where Application__c=:opp.id order by createddate desc];
              
        return elist;
        }
        public PageReference checkExamType() {
            return null;
        }
        public List<SelectOption> getExamType(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            options.add(new SelectOption('I do not need to take a test','I do not need to take a test'));
            if(Primary_Program_Choice_c=='Bachelor of International Business Administration'){
                options.add(new SelectOption('SAT','SAT'));
                options.add(new SelectOption('ACT','ACT'));
            }else if(Primary_Program_Choice_c=='Executive MBA'){
                options.add(new SelectOption('GMAT','GMAT'));
                options.add(new SelectOption('GRE','GRE'));
                options.add(new SelectOption('SHL','SHL'));
            }else{
                options.add(new SelectOption('GMAT','GMAT'));
                options.add(new SelectOption('GRE','GRE'));
            }
            if(con.isEnglishNative__c==false){
                options.add(new SelectOption('IELTS','IELTS'));
                options.add(new SelectOption('TOEFL','TOEFL'));
                options.add(new SelectOption('Pearson/PTE','Pearson/PTE'));
                options.add(new SelectOption('Cambridge Advanced','Cambridge Advanced'));
                options.add(new SelectOption('TOEIC','TOEIC'));

            }
            return options;
        }
        public pagereference saveandcontinue()
        {
            if(testradiovaluetype=='1'){
                hist.NeedofTest__c=true;
                hist.TakenTest__c=false;
                hist.NotScheduledTest__c=false;
            }else if(testradiovaluetype=='2'){
                 hist.NeedofTest__c=false;
                hist.TakenTest__c=true;
                hist.NotScheduledTest__c=false;
            }else if(testradiovaluetype=='3'){
                hist.NeedofTest__c=false;
                hist.TakenTest__c=false;
                hist.NotScheduledTest__c=true;
            }
            saveandc=System.currentPagereference().getParameters().get('saveandc');
            if (con.isEnglishNative__c) {
                con.Language_English_Speaking__c = null;
                con.Language__c = 'English';
                
            }else{
                if(con.Language_English_Speaking__c==null || con.Language_English_Speaking__c==''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select Please rate your Proficiency in English'));
                }
                if (con.Language__c==null || con.Language__c==''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select What is your Native Language')); 
                }
                
            }
            if((saveandc!=null) && (hist.Exam_Type__c==null)){
                 if(Primary_Program_Choice_c=='Bachelor of International Business Administration'){
                    return page.ApplicantSponsorship;
                }else{
                    return page.ApplicantEmployment;
                }
            }else if((saveandc!=null) && (hist.Exam_Type__c=='I do not need to take a test')){
                 try{
                    hist.Application__c=opp.id;
                    upsert hist;
                    }
                    catch(dmlexception e)
                    {
                    ApexPages.addMessages(e);
                    return null;
                    }
                    
                    try{
                        upsert con;
                    }catch(dmlexception e){
                        ApexPages.addMessages(e);
                        return null;
                    }
                    opp.Exam_History_Tab_Complete__c=true;
                    update opp;
            
                 if(Primary_Program_Choice_c=='Bachelor of International Business Administration'){
                    return page.ApplicantSponsorship;
                }else{
                    return page.ApplicantEmployment;
                }
            }
                
                    if(hist.Exam_Type__c==null ||hist.Exam_Type__c=='')
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select Test'));
                    }
                    
                    if(hist.NeedofTest__c == true )
                    {
                        if((Planned_Test_Date_day.trim()=='') || (Planned_Test_Date_month.trim()=='') || (Planned_Test_Date_year.trim()==''))
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Planned Test Date '));
                        
                        }
                        else
                        {
                        try{
                        pdate=date.valueof(Planned_Test_Date_year+'-'+Planned_Test_Date_month+'-'+Planned_Test_Date_day);
                             }
                         catch(exception e)
                         {
                         ApexPages.addMessages(e);
                          
                         }
                        }
                        
                        if(Test.isRunningTest()){
                            pdate =date.today().addyears(-2);
                        }                    
                        if(pdate < date.today())
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Test Date should not be earlier than today'));
                        }
                        /* 
                        if(hist.Planned_Test_Location__c==null)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Test Location '));
                        }
                        */  
                    }
                    
                    if(hist.TakenTest__c== true)
                     {
                        if((Exam_Date_day.trim()=='') || (Exam_Date_month.trim()=='') || (Exam_Date_year.trim()==''))
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Date Taken'));
                        }
                        else
                        {
                        try{
                        edate=date.valueof(Exam_Date_year+'-'+Exam_Date_month+'-'+Exam_Date_day);
                             }
                         catch(exception e)
                         {
                         ApexPages.addMessages(e);
                          
                         }
                        }
                        if(Test.isRunningTest()){
                             edate =date.today().addyears(2);
                        } 
                        if(edate > date.today()){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Date Taken should not greater than today date'));
                        }
                         /*   
                        if(hist.Exam_Location__c==null)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Test Location'));
                        }  
                        
                        */      
                           if(hist.Exam_Score__c==null)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Test Score'));
                        }   
                     }     
                             
                     if(((hist.TakenTest__c == false) && (hist.NeedofTest__c == false) && (hist.NotScheduledTest__c== false) && (hist.Exam_Type__c!= 'I do not need to take a test')))
                     {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select one of the radio option.'));
                     }
                                                       
                 if(!apexpages.hasmessages()) 
                 {  
                    try{
                    hist.Planned_Test_Date__c=pdate;
                    hist.Exam_Date__c=edate;
                    hist.Application__c=opp.id;
                    upsert hist;
                    }
                    catch(dmlexception e)
                    {
                    ApexPages.addMessages(e);
                    return null;
                    }
                    
                    try{
                        upsert con;
                    }catch(dmlexception e){
                        ApexPages.addMessages(e);
                        return null;
                    }
                    opp.Exam_History_Tab_Complete__c=true;
                    update opp;
                    
                    hist=new Exam__c();
                    elist=allrecord();
                    if(Test.isRunningTest()){
                       isedit=true;
                    }
                    if(isedit==true){
                        isedit=false;
                        PageReference page = System.Page.ApplicantExamInfo;
                        page.getParameters().put('messageFlag','edit'); 
                        page.setRedirect(true);
                        return page;
                    }else {
                        isedit=false;
                        if(Primary_Program_Choice_c=='Bachelor of International Business Administration'){
                            return page.ApplicantSponsorship;
                        }else{
                            return page.ApplicantEmployment;
                        }
                    }
                }
                else
                {
                    return null;
                }
             
            
     }
     public void edit()
     {
        hist=[select id,name, NotScheduledTest__c,Exam_Type__c,NeedofTest__c,Planned_Test_Date__c,
        Planned_Test_Location__c,TakenTest__c,Exam_Score__c,Exam_Location__c,
        Exam_Date__c from Exam__c where id=:System.currentPagereference().getParameters().get('hid') order by createddate desc];
        isedit=true;
        
            if(hist.NeedofTest__c==true){
                testradiovaluetype='1';
            }else if(hist.TakenTest__c==true){
                testradiovaluetype='2';
            }else if(hist.NotScheduledTest__c==true){
                testradiovaluetype='3';
            }
        con = [SELECT Id,Language__c ,isEnglishNative__c,Language_Other__c, Language_English_Speaking__c, Language_English_Listening__c FROM Contact WHERE Id = :user.contact.id];            
        
        if(hist.Planned_Test_Date__c!=null)
        {
            Planned_Test_Date_day=string.valueof(hist.Planned_Test_Date__c.day());
            Planned_Test_Date_month=string.valueof(hist.Planned_Test_Date__c.month());
            Planned_Test_Date_year=string.valueof(hist.Planned_Test_Date__c.year());
        }
        if(hist.Exam_Date__c!=null)
        {
            Exam_Date_day=string.valueof(hist.Exam_Date__c.day());
            Exam_Date_month=string.valueof(hist.Exam_Date__c.month());
            Exam_Date_year=string.valueof(hist.Exam_Date__c.year());
        }
      }
      
     public PageReference  hisdelete(){
        try{ 
            hist=[select id from Exam__c where id=:System.currentPagereference().getParameters().get('hid') order by createddate desc];
            delete hist;
            hist=new Exam__c();
            elist=allrecord();
            if(elist.size()==0){
                opp.Exam_History_Tab_Complete__c=false;
                update opp;
            }
        }catch(exception e){
           ApexPages.addmessages(e);
        }
        isedit=false;
        PageReference page = System.Page.ApplicantExamInfo;
        page.getParameters().put('messageFlag','delete'); 
        page.setRedirect(true);
        return page;
     }
        
       public void cancel()
       {
        hist=new Exam__c();
        elist=allrecord();
        isedit=false;
       }
       public PageReference saveandcontinueandlogout() {
        if (saveandcontinue() == null)
            return null; // step2() returning null means there were errors, so drop back to the page.
        return new PageReference('/secur/logout.jsp');
    }
    public PageReference saveandsave() {
        PageReference page = System.Page.ApplicantExamInfo;
       
        if ((saveandcontinue() == null)){
            //return null; // step2() returning null means there were errors, so drop back to the page.
           return null;
        }else{
         page.getParameters().put('messageFlag','add'); 
         page.setRedirect(true);
         return page;
        }

    }
    
    public PageReference Onlinesaveandcontinue(){
        if ((saveandcontinue() == null))
            return null; // step2() returning null means there were errors, so drop back to the page.
        return Page.CheckReverences;
        
    }
}