trigger Opportunity_UpdateRequirements on Opportunity (after insert, after update) 
{
    
    /*
        Code Modified By : Niket Chandane
        Modified date    : 4 April 2012
        Summary          : Opportunity_UpdateRequirements trigger executing unnecessary to avoid 
                            extra operation added if condition and condition to check program change
        
        Changes By     : Harsha Simha S
        Change Date     : 4/19/2013
        Summary       : Modified condition on update -- when stage is changed to current year (after october current year = next year ). 
                  old: When update requirements is true trigger fires (every time when checbox is true trigger fires)
                  New: only when   update requirements  is changed to true from false triggger fires                      
		
		Changes By     : Harsha Simha S
        Change Date     : 7/3/2013
        Summary       : commented conditions of insert,update and made whole code into 1 
		                checked condition for sfsup-745                              
    */
    //if(Trigger.isAfter && Trigger.isUpdate)
    //{
      list<Opportunity> newlst=new list<Opportunity>();
      list<Opportunity> oldlst=new list<Opportunity>();
      		
      Integer curr_year=system.today().year();
      if(System.today().month()>9)
        curr_year=system.today().year()+1;
        
        for(Opportunity objOpp : trigger.new)
        {       
        	if(!RecordTypeHelper.isapplicationprocessrecordtype(objopp.recordtypeid))
        		continue;
        		             
            Opportunity objOldOpp = Trigger.isUpdate?trigger.OldMap.get(objOpp.Id):new Opportunity();
            if(objOpp.Program__c != objOldOpp.Program__c || (objOpp.Update_Requirements__c && objOpp.Update_Requirements__c!=objOldOpp.Update_Requirements__c) ||(objOpp.Start_Term__c!=objOldOpp.Start_Term__c && (objOpp.Start_Term__c.contains(''+curr_year) || objOpp.Start_Term__c.contains(''+(curr_year+1)))) )  //By Sachin Bhadane for Hult#105 ::Added Extra condition "objOpp.Update_Requirements__c == true" 
            {
            	newlst.add(objOpp);
            	oldlst.add(objOldOpp);
                // We need to call Update reqirement when program is get updated
                //new Opportunity_UpdateRequirements(trigger.old, trigger.new).execute();
            }
        }
        if(!newlst.IsEmpty())
        {
        	new Opportunity_UpdateRequirements(oldlst, newlst).execute();
        }
        
    //}
    //else if(Trigger.isAfter && Trigger.isInsert)
     //   new Opportunity_UpdateRequirements(trigger.old, trigger.new).execute();
}