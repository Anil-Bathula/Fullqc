/****************************
  Trigger   : SATgrouping
  Developer : Anil.B
  Date      : 24/10/2014  
  Comment   : To update the field SAT_Grouping__c with the concerned value based on field  Undergraduate_Major__c.
  Testclass : SATgrouping_Test(100%)
*****************************/
trigger SATgrouping on Lead (before insert,before update) {

    for(lead ld:trigger.new){
        Lead oldld=Trigger.Isinsert?new lead():trigger.oldmap.get(ld.id);
        
        Map<String,String>sst=new Map<String,String>();
        
        for(SATgrouping__c s:SATgrouping__c.getAll().values()){
            sst.put(s.SAT_grouping_name__c,s.SAT_grouping_value__c);
        }
       
        if(ld.Leadsource=='SAT'){
            if(ld.Undergraduate_Major__c!=oldld.Undergraduate_Major__c)
            {     
              
                    if(ld.Undergraduate_Major__c!=NULL && sst.containskey(ld.Undergraduate_Major__c.tolowercase()))
                    {
                        ld.SAT_Grouping__c=sst.get(ld.Undergraduate_Major__c.tolowercase());
                    } 
                    else
                    {
                        ld.SAT_Grouping__c='General';
                    }
            }
        }else{
             ld.SAT_Grouping__c='General';
        }
    }
}