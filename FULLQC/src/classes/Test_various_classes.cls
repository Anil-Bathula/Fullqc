/*
    Class     : Test_various_classes 
    Developer : Harsha Simha S
    Date      : 23/7/2013
    Comment   : This test class can be used for any class, if the class coverage is small and creating new test_class for it is unecessary
                each test_method is a test class for particular class/trigger   
*/
@isTest 
private class Test_various_classes {
    
    /*  
        Developer       : Harsha Simha S
        Date            : 23/7/2013     
        Test Class for  : welcometeam_opppage_ctrlr
        Comment         : above class contains constructor and edit method.
    */  
    static testmethod void test_welcometeam_vfpage() 
    {
        Department__c dept=new Department__c();
        dept.Name='BBA';
        insert dept;
        
        Program__c pro =new Program__c();
        pro.name='Bachelor of Business Administration-UK-London';
        pro.Department__c=dept.id;
        insert pro;
        
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.StageName = 'In-Progress';        
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Start_Term__c='September'+' '+system.today().year();
        opp.Primary_Campus__c='Boston';
        insert opp;
                    
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        welcometeam_opppage_ctrlr woc=new welcometeam_opppage_ctrlr(controller);
        woc.edit();
    }
}