/*
Author          : Premanath Reddy
Created Date    : 18/10/2012
Purpose         : Requirement ConversionMatrix for Converter user.
*/
public with sharing class requirementsmatrix {
    public ApexPages.StandardController controller;
    public Requirement__c[] reqs{ set; get;}
    public Requirement__c[] requirementVisaList { set; get;}
    public List<reqmatrix> matrixtbl{get;set;}
    public reqmatrix mtrx{get;set;}
    public Opportunity oppobj{get;set;}
    public String header{get;set;}
    public string attid{get;set;}
    public String rolevals{get;set;}
    public map<ID,integer> data{get;set;}
    public Integer countrec{get;set;}
    public requirementsmatrix(ApexPages.StandardController controller){
        this.controller = controller; 
        oppobj=new Opportunity();
        //Getting converter into the picklist on pageload -if current user is Converter 
        try{
            Opportunity varopp=[select id
                                       ,name
                                       ,Conversion_Team_Member__c
                                       ,StageName
                                       ,Application_Substage__c
                                       from opportunity 
                                       where (Conversion_Team_Member__c!=:null and StageName='Partial Application') 
                                       and (Start_Term__c!='September 2011' and Start_Term__c!='September 2010')
                                       and Conversion_Team_Member__c=:UserInfo.getUserId() 
                                       and Application_Substage__c!='Completed Application' and Application_Substage__c!='Not Completing App' limit 1];
            if(varopp.Conversion_Team_Member__c==UserInfo.getUserId()){
                rolevals=UserInfo.getUserId();
                Search();
            }
        }
        catch(Exception e){
            Opportunity varopp=[select id
                                       ,name
                                       ,Conversion_Team_Member__c
                                       ,StageName
                                       ,Application_Substage__c
                                       from opportunity 
                                       where (Conversion_Team_Member__c!=:null and StageName='Partial Application') 
                                       and (Start_Term__c!='September 2011' and Start_Term__c!='September 2010') 
                                       and Application_Substage__c!='Completed Application' and Application_Substage__c!='Not Completing App' limit 1];
            rolevals=varopp.Conversion_Team_Member__c;
            Search();
        }
    }
    //Inner class for return the values to the PageBlockTable 
    public class reqmatrix{
        public String oppid{get;set;}
        public String oppname{get;set;}
        public String owner{get;set;}
        public String program{get;set;}
        public String Startterm{get;set;}
        public Date partialapp{get;set;}
        public Date deadline{get;set;}
        public String bgcol{get;set;}
        public String CurrentResume{get;set;}
        public String EssayStmt{get;set;}
        public String UndGrd{get;set;}
        public String HighSch{get;set;}
        public String Diploma{get;set;}
        public String ProfRecm{get;set;}
        public String Prof2{get;set;}
        public String GraduateTest{get;set;}
        public String Languageprof{get;set;}
        public reqmatrix(Id Id
                        ,String name
                        ,String owner
                        ,String program
                        ,String Startterm
                        ,Date partialapp
                        ,Date deadline
                        ,String resume
                        ,String essay
                        ,String UndGrd
                        ,String HighSch
                        ,String Diploma
                        ,String prof1
                        ,String prof2
                        ,String grad
                        ,String lang)
        {
            this.oppid=id;
            this.oppname=name;
            this.program=program;
            this.Startterm=Startterm;
            this.partialapp=partialapp;
            this.deadline=deadline;
            this.Owner=Owner;
            this.CurrentResume=resume;
            this.EssayStmt=essay;
            this.UndGrd=UndGrd;
            this.HighSch=HighSch;
            this.Diploma=Diploma;
            this.ProfRecm=prof1;
            this.Prof2=Prof2;
            this.GraduateTest=grad;
            this.Languageprof=lang;
        }
        public reqmatrix(){
            
        }
    }
    //This method for return the converters to the Converter picklist
    public List<SelectOption> getroles() {
         List<SelectOption> options = new List<SelectOption>();
         try{
             List<Opportunity> varopp=[select id
                                            ,name
                                            ,Conversion_Team_Member__c
                                            ,Conversion_Team_Member__r.Name
                                            ,StageName
                                            ,Application_Substage__c
                                            from opportunity 
                                            where (Conversion_Team_Member__c!=:null and StageName='Partial Application') 
                                            and (Start_Term__c!='September 2011' and Start_Term__c!='September 2010') 
                                            and (Application_Substage__c!='Completed Application' and Application_Substage__c!='Not Completing App')
                                            ORDER by Conversion_Team_Member__r.Name];
             
            /* data = new map<ID,integer>();
             for(Opportunity opp:varopp){
                 integer count = data.get(opp.Conversion_Team_Member__c);
                 if(count != null)
                     count++;
                 else
                     count = 1;
                 data.put(opp.Conversion_Team_Member__c, count);
             }
             List<Integer> aList=new List<Integer>(data.values());
             aList.sort();
             List<Integer> descValue = new List<Integer>();
             for(Integer i=aList.size()-1; i>=0;i--)
             {
             descValue.add(aList.get(i));
             }
             System.debug('Sorted values of Map in descending are:'+descValue);
             */
             set<ID> varset=new set<ID>();
             for(Opportunity opp:varopp){
                 if(!varset.contains(opp.Conversion_Team_Member__c)){
                     options.add(new SelectOption(opp.Conversion_Team_Member__c,opp.Conversion_Team_Member__r.Name));
                     varset.add(opp.Conversion_Team_Member__c);
                 }
             }
         }
         catch(Exception e){
         }
         return options;
    }
    //This method for On changing the Converter, It returns all Applications and Requirements of that Applications Based on Selection of Converter  
    public void Search(){
        matrixtbl=new List<reqmatrix>();
        //System.Debug('*********************'+count);
        String srt= ApexPages.currentPage().getParameters().get('rec');
        String dq='';
        if(srt!=null){
            dq+='select id,name,OwnerID,StageName,Application_Substage__c,Owner.Name,Start_Term__c,Program_Parsed__c,VC_Team_Member__c,Partial_Application_Date__c,Application_Complete_Deadline__c';
            dq+=',Contact__c,First_Name_from_Contact__c,Last_Name_from_Contact__c,(select id,name,Supplied__c,Verified__c,Approved__c from Requirements__r) from opportunity ';
            dq+='where Conversion_Team_Member__c='+'\''+rolevals+'\''+' and Application_Substage__c!='+'\''+'Completed Application'+'\'';
            dq+=' and Application_Substage__c!='+'\''+'Not Completing App'+'\''+' ORDER BY '+srt;
        }
        else{
            dq+='select id,name,OwnerID,StageName,Application_Substage__c,Owner.Name,Start_Term__c,Program_Parsed__c,VC_Team_Member__c,Partial_Application_Date__c,Application_Complete_Deadline__c';
            dq+=',Contact__c,First_Name_from_Contact__c,Last_Name_from_Contact__c,(select id,name,Supplied__c,Verified__c,Approved__c from Requirements__r) from opportunity ';
            dq+='where Conversion_Team_Member__c='+'\''+rolevals+'\''+' and Application_Substage__c!='+'\''+'Completed Application'+'\'';
            dq+=' and Application_Substage__c!='+'\''+'Not Completing App'+'\''+' ORDER BY Owner.Name';
        }
        //System.Debug(dq+'***************firing***'+srt);
        List<Opportunity> varopp=Database.query(dq);
        
        /*List<Opportunity> varopp=[select id
                                        ,name
                                        ,OwnerID
                                        ,StageName
                                        ,Application_Substage__c
                                        ,Owner.Name
                                        ,Start_Term__c
                                        ,Program_Parsed__c
                                        ,Partial_Application_Date__c
                                        ,Application_Complete_Deadline__c
                                        ,Contact__c
                                        ,First_Name_from_Contact__c
                                        ,Last_Name_from_Contact__c
                                        ,(select id,name,Supplied__c,Verified__c,Approved__c from Requirements__r) 
                                        from opportunity where Conversion_Team_Member__c=:rolevals 
                                        and Application_Substage__c!='Completed Application' 
                                        and Application_Substage__c!='Not Completing App'
                                        ORDER by Owner.Name];*/
        countrec=0;
        for(Opportunity o : varopp) {
            if(o.StageName=='Partial Application' && (o.Start_Term__c!='September 2011' && o.Start_Term__c!='September 2010')){
                countrec++;
                mtrx=new reqmatrix();
                mtrx.oppid=o.id;
                mtrx.oppname=(o.First_Name_from_Contact__c==null?'':o.First_Name_from_Contact__c)+' '+o.Last_Name_from_Contact__c;
                mtrx.owner=o.Owner.Name;
                mtrx.program=o.Program_Parsed__c;
                mtrx.Startterm=o.Start_Term__c;
                mtrx.partialapp=o.Partial_Application_Date__c;
                mtrx.deadline=o.Application_Complete_Deadline__c;
                for(Requirement__c req:o.Requirements__r){
                    //System.debug(req.Supplied__c+'-----------------------'+req.name+'<------------------->'+mtrx.oppname);
                    if(req.name=='Current Resume' && req.Approved__c==True){
                        mtrx.CurrentResume='Approved';
                    }
                    else if(req.name=='Current Resume' && req.Verified__c==True){
                        mtrx.CurrentResume='verified';
                    }
                    else if(req.name=='Current Resume' && req.Supplied__c==True){
                        mtrx.CurrentResume='Supplied';
                    }
                    else if(req.name=='Current Resume'){
                        mtrx.CurrentResume='docneed';
                    }
                    
                    if(req.name=='Essay/Personal Statement' && req.Approved__c==True){
                        mtrx.EssayStmt='Approved';
                    }
                    else if(req.name=='Essay/Personal Statement' && req.Verified__c==True){
                        mtrx.EssayStmt='verified';
                    }
                    else if(req.name=='Essay/Personal Statement' && req.Supplied__c==True){
                        mtrx.EssayStmt='Supplied';
                    }
                    else if(req.name=='Essay/Personal Statement'){
                        mtrx.EssayStmt='docneed';
                    }
                    
                    if(req.name=='Undergrad-Postgrad Transcript' && req.Approved__c==True){
                        mtrx.UndGrd='Approved';
                    }
                    else if(req.name=='Undergrad-Postgrad Transcript' && req.Verified__c==True){
                        mtrx.UndGrd='verified';
                    }
                    else if(req.name=='Undergrad-Postgrad Transcript' && req.Supplied__c==True){
                        mtrx.UndGrd='Supplied';
                    }
                    else if(req.name=='Undergrad-Postgrad Transcript'){
                        mtrx.UndGrd='docneed';
                    }
                    
                    if(req.name=='High School Transcript' && req.Approved__c==True){
                        mtrx.HighSch='Approved';
                    }
                    else if(req.name=='High School Transcript' && req.Verified__c==True){
                        mtrx.HighSch='verified';
                    }
                    else if(req.name=='High School Transcript' && req.Supplied__c==True){
                        mtrx.HighSch='Supplied';
                    }
                    else if(req.name=='High School Transcript'){
                        mtrx.HighSch='docneed';
                    }
                    
                    if(req.name=='High School Diploma' && req.Approved__c==True){
                        mtrx.Diploma='Approved';
                    }
                    else if(req.name=='High School Diploma' && req.Verified__c==True){
                        mtrx.Diploma='verified';
                    }
                    else if(req.name=='High School Diploma' && req.Supplied__c==True){
                        mtrx.Diploma='Supplied';
                    }
                    else if(req.name=='High School Diploma'){
                        mtrx.Diploma='docneed';
                    }
                    
                    if(req.name=='Professional Recommendation (1 of 2)' && req.Approved__c==True){
                        mtrx.ProfRecm='Approved';
                    }
                    else if(req.name=='Professional Recommendation (1 of 2)' && req.Verified__c==True){
                        mtrx.ProfRecm='verified';
                    }
                    else if(req.name=='Professional Recommendation (1 of 2)' && req.Supplied__c==True){
                        mtrx.ProfRecm='Supplied';
                    }
                    else if(req.name=='Professional Recommendation (1 of 2)'){
                        mtrx.ProfRecm='docneed';
                    }
                    
                    
                    if(req.name=='Professional Recommendation (2 of 2)' && req.Approved__c==True){
                        mtrx.Prof2='Approved';
                    }
                    else if(req.name=='Professional Recommendation (2 of 2)' && req.Verified__c==True){
                        mtrx.Prof2='verified';
                    }
                    else if(req.name=='Professional Recommendation (2 of 2)' && req.Supplied__c==True){
                        mtrx.Prof2='Supplied';
                    }
                    else if(req.name=='Professional Recommendation (2 of 2)'){
                        mtrx.Prof2='docneed';
                    }
                    
                    if(req.name=='Graduate Test' && req.Approved__c==True){
                        mtrx.GraduateTest='Approved';
                    }
                    else if(req.name=='Graduate Test' && req.Verified__c==True){
                        mtrx.GraduateTest='verified';
                    }
                    else if(req.name=='Graduate Test' && req.Supplied__c==True){
                        mtrx.GraduateTest='Supplied';
                    }
                    else if(req.name=='Graduate Test'){
                        mtrx.GraduateTest='docneed';
                    }
                    
                    if(req.name=='Language Proficiency, English' && req.Approved__c==True){
                        mtrx.Languageprof='Approved';
                    }
                    else if(req.name=='Language Proficiency, English' && req.Verified__c==True){
                        mtrx.Languageprof='verified';
                    }
                    else if(req.name=='Language Proficiency, English' && req.Supplied__c==True){
                        mtrx.Languageprof='Supplied';
                    }
                    else if(req.name=='Language Proficiency, English'){
                        mtrx.Languageprof='docneed';
                    }
                  }
                // Fetching requirement values into the inner class
                matrixtbl.add(new reqmatrix(mtrx.oppid
                                            ,mtrx.oppname
                                            ,mtrx.owner
                                            ,mtrx.program
                                            ,mtrx.Startterm
                                            ,mtrx.partialapp
                                            ,mtrx.deadline
                                            ,mtrx.CurrentResume
                                            ,mtrx.EssayStmt
                                            ,mtrx.UndGrd
                                            ,mtrx.HighSch
                                            ,mtrx.Diploma
                                            ,mtrx.ProfRecm
                                            ,mtrx.Prof2
                                            ,mtrx.GraduateTest
                                            ,mtrx.Languageprof));
               }
         }
         //System.Debug('*********************'+countrec);
    }
    
}