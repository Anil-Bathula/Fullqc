/*************************************
Class Name:-CampaignMemberStatus_Test
Developer :Anil.B
Coverage :88%
Trigger Name:-CampaignMemberStatus
**************************************/
@IsTest 
public class CampaignMemberStatus_Test {
  
      public static testmethod void campgn() {
        test.startTest(); 
        Country__c cntry=new Country__c();
        cntry.Name='United States';
        insert cntry;
        
        City__c cty=new City__c();
        cty.name='Boston';
        cty.Country__c=cntry.id;
        insert cty;
        
        Campaign cam=new Campaign();
        cam.name='Test Campaign1';
        cam.City__c=cty.id;
        cam.Type='Email';
        cam.Email_UTM__c='tset10charcehetere needed';
        insert cam;
        
        Campaign camp=new Campaign();
        camp.Parentid=cam.id;
        camp.name='Test Campaign2';
        camp.City__c=cty.id;
        Camp.Campaign_Sub_Type__c='121';
        camp.Program__c='MBA';
        camp.Region__c='EU';
        camp.Startdate=System.today();
        Camp.enddate=system.today()+1;
        camp.Type='Events';
        insert camp;
        test.stopTest();
    
      }
}