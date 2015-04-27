/*
Created By   :- Premanath Reddy
Created Date :- 2/11/13
Pupose       :- creates an Activity History Vf page to show all the completed activities in VF page.
Modified by  :Anil.B on 15/11/2013 JIRA NO:::SFSUP-672
Changes at :- line 52 Added recordtype =visa process in if condition if(currentTab=='name1').
              line 97 Added RecordType =visa process in if condition if(currentTab=='name3').
*/


public class OPP_ActivityHistory {

    public Opportunity opp{get;set;}
    public Opportunity opp1{get;set;}
    public id str{get;set;}    
    Public List<ActivityHistory> acthist{get;set;}
    Public List<ActivityHistory> act{get;set;}
    public List<Event> ev{get;set;}
    public List<Task> tsk{get;set;}
    public List<Recruiting> recruit{get;set;}
    
    public String currentTab{get;set;}
    public OPP_ActivityHistory(ApexPages.StandardController controller) {
        try{
            recruit=new List<Recruiting>();
            this.opp = (Opportunity)controller.getRecord();
            str=Apexpages.currentpage().getparameters().get('id');
            acthist=new List<ActivityHistory>();
            ev=new List<Event>();
            tsk=new List<Task>();
            
            opp=[Select c.Name,c.Id,c.StageName,c.Confirmed_Date__c From Opportunity c where id=:str];
            
            ev=[Select Id,Subject,Description,Created_Date_Time__c,ActivityDate,owner.Name,Who.Name,EndDateTime,RecordType.Name,whoId,createdby.Name from Event Where whatid=:str and EndDateTime<:System.Now() order by Created_Date_Time__c desc];
            tsk=[Select Id,Subject,Description,Created_Date_Time__c,ActivityDate,owner.Name,Who.Name,Status,RecordType.Name,whatId,createdby.Name from Task Where  whatid=:str and status='Completed' order by Created_Date_Time__c desc];
            currentTab='name1';
            Data();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
        }
    } 
    //On Selection of Tabs this method will fire
    public void Data(){
        recruit=new List<Recruiting>();
        System.Debug('*********************************'+currentTab); 
        str=Apexpages.currentpage().getparameters().get('id');
        try{
        if(currentTab=='name1'){
            if(tsk.size()>0){
                for(Task t:tsk){
                    if(t.RecordType.Name=='Follow-Up' || t.RecordType.Name=='Event Signup' || t.RecordType.Name=='Log Results of Calls' || t.RecordType.Name=='Interview' || t.RecordType.Name=='Visa' || t.RecordType.Name=='Visa Process'){
                        //System.Debug('=====================tsk='+t.RecordType.Name);
                        String dt=t.Created_Date_Time__c.format('dd/MM/yyyy');
                        if(t.Description!=null && t.Description.length()>=150 && t.Description.contains('Body:') && (t.RecordType.Name=='Follow-Up' || t.RecordType.Name=='Interview')){
                            Integer i=t.Description.indexOf('Body:',0);
                            t.Description=t.Description.substring(i+5,i+155);
                        }
                        else if(t.Description!=null && t.Description.length()>=150){
                            t.Description=t.Description.substring(0,150);
                        }
                        recruit.add(new Recruiting(t.id,t.Subject,t.Description,t.Created_Date_Time__c,t.ActivityDate,t.owner.Name));
                    }
                }
            }
            if(ev.size()>0){
                for(Event e:ev){
                    if(e.RecordType.Name=='Applicant Interview Event Record Type' || e.RecordType.Name=='Lead Interview Event Record Type'){
                        String dt=e.Created_Date_Time__c.format('dd/MM/yyyy');
                        if(e.Description!=null && e.Description.length()>=150){
                            e.Description=e.Description.substring(0,150);
                        }
                        recruit.add(new Recruiting(e.id,e.Subject,e.Description,e.Created_Date_Time__c,e.ActivityDate,e.owner.Name));
                    }
                }
            }
        }
        else if(currentTab=='name2'){           //System.Debug('*******************************kkkkk**'+tsk.size());
            if(tsk.size()>0){
                for(Task t:tsk){
                    if(t.createdby.Name=='Eloqua Marketing' || t.RecordType.Name=='GMAT Test' || t.RecordType.Name=='SAT Test' || t.RecordType.Name=='Contact Us' || t.RecordType.Name=='Brochure Request'){
                        String dt=t.Created_Date_Time__c.format('dd/MM/yyyy');
                        if(t.Description!=null && t.Description.length()>=150){
                            t.Description=t.Description.substring(0,150);
                        }
                        if(!t.Subject.contains('Email')){
                            //System.Debug('*******************************kkkkk**'+t.Subject);
                            recruit.add(new Recruiting(t.id,t.Subject,t.Description,t.Created_Date_Time__c,t.ActivityDate,t.owner.Name));
                        }
                    }
                }
            }
        }
        else if(currentTab=='name3'){
            if(tsk.size()>0){
                for(Task t:tsk){
                    if((t.RecordType.Name=='Follow-Up' || t.RecordType.Name=='Visa' || t.RecordType.Name=='Interview'|| t.RecordType.Name=='Visa Process') && t.Created_Date_Time__c>=opp.Confirmed_Date__c){
                        String dt=t.Created_Date_Time__c.format('dd/MM/yyyy');
                        if(t.Description!=null && t.Description.length()>=150 && t.Description.contains('Body:') && t.RecordType.Name=='Follow-Up'){
                            Integer i=t.Description.indexOf('Body:',0);
                            t.Description=t.Description.substring(i,i+150);
                        }
                        else if(t.Description!=null && t.Description.length()>=150){
                            t.Description=t.Description.substring(0,150);
                        }
                        recruit.add(new Recruiting(t.id,t.Subject,t.Description,t.Created_Date_Time__c,t.ActivityDate,t.owner.Name));
                    }
                }
            }
        }
        else if(currentTab=='name4' && (opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed' || opp.StageName=='Admissions Endorsed Confirmed'||opp.StageName=='Soft Rejected Confirmed')){
            if(tsk.size()>0){
                for(Task t:tsk){
                    if(t.RecordType.Name=='Confirmation' && t.Created_Date_Time__c>=opp.Confirmed_Date__c){
                        String dt=t.Created_Date_Time__c.format('dd/MM/yyyy');
                        if(t.Description!=null && t.Description.length()>=150){
                            t.Description=t.Description.substring(0,150);
                        }
                        recruit.add(new Recruiting(t.id,t.Subject,t.Description,t.Created_Date_Time__c,t.ActivityDate,t.owner.Name));
                    }
                }
            }
        }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
        }
    }
    
    //This Method for Edit operation
    Public pagereference pagerd(){ 
        String IdValue=ApexPages.currentPage().getParameters().get('Rec');
        Pagereference newpage = new Pagereference ('/'+IdValue+'/e?retURL='+str);
        return newpage;
    }
    //This method for Delete operation
    public pagereference Del(){
        Pagereference opppage;
        try{
        String IdValue=ApexPages.currentPage().getParameters().get('Rec1');
        opp1=[Select c.Name, c.Id, (Select Id,RecordTypeId From Tasks where id=:IdValue),(Select Id From Events where id=:IdValue) From Opportunity c where id=:str];
        
        if(opp1.Tasks.size()>0)
            Delete opp1.Tasks;
        else if(opp1.Events.size()>0)
            Delete opp1.Events;
        opppage = new Pagereference ('/'+str);
        }
        catch(Exception e){
        }
        return opppage;
    }
    //This method for Subject link
    public pagereference sub(){
        String IdValue=ApexPages.currentPage().getParameters().get('sub1');
        Pagereference newpage = new Pagereference ('/'+IdValue);
        return newpage;
    }
    
    //Inner class for return the values to the Recruiting Tab
    public class Recruiting{
        Public String Id{get;set;}
        public String Subject{get;set;}
        public String Description{get;set;}
        public DateTime Createddate{get;set;}
        public Date Duedate{get;set;}
        public String Assignedto{get;set;}
        public Recruiting(String id,String sub,String des,DateTime ctddt,Date duedt,String asgto){
            this.id=id;
            this.Subject=sub;
            this.Description=des;
            this.Createddate=ctddt;
            this.Duedate=duedt;
            this.Assignedto=asgto;
        }
    }
    // This method for Sorting values Based on Created date
    /*public List<Recruiting> sorting(){
        map<DateTime,List<Recruiting>> strrec= new map<DateTime,list<Recruiting>>();
        for(Recruiting a:recruit){
            if(strrec.containsKey(a.Createddate))
                strrec.get(a.Createddate).add(a);            
            else
                strrec.put(a.Createddate,new Recruiting[]{a});        
        }
        recruit= new list<Recruiting>();
        list<DateTime> dtList = new list<DateTime>();
        dtList.addAll(strrec.keyset());
        dtList.sort(); 
        return recruit;   
    }*/
}