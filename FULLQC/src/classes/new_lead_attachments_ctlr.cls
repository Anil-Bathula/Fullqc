public class new_lead_attachments_ctlr
{
/*
      Developer : Harsha Simha
      Extension for new_lead_attachments VF page.  
*/
    public string currleadid{get;set;}
    public Lead currlead_rec{get;set;}
    public boolean editlead{get;set;}
    public boolean addatach{get;set;}
    public string flagurl{get;set;}
     public blob body{get;set;}
     public string ctype{get;set;}
     public string fname{get;set;}
     public integer fsize{get;set;}
     
    /*attachment section variables*/
    public boolean showattchtable{get;set;} 
    public List<Attachment> currecattachmnts{get;set;}
    public map<string,Attachment> mapattch=new map<string,Attachment>();
    public string editattchid{get;set;}
    public Attachment attchmnt{get;set;}
    
    public new_lead_attachments_ctlr(ApexPages.StandardController controller) {
        
        currleadid=Apexpages.currentPage().getparameters().get('id');        
        currlead_rec=new Lead();
        if(currleadid!=null)
        {//Lead.
            editlead=false;
                currlead_rec=[select id,Name,Interview_Status__c,Interview_Date__c,Interview_Date_Booked__c,Program_Parsed__c,Lead_Stage__c,Region__c ,Country_Of_Residence__c,Country_Of_Residence__r.Flags__c,Country_Of_Residence__r.Name,SFGA__Web_Source__c,Program_Primary__r.Name,Owner.Name,Program_Primary__c,Telesales_Caller__c,Marketing_Source__c,Telesales_Caller__r.Name,OwnerId,LeadSource,Start_Term__c from Lead where id=:currleadid];
                   initattachments();                                  
        }
    } 
    
    
    /*init method for attachments, extracts attachments for current record*/ 
    public void initattachments()
    {             
        attchmnt= new Attachment();
        currecattachmnts=new List<Attachment>();
        if(currleadid==null||currleadid.trim()=='')
        {
        }
        else
        {
            currecattachmnts=[Select ParentId, Name, Id, Description, ContentType,CreatedDate From Attachment where ParentId=:currleadid];
            for(Attachment a:currecattachmnts)
            {
                mapattch.put(a.Id,a);    
            }
        }
        showattchtable=true;    
        addatach=false;
    }
    
    
     /*upload attachment under current record*/
    public void upattach()
    {
        attchmnt.ParentId=currlead_rec.Id;
        try
        {
                upsert attchmnt;
                initattachments();
        }
        catch(Exception e)
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Error : '+e));
        }      
    }
     
     /*displays File upload sections*/
    public void newattach()
    {
        showattchtable=true;    
        addatach=true;
        /*system.debug(Url.getCurrentRequestUrl());
        system.debug(Apexpages.currentPage());
        string redurl='/p/attach/NoteAttach?pid='+currleadid+'&parentname='+currlead_rec.Name+'&retURL=/'+currleadid;
        Pagereference p=new Pagereference(redurl);
        p.setRedirect(true);
        return p;  */      
    }
    
    /*Displays Edit Attachment section*/
    public void editattach()
    {    system.debug(editattchid);
        if(editattchid!=null && mapattch.containskey(editattchid))
        {
            attchmnt=mapattch.get(editattchid);  
            showattchtable=false;      
        }
    }
    
    /*Saves Changes to Attachment*/
    public void saveattach()
    {    
        if(attchmnt!=null)
        {
            update attchmnt;
            showattchtable=true;
           initattachments();
        }
    }

    /*section to display on cancel button click in New or Edit mode*/
    public void cancelattach()
    {   
        attchmnt=new Attachment();
        showattchtable=true;
         initattachments();
    }
    
    /*Delete Selected Attachment*/
    public void delattach()
    {    
        if(editattchid!=null && mapattch.containskey(editattchid))
        {
            attchmnt=mapattch.get(editattchid);
            Delete attchmnt;
            showattchtable=true;
            initattachments();
        }
    }
 
}