/*
    Developer   : Harsha Simha.S
    Date        : 1/14/2013    
    Summary     : Used for Routing Contacts, This class is overwritten from Contact_DynamicRouting as RoutebyPostalcode is completely removed!
    TestClass   : Contact_New_DynamicRoutingTest(78%)
    Modified By : Anil.B on 11/11/2014 to delete this field Sub_region__c removed this field from query
*/
public without sharing class Contact_New_DynamicRouting extends ContactExtension {
    final Id contactId;
    final String contactRoutingType;
    final boolean lbrdonce;
    final boolean dnotroute;
    
    static integer bf = 0;
    static set<Routing_Table__c> updatertble;
    static map<Id,Routing_Table__c> maproutetables;
    
    public Contact_New_DynamicRouting(ApexPages.StandardController controller){
        super(controller);
        this.contactId = controller.getId();
        Contact objCon = (Contact)controller.getRecord();
        objCon = [Select c.Apply_Routing_Type__c,LBR_d_once__c,Do_Not_Route__c From Contact c where id =: contactId limit 1][0];//.id;
        this.contactRoutingType = objCon.Apply_Routing_Type__c;
        this.lbrdonce=objCon.LBR_d_once__c;
        this.dnotroute=objCon.Do_Not_Route__c;
        system.debug(this.contactRoutingType +'==='+this.lbrdonce +'==='+this.dnotroute+'---'+objcon);
    }
    /*sets  Contact to LBR 
    Note : Currently we are adding flag recruiting but actual routing will 
        happen depends upon the applicant data
   */
  public PageReference execute(){
      PageReference newPage;
      System.debug(this.contactRoutingType +'==='+this.lbrdonce +'==='+this.dnotroute);
      if(this.contactRoutingType != RoutingAnalysis.RoutingTypeRecruiting && !this.lbrdonce && !this.dnotroute)
        update new Contact(Id = contactId, Apply_Routing_Type__c = RoutingAnalysis.RoutingTypeRecruiting);        
        newPage = new PageReference('/' + contactId);
      return newPage.setRedirect(true);
    }
     /*Function will accepts the list of contact apply the routing engine rules and 
       route the contact to respective user (reff. from contact_DynamicRputing)
    */
    public static void applyRoutingDynamicRouting(Contact[] contactNewList)
    {
      if(contactNewList == null && contactNewList.IsEmpty())
        return;
        updatertble=new set<Routing_Table__c>();
        maproutetables=new map<id,Routing_Table__C>();
        /*gets list of routing rules applicable for the Contacts*/  
        RoutingTableListInfo objRoutingTableListInfo = getRoutingTableList(contactNewList);
        if(objRoutingTableListInfo.lstByRecruitRouting.IsEmpty())
            return;
      
        /*List of routing Rules and Contacts are passed to the Routing Process and if any LBR is done then Rules are updated with latest count!*/
        for(Routing_table__c r:objRoutingTableListInfo.lstByRecruitRouting){maproutetables.put(r.Id,r);}
        List<DynamicRoutingResult> lstresult2 = applyRoutingDynamicRouting(objRoutingTableListInfo.lstByRecruitRouting, contactNewList, RoutingAnalysis.RecordTypeRecruiting);
        if(lstresult2.IsEmpty()) return;
        updaterulescount();       
        System.debug('Via Recruiting Routing result ===>'+lstresult2);
      
    }
    
    /*Function will accepts the list of contact and fires the query on the routing table
      Note    : It will returns all type of routing rules         
    */    
   public static RoutingTableListInfo getRoutingTableList(Contact[] contactList)
   {
       Set<String> contactCountryIdSet = new Set<String> { null };
        Set<String> contactCountrySet = new Set<String> { null };
        Set<String> contactStateSet = new Set<String> { null };
        Set<String> contactCitySet = new Set<String> { null };
        Set<String> contactDepartmentSet = new Set<String> { null };        
        for(Contact contact : contactList) {
            contactCountrySet.add(contact.Country_Of_Residence_Name__c); // only if available; may not be populated from the analysis tool.
            contactCountryIdSet.add(contact.Country_Of_Residence__c);
            contactStateSet.add(contact.MailingState);
            contactCitySet.add(contact.MailingCity);
            contactDepartmentSet.add(contact.Department_Name_Primary__c);                        
        }
        contactCountrySet = getCountryNameByCountryId(contactCountryIdSet);
        
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
        objRoutingParameterInfo.contactCitySet     = contactCitySet;
        
        System.debug('Paramter 1] contactCountrySet      ===>'+contactCountrySet);
        System.debug('Paramter 2] contactDepartmentSet   ===>'+contactDepartmentSet);
        System.debug('Paramter 3] contactStateSet        ===>'+contactStateSet);
        System.debug('Paramter 3] contact_CitySet        ===>'+contactCitySet);
        
        List<Routing_Table__c> lstByRecruitRouting = [select Name, Age_Range__c, City__c, Country__c, Comment__c, Department__c, Department__r.Name, Granularity__c, Lead_Source__c,
                     Lead_Status__c, Priority__c, Priority_Value__c, Priority_Grouping__c, Region__c, Routed_By__c, Routed_To__c, State__c, 
                     Postal_Code__c, Work_Load__c, Lower_Bound__c, Upper_Bound__c, Last_Roule_Applied_Date__c, Routed_Records__c from Routing_Table__c
                     where Is_Active__c = true and Country__c in :contactCountrySet and Department__r.Name in :contactDepartmentSet
                     and State__c in :contactStateSet and City__c in :contactCitySet order by Priority_Value__c desc, Granularity__c desc];
        /*//List<Routing_Table__c> lstByRecruitRouting = database.query(createRoutingQuery(objRoutingParameterInfo));//strQuery);
        for(Routing_Table__c lzr:lstByRecruitRouting)
        {
            System.debug('lstByRecruitRouting 5] lstByZipRouting ===>'+lzr+'----'+lzr.Department__c+'----'+lzr.Department__r.Name);
        }
        System.debug('lstByRecruitRouting 5] lstByZipRouting ===>'+lstByRecruitRouting+'----'+lstByRecruitRouting[0].Department__c+'----'+lstByRecruitRouting[0].Department__r.Name);
                */
        RoutingTableListInfo objRoutingTableListInfo = new RoutingTableListInfo(lstByRecruitRouting);        
        return objRoutingTableListInfo;
   }
   /*returns country name for the given country ids.*/
   public static Set<String> getCountryNameByCountryId(Set<String> contactCountryIdSet){
      Set<String> contactCountrySet = new Set<String> { null };
      for(Country__c country : [select Name from Country__c where Id in :contactCountryIdSet]) 
        contactCountrySet.add(country.Name);        
        return contactCountrySet;
    }
    /*If LBR is done then Routing Rule count and Last routed date is updated*/
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
                 +', Postal_Code__c'
                 //+', Wildcad_Postcode__c'
                 +', Work_Load__c'
                 +', Lower_Bound__c'
                 +', Upper_Bound__c'
                 +', Last_Roule_Applied_Date__c'
                 +', Routed_Records__c'
                 +' from Routing_Table__c'
                 +' where Is_Active__c = true'
                 +' and Country__c in : objRouting.contactCountrySet'                 
                 +' and Department__r.Name in : objRouting.contactDepartmentSet'
                 +' and State__c in : objRouting.contactStateSet'
                 +' and City__c in : objRouting.contactCitySet'
                 +' order by Priority_Value__c desc, Granularity__c desc';
        return strQuery;
    }
    
    /*Contacts will be routed based on their values with the applicable routing rules*/
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
         //   Map<String,Integer> MapDynamicUserAllocationMap = getDynamicUserAllocationMap(collectRoutingUserId(routingUserMap));
          
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
      system.debug(departmentRegionRelatedAccountsMap);
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
            system.debug(contactNew);
          /*Assigning each contact result for bulk data */
          DynamicRoutingResult objDynamicRoutingResult = new DynamicRoutingResult();
          objDynamicRoutingResult.objCon = contactNew;
          objDynamicRoutingResult.bIsRouted = false;
                    
          /*If Contact is having DoNotToute or LBRdOnce as true or contact stage is not 'qulaified lead and InProgress' then that contact is not sent to routing process!*/  
          if (contactNew.Do_Not_Route__c == true)
            continue;
            system.debug('===>'+contactNew.LBR_d_once__c);
          if(contactNew.LBR_d_once__c)
            continue;           
          
          system.debug('===>'+contactNew.Stage__c);     
          if(contactNew.Stage__c!='Qualified Lead' && contactNew.Stage__c!='In Progress' && contactNew.Stage__c!=null)
            continue;
          system.debug('===>'+contactNew);    
          Routing_Table__c routing;
          String strRoutingKey;
          String routingGroup = null;
          String postalCode;
          Map<String,Integer> MapRuleViaMatchCount = new Map<String,Integer>();
          Map<String,Routing_Table__c> MapIdVsRouteTable = new Map<String,Routing_Table__c>();
          
            Routing_Table__c[] routingGroupList = new Routing_Table__c[] {};
            List<Routing_Table__c> lstRoutingwithPriority = new List<Routing_Table__c>();
            
            System.debug('Contact :: '+contactNew.Name+' ==routingList ==>'+routingList);
            boolean prior_routing=false;
            integer ptycount=0;
            for(Routing_Table__c r : routingList)
            {
              Integer iRoutingParameterCount = 0;
              MapIdVsRouteTable.put(r.Id,r);
              
                if (r.Routed_To__c == null)
                    continue;
                /* NOTE: r.Region__c is ignored for routing purposes. 
                shs:11/6/2012:if postal code Routing then state should not match!*/
                if (definitiveNotMatched(r.Country__c, contactNew.Country_Of_Residence_Name__c))
                   continue;
                if (definitiveNotMatched(r.State__c, contactNew.MailingState))
                   continue;
                if (definitiveNotMatched(r.Department__r.Name, contactNew.Department_Name_Primary__c))
                  continue;
                if (definitiveNotMatched(r.City__c, contactNew.MailingCity))
                  continue;  
                
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
                    if (contactNew.MailingCity != null && contactNew.MailingCity.equalsIgnoreCase(r.City__c)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    }
                    if (contactNew.Department_Name_Primary__c != null && contactNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)){
                      iRoutingParameterCount++; MapRuleViaMatchCount.put(r.Id,iRoutingParameterCount);
                    } 
                    routingGroup = r.Priority__c;
                    routingGroupList.add(r);
                    if(r.Priority_Grouping__c && routingGroup.equalsIgnoreCase('High'))
                    {
                        integer i=0;
                        if((contactNew.Country_Of_Residence_Name__c==null && r.Country__c==null)||(contactNew.Country_Of_Residence_Name__c!=null && contactNew.Country_Of_Residence_Name__c.equalsIgnoreCase(r.Country__c)))
                            i++;
                        if((contactNew.Department_Name_Primary__c==null && r.Department__r.Name==null)||(contactNew.Department_Name_Primary__c!=null && contactNew.Department_Name_Primary__c.equalsIgnoreCase(r.Department__r.Name)))
                            i++;
                        if((contactNew.MailingState==null && r.State__c==null)||(contactNew.MailingState!=null && contactNew.MailingState.equalsIgnoreCase(r.State__c)))
                            i++;
                        if((contactNew.MailingCity==null && r.City__c==null)||(contactNew.MailingCity!=null && contactNew.MailingCity.equalsIgnoreCase(r.City__c)))
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
             // system.debug('User Load MapDynamicUserAllocationMap =>'+MapDynamicUserAllocationMap);
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
                prior_routing=true;
                //routing = retrieveOwnerName(MapDynamicUserAllocationMap,lstRoutingwithPriority);
                System.debug('Inside with priority contactNew =======>'+contactNew.Name+' :: routing to ::'+routing);
              }
            //{}
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
            
                
            if(routing.Routed_To__c != null){  /*Added By Sachin Bhadane to handle null assignment of Owner to the Contact in Load Balanced Routing */    
              contactNew.OwnerId = routing.Routed_To__c;
              objDynamicRoutingResult.bIsRouted = true;
              /*Below condition added to check : if priority routing is to be set to true and this acts like  do not route field functionality*/
              if(prior_routing)
              {
                contactNew.LBR_d_once__c=true;
              }
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
                //contactNew.Sub_Region__c = routing.Sub_Region__c; Commented by Anil.B to delete this field
            }
          if (RoutingAnalysis.getSetting().Override_Contact_Region__c == true && routing.Region__c != null) {
                contactNew.Region__c = routing.Region__c;
              //contactNew.Sub_Region__c = routing.Sub_Region__c;  Commented by Anil.B to delete this field
             }
             lstDynamicRoutingResult.add(objDynamicRoutingResult);
           }
      return lstDynamicRoutingResult;
    }
    
    /*      Method to Return RecordType Id    */
    public static String getHultApplicantRecordTypeId(String strRecType){
      return Contact.sObjectType.getDescribe().getRecordTypeInfosByName().get(strRecType).getRecordTypeId();
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
    /*Method to Return Routing Key based on Department name and Region.    */
    public static String getAccountKey(Routing_Table__c objRouting){System.DEbug(objRouting);
      String accountKey;
        if(objRouting.Department__r.Name  == null && objRouting.Region__c  == null)
          accountKey = Label.Undecided_Account_Kay;
        else if(objRouting.Department__r.Name  != null && objRouting.Region__c  == null)
          accountKey = objRouting.Department__r.Name + Label.Unknown;
        else if(objRouting.Department__r.Name  == null && objRouting.Region__c  != null)
          accountKey = Label.Undecided + objRouting.Region__c;
        else if(objRouting.Department__r.Name  != null && objRouting.Region__c  != null)
          accountKey = objRouting.Department__r.Name+'-'+ objRouting.Region__c;
       System.DEbug(objRouting+'--'+objRouting.Department__r.Name);
       System.Debug(accountKey);
       return accountKey.toLowerCase();
    }
    
    /*checks contact Recordtype id and returns back. If contact is n ot Applicant Recordtype then routing is not done for that contact!*/
    public static Contact[] getHultApplicantList(Contact[] applicantList){
      Contact[] hultApplicantList = new Contact[] {};
      String strHultID = getHultApplicantRecordTypeId(Label.HultApplicant_Record_Type);
      for(Contact objContact:applicantList){
        if(strHultID.equals(objContact.recordTypeId))
          hultApplicantList.add(objContact);
      }
      return hultApplicantList;
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
       for(AggregateResult objAgg : [Select Count(Id),ownerId From Contact where ownerId in : userId group by ownerId])
          MapUserIdAllocation.put(String.ValueOf(objAgg.get('ownerId')),Integer.valueOf(objAgg.get('expr0')));
        
        for(Id objUserId : userId)
          if(!MapUserIdAllocation.containsKey(objUserId))
            MapUserIdAllocation.put(objUserId,0);
        return MapUserIdAllocation;
   }*/
    /* Method returns map of routing rule Last Rule applied Date value.    */
    public static Map<string,Datetime> getDynamicruleAllocationdateMap(List<Routing_Table__c> routingruleslist)
    {
      Map<String,Datetime> MapruledateAllocation = new Map<String,Datetime>();
      for(Routing_Table__c rt:routingruleslist)
      {
        MapruledateAllocation.put(rt.Id,rt.Last_Roule_Applied_Date__c);
      }
      return MapruledateAllocation;
    }
    
   /*To avoid duplicate user Id as value    */ 
     public static Set<Id> collectRoutingUserId(Map<String,Id> UserMap){
      Set<Id> SetuserId = new Set<Id>();
      
      for(Id UserId : UserMap.Values())
        SetuserId.add(UserId);
      return SetuserId;
    }
    
    /*RoutingException class used for RoutingException (Custom Development)    */
    public class RoutingException extends Exception {}
    
    public class RoutingParameterInfo{
            Set<String> contactCountrySet = new Set<String> { null };
            Set<String> contactStateSet = new Set<String> { null };
            Set<String> contactDepartmentSet = new Set<String> { null };
            Set<String> contactCitySet = new Set<String> { null };      
            //Integer lowerBound,upperBound;
    }
        
        /* Inner class to store RoutingTableList of Zip based or Recruit based*/
    public class RoutingTableListInfo{        
           List<Routing_Table__c> lstByRecruitRouting = new List<Routing_Table__c>();
           public RoutingTableListInfo(List<Routing_Table__c> lstByRecruitRouting){          
             this.lstByRecruitRouting= lstByRecruitRouting;
           }
    }
    /* Inner class to maintain Contact info*/
    public class DynamicRoutingResult{
     Contact objCon = new Contact();
     Boolean bIsRouted = false;
   }
}