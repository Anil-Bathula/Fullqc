trigger Assessment_replicate on Assessment_un__c (after insert,after update) {
    
    if(trigger.isafter && trigger.isinsert){
       Assessment_replicatehelper.createAssessment(trigger.new);
    }
    
     if(trigger.isafter && trigger.isupdate){
       Assessment_replicatehelper.updateassesment(trigger.new);
    }

}