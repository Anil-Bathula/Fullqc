/**
 Change Log
 -------------------------------------------------------------------------------------------------------------------
    Date                Owner               Comment
 -------------------------------------------------------------------------------------------------------------------
    1 -Aug -2012     Niket Chandane     Code Coverage 82 %
 */
@isTest
public class Lead_DynamicRoutingTest {
    static Lead_DynamicRouting Lead_DynamicroteController;
    
    static testmethod void Lead_DynamicRoutingUnitTest()
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
        
        Lead objLead = TestDataUtil.createLead(objCountry.Id,objPro.Id);
        Database.insert(objLead);
        
        Lead_DynamicRouting leadController = new Lead_DynamicRouting(new ApexPages.StandardController(objLead));
        leadController.execute();
        leadController.getLeadId();
        
        Lead[] leadList = [ select Name, FirstName, LastName, Apply_Routing_Type__c, IsConverted, Lat__c, Lon__c, LeadSource, PostalCode, City, Country, OwnerId, State, Status
                 , Country_Of_Residence__c, Country_Of_Residence_Name__c, Age_Range__c, Work_Load__c, Department_Name_Primary__c, Department_Name_Secondary__c, Department_Name_Third__c, Program_Primary__c, 
                 Program_Secondary__c, Program_Third__c, Do_Not_Route__c from Lead where Id =: objLead.Id and IsConverted = false ];
        
        Lead_DynamicRouting.applyRouting(leadList);
        
        if(!LeadList.IsEmpty()){
            if(LeadList[0].Postalcode==null)
            {
                LeadList[0].Postalcode='5160a01';
            }else
            {
                LeadList[0].Postalcode=null;
            } 
        }
        Lead_DynamicRouting.applyRouting(leadList);
        test.stopTest();
    }
    
    static testMethod void Lead_DynamicRoutingUnitNegativeTest(){
        test.startTest();
        Lead_DynamicRouting.applyRouting(new List<Lead>{});
        Lead_DynamicRouting.applyRoutingDynamicRouting(new List<Routing_Table__c> {}, new List<Lead>{}, '');
        test.stopTest();
    }
    
    static testMethod void Contact_DynamicRoutingZipCodeTest(){
        test.startTest();
        
        User objUser = TestDataUtil.createUser('testuser@fakeemail.com','test');
        Database.insert(objUser);
       /*
        User objUser2 = TestDataUtil.createUser('test2user@fakeemail.com','test2');
        Database.insert(objUser2);
        
        User objUser3 = TestDataUtil.createUser('test3user@fakeemail.com','test3');
        Database.insert(objUser3);
        
        
        Country__c objCountry = TestDataUtil.createCountry();
        Database.insert(objCountry);*/
        Country__c objCountry = TestDataUtil.createCountry();
        Database.insert(objCountry);
        
        Department__c objDept = TestDataUtil.createDepartment();
        Database.insert(objDept);
        
        Program__c objPro = TestDataUtil.createProgram(objCountry.Id, objDept.Id);
        Database.insert(objPro);
        
        Lead objLead = TestDataUtil.createLead(objCountry.Id, objPro.Id);
        Database.insert(objLead);
        
        Requirement__c objReq = TestDataUtil.createRequirement(objCountry.Id);
        Database.insert(objReq); 
        
        Routing_Table__c objRouting = TestDataUtil.createZipRoutingTable(objDept.id, 'High', 'testuser@fakeemail.com');
        Database.insert(objRouting);
        
       /* Routing_Table__c objRouting2 = TestDataUtil.createZipRoutingTable(objDept.id, 'High', 'test2user@fakeemail.com');
        Database.insert(objRouting2);
        
        Routing_Table__c objRouting3 = TestDataUtil.createZipRoutingTable(objDept.id, 'High', 'test3user@fakeemail.com');
        Database.insert(objRouting3);*/
        
        List<Routing_Table__c> lstRoutingTable = [Select Id,Name,Routed_To__c from Routing_Table__c];
         set<string> testunameslist=new set<string>();
        for(Routing_Table__c r:lstRoutingTable){testunameslist.add(r.Routed_to__c);}
        map<String,Integer> MapUser = new Map<String,Integer>();
        Integer iCount =0;
        for(User objU : [Select Name,Email,Id from User where username in :testunameslist limit 2000])
        {iCount++;
            MapUser.put(objU.Id,iCount);
        }
        
        Lead_DynamicRouting.retrieveOwnerName(MapUser,lstRoutingTable);
        
        Account objAcc = TestDataUtil.createAccount();
        Database.insert(objAcc);
        
        Lead_DynamicroteController = new Lead_DynamicRouting(new Apexpages.Standardcontroller(objLead));
        Lead_DynamicroteController.execute();
        
        Lead[] leadList = [ select Name, FirstName, LastName, Apply_Routing_Type__c, IsConverted, Lat__c, Lon__c, LeadSource, PostalCode, City, Country, OwnerId, State, Status
                 , Country_Of_Residence__c, Country_Of_Residence_Name__c, Age_Range__c, Work_Load__c, Department_Name_Primary__c, Department_Name_Secondary__c, Department_Name_Third__c, Program_Primary__c, 
                 Program_Secondary__c, Program_Third__c, Do_Not_Route__c from Lead where Id =: objLead.Id and IsConverted = false ];
        
        Lead_DynamicRouting.applyRouting(leadList);
        if(!LeadList.IsEmpty()){
            if(LeadList[0].Postalcode==null)
            {
                LeadList[0].Postalcode='5160a01';
            }else
            {
                LeadList[0].Postalcode=null;
            } 
        }
        Lead_DynamicRouting.applyRouting(leadList);
        
        LeadList[0].Postalcode='11111';
        Lead_DynamicRouting.applyRouting(leadList);
        
        test.stopTest();
    }
}