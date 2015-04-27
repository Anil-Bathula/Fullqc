trigger Calculate_Experience on Employment__c (before insert, before update,after insert, after update) 
{
/*
        Trigger   : Calculate_Experience             
        Developer : Harsha Simha S
        Date      : 08/04/2013
        Summary   : Calculate Total Experience based on the Employment Dates.(Before Trigger)     
        Test Class: validation_AAM_Test(65%)  
        
        Changes   : 10/4/2013
        Summary   :  for Opportunity.Industry_Sector_c to be populated with Employment.Industry_Sectorc 
                     whenever an Employment record gets Current_Empoyer_c set to TRUE  

*/
    if(Trigger.isBefore)
    {
        for(Employment__c emp:Trigger.New)
        {
            if(emp.DateFrom__c==null)
                continue;
            if(emp.DateTo__c==null && !emp.isCurrent_Employer__c)
                continue;
            Date enddate=emp.isCurrent_Employer__c?System.today():emp.DateTo__c;
            
            integer totalmonths=emp.DateFrom__c.monthsBetween(enddate); 
            
            emp.Work_Experience_Years__c= totalmonths/12;
            emp.Work_Experience_Months__c=totalmonths-(emp.Work_Experience_Years__c*12);
            
        }
    }
    /*  added on 10/4/2013 by shs. for Opportunity.Industry_Sector_c to be populated with Employment.Industry_Sectorc 
        whenever an Employment record gets Current_Empoyer_c set to TRUE
*/
    if(Trigger.isAfter)
    {
        map<string,string> ind_sec=new map<string,string>();
        for(Employment__c emp:Trigger.New)
        {
            if(emp.isCurrent_Employer__c && (Trigger.isInsert || (Trigger.isUpdate && emp.Industry_Sector__c != Trigger.oldMap.get(emp.id).Industry_Sector__c)))
            {
                ind_sec.put(emp.Application__c,emp.Industry_Sector__c);
            }           
        }
        if(!ind_sec.keySet().IsEmpty())
        {
            List<opportunity> opp=[select id,Name,Industry_Sector__c from Opportunity where id IN:ind_sec.keyset()];
            for(integer i=0;i<opp.size();i++)
            {
                opp[i].Industry_Sector__c=ind_sec.get(opp[i].id);
            }
            update opp;
            
        }
    }
}