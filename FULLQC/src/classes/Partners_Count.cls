/*
    class	  : Partners_Count
    Developer : Harsha Simha S
    Date      : 9/30/2014
    Comment   : This class counts the ytd for the partners.   
    TestClass : Patnerytd_Test(70%)

*/
public with sharing class Partners_Count 
{
	public class partnercounts
	{
		public integer bba_partial{get;set;}
		public integer bba_conf{get;set;}
		
		public integer Masters_partial{get;set;}
		public integer Masters_conf{get;set;}
		
		public integer Mba_partial{get;set;}
		public integer Mba_conf{get;set;}
		
		public integer EMba_partial{get;set;}
		public integer EMba_conf{get;set;}
		public partnercounts()
		{
			bba_partial=0;
			bba_conf=0;			
			Masters_partial=0;
			Masters_conf=0;			
			Mba_partial=0;
			Mba_conf=0;			
			EMba_partial=0;
			EMba_conf=0;	
		}
	}
	 public static void partners_counts(map<string,list<string>> partners)
	 {//key- PArtnerid ; value- year
	 	if(partners.IsEmpty())
	 		return;
	 	Map<string,Map<string,partnercounts>> partner_count=new Map<string,Map<string,partnercounts>>(); 
	 	set<string> years=new set<string>();
	 	map<string,string> years_freq=new map<string,string>();
	 	
	 	
	 	map<string,string> partner_startterms=new map<string,string>();
	 	for(string temp:partners.keyset())
	 	{
	 		for(string s:partners.get(temp))
	 		{
	 			if(s!=null)
	 			{		 				
					try
					{
						years.add(s);	
						string tmp=(Integer.valueOf(s)-1)+'-'+s;
						years_freq.put(tmp,s);
						partner_startterms.put(temp+'--'+tmp,null);
					}
					catch(Exception e)
					{
						System.debug(e);
					}	
	 			}
	 		}
	 		
	 	}
	 	if(!years.IsEmpty())
	 	{	 		
	 		List<opportunity> ops=[select id,Name,stageName,Stage_HighLevel__c,Partner__c,Program_Parsed__c,Start_Year__c,Start_Term__c from Opportunity where Partner__c IN: partners.Keyset() and Start_Year__c IN:years and Stage_HighLevel__c='Partial'];
	 		for(Opportunity opp:ops)
	 		{
	 			Map<string,partnercounts> year_temp=partner_count.containsKey(opp.Partner__c)?partner_count.get(opp.Partner__c): new Map<string,partnercounts>();	 			
	 			partnercounts pc_temp=year_temp.containsKey(opp.Start_Year__c)?year_temp.get(opp.Start_Year__c): new partnercounts();
	 			boolean add=false;
	 			if(opp.Program_Parsed__c=='BIBA' || opp.Program_Parsed__c=='BBA')
	 			{add=true;
	 				if(opp.Stage_HighLevel__c=='Partial')
	 				{
		 				pc_temp.bba_partial++;
		 				if(opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed')
							pc_temp.bba_conf++;			
					}
	 			}
	 			if(opp.Program_Parsed__c=='MBA')
	 			{add=true;
	 				if(opp.Stage_HighLevel__c=='Partial')
	 				{
		 				pc_temp.Mba_partial++;
		 				if(opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed')
							pc_temp.Mba_conf++;			
					}
	 			}
	 			if(opp.Program_Parsed__c=='EMBA')
	 			{add=true;
	 				if(opp.Stage_HighLevel__c=='Partial')
	 				{
		 				pc_temp.EMba_partial++;
		 				if(opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed')
							pc_temp.EMba_conf++;			
					}
	 			}
	 			if(opp.Program_Parsed__c=='Masters')
	 			{add=true;
	 				if(opp.Stage_HighLevel__c=='Partial')
	 				{
		 				pc_temp.Masters_partial++;
		 				if(opp.StageName=='Confirmed' || opp.StageName=='Conditionally Confirmed')
							pc_temp.Masters_conf++;			
					}
					
	 			}
	 			
	 			if(add)
	 			{
	 				year_temp.put(opp.Start_Year__c,pc_temp);
	 				partner_count.put(opp.Partner__c,year_temp);
	 			}
	 			
	 		}
	 		
	 		if(!partner_count.IsEmpty())
	 		{
	 			List<Partner_Business__c> create_pbus=new list<Partner_Business__c>();
	 			for(Partner_Business__c pbus : [select id,Name,Recruitment_Year__c,
	 			Partner_Business__c from Partner_Business__c where Recruitment_Year__c IN:years_freq.keyset() and Partner_Business__c IN:partner_count.Keyset()])
	 			{
	 				partner_startterms.put(pbus.Partner_Business__c+'--'+pbus.Recruitment_Year__c,pbus.Id);	
	 				if(partner_count.ContainsKey(''+pbus.Partner_Business__c))
	 				{
	 					Map<string,partnercounts> year_temp=partner_count.get(''+pbus.Partner_Business__c);
	 					if(year_temp.containsKey(years_freq.get(pbus.Recruitment_Year__c)))
	 					{
	 						partnercounts tmp=year_temp.get(years_freq.get(pbus.Recruitment_Year__c));
	 						pbus.YTD_Confirmed_BBA__c=tmp.bba_conf;
	 						pbus.YTD_Confirmed_EMBA__c=tmp.EMba_conf;
	 						pbus.YTD_Confirmed_Masters__c=tmp.Masters_conf;
	 						pbus.YTD_Confirmed_MBA__c=tmp.Mba_conf;
	 						
	 						pbus.YTD_Partials_BBA__c=tmp.bba_partial;
	 						pbus.YTD_Partials_EMBA__c=tmp.EMba_partial;
	 						pbus.YTD_Partials_Masters__c=tmp.Masters_partial;
	 						pbus.YTD_Partials_MBA__c=tmp.Mba_partial;
	 						create_pbus.add(pbus);
	 					}
	 				}
	 			}
	 			
	 			
	 			for(string s:partner_startterms.Keyset())
				{
					if(partner_startterms.get(s)==null)
					{
						Partner_Business__c pbus=new Partner_Business__c();				
						pbus.Recruitment_Year__c=s.substring(s.indexOf('--')+2, s.length());
						pbus.Partner_Business__c=s.substring(0,s.indexOf('--'));
						if(partner_count.ContainsKey(''+pbus.Partner_Business__c))
		 				{
		 					Map<string,partnercounts> year_temp=partner_count.get(pbus.Partner_Business__c);
		 					if(year_temp.containsKey(years_freq.get(''+pbus.Recruitment_Year__c)))
		 					{
		 						partnercounts tmp=year_temp.get(years_freq.get(pbus.Recruitment_Year__c));
		 						pbus.YTD_Confirmed_BBA__c=tmp.bba_conf;
		 						pbus.YTD_Confirmed_EMBA__c=tmp.EMba_conf;
		 						pbus.YTD_Confirmed_Masters__c=tmp.Masters_conf;
		 						pbus.YTD_Confirmed_MBA__c=tmp.Mba_conf;
		 						
		 						pbus.YTD_Partials_BBA__c=tmp.bba_partial;
		 						pbus.YTD_Partials_EMBA__c=tmp.EMba_partial;
		 						pbus.YTD_Partials_Masters__c=tmp.Masters_partial;
		 						pbus.YTD_Partials_MBA__c=tmp.Mba_partial;
		 						create_pbus.add(pbus);
		 					}
		 				}
					}	
				}
				if(!create_pbus.IsEmpty())
				{			
					upsert create_pbus;
					
				}
	 			
	 		}
				 		
	 	}
	 	
	 	
	 }
}