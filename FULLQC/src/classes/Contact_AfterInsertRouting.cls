/***************************************************************************************
Class Name      : Contact_AfterInsertRouting
Author          : Niket Chandane
Created Date    : Aug 7, 2012
Usage           : HULT-184 (When applicant get created Message need to be created for routing purpose)
Revision History: 
-------------------------------------------------------------------------------------------------------------
	Date  			Owner 				Comment
	8 Aug 2012		Niket Chandane		Added Comment
-------------------------------------------------------------------------------------------------------------
****************************************************************************************/
public with sharing class Contact_AfterInsertRouting extends ContactTrigger {
	 public Contact_AfterInsertRouting(Contact[] contactOldList, Contact[] contactNewList) {
        super(contactOldList, contactNewList);
    }
    
    public virtual override void execute() {
    	
    	System.debug('Inside the Trigger 2 '+contactNewList);
    	
    	rC_Core__Message__c[] messageInsertList = new rC_Core__Message__c[] {};
    	 Dom.Document doc = new Dom.Document();
        doc.createRootElement('message', null, null);
        
        map<string,boolean> mapctctdonotroute=new map<String,boolean>();    	
        for(Contact contactNew : contactNewList){
        	if (contactNew == null)
                continue;
            if (contactNew.Program_Primary__c == null)
                continue; // no change
            if (contactNew.Country_Of_Residence__c == null)
            	continue;
            if(contactNew.Do_Not_Route__c)//added by shs
            	continue;	
        	    	
            Dom.XmlNode xml = doc.getRootElement().addChildElement('contact', null, null);
            xml.setAttribute('id', contactNew.Id);
             
            rC_Core__Message__c message = new rC_Core__Message__c();
        	message.rC_Core__Endpoint__c = 'queue://Contact_RouteByRecruitingServicer';
        	message.rC_Core__Data__c = doc.toXmlString();
            messageInsertList.add(message);	
        }
        
        if (messageInsertList.size() == 0)
            return;
        
        List<Database.Saveresult> lstDate = database.insert(messageInsertList);
        System.debug('lstDate ===>'+lstDate);
            
    }
}