public class GoEd_offerletter {
    String var;
    public GoEd__c goed{get;set;}
    public boolean disp_block{get;set;}
    public String curr_date{get;set;}
    public String goed_amt{get;set;}
    public GoEd_offerletter(){
        var=Apexpages.Currentpage().getParameters().get('id');
        DateTime d = datetime.now();
        string monthname= d.format('MMMMM');
        string day = String.valueOf(d.day());
        if (day.endsWith('1'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'st';
        }
        else if (day.endsWith('2'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'nd';
        }
        else if (day.endsWith('3'))
        {
            if(day.StartsWith('1') && day != '1') 
                day=day+'th';
            else 
                day=day+'rd';
        }
        else 
            day=day+'th';
        
        curr_date=monthname+' '+day+', '+d.Year();
        if(var==null){
            disp_block=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide GoEd ID!');
            ApexPages.addMessage(myMsg);
        }
        else{
            try{
                goed=[Select id,Finance__c,Finance__r.GoEd_Financing_Status__c,Finance__r.BBA_GoEd_Loan_Year_1__c,CurrencyIsoCode,Finance__r.BBA_GoEd_Loan_Year_2__c
                    ,Finance__r.Opportunity__r.contact__r.Name,Finance__r.BBA_GoEd_Loan_Year_3__c,Finance__r.BBA_GoEd_Loan_Year_4__c
                    ,Finance__r.Opportunity__r.Program__r.Country__r.Name,Finance__r.Application_Fee__c,Finance__r.Start_Term__c,Finance__r.CurrencyIsoCode
                    ,Finance__r.Go_Ed_Loan_Amount_USD__c,Finance__r.Go_Ed_Loan_Amount__c
                    from GoEd__c where id=:var];
                if(goed.Finance__r.Go_Ed_Loan_Amount__c>0 && goed.Finance__r.GoEd_Financing_Status__c!=null && goed.Finance__r.GoEd_Financing_Status__c!='Not Started'){    
                    disp_block=true;
                    if(goed.Finance__r.Opportunity__r.Program__r.Country__r.Name=='United Kingdom'){
                        goed_amt=goed.Finance__r.CurrencyIsoCode+' '+String.valueOf(goed.Finance__r.Go_Ed_Loan_Amount__c);
                    }
                    else if(goed.Finance__r.Opportunity__r.Program__r.Country__r.Name=='United States' 
                            || goed.Finance__r.Opportunity__r.Program__r.Country__r.Name=='United Arab Emirates'
                            || goed.Finance__r.Opportunity__r.Program__r.Country__r.Name=='China'){
                        goed_amt='USD '+String.valueOf(goed.Finance__r.Go_Ed_Loan_Amount_USD__c);
                    }
                }
                else{
                    disp_block=false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Page cannot be displayed!');
                    ApexPages.addMessage(myMsg);
                }
            }Catch(Exception e){
                disp_block=false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Page cannot be displayed!');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    public Static void sendpdf(set<string> emailfor) {
        // Define the email
        //try{
            list<Goed__c> list_goed  = new list<Goed__C>();
            Map<string,goed__c> goedmap= new Map<string,goed__c>();
            for(goed__c goed:[select id,NAme,Finance__c,Finance__r.Opportunity__r.Applicant_Email__c from goed__c where Finance__c IN:emailfor])
            {
                goedmap.put(goed.Finance__c,goed);
            }
            
            for(string fid:emailfor)
            {
                // Reference the attachment page and pass in the account ID
                PageReference pdf =  Page.GoEd_offerletter;
                pdf.getParameters().put('id',goedmap.get(fid).id); 
                pdf.setRedirect(true);
        
                // Take the PDF content
                Blob body;
        
                try {
                  body = pdf.getContentAsPDF();
                } catch (Exception e) {
                  body = Blob.valueOf('Some Text');
                }//System.Debug('************************'+pdf.getContentAsPDF());
                // Create the email attachment
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType('application/pdf');
                attach.setFileName('testPdf.pdf');
                attach.setInline(false);
                attach.Body = body;
        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                // Sets the paramaters of the email
                mail.setSubject( 'test');
                mail.setToAddresses(new String[] {goedmap.get(fid).Finance__r.Opportunity__r.Applicant_Email__c});
                mail.setPlainTextBody('Important Report Attachment!');
        
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        //}
        //catch (Exception e) {}
    }





}