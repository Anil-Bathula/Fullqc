/*
    Change Log 
-----------------------------------------------------------------------------------------------------------------------------
    Date            Owner               Comment
-----------------------------------------------------------------------------------------------------------------------------
    27/7/2012       Niket Chandane      Lead routing will work for Rcruiting as well as it 
                                        will work for the Zip code.
                                        - Priority grouping and load balancing will happen for 
                                            the Zip code/Recruiting
    27/7/2012       Niket Chandane      Added new method "applyRoutingDynamicRouting" provided full support
                                        Zip code and Load balancing + old recruiting
    Modified by: Anil.B on 11/11/2014 commented Sub_Region__c field value updation 
*/
public with sharing class Lead_DynamicRouting extends LeadExtension {

    final Id leadId;
    static set<Routing_Table__c> updatertble;
    static map<Id,Routing_Table__c> maproutetables;
    
    public Lead_DynamicRouting(ApexPages.StandardController controller) {
        super(controller);
        this.leadId = controller.getId();
    }
    
    public PageReference execute() {
        update new Lead(Id = leadId, Apply_Routing_Type__c = RoutingAnalysis.RoutingTypeRecruiting);
        return new PageReference('/' + leadId);
    }

    public static void applyRouting(Lead[] leadNewList) {
        if(leadNewList.IsEmpty())
            return ;
        updatertble=new set<Routing_Table__c>();
        maproutetables=new map<id,Routing_Table__C>();
            
        // Getting all the routing tables (Zip Based and Recruiting based) related with the Applicant data
        RoutingTableListInfo objRoutingTableListInfo = getRoutingTableList(leadNewList);
        
        if(objRoutingTableListInfo.lstByZipRouting.IsEmpty() && objRoutingTableListInfo.lstByRecruitRouting.IsEmpty())
            return;
        
        for(Routing_table__c r:objRoutingTableListInfo.lstByZipRouting){maproutetables.put(r.Id,r);}
        for(Routing_table__c r:objRoutingTableListInfo.lstByRecruitRouting){maproutetables.put(r.Id,r);}
        
        /*Existing logic // Send record for the routing 
        if(!applyRoutingDynamicRouting(objRoutingTableListInfo.lstByZipRouting, leadNewList, RoutingAnalysis.RoutingTypePostalCode))
            applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, leadNewList, RoutingAnalysis.RecordTypeRecruiting);*/
        
        /*//bys shs 
        System.debug('Zip Code Rules ==>'+objRoutingTableListInfo.lstByZipRouting);
        System.debug('Recruit Code Rules ==>'+objRoutingTableListInfo.lstByRecruitRouting);*/
        
        /*First Check for the Zip code routing*/
        List<DynamicRoutingResult> lstresult = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByZipRouting, leadNewList, RoutingAnalysis.RoutingTypePostalCode);
        //bys shs System.debug('Via Recruiting Routing result ===>'+lstresult);
        
        if(lstresult.IsEmpty()) return;
        
        List<Lead> lstLeadRecruiting = new List<Lead>();
        for(DynamicRoutingResult objRoutingResult : lstresult){
            if(!objRoutingResult.bIsRouted)
                lstLeadRecruiting.add(objRoutingResult.objLead);
        }
        
        if(lstLeadRecruiting.Isempty())
        {
            if(!updatertble.Isempty())
            {updaterulescount();
            }
            return;
        }
        
        List<DynamicRoutingResult> lstresult2 = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, lstLeadRecruiting, RoutingAnalysis.RecordTypeRecruiting);
        if(!updatertble.Isempty())
        {updaterulescount();
        }   
        //bys shs System.debug('Via Recruiting Routing result ===>'+lstresult2);
    }
    
    /*
        Created By  : Harsha Simha
        Created At  : 5 Sept 2012
        Parameters  : 
        Return Type : Void
        Summary     : Function will Capture all the rules which set the owner for contact and update \
                        their last rule applied date and Routing Count.
    */
    
    public static void updaterulescount()
    {
        if(!updatertble.ISEmpty())
        {
            list<Routing_Table__c> updrrules=new list<Routing_Table__c> ();
            updrrules=[select id,Name,Routed_To__c, Last_Roule_Applied_Date__c, Routed_Records__c from Routing_Table__c where id IN:updatertble];
            for(integer i=0;i<updrrules.size();i++)
            {
                if(maproutetables.containsKey(updrrules[i].Id))
                {   Routing_Table__c r=maproutetables.get(updrrules[i].Id);
                    updrrules[i].Last_Roule_Applied_Date__c=r.Last_Roule_Applied_Date__c;
                    updrrules[i].Routed_Records__c=r.Routed_Records__c;
                }
            }
            if(!updrrules.Isempty())
            {
                try{update updrrules;}catch(Exception e){system.Debug('------'+e);}
            }
        }
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Routing_Table__c[],lead[], String
        Return Type : Boolean
        Summary     : Function will accepts the list of leads,routing table and get the routing type and apply the 
                      routing engine rules and route the lead to respective user
    */
    public static List<DynamicRoutingResult> applyRoutingDynamicRouting(Routing_Table__c[] routingList ,lead[] leadNewList,String strRouteBy)
    {
       // System.debug('strRouteBy ==>'+strRouteBy+' == First Routing List =====>'+routingList);
        
        /*Boolean bIsRouted = false;
        if(routingList.IsEmpty() || leadNewList.IsEmpty())
            return bIsRouted;*/
        
        /*Routing result for bulk update*/
        List<DynamicRoutingResult> lstDynamicRoutingResult = new List<DynamicRoutingResult>(); 
            
        // Clear the routing
        for (Lead leadNew : leadNewList)
            leadNew.Apply_Routing_Type__c = null;
            
        final Map<String, Id> routingQueueMap = RoutingAnalysis.getRoutingQueueMap(routingList);
        final Map<String, Id> routingUserMap  = RoutingAnalysis.getRoutingUserMap(routingList);
        
        // Collect the dynamic User Map with Ownership
        Map<String,Integer> MapDynamicUserAllocationMap = getDynamicUserAllocationMap(collectRoutingUserId(routingUserMap));
        
        //SHS: Collects the Rules Last Routed Date
        Map<String,Datetime> MapDynamicruleAllocationdateMap = getDynamicruleAllocationdateMap(routingList);
        
        /*//bys shs system.debug('Lead_RouteByRecruiting.applyRouting(): routingQueueMap = ' + routingQueueMap);
        system.debug('Lead_RouteByRecruiting.applyRouting(): routingUserMap = ' + routingUserMap);*/
        
        // Rewrite the routing table with the actual ids
        for(Routing_Table__c routing : routingList) {
            if (RoutingAnalysis.RoutedByQueueName.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = routingQueueMap.get(routing.Routed_To__c);
            if (RoutingAnalysis.RoutedByUserName.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = routingUserMap.get(routing.Routed_To__c);
        }
        
        // Map the country ids to names
        Map<Id, String> countryNameMap = new Map<Id, String> {};
        
        for(Lead leadNew : leadNewList) {
            countryNameMap.put(leadNew.Country_Of_Residence__c, null);
        }
        
        for(Country__c country : [
            select Name
              from Country__c
             where Id in :countryNameMap.keySet()
        ]) countryNameMap.put(country.Id, country.Name);
        
        // Actual mapping starts
        //bys shs  system.debug('Lead_RouteByRecruiting.applyRouting(): countryNameMap = ' + countryNameMap);
/* --****************************************************************************************************************-- */        
        for(Lead leadNew : leadNewList) 
        {
         //bys shs    System.debug('leadNew ==========>'+leadNew.Id);
            /*Assigning each contact result for bulk data */
            DynamicRoutingResult objDynamicRoutingResult = new DynamicRoutingResult();
            objDynamicRoutingResult.objLead = leadNew;
            objDynamicRoutingResult.bIsRouted = false;
            
            Routing_Table__c routing;
            String strRoutingKey;
            String routingGroup = null;
            String postalCode;
            Map<String,Integer> MapRuleViaMatchCount = new Map<String,Integer>();
            Map<String,Routing_Table__c> MapIdVsRouteTable = new Map<String,Routing_Table__c>();
            
            Routing_Table__c[] routingGroupList = new Routing_Table__c[] {};
            List<Routing_Table__c> lstRoutingwithPriority = new List<Routing_Table__c>();
            
            if(!IsNullOrEmpty(leadNew.PostalCode)){
                //postalCode = RoutingAnalysis.getStandardizedPostalCode(contactNew.MailingPostalCode,contactNew.Country_Of_Residence_Name__c);
          //bys shs  System.debug('leadNew.PostalCode ===============>'+leadNew.PostalCode);
                postalCode = leadNew.PostalCode;
            }
            
            for(Routing_Table__c r : routingList) 
            {
                Integer iRoutingParameterCount = 0;
                MapIdVsRouteTable.put(r.Id,r);
               /* //bys shs 
               System.debug('r ==================================>Rule => '+r.Name);
                
                System.debug('r.Country__c ::'+r.Country__c+':: '+countryNameMap.get(leadNew.Country_Of_Residence__c)+' :: ==>'+definitiveNotMatched(r.Country__c, countryNameMap.get(leadNew.Country_Of_Residence__c)));
                System.debug('r.State__c ::'+r.State__c+':: '+leadNew.State+' :: '+definitiveNotMatched(r.State__c, leadNew.State));
                System.debug('r.Department__r.Name ::'+r.Department__r.Name+':: '+leadNew.Department_Name_Primary__c+' :: '+definitiveNotMatched(r.Department__r.Name, leadNew.Department_Name_Primary__c));
                */
                if (r.Routed_To__c == null)
                    continue;
                // NOTE: r.Region__c is ignored for routing purposes.
                if (definitiveNotMatched(r.Country__c, countryNameMap.get(leadNew.Country_Of_Residence__c)))
                    continue;
                if (definitiveNotMatched(r.State__c, leadNew.State))
                    continue;
                if (definitiveNotMatched(r.Department__r.Name, leadNew.Department_Name_Primary__c))
                    continue;
                
               //bys shs  System.debug('After Continue passing 1');
                
                /* Special handling if routing is working via Recruiting but the Zip code is not matching 
                then it must be allocated for next rule*/
                if(!IsNullOrEmpty(PostalCode) || r.Lower_Bound__c != null || r.Upper_Bound__c != null)
                {/*
                    System.debug('Postal ==========>'+PostalCode);
                    System.debug('Postal Code test 1'+definitiveNotMatched(r.Lower_Bound__c,postalCode));
                    System.debug('Postal Code test 1'+definitiveNotMatched(r.Upper_Bound__c,postalCode));
                    */
                    if(IsNullOrEmpty(postalCode))
                    continue;
                    if(definitiveNotMatched(r.Lower_Bound__c,postalCode))
                    continue;
                    if(definitiveNotMatched(r.Upper_Bound__c,postalCode))
                    continue;
                }
                
               //bys shs  System.debug('After Continue passing 2');
                /*Zip Code routing Logic*/
                if(strRouteBy.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode))
                {
              //bys shs       System.debug('After Continue passing 1');
                    
                    if(IsNullOrEmpty(postalCode))
                        continue;
                    if(r.Lower_Bound__c == null || r.Upper_Bound__c == null)
                        continue;
                    if(!postalCode.equalsIgnoreCase(r.Upper_Bound__c) || !postalCode.equalsIgnoreCase(r.Lower_Bound__c))
                        continue;
                        
                    /*if(IsNullOrEmpty(postalCode))
                    continue;
                    if(definitiveNotMatched(postalCode,r.Lower_Bound__c))
                    continue;
                    if(definitiveNotMatched(postalCode,r.Upper_Bound__c))
                    continue;*/
                    
                    // Grouping logic: add only High priority matches for which we can do load balancing
                    if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c))
                    {
                        /*System.debug('Inside Zip code Marker ==>'+r.Name);
                        System.debug('Country matching ==>'+String.valueOf(countryNameMap.get(leadNew.Country_Of_Residence__c)).equalsIgnoreCase(r.Country__c));*/
                        // New Development to get most accurate result
                        if (leadNew.Country_Of_Residence__c != null && String.valueOf(countryNameMap.get(leadNew.Country_Of_Residence__c)).equalsIgnoreCase(r.Country__c)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }
                        
                        if (leadNew.State != null && leadNew.State.equalsIgnoreCase(r.State__c)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }
                        if (leadNew.Department_Name_Primary__c != null && leadNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }
                        
                        routingGroup = r.Priority__c;
                        routingGroupList.add(r);
                        
                        // Priority Grouping with load balancing
                        if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                            lstRoutingwithPriority.add(r);
                    }
                }
                else // Normal routing (Recruiting) 
                {
                    /* shs: load balance routing (Recruiting) with out postal code!*/                
                    /* Grouping logic: add only High priority matches for which we can do load balancing*/
                    if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c))
                    {
                        /* New Development to get most accurate result */
                        if (leadNew.Country_Of_Residence__c != null && String.valueOf(countryNameMap.get(leadNew.Country_Of_Residence__c)).equalsIgnoreCase(r.Country__c)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }
                        if (leadNew.State != null && leadNew.State.equalsIgnoreCase(r.State__c)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }
                        if (leadNew.Department_Name_Primary__c != null && leadNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                            iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                        }   
                        
                        routingGroup = r.Priority__c;
                        routingGroupList.add(r);
                        
                        /* for zip code only High priority will be take in to consideration */
                        if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                            lstRoutingwithPriority.add(r);
                    }
                    /*System.debug('Inside the Recruiting marker'+r.Name);
                    if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c)){
                        routingGroup = r.Priority__c;
                        routingGroupList.add(r);
                    }*/
                }
            }
            /*//bys shs 
            System.debug('Lead ===========>'+leadNew.Name);
            system.debug('lstRoutingwithPriority ===========>'+lstRoutingwithPriority);
            system.debug('routingGroupList =============>'+routingGroupList);
            system.debug('MapRuleViaMatchCount =============>'+MapRuleViaMatchCount);
            */
            if(lstRoutingwithPriority.Isempty() && routingGroupList.IsEmpty() && MapRuleViaMatchCount.IsEmpty()){
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;
            }
            
            //finalizeSameRule()
          /*  SHS: Commented below condition and else condition lines i.e if condition and else condition
          if(strRouteBy.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode)){*/
                
                // Note Avoided else statement need to check each and every if condition
                if(!routingGroupList.isEmpty())
                    routing = routingGroupList.get(0);
                                
                // The information matches most we pick that rule   
                if(!MapRuleViaMatchCount.IsEmpty()){
                    String strRouteId = finalizeSameRule(MapRuleViaMatchCount);
                    if(strRouteId != null)
                        routing = MapIdVsRouteTable.get(strRouteId);
                }
                
                if(!lstRoutingwithPriority.IsEmpty()){
                    /*SHS: Added below line for roundrobin algorithm and commented next line which assigns
                     rules only for the owner with less count*/
                    routing =retrieveruleName(MapDynamicruleAllocationdateMap,lstRoutingwithPriority);
                    //routing = retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority);
                }
         /*   } 
            else
            { 
                System.debug('Grouping Size ==>'+lstRoutingwithPriority);
                System.debug('routingGroupList ==>'+routingGroupList);
                routing = !lstRoutingwithPriority.IsEmpty() ? retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority): routingGroupList.get(0);
            }*/
            if(routing == null){
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;
            }
                
            // Do_Not_Route__c and converted lead will not get routed
            if (leadNew.Do_Not_Route__c){
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue; // routing turned off
            }
            
            if (leadNew.IsConverted){
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;
            }
            
            // Debug userMap
            //bys shs system.debug('Lead_RouteByRecruiting.applyRouting(): applying owner = ' + routing.Routed_To__c);
            
            // Apply the owner
            
            if(routing.Routed_To__c != null){
                leadNew.OwnerId = routing.Routed_To__c;
                objDynamicRoutingResult.bIsRouted = true;
                //bIsRouted = true;
            }
            
            // Override the region?
            if (RoutingAnalysis.getSetting().Override_Lead_Region__c == true && routing.Region__c == null && RoutingAnalysis.getSetting().Override_When_Blank__c == true) {
                leadNew.Region__c = routing.Region__c;
                //leadNew.Sub_Region__c = routing.Sub_Region__c; commented by Anil.B on 11-11-2014
            }
            
            if (RoutingAnalysis.getSetting().Override_Lead_Region__c == true && routing.Region__c != null) {
                leadNew.Region__c = routing.Region__c;
               // leadNew.Sub_Region__c = routing.Sub_Region__c; commented by Anil.B on 11-11-2014
            }
            lstDynamicRoutingResult.add(objDynamicRoutingResult);
        }
        
        //return bIsRouted;
        return lstDynamicRoutingResult;
    }
    
    public static String finalizeSameRule(Map<String,Integer> MapRuleVsParamCount){
        String strRouteId;
        Integer iTempCount = 0;
        for(String strKey : MapRuleVsParamCount.keyset()){
            if(iTempCount < MapRuleVsParamCount.get(strKey)){
                iTempCount = MapRuleVsParamCount.get(strKey);
                strRouteId = strKey;
            }
        }
        return strRouteId;
    } 
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Contact[]
        Return Type : Routing_Table__c[]
        Summary     : Function will accepts the list of contact and fires the query on the routing table
        Note        : It will returns all type of routing rules                 
    */
   public static RoutingTableListInfo getRoutingTableList(Lead[] leadList)
   {
        Set<String> leadCountryIdSet = new Set<String> { null };
        Set<String> leadCountrySet = new Set<String> { null };
        Set<String> leadStateSet = new Set<String> { null };
        Set<String> leadDepartmentSet = new Set<String> { null };
        Set<String> leadSourceSet = new Set<String> { null };
        Set<String> leadStatusSet = new Set<String> { null };
        
        // Specially for Zip based routing
        String lowerBound,upperBound;
        
        // Now search the leads
        for(Lead lead : leadList) {
            leadCountryIdSet.add(lead.Country_Of_Residence__c);
            leadStateSet.add(lead.State);
            leadDepartmentSet.add(lead.Department_Name_Primary__c);
            leadSourceSet.add(lead.LeadSource);
            leadStatusSet.add(lead.Status);
            
            if(lead.PostalCode == null || lead.PostalCode =='')
              continue;
            
                String postalCode = String.valueOf(lead.PostalCode).trim();
                Pattern dollarPattern = Pattern.compile('[^0-9]');//shs:commented for remove all spcl chars('[a-z]|[A-Z]');
                postalCode = dollarPattern.matcher(postalCode).replaceAll('').replaceAll(' ','');
                
                if(PostalCode == null || PostalCode == '')
                    continue;
              
                if(lowerBound == null || lowerBound == '')
                    lowerBound = postalCode;
                else{
                    lowerBound =dollarPattern.matcher(lowerBound).replaceAll('').replaceAll(' ','');
                    if(long.valueOf(lowerBound) > long.valueOf(postalCode))
                    lowerBound = postalCode;
                }
                
                if(upperBound == null || upperBound == '')
                    upperBound = postalCode;
                else{
                    upperBound =dollarPattern.matcher(upperBound).replaceAll('').replaceAll(' ','');
                     if(long.valueOf(upperBound) < long.valueOf(postalCode))
                    upperBound = postalCode;
                }
            
            //Zip Based routing
            //String postalCode = RoutingAnalysis.getStandardizedPostalCode(contact.MailingPostalCode, contact.Country_Of_Residence_Name__c);
           /* String postalCode = lead.PostalCode;
            
            // Set the bounds
            if (lowerBound == null || lowerBound > postalCode)
                lowerBound = postalCode;
            if (upperBound == null || upperBound < postalCode)
                upperBound = postalCode;*/
        }
        
        // When these leads are coming in from the analysis tool, the formulas won't populate the departments
        // properly, so we have to do a manual search. We can tell if this is the origin, because the lead list
        // will be only 1 record long.
        if (leadList.size() == 1) {
            for(Program__c program : [
                select Department__r.Name
                  from Program__c
                 where Id = :leadList[0].Program_Primary__c
            ]) leadDepartmentSet.add(program.Department__r.Name);
        }
        
        // Special handling for the country of residence
        leadCountrySet = getCountryNameByCountryId(leadCountryIdSet);
        
        RoutingParameterInfo objRoutingParameterInfo    = new RoutingParameterInfo();
        objRoutingParameterInfo.leadCountrySet      = leadCountrySet;
        objRoutingParameterInfo.leadDepartmentSet   = leadDepartmentSet;
        objRoutingParameterInfo.leadStateSet        = leadStateSet;
        objRoutingParameterInfo.lowerBound          = lowerBound;
        objRoutingParameterInfo.upperBound          = upperBound;
        
        // Not sure abotu the Parameters
        objRoutingParameterInfo.leadStatusSet       = leadStatusSet;
        objRoutingParameterInfo.leadSourceSet       = leadSourceSet;
        /*//bys shs 
        System.debug('Paramter 1] leadCountrySet        ===>'+leadCountrySet);
        System.debug('Paramter 2] leadDepartmentSet     ===>'+leadDepartmentSet);
        System.debug('Paramter 3] leadStateSet      ===>'+leadStateSet);
        */
        List<Routing_Table__c> lstByZipRouting     = database.query(createRoutingQuery(objRoutingParameterInfo,RoutingAnalysis.RoutingTypePostalCode));
        List<Routing_Table__c> lstByRecruitRouting = database.query(createRoutingQuery(objRoutingParameterInfo,''));
        /*//bys shs 
        System.debug('lstByZipRouting 4] lstByZipRouting ===>'+lstByZipRouting);
        System.debug('lstByZipRouting 5] lstByZipRouting ===>'+lstByRecruitRouting);
        */
        RoutingTableListInfo objRoutingTableListInfo = new RoutingTableListInfo(lstByZipRouting,lstByRecruitRouting);
        
        return objRoutingTableListInfo;
   }
    
   /*
        Created By  : Niket Chandane
        Created At  : 24 July 2012
        Parameters  : String , String
        Return Type : Boolean
        Summary     : Function will accepts to Strings and checked both are same or not
                        and send result in boolean format
    */
    public static Boolean definitiveNotMatched(String value1, String value2){
        /*return value1 != null && value2 != null && value1.equalsIgnoreCase(value2) == false;*/
        if(value1 != null && value2 != null)
            return !value1.equalsIgnoreCase(value2);
        else if(value1 == null && value2 == null)
            return false;
        else if(value1 == null && value2 != null)
            return false;
        else return true;
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : RoutingParameterInfo , String  
        Return Type : String
        Summary     : Function accepts the RoutingParameterInfo and strRoutingBase 
                      as a parameter creates a dynamic query depends upon the strRoutingBase   
    */
    
    public static String createRoutingQuery(RoutingParameterInfo objRouting, String strRoutingBase){
        /*+' and Lead_Source__c in : objRouting.leadSourceSet'
                 +' and Lead_Status__c in : objRouting.leadStatusSet'*/
        String strQuery = 'select Name'
                 +', Age_Range__c'
                 +', City__c'
                 +', Country__c'
                 +', Comment__c'
                 +', Department__c'
                 +', Department__r.Name'
                 +', Granularity__c'
                 +', Lead_Source__c'
                 +', Lead_Status__c'
                 +', Priority__c'
                 +', Priority_Value__c'
                 +', Priority_Grouping__c'
                 +', Region__c'
                 +', Routed_By__c'
                 +', Routed_To__c'
                 +', State__c'
                 +', Sub_Region__c'
                 +', Work_Load__c'
                 +', Lower_Bound__c'
                 +', Upper_Bound__c'
                 +', Last_Roule_Applied_Date__c'
                 +', Routed_Records__c'
                 +' from Routing_Table__c'
                 +' where Is_Active__c = true'
                 +' and Country__c in : objRouting.leadCountrySet'
                 +' and State__c in : objRouting.leadStateSet'
                 +' and Department__r.Name in : objRouting.leadDepartmentSet';
               if(!IsNullOrEmpty(objRouting.lowerBound) && !IsNullOrEmpty(objRouting.upperBound) && 
                    strRoutingBase.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode))
                {
                    strQuery += ' and (Lower_Bound__c <= :lowerBound or Upper_Bound__c >= :upperBound)';
                    strQuery += ' and (Lower_Bound__c != null and Upper_Bound__c != null)';
                }
            strQuery += ' order by Priority_Value__c desc, Granularity__c desc';
        return strQuery;
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : String 
        Return Type : Boolean
        Summary     : Utility Function will accepts to Strings and check that is 
                      Is Null and Is Empty
    */
    public static Boolean IsNullOrEmpty(String strString){
        return (strString == null || ''.equals(strString)) ? true : false;
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Set<String> (contactCountryIdSet)
        Return Type : Set<String>
        Summary     : Function will accepts the set of Country Id and returns the 
                      Set of Country Name
    */
    public static Set<String> getCountryNameByCountryId(Set<String> contactCountryIdSet){
        Set<String> contactCountrySet = new Set<String>{null};
        for(Country__c country : [select Name from Country__c where Id in :contactCountryIdSet]) 
            contactCountrySet.add(country.Name);
        
        return contactCountrySet;
    }
    
    /*
        Created by  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Set<Id>
        Return Type : Map<String,Integer>
        Summary     : Method accepts the set of user id and returns the Map User Id and it's Owner Ship count 
                      for applicant
    */
    public static Map<String,Integer> getDynamicUserAllocationMap(Set<ID> userId){
        Map<String,Integer> MapUserIdAllocation = new Map<String,Integer>();
        for(AggregateResult objAgg : [Select Count(Id),ownerId From Lead where ownerId in : userId group by ownerId])
            MapUserIdAllocation.put(String.ValueOf(objAgg.get('ownerId')),Integer.valueOf(objAgg.get('expr0')));
        
        for(Id objUserId : userId)
            if(!MapUserIdAllocation.containsKey(objUserId))
                MapUserIdAllocation.put(objUserId,0);
        return MapUserIdAllocation;
    }
    
    /*
        Created By : Harsha Simha
        Created At : 29/8/2012
        Parameters : List<Routing_Table__c>
        Return type: map<string,Datetime>
        Summary    : Method returns map of routing rule Last Rule applied Date value.
    */
    public static Map<string,Datetime> getDynamicruleAllocationdateMap(List<Routing_Table__c> routingruleslist)
    {
        Map<String,Datetime> MapruledateAllocation = new Map<String,Datetime>();
        for(Routing_Table__c rt:routingruleslist)
        {
            MapruledateAllocation.put(rt.Id,rt.Last_Roule_Applied_Date__c);
        }
        return MapruledateAllocation;
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Map<String,Id> UserMap
        Return Type : Routing_Table__c[]
        Summary     : To avoid duplicate user Id as value
    */ 
    public static Set<Id> collectRoutingUserId(Map<String,Id> UserMap){
        Set<Id> SetuserId = new Set<Id>();
        
        for(Id UserId : UserMap.Values())
            SetuserId.add(UserId);
        return SetuserId;
    }
    
    /*
        Created By  : Niket Chandane
        Created At  : 27 July 2012
        Parameters  : Map<String,Integer> , Routing_table__c[]
        Return Type : Routing_Table__c
        Summary     : Function will accepts to Strings and checked both are same or not
                        and send result in boolean format
    */
    public static Routing_Table__c retrieveOwnerName(map<String,Integer> MapDynamicUserAllocationMap ,Routing_Table__c[] lstRouting){
        Integer firstUserCount = 0;
        Integer minCount = 0;
        Boolean bfirst = true;
        Id idOfUser = null;
        
        for(Routing_Table__c r: lstRouting)
        {
            if(MapDynamicUserAllocationMap.containsKey(r.Routed_To__c))
            {                   
                firstUserCount  = MapDynamicUserAllocationMap.get(r.Routed_To__c);
                if(bfirst){
                    minCount = firstUserCount;
                    idOfUser = r.Routed_To__c;
                }
                if(firstUserCount <= minCount && bfirst == false){
                    minCount = firstUserCount;
                    idOfUser = r.Routed_To__c;
                }
                bfirst  = false;
            }
        }
            
        minCount++;
        if(idOfUser != null)
            MapDynamicUserAllocationMap.Put(idOfUser,minCount);
             
        for(Routing_Table__c r: lstRouting){
            if(String.valueOf(r.Routed_To__c).equals(idOfUser))
              return r;
        }
        return null;
    }
    
    
    /*
        Created By  : Harsha Simha S
        Created At  : 8/27/2012
        Parameters  : Map<String,Datetime> , Routing_table__c[]
        Return Type : Routing_Table__c
        Summary     : Method will check the lowest last updated rule and returns the lowest last updated rule 
    */
    public static Routing_Table__c retrieveruleName(map<String,Datetime> MapDynamicruleAllocationdateMap ,Routing_Table__c[] lstRouting)
    {   
        datetime initdt;
        datetime mindt;
        Boolean bfirst = true;
        string toprule;
        for(Routing_Table__c r:lstRouting)
        {
            if(MapDynamicruleAllocationdateMap.containsKey(r.Id))
            {
                initdt=MapDynamicruleAllocationdateMap.get(r.Id)==null?datetime.now():MapDynamicruleAllocationdateMap.get(r.Id);
                if(bfirst)
                {
                    mindt=initdt;
                    toprule=r.Id;
                }
                if(initdt<=mindt && !bfirst)
                {   
                    mindt=initdt;
                    toprule=r.Id;
                }
                bfirst=false;
            }
        }       
        if(toprule!=null)
        {
            MapDynamicruleAllocationdateMap.put(toprule,datetime.Now());
        }
        for(Routing_Table__c r: lstRouting){
            if(r.Id==toprule){
                if(maproutetables.containskey(r.Id))
                {
                    Routing_Table__c r1=maproutetables.get(r.Id);                   
                    r1.Last_Roule_Applied_Date__c=Datetime.now();
                    r1.Routed_Records__c=r1.Routed_Records__c==null?1:(r1.Routed_Records__c+1);
                    r.Routed_Records__c=r1.Routed_Records__c;
                    updatertble.add(r1);
                    maproutetables.put(r1.Id,r1);
                }
              return r;
            }
        }
        return null;
    }
    
    /*
        Class       : RoutingException
        Created by  : Niket Chandane
        Summary     : RoutingException class used for RoutingException (Custom Development)
    */
    public class RoutingException extends Exception {}
    
    /*
        Class       : RoutingParameterInfo
        Created By  : Niket Chandane
        Summary     : The class object holding routing parameters
                        on which we can select routing rule 
    */
   // Inner class to store the routing parameters to get the routing records
    public class RoutingParameterInfo{
        Set<String> leadCountrySet = new Set<String> { null };
        Set<String> leadStateSet = new Set<String> { null };
        Set<String> leadDepartmentSet = new Set<String> { null };
        Set<String> leadSourceSet = new Set<String> { null }; 
        Set<String> leadStatusSet = new Set<String> { null };
        String lowerBound,upperBound;
    }
    
   // Inner class to store RoutingTableList of Zip based or Recruit based
   public class RoutingTableListInfo{
        List<Routing_Table__c> lstByZipRouting = new List<Routing_Table__c>();
        List<Routing_Table__c> lstByRecruitRouting = new List<Routing_Table__c>();
        public RoutingTableListInfo(List<Routing_Table__c> lstByZipRouting,List<Routing_Table__c> lstByRecruitRouting){
            this.lstByZipRouting    = lstByZipRouting;
            this.lstByRecruitRouting= lstByRecruitRouting;
        }
   }
   
   // Inner class for Bulk dynamic routing 
   public class DynamicRoutingResult{
      Lead objLead = new Lead();
      Boolean bIsRouted = false;
   }
}