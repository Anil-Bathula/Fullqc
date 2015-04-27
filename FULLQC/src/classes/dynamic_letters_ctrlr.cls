public with sharing class dynamic_letters_ctrlr 
{
    public Letter_Templates__c temp{get;set;}
    public dynamic_letters_ctrlr ()
    {
        temp=[select id,Name,Para_1__c,Para_2__c,Program__c,Template_Name__c from Letter_Templates__c];        
    }
}