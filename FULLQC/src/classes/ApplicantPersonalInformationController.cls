public class ApplicantPersonalInformationController {
    
    public boolean finalsubmit{get;set;}
    public Contact con {get; set;}
    public User currentUser {get; set;}
    public string birthday{get;set;}
    public string birthmonth{get;set;}
    public string birthyear{get;set;}
    public string testStr{get;set;}
    private Date birthdate;
    private Opportunity opp {get; set;}
    private Map <Id, Country__c> countries = new Map <Id, Country__c> ([Select Id, Name FROM Country__c]);
    public Attachment attach{get;set;} 
    public boolean chk{get;set;} 
    public boolean chkMailing{get;set;}
    public boolean mailingPurpose{get;set;} 
    public boolean chkAttach{get;set;} 
    public Opportunity opp1{get;set;}
    public ApplicantPersonalInformationController () {
    System.debug('0000000000');
        mailingPurpose = false;
        countries.put (null, new Country__c ()); // to avoid null pointer exception when page loads with no country selected
        con = new Contact ();
        currentUser = new User ();
        opp = new Opportunity ();
        opp1= new Opportunity ();
    System.debug('11111111111');    
        try {
            currentUser = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            con = [SELECT Id
                    , Name
                    , FirstName
                    , LastName
                    , Salutation
                    , Email
                    , OtherStreet
                    , OtherCity
                    , OtherState
                    , OtherPostalCode
                    , OtherCountry
                    , MailingStreet
                    , MailingCity
                    , MailingState
                    , MailingPostalCode
                    , MailingCountry
                    , Mailing_Country__c
                    , Accountid
                    , Title
                    , Phone
                    , Suffix__c
                    , Gender__c
                    , Country_Of_Citizenship__c
                    , Country_Of_Origin__c
                    , Country_Of_Residence__c
                    , Birthdate
                    , Language__c
                    , isEnglishNative__c
                    , Language_English_Speaking__c
                    , Language_English_Listening__c
                    , Language_English_Writing__c
                    , Language_English_Reading__c
                    , Language_Other__c
                    , Agent_Email__c
                    , Agent_Name__c
                    , Applicant_Email__c
                    , LeadSource
                    , Lead_Source_User_Supplied__c                    
                    , Home_Phone_Country_Code__c
                    , Home_Phone_Area_Code__c
                    , Home_Phone_Main_Number__c
                    , Mobile_Phone_Country_Code__c
                    , Mobile_Phone_Area_Code__c
                    , Mobile_Phone_Main_Number__c 
                    , MobilePhone
                    , I_would_like_to_use_a_different_Address__c 
                    , Other_Country__c
                FROM Contact WHERE Id = :currentUser.ContactId];
                countryChangeLoad();
                System.debug('22222222222');
                mailingPurpose = con.I_would_like_to_use_a_different_Address__c;
                try
                {
                    opp1=[select Program_and_Location_Tab_Complete__c,Primary_Program_Choice__c, Attachments_Tab_Complete__c, id from Opportunity where contact__c=:con.id limit 1];
                    Requirement__c hist; 
                    hist=[select Supplied__c, id,name,contact__c,Opportunity__c,recordtypeid from Requirement__c where name='Current Resume' and Opportunity__c=:opp1.id limit 1];
                    
                    list<Attachment> lstAttach = [Select Id, Name,Description,Body from Attachment where parentID = :hist.ID];
                    if(lstAttach.size()>0)
                    {
                        attach = [Select Id, Name,Description,Body,parentId  from Attachment where ID = :lstAttach[0].ID];
                        attach.body = null;
                        chk = true;
                    }
                    else
                    {
                        attach = new Attachment();
                        chk=false;
                    }
                }
                catch(Exception e)
                {
                System.debug('33333333333333');
                }
                //prepopulate fields when page loads
                if (con.Birthdate != null) {
                    birthday = string.valueOF(con.Birthdate.day());
                    birthmonth = string.valueOF(con.Birthdate.month());
                    birthyear = string.valueOF(con.Birthdate.year());
                }
                 System.debug('44444444444');
                 if(opp1.Primary_Program_Choice__c == 'Bachelor of International Business Administration')
                 {
                     chkAttach = false;
                 } 
                 else
                 {
                     chkAttach = true;
                 }
                
        } catch (Exception e) {
           // ApexPages.addmessages (e);
           System.debug('5555555555');
        }
        
        
        List <Opportunity> oppList = new List <Opportunity> ();
        oppList = [SELECT Id, Name FROM Opportunity WHERE Contact__c =:con.Id];
        
        if (oppList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Warning, 'Please complete Program/Location Section'));
         }
        System.debug('666666666666');
        
        // to lock visualforce page----
         try {
            ApplicantFinalController contrl= new ApplicantFinalController();
            contrl.getopp();
            finalsubmit=ApplicantFinalController.finalsubmit;
         }
         catch (Exception e){
            ApexPages.addMessages(e);
         }
        checkboxChanged();
        System.debug('777777777777777');
    }
    public List<SelectOption> getyesno() 
    {
    System.debug('123456Gender');        
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Male','Male'));     
            options.add(new SelectOption('Female','Female'));     
            System.debug('123456GenderLast'); 
            return options;
     
    }    
    public void countryChange() 
        {
            List<SelectOption> options = new List<SelectOption>();
            List<Country__c> cou=[select id,name,Calling_Code__c from country__c where Calling_Code__c!=null order by name asc];
            
            for(integer i=0;i<cou.size();i++)   
            {    
                if(cou[i].id == con.Country_Of_Residence__c) 
                {
                    con.Home_Phone_Country_Code__c = string.valueof(cou[i].Calling_Code__c);  
                    con.Mobile_Phone_Country_Code__c = string.valueof(cou[i].Calling_Code__c);
                }  
            } 
            con.Other_country__c = con.Country_Of_Residence__c;  
        }
        public void countryChangeLoad() 
        {
            List<SelectOption> options = new List<SelectOption>();
            List<Country__c> cou=[select id,name,Calling_Code__c from country__c where Calling_Code__c!=null order by name asc];
            for(integer i=0;i<cou.size();i++)   
            {    
                if(cou[i].id == con.Country_Of_Residence__c) 
                {
                  if(con.Home_Phone_Country_Code__c == null)
                   
                    con.Home_Phone_Country_Code__c = string.valueof(cou[i].Calling_Code__c);  
                   if(con.Mobile_Phone_Country_Code__c == null)
                    con.Mobile_Phone_Country_Code__c = string.valueof(cou[i].Calling_Code__c);
                }  
            } 
            if(con.Other_country__c == null)
            con.Other_country__c = con.Country_Of_Residence__c;
            System.debug('123456ContryChange');     
        }
    
    public void checkboxChanged()
    {
        if(mailingPurpose)
        {
            chkMailing = True;
        }
        else
        {
            chkMailing = false;
        }
    }
        // Code for country list 
     public List<SelectOption> getclist() {
     integer i=0;
            List<SelectOption> options = new List<SelectOption>();
            List<Country__c> cou=[select id,name from country__c where name != '-Did Not Respond-' order by name asc]; // remove -Did Not Respond- country from picklist
            options.add(new SelectOption('','-Select-'));            
            for(i=0;i<cou.size();i++){
            options.add(new SelectOption(cou[i].id,cou[i].name));            
            }
    
            System.debug('123456Clist');  
            return options;
        } 
        
        //list of states for country of residence
        
        public  List<SelectOption> getStatesList() {
            return renderStatesList('1');
        }
        
        private  List<SelectOption> renderStatesList (string country) { 
        
      
        System.debug('123456Slist');  
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-Select-')); 
        
        if(country=='1'){
            for (States__c s: [SELECT Name, Country__c, StateShortName__c FROM States__c WHERE Country__c = :countries.get(con.Other_Country__c).Name ORDER BY Name]) {
                options.add (new SelectOption (s.Name, s.Name));
            }
        }else{
            for (States__c s: [SELECT Name, Country__c, StateShortName__c FROM States__c WHERE Country__c = :countries.get(con.Mailing_Country__c).Name ORDER BY Name]) {
                options.add (new SelectOption (s.Name, s.Name));
            }
        }
        System.debug('123456SlistLast');
        return options;
       }
       
       public  List<SelectOption> getStatesList2() {
             return renderStatesList('2');
       }     
     
    
    // Code for country list 
        public List<SelectOption> getcountryCode() {
            System.debug('123456ConCode');
            integer i=0;
            List<SelectOption> options = new List<SelectOption>();
            List<Country__c> cou=[select id,name,Calling_Code__c from country__c where Calling_Code__c!=null order by name asc];
            options.add(new SelectOption('','-Select-'));            
            for(i=0;i<cou.size();i++){
            options.add(new SelectOption(string.valueof(cou[i].Calling_Code__c),cou[i].name+'('+cou[i].Calling_Code__c+')'));            
            }
    
            System.debug('123456ConCodeLast');
            return options;
        }
        
        
         public PageReference SaveAndContinue() {
            
           
            
            if (con.firstname==null || con.firstname=='')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter First Name'));
            if ((con.lastname.trim()=='') || (con.lastname==null))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Last Name'));
            if (con.Gender__c==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select Gender'));
            if (con.Country_Of_Origin__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Nationality'));
            if (con.Country_Of_Residence__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Country of Residence'));
           
            if((birthday.trim()=='') ||  (birthmonth.trim()=='') || (birthyear.trim()=='')) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter Birthdate (mm/dd/yyyy)'));
            } else {
                try {
                    birthdate =  date.valueof(birthyear+'-'+birthmonth+'-'+birthday);
                } catch(exception e) {
                    apexpages.addmessages(e);
                }
            }//end if for birthdate
            
            if ((birthdate!=null) && (birthdate>date.today()))
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Birthdate should be less than today date'));
//            if (con.Lead_Source_User_Supplied__c==null)
  //              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select "Where did you hear about Us?"'));
            if (con.otherstreet==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter current Street'));
                if (con.othercity==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter current City'));
                if (con.otherstate==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter current State/Province'));
                if (con.otherpostalcode==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter current Zip/Postal Code'));
                if (con.other_Country__c==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select current Country'));
            
            if(mailingPurpose)
            {
                if (con.mailingstreet==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter mailing Street'));
                if (con.mailingcity==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter mailing City'));
                if (con.mailingstate==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter mailing State/Province'));
                if (con.mailingpostalcode==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter mailing Zip/Postal Code'));
                if (con.Mailing_Country__c==null)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select mailing Country'));
            }
            if (con.Home_Phone_Country_Code__c==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter phone country code'));
            if ((con.Phone==null) || (con.Phone.trim()=='')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please enter main phone number'));}
             
    
            if (apexpages.hasmessages())
                return null; 
            
          
            
            try { 
                opp = [ SELECT Primary_Program_Choice__c,Primary_Campus__c, stageName
                                ,  Personal_Information_Complete__c
                                , Contact__c, Primary_Interest__c 
                                ,City__c
                        FROM Opportunity
                        WHERE Contact__c=:con.id ];
                if(countries.get(con.Country_Of_Origin__c).name=='China' && opp.Primary_Program_Choice__c=='Executive MBA' && opp.Primary_Campus__c=='Shanghai') {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Programs offered on Hult\'s Shanghai campus are not available for China nationals. We encourage Chinese nationals to apply to Hult\'s other campuses in Boston, San Francisco,London, and Dubai.'));
                    return null;
                }       
                
                con.Applicant_Email__c=con.email;
                con.Birthdate= birthdate;
                con.MailingCountry = countries.get(con.Mailing_Country__c).Name;
                con.OtherCountry = countries.get(con.Other_Country__c).Name;
                con.I_would_like_to_use_a_different_Address__c = mailingPurpose;
                if(!mailingPurpose)
                {
                    con.mailingstreet = con.Otherstreet;
                    con.mailingcity = con.Othercity;
                    con.mailingpostalcode = con.Otherpostalcode;
                    con.MailingCountry = countries.get(con.Other_Country__c).Name;
                    con.Mailing_Country__c = con.Other_Country__c;
                    con.MailingState = con.OtherState;
                }
                update con;
                
               
                opp.contact__c = con.id;
                opp.Personal_Information_Complete__c = true;
                opp.City__c=con.Othercity;
                update opp;
                
                Requirement__c hist1; 
                try{
                hist1=[select Supplied__c, id,name,contact__c,Opportunity__c,recordtypeid from Requirement__c where name='Current Resume' and Opportunity__c=:opp1.id];
                } catch (exception e){hist1=new Requirement__c(); }
                
                try{
                    hist1.name='Current Resume';
                   // hist1.Supplied__c=true;/*Commented by Anil.B becoz its populating value supplied__c to true when there is no attachment*/
                    hist1.contact__c=con.id;
                    hist1.Opportunity__c=opp1.id;
                    hist1.Description__c = con.id;
                    upsert hist1;
                }catch(exception e){
                    ApexPages.addMessages(e);
                }    
                try{
                if(Attach.Body != null){
                
                    if(Attach.parentId == null)
                    Attach.parentId = hist1.id;
                    upsert Attach;
                    
                 }
                }
                catch(exception e){
                    ApexPages.addMessages(e);
                }               
                return Page.ApplicantEducation;
                
            } catch (Exception e) {
                ApexPages.addMessages(e); 
                return null;
            }

        }
        
        public PageReference SaveAndLogout() {
            if (SaveAndContinue() == null)
                return null; // step2() returning null means there were errors, so drop back to the page.
            return new PageReference('/secur/logout.jsp');
        }
        public PageReference StateChange() {
           return null;
        }
        
        
        public static testMethod void testApplicantPersonalInformation () {
            
            Country__c country = new Country__c (Name='United States');
            insert country;
            
            States__c states = new States__c (Name='Test', StateShortName__c = 'TEST', Country__c = 'United States');
            insert states;
            
            User u = [select Id, Contact.Birthdate, Contact.Language__c, contact.Country_Of_Residence__c,
                                  contact.Country_Of_Origin__c,
                                  contact.mailingstreet,
                                  contact.mailingcity,
                                  contact.mailingstate,
                                  contact.mailingpostalcode,
                                  contact.mailingcountry,
                                  contact.mailing_country__c,
                                  contact.isEnglishNative__c
                                  from User where isActive=true AND ContactId != null LIMIT 1];
            // populate required field
            
            //u.contact.birthdate = System.Today();
            u.contact.language__c = 'English';
            u.contact.Gender__c = 'Male';
            u.contact.Country_Of_Origin__c = country.Id;
            u.contact.Country_Of_Residence__c = country.Id;
            u.contact.MailingStreet = '123';
            u.contact.MailingCity = '123';
            u.contact.MailingState = 'Minnesota';
            u.contact.MailingPostalCode = '55555';
            u.contact.MailingCountry = 'United States';
            u.contact.Mailing_Country__c = country.id;
            u.contact.OtherStreet = '123';
            u.contact.OtherCity = '123';
            u.contact.OtherState = 'Minnesota';
            u.contact.OtherPostalCode = '55555';
            u.contact.OtherCountry = 'United States';
            u.contact.Other_Country__c = country.id;
            u.contact.Language__c = 'English';
            u.contact.isEnglishNative__c = true;
            u.contact.phone = '98996595';
            
            update u.contact;
            
            System.runAs(u){
                ApplicantPersonalInformationController test = new ApplicantPersonalInformationController ();
                test.birthday = '02';
                test.mailingPurpose = false;
                test.birthmonth = '11';
                test.birthyear = '1988';
                test.getclist();
                test.getcountrycode();
                test.getStatesList();
                test.saveAndContinue();
                test.SaveAndLogout();
                test.getyesno();
                test.countryChange();
                test.mailingPurpose = true;
                test.checkboxChanged();
                test.renderStatesList('1'); 
                test.getStatesList2();
                ApplicantPersonalInformationController test2 = new ApplicantPersonalInformationController ();
            }
        }
        public static testMethod void testApplicantPersonalInformationNull() {
            
            Country__c country = new Country__c (Name='United States');
            insert country;
            
            States__c states = new States__c (Name='Test', StateShortName__c = 'TEST', Country__c = 'United States');
            insert states;
            
            User u = [select Id, Contact.Birthdate, Contact.Language__c, contact.Country_Of_Residence__c,
                                  contact.Country_Of_Origin__c,
                                  contact.mailingstreet,
                                  contact.mailingcity,
                                  contact.mailingstate,
                                  contact.mailingpostalcode,
                                  contact.mailingcountry,
                                  contact.mailing_country__c,
                                  contact.isEnglishNative__c
                                  from User where isActive=true AND ContactId != null LIMIT 1];
            // populate required field
            //System.Debug(u.id+'***********************************************'+u+u.contact.mailingstreet+u.contact.Country_Of_Residence__c+u.contact.isEnglishNative__c+u.Contact.Birthdate);
            
            u.contact.birthdate = System.Today();
            u.contact.language__c = 'English';
            u.contact.Gender__c = '';
            u.contact.Country_Of_Origin__c =null;
            u.contact.Country_Of_Residence__c = null;
            u.contact.MailingStreet = '';
            u.contact.MailingCity = '';
            u.contact.MailingState = '';
            u.contact.MailingPostalCode = '';
            u.contact.MailingCountry = '';
            u.contact.Mailing_Country__c =null;
            u.contact.OtherStreet = '';
            u.contact.OtherCity = '';
            u.contact.OtherState = '';
            u.contact.OtherPostalCode = '';
            u.contact.OtherCountry = '';
            u.contact.Other_Country__c = country.id;
            u.contact.Language__c = 'English';
            u.contact.isEnglishNative__c = true;
            u.contact.phone = '';
            u.contact.Home_Phone_Country_Code__c = null;
            u.contact.Mobile_Phone_Country_Code__c = null;
            u.contact.Other_country__c = null;
            u.contact.firstname= '';
            update u.contact;    
           
            System.runAs(u){
                ApplicantPersonalInformationController test = new ApplicantPersonalInformationController ();
                test.birthday = '';
                test.mailingPurpose = true;
                test.birthmonth = '';
                test.birthyear = '';
                test.saveAndContinue();
                test.StateChange();
                test.renderStatesList('2'); 
                ApplicantPersonalInformationController test2 = new ApplicantPersonalInformationController ();
         
            }
       }
        
}