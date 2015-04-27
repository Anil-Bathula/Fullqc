/*
      Developer : Harsha Simha
        Date    : 11/20/2012
                  When Program or Start Term Changes in Opportunity then Fee(lookup field in finance) is set to null,
                   so that Add_fee2finance trigger (before update) will set the new Fee value for the finance!   
      Test class: Fees_Test
      coverage  : 100%  
      
      Changes by SHS on 7/3/2014 for SFSUP-745
*/
trigger Opp_changeFees_inFin on Opportunity (after update) 
{
    list<string> slctdopps=new list<string>();      
    for(Opportunity opp:Trigger.new)
    {
        if(RecordTypeHelper.isapplicationprocessrecordtype(opp.Recordtypeid)&&(opp.Program__c!=TRigger.oldMap.get(opp.Id).Program__c || opp.Start_Term__c !=TRigger.oldMap.get(opp.Id).Start_Term__c))
        {
            slctdopps.add(opp.Id);          
        }
    }
    if(!slctdopps.IsEmpty())
    {
        List<Opportunity_Finance__c> oppfin=new List<Opportunity_Finance__c>();
        oppfin=[select id,Name,Fees__c,Opportunity__c from Opportunity_Finance__c where Opportunity__c IN:slctdopps];
        if(!oppfin.IsEmpty())
        {
            for(integer i=0;i<oppfin.size();i++)
            {
                oppfin[i].Fees__c=null;
            }
            
            Database.update(oppfin);
        }
    }
}