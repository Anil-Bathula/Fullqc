/************************************
Modified by :Anil.B on 27/11/2013 ---JIRA NO::SFSUP-672
Added soft rejected and soft rejected confirmed
in condition at line 148,163
*************************************/

public class ApplicantaccountDetails {
    public Opportunity opp;
    public datetime Application_Fee_Date_Time_c{get;set;}
    public date Confirmation_Deadline_c{get;set;}
    public User user{get;set;}
    public string msg{get;set;}
    public boolean isappFee{get;set;}
    public date CDeppaiddate{get;set;}
    public boolean cfee{get;set;}
    public string msgPhone{get;set;}
    public string Primary_Campus_c{get;set;}
    public string Start_Term_c{get;set;}
    public string OppProgram_rName{get;set;}
    public string OppOwnerPhone{get;set;}
    public string Program_Department_Name{get;set;}
    public string Program_formatted_for_emails_letters{get;set;}
    public string depname{get;set;}
    
    Public List<Acceptance_Letter__c> ALC {get;set;}
    public string ALCID{get;set;}
    public Department__c depart;
    public string OppOwnerName{get;set;}
    public string OppOwnerEmail{get;set;}
    
    public ApplicantaccountDetails(){
        user = [SELECT contact.firstname,contact.lastname, contact.Last_Log_In__c FROM User
        WHERE id = :UserInfo.getUserId()];
        msgPhone = '';
        try{
             opp=[select Program__r.name
                        , Start_Term__c 
                        , Confirmation_Deadline__c
                        , Owner.name
                        , Owner.email 
                        , owner.phone
                        , StageName
                        , Application_Substage__c
                        , Final_Submission_Tab_Complete__c
                        , Application_Fee_Date_Time__c 
                        , Primary_Campus__c
                        ,Program_formatted_for_emails_letters__c
                        ,Program__r.Department__r.Name
                        ,Program_Department__c
                   from Opportunity where contact__c=:user.contact.id limit 1]; 
                depart=[SELECT name FROM Department__c  WHERE id = :opp.Program_Department__c limit 1];
                Program_Department_Name=depart.name;     
                Application_Fee_Date_Time_c = opp.Application_Fee_Date_Time__c;
                Start_Term_c=opp.Start_Term__c;
                Confirmation_Deadline_c = opp.Confirmation_Deadline__c;
                Primary_Campus_c=opp.Primary_Campus__c;
                Program_formatted_for_emails_letters = opp.Program_formatted_for_emails_letters__c;
                OppProgram_rName=opp.Program__r.name;
                OppOwnerPhone=opp.Owner.phone;
                OppOwnerName=opp.Owner.name;
                OppOwnerEmail=opp.Owner.email;
                depname=opp.Program__r.Department__r.Name;
                
                // Get Acceptance letter
                ALC = [Select ID from Acceptance_Letter__c where Application__c = : opp.ID];
                
                if(ALC.size()>0)
                {
                    Attachment att = [Select ID from attachment where parentID=:ALC[0].ID];
                    ALCID = att.ID;
                }
                
                
                // method for get Confirmation deposit paid date
                ConfirmationDepositpaiddate();
                
                welcomeMessage(opp.StageName, opp.Application_Substage__c);  
                
                if(Application_Fee_Date_Time_c!=null){
                    isappFee =true;
                }
                 
            } 
            catch (exception e){
               welcomeMessage('Qualified Lead','default');  
           }     
       
        
    }
    
    public void ConfirmationDepositpaiddate(){
        try{            
            CDeppaiddate = [select Deposit_Date_Paid__c from Opportunity_Finance__c where Opportunity__c=:opp.id].Deposit_Date_Paid__c;            
            if(CDeppaiddate!=null)
            cfee = true;
        }
        catch(exception e){
        // Need to create Finance record
        //apexpages.addmessages(e);
        
            cfee = false;
            CDeppaiddate = null;
        }
       
    }
    
    public void welcomeMessage(String stage, String Substage){
        String cdate='';
        if (Confirmation_Deadline_c!=null){
            cdate = Confirmation_Deadline_c.day()+'-'+Confirmation_Deadline_c.month()+'-'+Confirmation_Deadline_c.year();
        }
        boolean homeFlag=false;
        msg='';
        msg='Dear '+ user.contact.firstname +' '+ user.contact.lastname +',<br /><br />'; 
       if(stage=='Qualified Lead' && (Substage==Null || Substage=='Emailed' || Substage=='Interested' || Substage=='Interested Next Year' || Substage=='Lack of Funds' ||  Substage=='Not Interested' || Substage=='Qualified for other program' || Substage=='Strongly Interested' || Substage=='Unqualified' || Substage=='Unreachable Call 1' || Substage=='Unreachable Call 2' || Substage=='Unreachable Call 3' || Substage=='Unreached')){

            msg +='Thank you for registering with Hult International Business School.  Please fill out the basic information required in the first and second tabs before proceeding with the remainder of your application.  We encourage you to complete each tab as soon as possible to secure your program and campus of choice.  Our Admissions Committee will review your application upon completion.<br/><br/><b>3 simple steps to complete your application</b><br/>1.    Complete the first '+((depName=='BBA'||depName=='BIBA')?'5':'6')+' tabs of the application form <br/>2.    Pay the application fee and submit your online application <br/>3.    Upload your additional documents such as your Personal Statement, transcripts and references with your application or at a later point in time   <br /><br />Should you have any questions as you fill out your application, please feel free to contact us <a target=\'blank\' href=\'http://www.hult.edu/contact-us/\'>www.hult.edu/contact-us</a><br /><br />The Hult Admissions Committee <br/><a target=\'blank\' href=\'http://www.hult.edu/contact-us/\'>http://www.hult.edu/contact-us</a>'; 
       }
       else if(stage=='In Progress' && (Substage==null || Substage=='Completed Application' || Substage=='Emailed' || Substage=='Interested' || Substage=='Interested Next Year' ||  Substage=='Lack of Funds' || Substage=='Not Completing App' || Substage=='Not Interested' || Substage=='Pending Test(s)' || Substage=='Qualified for other program' || Substage=='Strongly Interested' || Substage=='Underage' || Substage=='Unqualified' || Substage=='Unreachable Call 1' || Substage=='Unreachable Call 2' || Substage=='Unreachable Call 3' || Substage=='Working to Complete App' || Substage=='Unreached')){

           msg +='Thank you for beginning your application for admission to Hult International Business School.  To secure your program and campus of choice, we encourage you to complete the remainder of your application as soon as possible.  Our Admissions Committee will review your application upon completion.<br /><br /><b>3 simple steps to complete your application</b><br/>1.    Complete the first '+((depName=='BBA'||depName=='BIBA')?'5':'6')+' tabs of the application form <br/>2.    Pay the application fee and submit your online application <br/>3.    Upload your additional documents such as your Personal Statement, transcripts and references with your application or at a later point in time <br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }  
       else if(stage=='Partial Application' && (Substage==null || Substage=='Completed Application' || Substage=='Not Completing App' || Substage=='Pending Test(s)' || Substage=='Working to Complete App')){

           msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.<br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Accepted' && (Substage==null || Substage=='Interviewed' || Substage=='Pending Interview')){

           msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.         <br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Accepted' && Substage=='Notified'){
          msg +='Congratulations! You’ve been '+stage+' to Hult International Business School.<br /><br />Your Hult Acceptance Pack is on its way to you in the mail.  The Acceptance Pack contains useful information about your program, electives, campus city, and student life at Hult.  Please also explore myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, our student portal featuring exclusive videos and links to help you prepare for your time at Hult. You should have received an email with your myHult login credentials.  If you have not received your myHult login, please let me know.<BR/><BR/>Your seat for the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' for '+Start_Term_c+' will be reserved until no later than '+string.valueOf(Confirmation_Deadline_c)+'.  Seats are limited, so I advise you to secure your place as soon as possible by paying your confirmation deposit.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full acceptance into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>Congratulations, again! <BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       }   
       else if(stage=='Conditionally Accepted' && (Substage==Null || Substage=='Interviewed' || Substage=='Pending Interview')){
          msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.         <br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Conditionally Accepted' && Substage=='Notified'){
          msg +='Congratulations! You’ve been '+stage+' to Hult International Business School.<br /><br />Your Hult Acceptance Pack is on its way to you in the mail.  The Acceptance Pack contains useful information about your program, electives, campus city, and student life at Hult.  Please also explore myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, our student portal featuring exclusive videos and links to help you prepare for your time at Hult. You should have received an email with your myHult login credentials.  If you have not received your myHult login, please let me know.<BR/><BR/>Your seat for the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' for '+Start_Term_c+' will be reserved until no later than '+string.valueOf(Confirmation_Deadline_c)+'.  Seats are limited, so I advise you to secure your place as soon as possible by paying your confirmation deposit.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full acceptance into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>Congratulations, again! <BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       } 
       else if(stage=='Admissions Endorsed' && (Substage==Null || Substage=='Interviewed' || Substage=='Pending Interview')){
          msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.         <br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Admissions Endorsed' && Substage=='Notified'){
          msg +='Congratulations! You’ve been '+stage+' to Hult International Business School.<br /><br />Your Hult Acceptance Pack is on its way to you in the mail.  The Acceptance Pack contains useful information about your program, electives, campus city, and student life at Hult.  Please also explore myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, our student portal featuring exclusive videos and links to help you prepare for your time at Hult. You should have received an email with your myHult login credentials.  If you have not received your myHult login, please let me know.<BR/><BR/>Your seat for the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' for '+Start_Term_c+' will be reserved until no later than '+string.valueOf(Confirmation_Deadline_c)+'.  Seats are limited, so I advise you to secure your place as soon as possible by paying your confirmation deposit.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full acceptance into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>Congratulations, again! <BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       } 
       else if(stage=='Rejected' && (Substage==Null || Substage=='Age' || Substage=='Fraudulent document' || Substage=='GMAT low' || Substage=='GPA low' || Substage=='Invalid document' || Substage=='Missing Bachelor Degree' || Substage=='TOEFL low' || Substage=='Underage' || Substage=='Unsuitable' || Substage=='Work Experience low')){
          msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.         <br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Soft Rejected' && (Substage==Null || Substage=='Age' || Substage=='Fraudulent document' || Substage=='GMAT low' || Substage=='GPA low' || Substage=='Invalid document' || Substage=='Missing Bachelor Degree' || Substage=='TOEFL low' || Substage=='Underage' || Substage=='Unsuitable' || Substage=='Work Experience low')){
          msg +='Congratulations on completing the first step toward enrolling in Hult International Business School.  We have received your application fee and will be in touch regarding any additional documents necessary to complete your application.<br /><br />Upon completion, we will present your application to the Admissions Committee.  You will receive your admissions decision soon after the Admissions Committee has reviewed your application.         <br /><br />Please contact me with any questions that you may have as you work to gather the required documents to complete your application.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Withdrawn' && (Substage==Null || Substage=='Competitor-Admission Requirement' || Substage=='Competitor-Fin Aid Offer' || Substage=='Competitor-Program/Brand' || Substage=='Employment/Career' || Substage=='Interested Next Year' || Substage=='Lack of Funds' || Substage=='Lost rebooking' || Substage=='Low Exam/Test Results' || Substage=='Other' || Substage=='Personal Reasons' || Substage=='Underage')){
          msg +='Your application is currently in an inactive status.  Please contact me immediately so we can discuss reactivating your application and moving forward with the remaining steps.<br /><br />' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Confirmed' && (Substage==Null || Substage=='Notified')){
          msg +='Congratulations, you are now '+Stage+' to attend Hult International Business School.<br /><br />We have received your deposit and a seat in the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' beginning in '+Start_Term_c+' has been reserved for you. Our Student Services team will be in touch with you soon to help you prepare for your time at Hult.<br /><br />You may now access the Academic Gateway section of myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, which features important content including:<BR/><ul type="round"><LI>Program preparation exercises</LI><LI>Communications tools</LI><LI>Debates on global topics</LI></ul><BR/>Once your file has been reviewed, you will be able to access your financial statement.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full confirmation into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       }
       else if(stage=='Conditionally Confirmed' && (Substage==Null || Substage=='Notified')){
           msg +='Congratulations, you are now '+Stage+' to attend Hult International Business School.<br /><br />We have received your deposit and a seat in the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' beginning in '+Start_Term_c+' has been reserved for you. Our Student Services team will be in touch with you soon to help you prepare for your time at Hult.<br /><br />You may now access the Academic Gateway section of myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, which features important content including:<BR/><ul type="round"><LI>Program preparation exercises</LI><LI>Communications tools</LI><LI>Debates on global topics</LI></ul><BR/>Once your file has been reviewed, you will be able to access your financial statement.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full confirmation into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       }
       else if(stage=='Admissions Endorsed Confirmed' && (Substage==Null || Substage=='Notified')){
           msg +='Congratulations, you are now '+Stage+' to attend Hult International Business School.<br /><br />We have received your deposit and a seat in the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' beginning in '+Start_Term_c+' has been reserved for you. Our Student Services team will be in touch with you soon to help you prepare for your time at Hult.<br /><br />You may now access the Academic Gateway section of myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, which features important content including:<BR/><ul type="round"><LI>Program preparation exercises</LI><LI>Communications tools</LI><LI>Debates on global topics</LI></ul><BR/>Once your file has been reviewed, you will be able to access your financial statement.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full confirmation into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       }
       else if(stage=='Soft Rejected Confirmed' && (Substage==Null || Substage=='Notified')){
           msg +='Congratulations, you are now '+Stage+' to attend Hult International Business School.<br /><br />We have received your deposit and a seat in the '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' beginning in '+Start_Term_c+' has been reserved for you. Our Student Services team will be in touch with you soon to help you prepare for your time at Hult.<br /><br />You may now access the Academic Gateway section of myHult <a target=\'blank\' href=\'http://my.hult.edu/\'>my.hult.edu</a>, which features important content including:<BR/><ul type="round"><LI>Program preparation exercises</LI><LI>Communications tools</LI><LI>Debates on global topics</LI></ul><BR/>Once your file has been reviewed, you will be able to access your financial statement.<BR/><BR/>Please refer to your Admissions letter for information on any pending documents or test information needed for you to receive full confirmation into the program.<BR/><BR/><a Target="_blank" href="/portal/servlet/servlet.FileDownload?file='+ ALCID +'"> Admissions letter</a><BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>';
       }
       else if(stage=='Waitlisted Confirmed' && (Substage==Null || Substage=='Notified')){
          msg +='You are currently on the wait list for Hult’s '+ Program_formatted_for_emails_letters +' program in '+Primary_Campus_c+' for '+Start_Term_c+'. We will be in touch soon regarding your status.<BR/><BR/>' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Cancellation' && (Substage==Null || Substage=='Competitor-Admission Requirement' || Substage=='Competitor-Fin Aid Offer' || Substage=='Competitor-Program/Brand' || Substage=='Employment/Career' || Substage=='Employment/Career' || Substage=='Lack of Funds' || Substage=='Low Exam/Test Results' || Substage=='Other' || Substage=='Personal Reasons' || Substage=='Rebooking Loss' || Substage=='Visa Rejection')){
          msg +='We regret that you will not be able to join the '+ Program_formatted_for_emails_letters +' program at Hult this year.<br /><br />Please do not hesitate to contact me in the coming months should your situation change. I look forward to discussing your options for joining Hult International Business School in the future.<br /><br />' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Deferral' && (Substage==Null || Substage=='Competitor-Admission Requirement' || Substage=='Competitor-Fin Aid Offer' || Substage=='Competitor-Program/Brand' || Substage=='Employment/Career' || Substage=='Lack of Funds' || Substage=='Low Exam/Test Results' || Substage=='Other' || Substage=='Personal Reasons' || Substage=='Rebooking Loss' || Substage=='Underage' || Substage=='Visa Rejection')){
          msg +='We regret that you will not be able to join the '+ Program_formatted_for_emails_letters +' program at Hult this year.<br /><br />Please do not hesitate to contact me in the coming months should your situation change.  I look forward to discussing your options for joining Hult International Business School in the future.<br /><br />' + OppOwnerName + '<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }
       else if(stage=='Enrolled' && (Substage==Null || Substage=='')){
         msg +='Welcome to campus and best of luck with your studies!  If you have any questions or concerns please contact either Student Services or me.<br /><br />'+OppOwnerName+'<br /><a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a>'; 
       }    
       else{
            msg+='Thank you for registering with Hult International Business School. To start your application, please continue to fill out the information required in the tab called "Program and Location" and start proceeding with all applications steps. We encourage you to complete each one of the tabs as soon as possible and especially because Hult is facing an unprecedented level of interest. Our Admission Committee is reviewing candidate’s files as soon as they receive them.';    
            msg += '<br />';             
            msg+='<br/>Kind Regards,<br/><br/>Hult Admissions Team';  
            homeFlag=true;               
        }
                                                    
       /* if(stage=='In Progress'){
            msg +='Congratulations on starting your application. We encourage you to complete each one of the tabs as soon as possibleespecially because Hult is facing an un-precedent level of interest. Our Admission Committee is reviewing candidate’s files as soon as they receive them.'; 
            msg += '<br /><br />Kind Regards,'; 
            msg += '<br /><br />Hult Admissions Team';
            msg +='<br/><a target=\'blank\' href=\'http://www.hult.edu/Contact-Us/Admissions-Offices/\'>http://www.hult.edu/Contact-Us/Admissions-Offices/</a><br /><br />';
            homeFlag=true;   
        }else if(stage=='Partial Application' && (Substage=='Completed Application' || Substage =='Working to Complete App' || Substage=='Pending Test(s)' || Substage=='Not Completing App')){            
            msg += 'Congratulations on taking the first step towards becoming part of the world\'s most international business school. Our Admissions support team will review your application and let you know if there is any additional information we require before presenting your application to the Admissions Committee.  <br /><br />Please feel free to contact me if you have any additional question.'; 
            msg += '<br /><br />Best,<br/>';
        }else if(stage=='Waiting for Review' || stage=='Withdrawn' || stage=='Rejected' ){            
            msg += 'Congratulations on taking the first step towards becoming part of the world\'s most international business school. Our Admissions support team will review your application and let you know if there is any additional information we require before presenting your application to the Admissions Committee.  <br /><br />Please feel free to contact me if you have any additional question.'; 
            msg += '<br /><br />Best,<br/>';
        }else if(stage=='Accepted' && Substage=='Notified'){            
            msg += 'Congratulations!  You’ve been accepted to become part of the world’s most international business school!<br/><br/>I am pleased to inform you that Hult’s Acceptance Pack is on the way to you and will be with you shortly. Your Acceptance <br/> Pack contains useful information about your program, electives, campus city, and time at Hult.Please do not forget to access <br/> milt (my.hult.edu), our new student portal featuring complementary information, exclusive videos and links to help you in <br/> your preparation before joining Hult. You should have received an email with all access details for myHult. If this is not the <br/> case, kindly contact your recruiter.<br/><br/> Please note that you can also download a pdf version of your Acceptance letter in the Admission letters tab.<br/><br/> Your seat for your program beginning in '+Primary_Campus_c+' will be reserved until no later than '+cdate+'. <br/> Seats are filling up quickly, so to avoid disappointment you are advised to secure your place as soon as possible by paying <br/> your confirmation fee.<br/><br/> I am convinced that you will be a great asset to Hult and I look forward to welcoming you in our program.<br/><br/> Please do not hesitate to contact me for further questions.<br/><br/>Congratulations again!<br/><br/>';
            msg += 'Best,<br/>';
        }else if(stage=='Admissions Endorsed' && Substage=='Notified'){
            msg += 'Congratulations!  You’ve been endorsed to become part of the world’s most international business school!<BR/><BR/>I am happy to inform you that Hult’s Admissions Pack is on the way to you and will be with you shortly. Your Admissions Pack contains useful information about your program, electives, campus city, and time at Hult.Please do not forget to access myHult (my.hult.edu), our new student portal featuring complementary information, exclusive videos and links to help you in your preparation before joining Hult. You should have received an email with all access details for myHult. If this is not the case, kindly contact your recruiter.<BR/><BR/>Please note that you can also download a pdf version of your Admissions letter in the Admission letters tab.<BR/><BR/>Your seat for your program beginning in '+Primary_Campus_c+' will be reserved until no later than '+cdate+'.  Seats are filling up quickly, so to avoid disappointment you are advised to secure your place as soon as possible by paying your confirmation fee.<BR/><BR/>please also remember to hand in your pending documents listed in your admissions letter to receive full acceptance onto the program and to upload your test confirmation booking (test date and location) for your missing tests (ie. GMAT/TOEFL).  You can enter your test booking date in the Exam Information tab and upload your test booking confirmation under the Attach Documents tab.<BR/><BR/>I am convinced that you will be a great asset to Hult and I look forward to welcoming you in our program.<BR/><BR/>Please do not hesitate to contact me for further questions.<BR/><BR/>Congratulations again!<BR/><BR/>Best,<BR/>';   
        }else if(stage=='Conditionally Accepted' && Substage=='Notified'){
            msg += 'Congratulations!  You’ve been conditionally accepted to become part of the world’s most international business school!<BR/><BR/>I am happy to inform you that Hult’s Acceptance Pack is on the way to you and will be with you shortly. Your Acceptance Pack contains useful information about your program, electives, campus city, and time at Hult.Please do not forget to access myHult (my.hult.edu), our new student portal featuring complementary information, exclusive videos and links to help you in your preparation before joining Hult. You should have received an email with all access details for myHult. If this is not the case, kindly contact your recruiter.<BR/><BR/>Please note that you can also download a pdf version of your Acceptance letter in the Admission letters tab.<BR/><BR/>Your seat for your program beginning in '+Primary_Campus_c+' will be reserved until no later than '+cdate+'.  Seats are filling up quickly, so to avoid disappointment you are advised to secure your place as soon as possible by paying your confirmation fee.<BR/><BR/>Please also remember to hand in your missing original or notarized copies of the documents listed on your acceptance letter within the next 4 weeks to receive full acceptance onto the program.<BR/><BR/>I am convinced that you will be a great asset to Hult and I look forward to welcoming you in our program.<BR/><BR/>Please do not hesitate to contact me for further questions.<BR/><BR/>Congratulations again!<BR/><BR/>Best,<br/>';        
        }else if((stage=='Conditionally Accepted' || stage=='Admissions Endorsed' || stage=='Accepted') && (Substage=='Pending Interview' || Substage=='Interviewed' || Substage==null )){            
            msg += 'Congratulations on taking the first step towards becoming part of the world’s most international business school. Our Admissions support team is reviewing your application and will let you know if there is any additional information we require.<br/><br/>Please feel free to contact me if you have any additional question.<br/><br/>Best,<br/>';
         }else if(stage=='Admissions Endorsed Confirmed'){
            msg += 'Congratulations, you are now admissions endorsed confirmed to Hult.<BR/><BR/>I am glad to confirm that your seat onto the '+Program_Department_Name+' program is reserved for you and that we have received your deposit payment.<BR/><BR/>Our Student Service team will be in touch with you shortly to help you prepare for your time with Hult.<BR/><BR/>You have now access to the Academic Gateway section of myHult (my.hult.edu), featuring new content such as<BR/><ul type="round"><LI>Program preparation exercises</LI><LI>Professional and Communication skill tools</LI><LI>Global topic debates on video</LI></ul><BR/>If you want to review your financial information you can go to the Finance Statement tab which provides you with all relevant information on your invoice, due dates for your tuition fees, etc.<BR/><BR/>Please also remember to hand in your pending documents listed in your admissions letter to receive full acceptance onto the program and to upload your test confirmation booking (test date and location) for your missing tests (ie. GMAT/TOEFL). You can enter your test booking date in the Exam Information tab and upload your test booking confirmation under the Attach Documents tab. Keep in mind that your minimum test score/s must be presented to Hult before the program start in order to join this year.<BR/><BR/>I am convinced that you will be a great asset to Hult.<BR/><BR/>I look forward to welcoming you to the program and to discussing the next steps with you.<BR/><BR/>Best,<BR/>';        
        }else if(stage=='Conditionally Confirmed'){
            msg += 'Congratulations, you are now conditionally confirmed to Hult.<BR/><BR/>I am glad to confirm that your seat onto the '+Program_Department_Name+' program is reserved for you and that we have received your deposit payment.<BR/><BR/>Our Student Service team will be in touch with you shortly to help you prepare for your time with Hult.<BR/><BR/>You have now access to the Academic Gateway section of myHult (my.hult.edu), featuring new content such as <ul type="round"><li>Program preparation exercises</li><li>Professional and Communication skill tools</li><li>Global topic debates on video</li></ul><br/>If you want to review your financial information you can go to the Finance Statement tab which provides you with all relevant information on your invoice, due dates for your tuition fees, etc.<br/><br/>Please also remember to hand in your missing original or notarized copies of the documents listed on your acceptance letter within the next 4 weeks to receive full acceptance onto the program.<br/><br/>I am convinced that you will be a great asset to Hult.<br/><br/>I look forward to welcoming you to the program and to discussing the next steps with you.<br/><br/>Best,<br/>';        
        }else if(stage=='Confirmed'){
            msg += 'Congratulations, you are confirmed to Hult.<br/><br/>I am glad to confirm that your seat onto the [Program] program is reserved for you and that we have received your deposit payment.<br/><br/>Our Student Service team will be in touch with you shortly to help you prepare for your time with Hult.<br/><br/>You have now access to the Academic Gateway section of myHult (my.hult.edu), featuring new content such as<br/><ul type="round"><li>Program preparation exercises</li><li>Professional and Communication skill tools</li><li>Global topic debates on video</li></ul><br/>If you want to review your financial information you can go to the Finance Statement tab which provides you with all relevant information on your invoice, due dates for your tuition fees, etc.<br/><br/>I am convinced that you will be a great asset to Hult.<br/><br/>I look forward to welcoming you to the program and to discussing the next steps with you.<br/><br/>Best,<br/>';        
        }else if(stage=='Enrolled'){
            msg += 'Congratulations on your enrolment to the world’s most international business school! I hope you enjoy your time at Hult. <br/> Please feel free to contact me if you have any questions or need assistance.<br/><br/>Best,<br/>' ;
        }else if(stage=='Deferral' || stage=='Cancellation'){
            msg +='I am sorry to hear that you will not be able to join the '+Program_Department_Name+' program at Hult this year.<br/><br/>Please do not hesitate to contact me in the coming months if your situation changes. I am happy to discuss your options of joining the program in the coming year.<br/><br/>Best,<br/>'; 
        }else{
            msg+='Thank you for registering with Hult International Business School. To start your application, please continue to fill out the information required in the tab called "Program and Location" and start proceeding with all applications steps. We encourage you to complete each one of the tabs as soon as possible and especially because Hult is facing an unprecedented level of interest. Our Admission Committee is reviewing candidate’s files as soon as they receive them.';    
            msg += '<br />';             
            msg+='<br/>Kind Regards,<br/><br/>Hult Admissions Team';  
            homeFlag=true;               
        }
        if(homeFlag==false){
            msg += OppOwnerName+'<br />';
            msg += '<a href="mailto:'+OppOwnerEmail+'">'+OppOwnerEmail+'</a> <br />';             
            msg +='<a target=\'blank\' href=\'http://www.hult.edu/Contact-Us/Admissions-Offices/\'>http://www.hult.edu/Contact-Us/Admissions-Offices/</a><br /><br />';
        }
       */
    }
    
    public boolean getisCDeadline(){
        if(Confirmation_Deadline_c!=null){
                if((opp.StageName=='Conditionally Accepted' || opp.StageName=='Admissions Endorsed' || opp.StageName=='Accepted') && (opp.Application_Substage__c=='Notified')){            
                    return true;
                }
                else{
                    return false;
                }
        }
        else{
            return false;
        }
    }

}