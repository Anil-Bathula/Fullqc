/*
    Trigger     : Create_Partners_YTD_History
    Developer : Harsha Simha S
    Date      : 9/30/2014
    Comment   : This Trigger checks if stagename is changed to confirmed or its related or partner,Program is changed then it calls the 
    			partner_count class which counts the ytd for that partners.   
    TestClass : Patnerytd_Test(75%)

*/
trigger Create_Partners_YTD_History on Opportunity (after insert, after update) 
{		
	map<string,list<string>> partners_years=new map<string,list<string>>(); 
	for(Opportunity new_opp:Trigger.New)
	{
		Opportunity old_opp=Trigger.isinsert?new Opportunity():Trigger.oldMap.get(new_opp.Id);
		
		System.debug(new_opp.Stage_HighLevel__c +'----------'+old_opp.Stage_HighLevel__c);
		
		Integer curr_year=system.today().year();
        if(System.today().month()>9)
        curr_year=system.today().year()+1;
		
		if(new_opp.Partner__c!=old_opp.Partner__c || (new_opp.StageName!=old_opp.stageName && 
		(new_opp.Stage_HighLevel__c!=old_opp.Stage_HighLevel__c && new_opp.Stage_HighLevel__c=='Partial' ) ||
		((old_opp.StageName!='Confirmed' && old_opp.StageName!='Conditionally Confirmed') &&
		(new_opp.StageName=='Confirmed' || new_opp.StageName=='Conditionally Confirmed')) )
		|| new_opp.Program__c!=old_opp.Program__c || new_opp.Start_Term__c!=old_opp.Start_Term__c)
		{	
			list<String> temp=new list<string>();
			if(new_opp.Partner__c!=null && new_opp.Start_Year__c!=null)
			{
				try
				{
					Integer nyear=Integer.valueOf(new_opp.Start_Year__c);
					if(nyear>=curr_year)
					{
						temp=partners_years.containskey(new_opp.Partner__c)?partners_years.get(new_opp.Partner__c):new list<string>();
						temp.add(new_opp.Start_Year__c);
						partners_years.put(new_opp.Partner__c,temp);
					}
				}
				catch(Exception e){system.debug(e);}
			}
			if(Trigger.isUpdate && old_opp.Partner__c!=null && old_opp.Start_Year__c!=null)
			{
				try
				{
					Integer oyear=Integer.valueOf(old_opp.Start_Year__c);
					if(oyear>=curr_year)
					{
						temp=partners_years.containskey(old_opp.Partner__c)?partners_years.get(old_opp.Partner__c):new list<string>();
						temp.add(old_opp.Start_Year__c);
						partners_years.put(old_opp.Partner__c,temp);
					}
				}
				catch(Exception e){system.debug(e);}
			}
		}
	}
	
	
	if(!partners_years.IsEmpty())
	{
		Partners_Count.partners_counts(partners_years);
	}
	
	
}