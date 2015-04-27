@isTest
public class Lead_New_DynamicRoutingTest {
	static Lead_New_DynamicRouting Lead_DynamicroteController;
    
    static testmethod void Lead_New_DynamicRoutingUnitTest()
    {
        test.startTest();
        User objUser = TestDataUtil.createUser('test-user@fakeemail.com','testx');
        Database.insert(objUser);
        
        Country__c objCountry = TestDataUtil.createCountry();
        Database.insert(objCountry);
        
        Requirement__c objReq = TestDataUtil.createRequirement(objCountry.Id);
        Database.insert(objReq); 
        
        Department__c objDept = TestDataUtil.createDepartment();
        Database.insert(objDept);
        
        Program__c objPro = TestDataUtil.createProgram(objCountry.Id, objDept.Id);
        Database.insert(objPro);
        
        Routing_Table__c objRouting = TestDataUtil.createRoutingTable(objDept.id, 'High', 'test-user@fakeemail.com');
        Database.insert(objRouting);
        
        Account objAcc = TestDataUtil.createAccount();
        Database.insert(objAcc);
        
        Setting_Disabled__c sd=new Setting_Disabled__c();
        sd.Lead_OverrideCountries__c =true;
        Database.insert(sd);
        
        Lead objLead = TestDataUtil.createLead(objCountry.Id,objPro.Id);
        Database.insert(objLead);
        
        Lead_New_DynamicRouting leadController = new Lead_New_DynamicRouting(new ApexPages.StandardController(objLead));
        leadController.execute();
        leadController.getLeadId();
        
        Lead[] leadList = [ select Name, FirstName, LastName, Apply_Routing_Type__c, IsConverted, Lat__c, Lon__c, LeadSource, PostalCode, City, Country, OwnerId, State, Status
                 , Country_Of_Residence__c, Country_Of_Residence_Name__c, Age_Range__c, Work_Load__c, Department_Name_Primary__c, Department_Name_Secondary__c, Department_Name_Third__c, Program_Primary__c, 
                 Program_Secondary__c, Program_Third__c, Do_Not_Route__c from Lead where Id =: objLead.Id and IsConverted = false ];
        
        Lead_New_DynamicRouting.applyRouting(leadList);
        
        if(!LeadList.IsEmpty()){
            if(LeadList[0].Postalcode==null)
            {
                LeadList[0].Postalcode='5160a01';
            }else
            {
                LeadList[0].Postalcode=null;
            } 
        }
        Lead_New_DynamicRouting.applyRouting(leadList);
        
        map<String,Datetime> temp=new map<string,Datetime>();
        temp.put(objrouting.Id,System.now());
        List<Routing_Table__c> rt=new List<Routing_Table__c>();
        rt.add(objrouting);
        Lead_New_DynamicRouting.retrieveruleName(temp,rt);
        
        test.stopTest();
    }
    
    static testMethod void Lead_New_DynamicRoutingUnitNegativeTest(){
        test.startTest();
        Lead_New_DynamicRouting.applyRouting(new List<Lead>{});
        Lead_New_DynamicRouting.applyRoutingDynamicRouting(new List<Routing_Table__c> {}, new List<Lead>{}, '');
        test.stopTest();
    }	
}