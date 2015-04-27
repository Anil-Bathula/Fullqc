global class batch_updateopp_reqs implements Database.Batchable<sobject>,Database.stateful
{
	/*
		Developer 	:Harsha Simha S
		Date		:18/4/2013
		Summary		:This code is used to extract opportunities which dont have requirements
		Test Class	:batch_updateopp_reqs(70%)
					 ****
					 code to run this batch, change logic as required.
					 ----
					 	string query= 'select id,Name,Start_Term__c,(select id,NAme from Requirements__r) from opportunity where Program__c!=null and Contact__c!=null and start_term__c like \'%2013\'';//'select id,name from Opportunity where start_term__c like \'%2013\'';                
						batch_updateopp_reqs der=new batch_updateopp_reqs(query);   
						database.executebatch(der,200);
					 ****
	*/
	global String query;
	global String email_hdr;
	global integer total_count;
	global integer noreqs_count;
	public batch_updateopp_reqs(string q)
	{
	    this.query=q;
	    email_hdr='Id,Name,Start Term\n';
	    total_count=0;
	    noreqs_count=0;
	    
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
	 	system.debug(query);
      return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC,List<sobject> recs)
   	{   		
        list<opportunity> ono=new list<opportunity>();
		//list<opportunity> opp=[select id,Name,(select id,NAme from Requirements__r) from opportunity where Program__c!=null and Contact__c!=null and id IN:recs];
		//system.debug(opp);
		//for(opportunity o:opp)
		system.debug(recs);
		total_count+=recs.size();
		for(sobject s:recs)
		{
			Opportunity o=(opportunity)s;
			system.debug('---'+o);
			system.debug(o.Requirements__r.size()+'---'+o.Requirements__r);
			if(o.Requirements__r.ISEmpty())
		     {
		     	noreqs_count+=1;
		     	o.Update_Requirements__c=true; 
		     	ono.add(o);                
		     	email_hdr+=o.id+','+o.Name+','+o.Start_Term__c+'\n';
		     }
		}
		system.debug(ono.size()+'--'+ono);
		//if(!ono.ISEmpty()){update ono;}
   	}
   	global void finish(Database.BatchableContext BC){        
    	 	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Email Results'+System.today().day()+'_'+System.today().Month()+'_'+System.today().Year()+'.csv');
            Blob b=Blob.valueOf(email_hdr);
            efa.setContentType('text/csv');             
            efa.setBody(b);       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'harsha.simha@EF.com'});        
            mail.setSenderDisplayName('Batch Processing_update reqs');
            mail.setSubject('Batch Process _update Requirements Completed - '+system.today());
            mail.setPlainTextBody('Please find the attachment of updated Requirement records, dated : '+system.today()+'\n Total Opps Processed :'+total_count+'\n Opportunities without Requirements :'+noreqs_count);            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});     
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
    }
    @istest
    public static void testthisbatch()
    {
    	string query= 'select id,Name,Start_Term__c,(select id,NAme from Requirements__r) from opportunity where Program__c!=null and Contact__c!=null and start_term__c like \'%2013\'';//'select id,name from Opportunity where start_term__c like \'%2013\' limit 500';                
		batch_updateopp_reqs der=new batch_updateopp_reqs(query);   
		database.executebatch(der,200);
    }
}