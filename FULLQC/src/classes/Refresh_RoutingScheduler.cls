global class Refresh_RoutingScheduler implements Schedulable {
	
	global void execute(SchedulableContext ctx) 
    {
        List<CronTrigger> ct = [SELECT id, CronExpression, CronJobDetailId, CronJobDetail.Name, OwnerId, PreviousFireTime, StartTime, EndTime, NextFireTime, State, TimesTriggered from CronTrigger where CronJobDetail.Name like 'MessageServicer#%'];
        if(!ct.isEmpty())
    	{
    		if((ct[0].NextFireTime!=null && ct[0].NextFireTime<System.now())||(ct[0].StartTime!=null && ct[0].StartTime.addhours(3)<System.now()))
         	{
         		try{
         		system.abortJob(ct[0].Id);
         		}catch(Exception e){}
		        rC_Core.MessageServicerSchedulable.schedule(new rC_Core.MessageServicer.Servicer[] {
				new Lead_ConvertApplicantServicer(),
				new Lead_RouteByRecruitingServicer(),
				new Contact_RouteByRecruitingServicer()
				}); 		
				
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
	            mail.setToAddresses(new String[] {'harsha.simha@EF.com'});        
	            mail.setSenderDisplayName('Scheduler Restarted');
	            mail.setSubject('Scheduler Restarted @ '+system.now());
	            mail.setPlainTextBody('Hi All,\n Scheduler has restarted @ '+system.Now()+'\n please check once Every thing is working fine./n Total Messageservicer#... schedulers are '+ct.size()+' /n Thanks, /n Harsha.');
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
				
         	}       		
    	} 
    	else
    	{
    		rC_Core.MessageServicerSchedulable.schedule(new rC_Core.MessageServicer.Servicer[] {
				new Lead_ConvertApplicantServicer(),
				new Lead_RouteByRecruitingServicer(),
				new Contact_RouteByRecruitingServicer()
				}); 		
				
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
	            mail.setToAddresses(new String[] {'harsha.simha@EF.com'});        
	            mail.setSenderDisplayName('Scheduler Restarted');
	            mail.setSubject('Scheduler Restarted @ '+system.now());
	            mail.setPlainTextBody('Hi All,\n Scheduler has restarted @ '+system.Now()+'\n Query dint returned values. /n please check once Every thing is working fine. /n Thanks, /n Harsha.');
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    	
    	}   		
    }
    
}