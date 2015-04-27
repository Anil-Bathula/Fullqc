/*
    Change Log 
-----------------------------------------------------------------------------------------------------------------------------
    Date            Owner               Comment
-----------------------------------------------------------------------------------------------------------------------------
    24/7/2012       Niket Chandane      Added class to create the comman data for the 
                                        routing engine this will be a base classa for the 
                                        other test classes. 
*/ 

@isTest
public class TestDataUtil {
    public static User createUser(String strUserName,String NickName){
        ID ProfileID = [ Select id from Profile][0].id;
        User objUser = new User( email=strUserName, 
                                profileid = profileid, 
                                UserName=strUserName, 
                                alias='tuser1', 
                                CommunityNickName = NickName, 
                                TimeZoneSidKey='America/New_York', 
                                LocaleSidKey='en_US', 
                                EmailEncodingKey='ISO-8859-1', 
                                LanguageLocaleKey='en_US', 
                                FirstName = 'Test', 
                                LastName = 'User' );
        return objUser;
    }
    
    public static Country__c createCountry(){
        return new Country__c( Name = 'DemoCountry',Calling_Code__c = 00,Country_Code__c  = 'pp',Region__c = 'MEA11');
    }
    
    public static Department__c createDepartment(){
        return new Department__c(Name = 'TestMBA');
    }
    
    public static Requirement__c createRequirement(Id idCountry){
        return new Requirement__c(Name = 'CR',Country__c = idCountry);
    }
    
    public static Program__c createProgram(Id idCountry,Id idDept){
       return new Program__c(Name = 'TestProgram',Country__c= idCountry,Department__c = idDept);
    }
    
    public static Routing_Table__c createRoutingTable(Id IdDept,String strPriority,String strUser){
        return new Routing_Table__c(Routed_To__c = strUser, 
                                    Department__c = IdDept, 
                                    Priority__c = strPriority,
                                    Routed_By__c ='User Name',
                                    Region__c ='Asia',
                                    Is_Active__c = true);
    }
    
    public static Routing_Table__c createZipRoutingTable(Id IdDept,String strPriority,String strUser){
        return new Routing_Table__c(Routed_To__c = strUser, 
                                    Department__c = IdDept, 
                                    Priority__c = strPriority,
                                    Routed_By__c ='User Name',
                                    Region__c ='Asia',Postal_code__c='11111',
                                    Is_Active__c = true,Priority_Grouping__c = true);
    }
    
    public static Account createAccount(){
        return new Account(Name ='TestMBA-Asia');
    }
    
    public static Account createAccount(string acname,string rectype){
    	string recid=RecordTypeHelper.getRecordTypeId('Account',rectype);
    	Account a=new Account();
    	a.Name =acname==null?'TestMBA-Asia':acname;
    	if(recid!=null)
    		a.RecordTypeId=recid;
        return a;
    }
    
    public static Contact createContact(Id idPrimaryPro){
        return new Contact(LastName='TestContact',
                            Program_Primary__c = idPrimaryPro, 
                            RecordTypeId = getHultApplicantRecordTypeId());
    }
    
    public static Contact createZipContact(Id idPrimaryPro){
        return new Contact(LastName='TestContact',
                            Program_Primary__c = idPrimaryPro, MailingPostalCode ='11111',
                            RecordTypeId = getHultApplicantRecordTypeId());
    }
    
    public static String getHultApplicantRecordTypeId(){
        return Contact.sObjectType.getDescribe().getRecordTypeInfosByName().get(Label.HultApplicant_Record_Type).getRecordTypeId();
    }
    
    public static Lead createLead(String strCountry,String ProgramId)
    {
        Lead lead = new Lead();
        lead.Company = 'Company';
        lead.FirstName = 'FirstName';
        lead.LastName = 'LastName';
        //lead.Email = 'sample@example.com';
        lead.Applicant_Email__c = 'sample@example.com';
        lead.LeadSource ='Web';
        lead.Lat__c = 48.85;
        lead.Lon__c = 2.35;
        lead.Country_Of_Residence__c = strCountry;
        lead.Program_Primary__c = ProgramId;
        lead.OwnerId = UserInfo.getUserId();
        return lead;
    }
}