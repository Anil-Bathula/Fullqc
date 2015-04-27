/*
Author           : Premanath Reddy
Created Date     : January 11, 2013
Usage            : This triggers is on Lead on Before Insert& Before Update. 
                 : This trigger prevents user from creating duplicate Applicant_Email ids for email ids already existing in Lead.  
*/
trigger lead_ApplicantEmail_Dup_prevent on Lead(before insert, before update) {

    Map<String, Lead> leadMap = new Map<String, Lead>();
    for (Lead lead : System.Trigger.new) {
        
        if ((lead.Applicant_Email__c!= null) &&
                (System.Trigger.isInsert ||
                (lead.Applicant_Email__c!=System.Trigger.oldMap.get(lead.Id).Applicant_Email__c))) {
            //if we have Duplicate Emails among inserting records
            if (leadMap.containsKey(lead.Applicant_Email__c)) {
                lead.Applicant_Email__c.addError('Duplicate value on record,Lead');
            } else {
                leadMap.put(lead.Applicant_Email__c, lead);
            }
       }
    } 
    if(!leadMap.isEmpty()){
        List<Lead> led=[SELECT Applicant_Email__c,id,isConverted,Company,Start_Term__c,Phone,MobilePhone,Region__c,Lead_Stage__c
                      FROM Lead WHERE Applicant_Email__c IN :leadMap.KeySet()];
        if(!led.isEmpty()){
            for (Lead lead :led) {
                if(!lead.isConverted){
                    Lead newLead = leadMap.get(lead.Applicant_Email__c);
                    newLead.Applicant_Email__c.addError('Duplicate value on record'
                                                            +','+lead.ID
                                                            +','+lead.Company
                                                            +','+lead.Start_Term__c
                                                            +','+lead.Phone
                                                            +','+lead.MobilePhone
                                                            +','+lead.Region__c
                                                            +',Lead');
                }
            }
        }
    }
}