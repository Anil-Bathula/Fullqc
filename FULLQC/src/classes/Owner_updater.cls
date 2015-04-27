global class Owner_updater implements Database.Batchable<sobject>,Database.stateful{ 
     global map<string,String> lst_objects;     
     global map<string,String> route_lst_vals;
     global String mailbody; 
     global boolean sendemail;
     //global string sucmailbody;
     public Owner_updater(map<string,string> lst,map<string,string> route_lst)  
     {
        this.lst_objects=lst;  
        this.route_lst_vals=route_lst; 
        mailbody='Id,StatusCode,Error Message,Fields Affected the Error,Inactive OwnerId,Substitute OwnerId\n';
       // sucmailbody='Id,owner id\n';
        sendemail=false;
     }
     
     global Database.QueryLocator start(Database.BatchableContext BC)
     {      
        List<string> temp=new list<string>();
        temp.addAll(lst_objects.Keyset());
        return Database.getQueryLocator('select id,Name,ownerid from contact where ownerid IN: temp');         
     }     
     
     global void execute(Database.BatchableContext BC,List<sobject> recs)
     {          
        list<Contact> con=new list<Contact>();
        for(sobject s:recs)
        {
            Contact c=(Contact)s;
            c.OwnerId=lst_objects.get(c.OwnerId);
            con.add(c);
        } 
        if(!con.Isempty())
        {
            try
            {
                Database.SaveResult[] lsr =  Database.update(con,false);
                integer i=0;    
                for (Database.SaveResult sr : lsr) 
                {
                    /*if (sr.isSuccess()) 
                    {
                        sucmailbody+=sr.getId()+','+con[i].Id+','+con[i].OwnerId+'\n';
                    }*/
                    if (!sr.isSuccess()) 
                    {
                        for(Database.Error err : sr.getErrors()) 
                        {
                            sendemail=true;
                            string recid,reconr_old;
                            try
                            {
                            	recid=con[i].id;
                            	reconr_old=con[i].OwnerId;
                            }
                            catch(Exception e){system.debug(e);}                                
                            string flds=''+err.getFields(); 
                            mailbody+=recid+','+err.getStatusCode()+','+err.getMessage().escapeCsv()+','+flds.escapeCsv()+','+reconr_old+','+lst_objects.get(reconr_old)+'\n';
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
        string route_mailbody='Id,StatusCode,Error Message,Fields Affected the Error,Inactive UserId,Substitute UserId\n';
        boolean route_sendemail=false;
        if(!route_lst_vals.Isempty())
        {           
            
                List<Routing_Table__c> routlst=[select id,Name,OwnerID,Routed_By__c,Routed_To__c from Routing_Table__c where Routed_To__c in:route_lst_vals.keyset()];
                for(Routing_Table__c r:routlst)
                {
                    r.Routed_To__c=route_lst_vals.get(r.Routed_To__c);                                        
                }
                try
                { 
                    Database.SaveResult[] lsr =  Database.update(routlst,false);
                    integer i=0;
                    for (Database.SaveResult sr : lsr) {
                        if (!sr.isSuccess()) 
                        {
                            for(Database.Error err : sr.getErrors()) 
                            {
                                route_sendemail=true;   
                                string recid,reconr_old;
	                            try
	                            {
	                            	recid=routlst[i].id;
	                            	reconr_old=routlst[i].Routed_To__c;
	                            }
	                            catch(Exception e){system.debug(e);}     
	                            string flds=''+err.getFields();                         
                                route_mailbody+=recid+','+err.getStatusCode()+','+err.getMessage().escapeCsv()+','+flds.escapeCsv()+','+reconr_old+','+route_lst_vals.get(reconr_old)+'\n';
                            }
                        }
                        i++;
                    }                   
                }
                catch(Exception e)
                {
                    system.debug(e+'-------------------------------------IM LAst');
                }
        }
        if(sendemail || route_sendemail)
        {
                  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'harsha.simha@EF.com','daniel.mora@ef.com','Meghan.Shoemaker@EF.com'});        
            //mail.setSenderDisplayName('New Owner ');
            mail.setSubject('New Owner Update Failed Records');
            mail.setHtmlBody('Hi All,<br/> PFA for the list of contact/Routing records which are failed when Owner/Routed to user is deactivated.<br/><br/> Please do needfull');            
            
            List<Messaging.EmailFileAttachment> lefa = new list<Messaging.EmailFileAttachment>();
            if(sendemail)
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('ownerupdate failed Contacts.csv');
                Blob b=Blob.valueOf(mailbody);
                efa.setContentType('text/csv');             
                efa.setBody(b); 
               // mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});   
               lefa.add(efa);
                
                /*Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
                efa1.setFileName('ownerupdate succeeded Contacts.csv');
                Blob b1=Blob.valueOf(sucmailbody);
                efa1.setContentType('text/csv');             
                efa1.setBody(b1); 
                //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});   
                lefa.add(efa1);*/
            }
            if(route_sendemail)
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('Reoutedto failed Routing Rules.csv');
                Blob b=Blob.valueOf(route_mailbody);
                efa.setContentType('text/csv');             
                efa.setBody(b); 
                lefa.add(efa);
                //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});     
            }
            mail.setFileAttachments(lefa);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }     
     }  
}