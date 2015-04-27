trigger create_goed_documents on GoEd__c (after insert,before insert)  
{
    
    if(trigger.isbefore && trigger.isinsert)
    {
        list<string> finids=new list<string>();
        for(Goed__c god:trigger.New)
        {
            if(god.Finance__c!=null)
            {
                finids.add(god.finance__c);
            }
        }
        if(!finids.IsEmpty())
        {
            map<id,Opportunity_Finance__c> opf=new map<id,Opportunity_Finance__c>([select id,Name,Currencyisocode from Opportunity_Finance__c where id IN:finids]);
            if(!opf.IsEmpty())
            {
                for(Goed__c god:trigger.New)
                {
                    if(opf.containsKey(god.Finance__c))
                    {
                       god.CurrencyIsocode=opf.get(god.Finance__c).Currencyisocode;
                    }
                }        
            }
        }
    }
        
    if(Trigger.Isafter && trigger.isinsert)
    {
        list<GoEd_Document__c> docs_lst=new list<GoEd_Document__c>();
        For(GoEd__c  gd:trigger.New)
        {
            for(Goed_Master_Documents__c master:Goed_Master_Documents__c.getall().values() )
            {
                if(master.For_Student__c)
                {
                    GoEd_Document__c doc=new GoEd_Document__c();
                    doc.Name=master.Name;
                    doc.GoEd__c=gd.id;
                    doc.For__c='Student';
                    docs_lst.add(doc);
                }
                if(master.For_cosigner1__c)
                {
                    GoEd_Document__c doc=new GoEd_Document__c();
                    doc.Name='Cosigner1 '+master.Name;
                    doc.GoEd__c=gd.id;
                    doc.For__c='Cosigner 1';
                    docs_lst.add(doc);
                }
                if(gd.Program_Name__c!=null && gd.Program_Name__c.startswith('Bachelor') && master.For_cosigner2__c)
                {
                    GoEd_Document__c doc=new GoEd_Document__c();
                    doc.Name='Cosigner2 '+master.Name;
                    doc.GoEd__c=gd.id;
                    doc.For__c='Cosigner 2';
                    docs_lst.add(doc);
                }
            }
        }
        if(!docs_lst.IsEmpty())
        {
            insert docs_lst;
        }
    }
}