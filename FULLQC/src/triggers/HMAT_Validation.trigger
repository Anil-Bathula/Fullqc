/************************************************************************
Trigger    : HMAT_Validation
written By : Anil.B
Test Class : HMAT_validation_Test
Purpose    : To restrict user from creating duplicate records with
type HMAT for a application not more than one.
Code Coverage:90%.
*************************************************************************/
trigger HMAT_Validation on Exam__c (before insert, before update) {
 

    Map<String, Exam__c> EduMap =new Map<String, Exam__c>();
    for (Exam__c E : System.Trigger.new){
        if ((E.Exam_Type__c=='HMAT') &&
                (System.Trigger.isInsert ||
                 (E.Exam_Type__c!=
                    System.Trigger.oldMap.get(E.Id).Exam_Type__c))){
            if (EduMap.containsKey(E.Application__c)){
                E.addError('Already a HMAT record exists for this application');
            }else{
                EduMap.put(E.Application__c, E);
                System.debug('===>'+Edumap);
            }
       }
    }
    
    for (Exam__c E : [SELECT id,Exam_Type__c,Application__c  FROM Exam__c
                      WHERE Exam_Type__c='HMAT' AND Application__C IN :EduMap.KeySet()]){
        Exam__c newEd = EduMap.get(E.Application__c);
        newEd.addError('Already a HMAT record exists for this application');
    }
}