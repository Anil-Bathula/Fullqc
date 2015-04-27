@isTest
public class updt_cntry_test{
    public static testmethod void methodname(){
        test.startTest(); 
        Country__c cntry=new Country__c();
        cntry.Name='India';
        insert cntry;
        
        City__c cty=new City__c();
        cty.name='Bangalore';
        cty.Country__c=cntry.id;
        insert cty;
        
        Campaign camp=new Campaign();
        camp.name='Test Campaign';
        camp.City__c=cty.id;
        insert camp;
        test.stopTest();
    }
}