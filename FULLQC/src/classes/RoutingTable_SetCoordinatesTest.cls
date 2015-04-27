@IsTest
private class RoutingTable_SetCoordinatesTest {
    final static Decimal RoutedToLat = 30.000;
    final static Decimal RoutedToLon = -122.0;
    
    public static testmethod void testOk() 
    {
        /*User objUser = TestDataUtil.createUser('test-user@fakeemail.com','testx');
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
        Database.insert(objRouting);*/
        
        Routing_Table__c routing = new Routing_Table__c();
        routing.RecordTypeId = RoutingAnalysis.RecordTypeProximity;
        routing.Matching__c = RoutedToLat + ',' + RoutedToLon;
        routing.Is_Active__c = true;
        routing.Routed_By__c = RoutingAnalysis.RoutedByUserId;
        routing.Routed_To__c = UserInfo.getUserId();
        insert routing;
        
        system.assertEquals(RoutedToLat, [
            select Lat__c
              from Routing_Table__c
             where Id = :routing.Id
             limit 1
        ].Lat__c);
        
        system.assertEquals(RoutedToLon, [
            select Lon__c
              from Routing_Table__c
             where Id = :routing.Id
             limit 1
        ].Lon__c);
    }

        public static testmethod void testExpectedFailure() {
        Routing_Table__c routing = new Routing_Table__c();
        routing.RecordTypeId = RoutingAnalysis.RecordTypeProximity;
        routing.Matching__c = RoutedToLon + ',' + RoutedToLat;
        routing.Is_Active__c = true;
        routing.Routed_By__c = RoutingAnalysis.RoutedByUserId;
        routing.Routed_To__c = UserInfo.getUserId();
        
        try {
            insert routing;
            system.assert(false);
        } catch (System.DmlException pException) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, pException.getDmlType(0));
        }
    }
}