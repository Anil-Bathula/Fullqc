/*
Author          : Premanath Reddy
created Date    : 06/06/2014
Purpouse        : when a campaign is created OR edited, AND Camapain.city__c (lookup field) is populated.
                  Trigger should: assign the City.Country__c to the Campaign.Country__c lookup field,
                  regardless of if the Campaign.Country__c field is populated or not.
Test class      : updt_cntry_test (100% code coverage)
*/
trigger updt_cntry on Campaign (before insert,before update) {
    Map<Campaign,Id> cityids=new Map<Campaign,Id>();
    Map<Id,Id> cuntryids=new Map<Id,Id>();
    for(Campaign camp:Trigger.New){
        Campaign oldcamp=Trigger.Isinsert?new Campaign():trigger.oldmap.get(camp.id);
        if(camp.City__c!=oldcamp.City__c){
            cityids.put(camp,camp.City__c);
        }
    }
    if(!cityids.isEmpty()){
        List<City__c> citylst=[Select id,Name,Country__c from City__c where id in:cityids.values()];
        if(!citylst.isEmpty()){
            for(City__c c:citylst){
                cuntryids.put(c.id,c.Country__c);
            }
            if(!cuntryids.isEmpty()){
                for(Campaign cam:cityids.keyset()){
                    if(cuntryids.containsKey(cam.City__c)){
                        cam.Country__c=cuntryids.get(cam.City__c);
                    }
                }
            }
        }
    }
}