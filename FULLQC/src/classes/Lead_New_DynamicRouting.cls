/*
    Developer   : Harsha Simha.S
    Date        : 1/15/2013    
    Summary     : Used for Routing Leads, This class is overwritten from Lead_DynamicRouting as RoutebyPostalcode is completely removed!
    TestClass   : Lead_New_DynamicRoutingTest(77%)
    Modified by: Anil.B on 11/11/2014 commented Sub_Region__c field value updation 
*/
public with sharing class Lead_New_DynamicRouting extends LeadExtension {
    final Id leadId;
    static set<Routing_Table__c> updatertble;
    static map<Id,Routing_Table__c> maproutetables;
    public Lead curr_lead;
    
    public Lead_New_DynamicRouting(ApexPages.StandardController controller) {
        super(controller);
        this.leadId = controller.getId();
        curr_lead=(Lead)controller.getRecord();
        curr_lead = [Select LBR_d_once__c,Do_Not_Route__c From Lead l where id =: leadId limit 1][0];
    }
    
    /* sets  Lead to LBR*/
    public PageReference execute() {
        if(!curr_lead.Do_Not_Route__c && !curr_lead.LBR_d_once__c)
            update new Lead(Id = leadId, Apply_Routing_Type__c = RoutingAnalysis.RoutingTypeRecruiting);
        return new PageReference('/' + leadId);
    }
    
    /* Starts LBR for list of leads sent as parameter*/
    public static void applyRouting(Lead[] leadNewList)
    {
      if(leadNewList == null && leadNewList.IsEmpty())
        return;
        updatertble=new set<Routing_Table__c>();
        maproutetables=new map<id,Routing_Table__C>();
        
        /*gets list of routing rules applicable for the leads*/      
        RoutingTableListInfo objRoutingTableListInfo = getRoutingTableList(leadNewList);
        if(objRoutingTableListInfo.lstByRecruitRouting.IsEmpty())
            return;
      
        /*List of routing Rules and leads are passed to the Routing Process and if any LBR is done then Rules are updated with latest count!*/
        
        for(Routing_table__c r:objRoutingTableListInfo.lstByRecruitRouting){maproutetables.put(r.Id,r);}
        List<DynamicRoutingResult> lstresult2 = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, leadNewList, RoutingAnalysis.RecordTypeRecruiting);
        if(lstresult2.IsEmpty()) return;
        updaterulescount();       
        System.debug('Via Recruiting Routing result ===>'+lstresult2);
      
    }
    
    
    
    /*  accepts the list of Leads and fires the query on the routing table based on the leads country,state,city,Department and returns all type of routing rules      */
   public static RoutingTableListInfo getRoutingTableList(Lead[] leadList)
   {
       Set<String> leadCountryIdSet = new Set<String> { null };
        Set<String> leadCountrySet = new Set<String> { null };
        Set<String> leadStateSet = new Set<String> { null };
        Set<String> leadCitySet = new Set<String> { null };
        Set<String> leadDepartmentSet = new Set<String> { null };        
        for(Lead lead: leadList) {
            leadCountrySet.add(lead.Country_Of_Residence_Name__c); // only if available; may not be populated from the analysis tool.
            leadCountryIdSet.add(lead.Country_Of_Residence__c);
            leadStateSet.add(lead.State);
            leadCitySet.add(lead.City);
            leadDepartmentSet.add(lead.Department_Name_Primary__c);                        
        }
        leadCountrySet = getCountryNameByCountryId(leadCountryIdSet);
        
        if (leadList.size() == 1) {
            for(Program__c program : [
                select Department__r.Name
                  from Program__c
                 where Id = :leadList[0].Program_Primary__c
            ]) leadDepartmentSet.add(program.Department__r.Name);
        }
        
        RoutingParameterInfo objRoutingParameterInfo   = new RoutingParameterInfo();
        objRoutingParameterInfo.leadCountrySet     = leadCountrySet;
        objRoutingParameterInfo.leadDepartmentSet   = leadDepartmentSet;
        objRoutingParameterInfo.leadStateSet     = leadStateSet;
        objRoutingParameterInfo.leadCitySet     = leadCitySet;
        
        System.debug('Paramter 1] leadCountrySet      ===>'+leadCountrySet);
        System.debug('Paramter 2] leadDepartmentSet   ===>'+leadDepartmentSet);
        System.debug('Paramter 3] leadStateSet        ===>'+leadStateSet);
        System.debug('Paramter 3] lead_CitySet        ===>'+leadCitySet);
        
        List<Routing_Table__c> lstByRecruitRouting = database.query(createRoutingQuery(objRoutingParameterInfo));
        
        System.debug('lstByRecruitRouting 5] lstByZipRouting ===>'+lstByRecruitRouting);        
        RoutingTableListInfo objRoutingTableListInfo = new RoutingTableListInfo(lstByRecruitRouting);        
        return objRoutingTableListInfo;
   }
   
   /*returns country name for the given country ids.*/
   public static Set<String> getCountryNameByCountryId(Set<String> leadCountryIdSet){
      Set<String> leadCountrySet = new Set<String> { null };
      for(Country__c country : [select Name from Country__c where Id in :leadCountryIdSet]) 
        leadCountrySet.add(country.Name);        
        return leadCountrySet;
    }
    /*If LBR is done then Routing Rule count and Last routed date is updated*/
    public static void updaterulescount()
    {
      if(!updatertble.ISEmpty())
      {
        list<Routing_Table__c> updrrules=new list<Routing_Table__c> ();
        updrrules=[select id,Name,Routed_To__c, Last_RuleApplied_Date_LEAD__c, Routed_Records_LEAD__c from Routing_Table__c where id IN:updatertble];
        for(integer i=0;i<updrrules.size();i++)
        {
          if(maproutetables.containsKey(updrrules[i].Id))
          {  Routing_Table__c r=maproutetables.get(updrrules[i].Id);
            updrrules[i].Last_RuleApplied_Date_LEAD__c=r.Last_RuleApplied_Date_LEAD__c;
            updrrules[i].Routed_Records_LEAD__c=r.Routed_Records_LEAD__c;
          }
        }
        if(!updrrules.Isempty())
        {
          try{update updrrules;}catch(Exception e){system.Debug('------'+e);}
        }
      }
    }
    
    /*returns Routing table query string */
    public static String createRoutingQuery(RoutingParameterInfo objRouting){
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
                 +', Postal_Code__c'
                // +', Wildcad_Postcode__c'
                 +', Work_Load__c'
                 +', Lower_Bound__c'
                 +', Upper_Bound__c'
                 +', Last_RuleApplied_Date_LEAD__c'
                 +', Routed_Records_LEAD__c'
                 +' from Routing_Table__c'
                 +' where Is_Active__c = true'
                 +' and Country__c in : objRouting.leadCountrySet'                 
                 +' and Department__r.Name in : objRouting.leadDepartmentSet'
                 +' and State__c in : objRouting.leadStateSet'
                 +' and City__c in : objRouting.leadCitySet'
                 +' order by Priority_Value__c desc, Granularity__c desc';
        return strQuery;
    }
    
    /*Leads will be routed based on their values with the applicable routing rules*/
    public static List<DynamicRoutingResult> applyRoutingDynamicRouting(Routing_Table__c[] routingList ,Lead[] leadNewList,String strRouteBy)
    {
               
          System.debug('strRouteBy ==>'+strRouteBy+' == First Routing List =====>'+routingList);
          
          
          /*Routing result for bulk update*/
          List<DynamicRoutingResult> lstDynamicRoutingResult = new List<DynamicRoutingResult>(); 
          
          // We need to clear apply routing for all type of recordTypes
          for(Lead leadNew : leadNewList)
              leadNew.Apply_Routing_Type__c = null;
              
              
            // Map of UserName Vs User Id  ,queue id
            final Map<String, Id> routingQueueMap = RoutingAnalysis.getRoutingQueueMap(routingList);
            final Map<String, Id> routingUserMap = RoutingAnalysis.getRoutingUserMap(routingList);
            
            // Collect the dynamic User Map with Ownership
         //   Map<String,Integer> MapDynamicUserAllocationMap = getDynamicUserAllocationMap(collectRoutingUserId(routingUserMap));
          
          //SHS: Collects the Rules Last Routed Date
          Map<String,Datetime> MapDynamicruleAllocationdateMap = getDynamicruleAllocationdateMap(routingList);
          
        // Rewrite the routing table with the actual ids
       for(Routing_Table__c routing : routingList) {
            if (RoutingAnalysis.RoutedByQueueName.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = routingQueueMap.get(routing.Routed_To__c);
            if (RoutingAnalysis.RoutedByUserName.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = routingUserMap.get(routing.Routed_To__c);
        }
        
        
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
        system.debug('Lead_RouteByRecruiting.applyRouting(): countryNameMap = ' + countryNameMap);//bys shs
      /***********************************************************************************************************************/
      // Actual routing        
        System.debug('Size ============>'+leadNewList.size());        
        for(Lead leadNew : leadNewList)
        {
          /*Assigning each contact result for bulk data */
          DynamicRoutingResult objDynamicRoutingResult = new DynamicRoutingResult();
          objDynamicRoutingResult.objlead = leadNew;
          objDynamicRoutingResult.bIsRouted = false;
          
          /*If Lead is Converted or Lead DoNotToute or LBRdOnce is true then that lead is not sent to routing process!*/  
          if (leadNew.IsConverted)
          {
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;
          }
          if (leadNew.Do_Not_Route__c == true)
          {    
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;            
          }
          if(leadNew.LBR_d_once__c)
          { 
                lstDynamicRoutingResult.add(objDynamicRoutingResult);
                continue;            
          }
              
          Routing_Table__c routing;
          String strRoutingKey;
          String routingGroup = null;
          String postalCode;
          Map<String,Integer> MapRuleViaMatchCount = new Map<String,Integer>();
          Map<String,Routing_Table__c> MapIdVsRouteTable = new Map<String,Routing_Table__c>();
          
            Routing_Table__c[] routingGroupList = new Routing_Table__c[] {};
            List<Routing_Table__c> lstRoutingwithPriority = new List<Routing_Table__c>();
            
            System.debug('Lead :: '+leadNew.Name+' ==routingList ==>'+routingList);
            boolean prior_routing=false;
            integer ptycount=0;
            /*current lead is iterated through all the rules that are applicable and the best applcable is selected*/
            for(Routing_Table__c r : routingList)
            {
              Integer iRoutingParameterCount = 0;
              MapIdVsRouteTable.put(r.Id,r);
              
                if (r.Routed_To__c == null)
                    continue;
                /* NOTE: r.Region__c is ignored for routing purposes. 
                shs:11/6/2012:if postal code Routing then state should not match!*/
                if (definitiveNotMatched(r.Country__c, LeadNew.Country_Of_Residence_Name__c))
                   continue;
                if (definitiveNotMatched(r.State__c, LeadNew.State))
                   continue;
                if (definitiveNotMatched(r.Department__r.Name, LeadNew.Department_Name_Primary__c))
                  continue;
                if (definitiveNotMatched(r.City__c, LeadNew.City))
                  continue;  
                
                /* Grouping logic: add only High priority matches for which we can do load balancing*/
                if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c))
                {
                    /* New Development to get most accurate result */
                    if (LeadNew.Country_Of_Residence_Name__c != null && LeadNew.Country_Of_Residence_Name__c.equalsIgnoreCase(r.Country__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (leadNew.State != null && leadNew.State.equalsIgnoreCase(r.State__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (leadNew.City != null && leadNew.City.equalsIgnoreCase(r.City__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (leadNew.Department_Name_Primary__c != null && leadNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    } 
                    routingGroup = r.Priority__c;
                    routingGroupList.add(r);
                    if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                    {
                        integer i=0;
                        if((leadNew.Country_Of_Residence_Name__c==null && r.Country__c==null)||(leadNew.Country_Of_Residence_Name__c!=null && leadNew.Country_Of_Residence_Name__c.equalsIgnoreCase(r.Country__c)))
                            i++;
                        if((leadNew.Department_Name_Primary__c==null && r.Department__r.Name==null)||(leadNew.Department_Name_Primary__c!=null && leadNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)))
                            i++;
                        if((leadNew.State==null && r.State__c==null)||(leadNew.State!=null && leadNew.State.equalsIgnoreCase(r.State__c)))
                            i++;
                        if((leadNew.City==null && r.City__c==null)||(leadNew.City!=null && leadNew.City.equalsIgnoreCase(r.City__c)))
                            i++;
                            
                        if(lstRoutingwithPriority.IsEmpty())
                        {                    
                            ptycount=i;                 
                            lstRoutingwithPriority.add(r);
                        }
                        else
                        {
                            if(ptycount==i)
                            {
                                lstRoutingwithPriority.add(r);
                            }
                            else if(ptycount<i)
                            {
                                lstRoutingwithPriority.clear();
                                lstRoutingwithPriority.add(r);
                                ptycount=i;
                            }
                        }
                    }
                }
            }
            
            if(lstRoutingwithPriority.Isempty() && routingGroupList.IsEmpty() && MapRuleViaMatchCount.IsEmpty()){
              lstDynamicRoutingResult.add(objDynamicRoutingResult);
              continue;
            }
            
              system.debug('lstRoutingwithPriority =============>'+lstRoutingwithPriority);
              system.debug('routingGroupList =============>'+routingGroupList);        
              //system.debug('User Load MapDynamicUserAllocationMap =>'+MapDynamicUserAllocationMap);
              system.debug('Rule Load MapDynamicruleAllocationdateMap =>'+MapDynamicruleAllocationdateMap);
              /* Note Avoided else statement need to check each and every if condition */
              if(!routingGroupList.isEmpty()){
                System.debug('Inside Group List leadNew =======>'+leadNew.Name+' :: routing to ::'+routingGroupList);
                routing = routingGroupList.get(0);
              }
              
              // The information matches most we pick that rule  
              if(!MapRuleViaMatchCount.IsEmpty()){
                String strRouteId = finalizeSameRule(MapRuleViaMatchCount);
                if(strRouteId != null)
                  routing = MapIdVsRouteTable.get(strRouteId);
                System.debug('Inside Max Parameter leadNew =======>'+leadNew.Name+' :: routing to ::'+routing);  
              }
              
              if(!lstRoutingwithPriority.IsEmpty()){
                /*SHS: Added below line for roundrobin algorithm and commented next line which assigns
                 rules only for the owner with less count*/
                routing =retrieveruleName(MapDynamicruleAllocationdateMap,lstRoutingwithPriority);
                prior_routing=true;
                //routing = retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority);
                System.debug('Inside with priority leadNew =======>'+leadNew.Name+' :: routing to ::'+routing);
              }
                          
            if(routing == null){
              lstDynamicRoutingResult.add(objDynamicRoutingResult);
              continue;
            }
            /*handles null assignment of Owner to the lead in Load Balanced Routing */
            if(routing.Routed_To__c != null){      
              leadNew.OwnerId = routing.Routed_To__c;
              objDynamicRoutingResult.bIsRouted = true;
              /*Below condition added to check : if priority routing is to be set to true and this acts like  do not route field functionality*/
              if(prior_routing)
              {
                leadNew.LBR_d_once__c=true;
              }              
              if(maproutetables.containsKey(routing.Id))
              {
                system.debug(maproutetables.get(routing.Id)+'====');
                updatertble.add(maproutetables.get(routing.Id));
              }
              System.debug('routing =============>'+leadNew.OwnerId+' :: leadNew ::'+leadNew.Id);
            }
            // Override the region?
            if (RoutingAnalysis.getSetting().Override_lead_Region__c == true && routing.Region__c == null && RoutingAnalysis.getSetting().Override_When_Blank__c == true) {
                leadNew.Region__c = routing.Region__c;
               // leadNew.Sub_Region__c = routing.Sub_Region__c;  commented by Anil.B on 11-11-2014
            }
          if (RoutingAnalysis.getSetting().Override_lead_Region__c == true && routing.Region__c != null) {
                leadNew.Region__c = routing.Region__c;
               // leadNew.Sub_Region__c = routing.Sub_Region__c;   commented by Anil.B on 11-11-2014
             }
             lstDynamicRoutingResult.add(objDynamicRoutingResult);
           }
      return lstDynamicRoutingResult;
    }
    
    
    /*For the list of rules with high priority last rule applied date is applied!*/
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
          initdt=MapDynamicruleAllocationdateMap.get(r.Id)==null?Datetime.now():MapDynamicruleAllocationdateMap.get(r.Id);
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
            r1.Last_RuleApplied_Date_LEAD__c=Datetime.now();
            r1.Routed_Records_LEAD__c=r1.Routed_Records_LEAD__c==null?1:(r1.Routed_Records_LEAD__c+1);
            r.Routed_Records_LEAD__c=r1.Routed_Records_LEAD__c;
            updatertble.add(r1);
            maproutetables.put(r1.Id,r1);            
          } 
          return r;
        }
      }
      return null;
    }
    
    /*For the list of rules with matching count. Rule with highest Matching is returned*/
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
    
    /*checks whether 2 strings matches or not!*/
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
   public static Map<String,Integer> getDynamicUserAllocationMap(Set<ID> userId){
       Map<String,Integer> MapUserIdAllocation = new Map<String,Integer>();
       for(AggregateResult objAgg : [Select Count(Id),ownerId From Lead where ownerId in : userId group by ownerId])
          MapUserIdAllocation.put(String.ValueOf(objAgg.get('ownerId')),Integer.valueOf(objAgg.get('expr0')));
        
        for(Id objUserId : userId)
          if(!MapUserIdAllocation.containsKey(objUserId))
            MapUserIdAllocation.put(objUserId,0);
        return MapUserIdAllocation;
   }
    */
    
    /*returns map of routing rule Last Rule applied Date value.*/
    public static Map<string,Datetime> getDynamicruleAllocationdateMap(List<Routing_Table__c> routingruleslist)
    {
      Map<String,Datetime> MapruledateAllocation = new Map<String,Datetime>();
      for(Routing_Table__c rt:routingruleslist)
      {
        MapruledateAllocation.put(rt.Id,rt.Last_RuleApplied_Date_LEAD__c);
      }
      return MapruledateAllocation;
    }
    
   /*avoids duplicate user Id as value    */ 
     public static Set<Id> collectRoutingUserId(Map<String,Id> UserMap){
      Set<Id> SetuserId = new Set<Id>();
      
      for(Id UserId : UserMap.Values())
        SetuserId.add(UserId);
      return SetuserId;
    }
    
    /*RoutingException class used for RoutingException (Custom Development)    */
    public class RoutingException extends Exception {}
    
    /*RoutingParameterInfo class used for collecting Lead Values to check in Routing Rules*/
    public class RoutingParameterInfo{
            Set<String> LeadCountrySet = new Set<String> { null };
            Set<String> LeadStateSet = new Set<String> { null };
            Set<String> LeadDepartmentSet = new Set<String> { null };
            Set<String> LeadCitySet = new Set<String> { null };     
            //Integer lowerBound,upperBound;
    }
        
    /* Inner class to store RoutingTableList of Recruit based*/
    public class RoutingTableListInfo{        
           List<Routing_Table__c> lstByRecruitRouting = new List<Routing_Table__c>();
           public RoutingTableListInfo(List<Routing_Table__c> lstByRecruitRouting){          
             this.lstByRecruitRouting= lstByRecruitRouting;
           }
    }
    /* Inner class to maintain lead info*/
    public class DynamicRoutingResult{
     Lead objlead = new Lead();
     Boolean bIsRouted = false;
   }
}