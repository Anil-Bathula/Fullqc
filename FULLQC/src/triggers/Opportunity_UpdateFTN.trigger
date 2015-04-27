/*
    Modified : Harsha Simha 
    Date     : 7/4/2014
    Changes  : Actual trigger updates finance transactions when Opportunity proimary campus/Program is changed. 
                for this previous developer written 2 soql.
                I made those 2 queries into 1. 
    Modified by :Anil.B on 31/10/2014 ---on JIRA --SFSUP 775.
 Test class: TestForSixCardPaymentController(85%)
*/
trigger Opportunity_UpdateFTN on Opportunity (after update) 
{
    if(Trigger.isUpdate)
    {
        SET<ID> oppids = new SET<ID>();
        SET<ID> finupd = new SET<ID>();
        SET<ID> ftnupd = new SET<ID>();
        List<Opportunity_Finance__c> fin_update=new  List<Opportunity_Finance__c>();
        List<Finance_Transactions__c> ft_update=new  List<Finance_Transactions__c>();
        
        for(Opportunity objOpp : trigger.new)
        {
            Opportunity objOldOpp = trigger.OldMap.get(objOpp.Id);
            if((objOpp.Primary_Program_Choice__c != objOldOpp.Primary_Program_Choice__c)|| (objOpp.Primary_Campus__c != objOldOpp.Primary_Campus__c) ) 
            {
                oppids.add(objOpp.id);      
                ftnupd.add(objOpp.id);
                
            }
            /****SFSUP 775*****/
            if(objopp.Program__c!=objOldOpp.Program__c && objOldOpp.Primary_Campus__c=='Dubai' &&objOpp.Primary_Campus__c!='Dubai'){
                oppids.add(objopp.id);
                finupd.add(objopp.id);
            } //end SFSUP 775
        }
        System.debug('===oppids==>'+oppids+'==finupd==>'+finupd+'====ftnupd==>'+ftnupd);
        if(!oppids.isEmpty())
        {
             List<Opportunity_Finance__c> financeObj=[select id,Opportunity__c,Visa_Type_Picklist__c,(SELECT Id, Name,Finance__c from Finance_Transactions__r ) from  Opportunity_Finance__c where Opportunity__c IN :oppids];
            for(Opportunity_Finance__c opf:financeObj)
            {
            
                System.debug('=opid==>'+opf.Opportunity__c);
                if(finupd!=null && finupd.contains(opf.Opportunity__c))
                {
                    opf.Visa_Type_Picklist__c ='';
                    fin_update.add(opf);
                }
                if(ftnupd!=null && opf.Finance_Transactions__r.size()>0 && ftnupd.contains(opf.Opportunity__c))
                {
                    for(Finance_Transactions__c ft:opf.Finance_Transactions__r){                    
                      ft_update.add(ft);
                    }
                }
            }
             try
            {       
                if(!fin_update.isEmpty())
                    update fin_update;
            }
            catch(Exception e){}
            
            try
            {     
                if(!ft_update.IsEmpty())
                    update ft_update;
            }
            catch(Exception e){}
           
        }
        /****SFSUP 775*****//*
        if(opfids.size()>0){
           List<Opportunity_Finance__c> financeObj=[select id,Opportunity__c,Visa_Type_Picklist__c from  Opportunity_Finance__c where Opportunity__c IN :oppids];
           
           for(Opportunity_Finance__c opf:financeObj){
               opf.Visa_Type_Picklist__c ='';
               fin_update.add(opf);
               
           }
           update fin_update;
        }//end SFSUP 775*/
         
    }
}