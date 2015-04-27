@isTest
public class Amount_USD_Rate_Test{
    public static testmethod void methodname(){ 
      
        Opportunity op=new opportunity();
        op.Name='firstname';
        op.StageName='Accepted';
        op.CloseDate=System.today();
        insert op; 
        
        Opportunity_Finance__c fin=new Opportunity_Finance__c();
        fin.Go_Ed_Loan_Amount__c=200;
        fin.CurrencyIsoCode='USD';
        fin.Opportunity__c=op.id;
        fin.Go_Ed_Loan_Amount_First_Rate_USD__c=200;
        insert fin;
        system.assertEquals(fin.Go_Ed_Loan_Amount__c,fin.Go_Ed_Loan_Amount_First_Rate_USD__c=200);
        
        fin.Go_Ed_Loan_Amount__c=null;
        update fin;
        
        fin.Go_Ed_Loan_Amount__c=500;
        update fin;
        system.assertEquals(fin.Go_Ed_Loan_Amount__c,fin.Go_Ed_Loan_Amount_First_Rate_USD__c=500);
    }
}