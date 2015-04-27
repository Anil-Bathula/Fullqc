global class Del_Ind_Email_Results implements Database.Batchable<sobject> ,Database.Stateful
{
   global String query;
   global String email_hdr;
   global String email_reslts;
   global integer email_count;  
   global boolean send_email;
   global date ext_date=System.today().addDays(-14);  
  
  public Del_Ind_Email_Results(string q)
  {
    this.query=q;
    email_hdr='Id,Name,Campaign,Contact,Date Bounced,Date Opened,Date Sent,Date Unsubscribed,From Address,From Name,Lead,Number of Total Clicks,Number of Unique Clicks,Opened,Report,Subject Line\n';
    email_reslts=email_hdr;
    email_count=0;
    send_email=false;   
    
  }
   global Database.QueryLocator start(Database.BatchableContext BC){
      system.debug(query);
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC,List<sobject> recs)
   {
    
        string temp;
        List<xtma_Individual_Email_Result__c> delIer=new List<xtma_Individual_Email_Result__c>();
        for(sobject s:recs)
        {
            xtma_Individual_Email_Result__c Ier=(xtma_Individual_Email_Result__c)s;         
            string name =Ier.Name==null?'':string.ValueOf(Ier.Name).replaceAll(',','');
            string camp=Ier.Campaign__c==null?'':string.ValueOf(Ier.campaign__c).replaceAll(',','');
            string cont=Ier.Contact__c==null?'':String.ValueOf(Ier.Contact__c).replaceAll(',','');
            string dbncd=Ier.Date_Bounced__c==null?'':String.ValueOf(Ier.Date_Bounced__c).replaceAll(',','');
            string dto=Ier.Date_Time_Opened__c==null?'':String.ValueOf(Ier.Date_Time_Opened__c).replaceAll(',','');
            string dts=Ier.Date_Time_Sent__c==null?'':String.ValueOf(Ier.Date_Time_Sent__c).replaceAll(',','');
            string dus=Ier.Date_Unsubscribed__c==null?'':String.ValueOf(Ier.Date_Unsubscribed__c).replaceAll(',','');
            string fad=Ier.From_Address__c==null?'':String.ValueOf(Ier.From_Address__c).replaceAll(',','');
            string fnam=Ier.From_Name__c==null?'':String.ValueOf(Ier.From_Name__c).replaceAll(',','');
            string led=Ier.Lead__c==null?'':String.ValueOf(Ier.Lead__c).replaceAll(',','');
            string tclks=Ier.Number_of_Total_Clicks__c==null?'':String.ValueOf(Ier.Number_of_Total_Clicks__c).replaceAll(',','');
            string uclks=Ier.Number_of_Unique_Clicks__c==null?'':String.ValueOf(Ier.Number_of_Unique_Clicks__c).replaceAll(',','');
            string opn=Ier.Opened__c==null?'':String.ValueOf(Ier.Opened__c).replaceAll(',','');
            string rep=Ier.Report_Name__c==null?'':String.ValueOf(Ier.Report_Name__c).replaceAll(',','');
            string sub=Ier.Subject_Line__c==null?'':String.ValueOf(Ier.Subject_Line__c).replaceAll(',','');
            
            if(temp==null)temp=' ';         
            temp+=Ier.id+','+name+','+camp+','+cont+','+dbncd+','+dto+','+dts+','+dus+','+fad+','+fnam+','+led+','+tclks+','+uclks+','+opn+','+rep+','+sub+'\n';
            delier.add(ier);        
        }
        if(temp!=null)
        {
            try{
                Delete delier;
                email_reslts+=temp;
                send_email=true;                
            }   
            catch(Exception e)
            {
                system.debug(e);
            }   
            if(Blob.valueOf(email_reslts).size()>=8388608)
            {
                sendmail(email_reslts,email_count);
                email_reslts=email_hdr;
                send_email=false;
            }
        }
    
   }  
   
   global void finish(Database.BatchableContext BC){        
        System.debug(LoggingLevel.WARN,'Deleting Individual Email Results Finished');
        if(send_email && email_reslts!=email_hdr)
        {
            sendmail(email_reslts,email_count);
        }
   }
   
   public void sendmail(string mailbody,integer mailcount)
   {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Email Results'+System.today().day()+'_'+System.today().Month()+'_'+System.today().Year()+'_'+mailcount+'.csv');
            Blob b=Blob.valueOf(mailbody);
            efa.setContentType('text/csv');             
            efa.setBody(b);       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'anil.bathula@EF.com'});        
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Process Completed - '+system.today());
            mail.setPlainTextBody('Please find the attachment of deleted records, dated : '+system.today());            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});     
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            email_count++;  
   }
   
}