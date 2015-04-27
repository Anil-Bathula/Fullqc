/*
    Trigger   : Lead_update_leadsource_category
    Events    : Before Insert and Update on Lead
    Developer : Harsha Simha S
    Date      : 10/29/2012 
    Test Class :(Lead_ChangeTaskOwnersTest -75%);
    Comment   : SFSUP-768 for lead
                Updates Field Lead_source_category__c based on the value in the 
                Leadsource field (value extracted from the Lead_source__c object)
                
    Changes   : Harsha 10/29/'14
                SFSUP-774   
                set Primaryleadsource category as the First LeadSource value 
                
    Add ons   : Harsha 1/27/'15
                SFSUP-952   
                set LBRd Once field to false   
    Modified by :Anil.B on 6/feb/15 Added condition program changed and program parsed 
    is changed then update LBRd Once field to false          
            
*/
trigger Lead_Update_LeadSource_Category on Lead (before insert, before update) 
{
    
    List<String> leadsource=new List<String>();
   
    for(Lead l: Trigger.new)
    { 
        if(Trigger.isInsert)
        {   
            if(l.LeadSource!=null)
            {
                leadsource.add(l.LeadSource);
            }
        }
        if(Trigger.isUpdate && ((l.LeadSource!=Trigger.oldMap.get(l.Id).LeadSource) || l.Lead_Source_Category_lu__c==null ))
        {           
            if(l.LeadSource!=null)
                leadsource.add(l.LeadSource);
        }
        
        /*Start : SFSUP-952 */
        if(Trigger.isUpdate && ((l.Country_Of_Residence__c!=Trigger.oldMap.get(l.Id).Country_Of_Residence__c) || 
            (l.Program_Primary__c!=Trigger.oldMap.get(l.Id).Program_Primary__c && l.Program_Parsed__C!=Trigger.oldMap.get(l.Id).Program_Parsed__c)))
        {           
            l.LBR_d_once__c=false;
        }
       
        /*End : SFSUP-952 */
    }
    if(!leadsource.IsEmpty())
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
            
            for(Lead l:Trigger.new)
            {   if((Trigger.isInsert && l.LeadSource!=null) || (Trigger.isUpdate && ((l.LeadSource!=Trigger.oldMap.get(l.Id).LeadSource) || l.Lead_Source_Category_lu__c==null ))) 
                {
                    if((l.LeadSource!=null && ledsrcs.ContainsKey(l.LeadSource.toUpperCase()) ))
                    {                
                        string ledsrc=l.LeadSource;
                        if(ledsrcs.get(l.LeadSource.toUpperCase()).Valid_Lead_Source__c==null)
                        {
                            
                            if(Trigger.isinsert ||(Trigger.isUpdate&&Trigger.oldMap.get(l.Id).LeadSource==null))
                                l.First_Touch_Point_Source__c=l.LeadSource; //SFSUP-774                         
                            
                            l.Lead_Source_Category_lu__c=ledsrcs.get(l.LeadSource.toUpperCase()).Lead_Source_Category__c;
                        }
                        else 
                        {
                            if(ledsrcs.get(l.LeadSource.toUpperCase()).Valid_Lead_Source__c!=null)
                            {
                                if(Trigger.isinsert ||(Trigger.isUpdate&&Trigger.oldMap.get(l.Id).LeadSource==null))
                                    l.First_Touch_Point_Source__c=l.LeadSource;//SFSUP-774
                                    
                                l.LeadSource=ledsrcs.get(ledsrc.toUpperCase()).Valid_Lead_Source__r.Name;
                                l.Lead_Source_Category_lu__c=ledsrcs.get(ledsrc.toUpperCase()).Valid_Lead_Source__r.Lead_Source_Category__c; 
                            }
                            else
                            {
                                if(Trigger.isinsert ||(Trigger.isUpdate&&Trigger.oldMap.get(l.Id).LeadSource==null))
                                    l.First_Touch_Point_Source__c=l.LeadSource;//SFSUP-774
                                l.Lead_Source_Category_lu__c=oth_lscat[0].Id;
                            }
                        }
                    }
                    else if(!oth_lscat.IsEmpty() && l.LeadSource!=null)
                    {
                        if(Trigger.isinsert ||(Trigger.isUpdate&&Trigger.oldMap.get(l.Id).LeadSource==null))
                            l.First_Touch_Point_Source__c=l.LeadSource;//SFSUP-774
                        l.Lead_Source_Category_lu__c=oth_lscat[0].Id;
                        l.LeadSource='Other';
                    }
                }
            }
        }   
    }
}