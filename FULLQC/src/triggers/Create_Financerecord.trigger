trigger Create_Financerecord on Opportunity (after insert, after update) 
{
/*
HARSHA SIMHA S
7/27/2012
If opportubnity does not contain Finance record when paid Application fee is checked then create a finance record.

by shs on 7/3/2014 for SFSUP-745
*/
    list<string> oppids=new list<string>();
    list<Opportunity_Finance__c> exstopfins=new list<Opportunity_Finance__c>();
    map<id,Opportunity_Finance__c> exstopfinsmap=new map<id,Opportunity_Finance__c>();
    set<string> existoppids=new set<string>();
    for(opportunity o:Trigger.New)
    {
         if(!RecordTypeHelper.isapplicationprocessrecordtype(o.RecordTypeId))//SFSUP-745
            continue;
        if(trigger.IsInsert && o.Paid_Application_Fee__c)
        {
            oppids.add(o.id);
        }
        if(Trigger.Isupdate && o.Paid_Application_Fee__c && o.Paid_Application_Fee__c!=Trigger.oldMap.get(o.Id).Paid_Application_Fee__c)
        {
            oppids.add(o.id);
        }
    }   
    
    if(!oppids.IsEmpty())
    {

        for(Opportunity_Finance__c oppfins:[select id,Name,I_agree_to_Terms_Cond_for_App_Fee__c,Opportunity__c from Opportunity_Finance__c where Opportunity__c IN : oppids])
        {
            existoppids.add(oppfins.opportunity__c);
            exstopfinsmap.put(oppfins.opportunity__c,oppfins);
        }
        list<Opportunity_Finance__c > insopfin=new list<Opportunity_Finance__c >();
        //if(oppids.size()!=existoppids.size())
        //{
            for(string o:oppids)
            {
                if(!existoppids.contains(o))
                {
                    Opportunity_Finance__c f=new Opportunity_Finance__c ();
                    f.Opportunity__c=o;
                    f.CurrencyIsoCode=trigger.newMap.get(o).Program_Currency__c;
                    if(Trigger.newMap.get(o).Waived_off_Application_Fee__c)
                    {
                        f.I_agree_to_Terms_Cond_for_App_Fee__c=true;
                    }    
                    if(Trigger.newMap.get(o).Program_Parsed__c=='EMBA')
                    {
                        f.Installment_Plan__c='No FlexiPlan';
                        f.Insurance__c='Waived';
                    }
                    insopfin.add(f);
                }
                else
                {
                    if(Trigger.newMap.get(o).Waived_off_Application_Fee__c && exstopfinsmap.containskey(o))
                    {
                        Opportunity_Finance__c f=exstopfinsmap.get(o);                        
                          f.I_agree_to_Terms_Cond_for_App_Fee__c=true;
                        exstopfins.add(f);
                    }   
                }
            }
            if(!insopfin.ISEmpty())
            {
                try
                {
                    insert insopfin;
                }
                catch(exception e)
                {
                    Trigger.New[0].adderror(''+e);
                }
            }
            if(!exstopfins.ISEmpty())
            {
                try
                {
                    update exstopfins;
                }
                catch(Exception e){}
            }   
       // }
    }
}