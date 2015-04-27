trigger Fee_on_finance on Fees__c (after insert) {

    Map<String,Fees__c> varmap=new map<String,Fees__c>();
    Set<String>varmapyear=new set<string>();
    Set<String>varmapprogram=new set<string>();    
    list<Opportunity_Finance__c>fins=new list<Opportunity_Finance__c>(); 
    
    for(Fees__c fs:trigger.new){
        if(fs.year__c!=Null&&fs.Program_Name__c!=null){
            varmap.put(fs.Program_Name__c,fs); 
            varmapYear.add(fs.Year__c); 
            varmapProgram.add(fs.Program_Name__c);                                  
        }
    }
    system.debug('--->'+varmap.size());
    
    if(!varmap.isEmpty()){
      list<Opportunity_Finance__c>lstfin=[select id,name,Fees__c,Program__c,opportunity__r.Program__c from Opportunity_Finance__c where Fees__c=NULL AND opportunity__r.Paid_Application_Fee__c=False AND opportunity__r.Program__c IN:varmapProgram AND Opportunity__r.Start_Year__c IN:varmapYear];
      
           system.debug('--->'+lstfin.size());
            for(Opportunity_Finance__c opf:lstfin){
                if(varmap.containsKey(opf.opportunity__r.Program__c)){
                    opf.fees__c=varmap.get(opf.opportunity__r.Program__c).id;     
                    system.debug('********'+opf.fees__c);   
                    fins.add(opf);
                }
            }
            update fins;
    }
}