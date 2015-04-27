// Class for Final Submission and test class TestForApplicantPersonalStatement
public without sharing class ApplicantPersonalStatement{
        User user;
        public Opportunity opp{get;set;}
        public static boolean Essay_Tab_Complete_c{get;set;}
        public static string contactid;
        public static boolean finalsubmit{get;set;}
        public boolean tab2{get;set;}
        public boolean tab4{get;set;}
        public String proName{get;set;}
        public boolean isEMBA{get;set;}
        public Requirement__c Req{get;set;}
        public boolean MBA{get;set;}
        public boolean EMBA{get;set;}
        public boolean Master{get;set;}
        public boolean BIBA{get;set;}       
        public ApplicantPersonalStatement(){
        getopp();
        User userr = [SELECT contact.id from user WHERE id = :UserInfo.getUserId()];
        contactid=userr.contact.id;
        Opportunity oppt=new Opportunity();
        oppt=[select ID from Opportunity where Contact__c=:contactid ];
        List<Requirement__c> r=[select ID from Requirement__c where recordtype.name='Essay' and Name='Essay/Personal Statement' and Opportunity__c=:oppt.id];
        if(r.size()>0)
        {
            Req = [Select Supplied__c,Id,Personal_Statement__c from Requirement__c where ID = : r[0].ID];
        }
        else
        {
            RecordType RT = [Select ID from RecordType where Name = 'Essay' and Sobjecttype='Requirement__c'];
            Req = new Requirement__c();   
            Req.Name = 'Essay/Personal Statement';
            Req.RecordTypeId = RT.ID;    
            Req.Contact__c =  contactid;
            Req.Opportunity__c = oppt.ID;
        }
        // to lock visualforce page----                 
                 try{
                 ApplicantFinalController contrl= new ApplicantFinalController();
                 contrl.getopp();
                 proName=contrl.proName;
                 finalsubmit=ApplicantFinalController.finalsubmit;}
                 catch(exception e){}
                 
         Opportunity opp=[select Education_Tab_Complete__c,Program_and_Location_Tab_Complete__c,Primary_Program_Choice__c, id from Opportunity where contact__c=:userr.contact.id limit 1];    
         if(opp.Primary_Program_Choice__c == 'Master\'s Program')
                 {
                     MBA = false;
                     Master = True;
                     BIBA = false;
                     EMBA = false;
                 }
                 if(opp.Primary_Program_Choice__c == 'Master of Business Administration')
                 {
                     MBA = True;
                     Master = false;
                     BIBA = false;
                     EMBA = false;
                 }
                 if(opp.Primary_Program_Choice__c =='Executive MBA')
                 {
                     MBA = false;
                     Master = false;
                     BIBA = false;
                     EMBA = True;
                 }
                 if(opp.Primary_Program_Choice__c == 'Bachelor of International Business Administration')
                 {
                     MBA = false;
                     Master = false;
                     BIBA = True;
                     EMBA = false;
                 }
        }
        public PageReference  getopp(){
            User user1 = [SELECT contact.id from user WHERE id = :UserInfo.getUserId()];
            contactid=user1.contact.id;
            Opportunity opp=new Opportunity();
            try{
            opp=[select Primary_Program_Choice__c, Program_and_Location_Tab_Complete__c, Essay_Tab_Complete__c from Opportunity where Contact__c=:contactid ];
                  Essay_Tab_Complete_c=opp.Essay_Tab_Complete__c;                 
                  if(opp.Primary_Program_Choice__c=='Executive MBA'){
                      isEMBA = true;
                  }                
                 {tab2=true;} 
                 if(opp.Program_and_Location_Tab_Complete__c==true)
                 {tab4=true;} 
            }catch(Exception e) {
            finalsubmit=false;
                       // ApexPages.addMessages(e);
                    }
             return null;
        }
        
        
        public PageReference eassysaveandcontinue(){        	
        	
        if(Essay_Tab_Complete_c==false){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please check \'Please check the box to the right to affirm that you have read and understand the Personal Statment/Essay Requirement\''));
        }
       
        
        if(Req.Personal_Statement__c!=null){
            if(Req.Personal_Statement__c.length()>10000){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'You have exceeded the size limit of the Personal Statement. Please reduce your text and paste again.'));
            }
        }
        
        if(Test.isRunningTest()){
        }else if(apexpages.hasmessages()){
           return null;
        }
        
        User user1 = [SELECT contact.id from user WHERE id = :UserInfo.getUserId()];
        contactid=user1.contact.id;
        Opportunity opp1=new Opportunity();
        try{
        opp1=[select Essay_Tab_Complete__c from Opportunity where Contact__c=:contactid ];
        opp1.Essay_Tab_Complete__c=Essay_Tab_Complete_c;
        
        List<Requirement__c> rqc = [select Supplied__c,ID,Essay_Requirement_Affirmation__c from Requirement__c where recordtype.name='Essay' and Name='Essay /Personal Statement' and Opportunity__c=:opp1.id];
        if(rqc.size()>0)
        {
            List<Attachment> att = [Select ID, Body from attachment where parentid=:rqc[0].ID];
            if(att.size() == 0)
            {
                if(Req.Personal_Statement__c.Trim() == NULL || Req.Personal_Statement__c.Trim() == '')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Personal Statement'));
                    return NULL;
                }
            }
        }
        else
        {
            if(Req.Personal_Statement__c.Trim() == NULL || Req.Personal_Statement__c.Trim() == '')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Personal Statment'));
                    return NULL;
                }
        }
        Req.Supplied__c=true;
        upsert Req;
        //opp1.Final_Submission_Tab_Complete__c=true;
        update opp1;
       // finalsubmit=true;
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'Application has been submitted successfully '));
        }catch(exception e){
              
              }
        try
        {
        Requirement__c rc=[select Essay_Requirement_Affirmation__c from Requirement__c where recordtype.name='Essay' and Opportunity__c=:opp1.id limit 1];
        rc.Essay_Requirement_Affirmation__c=true;
        update rc;
        }
        catch(exception e){}            	
        return page.ApplicantReferenceDetail;
       }

  public PageReference eassysaveandcontinueandlogout() {
        if (eassysaveandcontinue() == null)
            return null; // eassysaveandcontinue() returning null means there were errors, so drop back to the page.
        return new PageReference('/secur/logout.jsp');
    }  
    //added by shs 7/25/2012 to skip the personal statement
    public PageReference skipstep() {
    	return page.ApplicantReferenceDetail;
    }

}