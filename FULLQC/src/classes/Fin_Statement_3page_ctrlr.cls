/*
Test Class :- TestForFin_Statement_3page_ctrlr (92%)
VF page:- Fin_Statement_3page
*/
public without sharing class Fin_Statement_3page_ctrlr 
{

    public User user{get;set;} 
    public Opportunity opp{get;set;}
    public Contact con{get;set;}
    public Requirement__c req{get;set;}
    public String firstname{get;set;}
    public string lastname{get;set;}
    Public string nomap{get;set;} 
    public double Total_Fees_Due_FS_c{get;set;}    
    public double Go_Ed_Loan_Amount_FS_c{get;set;}
    public double Scholarship_Amount_FS_c{get;set;}  
    public double Housing_Fee_FS_c{get;set;}
    Public double Payment_Amount_1st_c{get;set;}
    Public double Payment_Amount_2nd_c{get;set;}
    Public Date Payment_Due_Date_1st_c{get;set;}
    Public Date Payment_Due_Date_2nd_c{get;set;}
    //Public String Payment_Plan_c{get;set;}
    Public boolean I_agree_to_Hult_Terms_and_Conditions_c{get;set;}
    public String Program_c{get;set;}
    public String stage{get;set;}
    public string id{get;set;}
    public double Accommodation_Depositx_c{get;set;}
    public double Total_Tuition_Amount_c{get;set;}
    public Double Scholarship_Amount_c{get;set;}
    public double Go_Ed_Loan_Amount_c{get;set;}
    public string Dubai_Housing_Bursary_Amount_c{get;set;}
    public Double Early_Bird_Scholarship_Amount_c{get;set;}
    public Double Hult_India_Financial_Aid_c{get;set;}//Added by anil 24/5/13
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
    public string PrimaryCampus{get;set;}
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
    Public String Financial_Aid_Category_c{get;set;}
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
    public boolean islondon{get;set;}
    public double Hult_Financial_Aid_Amount_c{get;set;}
    public double Total_Tuition_Amount_p2_c{get;set;}
    public double Total_Tuition_Amount_p23_c{get;set;}
    public double Core_tuition_page2_c{get;set;}
    public double Core_tuition_page3_c{get;set;}
    public double Specialization_Fee_FS_new_p22_c{get;set;}
    public double Specialization_Fee_FS_new_p23_c{get;set;}
    public double IEBA_IEMS_Program_Fee_FS_p23_c{get;set;}
    Public double Total_tution_fee_p1_c{get;set;}
    public double Total_tution_fee_p2_c{get;set;}
    public double Total_tution_fee_p3_c{get;set;}
    public double Scholarship_Amount_FS_p23_c{get;set;}
    public double Go_Ed_Loan_Amount_FS_p23_c {get;set;}
    public double Bertil_Hult_Scholarship_Amount_FS_p23_c{get;set;}
    public double Dean_Scholarship_Amount_FS_p23_c{get;set;}
    public double Relocation_Scholarship_Amount_FS_p22_c{get;set;}
    public double Relocation_Scholarship_Amount_FS_p23_c{get;set;}
    public double Total_Financial_Aid_Amount_p2_c{get;set;}
    public double Total_Financial_Aid_Amount_p3_c{get;set;}
    public double Total_Balance_Due_FS_p2_c{get;set;}
    public double Total_Balance_Due_FS_p3_c{get;set;}
    Public double Fin_Aid_Hotel_and_Flight_c{get;set;}
    Public double Fin_Aid_Hotel_and_Flight22_c{get;set;}
    Public double Fin_Aid_Hotel_and_Flight23_c{get;set;}
    Public double Total_Scholarships_c{get;set;}
    Public double Scholarship_Amount_FS_p22_c{get;set;}
    Public double Dean_Scholarship_Amount_FS_p22_c{get;set;}
    Public double Total_Scholarships_p22_c{get;set;}
    Public double Total_Scholarships_p23_c{get;set;}
    public double Hult_Financial_Aid_Amount_p22_c{get;set;}
    public double Hult_Financial_Aid_Amount_p23_c{get;set;}
    public double Go_Ed_Loan_Amount_FS_p22_c{get;set;}
    public double Bertil_Hult_Scholarship_Amount_FS_p22_c{get;set;}
    public double Adjustment_Amount_p22_c{get;set;}
    public double Adjustment_Amount_p23_c{get;set;}
    public double Private_Financing_p22_c{get;set;}
    public double Private_Financing_p23_c{get;set;} 
    public double US_Federal_Financing_Stafford_p22_c{get;set;}
    public double US_Federal_Financing_Grad_Plus_p22_c{get;set;}
    public double US_Federal_Financing_Parent_Plus_p22_c{get;set;}
    public double US_Federal_Financing_Pell_p22_c{get;set;}
    public double US_Federal_Financing_Stafford_p23_c{get;set;}
    public double US_Federal_Financing_Grad_Plus_p23_c{get;set;}
    public double US_Federal_Financing_Parent_Plus_p23_c{get;set;}
    public double US_Federal_Financing_Pell_p23_c{get;set;}
    public double Hult_India_Financial_Aid_p22_c {get;set;}
    public double Hult_India_Financial_Aid_p23_c {get;set;}
    public Double Campus_Financial_Aid_I_FS_p22_c{get;set;}
    public Double Campus_Financial_Aid_I_FS_p23_c{get;set;}
    public Double Campus_Financial_Aid_II_FS_p22_c{get;set;}
    public Double Campus_Financial_Aid_II_FS_p23_c{get;set;}
    public Double Rotation_1_Fee_c{get;set;}
    public Double Rotation_2_Fee_c{get;set;}
    public Double Rotation_3_Fee_c{get;set;}
    public Double Rotation_4_Fee_c{get;set;}
    public Double Rotation_5_Fee_c{get;set;}
    public Double Rotation_6_Fee_c{get;set;}
    public string type{get;set;}
    Public double Rotation_Finance_c{get;set;}
    public string Rot_Housing_Module_D_c{get;set;}
    public string Rot_Visa_Module_D_c{get;set;}
    public string Rot_Insurance_Module_D_c{get;set;}
    public string Rot_Housing_Module_E_c{get;set;}
    public string Rot_Visa_Module_E_c{get;set;}
    public string Rot_Insurance_Module_E_c{get;set;}
   
    
    
        public Fin_Statement_3page_ctrlr()
        {
            try{
                islondon=false;
                Lock_Installment_Plan_c=false;
                nomap='No Map';
                type=System.currentPagereference().getParameters().get('type');
                // This condition use for create PDF from admin
                if(System.currentPagereference().getParameters().get('contactid')==null){
                  /*  user = [SELECT contact.Mailing_Country__r.Country_Code__c,contact.Student_ID__c,contact.Mailing_Country__r.Calling_Code__c, contact.Mailing_Country__r.Country_Code_for_PaytoStudy__c, contact.Mobile_Phone_Main_Number__c, contact.Home_Phone_Main_Number__c, contact.email, contact.Birthdate, contact.Salutation, contact.MailingStreet, contact.mailingpostalcode,contact.Mailingstate, contact.Mailingcity, contact.Mailing_Country__r.name, contact.id,contact.firstname,contact.lastname FROM User WHERE id = :UserInfo.getUserId()];*/
                }
                else{
                  /*  user = [SELECT contact.Mailing_Country__r.Country_Code__c,contact.Student_ID__c,contact.Mailing_Country__r.Calling_Code__c, contact.Mailing_Country__r.Country_Code_for_PaytoStudy__c, contact.Mobile_Phone_Main_Number__c, contact.Home_Phone_Main_Number__c, contact.email, contact.Birthdate, contact.Salutation, contact.MailingStreet, contact.mailingpostalcode,contact.Mailingstate, contact.Mailingcity, contact.Mailing_Country__r.name, contact.id,contact.firstname,contact.lastname FROM User WHERE contact.id = :System.currentPagereference().getParameters().get('contactid') limit 1];*/
                  Con=[select id,name,lastname,firstname
                     ,Mailing_Country__r.Country_Code__c
                     ,Mailing_Country__r.Calling_Code__c
                     ,Mailing_Country__r.Country_Code_for_PaytoStudy__c
                     ,Mobile_Phone_Main_Number__c
                     ,Home_Phone_Main_Number__c,Student_ID__c 
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
                        ccode= 'GBP';islondon=true;
                    }
                else{
                       ccode= 'USD';islondon=false;
                }
                              
                try{
                oppfin=[select 
                Lock_Installment_Plan__c,
                Accommodation_Depositx__c,
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
                Go_Ed_Loan_Note__c,
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
                Annual_Accommodation_Fee__c,
                Insurance__c,
                Early_Bird_Scholarship_Amount__c,
                Hult_India_Financial_Aid__c,
                Total_Balance_Due_FS__c,
                Total_Financial_Aid__c,                
                Bertil_Hult_Scholarship_Amount__c,
                Campus_Financial_Aid_I__c,
                Campus_Financial_Aid_II__c,
                Dean_Scholarship_Amount__c,
                Deposit_Amount_Due_FS__c,
                Insurance_Provider__c,
                Installment_Plan_Fee__c,                
                Partner_Program_Fee__c,
                Specialization_Fee_preFS__c,
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
                OP_Campus__c, 
                Partner_Program_Insurance_Fee__c,         
                Deposit_Paid__c,
                Deposit_Date_Paid__c, 
                Course_Deposit_Amount__c,
                Total_Tuition_Amount__c,                               
                Net_Amount_Due__c,                
                Fin_Aid_Hotel_and_Flight__c,
                Total_Scholarships__c,
                Hult_Financial_Aid_Amount__c,
                Accommodation_weeks__c,
                Financial_Aid_Category__c,
                Rotation_Finance__c,
                Rot_Housing_Module_D__c,
                Rot_Visa_Module_D__c,
                Rot_Insurance_Module_D__c,
                Rot_Housing_Module_E__c,
                Rot_Visa_Module_E__c,
                Rot_Insurance_Module_E__c,
                Rot_Housing_Mod_D_Fee__c,
                Rot_Visa_Mod_D_Fee__c,
                Rot_Insurance_Mod_D_Fee__c,
                Rot_Housing_Mod_E_Fee__c,
                Rot_Visa_Mod_E_Fee__c,
                Rot_Insurance_Mod_E_Fee__c,
                Scholarship_Amount__c,
                Go_Ed_Loan_Amount__c,
                Dubai_Housing_Bursary_Amount__c,
                Relocation_Scholarship_Amount__c,
                Go_Ed_MEFA_Replacement_Loan_Amount__c,
                Total_Financial_Aid_Amount__c, 
                Payment_Amount_1st__c,
                Payment_Amount_2nd__c,
                Payment_Due_Date_1st__c,
                Payment_Due_Date_2nd__c,                
                I_agree_to_Hult_Terms_and_Conditions__c,Name,Id from Opportunity_Finance__c where Opportunity__c=:opp.id];
                
                system.debug('oppfin = ' + oppfin);
                
                system.debug('opp.id = ' + opp.id);
                
                Rotation_1_Fee_c=oppfin.Rot_Housing_Mod_D_Fee__c;
                Rotation_2_Fee_c=oppfin.Rot_Visa_Mod_D_Fee__c;
                Rotation_3_Fee_c=oppfin.Rot_Insurance_Mod_D_Fee__c;
                Rotation_4_Fee_c=oppfin.Rot_Housing_Mod_E_Fee__c;
                Rotation_5_Fee_c=oppfin.Rot_Visa_Mod_E_Fee__c;
                Rotation_6_Fee_c=oppfin.Rot_Insurance_Mod_E_Fee__c;
                
                Rot_Housing_Module_D_c=oppfin.Rot_Housing_Module_D__c;
                Rot_Visa_Module_D_c=oppfin.Rot_Visa_Module_D__c;
                Rot_Insurance_Module_D_c=oppfin.Rot_Insurance_Module_D__c;
                Rot_Housing_Module_E_c=oppfin.Rot_Housing_Module_E__c;
                Rot_Visa_Module_E_c=oppfin.Rot_Visa_Module_E__c;
                Rot_Insurance_Module_E_c=oppfin.Rot_Insurance_Module_E__c;
                
                Financial_Aid_Category_c=oppfin.Financial_Aid_Category__c;
                Accommodation_Depositx_c=oppfin.Accommodation_Depositx__c;
                Housing_Accommodation_c =oppfin.Housing_Accommodation__c!=Null?oppfin.Housing_Accommodation__c+'/'+oppfin.Accommodation_weeks__c+' Weeks':Null;
                Go_Ed_Loan_Note_FS_c = oppfin.Go_Ed_Loan_Note__c;
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
                Housing_Fee_FS_c = oppfin.Annual_Accommodation_Fee__c;
                Aetna_Insurance_c = oppfin.Aetna_Insurance__c;
                Aetna_Insurance_Price_c = oppfin.Aetna_Insurance_Price__c;
                id=oppfin.id;
                Go_Ed_Loan_Amount_FS_c = oppfin.Go_Ed_Loan_Amount__c;
                Scholarship_Amount_FS_c = oppfin.Scholarship_Amount__c;
                Hult_India_Financial_Aid_c=oppfin.Hult_India_Financial_Aid__c;//Added by anil 24/5/13
                Installment_Plan_c = oppfin.Installment_Plan__c;
                hultID = oppfin.name;
                Total_Fees_Due_FS_c = oppfin.Total_Fees_Due_FS__c;
                Deposit_Paid_c=oppfin.Deposit_Paid__c;
                Deposit_Date_Paid_c=oppfin.Deposit_Date_Paid__c;
                Current_Balance_Due_Portal_c=oppfin.Tuition_Fees_Balance_Due__c;
                Net_Amount_Due_c=oppfin.Net_Amount_Due__c;
                Total_Tuition_Amount_c=oppfin.Total_Tuition_Amount__c;
                Course_Deposit_Amount_c=oppfin.Course_Deposit_Amount__c;
                Payment_Amount_1st_c=oppfin.Payment_Amount_1st__c;
                Payment_Amount_2nd_c=oppfin.Payment_Amount_2nd__c;
                Payment_Due_Date_1st_c=oppfin.Payment_Due_Date_1st__c;
                Payment_Due_Date_2nd_c=oppfin.Payment_Due_Date_2nd__c;                
                I_agree_to_Hult_Terms_and_Conditions_c=oppfin.I_agree_to_Hult_Terms_and_Conditions__c;
                Total_Tuition_Amount_c=oppfin.Total_Tuition_Amount__c;
                Scholarship_Amount_c=oppfin.Scholarship_Amount__c;
                Go_Ed_Loan_Amount_c=oppfin.Go_Ed_Loan_Amount__c;
                Dubai_Housing_Bursary_Amount_c=string.valueof(oppfin.Dubai_Housing_Bursary_Amount__c);
                Early_Bird_Scholarship_Amount_c=oppfin.Early_Bird_Scholarship_Amount__c;
                Bertil_Hult_Scholarship_Amount_c=string.valueof(oppfin.Bertil_Hult_Scholarship_Amount__c);
                Relocation_Scholarship_Amount_c=string.valueof(oppfin.Relocation_Scholarship_Amount__c);
                Go_Ed_MEFA_Replacement_Loan_Amount_c=string.valueof(oppfin.Go_Ed_MEFA_Replacement_Loan_Amount__c);
                Campus_Financial_Aid_I_FS_c=oppfin.Campus_Financial_Aid_I__c;
                Campus_Financial_Aid_II_FS_c=oppfin.Campus_Financial_Aid_II__c;
                Total_Financial_Aid_Amount_c=oppfin.Total_Financial_Aid_Amount__c;
                CurrencyIsoCode = oppfin.CurrencyIsoCode;
                PrimaryCampus=oppfin.OP_Campus__c;
                Student_Resources_Activities_c = oppfin.Student_Resources_Activities__c;
                Toolbox_Case_Study_Pack_c = oppfin.Toolbox_Case_Study_Pack__c;
                Erika_Insurance_Price_c = oppfin.Erika_Insurance_Price__c;
                Insurance_Fee_c = oppfin.Insurance_Fee__c;            
                Visa_Fee_c = oppfin.Visa_Fee__c;
                Specialization_Fee_FS_new_c = oppfin.Specialization_Fee_preFS__c;
                IEBA_IEMS_Program_Fee_FS_c = oppfin.Partner_Program_Fee__c;
                Partner_Program_Insurance_Fee_FS_c = oppfin.Partner_Program_Insurance_Fee__c;
                Installment_Plan_Fee_FS_c = oppfin.Installment_Plan_Fee__c;
                Insurance_Company_FS_c = oppfin.Insurance_Provider__c;
                Total_Fees_Due_FS_c = oppfin.Total_Fees_Due_FS__c;
                Insurance_Type_FS_c = oppfin.Insurance__c;
                Deposit_Amount_Due_FS_c = oppfin.Deposit_Amount_Due_FS__c;
                Dean_Scholarship_Amount_FS_c = oppfin.Dean_Scholarship_Amount__c;
                Bertil_Hult_Scholarship_Amount_FS_c = oppfin.Bertil_Hult_Scholarship_Amount__c ;
                Relocation_Scholarship_Amount_FS_c = oppfin.Relocation_Scholarship_Amount__c;
                Total_Financial_Aid_FS_c = oppfin.Total_Financial_Aid__c;
                Total_Balance_Due_FS_c = oppfin.Total_Balance_Due_FS__c;
                Early_Bird_Scholarship_Amount_FS_c = oppfin.Early_Bird_Scholarship_Amount__c;
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
                Core_tuition_page2_c=oppfin.Total_Tuition_Amount__c*0.6;//Core_tuition_page2__c
                Core_tuition_page3_c=oppfin.Total_Tuition_Amount__c*0.4;//Core_tuition_page3__c
                Fin_Aid_Hotel_and_Flight_c=oppfin.Fin_Aid_Hotel_and_Flight__c;
                Total_Scholarships_c=oppfin.Total_Scholarships__c; 
              
                Rotation_Finance_c=oppfin.Rotation_Finance__c;
                Hult_Financial_Aid_Amount_c=oppfin.Hult_Financial_Aid_Amount__c;
                
                /*
                    shs : 8/8/2012
                */               
                if(islondon)
                {
                    Total_Tuition_Amount_p2_c=Total_Tuition_Amount_c==null?0:Core_tuition_page2_c;
                    Specialization_Fee_FS_new_p22_c=Specialization_Fee_FS_new_c==null?0:Specialization_Fee_FS_new_c*0.6;
                    //IEBA_IEMS_Program_Fee_FS_p23_c=IEBA_IEMS_Program_Fee_FS_c==null?0:IEBA_IEMS_Program_Fee_FS_c/2; 
                    Total_tution_fee_p1_c=Specialization_Fee_FS_new_p22_c+Total_Tuition_Amount_p2_c+
                                            (Housing_Fee_FS_c==null?0:Housing_Fee_FS_c)+
                                            (Accommodation_Depositx_c==null?0:Accommodation_Depositx_c);
                    
                    /*Scholar Ship Section for Second Page*/
                     Scholarship_Amount_FS_p22_c=Scholarship_Amount_FS_c==null?0:Scholarship_Amount_FS_c*0.6;
                     Dean_Scholarship_Amount_FS_p22_c=Dean_Scholarship_Amount_FS_c==null?0:Dean_Scholarship_Amount_FS_c*0.6;
                     Total_Scholarships_p22_c=Scholarship_Amount_FS_p22_c+Dean_Scholarship_Amount_FS_p22_c;
                    
                    /*Scholar Ship Section for Third Page*/
                     Scholarship_Amount_FS_p23_c=Scholarship_Amount_FS_c==null?0:Scholarship_Amount_FS_c*0.4;
                     Dean_Scholarship_Amount_FS_p23_c=Dean_Scholarship_Amount_FS_c==null?0:Dean_Scholarship_Amount_FS_c*0.4;
                     Total_Scholarships_p23_c=Scholarship_Amount_FS_p23_c+Dean_Scholarship_Amount_FS_p23_c;
                     
                     /*Finacial Aid Section for Second Page*/
                     Hult_Financial_Aid_Amount_p22_c=Hult_Financial_Aid_Amount_c==null?0:Hult_Financial_Aid_Amount_c*0.6;
                     Go_Ed_Loan_Amount_FS_p22_c=Go_Ed_Loan_Amount_FS_c==null?0:Go_Ed_Loan_Amount_FS_c*0.6;
                     Bertil_Hult_Scholarship_Amount_FS_p22_c=Bertil_Hult_Scholarship_Amount_FS_c==null?0:Bertil_Hult_Scholarship_Amount_FS_c*0.6;
                     Relocation_Scholarship_Amount_FS_p22_c=Relocation_Scholarship_Amount_FS_c==null?0:Relocation_Scholarship_Amount_FS_c*0.6;
                     Adjustment_Amount_p22_c=Adjustment_Amount_c==null?0:Adjustment_Amount_c*0.6;
                     Private_Financing_p22_c= Private_Financing_c==null?0: Private_Financing_c*0.6;
                     US_Federal_Financing_Stafford_p22_c=US_Federal_Financing_Stafford_c==null?0:US_Federal_Financing_Stafford_c*0.6;
                     US_Federal_Financing_Grad_Plus_p22_c=US_Federal_Financing_Grad_Plus_c==null?0:US_Federal_Financing_Grad_Plus_c*0.6;
                     US_Federal_Financing_Parent_Plus_p22_c=US_Federal_Financing_Parent_Plus_c==null?0:US_Federal_Financing_Parent_Plus_c*0.6;
                     US_Federal_Financing_Pell_p22_c=US_Federal_Financing_Pell_c==null?0:US_Federal_Financing_Pell_c*0.6;
                     Hult_India_Financial_Aid_p22_c=Hult_India_Financial_Aid_c==null?0:Hult_India_Financial_Aid_c*0.6;
                     Campus_Financial_Aid_I_FS_p22_c=Campus_Financial_Aid_I_FS_c==null?0:Campus_Financial_Aid_I_FS_c*0.6;
                     Campus_Financial_Aid_II_FS_p22_c=Campus_Financial_Aid_II_FS_c==null?0:Campus_Financial_Aid_II_FS_c*0.6;   
                     Fin_Aid_Hotel_and_Flight22_c=Fin_Aid_Hotel_and_Flight_c==null?0:Fin_Aid_Hotel_and_Flight_c*0.6;                  
                  
                   /* Total Financial Aid calculation for Second page*/
                    Total_Financial_Aid_Amount_p2_c=Hult_Financial_Aid_Amount_p22_c+Go_Ed_Loan_Amount_FS_p22_c+Bertil_Hult_Scholarship_Amount_FS_p22_c+
                                                    Relocation_Scholarship_Amount_FS_p22_c+Adjustment_Amount_p22_c+ Private_Financing_p22_c+US_Federal_Financing_Stafford_p22_c+
                                                    US_Federal_Financing_Grad_Plus_p22_c+US_Federal_Financing_Parent_Plus_p22_c+US_Federal_Financing_Pell_p22_c+Hult_India_Financial_Aid_p22_c+
                                                    Campus_Financial_Aid_I_FS_p22_c+Campus_Financial_Aid_II_FS_p22_c+Fin_Aid_Hotel_and_Flight22_c;
                     
                    Total_Tuition_Amount_p23_c=Total_Tuition_Amount_c==null?0:Core_tuition_page3_c;  //(Total_Tuition_c/2)
                    Specialization_Fee_FS_new_p23_c=Specialization_Fee_FS_new_c==null?0:Specialization_Fee_FS_new_c*0.4;
                    IEBA_IEMS_Program_Fee_FS_p23_c=IEBA_IEMS_Program_Fee_FS_c==null?0:IEBA_IEMS_Program_Fee_FS_c;//previous it was IEBA_IEMS_Program_Fee_FS_c/2 removed /2 
                    Total_tution_fee_p2_c=IEBA_IEMS_Program_Fee_FS_p23_c+Specialization_Fee_FS_new_p23_c+Total_Tuition_Amount_p23_c;
                    
                    Total_tution_fee_p3_c=Total_tution_fee_p2_c+(Installment_Plan_Fee_FS_c==null?0:Installment_Plan_Fee_FS_c)+
                                            (Partner_Program_Insurance_Fee_FS_c==null?0:Partner_Program_Insurance_Fee_FS_c)+
                                            (Insurance_Fee_c==null?0:Insurance_Fee_c)+(Visa_Fee_c==null?0:Visa_Fee_c);
                                            
                    /*shs : page3 added rotation fee- sum of rotation items*/                        
                         
                    Total_tution_fee_p3_c=Total_tution_fee_p3_c+(Rotation_Finance_c==null?0:Rotation_Finance_c)+(Rotation_6_Fee_c==null?0:Rotation_6_Fee_c)+ 
                                            (Rotation_5_Fee_c==null?0:Rotation_5_Fee_c)+(Rotation_4_Fee_c==null?0:Rotation_4_Fee_c)+ (Rotation_3_Fee_c==null?0:Rotation_3_Fee_c)+ 
                                            (Rotation_2_Fee_c==null?0:Rotation_2_Fee_c)+ (Rotation_1_Fee_c==null?0:Rotation_1_Fee_c);                      
                   /*end sum rotation fee*/                        
                   
                    
                    /*Finacial Aid Section for third Page*/
                    Hult_Financial_Aid_Amount_p23_c=Hult_Financial_Aid_Amount_c==null?0:Hult_Financial_Aid_Amount_c*0.4;
                    Go_Ed_Loan_Amount_FS_p23_c=Go_Ed_Loan_Amount_FS_c==null?0:Go_Ed_Loan_Amount_FS_c*0.4;
                    Bertil_Hult_Scholarship_Amount_FS_p23_c=Bertil_Hult_Scholarship_Amount_FS_c==null?0:Bertil_Hult_Scholarship_Amount_FS_c*0.4;
                    Relocation_Scholarship_Amount_FS_p23_c=Relocation_Scholarship_Amount_FS_c==null?0:Relocation_Scholarship_Amount_FS_c*0.4;
                    Adjustment_Amount_p23_c=Adjustment_Amount_c==null?0:Adjustment_Amount_c*0.4;
                    Private_Financing_p23_c= Private_Financing_c==null?0: Private_Financing_c*0.4;
                    US_Federal_Financing_Stafford_p23_c=US_Federal_Financing_Stafford_c==null?0:US_Federal_Financing_Stafford_c*0.4;
                    US_Federal_Financing_Grad_Plus_p23_c=US_Federal_Financing_Grad_Plus_c==null?0:US_Federal_Financing_Grad_Plus_c*0.4;                    
                    US_Federal_Financing_Parent_Plus_p23_c=US_Federal_Financing_Parent_Plus_c==null?0:US_Federal_Financing_Parent_Plus_c*0.4;
                    US_Federal_Financing_Pell_p23_c=US_Federal_Financing_Pell_c==null?0:US_Federal_Financing_Pell_c*0.4;
                    Hult_India_Financial_Aid_p23_c=Hult_India_Financial_Aid_c==null?0:Hult_India_Financial_Aid_c*0.4;
                    Campus_Financial_Aid_I_FS_p23_c=Campus_Financial_Aid_I_FS_c==null?0:Campus_Financial_Aid_I_FS_c*0.4;
                    Campus_Financial_Aid_II_FS_p23_c=Campus_Financial_Aid_II_FS_c==null?0:Campus_Financial_Aid_II_FS_c*0.4;
                    Fin_Aid_Hotel_and_Flight23_c=Fin_Aid_Hotel_and_Flight_c==null?0:Fin_Aid_Hotel_and_Flight_c*0.4;
                   
                   /* Total Financial Aid calculation for third page*/
                    Total_Financial_Aid_Amount_p3_c=Hult_Financial_Aid_Amount_p23_c+Go_Ed_Loan_Amount_FS_p23_c+Bertil_Hult_Scholarship_Amount_FS_p23_c+
                                                    Relocation_Scholarship_Amount_FS_p23_c+Adjustment_Amount_p23_c+ Private_Financing_p23_c+US_Federal_Financing_Stafford_p23_c+
                                                    US_Federal_Financing_Grad_Plus_p23_c+US_Federal_Financing_Parent_Plus_p23_c+US_Federal_Financing_Pell_p23_c+Hult_India_Financial_Aid_p23_c+
                                                    Campus_Financial_Aid_I_FS_p23_c+Campus_Financial_Aid_II_FS_p23_c+Fin_Aid_Hotel_and_Flight23_c;

                    Total_Balance_Due_FS_p2_c=Total_tution_fee_p1_c-Total_Financial_Aid_Amount_p2_c-Total_Scholarships_p22_c;
                    Total_Balance_Due_FS_p3_c=Total_tution_fee_p3_c-Total_Financial_Aid_Amount_p3_c-Total_Scholarships_p23_c; 
                    
                }
                
                if(oppfin.Unlock_Student_Financial_Information__c){
                    Unlock_Student_Financial_Information_c =true;
                }
                Else if(type=='draft'){
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
            
           
            
               
        }
        
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
        
        public List<Fin_Statement_3page_ctrlr.WrapObj>  getfTransactionList(){
            //List<Finance_Transactions__c> sList = [select Transaction_Type__c,Amount_Received__c, CurrencyIsoCode,Transaction_Date_Time__c from Finance_Transactions__c where Finance__r.Opportunity__c=: opp.id and Transaction_Type__c!='Application Fee' and Transaction_Status__c='Success'];
            List<Finance_Transactions__c> sList = [select createddate, Transaction_Type__c,Amount_Received__c, CurrencyIsoCode,Transaction_Date_Time__c from Finance_Transactions__c where Finance__r.Opportunity__c=: opp.id and (Transaction_Status__c='Success' or Transaction_Status__c='Manually Processed') and Transaction_Type__c!='Application Fee' order by createddate desc];
            System.debug('------>>>'+slist);
            List<Fin_Statement_3page_ctrlr.WrapObj> wrapList = new List<Fin_Statement_3page_ctrlr.WrapObj>();
            for(Finance_Transactions__c f : sList){
                wrapList.add(new Fin_Statement_3page_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
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
         //   getData ='?external_unique_id='+ft+'&cu_id_number='+opp.App_ID__c+'&first_name='+con.firstname+'&last_name='+con.lastname+'&__date_of_birth_day='+setnumber(string.valueof(con.Birthdate.day()))+'&__date_of_birth_month='+setnumber(string.valueof(con.Birthdate.month()))+'&__date_of_birth_year='+con.Birthdate.year()+'&email='+con.email+'&suburban_city='+Con.Mailingcity+'&country='+Con.Mailing_Country__r.Country_Code_for_PaytoStudy__c+'&home_address='+EncodingUtil.urlEncode(Con.MailingStreet+'\n'+Con.mailingpostalcode+'\n'+con.Mailingstate, 'UTF-8')+'&__home_phone_number_international_dialing_code='+con.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+con.Mailing_Country__r.Calling_Code__c+'&__home_phone_number_mobile_phone='+Con.Mobile_Phone_Main_Number__c+'&__mobile_number_international_dialing_code='+Con.Mailing_Country__r.Country_Code__c.toLowerCase()+' '+Con.Mailing_Country__r.Calling_Code__c+'&__mobile_number_mobile_phone='+Con.Home_Phone_Main_Number__c+'&__tuition_fees_price='+paytostudyAmount;
          getData ='?external_unique_id='+ft+'&cu_id_number='+opp.App_ID__c;
        }
        
        if(Con.Salutation!=null){
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
            getData+='&__date_of_birth_day='+setnumber(string.valueof(Con.Birthdate.day()))+'&__date_of_birth_month='+setnumber(string.valueof(Con.Birthdate.month()))+'&__date_of_birth_year='+Con.Birthdate.year();
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
}