/*
Author          : Premanath Reddy
Created Date    : 06/03/2013
Purpose         : Visa Requirement Matrix for Visa Coordinator user based on Campus.
Test class      : visarequirements_Test
*/
public class visarequirements {
    
    public Requirement__c[] reqs{ set; get;}
    public Requirement__c[] requirementVisaList { set; get;}
    public List<visamatrix> matrixtbl{get;set;}
    public visamatrix mtrx{get;set;}
    public Opportunity oppobj{get;set;}
    public String header{get;set;}
    public string attid{get;set;}
    public String rolevals{get;set;}
    public String campusvals{get;set;}
    public map<ID,integer> data{get;set;}
    public Integer countrec{get;set;}
    public boolean declarefin{get;set;}
    public boolean pofbank{get;set;}
    public boolean pofloan{get;set;}
    public boolean pofsponsor{get;set;}
    public boolean socPassport{get;set;}
    public boolean trasferform{get;set;}
    public boolean casform{get;set;}
    public boolean signed{get;set;}
    public boolean visareg{get;set;}
    public boolean personaldet{get;set;}
    public boolean poffin{get;set;}//j755
    Map<Id,String> citymap=new Map<Id,String>();
    
    public visarequirements(){
        oppobj=new Opportunity();
        //campusvals='London';
        
    }
    //Inner class for return the values to the PageBlockTable 
    public class visamatrix{
        public String oppid{get;set;}
        public String oppname{get;set;}
        public String owner{get;set;}
        public String program{get;set;}
        public Date lastday{get;set;}
        public Boolean highrisk{get;set;}
        public String visaactv{get;set;}
        public String substages{get;set;}
        public String bgcol{get;set;}
        public String declarefin{get;set;}
        public String pofbank{get;set;}
        public String pofloan{get;set;}
        public String pofsponsor{get;set;}
        public String socPassport{get;set;}
        public String trasferform{get;set;}
        public String casform{get;set;}
        public String signed{get;set;}
        public String visareg{get;set;}
        public String personaldet{get;set;}
        public String poffin{get;set;}//j755
        public visamatrix(Id Id
                        ,String name
                        ,String owner
                        ,String program
                        ,Date lastday
                        ,Boolean highrisk
                        ,String visaactv
                        ,String substages
                        ,String dfin
                        ,String bank
                        ,String ploan
                        ,String psponsor
                        ,String passport
                        ,String form
                        ,String casform
                        ,String signed
                        ,String visareg
                        ,String personaldet
                        ,string poffin)//j755
        {
            this.oppid=id;
            this.oppname=name;
            this.program=program;
            this.lastday=lastday;
            this.highrisk=highrisk;
            this.visaactv=visaactv;
            this.substages=substages;
            this.Owner=Owner;
            this.declarefin=dfin;
            this.pofbank=bank;
            this.pofloan=ploan;
            this.pofsponsor=psponsor;
            this.socPassport=passport;
            this.trasferform=form;
            this.casform=casform;
            this.signed=signed;
            this.visareg=visareg;
            this.personaldet=personaldet;
            this.poffin=poffin;//j755
        }
        public visamatrix(){
            
        }
    }
    //This method for return the values to the VC Users picklist
    public List<SelectOption> getroles() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         // Applications Return only if Start_Term__c!='September 2011' and Start_Term__c!='September 2010'
         try{//
            
            /* List<Opportunity> varopp=[select id
                                            ,name
                                            ,VC_Team_Member__c
                                            ,VC_Team_Member__r.Name
                                            ,VC_Team_Member__r.City
                                            ,StageName
                                            ,Application_Substage__c
                                            from opportunity 
                                            where VC_Team_Member__c!=:null
                                            and (Start_Term__c Like :curryear or Start_Term__c like:nextyear)
                                            ORDER by VC_Team_Member__r.Name ];*/
             List<User> usr=[select id,name,Visa_Coordinator__c,City from User where Visa_Coordinator__c=true order by name];
             for(User u:usr){
                 options.add(new SelectOption(u.id,u.Name));
                 citymap.put(u.id,u.City);
             }
         }
         catch(Exception e){
         }
         return options;
    }
    //This method for return the values to the Campus picklist
    public List<SelectOption> getcampus() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         options.add(new SelectOption('Boston','Boston'));
         options.add(new SelectOption('Dubai','Dubai'));
         options.add(new SelectOption('London','London'));
         options.add(new SelectOption('San Francisco','San Francisco'));
         options.add(new SelectOption('Shanghai','Shanghai'));
         return options;
    }
    /*public void Test(){
        String srt= ApexPages.currentPage().getParameters().get('rec');
        System.Debug('***************firing***'+srt);
    }*/
    //This method for On changing the VC User, It returns all Applications and Requirements of that Applications Based on Selection of VC User
    public void vcUserChange(){
        if(rolevals!=null){
            campusvals=citymap.get(rolevals);
            Search();
        }
    }
    //This method for On changing the Campus/VC User, It returns all Applications and Requirements of that Applications Based on Selection of VC User  
    public void Search(){
        try{
            if(rolevals==null || campusvals==null){
                matrixtbl=new List<visamatrix>();
                countrec=0;
                campusvals=null;
                return;
            }
            else{
                
                if(campusvals=='Boston' || campusvals=='San Francisco'){
                    declarefin=true;
                    pofbank=true;
                    pofloan=true;
                    pofsponsor=true;
                    socPassport=true;
                    trasferform=true;
                    casform=false;
                    signed=false;
                    visareg=false;
                    personaldet=false;
                    poffin=true;//j755
                }
                else if(campusvals=='London'){
                    declarefin=true;
                    pofbank=true;
                    pofloan=true;
                    pofsponsor=true;
                    socPassport=true;
                    trasferform=false;
                    casform=true;
                    signed=false;
                    visareg=false;
                    personaldet=false;
                    poffin=false;//j755
                }
                else if(campusvals=='Dubai'){
                    declarefin=false;
                    pofbank=false;
                    pofloan=false;
                    pofsponsor=false;
                    socPassport=true;
                    trasferform=false;
                    casform=false;
                    signed=true;
                    visareg=false;
                    personaldet=true;
                    poffin=false;//j755
                }
                else if(campusvals=='Shanghai'){
                    declarefin=false;
                    pofbank=false;
                    pofloan=false;
                    pofsponsor=false;
                    socPassport=true;
                    trasferform=false;
                    casform=false;
                    signed=false;
                    visareg=true;
                    personaldet=false;
                    poffin=false;//j755
                }
                matrixtbl=new List<visamatrix >();
                String srt= ApexPages.currentPage().getParameters().get('rec');
                Integer curr_year=system.today().year();
                if(System.today().month()>9)
                curr_year=system.today().year()+1;
                string curryear=String.valueOf(curr_year);
                string nextyear=String.valueOf(curr_year+1);
                
                String dq='';
                if(srt==null){
                    srt='Owner.Name';
                }
                
                if(srt!=null){
                    dq+='select id,name,OwnerID,StageName,Application_Substage__c,Owner.Name,Start_Term__c,Program_Parsed__c,Last_day_for_Visa_Submission__c,VC_Team_Member__c,Partial_Application_Date__c,Application_Complete_Deadline__c';
                    dq+=',Contact__c,First_Name_from_Contact__c,Last_Name_from_Contact__c,High_Risk_Nationality__c,Visa_Activity_Level__c,Visa_Related_Sub_Stages__c,(select id,name,Supplied__c,Verified__c,Approved__c from Requirements__r) from opportunity ';
                    dq+='where VC_Team_Member__c='+'\''+rolevals+'\''+' and Campus_parsed_from_Program__c ='+'\''+campusvals+'\''+' and (Start_Term__c Like'+' '+'\'%'+curryear+'\''+' or Start_Term__c Like'+' '+'\'%'+nextyear+'\''+')';
                    dq+=' and (Visa_Related_Sub_Stages__c='+'\''+'1a. Initial VC Notification Sent'+'\''+' or Visa_Related_Sub_Stages__c='+'\''+'1b. Welcome Call/Collecting Visa Docs'+'\''+' or Visa_Related_Sub_Stages__c='+'\''+'No Visa Required-Pending Proof'+'\''+') ORDER BY '+srt;
                }
              // System.Debug(dq+'***************firing***'+srt);
                
                List<Opportunity> varopp=Database.query(dq);
                countrec=0;
                for(Opportunity o : varopp) {
                    countrec++;
                    mtrx=new visamatrix();
                    mtrx.oppid=o.id;
                    mtrx.oppname=(o.First_Name_from_Contact__c==null?'':o.First_Name_from_Contact__c)+' '+o.Last_Name_from_Contact__c;
                    mtrx.owner=o.Owner.Name;
                    mtrx.program=o.Program_Parsed__c;
                    mtrx.lastday=o.Last_day_for_Visa_Submission__c;
                    mtrx.highrisk=o.High_Risk_Nationality__c;
                    mtrx.visaactv=o.Visa_Activity_Level__c;
                    mtrx.substages=o.Visa_Related_Sub_Stages__c;
                    for(Requirement__c req:o.Requirements__r){
                        //System.debug(req.Supplied__c+'-----------------------'+req.name+'<------------------->'+mtrx.oppname);
                        if(req.name=='Declaration of Finances' && req.Approved__c==True){
                            mtrx.declarefin='Approved';
                        }
                        else if(req.name=='Declaration of Finances' && req.Verified__c==True){
                            mtrx.declarefin='verified';
                        }
                        else if(req.name=='Declaration of Finances' && req.Supplied__c==True){
                            mtrx.declarefin='Supplied';
                        }
                        else if(req.name=='Declaration of Finances'){
                            mtrx.declarefin='docneed';
                        }
                        
                        if(req.name=='Proof of Funds - Bank Statements' && req.Approved__c==True){
                            mtrx.pofbank='Approved';
                        }
                        else if(req.name=='Proof of Funds - Bank Statements' && req.Verified__c==True){
                            mtrx.pofbank='verified';
                        }
                        else if(req.name=='Proof of Funds - Bank Statements' && req.Supplied__c==True){
                            mtrx.pofbank='Supplied';
                        }
                        else if(req.name=='Proof of Funds - Bank Statements'){
                            mtrx.pofbank='docneed';
                        }
                        
                        if(req.name=='Proof of Funds - Loan Letter' && req.Approved__c==True){
                            mtrx.pofloan='Approved';
                        }
                        else if(req.name=='Proof of Funds - Loan Letter' && req.Verified__c==True){
                            mtrx.pofloan='verified';
                        }
                        else if(req.name=='Proof of Funds - Loan Letter' && req.Supplied__c==True){
                            mtrx.pofloan='Supplied';
                        }
                        else if(req.name=='Proof of Funds - Loan Letter'){
                            mtrx.pofloan='docneed';
                        }
                        
                        if(req.name=='Proof of Funds - Sponsorship Letter' && req.Approved__c==True){
                            mtrx.pofsponsor='Approved';
                        }
                        else if(req.name=='Proof of Funds - Sponsorship Letter' && req.Verified__c==True){
                            mtrx.pofsponsor='verified';
                        }
                        else if(req.name=='Proof of Funds - Sponsorship Letter' && req.Supplied__c==True){
                            mtrx.pofsponsor='Supplied';
                        }
                        else if(req.name=='Proof of Funds - Sponsorship Letter'){
                            mtrx.pofsponsor='docneed';
                        }
                        
                        if(req.name=='Scan of current passport' && req.Approved__c==True){
                            mtrx.socPassport='Approved';
                        }
                        else if(req.name=='Scan of current passport' && req.Verified__c==True){
                            mtrx.socPassport='verified';
                        }
                        else if(req.name=='Scan of current passport' && req.Supplied__c==True){
                            mtrx.socPassport='Supplied';
                        }
                        else if(req.name=='Scan of current passport'){
                            mtrx.socPassport='docneed';
                        }
                        
                        if(req.name=='SEVIS Transfer form' && req.Approved__c==True){
                            mtrx.trasferform='Approved';
                        }
                        else if(req.name=='SEVIS Transfer form' && req.Verified__c==True){
                            mtrx.trasferform='verified';
                        }
                        else if(req.name=='SEVIS Transfer form' && req.Supplied__c==True){
                            mtrx.trasferform='Supplied';
                        }
                        else if(req.name=='SEVIS Transfer form'){
                            mtrx.trasferform='docneed';
                        }
                        
                        
                        if(req.name=='CAS Request Form' && req.Approved__c==True){
                            mtrx.casform='Approved';
                        }
                        else if(req.name=='CAS Request Form' && req.Verified__c==True){
                            mtrx.casform='verified';
                        }
                        else if(req.name=='CAS Request Form' && req.Supplied__c==True){
                            mtrx.casform='Supplied';
                        }
                        else if(req.name=='CAS Request Form'){
                            mtrx.casform='docneed';
                        }
                        
                        if(req.name=='Student Enrollment Contract' && req.Approved__c==True){
                            mtrx.signed='Approved';
                        }
                        else if(req.name=='Student Enrollment Contract' && req.Verified__c==True){
                            mtrx.signed='verified';
                        }
                        else if(req.name=='Student Enrollment Contract' && req.Supplied__c==True){
                            mtrx.signed='Supplied';
                        }
                        else if(req.name=='Student Enrollment Contract'){
                            mtrx.signed='docneed';
                        }
                        
                        if(req.name=='Visa Registration Form' && req.Approved__c==True){
                            mtrx.visareg='Approved';
                        }
                        else if(req.name=='Visa Registration Form' && req.Verified__c==True){
                            mtrx.visareg='verified';
                        }
                        else if(req.name=='Visa Registration Form' && req.Supplied__c==True){
                            mtrx.visareg='Supplied';
                        }
                        else if(req.name=='Visa Registration Form'){
                            mtrx.visareg='docneed';
                        }
                        
                        if(req.name=='Personal Details for Visa' && req.Approved__c==True){
                            mtrx.personaldet='Approved';
                        }
                        else if(req.name=='Personal Details for Visa' && req.Verified__c==True){
                            mtrx.personaldet='verified';
                        }
                        else if(req.name=='Personal Details for Visa' && req.Supplied__c==True){
                            mtrx.personaldet='Supplied';
                        }
                        else if(req.name=='Personal Details for Visa'){
                            mtrx.personaldet='docneed';
                        }
                        
                        //Start j755
                        if(req.name=='Proof of financial means' && req.Approved__c==True){
                            mtrx.poffin='Approved';
                        }
                        else if(req.name=='Proof of financial means' && req.Verified__c==True){
                            mtrx.poffin='verified';
                        }
                        else if(req.name=='Proof of financial means' && req.Supplied__c==True){
                            mtrx.poffin='Supplied';
                        }
                        else if(req.name=='Proof of financial means'){
                            mtrx.poffin='docneed';
                        }
                        //End j755
                    }
                    // Fetching requirement values into the inner class
                    matrixtbl.add(new visamatrix(mtrx.oppid
                                                ,mtrx.oppname
                                                ,mtrx.owner
                                                ,mtrx.program
                                                ,mtrx.lastday
                                                ,mtrx.highrisk
                                                ,mtrx.visaactv
                                                ,mtrx.substages
                                                ,mtrx.declarefin
                                                ,mtrx.pofbank
                                                ,mtrx.pofloan
                                                ,mtrx.pofsponsor
                                                ,mtrx.socPassport
                                                ,mtrx.trasferform
                                                ,mtrx.casform
                                                ,mtrx.signed
                                                ,mtrx.visareg
                                                ,mtrx.personaldet
                                                ,mtrx.poffin));
                        
                 }
             }
             //System.Debug('*********************'+countrec);
        }
        catch(Exception e){System.Debug('******************catch***'+e);
        }
    }
}