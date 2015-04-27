/********************************************************
Modified by:Anil.B for Jira No:-706
Added a if condition to populate cs.campus__c in line 19.
Test Class:-Amount_USD_Rate_Test (84%)
*********************************************************/
trigger Amount_USD_Rate on Opportunity_Finance__c (before insert,before update) {

Set<Id> sobjectSetOfIds = new Set<Id>();
list<String> scurrencycode=new list<String>();

    for(Opportunity_Finance__c cs:trigger.New){         
        if(cs.Go_Ed_Loan_Amount__c!=null&&cs.CurrencyIsocode!=null){
            sobjectSetOfIds.add(cs.id); 
            scurrencycode.add(cs.CurrencyIsocode);          
        }   
        if( cs.RecordTypeId==RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Housing External Finance')){
           if(cs.OP_Campus__c !=null){
                cs.Campus_Program__c=cs.OP_Campus__c+'-'+'Accommodation';
            }
        }
        
        if(cs.OP_Campus__c !=null&&cs.Program_pre_Parsed__c!=null){      
            cs.Campus_Program__c=cs.OP_Campus__c+'-'+cs.Program_pre_Parsed__c;           
        }    
    }
    
    if(!scurrencycode.IsEmpty())
    {
     
     List<DatedConversionRate> Dcr=[select IsoCode,ConversionRate From DatedConversionRate where Isocode in:scurrencycode AND StartDate<=THIS_WEEK];
     if(Trigger.isInsert) {  
       if(!sobjectSetOfIds.ISEmpty()&& !Dcr.Isempty()){            
            for(Opportunity_Finance__c c: Trigger.new){ 
                for(integer i=0;i<Dcr.size();i++){
                    if(Dcr[i].IsoCode==c.CurrencyIsocode&&(Dcr[i].Isocode=='GBP'||Dcr[i].Isocode=='CNY')){                 
                        c.Go_Ed_Loan_Amount_First_Rate_USD__c=dcr[i].ConversionRate*0.98;  
                    }
                    Else{
                        c.Go_Ed_Loan_Amount_First_Rate_USD__c=dcr[i].ConversionRate;
                    }
                }
            }    
       }
     }
    
     if (Trigger.isUpdate) 
     {   
        if(!sobjectSetOfIds.ISEmpty()&&!Dcr.Isempty())
        {          
            for(Opportunity_Finance__c c: Trigger.new)
            {  
              for(integer i=0;i<Dcr.size();i++)
              {              
                if(trigger.oldMap.get(c.id).Go_Ed_Loan_Amount__c==null&&trigger.oldMap.get(c.id).Go_Ed_Loan_Amount_First_Rate_USD__c==null&&trigger.newMap.get(c.id).Go_Ed_Loan_Amount__c!=null&&(trigger.newMap.get(c.id).CurrencyIsocode=='GBP'||trigger.newMap.get(c.id).CurrencyIsocode=='CNY')){
                   c.Go_Ed_Loan_Amount_First_Rate_USD__c=dcr[i].ConversionRate*0.98;
                } 
                else if(trigger.oldMap.get(c.id).Go_Ed_Loan_Amount__c==null&&trigger.oldMap.get(c.id).Go_Ed_Loan_Amount_First_Rate_USD__c==null&&trigger.newMap.get(c.id).Go_Ed_Loan_Amount__c!=null&&(trigger.newMap.get(c.id).CurrencyIsocode=='AED'||trigger.newMap.get(c.id).CurrencyIsocode=='USD')) {
                   c.Go_Ed_Loan_Amount_First_Rate_USD__c=dcr[i].ConversionRate;
                } 
              }
            }
        }
     }
 
   }

 
}