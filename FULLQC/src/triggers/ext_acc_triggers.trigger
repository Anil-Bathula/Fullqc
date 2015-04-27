/*
    Developer    : Harsha Simha
    Date         : 7/17/2014
    Purpose      : This Trigger will creates a Finance record when an Opportunity of RecordType='Housing External Opportuity' is created.
    TestClass    : Test_Ext_Housing(100%)
	
	Changed By   : Harsha
	Date		 : 8/8/2014
	Changes		 : Added before trigger to update Currency and primary campus values.
*/
trigger ext_acc_triggers on Opportunity (before insert,before update,after insert) 
{
    List<string> oids=new List<String>();
    for(Opportunity o:Trigger.New)
    {
        if(o.RecordTypeId==RecordTypeHelper.getRecordTypeId('Opportunity','Housing External Opportunity'))
        {
        	if(trigger.isafter && trigger.isinsert)
        	{
	            oids.add(o.Id);
	            System.debug('>===>'+oids);
        	}
        	if(trigger.isbefore)
        	{//opp.Primary_Campus__c!=trigger.oldmap.get(opp.id).Primary_Campus__c
        		if(o.Program_Currency__c!=null && o.CurrencyIsoCode!= o.Program_Currency__c)
        			o.CurrencyIsoCode= o.Program_Currency__c;
        		if(o.Campus_parsed_from_Program__c!=o.Primary_Campus__c)
        			o.Primary_Campus__c=o.Campus_parsed_from_Program__c;
        	}
        }
    }
    if(!oids.IsEmpty())
    {
        list<Opportunity_Finance__c> list_opf=new list<Opportunity_Finance__c>();
        for(String s:oids)
        {
            Opportunity_Finance__c opf=new Opportunity_Finance__c();
            opf.Opportunity__c=s;
            opf.RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Housing External Finance');
            opf.Installment_Plan__c='No Installment Plan';
            opf.CurrencyIsoCode=Trigger.newMap.get(s).Program_Currency__c;
            list_opf.add(opf);
            System.debug('>=2==>'+list_opf);
            
        }
        if(!list_opf.IsEmpty())
        {
            try{
                insert list_opf;
                 System.debug('>=3==>'+list_opf);
            }
            catch(Exception e){}
        }
    }
}