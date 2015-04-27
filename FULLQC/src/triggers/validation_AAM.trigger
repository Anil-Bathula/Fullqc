/************************************************************************
Trigger    : validation_AAM
written By : Anil.B
Test Class : Validation_AAM_Test
Purpose    : To restrict user from creating duplicate records with
Degree="Bachelors degree" And Validate=True. There Should be only one
Bachelor degree validated.
Code Coverage:88%.
*************************************************************************/
trigger validation_AAM on Education__c (before insert, before update) {
 

    Map<String, Education__c> EduMap =new Map<String, Education__c>();
    for (Education__c E : System.Trigger.new){
        if ((E.Highest_Degree_Attained__c=='Bachelor\'s Degree'&&E.AAM_Validated__c==True) &&
                (System.Trigger.isInsert ||
                 (E.Highest_Degree_Attained__c !=
                    System.Trigger.oldMap.get(E.Id).Highest_Degree_Attained__c|| E.AAM_Validated__c!=System.Trigger.oldMap.get(E.Id).AAM_Validated__c))){
            if (EduMap.containsKey(E.Application__c)){
                E.addError('You can only validate one Bachelor\'s Degree, if you need to validate a different one then un-validate the original Education record first and proceed to validate the new record');
            }else{
                EduMap.put(E.Application__c, E);
                System.debug('===>'+Edumap);
            }
       }
    }
    
    for (Education__c E : [SELECT Application__c,Highest_Degree_Attained__c,AAM_Validated__c  FROM Education__c
                      WHERE AAM_Validated__c=True AND Highest_Degree_Attained__c='Bachelor\'s Degree' AND Application__C IN :EduMap.KeySet()]){
        Education__c newEd = EduMap.get(E.Application__c);
        newEd.addError('You can only validate one Bachelor\'s Degree, if you need to validate a different one then un-validate the original Education record first and proceed to validate the new record');
    }
}