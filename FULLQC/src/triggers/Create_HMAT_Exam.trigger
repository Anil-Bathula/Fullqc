trigger Create_HMAT_Exam on Opportunity (after update) {
    
    Set <id>opid=new Set<id>();
    
    
    if(staticFlag.Opp_Activity_hist){
        staticFlag.Opp_Activity_hist = false;
        for(opportunity op:trigger.new){
        
             if(!RecordTypeHelper.isapplicationprocessrecordtype(op.RecordTypeId))
             continue;
             
             Opportunity old_opp=Trigger.isinsert?new Opportunity():Trigger.oldMap.get(op.Id);  
                   
             if(old_opp.StageName!=op.StageName && op.StageName=='In Progress' && op.Validated_Adm_Test_Score_GMAT_Eq__c==NULL){
                  opid.add(op.id);
                  System.debug('****->'+op.id);
             }
        }
    }
    
    System.debug('====>'+opid.size());
    if(!opid.isEmpty()){
        List<Exam__c>lst_exm=new list<Exam__c>();
        for(id oid:opid){
            exam__c e=new exam__c();
            e.Exam_Type__c='HMAT';
            e.HMAT_Status__c='HMAT Invited';
            e.Application__c=oid;
            lst_Exm.add(e);
        }
        
        insert lst_Exm;
    }

}