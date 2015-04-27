/*
Author                :Premanath Reddy
Created Date          : 20/02/2014
Purpouse              : When we change the Visa Track look up in Rotation, in the related Rotation Documents 
                        fields should make true Required by Current Visa Track-R1 and Required by Current Visa Track-R2
                        R1 = Rotation 1, R2 = Rotation 2 If,
                        find the related Visa Track on that rotation then check if the visa track has Master 
                        Rotation Documnets Name as Same with Rotation Documents.
*/

trigger rot_visatrack on Rotation__c (after update) {

    map<id,id> rotmap=new map<id,id> ();
    List<Rotation_Documents__c> rotdoc=new List<Rotation_Documents__c>();
    List<Rotation_Documents__c> updtdoc=new List<Rotation_Documents__c>();
    List<Master_Rotation_Document__c> mrd=new List<Master_Rotation_Document__c>();
    public boolean rot1_bool{get;set;}
    public boolean rot2_bool{get;set;}
    
    for(Rotation__c rot:Trigger.New){
        if(Trigger.oldMap.get(rot.Id).Visa_Track__c!=rot.Visa_Track__c && rot.Visa_Track__c!=null){
            rotmap.put(rot.id,rot.Visa_Track__c);
        }
    }
    if(!rotmap.isEmpty()){
        rotdoc=[Select id,Name,Rotation1__c,Rotation2__c
                ,Required_by_Current_Visa_Track_R1__c,Required_by_Current_Visa_Track_R2__c 
                from Rotation_Documents__c where 
                Rotation1__c in:rotmap.keyset() or Rotation2__c in:rotmap.keyset()];
        
        mrd=[Select id,Name,Visa_Track__c from Master_Rotation_Document__c
                        where Visa_Track__c in:rotmap.values() or Visa_Track__c in:rotmap.values()];
        
        if(!rotdoc.isEmpty() && !mrd.isEmpty()){
            for(Rotation_Documents__c r:rotdoc){
                rot1_bool=false;
                rot2_bool=false;
                for(Master_Rotation_Document__c m:mrd){
                    if(rotmap.get(r.Rotation1__c)==m.Visa_Track__c && r.Name==m.Name){
                        r.Required_by_Current_Visa_Track_R1__c=true;
                        rot1_bool=true;
                    }
                    else if(!rot1_bool){
                        r.Required_by_Current_Visa_Track_R1__c=false;
                    }
                    if(rotmap.get(r.Rotation2__c)==m.Visa_Track__c && r.Name==m.Name){
                        r.Required_by_Current_Visa_Track_R2__c=true;
                        rot2_bool=true;
                    }
                    else if(!rot2_bool){
                        r.Required_by_Current_Visa_Track_R2__c=false;
                    }
                }
                updtdoc.add(r);
            }
            update updtdoc;
        }
    }
}