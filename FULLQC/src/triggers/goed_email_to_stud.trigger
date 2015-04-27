trigger goed_email_to_stud on Opportunity_Finance__c (after insert,after update) 
{
    list<string> fin_ids=new list<string>();
    for(Opportunity_Finance__c new_fin:trigger.New)
    {
        Opportunity_Finance__c old_fin=Trigger.Isinsert?new Opportunity_Finance__c():Trigger.Oldmap.get(new_fin.Id);
          if(old_fin.Go_Ed_Loan_Amount__c!=new_fin.Go_Ed_Loan_Amount__c && new_fin.Go_Ed_Loan_Amount__c!=null 
              && new_fin.GoEd_Financing_Status__c!=null && new_fin.GoEd_Financing_Status__c!='Not Started')
          {
              fin_ids.add(new_fin.Id);
              
          }
    
    }
    if(!fin_ids.IsEmpty())
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(goed__c goed:[select id,Name,Finance__c,Finance__r.Opportunity__r.Applicant_Email__c
                            ,Finance__r.Opportunity__r.Contact__r.Name from goed__c where Finance__c IN:fin_ids])
        {
            String userEmail = goed.Finance__r.Opportunity__r.Applicant_Email__c; 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            String[] toAddresses = new String[] {userEmail}; 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('GoEd offer letter'); 
            String fullFileURL='<a href="https://fullqc-hult-international-business-school.cs10.force.com/portal/GoEd_offerletter?id='+goed.id+'">Click Here</a>';
            String htmlBody= 'Hi '+goed.Finance__r.Opportunity__r.Contact__r.Name+'<br/><br/>';
            htmlBody+='Your GoED amount is changed. Please '+fullFileURL+' for your GoEd offer letter.<br/><br/><br/>';
            htmlBody+='<br/><br/> Thanks <br/> Hult Finance Team';
            
            mail.setHtmlBody(htmlBody); 
            mails.add(mail);
        }
        if(!mails.isEmpty())
            Messaging.sendEmail(mails);
    }
    
}