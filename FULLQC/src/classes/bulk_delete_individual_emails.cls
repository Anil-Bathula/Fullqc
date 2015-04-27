/******************************************************************************
Class:bulk_delete_individual_emails
Written By: Anil.B
Purpose:To Schedule the batch apex for deleting the Records from Individal Email Results object
******************************************************************************/

global class bulk_delete_individual_emails Implements Schedulable{

public static String CRON_EXP = '0 0 0 3 9 ? 2022';
/*Method to query for the records to delete */

     global void Execute(SchedulableContext SC){  
       string query='select id,name,Campaign__c,Contact__c,Date_Bounced__c,Date_Time_Opened__c,Date_Time_Sent__c,Date_Unsubscribed__c,From_Address__c,From_Name__c,Lead__c,Number_of_Total_Clicks__c,Number_of_Unique_Clicks__c,Opened__c,Report_Name__c,Subject_Line__c from xtma_Individual_Email_Result__c where Date_Time_Sent__c<=:ext_date limit 200000 ';            
       Del_Ind_Email_Results der=new Del_Ind_Email_Results(query);            
       database.executebatch(der);         
     }     
}