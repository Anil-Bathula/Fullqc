/******************************************************************************
Class:Opp_Comments
Written By: Anil.B
Purpose:To display comments records in Inline VIsualForce page(OpportunityComments)
Modified by Prem : SFSUP-767
Test class      : opp_comments_test(85%)
******************************************************************************/

Public Class Opp_Comments{

/*Declaration of variable*/
    public opportunity l {get;set;}
    public list<Comments__c> listCom{get; set;}  
    public Comments__c com{get;set;}   
    public Boolean property {get; set;}
    public Boolean showblock{get;set;}
    public Boolean hidebutton{get;set;} 
    public String selid { get; set; }   
    public String delid{get;set;} 
    id str{get;set;}      
    public map<id,comments__c> mpid{get;set;}  
    public list<leadHistory> listHistory{get;set;}
    Public Boolean hideblock{get;set;}
    
/*Defining the controller */
    public Opp_Comments(ApexPages.StandardController controller) {   
        l=(Opportunity)controller.getRecord();
        str=Apexpages.currentpage().getparameters().get('id');  
        property=false;       
        hidebutton=true; 
        hideblock=true;        
        com=new Comments__c();  
        mpid= new map<id,comments__c>(); 
        loaddata();           
    }
/*Querying for comments records which are linked with Current Opportunity record*/
    public void loaddata(){
        //Modified by Prem 19/7/2013:: "10. Welcome Team Profile"  users can only see calls logged by Welcome Team members.
        Set<String> allprofiles=new Set<String>{'Operations-Campus'};
        String teamprof=RecordTypeHelper.getprofilename(userinfo.getProfileId());
        
        if(str==null){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        }
        else if(!allprofiles.contains(teamprof)){
            listCom=[select id,name,lead__c
                              ,Applicant__c
                              ,Application__c
                              ,Finance__c
                              ,Comments__c
                              ,lead__r.Name                       
                              ,Role__c 
                              ,CreatedDate 
                              ,Owner.Name
                              ,Comment_Created_from__c
                               from comments__c 
                               where Application__c=:str order by CreatedDate desc limit 1000];
        }
        else{
           listCom=[select id,name,lead__c
                              ,Applicant__c
                              ,Application__c
                              ,Finance__c
                              ,Comments__c
                              ,lead__r.Name                       
                              ,Role__c 
                              ,CreatedDate 
                              ,Owner.Name
                              ,Comment_Created_from__c
                               from comments__c 
                               where Application__c=:str  AND Owner.Profile.Name=:teamprof order by CreatedDate desc limit 1000];
                               //system.debug('asd:->'+str); 
      }   
      for(comments__c c:listCom){                          
               mpid.put(c.id,c);                                   
      }                                        
   }
    
 /*Method for Clicking new button*/ 
    public void custNew(){   
        com=new comments__c();    
        property=true;
        hidebutton=false;  
        hideblock=false;          
    }
 /*Method for Clicking Save button*/
    public Void custSave(){    
        com.Application__c=str;     
        property=False; 
        hidebutton=true; 
        if(Com.Comments__c==null){   
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Record not Saved'));         
        } else{
        upsert com; 
        loaddata();
        }
           
    }
 /*Method for Clicking Edit button*/ 
    Public void custEdit(){         
        Property=true;
        hideblock=true;
        hidebutton=false;        
        if(mpid.containsKey(selid)){                   
           com=mpid.get(selid);       
        }             
    }  
 /*Method for Clicking Delete button*/
    public Void custDel(){
       try{
           listCom=[select id from comments__c where id=:delid];
           if(listcom.size()>0){
               delete listCom;
           }
           hideButton=true;
           property=False;
           loaddata();
       }
       Catch(Exception e){}
      
    } 
 /*Method for Clicking Cancel button*/
    Public Void CustCancel(){ 
    Property=False;
    hidebutton=false;  
    hidebutton=true; 
      loaddata(); 
    }
 
}