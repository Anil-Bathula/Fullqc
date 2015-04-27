/*
Author          : Premanath Reddy
created Date    : 11/14/2012    
Purpouse        : Updates the field ‘Stage__c’ in the contact object, when the field ‘StageName’ is changed in the relevant opportunity.

*/

trigger updatestage on Opportunity (after update) {

    List<id> oppids=new List<id>();
    List<id> conids=new List<id>();
    Map<id,String> varmap=new Map<id,String>();
    for(Opportunity opp:Trigger.New){
        if(Trigger.NewMap.get(opp.id).StageName!=Trigger.oldMap.get(opp.id).StageName){
            oppids.add(opp.id);
            conids.add(opp.Contact__c);
            varmap.put(opp.Contact__c,opp.StageName);
        }
    }
    if(!oppids.isEmpty()){
        List<contact> con=new List<contact>();
        List<contact> varcon=[select id,name,Stage__c from Contact where id in:conids];
        for(contact c:varcon){    
            c.Stage__c=varmap.get(c.id);
            con.add(c);
        }
        update con;

    }
}