/**
 * TestDataFactory.cls
 * 
 * Provides mock data for test classes
 * 
 * @author Gary Marsh (westbrook)
 * @date 13-08-09
 */
@isTest
public class TestDataFactory {
	
	public static testMethod void test() {
		// setup objects
		Map<String, Profile> profileMap = getProfileMap();
		List<User> users = createUsers(1, profileMap.get('System Administrator'), 'aaa', true);
		
		// non-setup objects
		System.runAs(users[0]) {
		List<Account> accounts = createAccounts(1, true);
		List<Contact> contacts = createContacts(1, accounts, true);
		List<ts2__Assessment__c> assessments = createAssessments(1, contacts, users, true);			
		}
	}

    public static Map<String, Profile> getProfileMap() {
    	Map<String, Profile> mp = new Map<String, Profile>();
    	
    	for(Profile p : [select Id, Name from Profile limit 10000]) {
    		mp.put(p.Name, p);
    	}
    		
    	return mp;
    }
    	
    public static List<Account> createAccounts(Integer size, Boolean withDml) {
		List<Account> items = new List<Account>();
    		
    	for(Integer i=0; i<size; i++) {
    		items.add(new Account(
    			Name = 'Test Account ' + i
    		));
    	}
    		
    	if(withDml) insert items;
    	return items;
	}
	
	public static List<Contact> createContacts(Integer size, List<Account> accts, Boolean withDml) {
		List<Contact> items = new List<Contact>();
    		
    	for(Integer i=0; i<size; i++) {
    		Account acct = i==0 ? accts[0] : accts[Math.mod(i, accts.size())];
    		items.add(new Contact(
    			AccountId = acct.Id,
    			FirstName = 'Test',
    			LastName = 'Contact',
    			Off_Talent_Solutions__c = true
    		));
    	}
    		
    	if(withDml) insert items;
    	return items;
	}
	
	public static List<User> createUsers(Integer size, Profile profile, String key, Boolean withDml) {
		List<User> items = new List<User>();
		
		for(Integer i=0; i<size; i++) {
			items.add(new User(
                Firstname = 'Test',
                Lastname = 'User ' + key + i,
                Alias = 'testuser',
                Email = 'testuser' + key + i + '@example.org',
                Username = 'testuser' + key + i + '@wigroup.com',
                CommunityNickname = 'test.user' + key + i,
                isActive = true,
                EmailEncodingKey='UTF-8',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_GB',
                TimeZoneSidKey='Europe/London',
                ProfileId = profile.Id
            ));
        }
        		
        if(withDml) insert items;
        return items;
	}
	
	public static List<ts2__Assessment__c> createAssessments(Integer size, List<Contact> cons, List<User> advisors, Boolean withDml) {
		List<ts2__Assessment__c> items = new List<ts2__Assessment__c>();
		
		final Datetime DATE_NOW = Datetime.now();
		
		for(Integer i=0; i<size; i++) {
			Contact con = i==0 ? cons[0] : cons[Math.mod(i, cons.size())];
			User advisor = i==0 ? advisors[0] : advisors[Math.mod(i, advisors.size())];
			items.add(new ts2__Assessment__c(
				ts2__Contact__c = con.Id,
				ts2__User__c = advisor.Id,
				Start_Time__c = String.valueOf(DATE_NOW.timeGmt()),
				End_Time__c = String.valueOf(DATE_NOW.addHours(2).timeGmt())
			));
		}
		
		if(withDml) insert items;
		return items;
	}
	
	public static List<User> createPortalUsers(Integer size, Profile profile, List<Contact> cons, String key, Boolean withDml) {
		List<User> items = new List<User>();
		
		for(Integer i=0; i<size; i++) {
			Contact con = i==0 ? cons[0] : cons[Math.mod(i, cons.size())];
			items.add(new User(
                Firstname = 'Test',
                Lastname = 'User ' + key + i,
                Alias = 'testuser',
                Email = 'testuser' + key + i + '@example.org',
                Username = 'testuser' + key + i + '@wigroup.com',
                CommunityNickname = 'test.user' + key + i,
                isActive = true,
                EmailEncodingKey='UTF-8',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_GB',
                TimeZoneSidKey='Europe/London',
                ProfileId = profile.Id,
                ContactId = con.Id,
                IsPortalSelfRegistered = true
            ));
        }
        		
        if(withDml) insert items;
        return items;
	}
}