trigger Test_Requirement_dep_errors on Requirement__c (before insert, before update) 
{
	boolean sendmail=false;
	string mail_header='Requirement Id,Requirement Name,Record Type,Program	,Parent Requirement,Opportunity,Parent Requirement: Department,Opp: Program Department,Mismatched Departments?,Mismatched Country?\n';
	for(Requirement__c req:Trigger.new)
	{
		if(req.Mismatched_Departments__c=='Yes' || req.Mismatch_Country__c=='Yes')
		{
			sendmail=true;
			mail_header+=req.Id+','+req.Name+','+req.RecordTypeId+','+req.Program__c+','+req.Parent__c+','+req.Opportunity__c+','+
							req.Parent_Requirement_Department__c+','+req.Opportunity_Program_Department__c+','+
							req.Mismatched_Departments__c+','+req.Mismatch_Country__c+'\n';
			
		}		
	}
	if(sendmail)
	{
		 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
         List<Messaging.EmailFileAttachment> lefa = new list<Messaging.EmailFileAttachment>();
          
            mail.setToAddresses(new String[] {'harsha.simha@EF.com'});        
            //mail.setSenderDisplayName('New Owner ');
            mail.setSubject('Requirement Failed Records');
            mail.setHtmlBody('Hi All,<br/> PFA for the list of Requirement records which may fail when mismatched Country and department. Please do needfull');            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Requirements_mismatched.csv');
                Blob b=Blob.valueOf(mail_header);
                efa.setContentType('text/csv');             
                efa.setBody(b); 
                lefa.add(efa);
                //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});    
           
           mail.setFileAttachments(lefa);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	
	}
}