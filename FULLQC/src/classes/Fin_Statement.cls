Public without sharing  Class Fin_Statement
{

    public User user{get;set;} 
    public Opportunity_finance__c u{get;set;}
    public Contact con{get;set;}
    public Opportunity opp{get;set;}
    public Requirement__c req{get;set;}
    public String firstname{get;set;}
    public string lastname{get;set;}
    Public string nomap{get;set;} 
    public double Total_Fees_Due_FS_c{get;set;}
    public double Go_Ed_Loan_Amount_FS_c{get;set;}
    public double Scholarship_Amount_FS_c{get;set;}  
    public double Hult_Financial_Aid_Amount_c{get;set;}
    public double Housing_Fee_FS_c{get;set;}
    Public double Payment_Amount_1st_c{get;set;}
    Public double Payment_Amount_2nd_c{get;set;}
    Public Date Payment_Due_Date_1st_c{get;set;}
    Public Date Payment_Due_Date_2nd_c{get;set;}
    Public String Payment_Plan_c{get;set;}
    Public boolean I_agree_to_Hult_Terms_and_Conditions_c{get;set;}
    public String Program_c{get;set;}
    public String stage{get;set;}
    public string id{get;set;}
    public double Total_Tuition_Amount_c{get;set;}
    public Double Scholarship_Amount_c{get;set;}
    public Double Hult_India_Financial_Aid_c{get;set;}//Added by anil 2/4/13
    public double Go_Ed_Loan_Amount_c{get;set;}
    public string Dubai_Housing_Bursary_Amount_c{get;set;}
    public Double Early_Bird_Scholarship_Amount_c{get;set;}
    public string Bertil_Hult_Scholarship_Amount_c{get;set;}
    public string Relocation_Scholarship_Amount_c{get;set;}
    public string Go_Ed_MEFA_Replacement_Loan_Amount_c{get;set;}
    public Double Campus_Financial_Aid_I_FS_c{get;set;} /*modified by Premanath Reddy 5/23/2013:: Reason: Added the two fields 'Campus Financial Aid I FS' and 'Campus Financial Aid II FS' under Financial Aid Section*/
    public Double Campus_Financial_Aid_II_FS_c{get;set;}
    public double Total_Financial_Aid_Amount_c{get;set;}
    public double Course_Deposit_Amount_c{get;set;}
    public Opportunity_Finance__c oppfin{get;set;}
    public String Primary_Program_Choice_c{get;set;}    
    public double Net_Amount_Due_c{get;set;}
    public double Current_Balance_Due_Portal_c{get;set;}
    public date Deposit_Date_Paid_c{get;set;}
    public double Deposit_Paid_c{get;set;}
    public string hultID{get;set;}
    public string CurrencyIsoCode{get;set;}
    public double Student_Resources_Activities_c{get;set;}
    public double Toolbox_Case_Study_Pack_c{get;set;}
    public double Erika_Insurance_Price_c{get;set;}
    public boolean Unlock_Student_Financial_Information_c{get;set;}
    public string App_ID_c{get;set;}
    public double Insurance_Fee_c{get;set;}
    public double Visa_Fee_c{get;set;}
    public double Specialization_Fee_FS_new_c{get;set;}
    public double IEBA_IEMS_Program_Fee_FS_c{get;set;}
    public double Partner_Program_Insurance_Fee_FS_c{get;set;}
    public double Installment_Plan_Fee_FS_c{get;set;}    
    public double Deposit_Amount_Due_FS_c{get;set;}  
    public double Dean_Scholarship_Amount_FS_c{get;set;}
    public double Bertil_Hult_Scholarship_Amount_FS_c{get;set;}
    public double Relocation_Scholarship_Amount_FS_c{get;set;}
    public double Total_Financial_Aid_FS_c{get;set;}
    Public double Total_Scholarships_c{get;set;}
    public double Total_Balance_Due_FS_c{get;set;}
    public double Early_Bird_Scholarship_Amount_FS_c{get;set;}
    public string Insurance_Company_FS_c{get;set;}
    public string Insurance_Type_FS_c{get;set;}
    public double Adjustment_Amount_c{get;set;}
    public double Private_Financing_c{get;set;}
    public double US_Federal_Financing_Stafford_c{get;set;}
    public double US_Federal_Financing_Grad_Plus_c{get;set;}
    public double US_Federal_Financing_Parent_Plus_c{get;set;}
    public double US_Federal_Financing_Pell_c{get;set;}
    public string Financial_Aid_Category_FS_c{get;set;}
    public date DatePrinted = date.today();
    public date getDatePrinted(){
        return DatePrinted;
    }
    public string Aetna_Insurance_c{get;set;}
    public double Aetna_Insurance_Price_c{get;set;}
    public string Installment_Plan_c{get;set;}   
    public string Go_Ed_Loan_Note_FS_c{get;set;}
    public string Private_Financing_Note_c{get;set;}
    public string US_Federal_Financing_Note_Stafford_c{get;set;}
    public string US_Federal_Financing_Note_Grad_Plus_c{get;set;}
    public string US_Federal_Financing_Note_Parent_Plus_c{get;set;}
    public string US_Federal_Financing_Note_Pell_c{get;set;}
    public string Status_Grad_Plus_c{get;set;}
    public string Status_Parent_Plus_c{get;set;}
    public string Status_Pell_c{get;set;}
    public string Status_Stafford_c{get;set;}
    public string GoEd_Financing_Status_c{get;set;}
    public string Private_Financing_Status_c{get;set;}
    public string ccode{get;set;}
    public string Housing_Accommodation_c{get;set;}
    public boolean isShow{get;set;}
    public double paytostudyAmount;
    public double paytostudyAmount1;
    public double paytostudyAmount2;
    public double Payment_Amount_3rd_c{get;set;}
    public double Payment_Amount_4th_c{get;set;}
    public double Payment_Amount_5th_c{get;set;}
    public double Payment_Amount_6th_c{get;set;}
    public double Payment_Amount_7th_c{get;set;}
    public double Payment_Amount_8th_c{get;set;}
    public date Payment_Due_Date_3rd_c{get;set;}
    public date Payment_Due_Date_4th_c{get;set;}
    public date Payment_Due_Date_5th_c{get;set;}
    public date Payment_Due_Date_6th_c{get;set;}
    public date Payment_Due_Date_7th_c{get;set;}
    public date Payment_Due_Date_8th_c{get;set;}    
    public boolean Lock_Installment_Plan_c{get;set;}
    public string type{get;set;}
    
   
    public PageReference threepage() {
     
        type=System.currentPagereference().getParameters().get('type');
        PageReference pageRef;
        if(type!='draft'){
           pageRef = new PageReference('/apex/Fin_Statement_3page?contactid='+System.currentPagereference().getParameters().get('contactid'));
        } 
        else{
            pageRef = new PageReference('/apex/Fin_Statement_3page?contactid='+System.currentPagereference().getParameters().get('contactid')+'&type='+type);
        }
        pageRef.setredirect(true);
        system.debug(')))->>>'+pageRef);
        return pageref;
    }
   
          
    
    
    public Fin_Statement()
    {}
       /* public Fin_Statement()
        {
            try{
                Lock_Installment_Plan_c=false;
                nomap='No Map';
                // This condition use for create PDF from admin
                if(System.currentPagereference().getParameters().get('contactid')==null){
                  //  user = [SELECT contact.Mailing_Country__r.Country_Code__c,contact.Mailing_Country__r.Calling_Code__c,
                   //  contact.Mailing_Country__r.Country_Code_for_PaytoStudy__c, contact.Mobile_Phone_Main_Number__c, 
                   //  contact.Home_Phone_Main_Number__c, contact.email, contact.Birthdate, contact.Salutation,
                    // contact.MailingStreet, contact.mailingpostalcode,contact.Mailingstate, contact.Mailingcity,
                  //   contact.Mailing_Country__r.name, contact.id,contact.firstname,contact.lastname
                    //  FROM User WHERE id = :UserInfo.getUserId()];                  
                  
                }
                else{
                   // user = [SELECT contact.Mailing_Country__r.Country_Code__c,contact.Mailing_Country__r.Calling_Code__c
                   //            , contact.Mailing_Country__r.Country_Code_for_PaytoStudy__c
                   //            , contact.Mobile_Phone_Main_Number__c, contact.Home_Phone_Main_Number__c
                   //            , contact.email, contact.Birthdate, contact.Salutation, contact.MailingStreet
                   //            , contact.mailingpostalcode,contact.Mailingstate, contact.Mailingcity
                   //            , contact.Mailing_Country__r.name, contact.id,contact.firstname
                   //            ,contact.lastname FROM User WHERE contact.id = :System.currentPagereference().getParameters().get('contactid') limit 1];  
                 Con=[select id,name,lastname,firstname
                     ,Mailing_Country__r.Country_Code__c
                     ,Mailing_Country__r.Calling_Code__c
                     ,Mailing_Country__r.Country_Code_for_PaytoStudy__c
                     ,Mobile_Phone_Main_Number__c
                     ,Home_Phone_Main_Number__c
                     ,email,Birthdate,Salutation,MailingStreet
                     ,mailingpostalcode,Mailingstate
                     ,Mailingcity,Mailing_Country__r.name
                      from contact where id=:System.currentPagereference().getParameters().get('contactid') limit 1];
                }
                opp=[select Primary_Program_Choice__c, PaytoStudy_Registration__c, Primary_Campus__c, program__r.CurrencyIsoCode,            
                App_ID__c, id, name,Program__r.name,StageName from Opportunity where contact__c=:con.id limit 1];
                Program_c=opp.Program__r.name;
                stage=opp.StageName;
                App_ID_c = opp.App_ID__c;  
                Primary_Program_Choice_c = opp.Primary_Program_Choice__c;
                if (opp.Primary_Campus__c=='London'){
                        ccode= 'GBP';
                    }
                else{
                       ccode= 'USD';
                }
                              
                try{
                oppfin=[select 
                Lock_Installment_Plan__c,
                Payment_Amount_3rd__c,
                Payment_Amount_4th__c,
                Payment_Amount_5th__c,
                Payment_Amount_6th__c,
                Payment_Amount_7th__c,
                Payment_Amount_8th__c,
                Payment_Due_Date_3rd__c,
                Payment_Due_Date_4th__c,
                Payment_Due_Date_5th__c,
                Payment_Due_Date_6th__c,
                Payment_Due_Date_7th__c,
                Payment_Due_Date_8th__c, 
                Housing_Accommodation__c,
                Tuition_Fees_Balance_Due__c,             
                Go_Ed_Loan_Note_FS__c,
                Private_Financing_Note__c,
                US_Federal_Financing_Note_Stafford__c,
                US_Federal_Financing_Note_Grad_Plus__c,
                US_Federal_Financing_Note_Parent_Plus__c,
                US_Federal_Financing_Note_Pell__c,
                Status_Grad_Plus__c,
                Status_Parent_Plus__c,
                Status_Pell__c,
                Status_Stafford__c,
                GoEd_Financing_Status__c,
                Private_Financing_Status__c,
                Adjustment_Amount__c, 
                Private_Financing__c,
                US_Federal_Financing_Stafford__c,
                US_Federal_Financing_Grad_Plus__c,
                US_Federal_Financing_Parent_Plus__c,
                US_Federal_Financing_Pell__c,
                Total_Fees_Due_FS__c,
                Go_Ed_Loan_Amount_FS__c,
                Scholarship_Amount_FS__c,
                Hult_India_Financial_Aid__c,
                Hult_Financial_Aid_Amount__c,
                Housing_Fee_FS__c,
                Early_Bird_Scholarship_Amount_FS__c,
                Total_Balance_Due_FS__c,
                Total_Financial_Aid_FS__c,
                Relocation_Scholarship_Amount_FS__c,
                Bertil_Hult_Scholarship_Amount_FS__c,
                Campus_Financial_Aid_I_FS__c,
                Campus_Financial_Aid_II_FS__c,
                Dean_Scholarship_Amount_FS__c,
                Deposit_Amount_Due_FS__c,
                Insurance_Type_FS__c,           
                Insurance_Company_FS__c,
                Installment_Plan_Fee_FS__c,
                Partner_Program_Insurance_Fee_FS__c,
                IEBA_IEMS_Program_Fee_FS__c,
                Specialization_Fee_FS_new__c,
                Visa_Fee__c,  
                Insurance_Fee__c,
                Installment_Plan__c,  
                Aetna_Insurance__c,       
                Aetna_Insurance_Price__c,
                Unlock_Student_Financial_Information__c,
                Toolbox_Case_Study_Pack__c,
                Erika_Insurance_Price__c,
                Student_Resources_Activities__c,
                CurrencyIsoCode,            
                Deposit_Paid__c,
                Deposit_Date_Paid__c, 
                Course_Deposit_Amount__c,
                Total_Tuition_Amount__c,
                Net_Amount_Due__c,
                Current_Balance_Due_Portal__c,
                Scholarship_Amount__c,Go_Ed_Loan_Amount__c,
                Dubai_Housing_Bursary_Amount__c,Early_Bird_Scholarship_Amount__c,
                Bertil_Hult_Scholarship_Amount__c,
                Relocation_Scholarship_Amount__c,
                Go_Ed_MEFA_Replacement_Loan_Amount__c,Total_Financial_Aid_Amount__c,Total_Scholarships__c,
                Financial_Aid_Category__c, id, Payment_Amount_1st__c,
                Payment_Amount_2nd__c,Payment_Due_Date_1st__c,Payment_Due_Date_2nd__c,Payment_Plan__c,
                I_agree_to_Hult_Terms_and_Conditions__c,Fin_Aid_Hotel_and_Flight__c, OP_Program__c,
                name from Opportunity_Finance__c where Opportunity__c=:opp.id];
                
                system.debug('oppfin = ' + oppfin);
                
                system.debug('opp.id = ' + opp.id);
                Housing_Accommodation_c = oppfin.Housing_Accommodation__c;
                Go_Ed_Loan_Note_FS_c = oppfin.Go_Ed_Loan_Note_FS__c;
                Private_Financing_Note_c= oppfin.Private_Financing_Note__c;
                US_Federal_Financing_Note_Stafford_c= oppfin.US_Federal_Financing_Note_Stafford__c;
                US_Federal_Financing_Note_Grad_Plus_c= oppfin.US_Federal_Financing_Note_Grad_Plus__c;
                US_Federal_Financing_Note_Parent_Plus_c= oppfin.US_Federal_Financing_Note_Parent_Plus__c;
                US_Federal_Financing_Note_Pell_c= oppfin.US_Federal_Financing_Note_Pell__c;
                Status_Grad_Plus_c= oppfin.Status_Grad_Plus__c;
                Status_Parent_Plus_c= oppfin.Status_Parent_Plus__c;
                Status_Pell_c= oppfin.Status_Pell__c;
                Status_Stafford_c= oppfin.Status_Stafford__c;
                GoEd_Financing_Status_c= oppfin.GoEd_Financing_Status__c;
                Private_Financing_Status_c= oppfin.Private_Financing_Status__c;
                Adjustment_Amount_c = oppfin.Adjustment_Amount__c;
                Private_Financing_c= oppfin.Private_Financing__c;
                US_Federal_Financing_Stafford_c= oppfin.US_Federal_Financing_Stafford__c;
                US_Federal_Financing_Grad_Plus_c= oppfin.US_Federal_Financing_Grad_Plus__c;
                US_Federal_Financing_Parent_Plus_c= oppfin.US_Federal_Financing_Parent_Plus__c;
                US_Federal_Financing_Pell_c= oppfin.US_Federal_Financing_Pell__c;
                Housing_Fee_FS_c = oppfin.Housing_Fee_FS__c;
                Aetna_Insurance_c = oppfin.Aetna_Insurance__c;
                Aetna_Insurance_Price_c = oppfin.Aetna_Insurance_Price__c;
                id=oppfin.id;
                Go_Ed_Loan_Amount_FS_c = oppfin.Go_Ed_Loan_Amount_FS__c;
                Scholarship_Amount_FS_c = oppfin.Scholarship_Amount_FS__c;
                Hult_India_Financial_Aid_c=oppfin.Hult_India_Financial_Aid__c;//Added by anil 2/3/13
                Hult_Financial_Aid_Amount_c=oppfin.Hult_Financial_Aid_Amount__c;
                Financial_Aid_Category_FS_c=oppfin.Financial_Aid_Category__c;
                Installment_Plan_c = oppfin.Installment_Plan__c;
                hultID = oppfin.name;
                Total_Fees_Due_FS_c = oppfin.Total_Fees_Due_FS__c;
                Deposit_Paid_c=oppfin.Deposit_Paid__c;
                Deposit_Date_Paid_c=oppfin.Deposit_Date_Paid__c;
                Current_Balance_Due_Portal_c=oppfin.Current_Balance_Due_Portal__c;
                Net_Amount_Due_c=oppfin.Net_Amount_Due__c;
                Total_Tuition_Amount_c=oppfin.Total_Tuition_Amount__c;
                Course_Deposit_Amount_c=oppfin.Course_Deposit_Amount__c;
                Payment_Amount_1st_c=oppfin.Payment_Amount_1st__c;
                Payment_Amount_2nd_c=oppfin.Payment_Amount_2nd__c;
                Payment_Due_Date_1st_c=oppfin.Payment_Due_Date_1st__c;
                Payment_Due_Date_2nd_c=oppfin.Payment_Due_Date_2nd__c;
                Payment_Plan_c=oppfin.Payment_Plan__c;
                I_agree_to_Hult_Terms_and_Conditions_c=oppfin.I_agree_to_Hult_Terms_and_Conditions__c;
                Total_Tuition_Amount_c=oppfin.Total_Tuition_Amount__c;
                Scholarship_Amount_c=oppfin.Scholarship_Amount__c;
                Go_Ed_Loan_Amount_c=oppfin.Go_Ed_Loan_Amount__c;
                Dubai_Housing_Bursary_Amount_c=string.valueof(oppfin.Dubai_Housing_Bursary_Amount__c);
                Early_Bird_Scholarship_Amount_c=oppfin.Early_Bird_Scholarship_Amount__c;
                Bertil_Hult_Scholarship_Amount_c=string.valueof(oppfin.Bertil_Hult_Scholarship_Amount__c);
                Relocation_Scholarship_Amount_c=string.valueof(oppfin.Relocation_Scholarship_Amount__c);
                Go_Ed_MEFA_Replacement_Loan_Amount_c=string.valueof(oppfin.Go_Ed_MEFA_Replacement_Loan_Amount__c);
                Campus_Financial_Aid_I_FS_c=oppfin.Campus_Financial_Aid_I_FS__c;
                Campus_Financial_Aid_II_FS_c=oppfin.Campus_Financial_Aid_II_FS__c;
                Total_Financial_Aid_Amount_c=oppfin.Total_Financial_Aid_Amount__c;
                Total_Scholarships_c=oppfin.Total_Scholarships__c; 
                CurrencyIsoCode = oppfin.CurrencyIsoCode;
                Student_Resources_Activities_c = oppfin.Student_Resources_Activities__c;
                Toolbox_Case_Study_Pack_c = oppfin.Toolbox_Case_Study_Pack__c;
                Erika_Insurance_Price_c = oppfin.Erika_Insurance_Price__c;
                Insurance_Fee_c = oppfin.Insurance_Fee__c;            
                Visa_Fee_c = oppfin.Visa_Fee__c;
                Specialization_Fee_FS_new_c = oppfin.Specialization_Fee_FS_new__c;
                IEBA_IEMS_Program_Fee_FS_c = oppfin.IEBA_IEMS_Program_Fee_FS__c;
                Partner_Program_Insurance_Fee_FS_c = oppfin.Partner_Program_Insurance_Fee_FS__c;
                Installment_Plan_Fee_FS_c = oppfin.Installment_Plan_Fee_FS__c;
                Insurance_Company_FS_c = oppfin.Insurance_Company_FS__c;
                Total_Fees_Due_FS_c = oppfin.Total_Fees_Due_FS__c;
                Insurance_Type_FS_c = oppfin.Insurance_Type_FS__c;
                Deposit_Amount_Due_FS_c = oppfin.Deposit_Amount_Due_FS__c;
                Dean_Scholarship_Amount_FS_c = oppfin.Dean_Scholarship_Amount_FS__c;
                Bertil_Hult_Scholarship_Amount_FS_c = oppfin.Bertil_Hult_Scholarship_Amount_FS__c;
                Relocation_Scholarship_Amount_FS_c = oppfin.Relocation_Scholarship_Amount_FS__c;
                Total_Financial_Aid_FS_c = oppfin.Total_Financial_Aid_FS__c;
                Total_Balance_Due_FS_c = oppfin.Total_Balance_Due_FS__c;
                Early_Bird_Scholarship_Amount_FS_c = oppfin.Early_Bird_Scholarship_Amount_FS__c;
                paytostudyAmount1 = oppfin.Payment_Amount_1st__c;
                paytostudyAmount2 = oppfin.Tuition_Fees_Balance_Due__c;
                Payment_Amount_3rd_c = oppfin.Payment_Amount_3rd__c;
                Payment_Amount_4th_c = oppfin.Payment_Amount_4th__c;
                Payment_Amount_5th_c = oppfin.Payment_Amount_5th__c;
                Payment_Amount_6th_c = oppfin.Payment_Amount_6th__c;
                Payment_Amount_7th_c = oppfin.Payment_Amount_7th__c;
                Payment_Amount_8th_c = oppfin.Payment_Amount_8th__c;
                Payment_Due_Date_3rd_c = oppfin.Payment_Due_Date_3rd__c;
                Payment_Due_Date_4th_c = oppfin.Payment_Due_Date_4th__c;
                Payment_Due_Date_5th_c = oppfin.Payment_Due_Date_5th__c;
                Payment_Due_Date_6th_c = oppfin.Payment_Due_Date_6th__c;
                Payment_Due_Date_7th_c = oppfin.Payment_Due_Date_7th__c;
                Payment_Due_Date_8th_c = oppfin.Payment_Due_Date_8th__c; 
                Lock_Installment_Plan_c=oppfin.Lock_Installment_Plan__c; 
                
                if(oppfin.Unlock_Student_Financial_Information__c){
                    Unlock_Student_Financial_Information_c =true;
                }
                else{
                    Unlock_Student_Financial_Information_c = false;
                }
                isShow = true;
                }
                catch (exception e){
                    Unlock_Student_Financial_Information_c = false;
                    isShow = false;
                //ApexPages.addMessages(e);
                //oppfin=new Opportunity_Finance__c();
                }
            }    
            catch(exception e){
                apexpages.addmessages(e);
            } 
            
           
            
               
        }*/
        
       // Code for currency convert       
       List<DatedConversionRate> ExchRateCache = [SELECT ISOCode, ConversionRate, StartDate, NextStartDate 
                FROM DatedConversionRate];
                 
       public double nRate(String cCode, date dDateFieldValue){
           double nRate = -1;
                for (DatedConversionRate exchRate : ExchRateCache) {
                    // Looping through the cached DatedConversionRate object
                    if (exchRate.ISOCode == cCode 
                    && exchRate.StartDate <= dDateFieldValue 
                    && exchRate.NextStartDate > dDateFieldValue) {
                        // Look for a match for CURRENCYCODE and within the Date Ranges
                        nRate = exchRate.ConversionRate;
                        break;
                    }
                }
                return nRate;
       }
       public double currencyConvert(double amount,string cCode, Date dDateFieldValue){
           double cValue;
           try{
               cValue = ((nRate(opp.program__r.CurrencyIsoCode,dDateFieldValue))/nRate(cCode ,dDateFieldValue))*amount;
           } 
           Catch(exception e){
               cvalue=amount;
           }
           return cValue;
       } 
       
        // end code for convert currency
        
        public List<Fin_Statement.WrapObj>  getfTransactionList(){
            /*List<Finance_Transactions__c> sList = [select Transaction_Type__c,Amount_Received__c
            , CurrencyIsoCode,Transaction_Date_Time__c from Finance_Transactions__c where Finance__r.Opportunity__c=: opp.id and Transaction_Type__c!='Application Fee' and Transaction_Status__c='Success'];*/
            
            List<Finance_Transactions__c> sList = [select createddate, Transaction_Type__c,Amount_Received__c, CurrencyIsoCode,
            Transaction_Date_Time__c from Finance_Transactions__c where Finance__r.Opportunity__c=: opp.id and (Transaction_Status__c='Success' or Transaction_Status__c='Manually Processed') and Transaction_Type__c!='Application Fee' order by createddate desc];
            
            List<Fin_Statement.WrapObj> wrapList = new List<Fin_Statement.WrapObj>();
            for(Finance_Transactions__c f : sList){
                wrapList.add(new Fin_Statement.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
            return wrapList;
      }
      
      public class WrapObj {
          public DateTime d{get;set;}
          public String tType{get;set;}
          public double aRec{get;set;}
          public String ccode{get;set;}
          public WrapObj(Datetime d, double aRec, String tType, String ccode){
              this.d= d;
              this.aRec= aRec;
              this.tType = tType;
              this.ccode = ccode;
          }
      }
      
      public List<SelectOption> getInstallmentPlan(){
            
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult F = Opportunity_Finance__c.Installment_Plan__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            options.add(new SelectOption('','--Select--'));            
            for(Schema.PicklistEntry pickListvalues : P){
                if(Primary_Program_Choice_c=='Executive MBA'){
                    if(pickListvalues.getvalue()=='FlexiPlan' || pickListvalues.getvalue()=='No FlexiPlan'){
                        options.add(new SelectOption(pickListvalues.getvalue(),pickListvalues.getvalue()));
                    }
                }else{
                    if(pickListvalues.getvalue()=='No Installment Plan' || pickListvalues.getvalue()=='Installment Plan'){
                        options.add(new SelectOption(pickListvalues.getvalue(),pickListvalues.getvalue()));
                    }
                }        
            }
            return options; 
    }
    
    public PageReference isSubmit(){
        if(Installment_Plan_c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please select Hult Installment Plan'));
            return null;
        }

        try{
        if(Lock_Installment_Plan_c==false && (Installment_Plan_c=='FlexiPlan' || Installment_Plan_c=='Installment Plan') ){
            oppfin.Lock_Installment_Plan__c= true;
            Lock_Installment_Plan_c= true;
        }else{
            oppfin.Lock_Installment_Plan__c= false;
             Lock_Installment_Plan_c=false;
        }
        
        oppfin.Installment_Plan__c = Installment_Plan_c;
        update oppfin;
        }
        catch(exception e){
            apexpages.addmessages(e);
        }
        return null;
    } 
    public Finance_Transactions__c ft;
    public string payMethod = 'PaytoStudy';
    public double amount;
     public PageReference PayToStudy1() {
        ft = new Finance_Transactions__c();
        ft.Finance__c = oppfin.id;
        ft.CurrencyIsoCode = ccode;
        ft.Transaction_Method__c = payMethod;
        ft.Transaction_Type__c = 'PtS 1st Payment';        
        try{
            insert ft;
            opp.PaytoStudy_Registration__c = true;
            update opp;                    
        }
        catch(exception e){
            apexpages.addmessages(e);        
            return null;
        }
        PageReference acctPage = System.Page.PayToStudy;
      acctPage.getParameters().put('payid',ft.id);
       acctPage.getParameters().put('ins','1');
      acctPage.setRedirect(true);
      return acctPage;
        //return Page.PayToStudy;
    }
    
    public PageReference PayToStudy2() {
        ft = new Finance_Transactions__c();
        ft.Finance__c = oppfin.id;
        ft.CurrencyIsoCode = ccode;
        ft.Transaction_Method__c = payMethod;
        ft.Transaction_Type__c = 'PtS 2nd Payment';        
        try{
            insert ft;
            opp.PaytoStudy_Registration__c = true;     
            update opp; 
             
        }
        catch(exception e){
            apexpages.addmessages(e);        
            return null;
        }
      PageReference acctPage = System.Page.PayToStudy;
      acctPage.getParameters().put('payid',ft.id);
      acctPage.getParameters().put('ins','2');
      acctPage.setRedirect(true);
      return acctPage;
        //return Page.PayToStudy;
    }
    
    public string setnumber(string num){
        if(integer.valueof(num)<9){
            return '0'+num;
        }
        return num;
    }
    
    public string getpaytoStudyURL(){    
        String getData;
        paytostudyAmount =0;
        string ft = System.currentPagereference().getParameters().get('payid');
        if(System.currentPagereference().getParameters().get('ins')!=null && System.currentPagereference().getParameters().get('ins')=='1'){
            paytostudyAmount= paytostudyAmount1;
        }
        else{
            paytostudyAmount = paytostudyAmount2;
        }
       
        if(Test.isRunningTest()){
        }else{
         //   getData ='?external_unique_id='+ft+'&cu_id_number='+opp.App_ID__c+'&first_name='+user.contact.firstname+'&last_name='+user.contact.lastname+'&__date_of_birth_day='+setnumber(string.valueof(user.contact.Birthdate.day()))+'&__date_of_birth_month='+setnumber(string.valueof(user.contact.Birthdate.month()))+'&__date_of_birth_year='+user.contact.Birthdate.year()+'&email='+user.contact.email+'&suburban_city='+user.contact.Mailingcity+'&country='+user.contact.Mailing_Country__r.Country_Code_for_PaytoStudy__c+'&home_address='+EncodingUtil.urlEncode(user.contact.MailingStreet+'\n'+user.contact.mailingpostalcode+'\n'+user.contact.Mailingstate, 'UTF-8')+'&__home_phone_number_international_dialing_code='+user.contact.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+user.contact.Mailing_Country__r.Calling_Code__c+'&__home_phone_number_mobile_phone='+user.contact.Mobile_Phone_Main_Number__c+'&__mobile_number_international_dialing_code='+user.contact.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+user.contact.Mailing_Country__r.Calling_Code__c+'&__mobile_number_mobile_phone='+user.contact.Home_Phone_Main_Number__c+'&__tuition_fees_price='+paytostudyAmount;
          getData ='?external_unique_id='+ft+'&cu_id_number='+opp.App_ID__c;
        }
        
        if(con.Salutation!=null){
            getData+='&title='+Con.Salutation.replace('.','');
        }

        if(Con.firstname!=null){
            getData+='&first_name='+Con.firstname;
        }else{
            getData+='&first_name=-';
        }

        if(Con.lastname!=null){
            getData+='&last_name='+Con.lastname;
        }else{
            getData+='&last_name=-';
        }
        if(Con.Birthdate!=null){
            getData+='&__date_of_birth_day='+setnumber(string.valueof(con.Birthdate.day()))+'&__date_of_birth_month='+setnumber(string.valueof(Con.Birthdate.month()))+'&__date_of_birth_year='+con.Birthdate.year();
        }else{
            getData+='&__date_of_birth_day=-';
        }
        if(Con.email!=null){
            getData+='&email='+Con.email;
        }else{
            getData+='&email=-';
        }
        if(Con.Mailingcity!=null){
            getData+='&suburban_city='+Con.Mailingcity;
        }else{
            getData+='&suburban_city=-';
        }
        if(Con.Mailing_Country__r.Country_Code_for_PaytoStudy__c!=null){
            getData+='&country='+Con.Mailing_Country__r.Country_Code_for_PaytoStudy__c;
        }else{
            getData+='&country=-';
        }
        if(Con.MailingStreet!=null){
            getData+='&home_address='+EncodingUtil.urlEncode(Con.MailingStreet+'\n'+Con.mailingpostalcode+'\n'+Con.Mailingstate, 'UTF-8');
        }else{
            getData+='&home_address=-';
        }
        if(Con.Mailing_Country__r.Country_Code__c!=null){
            getData+='&__home_phone_number_international_dialing_code='+Con.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+Con.Mailing_Country__r.Calling_Code__c;
        }else{
            getData+='&__home_phone_number_international_dialing_code=-';
        }
        if(Con.Mobile_Phone_Main_Number__c!=null){
            getData+='&__home_phone_number_mobile_phone='+Con.Mobile_Phone_Main_Number__c;
        }else{
            getData+='&__home_phone_number_mobile_phone=-';
        }   
        if(Con.Mailing_Country__r.Country_Code__c!=null){
            getData+='&__mobile_number_international_dialing_code='+Con.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+Con.Mailing_Country__r.Calling_Code__c;
        }else{
            getData+='&__mobile_number_international_dialing_code=-';
        }
        if(Con.Home_Phone_Main_Number__c!=null){
            getData+='&__mobile_number_mobile_phone='+Con.Home_Phone_Main_Number__c;
        }else{
            getData+='&__mobile_number_mobile_phone=-';
        }
        if(paytostudyAmount!=null){
            getData+='&__tuition_fees_price='+paytostudyAmount;
        }else{
            getData+='&__tuition_fees_price=-';
        }
    
        
          
        if(opp.program__r.CurrencyIsoCode== 'GBP'){
            return 'https://hult-uk.studentfees.com/'+getData;
        }
        else if(opp.program__r.CurrencyIsoCode== 'USD'){
            return 'https://hult-usd.studentfees.com/'+getData;
        }
        else if(opp.program__r.CurrencyIsoCode== 'AED'){
            return 'https://hult-aed.studentfees.com/'+getData;
        }
        else if(opp.program__r.CurrencyIsoCode== 'CNY'){
            return 'https://hult-cny.studentfees.com/'+getData;
        }
        return null;
    }     
    
    
    /*
    <!-- This page is similar as FianaceStatementPDF(Component)all the changes are similar to it.-->
<apex:stylesheet value="{!$Resource.style}" />
<apex:outputPanel rendered="{!Unlock_Student_Financial_Information_c}">
<apex:pageMessages ></apex:pageMessages>
<table width="100%" border="0" >
    <tr>
        <td align="center" colspan="2">             
                <table width="100%" cellpadding="0" cellspacing="0">
                <!-- Prem  2/27/2013
                  Added New Logo and New Adress-->
                  <!-- Anil 28/2/2013--Added New log Adjusted the size in the page layout of address on right side-->
                    <tr>                                                
                        <td valign="top" align="left"><apex:image url="{!$Resource.Hult_Logo}" style="height:40px;width:180px;"/></td>
                        <td class="formlableheader" width="36%">
                        <td valign="top" align="left" class="headerImage">
                        <!-- Prem 3/19/2013
                         if the Campus is London company name should be 'Hult International Business School Ltd'
                         if not 'Hult International Business School AG' -->
                          <apex:outputPanel rendered="{!if(ccode!='GBP',true,false)}">      
                                <b>Hult International Business School AG</b><br />                           
                                Haldenstrasse 4<br />
                                6006 Lucerne <br />
                                Switzerland <br />
                                Tel: +41 (0) 414174635<br />
                                www.hult.edu<br />
                            </apex:outputPanel>
                            <!--<apex:outputPanel rendered="{!if(CurrencyIsoCode=='GBP',true,false)}">
                                <b>Hult International Business School Ltd</b><br />
                                46-47 Russell Square<br />
                                Bloomsbury, London WC1B 4 JP, <br />United Kingdom<br />
                                Tel: + 44 20 7636 5667<br />
                                Fax: +44 20 7691 9344<br />
                            </apex:outputPanel>-->
                        </td>
                       </td>
                    </tr>
                </table>
            
        </td>
    </tr>
    <tr class="desFont" >
        <td colspan="2">&nbsp;
        </td>
    </tr>
    <tr>
        <td align="center" colspan="2" class="formlableheader">
          <h2>  Statement Of Account </h2> <!--Anil.B--1/3/2013-- Changed the font size--->
        </td>
    </tr>
   
  <tr class="desFont" >
    <td class="formlableheader"  Width="30%" align="left">Full Name:</td>
    <td  class="formlable" width="80%"><apex:outputField value="{!con.firstname}"/>&nbsp;<apex:outputField value="{!con.lastname}"/></td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader">Hult ID:</td>
    <td class="formlable"><apex:outputText value="{!App_ID_c}" /></td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader" valign="top" >Address:</td>
    <td class="formlable">
    <apex:outputText rendered="{!if(Con.MailingStreet!=null,true,false)}" value="{!Con.MailingStreet}," /> <br />
    <apex:outputText rendered="{!if(Con.Mailingcity!=null,true,false)}" value="{!Con.Mailingcity}," /> <br />
    <apex:outputText rendered="{!if(Con.Mailingstate!=null,true,false)}" value="{!Con.Mailingstate}" /> <br />
    <apex:outputText rendered="{!if(Con.mailingpostalcode!=null,true,false)}" value="{!Con.mailingpostalcode}" /> <br />
    <apex:outputText rendered="{!if(Con.Mailing_Country__r.name!=null,true,false)}" value="{!Con.Mailing_Country__r.name}" /> <br />
   </td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader">Date Issued</td>
    <td class="formlable">
        <apex:outputText value="{0,date,dd'/'MM'/'yyyy}">
            <apex:param value="{!DatePrinted}" /> 
        </apex:outputText>
    </td>
  </tr>
  <apex:outputtext rendered="{!if((Payment_Amount_1st_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">1st Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;    
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_1st_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_1st_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_1st_c}" /> 
        </apex:outputText></td>
  </tr>
  </apex:outputtext>
  <apex:outputText rendered="{!if((Payment_Amount_2nd_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">2nd Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_2nd_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_2nd_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_2nd_c}" /> 
        </apex:outputText></td>
  </tr>
  
  
  </apex:outputText>

  <!-- Code for Eight Payments---->
  <!--<apex:outputText rendered="{!if(((Installment_Plan_c=='FlexiPlan' || Installment_Plan_c=='No FlexiPlan') && Primary_Program_Choice_c=='Executive MBA'),true,false)}">--->
    <apex:outputText rendered="{!if((Payment_Amount_3rd_c != 0),true,false)}">
    <tr class="desFont">
    <td class="formlableheader">3rd Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_3rd_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_3rd_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_3rd_c}" /> 
        </apex:outputText></td>
  </tr>
   </apex:outputText>
  
  <apex:outputText rendered="{!if(((Installment_Plan_c=='FlexiPlan' || Installment_Plan_c=='No FlexiPlan') && Primary_Program_Choice_c=='Executive MBA'),true,false)}">
    <tr class="desFont">
    <td class="formlableheader">4th Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_4th_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_4th_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_4th_c}" /> 
        </apex:outputText></td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Installment_Plan_c=='FlexiPlan' && Primary_Program_Choice_c=='Executive MBA'),true,false)}">
      <tr class="desFont">
    <td class="formlableheader">5th Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_5th_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_5th_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_5th_c}" /> 
        </apex:outputText></td>
  </tr>
      <tr class="desFont">
    <td class="formlableheader">6th Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_6th_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_6th_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_6th_c}" /> 
        </apex:outputText></td>
  </tr>
      <tr class="desFont">
    <td class="formlableheader">7th Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_7th_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_7th_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_7th_c}" /> 
        </apex:outputText></td>
  </tr>
      <tr class="desFont">
    <td class="formlableheader">8th Tuition and Fee Payment:</td>
    <td class="formlable">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Payment_Amount_8th_c}"/>
        </apex:outputText>
    &nbsp;&nbsp;<apex:outputText rendered="{!if(not isnull(Payment_Due_Date_8th_c),true,false)}" value="(Due: {0,date,dd'/'MM'/'yyyy})">
            <apex:param value="{!Payment_Due_Date_8th_c}" /> 
        </apex:outputText></td>
  </tr>
  </apex:outputText>
  <tr>
    <td>
    </td>
    <!--Modified by Anil.B - 20/06/2013-Changed paragraph of 181 to 179 line bases on JIRA No:SFSUP-610 and increased the font size to 8px to 9 px ---->
    <td style="font-size:9px ">
    The above amounts indicating payments due reflect the original payment plan and may differ from the current balance due on your live Hult statement below.The above amounts do not update once payment has been made but the current balance on your statement below does. You need to ensure that you have paid the amount that is due by the dates above. Please contact our finance dept if you have any questions.


    <!--The above amounts for the 1st and 2nd payments due reflect the original payment plan and may differ from the current balance due on your live Hult statement below. The above amounts do not update once payment has been made but the current balance on your statement below does. You need to ensure that you have paid the amount that is due by the dates above. Please contact our finance dept if you have any questions.-->
  
    </td>  
  </tr>
  <tr class="desFont">
    <td class="formlable">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader" colspan="2">Program Fee</td>
  </tr>
  <tr class="desFont">
     <td height="19" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;">&nbsp;</td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader">Program:</td>
    <td class="formlableheader" align="right">{!Program_c}</td>
  </tr>
  <apex:outputText rendered="{!if((Total_Tuition_Amount_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Tuition Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Tuition_Amount_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Housing_Accommodation_c!=null),true,false)}">
  <tr class="desFont">
    <td class="formlable">Housing Accommodation:</td>
    <td class="formlableheader" align="right">
        <apex:outputText value="{!Housing_Accommodation_c}">        
        </apex:outputText>
    </td>
  </tr> 
  <tr class="desFont">
    <td class="formlable">Housing Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0,number,.00}">
        <apex:param value="{!Housing_Fee_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <!--
  <apex:outputText rendered="{!if((Insurance_Fee_c != 0),true,false)}">
   <tr class="desFont">
    <td class="formlable">Insurance Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Insurance_Fee_c}"/>
        </apex:outputText>
    </td>
   </tr>
  </apex:outputText>
  -->
    <apex:outputText rendered="{!if((Insurance_Fee_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">{!Insurance_Company_FS_c}:&nbsp; <apex:outputText rendered="{!if(AND(Insurance_Type_FS_c !=null,NOT(ISBLANK(Insurance_Type_FS_c))),true,false)}" style="align:left;font-size:8px;font-weight:normal;" value="({!Insurance_Type_FS_c})" /></td>
  <!--  <td class="formlableheader" align="Right">({!Insurance_Type_FS_c})&nbsp;{!CurrencyIsoCode}&nbsp; --Changes Made by -Anil.B-->
        <td class="formlableheader" align="Right">&nbsp;{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Insurance_Fee_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText> 
  <apex:outputText rendered="{!if((Visa_Fee_c !=null),true,false)}">
   <tr class="desFont">
    <td class="formlable">Visa Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Visa_Fee_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Specialization_Fee_FS_new_c != 0),true,false)}">
   <tr class="desFont">
    <td class="formlable">Specialization Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Specialization_Fee_FS_new_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((IEBA_IEMS_Program_Fee_FS_c != 0),true,false)}">
   <tr class="desFont">
    <td class="formlable">IEMA Program Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!IEBA_IEMS_Program_Fee_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Partner_Program_Insurance_Fee_FS_c != 0),true,false)}">
   <tr class="desFont">
    <td class="formlable">Partner Program Insurance Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Partner_Program_Insurance_Fee_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Installment_Plan_Fee_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Installment Plan Fee:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Installment_Plan_Fee_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
<!--
  <tr>
    <td class="formlable">Toolbox and Case Study Pack:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;{!Toolbox_Case_Study_Pack_c}</td>
  </tr>
  <tr>
    <td class="formlable">Student Resources and Activities:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;{!Student_Resources_Activities_c}</td>
  </tr>


  <apex:outputText rendered="{!if((Total_Fees_Due_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Total Fee Due</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Fees_Due_FS_c}"/>
        </apex:outputText>
    
    </td>
  </tr>
  </apex:outputText>
-->
  <tr class="desFont">
     <td height="2" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;"></td>
  </tr>
  <apex:outputText rendered="{!if((Total_Fees_Due_FS_c!=0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">Total Tuition And Fees:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Fees_Due_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <tr>
      <td colspan="2" height="5px">
      </td>
  </tr>
  <!--
  <apex:outputText rendered="{!if((Deposit_Amount_Due_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Deposit Amount Due:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Deposit_Amount_Due_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  -->
  <tr class="desFont">
    <td class="formlable">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <apex:outputText rendered="{!if((Total_Scholarships_c!=0),true,false)}"><!--- Added Condition Anil.B--4/3/2013--->
  <tr class="desFont">
    <td class="formlableheader" colspan="2">Scholarships</td>
  </tr>
  <tr class="desFont">
     <td height="19" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;">&nbsp;</td>
  </tr>
  <apex:outputText rendered="{!if((Scholarship_Amount_FS_c !=null),true,false)}">
  <tr class="desFont">
    <td class="formlable" width="40%">Scholarship Amount:&nbsp;  <apex:outputText rendered="{!if(AND(Scholarship_Amount_FS_c != 0,NOT(ISBLANK(Financial_Aid_Category_FS_c))),true,false)}" style="align:left;font-size:8px;font-weight:normal;" value="({!Financial_Aid_Category_FS_c})" /> </td>
    <td class="formlableheader" align="left">
    <!--2/27/2013 : Anil (Global Leadership) should appear next to ‘Scholarship Amount’ not on the far right side -->
    <span style='float:left'>
       <!-- <apex:outputText rendered="{!if(AND(Scholarship_Amount_FS_c != 0,NOT(ISBLANK(Financial_Aid_Category_FS_c))),true,false)}" style="align:left;font-size:8px;font-weight:normal;" value="({!Financial_Aid_Category_FS_c})" /><!-- <font style="font-size:8px;">({!Financial_Aid_Category_FS_c})</font>-->
    </span>
   
    <span style='float:right'>
        {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Scholarship_Amount_FS_c}"/>
        </apex:outputText>
    </span>
    
   </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if((Dean_Scholarship_Amount_FS_c !=0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Dean Scholarship Amount:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0,number,.00}">
        <apex:param value="{!Dean_Scholarship_Amount_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <!--Anil.B-1/3/2013- Added New Field called Subtotal(Total_Scholarships_c) to the page layout-->
   <tr>
     <td height="2" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;"></td>
  </tr>

  <apex:outputText rendered="{!if((Total_Scholarships_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">Total Scholarships:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Scholarships_c}"/>
        </apex:outputText>
    </td>
  </tr>
  
  </apex:outputText>
   <tr>
      <td colspan="2" height="20px">
      </td>
  </tr>
  </apex:outputText>
  <!--Anil.B-1/3/2013-Changes End hear-->
  
  <!-- 2/27/2013: Prem added Hult Financial Aid into Finance Statement PDF (Separate line)-->
  
  <tr class="desFont" >
    <td class="formlableheader" colspan="2">Financial Aid</td>
  </tr>
  <tr class="desFont">
     <td height="19" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;">&nbsp;</td>
  </tr>
  <apex:outputText rendered="{!if((Hult_Financial_Aid_Amount_c!=0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Hult Financial Aid Amount: </td>
    <td class="formlableheader" align="right">
    {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Hult_Financial_Aid_Amount_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if(Go_Ed_Loan_Amount_FS_c != 0 && (GoEd_Financing_Status_c== 'Complete application submitted' || GoEd_Financing_Status_c== 'In progress' || GoEd_Financing_Status_c== 'Evaluation pending'),true,false)}">
  <tr class="desFont">
    <td class="formlable">Go Ed Loan Amount:</td>
    <td class="formlableheader" align="right">
    <!--<apex:outputText rendered="{!if(Go_Ed_Loan_Amount_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!Go_Ed_Loan_Note_FS_c})" />    -->   
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Go_Ed_Loan_Amount_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>

  <apex:outputText rendered="{!if((Early_Bird_Scholarship_Amount_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Early Bird Scholarship Amount:</td>
    <td class="formlableheader" align="right">
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Early_Bird_Scholarship_Amount_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if((Bertil_Hult_Scholarship_Amount_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Bertil Hult Scholarship Amount:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Bertil_Hult_Scholarship_Amount_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  <apex:outputText rendered="{!if((Relocation_Scholarship_Amount_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Relocation Financial Aid Amount:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Relocation_Scholarship_Amount_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
    <apex:outputText rendered="{!if((Adjustment_Amount_c !=null),true,false)}">
  <tr class="desFont">
    <td class="formlable">Adjustment Amount:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Adjustment_Amount_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
    <apex:outputText rendered="{!if(Private_Financing_c!=null && (Private_Financing_Status_c== 'Approved' || Private_Financing_Status_c== NULL),true,false)}">
  <tr class="desFont">
    <td class="formlable">Private Financing:&nbsp;<apex:outputText rendered="{!if(Go_Ed_Loan_Amount_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!Private_Financing_Note_c})" /></td>
    <td class="formlableheader" align="right">
   <!-- <apex:outputText rendered="{!if(Go_Ed_Loan_Amount_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!Private_Financing_Note_c})" /> -- Changes Made by Anil.B--4/3/2013-->      
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0,number,.00}">
        <apex:param value="{!Private_Financing_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
 <apex:outputText rendered="{!if(US_Federal_Financing_Stafford_c!=null && (Status_Stafford_c== 'Approved' || Status_Stafford_c== NULL),true,false)}">
  <tr class="desFont">
    <td class="formlable" align="left" width="52%">Stafford Loan:&nbsp;<apex:outputText rendered="{!if(US_Federal_Financing_Stafford_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Stafford_c})" /></td>
    <td class="formlableheader" align="right">
   <!-- <apex:outputText rendered="{!if(US_Federal_Financing_Stafford_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Stafford_c})" /> -- Changes Made by Anil.B--4/3/2013-->      
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!US_Federal_Financing_Stafford_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if(US_Federal_Financing_Grad_Plus_c!=null && (Status_Grad_Plus_c== 'Approved' || Status_Grad_Plus_c== NULL),true,false)}">
  <tr class="desFont">
    <td class="formlable" >Grad Plus Loan:&nbsp;<apex:outputText rendered="{!if(US_Federal_Financing_Grad_Plus_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Grad_Plus_c})" /></td>
    <td class="formlableheader" align="right">
   <!-- <apex:outputText rendered="{!if(US_Federal_Financing_Grad_Plus_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Grad_Plus_c})" /> -- Changes Made by Anil.B--4/3/2013-->      
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0,number,.00}">
        <apex:param value="{!US_Federal_Financing_Grad_Plus_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if(US_Federal_Financing_Parent_Plus_c!=null && (Status_Parent_Plus_c== 'Approved' || Status_Parent_Plus_c== NULL),true,false)}">
  <tr class="desFont">
    <td class="formlable">Parent Plus Loan:&nbsp;<apex:outputText rendered="{!if(US_Federal_Financing_Parent_Plus_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Parent_Plus_c})" /></td>
    <td class="formlableheader" align="right">
   <!-- <apex:outputText rendered="{!if(US_Federal_Financing_Parent_Plus_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Parent_Plus_c})" /> -- Changes Made by Anil.B--4/3/2013-->      
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!US_Federal_Financing_Parent_Plus_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if(US_Federal_Financing_Pell_c!=null && (Status_Pell_c == 'Approved' || Status_Pell_c == NULL),true,false)}">
  <tr class="desFont">
    <td class="formlable">Pell Grant:&nbsp; <apex:outputText rendered="{!if(US_Federal_Financing_Pell_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Pell_c})" /> </td>
    <td class="formlableheader" align="right">
    <!--<apex:outputText rendered="{!if(US_Federal_Financing_Pell_c!=0,true,false)}" style="font-size:8px;font-weight:normal" value="({!US_Federal_Financing_Note_Pell_c})" />  -- Changes Made by Anil.B--4/3/2013-->    
         {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!US_Federal_Financing_Pell_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>  
  
  
  <apex:outputText rendered="{!if((Hult_India_Financial_Aid_c!=null),true,false)}">
  <tr class="desFont">
    <td class="formlable">Currency Compensation Amount:</td>
   <td class="formlableheader" align="right">
        {!CurrencyIsoCode}&nbsp;
         <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Hult_India_Financial_Aid_c}"/>
        </apex:outputText>
   </td>
  </tr>
  </apex:outputText>
  
  <!-- Added by Premanath Reddy 5/23/2013:: Reason: Added the two fields 'Campus Financial Aid I FS' and 'Campus Financial Aid II FS' under Financial Aid Section-->
  <apex:outputText rendered="{!if((Campus_Financial_Aid_I_FS_c != 0),true,false)}"> 
  <tr class="desFont">
    <td class="formlable">Campus Financial Aid I</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Campus_Financial_Aid_I_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <apex:outputText rendered="{!if((Campus_Financial_Aid_II_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Campus Financial Aid II</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Campus_Financial_Aid_II_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  <!-- Hotel and Flight Anil.B 20/6/2013--->
 <apex:outputText rendered="{!if((oppfin.OP_Program__c=='EMBAm-UAE-Dubai' && oppfin.Fin_Aid_Hotel_and_Flight__c!=null ),true,false)}">
  <tr class="desFont">
    <td class="formlable">Fin Aid Hotel and Flight</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!oppfin.Fin_Aid_Hotel_and_Flight__c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
 <!-- <apex:outputText rendered="{!if((Scholarship_Amount_c !=null),true,false)}">
  <tr class="desFont">
    <td class="formlable">Merit Base Scholarship Amount:</td>
   <td class="formlableheader" align="right">
        {!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{!Scholarship_Amount_c }">
        <apex:param value="{!Scholarship_Amount_c}"/>
        </apex:outputText>
   </td>
  </tr>
  </apex:outputText>-- Commented by Anil.B Similar as scholarship amount-->
  
  
  <!-- 
  <tr>
    <td class="formlable">Should say Total Financial Aid not Total:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;</td>
  </tr> 
  <tr>
    <td class="formlable">Scholarships &amp; Loans:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;{!Scholarship_Amount_c}</td>
  </tr> -->

  
  <tr>
     <td height="2" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;"></td>
  </tr>

  <apex:outputText rendered="{!if((Total_Financial_Aid_Amount_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">Total Financial Aid:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Financial_Aid_Amount_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
  
  
  
  
    <!--
  <tr class="desFont">
     <td height="19" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;">&nbsp;</td>
  </tr>
  
  <apex:outputText rendered="{!if((Total_Financial_Aid_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">Total Financial Aid:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Financial_Aid_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
    -->
    
<tr>
    <td class="formlable" height="5px"></td>
    <td></td>
  </tr>
  <apex:outputText rendered="{!if((Total_Balance_Due_FS_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlable">Total Balance Due:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Total_Balance_Due_FS_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
    
  <tr>
    <td class="formlable">&nbsp;</td>
    <td></td>
  </tr>
  <tr class="desFont">
    <td class="formlableheader" colspan="2">Payments</td>

  </tr>
  <tr>
     <td height="2" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;"></td>
  </tr>
  <tr class="desFont">
    <td colspan="2">
         <apex:dataTable width="100%" border="0" cellpadding="1px;" headerClass="desFont" value="{!fTransactionList}" var="e" >
            <apex:column width="35%">
                <apex:facet name="header">Date</apex:facet>                
                <apex:outputText value="{0,date,dd'/'MM'/'yyyy}">
                    <apex:param value="{!e.d}" /> 
                </apex:outputText>
            </apex:column>
            <apex:column width="30%">
                <apex:facet name="header">Description</apex:facet>
                <apex:outputText value="{!e.tType}" style="font-size:10px"/>  <!--Added font size  by anil.B 18/4/2013-->
            </apex:column>
            <apex:column width="30%" style="text-align:right" >  <!--Alignement size decreased from 35-30 by anil.B 18/4/2013-->
                <apex:facet name="header"><span style="float:right">Currency &amp; Amount Applied</span></apex:facet>
                <!-- apex:outputText value="{!e.ccode} {!e.aRec}"/ -->
                <apex:outputText value="{!e.ccode}{0,number,.00}">
                    <apex:param value="{!e.aRec}"/>
                </apex:outputText>
            </apex:column>
        </apex:datatable>
                                                 
    </td>
    

  </tr>
  <tr>
     <td height="2" colspan="2" background="{!URLFOR($Resource.Images, 'new-images/line.jpg')}" style="background-repeat:repeat-x;"></td>
  </tr>
  <apex:outputText rendered="{!if((Current_Balance_Due_Portal_c != 0),true,false)}">
  <tr class="desFont">
    <td class="formlableheader">Current Balance Due:</td>
    <td class="formlableheader" align="right">{!CurrencyIsoCode}&nbsp;
        <apex:outputText value="{0, number, .00}">
        <apex:param value="{!Current_Balance_Due_Portal_c}"/>
        </apex:outputText>
    </td>
  </tr>
  </apex:outputText>
<!--Modified By Anil.B on 2/7/2013---JIRA NO::SFSUP-607--Commented the Output text->
<!--  <apex:outputText rendered="{!if(CurrencyIsoCode=='GBP',true,false)}">-->
      <tr class="desFont">
        <td class="formlable">&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <!--Modified by Anil.B on 19/6/2013 at line 717 Just changed Limited to AG in the Remark Paragraph on request of JIRA NO:-SFSUP-607 -->
      <tr class="formlable">
        <td class="formlableheader" colspan="2">Remark: The Tuition Fee amount includes a portion collected on behalf of Hult International Business School AG. Switzerland for services such as Application Processing, Career &amp; Alumni services and others, as specified in the Terms &amp; Conditions by Hult International Business School AG.</td>
      </tr>
 <!-- </apex:outputText> -->
</table>
</apex:outputPanel>
<apex:outputPanel rendered="{! NOT Unlock_Student_Financial_Information_c}">
<table width="100%">
    <tr>
        <td class="formlableheader" align="center">
            Not available yet
        </td>
    </tr>
</table>
</apex:outputPanel>
    
    
    */
}