@RestResource(UrlMapping='/goed_pdf/*')
global class webservice2pdf 
{
    @httpget
	global static void Mail_goed_Pdf()
	{
        Restrequest req=restContext.Request;
        map<string,object> param=new map<String,object>();
        try
		{
			String temp=req.requestBody.toString();
			system.debug(temp);			
			param= (Map<String, Object>)JSON.deserializeUntyped(temp);
		}
		catch(Exception e)
		{
			
		}
		if(!param.isEmpty())
		{
            try
            {
                if(param.containsKey('fin_ids'))
                {
            		list<string> Finids=(List<string>)param.get('fin_ids');
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    for(goed__c goed:[select id,NAme,Finance__c,Finance__r.Opportunity__r.Applicant_Email__c from goed__c where Finance__c IN:Finids])
                    {
                        PageReference pdf = new PageReference('/apex/GoEd_offerletter?id='+goed.Id);
                        Blob body;            
                        try 
                        {
                          body = pdf.getContentAsPDF();
                        } 
                        catch (VisualforceException e) 
                        {
                          body = Blob.valueOf('PDF Get Failed');
                        }
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType('application/pdf');
                        attach.setFileName('reportPdf.pdf');
                        attach.setInline(false);
                        attach.Body = body;
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setUseSignature(false);
                        mail.setToAddresses(new String[] { 'harsha.simha@ef.com'});
                        mail.setSubject('Report PDF Email Demo by shs');
                        mail.setHtmlBody('Important Report Attachment!');
                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                        
                        mails.add(mail);
                    }
                    // Send the email
                    Messaging.sendEmail(mails);
                    
                }
            }
            catch(Exception e)
            {}
        }
        
    }
	webService static void getpdf(list<string> Finids) 
    {//webservice2pdf.getpdf(); 
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    	for(goed__c goed:[select id,NAme,Finance__c,Finance__r.Opportunity__r.Applicant_Email__c from goed__c where Finance__c IN:Finids])
        {
            PageReference pdf = new PageReference('/apex/GoEd_offerletter?id='+goed.Id);
            Blob body;            
            try 
            {
              body = pdf.getContentAsPDF();
            } 
            catch (VisualforceException e) 
            {
              body = Blob.valueOf('PDF Get Failed');
            }
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('reportPdf.pdf');
            attach.setInline(false);
            attach.Body = body;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { 'harsha.simha@ef.com'});//,goed.Finance__r.Opportunity__r.Applicant_Email__c });
            mail.setSubject('Report PDF Email Demo by shs');
            mail.setHtmlBody('Important Report Attachment!');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            
            mails.add(mail);
        }
        // Send the email
        Messaging.sendEmail(mails);
    }
    
    @future(callout=true)
    public static void getpdfs(list<string> finids)
    {
        string endpoint_url= Url.getSalesforceBaseUrl().toExternalform()+'/services/apexrest/goed_pdf';
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint( endpoint_url);
        req.setMethod('GET');
        string body='{"fin_ids":[';
        integer i=0;
        for(string s:Finids)
        {
            body+=i==0?'"'+s+'"':'",'+s+'"';
        }
        body+=']}';
        Http h = new Http();
        HttpResponse res = h.send(req);    
        
    }
}