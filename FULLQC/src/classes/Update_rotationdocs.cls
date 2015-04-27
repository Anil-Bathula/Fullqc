public with sharing class Update_rotationdocs 
{   
    public static void update_rotations(map<id,Rotation__c> oldrot,map<id,Rotation__c> newrot)
    {
        map<id,list<Rotation__c>> visatrack_rotations=new map<id,list<Rotation__c>>(); 
        map<id,list<Master_Rotation_Document__c>> masterdocs_map=new map<id,list<Master_Rotation_Document__c>>();
        map<id,map<string,Rotation_Documents__c>> existingdocs_map=new map<id,map<string,Rotation_Documents__c>>();
                
        list<Rotation_Documents__c> upsert_rotdocs=new list<Rotation_Documents__c>();
        
        set<string> contactids=new set<string>();
        set<Rotation__c> rotationss=new set<Rotation__c>();
        set<string> rotationsfordeps=new set<string>();
        System.debug(newrot+'----------------'+oldrot);
        for(id s:newrot.Keyset())
        {
            if(!newrot.get(s).Active__c)
                continue;
                
            //s1:exract all rotations comes under this visa track.          
            if(newrot.get(s).visa_track__c!=oldrot.get(s).visa_track__c && newrot.get(s).visa_track__c!=null)
            {
                Rotation__c rot=newrot.get(s);//.visa_track__c;
                //string visatrack=r.visa_track__c;
                list<Rotation__c> temp_rots=visatrack_rotations.containskey(rot.visa_track__c)?visatrack_rotations.get(rot.visa_track__c):new list<Rotation__c>();
                temp_rots.add(rot);
                visatrack_rotations.put(rot.visa_track__c,temp_rots);
                contactids.add(rot.student__c);
                rotationss.add(rot);
                rotationsfordeps.add(rot.Id);
            }
        }
        
        if(!visatrack_rotations.IsEmpty())
        {
            system.debug(visatrack_rotations+'---------------'+rotationss);
            
            //s2::extract all master docs based on visa tracks .
            masterdocs_map=getMaster_Rotation_Documents(visatrack_rotations.keyset());
            
            //s3::extract all docs for a particular student.
            existingdocs_map=getstudent_existingdocs(contactids);
            
            for(Rotation__c r:rotationss) // for each rotations
            {
                    System.debug(r+'===============');
                    If(!masterdocs_map.containsKey(r.Visa_Track__c))
                        continue;
                    
                    for(Master_Rotation_Document__c mdocr:masterdocs_map.get(r.Visa_Track__c)) // for all master documents in the visa track.
                    {   
                        if(!mdocr.Applies_to_Student__c)//if not for student then goto next doc. 
                            continue;
                        Rotation_Documents__c insrdoc=new Rotation_Documents__c();
                        
                        if(mdocr.New_copy_in_all_rotations__c)
                        {
                            insrdoc.Rotation1__c=r.Id;
                            insrdoc.Name=mdocr.Name;
                            insrdoc.dont_merge__c=mdocr.New_copy_in_all_rotations__c;
                            upsert_rotdocs.add(insrdoc);
                            continue;
                        }    
                       System.debug('-------------'+mdocr);     
                        boolean docexist=false;                 
                        map<string,Rotation_Documents__c> existdocs=existingdocs_map.containsKey(r.Student__c)?(existingdocs_map.get(r.Student__c)==null?
                                                                    new map<string,Rotation_Documents__c>() :existingdocs_map.get(r.Student__c)):new map<string,Rotation_Documents__c> ();
                        System.debug('-------------'+existdocs);
                        
                        if(!existdocs.IsEmpty())
                        {
                            for(String s:existdocs.keyset()) // for each existing document of a student.
                            {
                                System.debug(mdocr+' :'+'-------------'+s +'=========='+s.startsWith(mdocr+' :'));
                                if(!s.toLowerCase().startsWith(mdocr.Name.toLowerCase()+' :'))
                                    continue;
                                if(s.contains(': '+ r.Id) )//if there is a same doc exist for this rotation
                                {    
                                    docexist=true;
                                    break;
                                }
                                
                                
                                Rotation_Documents__c rd =existdocs.get(s);
                                
                                if(rd.Dont_Merge__c)
                                {
                                    break;
                                }   
                                                                                        
                                if(rd.Rotation1__c!=null && rd.Rotation2__c!=null)
                                {        
                                    if(!rd.Rotation1_Active__c)
                                    {
                                        docexist=true;
                                        insrdoc=rd;
                                        insrdoc.Rotation1__c=r.Id;
                                        insrdoc.Rotation1_VisaTrack__c=r.Visa_Track__c;
                                        insrdoc.Created_from_Visatrack_Portal__c=true;
                                        upsert_rotdocs.add(insrdoc);
                                        break;
                                    }
                                    else if(!rd.Rotation2_Active__c)
                                    {
                                        docexist=true;
                                        insrdoc=rd;
                                        insrdoc.Rotation2__c=r.Id;
                                        insrdoc.Rotation2_VisaTrack__c=r.Visa_Track__c;
                                        insrdoc.Created_from_Visatrack_Portal__c=true;
                                        upsert_rotdocs.add(insrdoc);
                                        break;
                                    }
                                }
                                else if(rd.Rotation1__c==null)
                                {
                                    docexist=true;
                                    insrdoc=rd;
                                    insrdoc.Rotation1__c=r.Id;
                                    insrdoc.Rotation1_VisaTrack__c=r.Visa_Track__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);                                    
                                    /*if(inactivate_rotdocs.ContainsKey(''+rd.Id))
                                    {
                                        inactivate_rotdocs.put(''+rd.Id,false);//current rotation document should be active    
                                    }*/
                                    
                                    break;
                                }
                                else if(rd.Rotation2__c==null)
                                {
                                    docexist=true;
                                    insrdoc=rd;
                                    insrdoc.Rotation2__c=r.Id;
                                    insrdoc.Rotation2_VisaTrack__c=r.Visa_Track__c;
                                    insrdoc.Created_from_Visatrack_Portal__c=true;
                                    upsert_rotdocs.add(insrdoc);
                                    /*
                                    if(inactivate_rotdocs.ContainsKey(''+rd.Id))
                                    {
                                        inactivate_rotdocs.put(''+rd.Id,false);//current rotation document should be active    
                                    }
                                    */
                                    break;
                                }
                            }
                        }
                        if(!docexist)
                        {
                            insrdoc.Rotation1__c=r.Id;
                            insrdoc.Name=mdocr.Name;
                            insrdoc.Rotation1_VisaTrack__c=r.Visa_Track__c;
                            insrdoc.Created_from_Visatrack_Portal__c=true;
                            insrdoc.dont_merge__c=mdocr.New_copy_in_all_rotations__c;
                            upsert_rotdocs.add(insrdoc);
                        }
                    }
            }
            
            If(!upsert_rotdocs.IsEmpty())
            {
                try             
                {   system.debug(upsert_rotdocs);
                    upsert upsert_rotdocs;
                    system.debug(upsert_rotdocs+'--------');
                }
                Catch(Exception e)
                {   
                    System.debug(e);
                }
            }            
            calldependends(rotationsfordeps);//update rotation dependents with documents.
        }       
        
    }
    
    public static void calldependends(set<string> rotations)
    {
        list<Dependent__c> deps=[select id,Name,Have_second_Passport__c,Student__c,Rotation1__c,Rotation2__c, 
                                    Rotation1_VisaTrack__c,Rotation2_VisaTrack__c from Dependent__c where Rotation1__c IN:rotations or Rotation2__c IN: rotations ];
        map<id,Dependent__c> olddep=new map<id,Dependent__c>();
        map<id,Dependent__c> newdep=new map<id,Dependent__c>();
        for(Dependent__c d:deps)
        {
            
            Dependent__c oldd=new Dependent__c();           
            
            oldd.Rotation1__c=d.Rotation1__c;
            oldd.Rotation2__c=d.Rotation2__c;
            oldd.Id=d.Id;
                        
            if(olddep.containskey(d.Id))
                oldd=olddep.get(d.Id);
            
            if(rotations.Contains(d.Rotation1__c))
            {
                oldd.Rotation1__c=null;
            }
            if(rotations.Contains(d.Rotation2__c))
            {
                oldd.Rotation2__c=null;
            }   
            System.debug(d+'-----------'+oldd);
            olddep.put(d.Id,oldd);
            newdep.put(d.Id,d);
        }
        
        if(!newdep.IsEmpty())
        {
            update_dependent_docs.update_dependents(olddep, newdep);
        }
    }
    public static map<id,list<Master_Rotation_Document__c>> getMaster_Rotation_Documents(set<id> visatracks)
    {
        
        List<Master_Rotation_Document__c> docs=[select id,Name,Applies_to_Dependent__c,Applies_to_Student__c,Visa_Track__c,New_copy_in_all_rotations__c 
                                                 from Master_Rotation_Document__c where Visa_Track__c IN: visatracks];
        system.debug(visatracks+'------------------------'+docs);
        map<id,list<Master_Rotation_Document__c>> masterdocs_map=new map<id,list<Master_Rotation_Document__c>>();                                        
        
        for(Master_Rotation_Document__c md:docs)
        {
            list<Master_Rotation_Document__c> temp=masterdocs_map.containsKey(md.Visa_Track__c)?masterdocs_map.get(md.Visa_Track__c):new list<Master_Rotation_Document__c>(); 
            temp.add(md);
            masterdocs_map.put(md.Visa_Track__c,temp);
        }       
        system.debug('------------------------------'+masterdocs_map);
        return masterdocs_map;
    }
    
    public static map<id,map<string,Rotation_Documents__c>> getstudent_existingdocs(set<string> contactids)
    {
        list<Rotation_Documents__c> rdocs=[select id,Name,Approved_Date__c,
                                            Created_from_Visatrack_Portal__c,dep_ContactId__c,Dependent__c,
                                            Dont_Merge__c,EXACT_Passport_Family_Name__c,EXACT_Passport_First_Name__c,
                                            EXACT_Passport_Middle_Name__c,For__c,Passport_Expiration_Date__c,                                            
                                            Passport_Issue_Date__c,Passport_issued_country__c,Passport_Number__c,
                                            Passport_Type__c,Required_by_Current_Visa_Track_R1__c,Required_by_Current_Visa_Track_R2__c,rot_ContactId__c,
                                            Rotation1__c,Rotation1_Active__c,For_Rotation1_available_to_portal__c,Rotation1_VisaTrack__c,
                                            Rotation2__c,Rotation2_Active__c,For_Rotation2_available_to_portal__c,Rotation2_VisaTrack__c,
                                            RotationsId__c,Student_has_second_passport__c,
                                            StudentId__c,Supplied__c,Supplied_Date__c,Verified__c,Verified_Date__c,
                                            Waived__c,Waived_Date__c,Waived_Reason__c 
                                          from Rotation_Documents__c where StudentId__c IN: contactids and Dependent__c=null];
        
        system.debug(contactids+'---------------------------'+rdocs);                                       
        map<id,map<string,Rotation_Documents__c>> existingdocs=new map<id,map<string,Rotation_Documents__c>>();
        for(Rotation_Documents__c r:rdocs)
        {
            map<string,Rotation_Documents__c> docs_map=existingdocs.containskey(r.StudentId__c)?existingdocs.get(r.StudentId__c):new map<string,Rotation_Documents__c>();
            string docname=r.Name+' : '+r.Rotation1__c + ' : ' +r.Rotation2__c;
            docs_map.put(docName,r);
            existingdocs.put(r.StudentId__c, docs_map);         
        }
        System.debug(existingdocs+'-----------------');
        return existingdocs;
    }
}