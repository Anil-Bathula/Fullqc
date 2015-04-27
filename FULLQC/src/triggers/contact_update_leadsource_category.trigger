/*
    Trigger   : contact_update_leadsource_category
    Events    : Before Insert and Update on Contact
    Developer : Harsha Simha S
    Date      : 10/31/2012
    Comment   : Updates Field Lead_source_category__c based on the value in the 
                Leadsource field (value extracted from the Lead_source__c object)
    
    Changes   : Harsa 12/3/'13
                set leadsource category as other if lead source is null(so remve checking leadsource !=null and add condition to set leadsourcecategory as other is source is null.)
    Test Class: Lead_ChangeTaskOwnersTest.cls(100%) 
    
    Changes   : Harsa 2/9/2013
                Added condition to check Contact is of Applicant Recordtype.
              
    Modified  : Harsha 1/July/2014 SFSUP-746        
    
    Changes   : Harsha 17/9/2014
                Set lead source and lead source category as other if Lead source is not found. SFSUP-768  
                
    Add ons   : Harsha 1/27/'15
                SFSUP-952   
                set LBRd Once field to false   
                
    Modified by :Anil.B on 6/feb/15 Added condition program changed and program parsed 
    is changed then update LBRd Once field to false                   
*/
trigger contact_update_leadsource_category on Contact (before insert, before update) 
{

    set<String> ctctid=new set<String>();
    List<String> leadsource=new List<String>();
   // string Recid=RecordTypeHelper.getRecordTypeId('Contact', 'Applicant');
    for(Contact c: Trigger.new)
    { 
        
        //if(c.RecordTypeId!=Recid)
        if(!RecordTypeHelper.isapplicationprocessrecordtype(c.RecordTypeId))
            continue;
        if(Trigger.isInsert)
        {system.debug('--------'+c.Id);
            ctctid.add(c.Id);
            if(c.LeadSource!=null)
            {
                leadsource.add(c.LeadSource);
            }
        }
        if(Trigger.isUpdate && ((c.LeadSource!=Trigger.oldMap.get(c.Id).LeadSource) || c.Lead_Source_Category__c==null ))
        {
            ctctid.add(c.Id);
            if(c.LeadSource!=null)
                leadsource.add(c.LeadSource);
        }
        
        /*Start : SFSUP-952 */
        
        if(Trigger.isUpdate && ((c.Country_Of_Residence__c!=Trigger.oldMap.get(c.Id).Country_Of_Residence__c) || 
        (c.Program_Primary__c!=Trigger.oldMap.get(c.Id).Program_Primary__c && c.Program_Parsed__C!=Trigger.oldMap.get(c.Id).Program_Parsed__c)))
        {           
            c.LBR_d_once__c=false;
        } 
        /*End : SFSUP-952 */
        
    }
    if(!ctctid.IsEmpty())
    {
        List<Lead_Source__c> lscat=[select id,Name,Weighting__c,Valid_Lead_Source__c,Valid_Lead_Source__r.Name,Valid_Lead_Source__r.Lead_Source_Category__c,Lead_Source_Category__r.Name from Lead_Source__c where Name IN:leadsource ];
        List<Lead_Source_Category__c> oth_lscat=[select id,Name from Lead_Source_Category__c where Name='Other'];//SFSUP-768
        if(!lscat.IsEmpty()|| !oth_lscat.IsEmpty())
        {
            Map<string,Lead_Source__c> ledsrcs=new Map<String,Lead_Source__c>();            
            for(Lead_Source__C ls:lscat)
            {
                ledsrcs.put(ls.Name.toUpperCase(),ls);              
            }
            
            for(Contact c:Trigger.new)
            {   
                if((Trigger.isInsert && c.LeadSource!=null) || (Trigger.isUpdate && ((c.LeadSource!=Trigger.oldMap.get(c.Id).LeadSource) || c.Lead_Source_Category__c==null )))
                {
                    if((c.LeadSource!=null && ledsrcs.ContainsKey(c.LeadSource.toUpperCase()) ))
                    {
                    /*
                        Changes: 26/3/2013 by SHS 
                        Added logic to check if there is value in 'Valid lead source' field, 
                        if there then set contact leadsource to valid lead source and leadsource category with approporiate value.
                                
                                2/4/2013 by SHS
                        Added logic to consider case insesitive for the Lead source value and Lead source object name comparision.
                    */
                        string ledsrc=c.LeadSource;
                        if(ledsrcs.get(c.LeadSource.toUpperCase()).Valid_Lead_Source__c==null)
                        {
                            c.Lead_Source_Category__c=ledsrcs.get(c.LeadSource.toUpperCase()).Lead_Source_Category__c;
                        }
                        else 
                        {
                            if(ledsrcs.get(c.LeadSource.toUpperCase()).Valid_Lead_Source__c!=null){
                                c.LeadSource=ledsrcs.get(ledsrc.toUpperCase()).Valid_Lead_Source__r.Name;
                                c.Lead_Source_Category__c=ledsrcs.get(ledsrc.toUpperCase()).Valid_Lead_Source__r.Lead_Source_Category__c;                   
                            }
                            else
                            {
                                c.Lead_Source_Category__c=oth_lscat[0].Id;
                            }
                        }
                    }
                    else if(!oth_lscat.IsEmpty() && c.LeadSource!=null)
                    {
                        try{//TO TEST THE REASON FOR THE ISSUE
                        c.Description+=';'+c.LeadSource+'---'+ctctid;
                        
                        if(c.Description!=null && c.Description.length()>=32000)
                            c.Description=c.Description.substring(0,31998);
                        }catch(Exception e){System.debug(e);}
                        
                        c.Lead_Source_Category__c=oth_lscat[0].Id;
                        c.LeadSource='Other';//SFSUP-768
                    }
                }
            }
        }   
    }
}