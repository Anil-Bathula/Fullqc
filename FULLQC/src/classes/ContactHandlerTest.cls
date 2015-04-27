/**
 * ContactHandlerTest.cls
 * 
 * Test methods for ContactHandler.cls and ContactTrigger.trigger
 * 
 * @author Gary Marsh (westbrook)
 * @date 13-08-08
 */
@isTest
private class ContactHandlerTest {
	
	private static final List<User> adminUsers;
	private static final Map<String, Profile> profileMap;
	private static final List<Account> accounts;
	
	private static final String PORTAL_PROFILE = 'Student Portal';
	
	static {
		profileMap = TestDataFactory.getProfileMap();
		adminUsers = TestDataFactory.createUsers(1, profileMap.get('System Administrator'), 'aaa', true);
		accounts = TestDataFactory.createAccounts(1, true);
	}
	
	/**
	 * #829
	 */
    static testMethod void deactivateUsersOffTalentSolutions() {
    	List<Contact> contacts = TestDataFactory.createContacts(1, accounts, false);
    	contacts[0].Off_Talent_Solutions__c = false;
    	contacts[0].Waived__c = false;
    	insert contacts;
    		
		List<User> portalUsers = TestDataFactory.createPortalUsers(1, profileMap.get(PORTAL_PROFILE), contacts, 'bbb', true);
		
		contacts[0].Off_Talent_Solutions__c = true;
		
		System.runAs(adminUsers[0]) {
			Test.startTest();
			update contacts;
			Test.stopTest();
		}
		
		System.assertEquals(1, [select count() from User
		where ContactId in :contacts /*and isActive = false*/
		and Profile.Name = :ContactHandler.PROFILE_STUDENT_OFF_SERVICE],
		'Expected 1 user set to off service');
    }
    
    /**
	 * #829
	 */
    static testMethod void deactivateUsersWaived() {
    	List<Contact> contacts = TestDataFactory.createContacts(1, accounts, false);
    	contacts[0].Off_Talent_Solutions__c = false;
    	contacts[0].Waived__c = false;
    	insert contacts;
    		
		List<User> portalUsers = TestDataFactory.createPortalUsers(1, profileMap.get(PORTAL_PROFILE), contacts, 'bbb', true);
		
		contacts[0].Waived__c = true;
		
		System.runAs(adminUsers[0]) {
			Test.startTest();
			update contacts;
			Test.stopTest();
		}
		
		System.assertEquals(1, [select count() from User
		where ContactId in :contacts /*and IsActive = false*/ 
		and Profile.Name = :ContactHandler.PROFILE_STUDENT_OFF_SERVICE],
		'Expected 1 user set to off service');
    }
    
    /**
	 * #829
	 */
    static testMethod void activateUsers() {
    	List<Contact> contacts = TestDataFactory.createContacts(1, accounts, false);
    	contacts[0].Off_Talent_Solutions__c = true;
    	contacts[0].Waived__c = true;
    	insert contacts;
    		
		List<User> portalUsers = TestDataFactory.createPortalUsers(1, profileMap.get(PORTAL_PROFILE), contacts, 'bbb', false);
		portalUsers[0].IsActive = false;
		insert portalUsers;
			
		contacts[0].Off_Talent_Solutions__c = false;
		contacts[0].Waived__c = false;
		
		System.runAs(adminUsers[0]) {
			Test.startTest();
			update contacts;
			Test.stopTest();
		}
		
		System.assertEquals(1, [select count() from User 
		where ContactId in :contacts /*and IsActive = true*/ 
		and Profile.Name = :ContactHandler.PROFILE_STUDENT],
		'Expected 1 user set to on service');
    }
}