global class test_MyFutureClass {
  
  @future
  public static void testfuture_pdf() 
  {//test_MyFutureClass.testfuture_pdf();
        PageReference pdf = new PageReference('/apex/Acceptanceletters_2015?id=006U00000030BRf&type=pdf');
//        pdf.getParameters().put('id','006U00000030BRf');
//        pdf.getParameters().put('id','pdf');
        
        Blob body;
        
        try {
        
          // returns the output of the page as a PDF
          body = pdf.getContentAsPDF();
        } catch (VisualforceException e) {
          body = Blob.valueOf('PDF Get Failed');
        }
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('acceptance_letter.pdf');
        attach.setInline(false);
        attach.Body = body;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { 'harsha.simha@ef.com' });
        mail.setSubject('Report PDF Email Demo');
        mail.setHtmlBody('Important Report Attachment!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
  }
}