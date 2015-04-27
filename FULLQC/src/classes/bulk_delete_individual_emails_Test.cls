@IsTest
private class bulk_delete_individual_emails_Test{
 static testmethod void bulk_delete_individual_emails() {   
   
    date ext_date=System.today().addDays(-14);  
    set<id>ids=new set<id>(); 
    

     List <xtma_Individual_Email_Result__c> lds = new List<xtma_Individual_Email_Result__c>();
            for(integer i = 0; i<5; i++){
             
                xtma_Individual_Email_Result__c l = new xtma_Individual_Email_Result__c(); 
                l.name='anil';
                l.Date_Time_Sent__c=system.today();
                l.Date_Bounced__c=system.today();
                l.Date_Unsubscribed__c=system.today();
                l.Date_Time_Opened__c=system.today();               
                lds.add(l);
                
            }    
        insert lds;       
       
       Test.startTest(); 
        
        String query='select id,name,Campaign__c,Contact__c,Date_Bounced__c,Date_Time_Opened__c,Date_Time_Sent__c,Date_Unsubscribed__c,From_Address__c,From_Name__c,Lead__c,Number_of_Total_Clicks__c,Number_of_Unique_Clicks__c,Opened__c,Report_Name__c,Subject_Line__c from xtma_Individual_Email_Result__c limit 20';
       
        Del_Ind_Email_Results c = new Del_Ind_Email_Results(query); 
        
        ID batchprocessid = Database.executeBatch(c,200);

   // Schedule the test job     

      String jobId = System.schedule('testBasicScheduledApex',bulk_delete_individual_emails.CRON_EXP,new bulk_delete_individual_emails());
   // Get the information from the CronTrigger API object 
    

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same 
    
      System.assertEquals(bulk_delete_individual_emails.CRON_EXP,ct.CronExpression);

   // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);

   // Verify the next time the job will run 
    
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
     

   Test.stopTest();

  

   }
   }