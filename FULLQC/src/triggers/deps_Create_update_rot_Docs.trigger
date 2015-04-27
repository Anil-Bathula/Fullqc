/*
    Developer   :: S.Harsha Simha
    Date        :: 23/1/2014
    Comments    :: Trigger to create new Rotation document 'Second Passport' when "have second passport" checkbox is set to true on Dependent.
*/
trigger deps_Create_update_rot_Docs  on Dependent__c (after insert, after update) 
{
	map<id,Dependent__c> oldrotdep =new map<id,Dependent__c> ();
    map<id,Dependent__c> newrotdep =new map<id,Dependent__c> ();
     map<id,Dependent__c> novisatrackdeps =new map<id,Dependent__c> ();
     
   for(Dependent__c rd:Trigger.new)
   {
   		if(rd.Rotation1__c==null && rd.Rotation2__c==null)
   			continue;
   		
   		Dependent__c old_rd=new Dependent__c();
   		if(Trigger.isUpdate)
   			old_rd=Trigger.oldMap.get(rd.Id);	
   		
   		if(rd.Rotation1__c!=old_rd.Rotation1__c || rd.Rotation2__c!=old_rd.Rotation2__c)
   		{
   			oldrotdep.put(rd.Id,old_rd);
   			newrotdep.put(rd.Id,rd);
   		}
   		
   		if(Trigger.isInsert || Trigger.isupdate)
   		{
	   		If(rd.Rotation1__c!=null && rd.Rotation1_VisaTrack__c==null)
	   		{
	   			novisatrackdeps.put(rd.Id,rd);
	   		}
	   		If(rd.Rotation1__c!=null && rd.Rotation1_VisaTrack__c==null)
	   		{
	   			novisatrackdeps.put(rd.Id,rd);
	   		}
   		}
   }
   if(!newrotdep.IsEmpty())
   {
   		update_dependent_docs.update_dependents(oldrotdep, newrotdep);
   }
   
   if(!novisatrackdeps.IsEmpty())
   {
   		list<Rotation_Documents__c> upsertlist=new list<Rotation_Documents__c>();
		map<string,Rotation_Documents__c>  depdocs=new map<string,Rotation_Documents__c> ();
		list<Rotation_Documents__c> rdocs=[select id,Name,dependent__c,Rotation1__c,Rotation2__c,Created_from_Visatrack_Portal__c from Rotation_Documents__c where dependent__c IN:novisatrackdeps.keyset() and Name='Passport Copy And Data' and Dependent__c!=null];
		for(Rotation_Documents__c r: rdocs)
		{
			depdocs.put(r.dependent__c,r);
		}
		for(Dependent__c dep :novisatrackdeps.values())
   		{
   			Rotation_Documents__c dml_rdoc=new Rotation_Documents__c();
    		dml_rdoc.Name='Passport Copy And Data';
    		dml_rdoc.Created_from_Visatrack_Portal__c=true;
    		dml_rdoc.Dependent__c=dep.Id;
   			if(depdocs.containskey(dep.id))
   			{
   				dml_rdoc=depdocs.get(dep.Id);   				
   			}
			
   			if(dep.Rotation1__c!=null && dml_rdoc.Rotation1__c!=dep.Rotation1__c)
   			{
   					dml_rdoc.Rotation1__c=dep.Rotation1__c;
   			}
   			if(dep.Rotation2__c!=null && dml_rdoc.Rotation2__c!=dep.Rotation2__c)
   			{
   					dml_rdoc.Rotation2__c=dep.Rotation2__c;
   			}
   			upsertlist.add(dml_rdoc);
   		}
   		if(!upsertlist.ISempty())
   		{
   			try
   			{
   				upsert upsertlist;
   			}
   			catch(Exception e)
   			{
   				system.debug(e);
   			}
   		}
   }
}