trigger create_goed on Opportunity_Finance__c (after insert,after update) 
{
    set<string> createfor=new set<string>();
    for(Opportunity_Finance__c new_fin:trigger.New)
    {
    
        Opportunity_Finance__c old_fin=Trigger.Isinsert?new Opportunity_Finance__c():Trigger.Oldmap.get(new_fin.Id);
          if((new_fin.Go_Ed_Loan_Amount__c!=null && new_fin.GoEd_Financing_Status__c=='Start Application') && 
             (old_fin.Go_Ed_Loan_Amount__c==null || old_fin.GoEd_Financing_Status__c!='Start Application'))
          {
              createfor.add(new_fin.Id);
          }
    
    }
    
    if(!createfor.IsEmpty())
    {
        list<Goed__c> list_goed  = new list<Goed__C>();
        set<string> existing_fins  = new set<string>();
        for(goed__c goed:[select id,NAme,Finance__C from goed__c where Finance__C IN:createfor])
        {
            existing_fins.add(goed.Finance__c);
        }
        for(string fin:createfor)
        {
            if(!existing_fins.Contains(fin))
            {
                goed__c goed=new goed__c ();
                goed.Finance__c=fin;
                list_goed.add(goed);
            }
        }
        if(!list_goed.IsEmpty())
        {
            insert list_goed;
        }        
    }
}