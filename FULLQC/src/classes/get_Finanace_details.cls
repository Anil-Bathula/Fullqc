global class get_Finanace_details 
{
    webService static Opportunity_Finance__c getfins(String contactid) 
    {
        
        Opportunity_Finance__c opf=new Opportunity_Finance__c();
        try{
        	opf=[select id,Name,Accommodation_weeks__c,Rot_Visa_Module_D__c,Rot_Housing_Mod_D_Fee__c,Rot_Visa_Mod_D_Fee__c,Rot_Insurance_Mod_D_Fee__c,Rot_Housing_Mod_E_Fee__c,Rot_Visa_Mod_E_Fee__c,Rot_Insurance_Mod_E_Fee__c,
                        Rot_Visa_Module_E__c,currencyisoCode,Rot_Housing_Module_D__c,Rot_Housing_Module_E__c,Rot_Insurance_Module_D__c,Rot_Insurance_Module_E__c from Opportunity_Finance__c where Opportunity__r.Contact__c=:contactid];
        }
        catch(Exception e){System.debug(e);}
        return opf;
        
    } 
    
    webService static string update_fins(String contactid,string modd_housing,string mode_housing,string modd_insurance,string mode_insurance) 
    {
        string ret='error';
        list<Opportunity_Finance__c> opf=[select id,Name,Rot_Housing_Mod_D_Fee__c,Rot_Visa_Mod_D_Fee__c,Accommodation_weeks__c,
        Rot_Housing_Module_D__c,Rot_Housing_Module_E__c,Rot_Insurance_Module_D__c,Rot_Insurance_Module_E__c from Opportunity_Finance__c where Opportunity__r.Contact__c=:contactid];
        if(!opf.IsEmpty())
        {
            boolean temp=false;
            if(modd_housing!=null)
            {
                opf[0].Rot_Housing_Module_D__c=modd_housing;
                temp=true;
            }
            if(mode_housing!=null)
            {
                opf[0].Rot_Housing_Module_E__c=mode_housing;
                    temp=true;
            }
            if(modd_insurance!=null)
            {
                opf[0].Rot_Insurance_Module_D__c=modd_insurance;
                    temp=true;
            }
            if(mode_insurance!=null)
            {
                opf[0].Rot_Insurance_Module_E__c=mode_insurance;
                temp=true;
            }
            
            if(temp)
            {               
                try{
                    update opf[0];
                    ret='success';
                }
                catch(Exception e)
                {
                    ret+=' : '+e;
                }
            }
        }
        else
        {
            ret+=' : No Finance record exist for this contact.';
        }
        return ret;
        
    }
    
}