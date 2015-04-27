/*
   Change Log 
  ======================================================================================================================================
    Date            Action          Owner               Commented
  ======================================================================================================================================
    13-June-2012    Modified        Niket Chandane      Use current Routing tables to setup assignments 
                                                        (duplicate records allowed with only recruiter name different)
    19-June-2012    Modified        Niket Chandane      Only Priority Group marked rules can be created as duplicates 
                                                        ie same criteria and priority
    2-Aug-2012      Modified        Niket Chandane      Routing rule changes to save Zip with Priority Grouping
                                                        1.Only High priority rules can be marked as priority grouping
                                                        2.Only zip code rules can be marked priority grouping
*/

public without sharing class RoutingTable_SetUniquenessId extends RoutingTableTrigger { 
    public RoutingTable_SetUniquenessId(Routing_Table__c[] routingOldList, Routing_Table__c[] routingNewList) {
        super(routingOldList, routingNewList);
    }
    
    public override void execute() {
        system.assert(Trigger.isBefore, 'RoutingTable_SetUniquenessId: This code must be run as a before trigger.');
        
        for(Routing_Table__c routing : getRoutingTableNewList()) {
            // Need to check that only High Priority Issue can be marked as priority Grouping = true
            if(routing.Priority_Grouping__c && !'High'.equalsIgnoreCase(routing.Priority__c))
                routing.addError(Label.Error_RuleWithoutHighPriority_Can_not_be_Prioritised);
            
            /*if(routing.Lower_Bound__c == null && routing.Upper_Bound__c == null && routing.Priority_Grouping__c)
                routing.addError(Label.Error_only_zip_rule_can_be_prioritised);
            if(routing.postal_code__c == null && routing.Priority_Grouping__c)
                routing.addError(Label.Error_only_zip_rule_can_be_prioritised);*/
            
            // NOTE: we do a replaceAll() because this is a before trigger, and the lower/upper bound
            // parser may not have run yet. So, in lieu, we just strip all spaces and hope it works.
            if (routing.Is_Active__c){
                
                routing.Uniqueness_ID__c = blankValue(routing.Matching__c).replaceAll(' ', '') + ':'
                                         
                                         // All record types
                                         + blankValue(routing.Lead_Source__c) + ':'
                                         + blankValue(routing.Lead_Status__c) + ':'
                                         + blankValue(routing.Country__c) + ':'
                                         + blankValue(routing.State__c) + ':'
                                         
                                         // RecordType = Recruiting
                                         + blankValue(routing.Age_Range__c) + ':'
                                         + blankValue(routing.Department__c) + ':'
                                         + blankValue(routing.Region__c) + ':'
                                         + blankValue(routing.Work_Load__c) + ':'
                                                                                  
                                         // Zip Postal Code
                                         + blankValue(routing.Lower_Bound__c) +':'
                                         + blankValue(routing.Priority__c) +':'
                                         + blankValue(routing.Upper_Bound__c);
                                        
                 // Allow for the priority check box checked                        
                 if(!routing.Priority_Grouping__c){
                 // Old Code which will not allow same rule with different user                        
                    if (new Set<String> { 'Department Name', 'Department ID' }.contains(routing.Routed_By__c)){
                        routing.Uniqueness_ID__c += ':' + 'Department';
                        routing.Uniqueness_ID__c += ':' + routing.Routed_To__c;
                    }
                }else{
                        routing.Uniqueness_ID__c += ':' + routing.Routed_To__c;
                    }
                
                routing.Uniqueness_ID__c = routing.Uniqueness_Id__c.toUpperCase();
                
                routing.Uniqueness_ID__c = Crypto.generateDigest('MD5', Blob.valueOf(routing.Uniqueness_ID__c)).toString();
            } else {
                routing.Uniqueness_ID__c = null;
            }
        }
    }
    
    String blankValue(String value) {
        return value == null ? '' : value.trim();
    }
}