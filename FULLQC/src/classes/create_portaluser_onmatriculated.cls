/* 
	Developer	: Harsha Simha
	Date	 	: 9/10/2014
	Purpose		: Future Method "create_portaluser" collects list of contactids and checcks if the emailid contains student.hult.edu and creates a user record for them 
					and sends mail to the list of users with success and failure list.
	Test Class	: TEST_Createportal_user.cls(79%)
*/
public with sharing class create_portaluser_onmatriculated 
{
	@future 
	public static void create_portaluser(list<String> cons) 
	{
		list<user> users=new list<user>();
		map<string,contact> finallist=new map<String,contact>();
		set<string> existing_users=new set<string>();
		list<contact> con=[select id,name,Email,start_Term__c,Campus__c,Campus_parsed_from_Program__c ,Program_Parsed__c,FirstName,LastNAme,Program_Primary__c,Student_ID__c,Program_Primary__r.Name  from Contact where id IN: Cons];
		boolean sendmail=false;
		string errorstring='Contact Id,Student Id, Name, Email , Program , Start Term, Error \n';
		string succ_string='Contact Id,Student Id, Name, Email , Program , Start Term, User \n';
		for(contact c:con)
		{
			if(c.Email!=null && c.Email.contains('@student.hult.edu'))
			{
				finallist.put(c.Id,c);
			}
			else
			{
				errorstring+=c.Id+','+c.Student_ID__c+','+c.Name+','+c.Email+','+c.Program_Primary__r.Name+','+c.start_Term__c+', Email id is not Hult Student Mailid \n';
				sendmail=true;
			}
		}
		
		if(!finallist.IsEmpty())
		{
			
			for(user usrs : [select id,Name,Profile_Name__c,ContactId,Username from user where ContactId IN:finallist.keyset()])
			{
				sendmail=true;
				existing_users.add(usrs.contactId);
				Contact c=finallist.get(usrs.contactId);
				errorstring+=c.Id+','+c.Student_ID__c+','+c.Name+','+c.Email+','+c.Program_Primary__r.Name+','+c.start_Term__c+', user already exist for this contact with profile '+usrs.Profile_Name__c+' & username  '+usrs.Username+'.'+Url.getSalesforceBaseUrl().toExternalForm()+'/'+usrs.id +' \n';
			}
			Database.DMLOptions dml = new Database.DMLOptions();
				dml.EmailHeader.triggerUserEmail=true;
				dml.optAllOrNone =false;
			for(String s:finallist.keyset())
			{
				if(existing_users.contains(s))
					continue;
					
				Contact c=finallist.get(s);
				string aliasn=c.FirstName!=null?c.FirstName.substring(0,1):'FN';				
				aliasn+=c.LastName!=null?(c.LastName.length()>=4?c.LastName.substring(0,4):c.LastName):'LN';
				
				string timezone='America/New_York';
				if(c.Campus_parsed_from_Program__c =='Dubai')
					timezone='Asia/Kuwait';
				if(c.Campus_parsed_from_Program__c =='London')
					timezone='Europe/London';
				if(c.Campus_parsed_from_Program__c =='Shanghai')
					timezone='Asia/Shanghai';
				if(c.Campus_parsed_from_Program__c =='San Francisco')
					timezone='America/Los_Angeles';
				if(c.Campus_parsed_from_Program__c =='Boston')
					timezone='America/New_York';
				
				user u=new user();				
				u.FirstName=c.FirstName;
				u.LastName=c.LastName;
                u.Alias=aliasn;
                
				u.TimeZoneSidKey=timezone;
				u.Email=c.Email;
				u.Username=c.Email;
				u.ContactId=c.Id;
				u.languagelocalekey='en_US';
				u.localesidkey='en_US'; 
				u.profileid = '00eU0000000IrdI';
				u.EmailEncodingKey='ISO-8859-1';				
					//u.setoptions(dml);
					
				users.add(u);			
			}
			
			if(!users.IsEmpty())
			{system.debug('--------------00'+users);
				try{
				Database.Saveresult[] sr;
				try{
				sr= Database.insert(users,dml);}
				catch(EXception e1){system.debug(e1);}
				integer i=0;
				System.debug('-----------0 '+sr);
				for (Database.SaveResult result : sr) 
				{					
					Contact c=finallist.get(users[i].ContactId);					
            		if (!result.isSuccess()) 
            		{            			            			
            			Database.Error[] errs = result.getErrors();
            			
            			System.debug(errs+'-----------1 '+result);
            			string er=' ';
		                for(Database.Error err : errs)
		                {   
		                	 
		                	er+=err.getStatusCode() + ' - ' + err.getMessage()+ ' -- ';
		                }
		                sendmail=true;
		                errorstring+=c.Id+','+c.Student_ID__c+','+c.Name+','+c.Email+','+c.Program_Primary__r.Name+','+c.start_Term__c+', Error while inserting'+er+' \n';
            		}
            		else
            		{/*//commented it as emails send to user at the time of creation only.
            			try{
            			System.resetPassword(result.getId() , true);            			
            			}
            			catch(Exception e)
            			{
            				sendmail=true;
            				errorstring+=c.Id+','+c.Name+','+c.Email+','+c.Program_Primary__r.Name+','+c.start_Term__c+',Reset password for - '+Url.getSalesforceBaseUrl().toExternalForm()+'/'+result.getId() +', error msg -'+e+' \n';
            			}*/
            			sendmail=true;
            			succ_string+=c.Id+','+c.Student_ID__c+','+c.Name+','+c.Email+','+c.Program_Primary__r.Name+','+c.start_Term__c+','+Url.getSalesforceBaseUrl().toExternalForm()+'/'+result.getId() +' \n';
            			System.debug(succ_string+'-----------2'+result);
            		}
            		i++;
            	}
            	
            	}catch(Exception e){}
			
			}
		}
		System.debug(sendmail+'-----------3 '+succ_string);
		System.debug('-----------4 '+errorstring);
		if(sendmail)
			sendmail(errorstring,succ_string);
	}
	
	public static void sendmail(string err_bdy,string succ_bdy)
    {
    	System.debug(succ_bdy+'-----------5 '+err_bdy);
    	string body='<B>HI all,<br/><p>Please find attached the list of HCP users processed and created on '+System.today()+
					'<br/><br/>Success List.csv shows the list of users created successfully. NO ACTION IS REQUIRED FOR THOSE.'+
					'<br/>Error List.csv shows the list of users who could not be created (details in the list attached). THOSE NEED TO BE PROCESSED MANUALLY.</P></b>';

    	
   			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Error List.csv');            
            Blob b=Blob.valueOf(err_bdy);
            efa.setContentType('text/csv');             
            efa.setBody(b);      
            
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName('Success List.csv');            
            Blob b1=Blob.valueOf(succ_bdy);
            efa1.setContentType('text/csv');             
            efa1.setBody(b1); 
            System.debug(efa+'-----------5 '+efa1);
             
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[] {'harsha.simha@EF.com','hultservicedeliveryteam@hult.edu'});        
            mail.setSenderDisplayName('HULT SFDC TEAM');
            mail.setSubject('User Record Creation for students - Update '+system.today());
            
            mail.setHtmlBody(body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa,efa1});     
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
    }
	
}