/*
        Developer        : Harsha Simha
        Date             : 20/1/2014
        Comments         : This page will display list of Dependents under one Rotation. 
                           Ability to Edit or Remove Existing Dependents from the Rotation.
                           Ability to Create New Rotation, Select the existing Dependents for that student(not under this rotation).
        
*/

public with sharing class Rotation_dependents_ctrlr 
{
    public List<Dependent__c> deps{get;set;}
    public string dep_id{get;set;}
    public string student_id{get;set;}
    public list<createdeps> create_deps{get;set;}
    public boolean disp_view{get;set;}
    public boolean disp_new{get;set;}
    public Rotation_dependents_ctrlr(ApexPages.StandardController controller) 
    {
       
         init();
         
    }
    
    public void init()
    {
         disp_view=true;
        disp_new=false;
        deps=new List<Dependent__c>();
        create_deps=new list<createdeps>();
        string page_id=ApexPages.CurrentPage().getParameters().get('id');    
        List<Rotation__c> rots=[select id,Student__c,(select id,Name,Date_of_Birth__c,First_Name__c,Gender__c,Last_Name__c,Relationship__c,
                                Rotation1__c,Rotation2__c,Student__c from Dependents__r),Name,(select id,Name,Date_of_Birth__c,
                                First_Name__c,Gender__c,Last_Name__c,Relationship__c,Rotation1__c,Rotation2__c,
                                Student__c from Rotation2Dependents__r) from Rotation__c where id=:page_id];
        
        for(Rotation__c r:rots)
        {
            student_id=r.Student__c;
            for(Dependent__c d:r.Dependents__r)
            {
                deps.add(d);
            }
            for(Dependent__c d:r.Rotation2Dependents__r)
            {
                deps.add(d);
            }
        }
        //deps=[select id,Name,Date_of_Birth__c,First_Name__c,Gender__c,Last_Name__c,Relationship__c,
          //   Rotation1__c,Rotation2__c,Student__c from Dependent__c where Rotation1__c=:page_id or Rotation2__c=:page_id ];
    }   
    public PageReference delete_dep()
    {
        if(ApexPages.CurrentPage().getParameters().get('depsid')!=null)
        {
            integer i=0;
            for(Dependent__c d : deps)
            {
                    system.debug(i+'--------------'+d.Id+'====================='+d.Id==ApexPages.CurrentPage().getParameters().get('depsid'));
                    system.debug(i+'--------------'+d.Rotation1__c+'=========='+d.Rotation2__c+'==========='+d.Id==ApexPages.CurrentPage().getParameters().get('id'));
                if(d.Id==ApexPages.CurrentPage().getParameters().get('depsid'))
                {
                    if(d.Rotation1__c==ApexPages.CurrentPage().getParameters().get('id'))
                    {
                        d.Rotation1__c=null;
                    }
                    if(d.Rotation2__c==ApexPages.CurrentPage().getParameters().get('id'))
                    {
                        d.Rotation2__c=null;
                    }
                    update d;
                    init();
                }
            }
        }
        return null;
    }
    
    public void New_dep()
    {
    disp_view=false;
    disp_new=true;
        string page_id=ApexPages.CurrentPage().getParameters().get('id');
        List<Dependent__c> dep=[select id,Name,Date_of_Birth__c,First_Name__c,Gender__c,Last_Name__c,Relationship__c,
             Rotation1__c,Rotation2__c,Student__c from Dependent__c where Rotation1__c!=:page_id and Rotation2__c!=:page_id and Student__c=:student_id];
        for(Dependent__c d:dep)
        {
            if(d.Rotation1__c!=null && d.Rotation2__c!=null)
                continue;
            if(d.Rotation1__c!=page_id  && d.Rotation1__c==null)
               d.Rotation1__c=page_id; 
            else if(d.Rotation2__c!=page_id  && d.Rotation2__c==null)
               d.Rotation2__c=page_id; 
            
            create_deps.add(new createdeps(false,d));
        }
    }
    public void add_blankdep()
    {
        create_deps.add(new createdeps(ApexPages.CurrentPage().getParameters().get('id'),student_id));
    }
    
    public void save_deps()
    {
        list<Dependent__c> save_deps=new list<Dependent__c>();
        for(createdeps d:create_deps)
        {
            
            if(d.isselected)
            {
                save_deps.add(d.depend);
            }
        }
        if(!save_deps.IsEmpty())
        {
            try
            {
                upsert save_deps;
                apexpages.addmessage(new apexpages.message(apexpages.severity.Info,'Records Saved Succesfully'));
                init();
            }
            catch(Exception e)
            {
                System.debug(e);
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Error : '+e));
            }
        }
        else
        {
            apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'No Records are Selected.'));
        }
    }
    
    public void cancl()
    {
        init();
    }
    
    
    public class createdeps
    {
        public boolean isselected{get;set;}
        public Dependent__c depend{get;set;}
        public boolean remove_btn{get;set;}
        createdeps(string depid,string studid)
        {
            isselected=false;
            depend=new Dependent__c();
            depend.Rotation1__c=depid;
            depend.student__c=studid;   
            remove_btn=true;
        }
        createdeps(boolean sel,Dependent__c dependents)
        {
            isselected=sel;
            depend=dependents;
            remove_btn=false;
        }
        
    }
}