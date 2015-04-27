public with sharing class update_dependent_docs 
{ 
     
    
    public static void update_dependents(map<id,Dependent__c> olddep,map<id,Dependent__c> newdep)
    {
        map<string,set<id>> visatracktodeps=new map<string,set<id>>();
        map<string,list<Master_Rotation_Document__c>>  masterdocs_map=new map<string,list<Master_Rotation_Document__c>>();
        map<id,map<string,Rotation_Documents__c>> existdocs_map=new map<id,map<string,Rotation_Documents__c>>();
        
        list<Rotation_Documents__c> upsert_rotdocs=new list<Rotation_Documents__c>();
        
        set<id> deps_set=new set<id>(); 
        system.debug(newdep); 
        system.debug(olddep);
        for(id s:newdep.keyset())
        {
            
            if(newdep.get(s).Rotation1__c!=olddep.get(s).Rotation1__c)
            {               
                Dependent__c dep=newdep.get(s);             
                set<id> temp=visatracktodeps.containsKey(dep.Rotation1_VisaTrack__c)?visatracktodeps.get(dep.Rotation1_VisaTrack__c):new set<id>();
                temp.add(dep.Id);
                visatracktodeps.put(dep.Rotation1_VisaTrack__c,temp);
                deps_set.add(dep.Id);
            }
            if(newdep.get(s).Rotation2__c!=olddep.get(s).Rotation2__c )
            {
                Dependent__c dep=newdep.get(s);
                set<id> temp=visatracktodeps.containsKey(dep.Rotation2_VisaTrack__c)?visatracktodeps.get(dep.Rotation2_VisaTrack__c):new set<id>();
                temp.add(dep.Id);
                visatracktodeps.put(dep.Rotation2_VisaTrack__c,temp);
                deps_set.add(dep.Id);
            }
        }
        
        if(!visatracktodeps.isEmpty()&&visatracktodeps.keyset()!=NULL)
        {
            system.debug(deps_set+'======'+visatracktodeps.keyset());
            masterdocs_map=getMaster_dependent_Documents(visatracktodeps.keyset());             
            existdocs_map=getdependent_existingdocs(deps_set);
            if(masterdocs_map!=null && !masterdocs_map.IsEmpty())
            {
                for(id dep_id:deps_set)
                {
                    boolean isrot1=false;
                    boolean isrot2=false;
                    set<string> depvisatracks=new set<string>();
                    if(newdep.get(dep_id).Rotation1__c!=olddep.get(dep_id).Rotation1__c)
                    {
                        isrot1=true;
                        depvisatracks.add(newdep.get(dep_id).Rotation1_VisaTrack__c);
                    }
                    if(newdep.get(dep_id).Rotation2__c!=olddep.get(dep_id).Rotation2__c)
                    {
                        isrot2=true;
                        depvisatracks.add(newdep.get(dep_id).Rotation2_VisaTrack__c);
                    }system.debug(depvisatracks);
                    if(depvisatracks.IsEmpty())
                        continue;                   
                    for(string s:depvisatracks)
                    {   system.debug(s+'==========='+masterdocs_map.Keyset());
                        if(!masterdocs_map.containsKey(s))
                            continue;
                        
                        for(Master_Rotation_Document__c mrdoc:masterdocs_map.get(s))
                        {
                            boolean isdocexist=false;
                            if(!mrdoc.Applies_to_Dependent__c )//if not for Depoendent then goto next doc. 
                                continue;
                            Rotation_Documents__c insrdoc=new Rotation_Documents__c();
                            
                            if(mrdoc.New_copy_in_all_rotations__c)
                            {
                                if(isrot1 && newdep.get(dep_id).Rotation1_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    Rotation_Documents__c insrdoc1=new Rotation_Documents__c();
                                    insrdoc1.Name=mrdoc.Name;
                                    insrdoc1.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc1.Rotation1__c=newdep.get(dep_id).Rotation1__c;
                                    insrdoc1.Rotation1_VisaTrack__c=newdep.get(dep_id).Rotation1_VisaTrack__c;
                                    insrdoc1.Created_from_Visatrack_Portal__c=true;
                                    insrdoc1.dont_merge__c=mrdoc.New_copy_in_all_rotations__c;
                                    upsert_rotdocs.add(insrdoc1);
                                }
                                if(isrot2 && newdep.get(dep_id).Rotation2_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    Rotation_Documents__c insrdoc1=new Rotation_Documents__c();
                                    insrdoc1.Name=mrdoc.Name;
                                    insrdoc1.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc1.Rotation2__c=newdep.get(dep_id).Rotation2__c;
                                    insrdoc1.Rotation2_VisaTrack__c=newdep.get(dep_id).Rotation2_VisaTrack__c;
                                    insrdoc1.Created_from_Visatrack_Portal__c=true;
                                    insrdoc1.dont_merge__c=mrdoc.New_copy_in_all_rotations__c;
                                    upsert_rotdocs.add(insrdoc1);
                                }
                                continue;
                            }
                            
                            map<string,Rotation_Documents__c> existdocs=existdocs_map.containsKey(dep_id)?(existdocs_map.get(dep_id)==null?
                                                                    new map<string,Rotation_Documents__c>() :existdocs_map.get(dep_id)):new map<string,Rotation_Documents__c> ();
                            
                            for(string docnames:existdocs.keyset())
                            {
                                if(!docnames.toLowerCase().startsWith(mrdoc.Name.toLowerCase()+' :'))
                                    continue;
                                if(isrot1 && newdep.get(dep_id).Rotation1_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    isdocexist=true;
                                    insrdoc=existdocs.get(docnames);
                                    insrdoc.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc.Rotation1__c=newdep.get(dep_id).Rotation1__c;
                                    insrdoc.Rotation1_VisaTrack__c=newdep.get(dep_id).Rotation1_VisaTrack__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);
                                }
                                if(isrot2 && newdep.get(dep_id).Rotation2_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    isdocexist=true;
                                    insrdoc=existdocs.get(docnames);
                                    insrdoc.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc.Rotation2__c=newdep.get(dep_id).Rotation2__c;
                                    insrdoc.Rotation2_VisaTrack__c=newdep.get(dep_id).Rotation2_VisaTrack__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);
                                }
                                if(isdocexist)
                                    break;
                            }
                            if(!isdocexist)
                            {
                                if(isrot1 && newdep.get(dep_id).Rotation1_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    insrdoc.Name=mrdoc.Name;
                                    insrdoc.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc.Rotation1__c=newdep.get(dep_id).Rotation1__c;
                                    insrdoc.Rotation1_VisaTrack__c=newdep.get(dep_id).Rotation1_VisaTrack__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);
                                }
                                if(isrot2 && newdep.get(dep_id).Rotation2_VisaTrack__c==mrdoc.Visa_Track__c)
                                {
                                    insrdoc.Name=mrdoc.Name;
                                    insrdoc.Dependent__c=newdep.get(dep_id).Id;
                                    insrdoc.Rotation2__c=newdep.get(dep_id).Rotation2__c;
                                    insrdoc.Rotation2_VisaTrack__c=newdep.get(dep_id).Rotation2_VisaTrack__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);
                                }
                            }
                        }
                    }
                }
            }   
            if(!upsert_rotdocs.IsEmpty())
            {
                try
                {
                    upsert upsert_rotdocs;
                }
                catch(Exception e)
                {
                    System.debug(e);
                }
            }
        }
    }
    
    public static map<string,list<Master_Rotation_Document__c>> getMaster_dependent_Documents(set<string> visatracks)
    {
        
        List<Master_Rotation_Document__c> docs=[select id,Name,Applies_to_Dependent__c,Applies_to_Student__c,Visa_Track__c,New_copy_in_all_rotations__c 
                                                 from Master_Rotation_Document__c where Visa_Track__c IN: visatracks and Applies_to_Dependent__c=true];
        
        map<string,list<Master_Rotation_Document__c>> masterdocs_map=new map<string,list<Master_Rotation_Document__c>>();                                        
        
        for(Master_Rotation_Document__c md:docs)
        {
            list<Master_Rotation_Document__c> temp=masterdocs_map.containsKey(md.Visa_Track__c)?masterdocs_map.get(md.Visa_Track__c):new list<Master_Rotation_Document__c>(); 
            temp.add(md);
            masterdocs_map.put(md.Visa_Track__c,temp);
        }       
        system.debug('------------------------------'+masterdocs_map);
        return masterdocs_map;
    }
    
    public static map<id,map<string,Rotation_Documents__c>> getdependent_existingdocs(set<id> dependentids)
    {
        list<Rotation_Documents__c> rdocs=[select id,Name,Rotation1__c,Rotation2__c,Dependent__c,StudentId__c,Dont_Merge__c   
                                                from Rotation_Documents__c where Dependent__c IN: dependentids];
        
        system.debug(dependentids+'---------------------------'+rdocs);                                       
        map<id,map<string,Rotation_Documents__c>> existingdocs=new map<id,map<string,Rotation_Documents__c>>();
        for(Rotation_Documents__c r:rdocs)
        {
            map<string,Rotation_Documents__c> docs_map=existingdocs.containskey(r.Dependent__c)?existingdocs.get(r.Dependent__c):new map<string,Rotation_Documents__c>();
            string docname=r.Name+' : '+r.Dependent__c+' - r1 : '+r.Rotation1__c + ' - r2 : ' +r.Rotation2__c;
            docs_map.put(docName,r);
            existingdocs.put(r.Dependent__c, docs_map);         
        }
        System.debug(existingdocs+'-----------------');
        return existingdocs;
    }
}