/*
    Developer   :: S.Harsha Simha
    Date        :: 23/1/2014
    Comments    :: Trigger to create new Rotation document when have second passport checkbox is set to true on Rotation.
*/
trigger rot_Create_update_rot_Docs  on Rotation__c (after insert, after update) 
{
    
    list<Rotation__c> selectedrotations=new list<Rotation__c>();
    list<string> studentids=new list<string>();
    map<string,List<Rotation__c>> student2rotation=new map<string,list<Rotation__c>>();
    
    map<id,Rotation__c> oldrot =new map<id,Rotation__c> ();
    map<id,Rotation__c> newrot =new map<id,Rotation__c> ();
    map<id,Rotation__C> withoutvisatrack=new map<id,Rotation__c> ();
    set<string> strudentids_novistrack=new set<string>();
    map<id,list<string>> student_novisatrackmap=new map<id,list<string>> ();
            
    for(Rotation__c rot:Trigger.New)
    {
        if(Trigger.isInsert)
        {
            oldrot.put(rot.Id,new Rotation__c());
            newrot.put(rot.Id,rot);
            if(rot.Visa_Track__c==null && rot.Rotation_Campus__c!=null && rot.Home_Campus__c!=rot.Rotation_Campus__c)
            {   
                withoutvisatrack.put(rot.Id,rot);
                strudentids_novistrack.add(rot.student__c);
                list<string> temp=student_novisatrackmap.containsKey(rot.student__c)?student_novisatrackmap.get(rot.student__c):new list<string>();
                temp.add(rot.Id);                
                student_novisatrackmap.put(rot.student__c,temp);
            }
        }
        if(Trigger.isUpdate)
        {
            Boolean temp=false;
            if(rot.Visa_Track__c!=null && rot.Visa_Track__c!=Trigger.oldMap.get(rot.Id).Visa_Track__c)
                temp=true;
            else if(rot.Active__c && rot.Active__c!=Trigger.oldMap.get(rot.Id).Active__c)   
                temp=true;
            if(temp)
            {   
                oldrot.put(rot.Id,Trigger.oldMap.get(rot.Id));
                newrot.put(rot.Id,rot);
            }
        }
        
        if(Trigger.Isinsert && rot.Student_has_second_passport__c) 
        {
            selectedrotations.add(rot);
            studentids.add(rot.Student__c);
            list<Rotation__c> rots_temp1=student2rotation.ContainsKey(rot.Student__c)?student2rotation.get(rot.Student__c):new List<rotation__c>();
            rots_temp1.add(rot);
            student2rotation.put(rot.Student__c,rots_temp1);
        }
/*        if(Trigger.Isinsert && rot.Have_second_Passport__c)
        {
            selectedrotations.add(rot);
            studentids.add(rot.Student__c);
            list<Rotation__c> rots_temp1=student2rotation.ContainsKey(rot.Student__c)?student2rotation.get(rot.Student__c):new List<rotation__c>();
            rots_temp1.add(rot);
            student2rotation.put(rot.Student__c,rots_temp1);
        }
        
        if(rot.Have_second_Passport__c &&  (Trigger.Isupdate && rot.Have_second_Passport__c!=Trigger.Oldmap.get(rot.Id).Have_second_Passport__c))
        {
            selectedrotations.add(rot);
            studentids.add(rot.Student__c);
            list<Rotation__c> rots_temp1=student2rotation.ContainsKey(rot.Student__c)?student2rotation.get(rot.Student__c):new List<rotation__c>();
            rots_temp1.add(rot);
            student2rotation.put(rot.Student__c,rots_temp1);
        }*/
    }
    
    if(!newrot.Isempty())
    {
        Update_rotationdocs.update_rotations(oldrot, newrot);
    }
    if(!withoutvisatrack.IsEmpty())
    {
        list<Rotation_Documents__c> upsert_rdocs=new list<Rotation_Documents__c>();
        map<string,Rotation_Documents__c> existing_rdocs=new map<string,Rotation_Documents__c>();
        list<Rotation_Documents__c> rdocs=[select id,Name,Rotation1__C,Rotation2__C,StudentId__c from Rotation_Documents__c where StudentId__c IN: strudentids_novistrack and Name='Passport Copy And Data' and dependent__c=null];
        for(Rotation_Documents__c r:rdocs)
        {
            existing_rdocs.put(r.StudentId__c,r);
        }
        
        for(string s:strudentids_novistrack)
        {
            list<string> ctct_rotids=new list<string>();
             ctct_rotids=student_novisatrackmap.containskey(s)?student_novisatrackmap.get(s):new list<string>();
            if(ctct_rotids!=null && !ctct_rotids.IsEmpty())
            {                                    
                Rotation_Documents__c dml_rdoc=new Rotation_Documents__c();
                dml_rdoc.Name='Passport Copy And Data';
                dml_rdoc.Created_from_Visatrack_Portal__c=true;
                if(existing_rdocs.containsKey(s))
                {
                    dml_rdoc=existing_rdocs.get(s);
                }
                if(ctct_rotids.size()>=1)
                {
                    if(ctct_rotids.size()==1)
                    {                    
                        if(dml_rdoc.rotation1__c==null)
                            dml_rdoc.rotation1__c=ctct_rotids[0];
                        else if(dml_rdoc.rotation2__c==null)
                            dml_rdoc.rotation2__c=ctct_rotids[0];
                        upsert_rdocs.add(dml_rdoc);        
                    }
                    else
                    {
                        
                        if(dml_rdoc.rotation1__c==null && dml_rdoc.rotation2__c==null)
                        {                                
                            dml_rdoc.rotation1__c=ctct_rotids[0];
                            dml_rdoc.rotation2__c=ctct_rotids[1];
                        }
                        else 
                        {
                            if(dml_rdoc.rotation1__c==ctct_rotids[0] || dml_rdoc.rotation2__c==ctct_rotids[0])
                            {    
                                if(dml_rdoc.rotation2__c==ctct_rotids[0])
                                    dml_rdoc.rotation1__c=ctct_rotids[1];
                                 else if(dml_rdoc.rotation1__c==ctct_rotids[0])
                                    dml_rdoc.rotation2__c=ctct_rotids[1];   
                            }
                            if(dml_rdoc.rotation1__c==ctct_rotids[1] || dml_rdoc.rotation2__c==ctct_rotids[1])
                            {    
                                if(dml_rdoc.rotation2__c==ctct_rotids[1])
                                    dml_rdoc.rotation1__c=ctct_rotids[0];
                                 else if(dml_rdoc.rotation1__c==ctct_rotids[1])
                                    dml_rdoc.rotation2__c=ctct_rotids[0];   
                            }
                        }
                        upsert_rdocs.add(dml_rdoc);        
                    }
                
                }
            }
        }/*
        for(rotation__c r:withoutvisatrack.values())
        {
            Rotation_Documents__c dml_rdoc=new Rotation_Documents__c();
            dml_rdoc.Name='Passport Copy And Data';
            dml_rdoc.Created_from_Visatrack_Portal__c=true;
            if(existing_rdocs.containsKey(r.Student__c))
            {
                dml_rdoc=existing_rdocs.get(r.Student__c);
            }
            if(dml_rdoc.rotation1__c==null)
                dml_rdoc.rotation1__c=r.Id;
            else if(dml_rdoc.rotation2__c==null)
                dml_rdoc.rotation2__c=r.Id;
            upsert_rdocs.add(dml_rdoc);
            
        }*/
        if(!upsert_rdocs.IsEmpty())
        {
            try
            {
                    upsert upsert_rdocs;
            }
            catch(Exception e){system.debug(e);}
        }
    }
   
    if(!selectedrotations.IsEmpty())
    {
        List<Rotation_Documents__c> upsert_rdocs2pasport=new List<Rotation_Documents__c>();
        map<string,Rotation_Documents__c> existing_rdocs2=new map<string,Rotation_Documents__c>();
        if(!studentids.Isempty())
        {
            list<Rotation_Documents__c> rdocs=[select id,Name,Rotation1__C,Rotation2__C,StudentId__c from Rotation_Documents__c where StudentId__c IN: studentids and Name='Second Passport' and dependent__c=null];
            for(Rotation_Documents__c r:rdocs)
            {
                existing_rdocs2.put(r.StudentId__c,r);
            }
        }
        for(Rotation__c r:selectedrotations)
        {
            Rotation_Documents__c dml_rdoc=new Rotation_Documents__c();
            dml_rdoc.Name='Second Passport';
            dml_rdoc.Created_from_Visatrack_Portal__c=true;
            if(existing_rdocs2.containsKey(r.Student__c))
            {
                dml_rdoc=existing_rdocs2.get(r.Student__c);
            }
            if(dml_rdoc.rotation1__c==null)
                dml_rdoc.rotation1__c=r.Id;
            if(dml_rdoc.rotation2__c==null)
                dml_rdoc.rotation2__c=r.Id;
            upsert_rdocs2pasport.add(dml_rdoc);
        }
        if(!upsert_rdocs2pasport.IsEmpty())
        {
            try
            {
                upsert upsert_rdocs2pasport;
            }
            catch(Exception e)
            {
                system.debug(e);
            }
        }
    }
    
}