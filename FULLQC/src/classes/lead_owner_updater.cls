global class lead_owner_updater implements Database.Batchable<sobject>,Database.stateful{ 
     global map<string,String> lst_objects;     
     global String mailbody;
     global boolean sendemail;
     public lead_owner_updater(map<string,string> lst)  
     {
        this.lst_objects=lst;   
        mailbody='Id,StatusCode,Error Message,Fields Affected the Error,Inactive OwnerId,Substitute OwnerId\n';
        sendemail=false;
     }
     
     global Database.QueryLocator start(Database.BatchableContext BC)
     {      
        List<string> temp=new list<string>();
        temp.addAll(lst_objects.Keyset());
        return Database.getQueryLocator('select id,Name,ownerid from lead where ownerid IN:temp and IsConverted=false');           
     }     
     
     global void execute(Database.BatchableContext BC,List<sobject> recs)
     {          
        list<Lead> led=new list<Lead>();
        for(sobject s:recs)
        {
            Lead l=(Lead)s;         
            l.OwnerId=lst_objects.get(l.OwnerId);
            led.add(l);
        } 
        if(!led.Isempty())
        {
            try{
                Database.SaveResult[] lsr =  Database.update(led,false);
                    Integer i=0;
                for (Database.SaveResult sr : lsr) 
                {
                    if (!sr.isSuccess()) 
                    {
                        for(Database.Error err : sr.getErrors()) 
                        {
                            sendemail=true;  
                            string reconr_old=led[i].OwnerId;                           
                            mailbody+=led[i].id+','+err.getStatusCode()+','+err.getMessage()+','+err.getFields()+','+reconr_old+','+lst_objects.get(reconr_old)+'\n';
                        }
                    }
                    i++;
                }    
            }
            catch(Exception e)
            {
                System.DEbug(e);
            }
        }
             //update accsToUpdate; 
     }  
        
     global void finish(Database.BatchableContext info)
     {
        if(sendemail)
        {
                  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'harsha.simha@EF.com','daniel.mora@ef.com','Meghan.Shoemaker@EF.com'});        
            //mail.setSenderDisplayName('New Owner ');
            mail.setSubject('New Owner Update Failed Records');
            mail.setHtmlBody('Hi All,<br/> PFA for the list of Lead records which are failed when Owner is deactivated.<br/><br/> Please do needfull');            
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('ownerupdate failed Leads.csv');
                Blob b=Blob.valueOf(mailbody);
                efa.setContentType('text/csv');             
                efa.setBody(b); 
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});     
                        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
             system.debug('-------------------------------------IM LAst');
     }  
}