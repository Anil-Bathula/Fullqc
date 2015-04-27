/******************************************************************************
Class:Opp_logCall
Written By: Anil.B
Purpose:To Create log a call on task with a button click
Changes :Anil.B 30/4/2013 added a query (line 25,41) and displaying all those results
in a page block table in opp_logcall vf page

Last Modified : Prem 29/10/2013 Replaced with RecordTypeHelper class instead of using the Query for Record Type for getting id.
*****************************************************************************
HISTORY 

    [3/12/2013] HARSHA SIMHA S :: Changed code to run for both Lead and Opportunity Standard Controllers. [sfsup-681]
    [13/12/2013] Prem :: SFSUP-686 :- Error Fixed. changed the condition.
    [27/06/2014] Anil:: SFSUP-742 :- Enhancement to update lead stage on clicking leftvoice mail andleft voice mail and called no voicemail buttons. 
    Modified by Prem : SFSUP-767
*/

Public Class Opp_logCall{

/*Declaration of variable*/
    public opportunity opp {get;set;}   
    public Task tsk{get;set;}   
    public Boolean property {get; set;}
    public Boolean showblock{get;set;}
    public Boolean hidebutton{get;set;} 
    public String SelId { get; set; }   
    public String delid{get;set;} 
    public string str{get;set;}      
    public map<id,Task> mpid{get;set;}  
    public list<leadHistory> listHistory{get;set;}
    Public Boolean hideblock{get;set;}
    public String usr=UserInfo.getUserId();
    public Boolean refreshPage {get; set;}
    Public list<Task>lsttsk{get;set;}
    public boolean islead=false;//[sfsup-681]
    public lead ld{get;set;}
    public lead l{get;set;}
   
   
    
/*Defining the controller */
    public Opp_logCall(ApexPages.StandardController controller) {   
        
        str=Apexpages.currentpage().getparameters().get('id');  
        if(str==null)
        {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You can log a call with opportunity or lead only.');
                Apexpages.addMessage(myMsg);
        }
        else
        {
            if(str.startswith('006'))
            {    
                islead=false;
                opp=(Opportunity)controller.getRecord();
            }
            else if(str.startswith('00Q'))
            {
                islead=true;   
                ld=(lead)controller.getRecord();
                l=[Select id,name,Lead_Stage__c from lead where id=:str];
            }     
            property=false;       
            hidebutton=true; 
            hideblock=true;        
            tsk=new Task();  
            mpid= new map<id,Task>(); 
            refreshPage=false;
            //Modified by Prem 10/6/2013:: "10. Welcome Team Profile"  users can only see calls logged by Welcome Team members.
            Set<String> allprofiles=new Set<String>{'Operations-Campus'};
            String teamprof=RecordTypeHelper.getprofilename(userinfo.getProfileId());
            string task_qry='select id,Subject,Description,CreatedDate,CreatedBy.Name from task where Status=\'Completed\''+
                                            ' and (subject=\'Left voicemail\' OR subject=\'Called,no voicemail\' OR subject=\'Connected\' OR subject=\'Face-to-Face\' )';
            if(islead)
                    task_qry+=' and whoid=:str'     ;                       
            else if(!islead)
                    task_qry+=' and whatid=:str'    ;
            if(allprofiles.contains(teamprof)){
                    task_qry+=' and Owner.Profile.Name=:teamprof ';   
            }
            task_qry+=' ORDER BY Createddate DESC limit 5';
            lsttsk=Database.query(task_qry);
        }
               /*else{
           lsttsk=[select id,
                           Subject,Description,CreatedDate,
                           CreatedBy.Name from 
                           task where whatid=:str and Status='Completed' and Owner.Profile.Name=:teamprof and
                           (subject='Left voicemail' OR subject='Called,no voicemail' OR subject='Connected' )
                           ORDER BY Createddate DESC limit 5];
       }
       */
                  
    }
    
    public void custNew(){   
     
        tsk=new Task();    
        property=true;
        hidebutton=false;  
        hideblock=false;          
    }
    
    Public Void CustCancel(){ 
        Property=False;
        hidebutton=false;  
        hidebutton=true;      
    }
    /*************This method is used for 2 buttons Connected and face to face**********/ 
    public Void custSave(){   
    
         //String s=[select id from Recordtype Where sobjectType='Task' And Name='Log Results of Calls' limit 1].id;      
         String s=RecordTypeHelper.getRecordTypeId('Task','Log Results of Calls');
         //Opportunity opp=[select id,name from Opportunity where  isDeleted=false AND id=:str ];
         //System.debug('::->'+opp);
         //If(opp!=null) {
            property=False; 
            hidebutton=true; 
            refreshPage=true;
            tsk.RecordTypeId=s;  
            tsk.Subject=selid;  
            tsk.Priority='Normal' ;
            tsk.Status='Completed';
            tsk.ActivityDate=system.today();
            tsk.Ownerid=usr;   
            if(islead)
            {
                tsk.whoid=str;
            }
            else
            {
                tsk.whatid=str;
            }      
            if(tsk.Description==null){   
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Record not Saved'));         
            } else{
                    //Modified :: SFSUP-686 :: Prem:- StringException :out of bounds firing the Error,so i have changed the below condition.
                try{  
                     tsk.Comments_Rl__c=tsk.Description==null?null:(tsk.Description.length()>250?tsk.Description.substring(0,250):tsk.Description);
                    // Integer i = tsk.Description.length(); 
                    // tsk.Comments_Rl__c=tsk.Description==null?null:(i>250?tsk.Description.substring(0,250):tsk.Description);
                     insert tsk;
                }
                catch(Exception e)
                {
                    system.debug(e);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error :: '+e);
                    Apexpages.addMessage(myMsg);
                }           
            }
        // }
           
    }
    
    /*************This method is used for 2 buttons left voice mail and called no voicemail**********/
     public Void custSave1(){   
      
       //String s=[select id from Recordtype Where sobjectType='Task' And Name='Log Results of Calls' limit 1].id;      
       String s=RecordTypeHelper.getRecordTypeId('Task','Log Results of Calls');
       //Opportunity opp=[select id,name from Opportunity where  isDeleted=false AND id=:str ];
      // System.debug('::->'+opp);
       
        //If(opp!=null) {
            tsk=new Task();
            property=False;            
            hidebutton=true; 
            refreshPage=true;
            tsk.RecordTypeId=s;
            //tsk.whatid=str;  
            tsk.Subject=selid;  
            tsk.Priority='Normal' ;
            tsk.Status='Completed';
            tsk.ActivityDate=system.today();
            tsk.Ownerid=usr; 
            if(islead)
            {
               
                /*****Jira 742******* START *****/
                ld.id=l.id;
                
                if(selid=='Left voicemail'||selid=='Called,no voicemail'){
                    if(l.lead_stage__c!='Unreachable Call 1' && l.lead_stage__c!='Unreachable Call 2'&&l.lead_stage__c!='Unreachable Call 3'&&l.lead_stage__c!='Unreached'){
                        ld.lead_stage__c='Unreachable Call 1';
                    }else if(l.lead_stage__c=='Unreachable Call 1'){
                        ld.lead_stage__c='Unreachable Call 2';        
                        system.debug('***************>'+l.lead_stage__c);               
                    }else if(l.lead_stage__c=='Unreachable Call 2'){
                        ld.lead_stage__c='Unreachable Call 3';
                    }else if(l.lead_stage__c=='Unreachable Call 3'){
                        ld.lead_stage__c='Unreached';
                    }else{
                    }
                }
                update ld;
                /*****Jira 742******* END *****/
                 tsk.whoid=str;
                
            }
            else
            {
                tsk.whatid=str;
            }   
            try{ 
            Insert tsk;
            }
            catch(Exception e)
            {
                system.debug(e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error :: '+e);
                Apexpages.addMessage(myMsg);
            
            }
                      
           // }
          
        }
           
    
}