/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAlldata=true)
private class Test_Refresh_RoutingScheduler {

    static testMethod void Refresh_RoutingScheduler() 
    {
    	string CRON_EXP='0 0 0 3 3 ? 2022';
    	string CRON_EXP1='0 0 0 3 3 ? 2020';
    	 List<CronTrigger> ct = [SELECT id, CronExpression from CronTrigger where CronJobDetail.Name like 'MessageServicer#%'];
    	test.startTest();
    	
    	String jobId = System.schedule('testScheduledApex',CRON_EXP,new Refresh_RoutingScheduler());
    	if(!ct.IsEmpty())
    		System.abortJob(ct[0].id);
    		
    		
    	jobId = System.schedule('testScheduledApex1',CRON_EXP1,new Refresh_RoutingScheduler());	
    	test.stopTest();
        
    }
}