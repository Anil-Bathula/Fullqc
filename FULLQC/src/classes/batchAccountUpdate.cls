global class batchAccountUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name,Country_Of_Residence__c,Country_Of_Residence_Name__c,region__c,Program_Parsed__c,MailingState FROM Contact';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
         for(Contact con : scope)
         {
          if(con.Region__c!=null){
            String cor=con.region__c=='North Am'?con.MailingState:con.Country_Of_Residence_Name__c;
            String Country= sub_region_logic.get_Subregion(con.Region__c,cor,con.Program_Parsed__c); 
            //con.Sub_Region__c=Country!=Null?Country:con.Region__c;
           }            
         }
         update scope;
    }   
    
    global void finish(Database.BatchableContext BC) {
    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'anil.bathula@EF.com'});        
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Process Completed - '+system.today());
            mail.setPlainTextBody('update is completed : '+system.today());           
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}