trigger Education_2_opportunity on Education__c (after insert, after update) 
{
    /*      
        Trigger   : Education_2_opportunity             
        Developer : Harsha Simha S
        Date      : 04/04/2013
        Comment   : update Education Converted_GPA__c in Opportunity Undergrad_Validated_GPA__c field. 
                    when AAm_validated under Education is true.     
        Test Class: validation_AAM_Test(84%)    
    
    */
    Map<string,Education__c> edumaps=new map<String,Education__c>();
    for(Education__C ed:Trigger.New)
    {
        if(Trigger.isInsert && ed.AAM_Validated__c)
        {//Education__c.
            edumaps.put(ed.Application__c,ed);
        }
        if(Trigger.isUpdate && ed.AAM_Validated__c && ed.AAM_Validated__c!=Trigger.oldMap.get(ed.Id).AAM_Validated__c)
        {
            edumaps.put(ed.Application__c,ed);
        }
    }
    if(!edumaps.keySet().isEmpty())
    {
        List<Opportunity> eduopps=[select id,Name,Undergrad_Validated_GPA__c from Opportunity where id IN: edumaps.keySet() ];
        for(integer i=0;i<eduopps.size();i++)
        {
            eduopps[i].Undergrad_Validated_GPA__c=edumaps.get(eduopps[i].id).Converted_GPA__c;
        }
        try
        {           
            update eduopps;
        }
        catch(Exception e)
        {
            system.debug(e);
        }
    }
}