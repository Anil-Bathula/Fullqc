trigger Accommodation_mapping on Opportunity_Finance__c (before insert,before update){
    list<ID> finids=new list<ID>();
    list<ID> feeids=new list<ID>();
    List<Opportunity_Finance__c> finlst=new List<Opportunity_Finance__c>();
    Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Fees__c').getDescribe().fields.getMap();
    Map<String,string> feelables=new Map<String,string>();
    String non_biba=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance');
    String hous_ext=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Housing External Finance');
    
    list<id> bba_fieldmap_fins=new list<id>();
    for(Opportunity_Finance__c fin:Trigger.new){
        if(fin.fees__c!=null ){
            Opportunity_Finance__c oldfin=trigger.Isinsert?new Opportunity_Finance__c():Trigger.oldmap.get(fin.id);
            if((fin.RecordTypeId==non_biba || fin.RecordTypeId==hous_ext) &&
                (oldfin.Housing_Accommodation__c!=fin.Housing_Accommodation__c 
                || oldfin.Accommodation_weeks__c!=fin.Accommodation_weeks__c
                || oldfin.fees__c!=fin.fees__c
                ||(fin.Housing_Accommodation__c !=null && fin.Accommodation_weeks__c!=null && fin.Annual_Accommodation_Fee__c==null)))
            {                    
                finlst.add(fin);
                feeids.add(fin.fees__c);
            }
        }
    }
    if(!feeids.isempty()){
        try{
            String theQuery = 'SELECT ';
            for(Schema.SObjectField s : fieldMap.values()){
               String theName = s.getDescribe().getName();
               theQuery += theName + ',';
            }
            
            theQuery = theQuery.subString(0, theQuery.length() - 1);
            theQuery += ' FROM Fees__c where id in: feeids';
            //dynamic call
            List<Fees__c> feefieldmap= Database.query(theQuery);
    
            Map<ID,Fees__c> fees=new Map<ID,Fees__c>();
            fees.putAll(feefieldmap);
            
            for(Opportunity_Finance__c f: finlst){
                if(f.Housing_Accommodation__c==null || f.Accommodation_weeks__c==null){
                    f.Annual_Accommodation_Fee__c=null;
                    return;
                }
                String hous_accm=f.Housing_Accommodation__c;
                integer  accm_weeks=Integer.valueOf(f.Accommodation_weeks__c);
                String housing;
                if(accm_weeks>=1 && accm_weeks<=42){
                    housing=hous_accm+' P1';
                }
                else if(accm_weeks>=43 && accm_weeks<=50){
                    housing=hous_accm+' P2';
                }
                else if(accm_weeks>=51 && accm_weeks<=52){
                    housing=hous_accm+' P3';
                }
                
                for(Schema.SObjectField sfield : fieldMap.Values()){
                    schema.describefieldresult dfield = sfield.getDescribe();
                    if(String.valueOf(dfield.getType())!='TEXTAREA'){
                        feelables.put(dfield.getLabel().tolowercase(),dfield.getname());
                    }
                }
                housing=housing.tolowercase();
                if(feelables.containsKey(housing)){
                    sObject fe=fees.get(f.Fees__c);
                    
                    if(fe.get(feelables.get(housing))!=null){
                        f.Annual_Accommodation_Fee__c=Integer.valueOf(fe.get(feelables.get(housing)))*accm_weeks;
                    }
                    else{
                        f.Annual_Accommodation_Fee__c=null;
                    }
                    //System.Debug(feelables.get(housing)+'*****************'+fe.get(feelables.get(housing)));
                }
                else{
                    f.Annual_Accommodation_Fee__c=null;
                }
                
            }
        }
        catch(Exception e){}
    }
    
    
}