/**
 * ContactHandler.cls
 * 
 * Handles functionality for ContactTrigger.trigger
 * 
 * @author Gary Marsh (westbrook)
 * @date 13-08-08
 */
public without sharing class ContactHandler {

	private static ContactHandler handler;

	@TestVisible private static final String PROFILE_STUDENT = 
			'Hult Career Point Student Profile';
	@TestVisible private static final String PROFILE_STUDENT_OFF_SERVICE = 
			'Hult Career Point Student Profile - Off Service';

	private static final Set<String> PROFILE_NAMES = new Set<String> {
		PROFILE_STUDENT, PROFILE_STUDENT_OFF_SERVICE
	};
	private static final Map<String, Profile> profileMap = 
			getProfileMap(PROFILE_NAMES);
	
	private ContactHandler(){}
	
	public static ContactHandler getHandler() {
		if(null==handler) { handler = new ContactHandler(); } return handler;
	}
	
	public void afterInsert() {
		
	}
	
	public void afterUpdate() {
		activateUsers((List<Contact>)Trigger.new, (Map<Id, Contact>)Trigger.oldMap);
		deactivateUsers((List<Contact>)Trigger.new, (Map<Id, Contact>)Trigger.oldMap);
	}
	
	/**
	 * #829
	 * Activate users when their related contact has the Off_Talent_Solutions__c
	 * checkbox set to true
	 */
	private void activateUsers(List<Contact> recs, Map<Id, Contact> oldMap) {
		List<Contact> affectedRecs = new List<Contact>();
		
		// find all affected records where off talent solutions is set to false
		for(Contact rec : recs) {
			if(hasContactChangedToActive(rec, oldMap.get(rec.Id))) {
				affectedRecs.add(rec);
			}
		}
		
		// if there are no affected records, exit
		if(affectedRecs.isEmpty()) { return; }
		
		// retrieve affected user ids
		Set<Id> affectedUserIds = getAffectedUserIds(affectedRecs);
		
		// if there are no affected users, exit
		if(affectedUserIds.isEmpty()) { return; }
		
		// set isActive to true
		setActiveStatus(affectedUserIds, true);
	}
	
	/**
	 * #829
	 * Deactivate users when their related contact has the Off_Talent_Solutions__c
	 * checkbox set to false
	 */
	private void deactivateUsers(List<Contact> recs, Map<Id, Contact> oldMap) {
		List<Contact> affectedRecs = new List<Contact>();
		
		// find all affected records where off talent solutions is set to false
		for(Contact rec : recs) {
			if(hasContactChangedToInactive(rec, oldMap.get(rec.Id))) {
				affectedRecs.add(rec);
			}
		}
		
		// if there are no affected records, exit
		if(affectedRecs.isEmpty()) { return; }
		
		Set<Id> affectedUserIds = getAffectedUserIds(affectedRecs);
		
		// if there are no affected users, exit
		if(affectedUserIds.isEmpty()) { return; }
		
		// set isActive to false
		setActiveStatus(affectedUserIds, false);
	}
	
	/**
	 * Checked to see if a contact has been changed to active. A field
	 * change must take place for this to occur
	 */
	private Boolean hasContactChangedToActive(Contact rec, Contact oldRec) {
		return !rec.Off_Talent_Solutions__c && !rec.Waived__c &&
		(rec.Off_Talent_Solutions__c != oldRec.Off_Talent_Solutions__c ||
		rec.Waived__c != oldRec.Waived__c);
	}
	
	/**
	 * Checked to see if a contact has been changed to inactive. A field
	 * change must take place for this to occur
	 */
	private Boolean hasContactChangedToInactive(Contact rec, Contact oldRec) {
		return (rec.Off_Talent_Solutions__c || rec.Waived__c) &&
		(rec.Off_Talent_Solutions__c != oldRec.Off_Talent_Solutions__c ||
		rec.Waived__c != oldRec.Waived__c);
	}
	
	@future
	private static void setActiveStatus(Set<Id> ids, Boolean isActive) {
		List<User> users = new List<User>();
		for(Id i : ids) {
			users.add(new User(
				Id = i,
				//IsActive = isActive,
				ProfileId = isActive ? profileMap.get(PROFILE_STUDENT).Id : 
						profileMap.get(PROFILE_STUDENT_OFF_SERVICE).Id
			));
		}
		
		update users;
	}
	
	private Map<Id, User> getPortalUsers(List<Contact> recs) {
		Map<Id, User> portalUsers = new Map<Id, User>();
		
		for(User u : [select Id, ContactId from User where ContactId in :recs]) {
			portalUsers.put(u.ContactId, u);
		}
		
		return portalUsers;
	}

	private static Map<String, Profile> getProfileMap(Set<String> profileNames) {
		Map<String, Profile> myMap = new Map<String, Profile>();

		for(Profile p : [select Id, Name from Profile where Name in :profileNames]) {
			myMap.put(p.Name, p);
		}

		return myMap;
	}
	
	private Set<Id> getAffectedUserIds(List<Contact> recs) {
		Set<Id> userIds = new Set<Id>();
		Map<Id, User> portalUsers = getPortalUsers(recs);
		
		for(Contact rec : recs) {
			if(!portalUsers.containsKey(rec.Id)) { continue; }
			userIds.add(portalUsers.get(rec.Id).Id);
		}
		
		return userIds;
	}
}