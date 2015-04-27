public class HRP_visamatrix {
    public Rotation_Documents__c[] reqs{ set; get;}
    public Rotation_Documents__c[] requirementVisaList { set; get;}
    public List<visamatrix> matrixtbl{get;set;}
    public visamatrix mtrx{get;set;}
    public Rotation__c rotobj{get;set;}
    public String header{get;set;}
    public string attid{get;set;}
    public String rolevals{get;set;}
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
    public boolean poffin{get;set;}
    
    public HRP_visamatrix(){
        rotobj=new Rotation__c();
        
    }
    //Inner class for return the values to the PageBlockTable 
    public class visamatrix{
        public String rotid{get;set;}
        public String rotname{get;set;}
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
        public String poffin{get;set;}
        public String stuunder{get;set;}
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
                        ,string poffin
                        ,string stuunder)
        {
            this.rotid=id;
            this.rotname=name;
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
            this.poffin=poffin;
            this.stuunder=stuunder;
        }
        public visamatrix(){
            
        }
    }
    //This method for return the values to the VC Users picklist
    public List<SelectOption> getroles() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('','--None--'));
         try{
             List<User> usr=[select id,name,Visa_Coordinator__c,City from User where Visa_Coordinator__c=true order by name];
             for(User u:usr){
                 options.add(new SelectOption(u.id,u.Name));
             }
         }
         catch(Exception e){
         }
         return options;
    }
    //This method for On changing the VC User, It returns all rotations Based on Selection of VC User  
    public void Search(){
        try{
            if(rolevals==null){
                matrixtbl=new List<visamatrix>();
                countrec=0;
                return;
            }
            else{
                matrixtbl=new List<visamatrix >();
                String srt= ApexPages.currentPage().getParameters().get('rec');
                Integer curr_year=system.today().year();
                if(System.today().month()>9)
                curr_year=system.today().year()+1;
                string curryear=String.valueOf(curr_year);
                string nextyear=String.valueOf(curr_year+1);
                
                String dq='';
                if(srt==null){
                    srt='Student__r.ownerId';
                }
                
                //if(srt!=null){
                    dq+='select id,name';
                    dq+=',Student__c,Student__r.ownerId,(select id,name,Supplied__c,Verified__c,Approved__c from Rotation_Documents__r) from Rotation__c';
                    dq+=' where Student__r.ownerId = : rolevals';
                //}
              // System.Debug(dq+'***************firing***'+srt);
                
                List<Rotation__c> varrot=Database.query(dq);
                countrec=0;
                for(Rotation__c o : varrot) {
                    countrec++;
                    mtrx=new visamatrix();
                    mtrx.rotid=o.id;
                    mtrx.rotname=o.Name;
                    System.Debug(o.Rotation_Documents__r.size()+'***************firing***'+mtrx.rotname);
                    for(Rotation_Documents__c req:o.Rotation_Documents__r){
                        System.debug(o.name+'-----------------------'+req.name+'<------------------->'+mtrx.rotname);
                        if(req.name=='Bank Validation Form' && req.Approved__c==True){
                            mtrx.declarefin='Approved';
                        }
                        else if(req.name=='Bank Validation Form' && req.Verified__c==True){
                            mtrx.declarefin='verified';
                        }
                        else if(req.name=='Bank Validation Form' && req.Supplied__c==True){
                            mtrx.declarefin='Supplied';
                        }
                        else if(req.name=='Bank Validation Form'){
                            mtrx.declarefin='docneed';
                        }
                        
                        if(req.name=='Copy Of Visa-China EMBA Tourist' && req.Approved__c==True){
                            mtrx.pofbank='Approved';
                        }
                        else if(req.name=='Copy Of Visa-China EMBA Tourist' && req.Verified__c==True){
                            mtrx.pofbank='verified';
                        }
                        else if(req.name=='Copy Of Visa-China EMBA Tourist' && req.Supplied__c==True){
                            mtrx.pofbank='Supplied';
                        }
                        else if(req.name=='Copy Of Visa-China EMBA Tourist'){
                            mtrx.pofbank='docneed';
                        }
                        
                        if(req.name=='Copy Of Visa-China X-2' && req.Approved__c==True){
                            mtrx.pofloan='Approved';
                        }
                        else if(req.name=='Copy Of Visa-China X-2' && req.Verified__c==True){
                            mtrx.pofloan='verified';
                        }
                        else if(req.name=='Copy Of Visa-China X-2' && req.Supplied__c==True){
                            mtrx.pofloan='Supplied';
                        }
                        else if(req.name=='Copy Of Visa-China X-2'){
                            mtrx.pofloan='docneed';
                        }
                        
                        if(req.name=='Copy Of Visa-UAE Visitor' && req.Approved__c==True){
                            mtrx.pofsponsor='Approved';
                        }
                        else if(req.name=='Copy Of Visa-UAE Visitor' && req.Verified__c==True){
                            mtrx.pofsponsor='verified';
                        }
                        else if(req.name=='Copy Of Visa-UAE Visitor' && req.Supplied__c==True){
                            mtrx.pofsponsor='Supplied';
                        }
                        else if(req.name=='Copy Of Visa-UAE Visitor'){
                            mtrx.pofsponsor='docneed';
                        }
                        
                        if(req.name=='Copy Of Visa-UK Visa National' && req.Approved__c==True){
                            mtrx.socPassport='Approved';
                        }
                        else if(req.name=='Copy Of Visa-UK Visa National' && req.Verified__c==True){
                            mtrx.socPassport='verified';
                        }
                        else if(req.name=='Copy Of Visa-UK Visa National' && req.Supplied__c==True){
                            mtrx.socPassport='Supplied';
                        }
                        else if(req.name=='Copy Of Visa-UK Visa National'){
                            mtrx.socPassport='docneed';
                        }
                        
                        if(req.name=='Copy Of Visa-US F-1' && req.Approved__c==True){
                            mtrx.trasferform='Approved';
                        }
                        else if(req.name=='Copy Of Visa-US F-1' && req.Verified__c==True){
                            mtrx.trasferform='verified';
                        }
                        else if(req.name=='Copy Of Visa-US F-1' && req.Supplied__c==True){
                            mtrx.trasferform='Supplied';
                        }
                        else if(req.name=='Copy Of Visa-US F-1'){
                            mtrx.trasferform='docneed';
                        }
                        
                        
                        if(req.name=='Declaration Of Finances' && req.Approved__c==True){
                            mtrx.casform='Approved';
                        }
                        else if(req.name=='Declaration Of Finances' && req.Verified__c==True){
                            mtrx.casform='verified';
                        }
                        else if(req.name=='Declaration Of Finances' && req.Supplied__c==True){
                            mtrx.casform='Supplied';
                        }
                        else if(req.name=='Declaration Of Finances'){
                            mtrx.casform='docneed';
                        }
                        
                        if(req.name=='Letter Of Support' && req.Approved__c==True){
                            mtrx.signed='Approved';
                        }
                        else if(req.name=='Letter Of Support' && req.Verified__c==True){
                            mtrx.signed='verified';
                        }
                        else if(req.name=='Letter Of Support' && req.Supplied__c==True){
                            mtrx.signed='Supplied';
                        }
                        else if(req.name=='Letter Of Support'){
                            mtrx.signed='docneed';
                        }
                        
                        if(req.name=='Passport Copy And Data' && req.Approved__c==True){
                            mtrx.visareg='Approved';
                        }
                        else if(req.name=='Passport Copy And Data' && req.Verified__c==True){
                            mtrx.visareg='verified';
                        }
                        else if(req.name=='Passport Copy And Data' && req.Supplied__c==True){
                            mtrx.visareg='Supplied';
                        }
                        else if(req.name=='Passport Copy And Data'){
                            mtrx.visareg='docneed';
                        }
                        
                        if(req.name=='Proof Of Funding' && req.Approved__c==True){
                            mtrx.personaldet='Approved';
                        }
                        else if(req.name=='Proof Of Funding' && req.Verified__c==True){
                            mtrx.personaldet='verified';
                        }
                        else if(req.name=='Proof Of Funding' && req.Supplied__c==True){
                            mtrx.personaldet='Supplied';
                        }
                        else if(req.name=='Proof Of Funding'){
                            mtrx.personaldet='docneed';
                        }
                        
                        if(req.name=='Proof Of Insurance' && req.Approved__c==True){
                            mtrx.poffin='Approved';
                        }
                        else if(req.name=='Proof Of Insurance' && req.Verified__c==True){
                            mtrx.poffin='verified';
                        }
                        else if(req.name=='Proof Of Insurance' && req.Supplied__c==True){
                            mtrx.poffin='Supplied';
                        }
                        else if(req.name=='Proof Of Insurance'){
                            mtrx.poffin='docneed';
                        }
                        
                        if(req.name=='Student Undertaken Letter' && req.Approved__c==True){
                            mtrx.stuunder='Approved';
                        }
                        else if(req.name=='Student Undertaken Letter' && req.Verified__c==True){
                            mtrx.stuunder='verified';
                        }
                        else if(req.name=='Student Undertaken Letter' && req.Supplied__c==True){
                            mtrx.stuunder='Supplied';
                        }
                        else if(req.name=='Student Undertaken Letter'){
                            mtrx.stuunder='docneed';
                        }
                    }
                    // Fetching requirement values into the inner class
                    matrixtbl.add(new visamatrix(mtrx.rotid
                                                ,mtrx.rotname
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
                                                ,mtrx.poffin
                                                ,mtrx.stuunder));
                        
                 }
             }
        }
        catch(Exception e){System.Debug('******************catch***'+e);
        }
    }
}