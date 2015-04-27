/*
      Developer : Premanath Reddy
      Date      : 11/03/2014                
      purpose   : This trigger connects a few Finance fields with Fee object fields,it run every time any of these new fields is UPDATED.
                  
      Test class: mapping_Finwithfee_test
      coverage  : 100%
      
      Modified : 20/3/2014  prem :: connects BBA Finanace Record type fields with Fee And calling the mapping_Finwithfeevalues class for field mapping.
      Modified :Prem : SFSUP-772
      Modified : 07/11/2014 - Prem :: SFSUP-779
      Modified : 17/02/2015 - Prem :: SFSUP-970
*/         

trigger conect_finwithfee on Opportunity_Finance__c (before update,after insert,after update) {
if(trigger.isbefore){
    list<ID> finids=new list<ID>();
    list<ID> feeids=new list<ID>();
    map<string,string> hous_accm=new map<string,string>();
    map<string,string> rot_item=new map<string,string>();
    String bba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');
    String nonbba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance');
    Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Fees__c').getDescribe().fields.getMap();
    Map<String,string> feelables=new Map<String,string>();
    list<id> bba_fieldmap_fins=new list<id>();
    for(Opportunity_Finance__c fin:Trigger.new){
        if(fin.fees__c!=null ){
            Opportunity_Finance__c oldfin=trigger.Isinsert?new Opportunity_Finance__c():Trigger.oldmap.get(fin.id);
            //If Program is Non BBA then Connecting Non-BBA finance with Fee
            if(!fin.OP_Program__c.startsWith('Bachelor') &&
                (oldfin.Housing_Accommodation__c!=fin.Housing_Accommodation__c 
                || oldfin.Accommodation_weeks__c!=fin.Accommodation_weeks__c
                || oldfin.Rot_Housing_Module_D__c!=fin.Rot_Housing_Module_D__c 
                || oldfin.Rot_Visa_Module_D__c!=fin.Rot_Visa_Module_D__c
                || oldfin.Rot_Insurance_Module_D__c!=fin.Rot_Insurance_Module_D__c
                || oldfin.Rot_Housing_Module_E__c!=fin.Rot_Housing_Module_E__c
                || oldfin.Rot_Visa_Module_E__c!=fin.Rot_Visa_Module_E__c
                || oldfin.Rot_Insurance_Module_E__c!=fin.Rot_Insurance_Module_E__c
                || oldfin.fees__c!=fin.fees__c
                ||(fin.Housing_Accommodation__c !=null && fin.Annual_Accommodation_Fee__c==null) 
                ||(fin.Rot_Housing_Module_D__c !=null && fin.Rot_Housing_Mod_D_Fee__c==null)
                ||(fin.Rot_Visa_Module_D__c !=null && fin.Rot_Visa_Mod_D_Fee__c==null)
                ||(fin.Rot_Insurance_Module_D__c !=null && fin.Rot_Insurance_Mod_D_Fee__c==null)
                ||(fin.Rot_Housing_Module_E__c !=null && fin.Rot_Housing_Mod_E_Fee__c==null)
                ||(fin.Rot_Visa_Module_E__c !=null && fin.Rot_Visa_Mod_E_Fee__c==null)
                ||(fin.Rot_Insurance_Module_E__c  !=null && fin.Rot_Insurance_Mod_E_Fee__c==null)
                || mapping_Finwithfeevalues.isnon_biba_dependentvalues_changed(oldfin,fin)))
            {                    
                finids.add(fin.id);
                feeids.add(fin.fees__c);
            }
            //If Program Starts with Bachelor then Connecting BBA finance with Fee
            if(fin.OP_Program__c.startsWith('Bachelor')){
                if(oldfin.BBA_Insurance_Picklist_Year_1__c!=fin.BBA_Insurance_Picklist_Year_1__c || 
                    oldfin.BBA_Insurance_Picklist_Year_2__c!=fin.BBA_Insurance_Picklist_Year_2__c ||
                    oldfin.BBA_Insurance_Picklist_Year_3__c!=fin.BBA_Insurance_Picklist_Year_3__c ||
                    oldfin.BBA_Insurance_Picklist_Year_4__c!=fin.BBA_Insurance_Picklist_Year_4__c ||
                    
                    oldfin.BBA_Installment_Plan_Picklist__c!=fin.BBA_Installment_Plan_Picklist__c|| 
                    oldfin.BBA_Installment_Plan_Picklist_Year_2__c!=fin.BBA_Installment_Plan_Picklist_Year_2__c||
                    oldfin.BBA_Installment_Plan_Picklist_Year_3__c!=fin.BBA_Installment_Plan_Picklist_Year_3__c||
                    oldfin.BBA_Installment_Plan_Picklist_Year_4__c!=fin.BBA_Installment_Plan_Picklist_Year_4__c ||
                    
                    oldfin.BBA_Accommodation_Year_1__c!=fin.BBA_Accommodation_Year_1__c|| 
                    oldfin.BBA_Accommodation_Weeks_Year_1__c!=fin.BBA_Accommodation_Weeks_Year_1__c||
                    oldfin.BBA_Accommodation_Year_2__c!=fin.BBA_Accommodation_Year_2__c||
                    oldfin.BBA_Accommodation_Weeks_Year_2__c!=fin.BBA_Accommodation_Weeks_Year_2__c||
                    oldfin.BBA_Accommodation_Year_3__c!=fin.BBA_Accommodation_Year_3__c|| 
                    oldfin.BBA_Accommodation_Weeks_Year_3__c!=fin.BBA_Accommodation_Weeks_Year_3__c||
                    oldfin.BBA_Accommodation_Year_4__c!=fin.BBA_Accommodation_Year_4__c||
                    oldfin.BBA_Accommodation_Weeks_Year_4__c!=fin.BBA_Accommodation_Weeks_Year_4__c ||
                    
                    oldfin.fees__c!=fin.fees__c ||
                    oldfin.God_Lever_BBA__c!=fin.God_Lever_BBA__c ||
                    mapping_Finwithfeevalues.isbiba_dependentvalues_changed(oldfin,fin) ||
                    (oldfin.RecordTypeId==nonbba_rectype && fin.RecordTypeId==bba_rectype))
                {
                    feeids.add(fin.fees__c);
                    bba_fieldmap_fins.add(fin.id);
                }
            }
        }
        
    }
    if(!feeids.isempty()){
        String theQuery = 'SELECT ';
        for(Schema.SObjectField s : fieldMap.values()){
           String theName = s.getDescribe().getName();
           theQuery += theName + ',';
           feelables.put(s.getDescribe().getLabel().tolowercase(),s.getDescribe().getName());
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1);
        theQuery += ' from Fees__c where ID In: feeids';
        //dynamic call
        List<Fees__c> feefieldmap= Database.query(theQuery);

        Map<ID,Fees__c> fees=new Map<ID,Fees__c>();
        fees.putAll(feefieldmap);
        /*shs :: bba field map code*/
        if(!bba_fieldmap_fins.IsEmpty()) 
        { 
           for(id fins:bba_fieldmap_fins)
           {
               Opportunity_Finance__c new_fin=trigger.newMap.get(fins);
               if(fees.containskey(new_fin.Fees__c))
               {
                   mapping_Finwithfeevalues.biba_method(fees.get(new_fin.Fees__c),new_fin,feelables);
               }
           }
        }
        /*end of bba field map code*/
        //Non-BBA field mapping
        for(ID fid: finids){
            Opportunity_Finance__c old_fin=trigger.Isinsert?new Opportunity_Finance__c():Trigger.oldmap.get(fid);
            Opportunity_Finance__c new_fin=Trigger.newmap.get(fid);
            Fees__c fee=new Fees__c();
            fee=fees.get(new_fin.fees__c);
            mapping_Finwithfeevalues.non_biba_method(fee,new_fin,feelables);
        }
        
    }
}
    if(trigger.isafter)
    {
        list<Opportunity_Finance__c > updfins=new list<Opportunity_Finance__c>();
        for(Opportunity_Finance__c fin:Trigger.new)
        {
            Opportunity_Finance__c oldfin=trigger.isinsert?new Opportunity_Finance__c():trigger.oldmap.get(fin.id);
            if(fin.Fees__c!=null && oldfin.Fees__c==null)
            {
                updfins.add(fin);
            }
        }
        if(!updfins.IsEmpty())
        {
            try{
                update updfins;
                }
                catch(Exception e){system.debug(e);}
        }
    }
}