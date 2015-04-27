/*
  Change Log 
-----------------------------------------------------------------------------------------------------------------------------
  Date       Owner        Comment
-----------------------------------------------------------------------------------------------------------------------------
  24/7/2012    Niket Chandane      Contact routing will work for Rcruiting as well as it 
                    will work for the Zip code.
                    - Priority grouping and load balancing will happen for 
                      the Zip code/Recruiting
  27/7/2012    Niket Chandane    Added new method "applyRoutingDynamicRouting" provided full support
                    Zip code and Load balancing + old recruiting
  28/8/2012    Harsha Simha    Added new Logic for Roundrobin routing based on the lastRoutedDate in Routing Table
                    and applied same for Other than postalcode type recruiting
*/
public without sharing class Contact_DynamicRouting extends ContactExtension {
  final Id contactId;
    final String contactRoutingType;
    
    static integer bf = 0;
    static set<Routing_Table__c> updatertble;
    static map<Id,Routing_Table__c> maproutetables;
    
    public Contact_DynamicRouting(ApexPages.StandardController controller){
        super(controller);
        this.contactId = controller.getId();
        Contact objCon = (Contact)controller.getRecord();
        objCon.Apply_Routing_Type__c = [Select c.Apply_Routing_Type__c From Contact c where id =: contactId limit 1][0].id;
        this.contactRoutingType = objCon.Apply_Routing_Type__c;
    }
  
  /* 
    Note : Currently we are adding flag recruiting but actual routing will 
        happen depends upon the applicant data
   */
  public PageReference execute(){
      PageReference newPage;
      if(this.contactRoutingType != RoutingAnalysis.RoutingTypeRecruiting)
        update new Contact(Id = contactId, Apply_Routing_Type__c = RoutingAnalysis.RoutingTypeRecruiting);
        
        newPage = new PageReference('/' + contactId);
      return newPage.setRedirect(true);
    }
    
    /*
      Created By   : Niket Chandane
      Created At   : 27 July 2012
      Parameters   : Contact[] contactNewList
      Return Type  : void
      Summary   : Function will accepts the list of contact apply the 
              routing engine rules and route the contact to respective user
    */
    public static void applyRoutingDynamicRouting(Contact[] contactNewList){
      if(contactNewList == null && contactNewList.IsEmpty())
        return;
        updatertble=new set<Routing_Table__c>();
        maproutetables=new map<id,Routing_Table__C>();
      /* Getting all the routing tables (Zip Based and Recruiting based) related with the Applicant data */
      RoutingTableListInfo objRoutingTableListInfo = getRoutingTableList(contactNewList);
      if(objRoutingTableListInfo.lstByZipRouting.IsEmpty() && objRoutingTableListInfo.lstByRecruitRouting.IsEmpty())
        return;
      
      for(Routing_table__c r:objRoutingTableListInfo.lstByZipRouting){maproutetables.put(r.Id,r);}
      for(Routing_table__c r:objRoutingTableListInfo.lstByRecruitRouting){maproutetables.put(r.Id,r);}
      /* Existing logic */
      /*if(!applyRoutingDynamicRouting(objRoutingTableListInfo.lstByZipRouting, contactNewList, RoutingAnalysis.RoutingTypePostalCode))
        applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, contactNewList, RoutingAnalysis.RecordTypeRecruiting);*/
      
      /*First Check for the Zip code routing*/
      List<DynamicRoutingResult> lstresult = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByZipRouting, contactNewList, RoutingAnalysis.RoutingTypePostalCode);
      if(lstresult.IsEmpty()) return;
      
      System.debug('Via Zip Code Routing result ===>'+lstresult);
      
      List<Contact> lstConRecruiting = new List<Contact>(); 
      for(DynamicRoutingResult objRoutingResult : lstresult){
        if(!objRoutingResult.bIsRouted)
          lstConRecruiting.add(objRoutingResult.objCon);
      }
      
      if(lstConRecruiting.Isempty()){
        if(!updatertble.Isempty())
        {updaterulescount();
        }  
        return;
      }
      
      List<DynamicRoutingResult> lstresult2 = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, lstConRecruiting, RoutingAnalysis.RecordTypeRecruiting);
      if(!updatertble.Isempty())
      {
        updaterulescount();
      }  
      System.debug('Via Recruiting Routing result ===>'+lstresult2);
      
    }
    
    /*
      Created By   : Harsha Simha
      Created At   : 5 Sept 2012
      Parameters   : 
      Return Type  : Void
      Summary   : Function will Capture all the rules which set the owner for contact and update \
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
          {  Routing_Table__c r=maproutetables.get(updrrules[i].Id);
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
      Created By   : Niket Chandane
      Created At   : 27 July 2012
      Parameters   : Routing_Table__c[],contact[], String
      Return Type  : Boolean
      Summary   : Function will accepts the list of contact,routing table and get the routing type and apply the 
              routing engine rules and route the contact to respective user
    */
    public static List<DynamicRoutingResult> applyRoutingDynamicRouting(Routing_Table__c[] routingList ,Contact[] contactNewList,String strRouteBy)
    {
      //if(contactNewList.IsEmpty()) return null;      
      System.debug('strRouteBy ==>'+strRouteBy+' == First Routing List =====>'+routingList);
      //Boolean  = false;
      
      /*Routing result for bulk update*/
      List<DynamicRoutingResult> lstDynamicRoutingResult = new List<DynamicRoutingResult>(); 
      
      /*if(routingList.IsEmpty() || contactNewList.IsEmpty())
        return ;*/
        
      // Map will store string Account name Vs List of Account
      Map <String,List<Account>> departmentRegionRelatedAccountsMap = new Map <String,List<Account>>();
      
      // We need to clear apply routing for all type of recordTypes
      for(Contact contactNew : contactNewList)
          contactNew.Apply_Routing_Type__c = null;
            
        // Routing will work only for the HULT Applicant
        contactNewList = getHultApplicantList(contactNewList);
          
          
        // Map of UserName Vs User Id  
        final Map<String, Id> routingUserMap = RoutingAnalysis.getRoutingUserMap(routingList);
        
        // Collect the dynamic User Map with Ownership
        Map<String,Integer> MapDynamicUserAllocationMap = getDynamicUserAllocationMap(collectRoutingUserId(routingUserMap));
      
      //SHS: Collects the Rules Last Routed Date
      Map<String,Datetime> MapDynamicruleAllocationdateMap = getDynamicruleAllocationdateMap(routingList);
      
      // Rewrite the routing table with the actual ids
        for(Routing_Table__c routing : routingList){
          /*Replaces the routing name via User Id*/
            if (RoutingAnalysis.RoutedByUserName != null && RoutingAnalysis.RoutedByUserName.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = routingUserMap.get(routing.Routed_To__c);
            else if (RoutingAnalysis.RoutedByUserId != null && !RoutingAnalysis.RoutedByUserId.equalsIgnoreCase(routing.Routed_By__c))
                routing.Routed_To__c = null; // contacts only support routing by user name or id.
        
        // Fill the key as conmbination of Department and Region
            String strAccountKey = getAccountKey(routing);
          if(departmentRegionRelatedAccountsMap.containsKey(strAccountKey) == false)
               departmentRegionRelatedAccountsMap.put(strAccountKey,new List<Account>());
        }
      
      // Fill Map of Account Name vs List of Accounts
        for(Account account : [select Id,Name from Account where Name in : departmentRegionRelatedAccountsMap.keySet() and RecordTypeId=:RecordTypeHelper.getRecordTypeId('Account','Candidate') ]){
          if(account.Name != null && departmentRegionRelatedAccountsMap.containsKey((account.Name).toLowerCase()))
            departmentRegionRelatedAccountsMap.get((account.Name).toLowerCase()).add(account);
        }
      
      /***********************************************************************************************************************/
      // Actual routing
        
        System.debug('Size ============>'+contactNewList.size());
        
        for(Contact contactNew : contactNewList)
        {
          /*Assigning each contact result for bulk data */
          DynamicRoutingResult objDynamicRoutingResult = new DynamicRoutingResult();
          objDynamicRoutingResult.objCon = contactNew;
          objDynamicRoutingResult.bIsRouted = false;
            
          Routing_Table__c routing;
          String strRoutingKey;
          String routingGroup = null;
          String postalCode;
          Map<String,Integer> MapRuleViaMatchCount = new Map<String,Integer>();
          Map<String,Routing_Table__c> MapIdVsRouteTable = new Map<String,Routing_Table__c>();
          
            Routing_Table__c[] routingGroupList = new Routing_Table__c[] {};
            List<Routing_Table__c> lstRoutingwithPriority = new List<Routing_Table__c>();
            
            if(!IsNullOrEmpty(contactNew.MailingPostalCode)){
              //postalCode = RoutingAnalysis.getStandardizedPostalCode(contactNew.MailingPostalCode,contactNew.Country_Of_Residence_Name__c);
              postalCode = contactNew.MailingPostalCode;
            }
            
            System.debug('Contact :: '+contactNew.Name+' ==routingList ==>'+routingList);
            
            for(Routing_Table__c r : routingList)
            {
              Integer iRoutingParameterCount = 0;
              MapIdVsRouteTable.put(r.Id,r);
              
                if (r.Routed_To__c == null)
                    continue;
                /* NOTE: r.Region__c is ignored for routing purposes. */
                if (definitiveNotMatched(r.Country__c, contactNew.Country_Of_Residence_Name__c))
                   continue;
                if (definitiveNotMatched(r.State__c, contactNew.MailingState))
                   continue;
                if (definitiveNotMatched(r.Department__r.Name, contactNew.Department_Name_Primary__c))
                  continue;
                
                /* Special handling if routing is working via Recruiting but the Zip code is not matching 
                then it must be allocated for next rule*/
                if(contactNew.MailingPostalCode != null || r.Lower_Bound__c != null || r.Upper_Bound__c != null){
                  System.debug('If recruiting having Zip code there ======>'+IsNullOrEmpty(postalCode));
                  System.debug('4 =============>'+definitiveNotMatched(r.Lower_Bound__c,postalCode));
                  System.debug('5 =============>'+definitiveNotMatched(r.Upper_Bound__c,postalCode));
                  
                  if(IsNullOrEmpty(postalCode))
                  continue;
                  if(definitiveNotMatched(r.Lower_Bound__c,postalCode))
                  continue;
                  if(definitiveNotMatched(r.Upper_Bound__c,postalCode))
                  continue;
                }
                
                /*Zip Code routing Logic*/
                if(strRouteBy.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode))
                {
                  System.debug('Inside the Zip code routing');
                  if(IsNullOrEmpty(postalCode))
                    continue;
                  if(r.Lower_Bound__c == null || r.Upper_Bound__c == null)
                    continue;
                  if(!postalCode.equalsIgnoreCase(r.Upper_Bound__c) || !postalCode.equalsIgnoreCase(r.Lower_Bound__c))
                    continue;
                  /*if(definitiveNotMatched(r.Lower_Bound__c,postalCode))
                  continue;
                  if(definitiveNotMatched(r.Upper_Bound__c,postalCode))
                  continue;*/
                  
              /* Grouping logic: add only High priority matches for which we can do load balancing*/
                  if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c))
                  {
                    /* New Development to get most accurate result */
                    if (contactNew.Country_Of_Residence_Name__c != null && contactNew.Country_Of_Residence_Name__c.equalsIgnoreCase(r.Country__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (contactNew.MailingState != null && contactNew.MailingState.equalsIgnoreCase(r.State__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (contactNew.Department_Name_Primary__c != null && contactNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }  
                    
                    routingGroup = r.Priority__c;
                      routingGroupList.add(r);
                      
                      /* for zip code only High priority will be take in to consideration */
                      if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                        lstRoutingwithPriority.add(r);
                  }
                }
                else /* shs: load balance routing (Recruiting) with out postal code!*/ 
                {
                  /* Grouping logic: add only High priority matches for which we can do load balancing*/
                  if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c))
                  {
                    /* New Development to get most accurate result */
                    if (contactNew.Country_Of_Residence_Name__c != null && contactNew.Country_Of_Residence_Name__c.equalsIgnoreCase(r.Country__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (contactNew.MailingState != null && contactNew.MailingState.equalsIgnoreCase(r.State__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (contactNew.Department_Name_Primary__c != null && contactNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }  
                    
                    routingGroup = r.Priority__c;
                      routingGroupList.add(r);
                      
                      /* for zip code only High priority will be take in to consideration */
                      if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                        lstRoutingwithPriority.add(r);
                  }
                  /*
                  if(routingGroup == null || routingGroup.equalsIgnoreCase(r.Priority__c)){
                      routingGroup = r.Priority__c;
                      routingGroupList.add(r);
                  }*/
                }
            }
            
            if(lstRoutingwithPriority.Isempty() && routingGroupList.IsEmpty() && MapRuleViaMatchCount.IsEmpty()){
              lstDynamicRoutingResult.add(objDynamicRoutingResult);
              continue;
            }
            
            /*
            Comment By : Niket Chandane
            Date     : 7 June 2012
            Commnet    : Routing Load balancing will only work for those who is having Priority_Grouping__c = true
                    If there is no any rotuing rule coming with Priority_Grouping__c = true then routing will happen without load 
                    balancing.*/
                    
            //finalizeSameRule()
            /*SHS: Commented 298,299,325,326 lines i.e if condition and else condition*/
           // if(strRouteBy.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode))
            //{
              system.debug('lstRoutingwithPriority =============>'+lstRoutingwithPriority);
              system.debug('routingGroupList =============>'+routingGroupList);        
              system.debug('User Load MapDynamicUserAllocationMap =>'+MapDynamicUserAllocationMap);
              system.debug('Rule Load MapDynamicruleAllocationdateMap =>'+MapDynamicruleAllocationdateMap);
              /* Note Avoided else statement need to check each and every if condition */
              if(!routingGroupList.isEmpty()){
                System.debug('Inside Group List contactNew =======>'+contactNew.Name+' :: routing to ::'+routingGroupList);
                routing = routingGroupList.get(0);
              }
              
              // The information matches most we pick that rule  
              if(!MapRuleViaMatchCount.IsEmpty()){
                String strRouteId = finalizeSameRule(MapRuleViaMatchCount);
                if(strRouteId != null)
                  routing = MapIdVsRouteTable.get(strRouteId);
                System.debug('Inside Max Parameter contactNew =======>'+contactNew.Name+' :: routing to ::'+routing);  
              }
              
              if(!lstRoutingwithPriority.IsEmpty()){
                /*SHS: Added below line for roundrobin algorithm and commented next line which assigns
                 rules only for the owner with less count*/
                routing =retrieveruleName(MapDynamicruleAllocationdateMap,lstRoutingwithPriority);
                //routing = retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority);
                System.debug('Inside with priority contactNew =======>'+contactNew.Name+' :: routing to ::'+routing);
              }
            //}
            //else routing = !lstRoutingwithPriority.IsEmpty() ?retrieveruleName(MapDynamicruleAllocationdateMap,lstRoutingwithPriority): routingGroupList.get(0);
            //else routing = !lstRoutingwithPriority.IsEmpty() ? retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority): routingGroupList.get(0);
            
            if(routing == null){
              lstDynamicRoutingResult.add(objDynamicRoutingResult);
              continue;
            }
              
            // Creating routing key  
            strRoutingKey = getAccountKey(routing);
            
            /* Updated the Account ID as per the  routing Department-Region */
            if(departmentRegionRelatedAccountsMap.containsKey(strRoutingKey)){
              if(departmentRegionRelatedAccountsMap.get(strRoutingKey).size() > 0)
                contactNew.AccountId = departmentRegionRelatedAccountsMap.get(strRoutingKey)[0].id;
            }
            else // If not able to set the account need to throw error
              throw new RoutingException(Label.RoutingException_Unable_to_find_Parent_Account);
            
            /*
              Note :If do not route flag is checked then we are not going to route record
                  but account will update as per the Dept-Region
            */ 
            if (contactNew.Do_Not_Route__c == true)
                continue;
            
            if(routing.Routed_To__c != null){  /*Added By Sachin Bhadane to handle null assignment of Owner to the Contact in Load Balanced Routing */    
              contactNew.OwnerId = routing.Routed_To__c;
              objDynamicRoutingResult.bIsRouted = true;
              // = true;
              /*as in routing field they are changing Routed_to__c = Userid either routed by is username/other 
              we are using another variables to update some values in routing rule*/
              if(maproutetables.containsKey(routing.Id))
              {system.debug(maproutetables.get(routing.Id)+'====');
                updatertble.add(maproutetables.get(routing.Id));
              }
              System.debug('routing =============>'+contactNew.OwnerId+' :: contactNew ::'+contactNew.Id);
            }
            // Override the region?
            if (RoutingAnalysis.getSetting().Override_Contact_Region__c == true && routing.Region__c == null && RoutingAnalysis.getSetting().Override_When_Blank__c == true) {
                contactNew.Region__c = routing.Region__c;
               // contactNew.Sub_Region__c = routing.Sub_Region__c;
            }
          if (RoutingAnalysis.getSetting().Override_Contact_Region__c == true && routing.Region__c != null) {
                contactNew.Region__c = routing.Region__c;
                //contactNew.Sub_Region__c = routing.Sub_Region__c;  Commented By Anil.B on 11/11/2014 to delete this field
             }
             lstDynamicRoutingResult.add(objDynamicRoutingResult);
           }
      return lstDynamicRoutingResult;
    }
    
    /*
      Created by   :  Niket Chandane
      Created At   : 24 July 2012
      Parameters   : String (Record Type Name of the Contact)
      Return Type : String 
        Summary   : Method to Return RecordType Id 
    */
    public static String getHultApplicantRecordTypeId(String strRecType){
      return Contact.sObjectType.getDescribe().getRecordTypeInfosByName().get(strRecType).getRecordTypeId();
    }
    
    
    /*
      Created by   :  Niket Chandane
      Created At   : 24 July 2012
      Parameters   : String (Record Type Name of the Contact)
      Return Type : String 
        Summary   : Method to Return Routing Key based on Department name and Region.
    */
    public static String getAccountKey(Routing_Table__c objRouting){
      String accountKey;
        if(objRouting.Department__r.Name  == null && objRouting.Region__c  == null)
          accountKey = Label.Undecided_Account_Kay;
        else if(objRouting.Department__r.Name  != null && objRouting.Region__c  == null)
          accountKey = objRouting.Department__r.Name + Label.Unknown;
        else if(objRouting.Department__r.Name  == null && objRouting.Region__c  != null)
          accountKey = Label.Undecided + objRouting.Region__c;
        else if(objRouting.Department__r.Name  != null && objRouting.Region__c  != null)
          accountKey = objRouting.Department__r.Name+'-'+ objRouting.Region__c;
       return accountKey.toLowerCase();
    }
    
     /*
      Created by   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : NA
      Return Type : String 
        Summary   : Method to Return RecordType Id 
    */
  public static Contact[] getHultApplicantList(Contact[] applicantList){
      Contact[] hultApplicantList = new Contact[] {};
      String strHultID = getHultApplicantRecordTypeId(Label.HultApplicant_Record_Type);
      for(Contact objContact:applicantList){
        if(strHultID.equals(objContact.recordTypeId))
          hultApplicantList.add(objContact);
      }
      return hultApplicantList;
    }
    
    /*
      Created by   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : Set<Id>
      Return Type : Map<String,Integer>
        Summary   : Method accepts the set of user id and returns the Map User Id and it's Owner Ship count 
                for applicant
    */
    public static Map<String,Integer> getDynamicUserAllocationMap(Set<ID> userId){
    Map<String,Integer> MapUserIdAllocation = new Map<String,Integer>();
    for(AggregateResult objAgg : [Select Count(Id),ownerId From Contact where ownerId in : userId group by ownerId])
      MapUserIdAllocation.put(String.ValueOf(objAgg.get('ownerId')),Integer.valueOf(objAgg.get('expr0')));
    
    for(Id objUserId : userId)
      if(!MapUserIdAllocation.containsKey(objUserId))
        MapUserIdAllocation.put(objUserId,0);
    return MapUserIdAllocation;
  }
    
    /*
      Created By : Harsha Simha
      Created At : 27/8/2012
      Parameters : List<Routing_Table__c>
      Return type: map<string,Datetime>
      Summary     : Method returns map of routing rule Last Rule applied Date value.
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
      Created By   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : Map<String,Id> UserMap
      Return Type  : Routing_Table__c[]
      Summary   : To avoid duplicate user Id as value
    */ 
     public static Set<Id> collectRoutingUserId(Map<String,Id> UserMap){
      Set<Id> SetuserId = new Set<Id>();
      
      for(Id UserId : UserMap.Values())
        SetuserId.add(UserId);
      return SetuserId;
    }
    
    
    /*
      Created By   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : Contact[]
      Return Type  : Routing_Table__c[]
      Summary   : Function will accepts the list of contact and fires the query on the routing table
      Note    : It will returns all type of routing rules         
    */
   public static RoutingTableListInfo getRoutingTableList(Contact[] contactList)
   {
       Set<String> contactCountryIdSet = new Set<String> { null };
        Set<String> contactCountrySet = new Set<String> { null };
        Set<String> contactStateSet = new Set<String> { null };
        Set<String> contactDepartmentSet = new Set<String> { null };
        
        // Specially for Zip based routing
          String lowerBound,upperBound;
        //  Integer lowerBound,upperBound;
        
        // Now search the contacts
        for(Contact contact : contactList) {
            contactCountrySet.add(contact.Country_Of_Residence_Name__c); // only if available; may not be populated from the analysis tool.
            contactCountryIdSet.add(contact.Country_Of_Residence__c);
            contactStateSet.add(contact.MailingState);
            contactDepartmentSet.add(contact.Department_Name_Primary__c);
                        
            //Zip Based routing
            //String postalCode = RoutingAnalysis.getStandardizedPostalCode(contact.MailingPostalCode, contact.Country_Of_Residence_Name__c);
            if(contact.MailingPostalCode != null)
            {
                
              String postalCode = String.valueOf(contact.MailingPostalCode).trim();
              Pattern dollarPattern = Pattern.compile('[^0-9]');//shs:commented for remove all spcl chars ('[a-z]|[A-Z]');
              postalCode = dollarPattern.matcher(postalCode).replaceAll('').replaceAll(' ','');
              
              if(postalCode ==null || postalCode =='')
                continue;
               try{ 
              if(lowerBound == null)
                lowerBound = postalCode;
              else 
              {
                lowerBound =dollarPattern.matcher(lowerBound).replaceAll('').replaceAll(' ','');
                if(lowerBound.trim()==''||lowerBound.trim()==null||lowerBound==''||lowerBound==null)//added by shs 10/22/2012 : as not sure what to do on equal condition
                {       lowerBound = postalCode;}
                else{
                if(long.valueOf(lowerBound) > long.valueOf(postalCode))
                lowerBound = postalCode;
                }
              }
              
              if(upperBound == null)
                upperBound = postalCode;
              else{
                upperBound =dollarPattern.matcher(upperBound).replaceAll('').replaceAll(' ','');
                
                if(upperBound.trim()==''||upperBound.trim()==null||upperBound==''||upperBound==null)//added by shs 10/22/2012 : as not sure what to do on equal condition
                {       upperBound = postalCode;}
                else{       
                 if(long.valueOf(upperBound) < long.valueOf(postalCode))
                upperBound = postalCode;
                }
              }
              }catch(Exception e){system.debug(e); continue;}
              // Set the bounds
              /*if (lowerBound == null || lowerBound > postalCode)
              {
                lowerBound = postalCode;
              }
              if (upperBound == null || upperBound < postalCode)
              {
                System.debug('inside Upperbond ===>'+upperBound);
                  upperBound = postalCode;
              }*/
           }
        }
        
        System.debug('lowerBound ==================>'+lowerBound);
        System.debug('upperBound ==================>'+upperBound);
        
        // Special handling for the country of residence
        contactCountrySet = getCountryNameByCountryId(contactCountryIdSet);
        
        // When these contacts are coming in from the analysis tool, the formulas won't populate the departments
        // properly, so we have to do a manual search. We can tell if this is the origin, because the contact list
        // will be only 1 record long.
        if (contactList.size() == 1) {
            for(Program__c program : [
                select Department__r.Name
                  from Program__c
                 where Id = :contactList[0].Program_Primary__c
            ]) contactDepartmentSet.add(program.Department__r.Name);
        }
        
        RoutingParameterInfo objRoutingParameterInfo   = new RoutingParameterInfo();
        objRoutingParameterInfo.contactCountrySet     = contactCountrySet;
        objRoutingParameterInfo.contactDepartmentSet   = contactDepartmentSet;
        objRoutingParameterInfo.contactStateSet     = contactStateSet;
        objRoutingParameterInfo.lowerBound         = lowerBound;
        objRoutingParameterInfo.upperBound         = upperBound;
        
        System.debug('Paramter 1] contactCountrySet      ===>'+contactCountrySet);
        System.debug('Paramter 2] contactDepartmentSet   ===>'+contactDepartmentSet);
        System.debug('Paramter 3] contactStateSet      ===>'+contactStateSet);
        
        
        List<Routing_Table__c> lstByZipRouting      = database.query(createRoutingQuery(objRoutingParameterInfo,RoutingAnalysis.RoutingTypePostalCode));
        List<Routing_Table__c> lstByRecruitRouting = database.query(createRoutingQuery(objRoutingParameterInfo,''));
        
        System.debug('lstByZipRouting 4] lstByZipRouting ===>'+lstByZipRouting);
        System.debug('lstByRecruitRouting 5] lstByZipRouting ===>'+lstByRecruitRouting);
        
        RoutingTableListInfo objRoutingTableListInfo = new RoutingTableListInfo(lstByZipRouting,lstByRecruitRouting);
        
        return objRoutingTableListInfo;
   }
    
    /*
      Created By   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : Set<String> (contactCountryIdSet)
      Return Type  : Set<String>
      Summary   : Function will accepts the set of Country Id and returns the 
              Set of Country Name
    */
    public static Set<String> getCountryNameByCountryId(Set<String> contactCountryIdSet){
      Set<String> contactCountrySet = new Set<String> { null };
      for(Country__c country : [select Name from Country__c where Id in :contactCountryIdSet]) 
        contactCountrySet.add(country.Name);
        
        return contactCountrySet;
    }
    
    /*
      Created By   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : String , String
      Return Type  : Boolean
      Summary   : Function will accepts to Strings and checked both are same or not
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
      Created By   : Niket Chandane
      Created At   : 24 July 2012
      Parameters   : Map<String,Integer> , Routing_table__c[]
      Return Type  : Routing_Table__c
      Summary   : Function will accepts to Strings and checked both are same or not
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
      Created By   : Harsha Simha S
      Created At   : 8/27/2012
      Parameters   : Map<String,Datetime> , Routing_table__c[]
      Return Type  : Routing_Table__c
      Summary   : Method will check the lowest last updated rule and returns the lowest last updated rule 
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
      Created By   : Niket Chandane
      Created At   : 25 July 2012
      Parameters   : RoutingParameterInfo , String  
      Return Type  : String
      Summary   : Function accepts the RoutingParameterInfo and strRoutingBase 
              as a parameter creates a dynamic query depends upon the strRoutingBase   
    */
    
    public static String createRoutingQuery(RoutingParameterInfo objRouting, String strRoutingBase){
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
                 +', Work_Load__c'
                 +', Lower_Bound__c'
                 +', Upper_Bound__c'
                 +', Last_Roule_Applied_Date__c'
                 +', Routed_Records__c'
                  +' from Routing_Table__c'
                +' where Is_Active__c = true'
                 +' and Country__c in : objRouting.contactCountrySet'
                 +' and State__c in : objRouting.contactStateSet'
                 +' and Department__r.Name in : objRouting.contactDepartmentSet';
               //if(!IsNullOrEmpty(objRouting.lowerBound) && !IsNullOrEmpty(objRouting.upperBound) &&
               if(!IsNullOrEmpty(String.ValueOf(objRouting.lowerBound)) && !IsNullOrEmpty(String.ValueOf(objRouting.upperBound)) && 
                   strRoutingBase.equalsIgnoreCase(RoutingAnalysis.RoutingTypePostalCode))
                 {
                   strQuery += ' and (Lower_Bound__c <= :lowerBound or Upper_Bound__c >= :upperBound)';
                     strQuery += ' and (Lower_Bound__c != null and Upper_Bound__c != null)';
                 }
            strQuery += ' order by Priority_Value__c desc, Granularity__c desc';
    return strQuery;
  }
    
    /*
      Created By   : Niket Chandane
      Created At   : 25 July 2012
      Parameters   : String 
      Return Type  : Boolean
      Summary   : Utility Function will accepts to Strings and check that is 
              Is Null and Is Empty
    */
    public static Boolean IsNullOrEmpty(String strString){
      return (strString == null || ''.equals(strString)) ? true : false;
    }
    
    /*
      Class     : RoutingException
      Created by   : Niket Chandane
      Summary     : RoutingException class used for RoutingException (Custom Development)
    */
    public class RoutingException extends Exception {}
    
    /*
      Class     : RoutingParameterInfo
      Created By   : Niket Chandane
      Summary   : The class object holding routing parameters
              on which we can select routing rule 
    */
   // Inner class to store the routing parameters to get the routing records
  public class RoutingParameterInfo{
    Set<String> contactCountrySet = new Set<String> { null };
    Set<String> contactStateSet = new Set<String> { null };
    Set<String> contactDepartmentSet = new Set<String> { null };
    String lowerBound,upperBound;
    //Integer lowerBound,upperBound;
  }
  
   // Inner class to store RoutingTableList of Zip based or Recruit based
   public class RoutingTableListInfo{
       List<Routing_Table__c> lstByZipRouting = new List<Routing_Table__c>();
       List<Routing_Table__c> lstByRecruitRouting = new List<Routing_Table__c>();
       public RoutingTableListInfo(List<Routing_Table__c> lstByZipRouting,List<Routing_Table__c> lstByRecruitRouting){
         this.lstByZipRouting   = lstByZipRouting;
         this.lstByRecruitRouting= lstByRecruitRouting;
       }
   }
   
   /*
      Class     : RoutingParameterInfo
      Created By   : Niket Chandane
      Summary   : The class object keep track of the contact which is 
              routed by engine or not when we do bulk load  
   */
   
   // Inner class for Bulk dynamic routing 
   public class DynamicRoutingResult{
     Contact objCon = new Contact();
     Boolean bIsRouted = false;
   }
}