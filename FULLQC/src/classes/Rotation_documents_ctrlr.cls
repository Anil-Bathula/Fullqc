public with sharing class Rotation_documents_ctrlr {
    Public List<Rotation_Documents__c> rotdocs{get;set;}
    Public string filtervalue{get;set;}
    Public string opt_doc{get;set;}
     Public boolean viewmode{get;set;}
      
    string page_id=ApexPages.CurrentPage().getParameters().get('id');    
    public Rotation_documents_ctrlr(ApexPages.StandardController controller) 
    {
        filtervalue='Active';
        rotdocs=new list<rotation_Documents__c>();
        viewmode=true;
        getrotdocs();
    }
    public void newbtn()
    {
        viewmode=false;
    }
    public void savebtn()
    {
        rotation_Documents__c rd=new rotation_Documents__c();
        rd.Name=opt_doc;
        rd.Rotation1__c=page_id;
        try
        {
            insert rd;
            viewmode=true;
        }
        catch(Exception e)
        {
            System.debug(e);
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Error ' + e));
        }
    }
    public void cancelbtn()
    {
        
    }
    String querystr;
    public void getrotdocs()
    {//Rotation_Documents__c.
        if(page_id!=null)
      /*  rotdocs=[select id,Name,For__c,Rotation1__c,Rotation2__c 
                    from rotation_Documents__c where Rotation1__c=: page_id or Rotation2__c=: page_id ];*/
        querystr='select id,Name,For__c,Rotation1__c,Rotation2__c,For_Rotation1_available_to_portal__c,'
                        +'For_Rotation2_available_to_portal__c,Created_from_Visatrack_Portal__c from rotation_Documents__c where id!=null';
        if(filtervalue=='Active')
        {  
                querystr+=' and (Rotation1__c=: page_id or Rotation2__c=: page_id) and ((Rotation1__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation1_available_to_portal__c=true)) or (Rotation2__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation2_available_to_portal__c=true)))'; 
        }       
        if(filtervalue=='All')
        {  
                querystr+=' and (Rotation1__c=: page_id or Rotation2__c=: page_id )'; 
        }
        if(filtervalue=='Dependents')
        {  
                querystr+=' and (Rotation1__c=: page_id or Rotation2__c=: page_id ) and Dependent__c!=null'; 
        }
        if(filtervalue=='Active Dependents')
        {  
                querystr+=' and (Rotation1__c=: page_id or Rotation2__c=: page_id ) and Dependent__c!=null and ((Rotation1__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation1_available_to_portal__c=true)) or (Rotation2__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation2_available_to_portal__c=true)))';
        }
        if(filtervalue=='Active Students')
        {  
                querystr+=' and (Rotation1__c=: page_id or Rotation2__c=: page_id ) and Dependent__c=null and ((Rotation1__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation1_available_to_portal__c=true)) or (Rotation2__c=:page_id and (Created_from_Visatrack_Portal__c=true and For_Rotation2_available_to_portal__c=true)))';
        }
        //list<sobject> recs;             
        rotdocs=Database.query(querystr);                  
/*            rotdocs=[select id,Name,For__c,Rotation1__c,Rotation2__c 
                    from rotation_Documents__c where ((Rotation1__c=: page_id and Rotation1_available_in_portal__c=true) or (Rotation2__c=:page_Id and Rotation2_available_in_portal__c=true) and For__c ='Student' )];
  */  }
     public List<SelectOption> getfiltervals() 
     {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Active','All Active Documents'));
            options.add(new SelectOption('All','All Documents'));
            options.add(new SelectOption('Dependents','Dependents All Documents'));
            options.add(new SelectOption('Active Students','Student Active Documents'));
            options.add(new SelectOption('Active Dependents','Dependents Active Documents'));
            return options;
    }
    public List<SelectOption> getopt_docsvals() 
    {
        list<Master_Rotation_Document__c> mdocs=[select id,Name,Applies_to_Dependent__c,Visa_Track__c,Visa_Track__r.Name from Master_Rotation_Document__c where Visa_Track__r.Name='Optional Documents'];
        List<SelectOption> options = new List<SelectOption>();
        for(Master_Rotation_Document__c m:mdocs)
        {
            options.add(new SelectOption(''+m.Name,m.Name));
        }
        return options;
    }    
}