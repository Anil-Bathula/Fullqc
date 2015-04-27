Public without sharing  Class StudentFinancialInformationController
{

    public User user{get;set;}
    public Opportunity opp{get;set;}
    public Opportunity_Finance__c oppfin{get;set;}
    public Decimal Percent_Complete_c{get;set;}
    public boolean Unlock_Student_Financial_Information_c{get;set;}
    public boolean Paid_Application_Fee_c{get;set;}
    public boolean isAcceptanceletter{get;set;}
    public string proname{get;set;}
    public boolean isPayConfirmationDeposit{get;set;}
    public string Applicant_Confirmation_c{get;set;}
    public string App_ID_c{get;set;}
    public boolean Program_and_Location_Tab_Complete_c{get;set;}
    public boolean Personal_Information_Complete_c{get;set;}
    public boolean Education_Tab_Complete_c{get;set;}
    public boolean Employment_Tab_Complete_c{get;set;}
    public boolean Exam_History_Tab_Complete_c{get;set;}
    public boolean Sponsorship_Tab_Complete_c{get;set;}
    public boolean Essay_Tab_Complete_c{get;set;}
    public boolean Reference_Tab_Complete_c{get;set;}
    public boolean Attachments_Tab_Complete_c{get;set;}
    public integer Percentage_Complete_Application_c{get;set;}
    public boolean isFinalSubmission{get;set;}
    public boolean isTuitionPayments{get;set;}
    public boolean isApplicationFeePayment{get;set;}
    public boolean Confirmation_Deposit_Paid_c{get;set;}
    
    public StudentFinancialInformationController() {
        user = new User();
        opp = new Opportunity();
        oppfin = new Opportunity_Finance__c();
        Percent_Complete_c = 0;
        Unlock_Student_Financial_Information_c = false;
        isFinalSubmission=false;
        isTuitionPayments=false;
        isApplicationFeePayment=false;
        isPayConfirmationDeposit=false;
        
        User[] userList = [
            select Contact.FirstName
                 , Contact.LastName 
              from User 
             where Id = :UserInfo.getUserId()
        ];
        
        if (userList.size() == 0)
            return;
       
        user = userList[0];
        
        // Find the opportunity record
        Opportunity[] opportunityList = [
            select Name
                 , Program__r.Name
                 , StageName
                 , Application_Substage__c
                 , Percent_Complete__c
                 ,Paid_Application_Fee__c
                 ,Applicant_Confirmation__c
                 ,App_ID__c
                 ,Program_and_Location_Tab_Complete__c
                 ,Personal_Information_Complete__c
                 ,Education_Tab_Complete__c
                 ,Employment_Tab_Complete__c
                 ,Exam_History_Tab_Complete__c
                 ,Sponsorship_Tab_Complete__c
                 ,Essay_Tab_Complete__c
                 ,Reference_Tab_Complete__c
                 ,Attachments_Tab_Complete__c
                 ,Percentage_Complete_Application__c
              from Opportunity 
             where Contact__c = :user.Contact.Id
        ];
        
        if (opportunityList.size() == 0)
            return;
        
        opp = opportunityList[0];
        App_ID_c = opp.App_ID__c;   
        Percentage_Complete_Application_c=Integer.valueOf(opp.Percentage_Complete_Application__c.round());
        Program_and_Location_Tab_Complete_c=opp.Program_and_Location_Tab_Complete__c;
        Personal_Information_Complete_c=opp.Personal_Information_Complete__c;
        Education_Tab_Complete_c=opp.Education_Tab_Complete__c;
        Employment_Tab_Complete_c=opp.Employment_Tab_Complete__c;
        Exam_History_Tab_Complete_c=opp.Exam_History_Tab_Complete__c;
        Sponsorship_Tab_Complete_c=opp.Sponsorship_Tab_Complete__c;
        Essay_Tab_Complete_c=opp.Essay_Tab_Complete__c;
        Reference_Tab_Complete_c=opp.Reference_Tab_Complete__c;
        Attachments_Tab_Complete_c=opp.Attachments_Tab_Complete__c;
        Applicant_Confirmation_c=opp.Applicant_Confirmation__c;
        Percent_Complete_c=opp.Percent_Complete__c;
        Paid_Application_Fee_c=opp.Paid_Application_Fee__c;
        proname=opp.Program__r.Name;
        
       /* if((opp.stageName=='Confirmed') || (opp.stageName=='Cond. Accepted') || (opp.stageName=='Endorsed') ){
            isAcceptanceletter = true;
        }*/
        if ((opp.stageName=='Accepted' || opp.stageName=='Conditionally Accepted' || opp.stageName=='Admissions Endorsed') && opp.Application_Substage__c=='Notified'){
            isAcceptanceletter = true;
            isPayConfirmationDeposit = true;
            isFinalSubmission=false;
            isTuitionPayments=false;
            isApplicationFeePayment=false;
        }else if(    opp.stageName=='Confirmed' || opp.stageName=='Conditionally Confirmed'
                 || opp.stageName=='Endorsed Confirmed' || opp.stageName=='Waitlisted Confirmed'
                 || opp.stageName=='Cancellation' || opp.stageName=='Deferral'
                 || opp.stageName=='Enrolled' || opp.stageName=='Admissions Endorsed Confirmed'|| opp.stageName=='Soft Rejected Confirmed' ){
            isAcceptanceletter = true;
        }
        else{
            isAcceptanceletter = false;
        }
        
         
        // Find the opportunity finance record
        Opportunity_Finance__c[] opportunityFinanceList = [
            select Unlock_Student_Financial_Information__c,Confirmation_Deposit_Paid__c 
              from Opportunity_Finance__c 
             where Opportunity__c = :opp.id
        ];
        
        if(Applicant_Confirmation_c=='No' && Paid_Application_Fee_c==false){
            isApplicationFeePayment=true;
            isPayConfirmationDeposit=false;
            isFinalSubmission=false;
            isTuitionPayments=false;
        }
        
        if (opportunityFinanceList.size() == 0)
            return;
        oppfin = opportunityFinanceList[0];
        Unlock_Student_Financial_Information_c = oppfin.Unlock_Student_Financial_Information__c;
        Confirmation_Deposit_Paid_c=oppfin.Confirmation_Deposit_Paid__c;
       
        if(Applicant_Confirmation_c=='Yes' && Unlock_Student_Financial_Information_c==true){
            isTuitionPayments=true;
            isPayConfirmationDeposit=false;
            isFinalSubmission=false;
            isApplicationFeePayment=false;
        }
        if((Applicant_Confirmation_c=='No' && Paid_Application_Fee_c==true)||(Applicant_Confirmation_c=='Yes' && isTuitionPayments==false && isPayConfirmationDeposit==false) ){
            isFinalSubmission=true;
            isPayConfirmationDeposit=false;
            isTuitionPayments=false;
            isApplicationFeePayment=false;
        }
        if(Confirmation_Deposit_Paid_c==true && isTuitionPayments==false){
            isPayConfirmationDeposit=true;
            isFinalSubmission=false;
            isTuitionPayments=false;
            isApplicationFeePayment=false;
        }
   }
        
   static testMethod void testPStudentFinancialInformation() {  
        
         User currentUser = [select id,contact.id, title, firstname, lastname, email FROM User WHERE Profile.Name  = 'Applicant Customer Portal User' and IsActive  = true limit 1];      
                program__c pro = new program__c();
                pro.Name = 'TestMBA-UAE-Dubai';
                pro.Active__c = true;
                insert pro;
                //program__c pro =[select id from program__c where Name='MBA-UAE-Dubai'];
                
                try{
                Opportunity opp = new Opportunity();
                opp.Name = 'Test Opportunity';
                opp.Contact__c = currentUser.Contact.Id;
                opp.StageName ='Accepted';
                opp.CloseDate = Date.today();
                opp.Program__c=pro.id;
                opp.Education_Tab_Complete__c=false;
                opp.Primary_Program_Choice__c = 'Master of Business Administration';
                insert opp;
                Opportunity_Finance__c oppfin= new Opportunity_Finance__c();
                oppfin.Opportunity__c=opp.id;
                oppfin.CurrencyIsoCode='USD';
                //oppfin.Payment_Plan__c='Regular';
                oppfin.I_agree_to_Hult_Terms_and_Conditions__c=true;
                oppfin.Unlock_Student_Financial_Information__c=true;
                insert oppfin;} catch (exception e){}
        
        
        System.runAs(currentUser) 
        {
           
           StudentFinancialInformationController controller = new StudentFinancialInformationController();
            
        }  
        }
        
    static testMethod void testNStudentFinancialInformation(){  
        
         
         User currentUser = [select id,contact.id, title, firstname, lastname, email FROM User WHERE Profile.Name  = 'Applicant Customer Portal User' and IsActive  = true limit 1];   
             try{
                Opportunity opp = new Opportunity();
                opp.Name = 'Test Opportunity';
                opp.Contact__c = currentUser.Contact.Id;
                opp.StageName ='Accepted';
                opp.CloseDate = Date.today();
                opp.Applicant_Confirmation__c='No';
                opp.Paid_Application_Fee__c=false; 
                opp.Primary_Program_Choice__c = 'Master of Business Administration';
                insert opp;
                } catch (exception e){}
         System.runAs(currentUser) 
         {    
                StudentFinancialInformationController controller = new StudentFinancialInformationController();
                controller.Applicant_Confirmation_c='No';
                controller.Paid_Application_Fee_c=false;
                StudentFinancialInformationController cont2= new StudentFinancialInformationController();
               
                
        }

     }     

}