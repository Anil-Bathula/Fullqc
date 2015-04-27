/*
    Developer : Premanath Reddy
    Date      : 08/08/2014                
    purpose   : SFSUP-762 - This trigger use for when a value is selected in "installment plan" field of finance 
            record, get the "Installment Plan Multiplier Values" record (from one of these fees fields 
            "No Installment Plan", "Installment Plan", "Installment Plan Flex", "No Flexi plan", "Flexiplan")
            based on the Installment plan value.          
*/ 
trigger connct_instalmentplan on Opportunity_Finance__c (before update) 
{
    map<string,string> Fin_n_its_feeid=new map<string,string>();
    map<string,string> Fin_n_its_instid=new map<string,string>();
    for(Opportunity_Finance__c opf:Trigger.new)
    {
        boolean istrue=mapping_Finwithfeevalues.check_installmentplan_trigger_conditions(opf,Trigger.OldMap.get(opf.Id));
        if(opf.Installment_Plan__c!=null && opf.Fees__c!=null && istrue)
        {
            if(opf.Program__c.Startswith('Bachelor'))
            {
                String godlever=opf.God_Lever_BBA__c==null?'':opf.God_Lever_BBA__c;
                if(!(godlever.contains('Year 1') && godlever.contains('Year 2') && godlever.contains('Year 3') && godlever.contains('Year 4')))
                {
                    Fin_n_its_feeid.put(opf.Id,opf.Fees__c);
                    
                }
            }
            else
            {   
                if(!opf.God_Lever__c)
                {
                    Fin_n_its_feeid.put(opf.Id,opf.Fees__c);
                }
            }
        }
    }    
    if(!Fin_n_its_feeid.IsEmpty())
    {
        map<id,Fees__c> fee_map=new map<id,Fees__c>([select id,Name,No_Installment_Plan__c,No_FlexiPlan__c,Installment_Plan__c,Installment_Plan_Flex__c,
                                                    FlexiPlan__c,Program_Start_Date__c,Program_Start_Date_Year_2__c,Program_Start_Date_Year_3__c,
                                                     Program_Start_Date_Year_4__c,Installment_Plan_fee__c,
                                                    Installment_Plan_Flex_Fee__c from Fees__c where id IN:Fin_n_its_feeid.values()]);
        if(!fee_map.Isempty())
        {
            for(string finid:Fin_n_its_feeid.Keyset())
            {
                Opportunity_Finance__c opf=Trigger.newMap.get(finid);
                Fees__c fee=fee_map.get(opf.Fees__c);
                if(opf.Installment_Plan__c=='No Installment Plan')// && fee.No_Installment_Plan__c!=null)
                {
                    Fin_n_its_instid.put(opf.Id,fee.No_Installment_Plan__c);
                    //instalment_plan.add(fee.No_Installment_Plan__c);
                }
                if(opf.Installment_Plan__c=='Installment Plan')// && fee.Installment_Plan__c!=null)
                {
                    Fin_n_its_instid.put(opf.id,fee.Installment_Plan__c);
                    //instalment_plan.add(fee.Installment_Plan__c);
                }
                if(opf.Installment_Plan__c=='Installment Plan Flex')// && fee.Installment_Plan_Flex__c!=null)
                {
                    Fin_n_its_instid.put(opf.id,fee.Installment_Plan_Flex__c);
                }
                if(opf.Installment_Plan__c=='FlexiPlan')// && fee.FlexiPlan__c!=null)
                {
                    Fin_n_its_instid.put(opf.id,fee.FlexiPlan__c);
                }
                if(opf.Installment_Plan__c=='No FlexiPlan')// && fee.No_FlexiPlan__c!=null)
                {
                    Fin_n_its_instid.put(opf.id,fee.No_FlexiPlan__c);
                }
            }
            if(!Fin_n_its_instid.IsEmpty())
            {
                list<string> temp=Fin_n_its_instid.Values();
                Map <String, Schema.SObjectField> fieldmap=new Map <String, Schema.SObjectField>();
                fieldMap = Schema.getGlobalDescribe().get('Installment_Plan_Multiplier_Values__c').getDescribe().fields.getMap();
                string theQuery = 'SELECT ';
                for(Schema.SObjectField s : fieldMap.values()){
                    String theName = s.getDescribe().getName();
                    theQuery += theName + ',';
                }        
                theQuery = theQuery.subString(0, theQuery.length() - 1);
                theQuery += ' from Installment_Plan_Multiplier_Values__c where ID IN:temp';
                system.debug(thequery);
                List<Installment_Plan_Multiplier_Values__c> iplst= Database.query(theQuery);    
                Map<String,Installment_Plan_Multiplier_Values__c> ip_map=new map<string,Installment_Plan_Multiplier_Values__c>();
                for(Installment_Plan_Multiplier_Values__c ip:iplst)
                {
                    ip_map.put(ip.Id,ip);
                }
                
                for(string fid:Fin_n_its_feeid.Keyset())
                {
                    if(fee_map.ContainsKey(Trigger.newMap.get(fid).Fees__c) && fee_map.get(Trigger.newMap.get(fid).Fees__c)!=null )  
                    {
                        Installment_Plan_Multiplier_Values__c instplan=Fin_n_its_instid.ContainsKey(fid)?(Fin_n_its_instid.get(fid)!=null?ip_map.get(Fin_n_its_instid.get(fid)):new Installment_Plan_Multiplier_Values__c()):new Installment_Plan_Multiplier_Values__c();
                        Opportunity_Finance__c fin= Trigger.newMap.get(fid);
                        fin= mapping_Finwithfeevalues.inst_multiplier(fin, fee_map.get(fin.Fees__c), instplan);                     
                    }
                }
            }
        }
    }
}