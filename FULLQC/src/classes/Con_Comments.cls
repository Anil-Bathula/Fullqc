/******************************************************************************
Class:Con_Comments
Written By: Anil.B
Purpose:To display comments records in Inline VIsualForce page(ContactComments)
******************************************************************************/



Public Class Con_Comments{
/*Declaration of Variable*/
    public Contact l {get;set;}
    public list<Comments__c> listCom{get; set;}  
    public Comments__c com{get;set;}   
    public Boolean property {get; set;}
    public Boolean showblock{get;set;}
    public Boolean hidebutton{get;set;} 
    public String SelId { get; set; }   
    public String delid{get;set;} 
    id str{get;set;}      
    public map<id,comments__c> mpid{get;set;}  
    public list<leadHistory> listHistory{get;set;}
    Public Boolean hideblock{get;set;}
    
/*Defining the controller */
    public con_Comments(ApexPages.StandardController controller) {   
        l=(Contact)controller.getRecord();
        str=Apexpages.currentpage().getparameters().get('id');  
        property=false;       
        hidebutton=true; 
        hideblock=true;        
        com=new Comments__c();  
        mpid= new map<id,comments__c>(); 
        loaddata();           
    }
 /*Querying for comments records which are linked with Current contact record*/ 
    public void loaddata(){
        if(str==null){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Applicant Record'));
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
                               where Applicant__c=:str order by CreatedDate desc limit 1000];
                               system.debug('asd:->'+str);
                              
          for(comments__c c:listCom){                          
               mpid.put(c.id,c);                                   
          }
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
        com.Applicant__c=str;    
        System.debug('ASD'+com.Applicant__c);
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
        if(mpid.containsKey(SelId)){                   
           com=mpid.get(SelId);       
        }             
    }  
 /*Method for Clicking Delete button*/
    public Void custDel(){
       listCom=[select id from comments__c where id=:delid];
       if(listcom.size()>0){
           delete listCom;
       }
       hideButton=true;
       property=False;
       loaddata();
       
    } 
 /*Method for Clicking Cancel button*/
    Public Void CustCancel(){ 
    Property=False;
    hidebutton=false;  
    hidebutton=true; 
      loaddata(); 
    }
 
}