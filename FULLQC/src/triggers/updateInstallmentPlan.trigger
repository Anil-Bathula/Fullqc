// Trigger to update Installment Plan on Finance Object when the program is changed.
/*
    Changes done by : S. Harsha Simha
    Date     :: 15/11/2013
    Comments :: OLI query was inside the for loop which is causing issue too many soql queries in scheduled jobs.(Daniel written)
                 Removed query in for loops. 
    Modified By:-Anil.B 16/11/2013--opp[i].Program_Parsed__c != 'EMBA' changed the condition due to error list is out of bound of exception.
    
    Modified By:- Prem :- Finance record type to 'BBA Finance' if the Program__c value starts with 'Bachelor'
    
    Modified By:- SHS :- 7/2/2014  SFSUP-745 Runs for application process only
*/
trigger updateInstallmentPlan on Opportunity (after update) {
     integer i;
     String bba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');
     String nonbba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance');
     List<Opportunity_Finance__c> oppFinNew = new List<Opportunity_Finance__c>();
   //  List<Opportunity> opp = Trigger.new;
    // List<Opportunity> oppOld = Trigger.old;     
     List<string> oppids = new List<string>();
     
    /* for(i=0;i<opp.size();i++){
      System.debug(opp[i].Program__c'==================0000'+oppOld[i].Program__c);
         if(opp[i].Program__c !=oppOld[i].Program__c ){
             oppids.add(opp[i].Id); 
         }
     }*/
     for(opportunity opp:trigger.new){
     System.debug(opp.Program__c+'==================0000?->'+trigger.oldmap.get(opp.id).program__c);
         if(RecordTypeHelper.isapplicationprocessrecordtype(opp.Recordtypeid) && opp.program__c!=trigger.oldmap.get(opp.id).program__c){
             oppids.add(opp.Id); 
         }
     }
     
   
    if(!oppids.IsEmpty()){
         List<Opportunity_Finance__c> oppFin = [select id,Installment_Plan__c,recordtypeid,Opportunity__r.program__r.Name, 
         Housing_Accommodation__c,Program_Parsed__c,Opportunity__c, CurrencyIsoCode from Opportunity_Finance__c where Opportunity__c IN:oppids];
         System.debug('====0000'+oppfin);
         for(Opportunity_Finance__c opf : oppFin){
         System.debug('====1111>'+opf.Opportunity__c);
             If(Trigger.newMap.ContainsKey(opf.Opportunity__c)){
         
                 if (opf.Program_Parsed__c != 'EMBA') {
                     opf.Installment_Plan__c = 'No Installment Plan';
                     opf.Housing_Accommodation__c= '';
                     opf.Payment_Amount_3rd__c= NULL;
                     opf.Payment_Due_Date_3rd__c= NULL;
                     opf.Payment_Amount_4th__c= NULL;
                     opf.Payment_Due_Date_4th__c= NULL;
                     opf.Payment_Amount_5th__c= NULL;
                     opf.Payment_Due_Date_5th__c= NULL;
                     opf.Payment_Amount_6th__c= NULL;
                     opf.Payment_Due_Date_6th__c= NULL;
                     opf.Payment_Amount_7th__c= NULL;
                     opf.Payment_Due_Date_7th__c= NULL;
                     opf.Payment_Amount_8th__c= NULL;
                     opf.Payment_Due_Date_8th__c= NULL;
                     opf.CurrencyIsoCode = Trigger.newMap.get(opf.Opportunity__c).Program_Currency__c;
                 }
                 else {
                     opf.Installment_Plan__c = 'No FlexiPlan';
                     opf.Housing_Accommodation__c= '';                         
                     opf.Payment_Amount_5th__c= NULL;
                     opf.Payment_Due_Date_5th__c= NULL;
                     opf.Payment_Amount_6th__c= NULL;
                     opf.Payment_Due_Date_6th__c= NULL;
                     opf.Payment_Amount_7th__c= NULL;
                     opf.Payment_Due_Date_7th__c= NULL;
                     opf.Payment_Amount_8th__c= NULL;
                     opf.Payment_Due_Date_8th__c= NULL;
                     opf.CurrencyIsoCode = Trigger.newMap.get(opf.Opportunity__c).Program_Currency__c;
                 }
                 
                 oppFinNew.add(opf); 
                 
                 //Finance record type to 'BBA Finance' if the Program__c value starts with 'Bachelor'
                /* if(opf.Opportunity__r.program__r.Name.startsWith('Bachelor')){
                     opf.recordtypeid=bba_rectype;
                 }else{
                     opf.recordtypeid=nonbba_rectype;
                 }*/
           }
             
             
             
         }
         
         try{
             update oppFinNew;             
         }
         catch(System.DmlException e){
          Trigger.new[0].adderror(e.getMessage());           
         }
     }
   
}