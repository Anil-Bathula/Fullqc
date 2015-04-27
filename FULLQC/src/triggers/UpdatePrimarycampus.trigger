/***********************************
Trigger Name :- UpdatePrimarycampus
Test Class   :- UpdatePrimarycampus_Test
Writen by    :- Anil.B
Purpose      :- This trigger is used to update the primary campus
field from the program choosen .
Enhancement  :- added extra if condition and to update Program_Parsed_picklist__c
field with value Program_Parsed__c ---Anil.Bathula-30/1/2014
Changes by SHS on 7/3/2014 for SFSUP-745
************************************/
trigger UpdatePrimarycampus on Opportunity(before insert,before update) {

    For(Opportunity opp:Trigger.new)
    {  
    	if(!RecordTypeHelper.isapplicationprocessrecordtype(opp.Recordtypeid))	    
         continue; 
            
            If(opp.Campus_parsed_from_Program__c!=opp.Primary_Campus__c){
                opp.Primary_Campus__c=opp.Campus_parsed_from_Program__c;
            }    
            if(Trigger.isInsert&&opp.program__c!=null&&opp.Program_Parsed__c!=Null){
                System.debug('======>'+opp.Program_Parsed__c);
                opp.Program_Parsed_picklist__c=opp.Program_Parsed__c;
            }
            if(Trigger.ISupdate&&Opp.program__c!=trigger.oldmap.get(opp.id).program__c &&opp.Program_Parsed__c!=null){
                opp.Program_Parsed_picklist__c=opp.Program_Parsed__c;
            }
    }
}