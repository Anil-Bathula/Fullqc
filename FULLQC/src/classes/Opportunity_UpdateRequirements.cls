/*Ian's Code: commented by Mahesh on 1/19/2012 at 11:33 AM EST to fix routing issue in prod
public without sharing class Opportunity_UpdateRequirements extends OpportunityTrigger {
    public Boolean forceUpdate { set; get; }
    
    public class ProcessingException extends Exception {}
    
    public Opportunity_UpdateRequirements(Opportunity[] opportunityOldList, Opportunity[] opportunityNewList) {
        super(opportunityOldList, opportunityNewList);
        forceUpdate = false;
    }
    
    // This trigger applies when the program has changed
    
    public virtual override void execute() {
        // Disabled at a global level?
        if (getDisabledSetting().Opportunity_UpdateRequirements__c == true)
            return;
        
        // Extra a list of programs from the opportunities
        Set<Id> opportunityProgramIds = new Set<Id> {};
        Set<Id> opportunityProgramCountryIds = new Set<Id> {};
        Set<Id> opportunityProgramDepartmentIds = new Set<Id> {};
        
        for(Opportunity opportunityNew : opportunityNewList) {
            opportunityProgramIds.add(opportunityNew.Program__c);
            opportunityProgramCountryIds.add(opportunityNew.Program_Country__c);
            opportunityProgramDepartmentIds.add(opportunityNew.Program_Department__c);
        }
        
        // Maps for insert/delete recognition
        Map<String, Requirement__c> requirementOldMap = new Map<String, Requirement__c> {}; 
        Map<String, Requirement__c> requirementNewMap = new Map<String, Requirement__c> {}; 
        
        // Build the old map
        for(Requirement__c requirementOld : [
            select Opportunity__c
                 , Parent__r.Comparison_Key__c
              from Requirement__c
             where Opportunity__c in :opportunityOldList
               and Parent__c != null
        ]) requirementOldMap.put(generateComparisonKey(requirementOld.Opportunity__c, requirementOld.Parent__r), requirementOld);
        
        system.debug('Opportunity_UpdateRequirements: requirementOldMap = ' + requirementOldMap);
        
        // Find the new needed requirements
        Requirement__c[] requirementAggregatedList = [
            select Name
                 , Comparison_Key__c
                 , Country__c
                 , Department__c
                 , Description__c
                 , Program__c
                 , RecordTypeId
                 , Required_By__c
                 , Required_For__c
              from Requirement__c
             where ((Country__c != null and Country__c in :opportunityProgramCountryIds)
                or  (Department__c != null and Department__c in :opportunityProgramDepartmentIds)
                or  (Program__c != null and Program__c in :opportunityProgramIds))
               and Contact__c = null
               and Opportunity__c = null
               and Parent__c = null
        ];
        
        system.debug('Opportunity_UpdateRequirements: requirementAggregatedList = ' + requirementAggregatedList);
        
        // For efficiency, map each country, department, and program to requirement lists
        Map<Id, Requirement__c[]> requirementCountryMap = new Map<Id, Requirement__c[]> {};
        Map<Id, Requirement__c[]> requirementDepartmentMap = new Map<Id, Requirement__c[]> {};
        Map<Id, Requirement__c[]> requirementProgramMap = new Map<Id, Requirement__c[]> {};
        
        for(Requirement__c requirementAggregated : requirementAggregatedList) {
            putRequirement(requirementCountryMap, requirementAggregated.Country__c, requirementAggregated);
            putRequirement(requirementDepartmentMap, requirementAggregated.Department__c, requirementAggregated);
            putRequirement(requirementProgramMap, requirementAggregated.Program__c, requirementAggregated);
        }
        
        system.debug('Opportunity_UpdateRequirements: requirementCountryMap = ' + requirementCountryMap);
        system.debug('Opportunity_UpdateRequirements: requirementDepartmentMap = ' + requirementDepartmentMap);
        system.debug('Opportunity_UpdateRequirements: requirementProgramMap = ' + requirementProgramMap);
        
        // Upsert and delete lists
        Requirement__c[] requirementUpsertList = new Requirement__c[] {};
        Requirement__c[] requirementDeleteList = new Requirement__c[] {};
        
        // Build a map of desired requirements
        for(Opportunity opportunityNew : opportunityNewList) {
            Requirement__c[] requirementTemplateList = new Requirement__c[] {};
            requirementTemplateList.addAll(getRequirementList(requirementCountryMap, opportunityNew.Program_Country__c));
            requirementTemplateList.addAll(getRequirementList(requirementDepartmentMap, opportunityNew.Program_Department__c));
            requirementTemplateList.addAll(getRequirementList(requirementProgramMap, opportunityNew.Program__c));
            
            system.debug('Opportunity_UpdateRequirements: opportunityNew.Id = ' + opportunityNew.Id);
            system.debug('Opportunity_UpdateRequirements: requirementTemplateList = ' + requirementTemplateList);
            
            // Check each and see if it exists already
            for(Requirement__c requirementTemplate : requirementTemplateList) {
                String comparisonKey = generateComparisonKey(opportunityNew.Id, requirementTemplate);
                
                // Try to find the pre-existing requirement
                Requirement__c requirementNew = requirementOldMap.get(comparisonKey);
                
                // If requirementNew is null, then this is a new requirement and we clone the template.
                if (requirementNew == null)
                    requirementNew = requirementTemplate.clone(false, false);
                else // if not new, clear out the key reference so what's left over gets deleted
                    requirementOldMap.remove(comparisonKey);
                
                // Whether new or merged, set certain field data
                requirementNew.Program__c = null;    // clear this out so the related lists don't get polluted.
                requirementNew.Country__c = null;    // this too
                requirementNew.Department__c = null; // this too
                requirementNew.Opportunity__c = opportunityNew.Id;
                requirementNew.Contact__c = opportunityNew.Contact__c;
                
                // Maintain integrity
                requirementNew.Description__c = requirementTemplate.Description__c;
                requirementNew.Name = requirementTemplate.Name;
                requirementNew.Parent__c = requirementTemplate.Id;
                requirementNew.RecordTypeId = requirementTemplate.RecordTypeId;
                requirementNew.Required_For__c = requirementTemplate.Required_For__c;
                requirementUpsertList.add(requirementNew);
            }
        }
        
        // Scan through the old map and mark for deletion anything that isn't supplied, verified, approved, or waived
        for(Requirement__c requirementOld : requirementOldMap.values()) {
            if (requirementOld.Approved__c == true)
                continue;
            if (requirementOld.Supplied__c == true)
                continue;
            if (requirementOld.Verified__c == true)
                continue;
            if (requirementOld.Waived__c == true)
                continue;
            requirementDeleteList.add(requirementOld);
        }
        
        // Run DML
        if (requirementDeleteList.size() != 0)
            delete requirementDeleteList;
        if (requirementUpsertList.size() != 0)
            upsert requirementUpsertList;
    }
    
    public Requirement__c[] getRequirementList(Map<Id, Requirement__c[]> requirementMap, Id referenceId) {
        return requirementMap.get(referenceId) == null ? new Requirement__c[] {} : requirementMap.get(referenceId);
    }
    
    public void putRequirement(Map<Id, Requirement__c[]> requirementMap, Id referenceId, Requirement__c requirement) {
        if (requirementMap == null || referenceId == null || requirement == null)
            return;
        else if (requirementMap.get(referenceId) != null)
            requirementMap.get(referenceId).add(requirement);
        else
            requirementMap.put(referenceId, new Requirement__c[] { requirement });
    }
    
    public String generateComparisonKey(Id opportunityId, Requirement__c parentRequirement) {
        if (parentRequirement != null && parentRequirement.Comparison_Key__c != null)
            return opportunityId + ':' + parentRequirement.Comparison_Key__c;
        if (parentRequirement != null && parentRequirement.Id != null)
            return opportunityId + ':' + parentRequirement.Id;
        throw new ProcessingException('Unable to generate a unique identifier');
    }
}
*/// Ian's code ends here..

public without sharing class Opportunity_UpdateRequirements extends OpportunityTrigger 
{
    public Boolean forceUpdate { set; get; }
    public static Boolean IsTriggerFired {get;set;}
    
    public class ProcessingException extends Exception {}
    
    public Opportunity_UpdateRequirements(Opportunity[] opportunityOldList, Opportunity[] opportunityNewList) 
    {
        super(opportunityOldList, opportunityNewList);
        forceUpdate = false;
    }
    
    // This trigger applies when the program has changed
    
    public virtual override void execute() 
    {
        
        /*Note : HULT-186: 
            Removed the static flag we handling recurcing condition in the 
            trigger it self when lead is get converted in After insert trigger 
        */
        /*if(IsTriggerFired != null && IsTriggerFired)
            return;*/
            
        if (getDisabledSetting().Opportunity_UpdateRequirements__c == true)
            return;
        
        // Maps for insert/delete recognition
        Map<String, Requirement__c> requirementOldMap = new Map<String, Requirement__c> {};
        Map<String,Boolean> requirementDeleteMap = new Map<String, Boolean> {};
        
        // Upsert and delete lists
        Requirement__c[] requirementUpsertList = new Requirement__c[] {};
        
        // getting Visa Requirement Type Id 
        //String strRequirementTypeVisa = getVisaRequirementId();
        System.debug('opportunityOldList =============>'+opportunityOldList+'======>'+opportunityOldList.size()+'=====>'+opportunityOldList.isempty());
        list<opportunity> opportunityOldList1=new list<opportunity> (); 
        for(opportunity o:opportunityOldList)
        {
        	opportunity nullopp=new opportunity();
        	system.debug('==>'+o);
        	if(o==nullopp)
	        	continue;
	        
			opportunityOldList1.add(o);
        }
        List<Requirement__c> lstOldRequirement = getOldRequirement(opportunityOldList1);
        
        //System.debug('1. Get Old Requirement ==>'+lstOldRequirement);
        
        if(lstOldRequirement != null && lstOldRequirement.size() > 0){
            for(Requirement__c requirementOld : lstOldRequirement){
                
                String strComparisonKey = generateComparisonKey(requirementOld.Opportunity__c, requirementOld.Parent__r);
                requirementOldMap.put(strComparisonKey,requirementOld);
                requirementDeleteMap.put(requirementOld.Id+':'+strComparisonKey,true);
            }
        }
        
        // Extra a list of programs from the opportunities
        Set<Id> opportunityProgramIds = new Set<Id> {};
        Set<Id> opportunityProgramCountryIds = new Set<Id> {};
        Set<Id> opportunityProgramDepartmentIds = new Set<Id> {};
        Set<String> opportunityCountryResidence = new set<String>();
        
        Map<Id,Opportunity> mapOppId = new Map<Id,Opportunity>(); 
        mapOppId.putAll(opportunityNewList);
        
        // Created set for upadted oppotunity
        for(Opportunity opportunityNew : opportunityNewList){
            /*
              Code Updated by : Niket Chandane
              Summary         : Added a line to fill the Map with opp id 
            */
            //opportunityCountryResidence.add(opportunityNew.Country_Of_Residence__c);
            opportunityCountryResidence.add(opportunityNew.Country_Of_Origin__c);
            
            opportunityProgramIds.add(opportunityNew.Program__c);
            opportunityProgramCountryIds.add(opportunityNew.Program_Country__c);
            opportunityProgramDepartmentIds.add(opportunityNew.Program_Department__c);
        }
        
        // Get the Map of Opp Id and the Opportunity Programs Country 
        Map<String,String> OppIdOfProCountry = getMapOppOfProgramCountry(opportunityCountryResidence);
        
        /*Creating set of new requiment as per updated opportunity country, dept and program */
        Requirement__c[] requirementAggregatedList = CollectRequirementForUpdatedOpportunity(opportunityProgramCountryIds,
                                                        opportunityProgramDepartmentIds,opportunityProgramIds);
                                                        
        opportunityProgramIds.clear();
        opportunityProgramCountryIds.clear();
        opportunityProgramDepartmentIds.clear();
        
        //For efficiency, map each country, department, and program to requirement lists
        Map<Id, Requirement__c[]> requirementCountryMap = new Map<Id, Requirement__c[]> {};
        Map<Id, Requirement__c[]> requirementDepartmentMap = new Map<Id, Requirement__c[]> {};
        Map<Id, Requirement__c[]> requirementProgramMap = new Map<Id, Requirement__c[]> {};
       
        for(Requirement__c requirementAggregated : requirementAggregatedList) {
            putRequirement(requirementCountryMap, requirementAggregated.Country__c, requirementAggregated);
            putRequirement(requirementDepartmentMap, requirementAggregated.Department__c, requirementAggregated);
            putRequirement(requirementProgramMap, requirementAggregated.Program__c, requirementAggregated);
            system.debug('----->'+requirementAggregated  );
        }
        
        // To avoid Heap size 
        requirementAggregatedList.clear();
        
        //System.debug('===> Old Requirement Map with Camparison key'+requirementOldMap);
        
        // Pick all the Requremets as per the Country, Program ,Department
        for(Opportunity opportunityNew : opportunityNewList)
        {
            Requirement__c[] requirementTemplateList = new Requirement__c[] {};
            
            if(requirementCountryMap != null && opportunityNew.Program_Country__c != null)
                requirementTemplateList.addAll(getRequirementList(requirementCountryMap, opportunityNew.Program_Country__c));
            if(requirementDepartmentMap != null && opportunityNew.Program_Department__c != null)
                requirementTemplateList.addAll(getRequirementList(requirementDepartmentMap, opportunityNew.Program_Department__c));
            if(requirementProgramMap != null && opportunityNew.Program__c != null)
                requirementTemplateList.addAll(getRequirementList(requirementProgramMap, opportunityNew.Program__c));
            
            // Need to avoid the requirements which are getting inserted duplicately
            requirementTemplateList = generateUniqueRequirementList(requirementTemplateList);
            
           // System.debug('requirementTemplateList  ====>'+requirementTemplateList);
            
            if(requirementTemplateList != null && requirementTemplateList.size() > 0){
                for(Integer iCount = 0; iCount < requirementTemplateList.size(); iCount++)
                {
                    // Generated Key for the new requirement
                    String comparisonKey = generateComparisonKey(opportunityNew.Id, requirementTemplateList[iCount]);
                    String strCountryId;
                    
                    //System.debug('New Req'+requirementTemplateList[iCount].Name+':: Parent Key ::'+requirementTemplateList[iCount]+' :: strComparisonKey ::'+comparisonKey);
                    
                    Requirement__c requirementNew;                  
                    // Try to find the pre-existing requirement
                    if(requirementOldMap!= null && comparisonKey != null && requirementOldMap.ContainsKey(comparisonKey))
                     {  
                        Requirement__c requirementOld = requirementOldMap.get(comparisonKey);
                        
                        requirementDeleteMap.put(requirementOld.Id+':'+comparisonKey,false);
                        
                        //Removed to avoid heap size issue
                        //requirementNew = requirementOld.clone(false,false);
                        requirementNew = requirementOld.clone(true,true);
                        //requirementOldMap.remove(comparisonKey);
                     }
                    
                    if(requirementNew == null){                     
                        requirementNew = requirementTemplateList[iCount].clone(false, false);                       
                    }
                    
                    /* Code commented by Niket 
                        to delete all the old requirements 
                        Code Commented : else{requirementOldMap.remove(comparisonKey);}*/
                    
                    // Whether new or merged, set certain field data
                    requirementNew.Program__c = null;    // clear this out so the related lists don't get polluted.
                    requirementNew.Country__c = null;    // this too
                    requirementNew.Department__c = null; // this too
                    requirementNew.Opportunity__c = opportunityNew.Id;
                    requirementNew.Contact__c = opportunityNew.Contact__c;
                    
                    // Maintain integrity
                    requirementNew.Description__c = requirementTemplateList[iCount].Description__c;
                    requirementNew.Name = requirementTemplateList[iCount].Name;
                    requirementNew.Parent__c = requirementTemplateList[iCount].Id;
                    requirementNew.RecordTypeId = requirementTemplateList[iCount].RecordTypeId;
                    requirementNew.Required_For__c = requirementTemplateList[iCount].Required_For__c;
                    
                    /*  Issue       : HULT-176
                        Description : 476 Have Copy of Passport Requirement assigned to every Application
                    */
                    requirementUpsertList.add(requirementNew);
                    
                    /*  
                        Code Modified :Niket Chandane
                        Summary       :Need To check that if Opportunity Country and Opportunity Program => Country 
                                       is same then Visa requrement should not be added  
                    
                    if(opportunityNew.Country_Of_Origin__c != null && OppIdOfProCountry.ContainsKey(opportunityNew.Country_Of_Origin__c))
                        strCountryId = OppIdOfProCountry.get(opportunityNew.Country_Of_Origin__c).subString(0,15);
                    
                    if(strCountryId != null && !strCountryId.equals(opportunityNew.Program_Country__c))
                    {
                        requirementUpsertList.add(requirementNew);
                    }
                    else{
                        if(requirementNew.RecordTypeId != null && !String.valueOf(requirementNew.RecordTypeId).equals(strRequirementTypeVisa))
                            requirementUpsertList.add(requirementNew);
                    }*/
                }
                
                // to avoid heap size removed the collection which are alredy used
               /* requirementTemplateList = null;
                requirementCountryMap   = null;
                requirementDepartmentMap = null;
                requirementProgramMap   = null;
                requirementOldMap       = null;*/
            }
        }
        system.debug(lstOldRequirement.size()+'-------------'+lstOldRequirement);
       // Need to delete the Old Requrement
       if(lstOldRequirement.size() != 0)
       {
        List<Requirement__c> lstDelReq = new List<Requirement__c>();
        
         for(Requirement__c objDeleteRequire :lstOldRequirement)
         {
            String comparisonKey = generateComparisonKey(objDeleteRequire.Opportunity__c, objDeleteRequire.Parent__r);
            //System.debug('comparisonKey =====>'+comparisonKey+' Contains ==>'+requirementDeleteMap.ContainsKey(objDeleteRequire.Id+':'+comparisonKey));
            if(requirementDeleteMap.ContainsKey(objDeleteRequire.Id+':'+comparisonKey) && requirementDeleteMap.get(objDeleteRequire.Id+':'+comparisonKey)){
                System.debug('---'+objDeleteRequire.Name);
                if(objDeleteRequire.Name!='Professional Recommendation')
                {
                    lstDelReq.add(objDeleteRequire);
                }
            }
         }system.debug(lstDelReq.size()+'-------------'+lstDelReq);
         delete lstDelReq;
       }
         
        // To avoid the heap size limit 
         lstOldRequirement.clear();
       
       if(requirementUpsertList.size() != 0)
       {System.debug(requirementUpsertList.size()+'-----------'+requirementUpsertList);
         List<Runtime_Errors__c> ins_errs=new List<Runtime_Errors__c>(); 
         try
         {
            List<Database.Upsertresult>  lstResult = Database.upsert(requirementUpsertList);
            
            for(Database.Upsertresult res:lstResult )
            {
                if(!res.isSuccess())
                {
                    
                    Runtime_Errors__c re=new Runtime_Errors__c();
                    re=Exception_Handler.Collect_exceptions('Opportunity_UpdateRequirements', 'DML Failed', res.getErrors()+'---------------'+'opportunityNewList='+opportunityNewList+'[][][] opportunityOldList'+opportunityOldList, '');
                    if(re!=null)
                        ins_errs.add(re);                       
                }
            }
         }  
         catch(Exception e)
         {
            
            Runtime_Errors__c re=new Runtime_Errors__c();
            re=re=Exception_Handler.Collect_exceptions('Opportunity_UpdateRequirements', e.getTypeName(), e.getMessage()+'---------------'+'opportunityNewList='+opportunityNewList+'[][][] opportunityOldList'+opportunityOldList,e.getStackTraceString());            
            if(re!=null)
                ins_errs.add(re);
         }
         if(!ins_errs.IsEmpty())
         {
             try
             {
                Exception_Handler.insert_exceptions(ins_errs);
             }
             catch(Exception e)
             {
                system.debug(e);
             }
         }
       }
       
       IsTriggerFired = true;
    }
    
    public List<Requirement__c> getNewlyInsertedRequirements(List<Database.Saveresult> lstdbResult)
    {
        Set<Id> setNewRequirementId = new Set<Id>();
        for(Database.Saveresult dbResult  :lstdbResult){
            if(dbResult.isSuccess())
                setNewRequirementId.add(dbResult.getId());
        }
        
        return getNewRequirementById(setNewRequirementId);
    }
    
    public List<Requirement__c> getNewRequirementById(Set<Id> setNewRequirementId)
    {
        return [
            select Name
                 , Comparison_Key__c
                 , Country__c
                 , Department__c
                 , Description__c
                 , Program__c
                 , RecordTypeId
                 , Required_By__c
                 , Required_For__c
                 , Contact__c
                 , Opportunity__c
                 , Parent__c,Parent__r.Comparison_Key__c
                    
              from Requirement__c
             where Id in : setNewRequirementId
        ];
    }
    
    public Set<Id> getOldRequirementId(List<Requirement__c> lstOldRequirement)
    {
        Set<Id> setOldReq = new Set<Id>();
        for(Requirement__c objReq : lstOldRequirement){
            setOldReq.add(objReq.Id);
        }
        return setOldReq;
    }
    
    /*
       Method Created BY : Niket Chandane
       Parameters        : Set<String> setCountryName
       Summary           : Method accepts the set of Country name 
                           and returns the Map of Country Name and Country id.  
       Return            : Map<String,String>
    */
    public Map<String,String> getMapOppOfProgramCountry(Set<String> setCountryName){
        Map<String,String> mapProgramIdwithCountries = new Map<String,String>();
        for(Country__c objCountry : [Select c.Name, c.Id From Country__c c where c.Name in : setCountryName])
            mapProgramIdwithCountries.put(objCountry.Name,objCountry.Id);
        
        return mapProgramIdwithCountries;
    }
    
     /*
       Method Created BY : Niket Chandane
       Parameters        : set<Id> opportunityProgramCountryIds, set<Id> opportunityProgramDepartmentIds,set<Id> opportunityProgramIds
       Summary           : Method accepts the set of Country,Dept,Program
                           and returns the list of the requirements
       Return            : Requirement__c[]
    */
    
    public Requirement__c[] CollectRequirementForUpdatedOpportunity(set<Id> opportunityProgramCountryIds, set<Id> opportunityProgramDepartmentIds,set<Id> opportunityProgramIds)
    {
        return [
            select Name
                 , Comparison_Key__c
                 , Country__c
                 , Department__c
                 , Description__c
                 , Program__c
                 , RecordTypeId
                 , Required_By__c
                 , Required_For__c
                 ,Personal_Statement__c
              from Requirement__c
             where ((Country__c != null and Country__c in :opportunityProgramCountryIds)
                or (Department__c != null and Department__c in :opportunityProgramDepartmentIds)
                or (Program__c != null and Program__c in :opportunityProgramIds))
               and Contact__c = null
               and Opportunity__c = null
               and Parent__c = null
        ];
    }
    
    /*
       Method Created BY : Niket Chandane
       Parameters        : Opportunity[] opportunityOldList
       Summary           : Method accepts the list of the Old Opportunity
                           and returns the list of the requirements
       Return            : Requirement__c[]                    
    */
    
    public  Requirement__c[] getOldRequirement(Opportunity[] opportunityOldList)
    {
       return [select Id,Identifier_Unique__c,Name,Parent__c
                 , Opportunity__c,Comparison_Key__c
                 , Parent__r.Comparison_Key__c
                 , Supplied_Date__c
                 , Waived__c, Waived_Date__c, Verified__c, Verified_Date__c, Supplied__c
                 , Recommendation_Work_Experience__c, Recommendation_Waived_Access__c
                 , Recommendation_Stress_Management__c, Recommendation_SWOT__c
                 , Recommendation_Potential_For_Growth__c, Recommendation_Position__c
                 , Recommendation_Personal_Motivation__c, Recommendation_Level_Of_Planning__c
                 , Recommendation_Last_Name__c, Recommendation_First_Name__c, Recommendation_English_Ability__c 
                 , Recommendation_Email_Address__c, Recommendation_Decision__c, Recommendation_Contact__c 
                 , Recommendation_Company__c, Recommendation_Comments__c, Recommendation_Background__c, Recommendation_Analytical_Ability__c
                 , Approved__c, Approved_Date__c
                 , Personal_Statement__c
                 , Waiver_Reason__c, Unlocked__c, Unlocked_Date__c , Title__c, Status_UI__c
                 , SponsorerAddress__c, Sponser__c, Retake_Exam_Score__c, Retake_Exam_Location__c
                 , Retake_Exam_Date__c,Required_For__c,Required_By__c,Phone_Country_Code__c
                 ,PhoneNo__c,PhoneCountryCode__c, Orphaned__c, Opportunity_Stage__c,Mismatched_Departments__c
                 , Mismatched_Contact__c, GPA__c, Fax_CountryCode__c, FaxNo__c, FaxCountryCode__c
                 , FaxAreaCode__c, Family_Sponsor__c, Employee__c, Description__c, DEBUG_Child_of_a_Child__c
                 , CurrencyIsoCode, Contact__c, ContactPerson__c, Comments__c, Amount__c
                 
              from Requirement__c
             where Opportunity__c in :opportunityOldList 
              ]; // and Parent__c != null
    }
    
    public Requirement__c[] getRequirementList(Map<Id, Requirement__c[]> requirementMap, Id referenceId){
        /*Modified By : Sachin Bhadane
              Summary : Added an If else condition for avoiding attempt to de-reference a null object Error for Hult# 177 */
            return requirementMap.get(referenceId) == null ? new Requirement__c[] {} : requirementMap.get(referenceId);
    }
    
    public void putRequirement(Map<Id, Requirement__c[]> requirementMap, Id referenceId, Requirement__c requirement) 
    {
        if (requirementMap == null || referenceId == null || requirement == null)
            return;
        else if (requirementMap.get(referenceId) != null)
            requirementMap.get(referenceId).add(requirement);
        else
            requirementMap.put(referenceId, new Requirement__c[] { requirement });
    }
    
    public String generateComparisonKey(Id opportunityId, Requirement__c parentRequirement) 
    {
        
        if (parentRequirement != null && parentRequirement.Comparison_Key__c != null)
        {
            return opportunityId + ':' + parentRequirement.Comparison_Key__c;
        }
        if (parentRequirement != null && parentRequirement.Id != null)
        {
            return opportunityId + ':' + parentRequirement.Id;
        }
        if(parentRequirement == null)
        {
            return opportunityId +':' +'No Parent';
        }
        throw new ProcessingException(Label.Unable_to_generate_a_unique_identifier);
    }
    
    public  Requirement__c[] generateUniqueRequirementList( Requirement__c[] requirementList)
    { 
        if(requirementList != null && requirementList.size() < 1)
        return null;
        set<String> setkey = new set<String>();
        Map<String,Requirement__c> MapKeyReq = new Map<String,Requirement__c>(); 
        for(Requirement__c objReq : requirementList)
        {
            String strRequired_For;
            if(objReq.Country__c != null)
                strRequired_For = objReq.Country__c;
            else if(objReq.Department__c != null)
                strRequired_For = objReq.Department__c;
            else if(objReq.Program__c != null)
                strRequired_For = objReq.Program__c;
                
            String strCommanKey = objReq.Name + objReq.RecordTypeId + strRequired_For;
            
            // Need to fill the Set ans Map with same key
            setkey.add(strCommanKey);
            MapKeyReq.put(strCommanKey,objReq);
        }
        
        // Clear all parent requirement list to avoid duplication
        requirementList.clear();
        
        // Fill the unique requirement
        for(String strSetKey : setkey){
            requirementList.add(MapKeyReq.get(strSetKey));
        }
        return requirementList;
    }
    
     /*
       Method Created BY : Niket Chandane
       Parameters        : N/A
       Summary           : Method returns the VISA recordtype id.  
       Return            : String
       
       Note              : Currently this function is not used in the code due to 
       HULT-176 Issue
   
    public String getVisaRequirementId(){
        return [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='Requirement__c' and Name ='Visa'][0].Id;
    }  */
}