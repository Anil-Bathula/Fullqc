/*
    Developer   :: Premanath Reddy
    Date        :: 14/1/2015
    Comments    :: (SFSUP-850)Trigger to update the finance visa track is changed on Rotation.
    Test Class  :: Rotation2documentstest(77%)
*/
trigger rot_autofee on Rotation__c (after insert,after update) {
    map<Rotation__c,id> rotmap=new map<Rotation__c,id>();
    List<Rotation__c> rotlst=new List<Rotation__c>();
    Set<Id> ids=new Set<Id>();
    for(Rotation__c rot:Trigger.New){
        Rotation__c oldrot=Trigger.isInsert?new Rotation__c():Trigger.oldMap.get(rot.Id);
        if(rot.Active__c && rot.Is_Rotating__c && oldrot.Visa_Track__c!=rot.Visa_Track__c && rot.Visa_Track__c!=null){
            rotmap.put(rot,rot.Visa_Track__c);
            ids.add(rot.Student__c);
        }
        if((oldrot.Rot_Housing_Module_D__c!=rot.Rot_Housing_Module_D__c&& rot.Rot_Housing_Module_D__c!=null)
            || (oldrot.Rot_Housing_Module_E__c!=rot.Rot_Housing_Module_E__c&& rot.Rot_Housing_Module_E__c!=null)){
            rotlst.add(rot);
            ids.add(rot.Student__c);
        }
    }
    if(!rotmap.isEmpty() || !rotlst.isEmpty()){
        Map<String,String> visa_trak=new Map<String,String>();
        Map<String,String> varmap=new Map<String,String>();
        Map<String,String> varmap1=new Map<String,String>();
        List<Opportunity_Finance__c> updtfin=new List<Opportunity_Finance__c>();
        List<Opportunity_Finance__c> fin=[Select id,Rot_Visa_Module_D__c,Rot_Visa_Module_E__c,Opportunity__r.Contact__c
                                           ,Rot_Housing_Module_D__c,Rot_Housing_Module_E__c
                                           from Opportunity_Finance__c where Opportunity__r.Contact__c in:ids];
        List<Visa_Track__c> visatrac=[Select id,Name from Visa_Track__c where id in:rotmap.values()];
        for(Visa_Track__c vt:visatrac){
            visa_trak.put(vt.id,vt.Name);
        }
        
        Map<String,String> modd_map=new Map<String,String>();
        modd_map.put('China: X-2 Visa','SHA - Visa - JW-202');
        modd_map.put('UAE: Visitor Visa','DUB - Visa - Visit');
        modd_map.put('UAE: Student Residence','DUB - Visa - Residence');
        modd_map.put('UAE: EMBA Transit Visa','DUB - Visa - Transit');
        modd_map.put('UAE: Visitor Visa 3 month','Dubai - UAE Visit Visa (3 month) - Mod D');
        modd_map.put('UAE: Visitor Visa 30 day','Dubai - UAE Visit Visa (1 month) - Mod D');
        
        Map<String,String> mode_map=new Map<String,String>();
        mode_map.put('China: X-2 Visa','SHA - Visa - JW-202');
        mode_map.put('UAE: Visitor Visa','DUB - Visa - Visit');
        mode_map.put('UAE: Student Residence','DUB - Visa - Residence');
        mode_map.put('UAE: EMBA Transit Visa','DUB - Visa - Transit');
        mode_map.put('UAE: Visitor Visa 3 month','Dubai - Visit Visa (1 month) - Mod E');
        mode_map.put('UAE: Visitor Visa 30 day','Dubai - Visit Visa (3 months) - Mod E');
        
        for(Rotation__c rr:rotmap.Keyset()){
            if(modd_map.containsKey(visa_trak.get(rr.Visa_Track__c))){
                varmap.put(rr.Student__c,visa_trak.get(rr.Visa_Track__c));
                varmap1.put(rr.Student__c,rr.Type__c);
            }
        }
        if(!varmap.isEmpty() || !rotlst.isEmpty()){
            try{                        
            for(Opportunity_Finance__c opf:fin){
                if(!varmap.isEmpty()){
                    if(varmap1.get(opf.Opportunity__r.Contact__c)=='Mod D' || varmap1.get(opf.Opportunity__r.Contact__c)=='Mod D & E'){
                        if(modd_map.containsKey(varmap.get(opf.Opportunity__r.Contact__c))){
                            opf.Rot_Visa_Module_D__c=modd_map.get(varmap.get(opf.Opportunity__r.Contact__c));
                        }
                    }
                    if(varmap1.get(opf.Opportunity__r.Contact__c)=='Mod E'){
                        if(mode_map.containsKey(varmap.get(opf.Opportunity__r.Contact__c))){
                            opf.Rot_Visa_Module_E__c=mode_map.get(varmap.get(opf.Opportunity__r.Contact__c));
                        }
                    }
                }
                if(!rotlst.isEmpty()){
                    for(Rotation__c rtl:rotlst){
                        if(rtl.Student__c==opf.Opportunity__r.Contact__c){
                            if(rtl.Rot_Housing_Module_D__c!=null)
                                opf.Rot_Housing_Module_D__c=rtl.Rot_Housing_Module_D__c;
                            if(rtl.Rot_Housing_Module_E__c!=null)
                                opf.Rot_Housing_Module_E__c=rtl.Rot_Housing_Module_E__c;
                        }
                    }
                }
                updtfin.add(opf);
            }
            Update updtfin;
            }
            Catch(Exception e){System.Debug(e);}
        }
        
    }
}