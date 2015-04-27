/**********************************************************************************************
Trigger    : AAM_Team_Memeber
Written By : Anil.B
Purpose    : To update the requirements which are linked with
 opportunity when the stage high level=partial and AAm team memeber!=Null
 Instead of writining two triggers on both the objects we made one trigger in opportunity and 
 a work flow in requiremnts object to Update AAM_Team_Memeber email field
 Changes by SHS on 7/4/2014 for SFSUP-745
 ***********************************************************************************************/
trigger AAM_Team_Memeber on Opportunity (after update) {
    
 List<Requirement__c> LstReq = new list<Requirement__c>();
 set<id>oppids = new set<id>();
 
    For(Opportunity o:trigger.new){
    	if(!RecordTypeHelper.isapplicationprocessrecordtype(o.Recordtypeid))//SFSUP-745
    		continue;
    		
     System.debug('********1****>>>'+o.Stage_HighLevel__c);
         if(trigger.oldmap.get(o.id).Stage_HighLevel__c!=o.Stage_HighLevel__c || trigger.oldmap.get(o.id).AAM_Team_Member__c!=o.AAM_Team_Member__c &&
            (o.AAM_Team_Member__c!=Null && o.Stage_HighLevel__c=='Partial')){
            System.debug('************>>>'+o.Stage_HighLevel__c);
             oppids.add(o.id);
         }
    }
    if(!oppids.IsEmpty()){
        List<Requirement__c> reqs=[select id,name from Requirement__c where opportunity__c IN:oppids];
            if(!reqs.isempty())
            {
                  try{
                      update reqs;
                  }catch(Exception e){
                      System.debug('An error occured'+e.getmessage());
                  }
            }
    }
}