/*
    Developer : Premanath Reddy
    Date      : 31/10/2014                
    purpose   : This class for BBA Finance PDF Buttons those are PDF-Yr1,PDF-Yr2,PDF-Yr3,PDF-Yr4,PDF-Yr5 and Draft PDF - Yr1.
              
    Test class: TestForFin_Statement_3page_ctrlr
    coverage  : 96%
    
    Modified  : Prem (4/2/2015) Added Accommodation Deposit (Year 2 / Year 3 / Year 4)
    Modified  : Prem (12/2/2015) SFSUP-970 - Added Pre-University Fee field into Invoice PDF year 1
*/
public class Fin_Statement_bba_ctrlr {
    public User user{get;set;} 
    public Opportunity opp{get;set;}
    public Contact con{get;set;}
    public Requirement__c req{get;set;}
    Public boolean I_agree_to_Hult_Terms_and_Conditions_c{get;set;}
    public String Program_c{get;set;}
    public String stage{get;set;}
    public string id{get;set;}
    public boolean Unlock_Student_Financial_Information_c{get;set;}
    public string App_ID_c{get;set;}
    public Opportunity_Finance__c oppfin{get;set;}
    public String Primary_Program_Choice_c{get;set;}
    public string ccode{get;set;}
    public boolean Lock_Installment_Plan_c{get;set;}
    Public string nomap{get;set;}
    public boolean islondon{get;set;}
    public string CurrencyIsoCode{get;set;}
    public string PrimaryCampus{get;set;}
    public string type{get;set;}
    public string buttn_name{get;set;}
    public boolean year1_bool{get;set;}
    public boolean year2_bool{get;set;}
    public boolean year3_bool{get;set;}
    public boolean year4_bool{get;set;}
    public boolean year5_bool{get;set;}
    public date DatePrinted = date.today();
    public date getDatePrinted(){
        return DatePrinted;
    }
    Public double Payment_Amount_1st_c{get;set;}
    Public double Payment_Amount_2nd_c{get;set;}
    public double Payment_Amount_3rd_c{get;set;}
    public double Payment_Amount_4th_c{get;set;}
    public double Payment_Amount_5th_c{get;set;}
    public double Payment_Amount_6th_c{get;set;}
    public double Payment_Amount_7th_c{get;set;}
    public double Payment_Amount_8th_c{get;set;}
    Public Date Payment_Due_Date_1st_c{get;set;}
    Public Date Payment_Due_Date_2nd_c{get;set;}
    public date Payment_Due_Date_3rd_c{get;set;}
    public date Payment_Due_Date_4th_c{get;set;}
    public date Payment_Due_Date_5th_c{get;set;}
    public date Payment_Due_Date_6th_c{get;set;}
    public date Payment_Due_Date_7th_c{get;set;}
    public date Payment_Due_Date_8th_c{get;set;}
    
    Public double BBA_Program_Fee_c{get;set;}
    Public double BBA_Pre_University_Fee_c{get;set;}
    Public double BBA_Accommodation_Fee_c{get;set;}
    Public double BBA_Accommodation_Deposit_c{get;set;}
    Public double BBA_Insurance_c{get;set;}
    Public double BBA_Installment_Plan_c{get;set;}
    Public double BBA_Extra_Credits_Charged_c{get;set;}
    Public double BBA_Scholarship_Financial_Aid_c{get;set;}
    Public double BBA_Dean_Financial_Aid_c{get;set;}
    public double BBA_GoEd_Loan_c{get;set;}
    public String Go_Ed_Loan_Note_c{get;set;}
    Public double BBA_Adjustment_Amount_BBA_c{get;set;}
    Public double BBA_US_Federal_Direct_Loan_c{get;set;}
    Public double BBA_Private_Financing_c{get;set;}
    Public double BBA_US_Federal_Parent_Plus_c{get;set;}
    Public double BBA_US_Federal_Pell_c{get;set;}
    Public double BBA_tot_program_fee_c{get;set;}
    Public double BBA_tot_scholarship_c{get;set;}
    Public double BBA_total_Balance_Due_c{get;set;}
    Public double BBA_current_Balance_Due_c{get;set;}
    //for London Page 2
    Public double BBA_Program_Fee2_c{get;set;}
    Public double BBA_Pre_University_Fee2_c{get;set;}
    Public double BBA_Accommodation_Fee2_c{get;set;}
    Public double BBA_Accommodation_Deposit2_c{get;set;}
    Public double BBA_Insurance2_c{get;set;}
    Public double BBA_Installment_Plan2_c{get;set;}
    Public double BBA_Extra_Credits_Charged2_c{get;set;}
    Public double BBA_Scholarship_Financial_Aid2_c{get;set;}
    Public double BBA_Dean_Financial_Aid2_c{get;set;}
    public double BBA_GoEd_Loan2_c{get;set;}
    Public double BBA_Adjustment_Amount2_BBA_c{get;set;}
    Public double BBA_US_Federal_Direct_Loan2_c{get;set;}
    Public double BBA_Private_Financing2_c{get;set;}
    Public double BBA_US_Federal_Parent_Plus2_c{get;set;}
    Public double BBA_US_Federal_Pell2_c{get;set;}
    Public double BBA_tot_program_fee2_c{get;set;}
    Public double BBA_tot_scholarship2_c{get;set;}
    Public double BBA_total_Balance_Due2_c{get;set;}
    //for London Page 3
    Public double BBA_Program_Fee3_c{get;set;}
    Public double BBA_Pre_University_Fee3_c{get;set;}
    Public double BBA_Accommodation_Fee3_c{get;set;}
    Public double BBA_Accommodation_Deposit3_c{get;set;}
    Public double BBA_Insurance3_c{get;set;}
    Public double BBA_Installment_Plan3_c{get;set;}
    Public double BBA_Extra_Credits_Charged3_c{get;set;}
    Public double BBA_Scholarship_Financial_Aid3_c{get;set;}
    Public double BBA_Dean_Financial_Aid3_c{get;set;}
    public double BBA_GoEd_Loan3_c{get;set;}
    Public double BBA_Adjustment_Amount3_BBA_c{get;set;}
    Public double BBA_US_Federal_Direct_Loan3_c{get;set;}
    Public double BBA_Private_Financing3_c{get;set;}
    Public double BBA_US_Federal_Parent_Plus3_c{get;set;}
    Public double BBA_US_Federal_Pell3_c{get;set;}
    Public double BBA_tot_program_fee3_c{get;set;}
    Public double BBA_tot_scholarship3_c{get;set;}
    Public double BBA_total_Balance_Due3_c{get;set;}
    
    //Rotation
    public Double Rotation_1_Fee_c{get;set;}
    public Double Rotation_2_Fee_c{get;set;}
    public Double Rotation_3_Fee_c{get;set;}
    public Double Rotation_4_Fee_c{get;set;}
    public Double Rotation_5_Fee_c{get;set;}
    public Double Rotation_6_Fee_c{get;set;}
    public Double Total_Rotation_Fees_Due_c{get;set;}
    public Double BBA_Total_Rotation_Fees_c{get;set;}
    public Double BBA_Total_Rotation_Fees2_c{get;set;}
    public Double BBA_Total_Rotation_Fees3_c{get;set;}
    
    Public double Rotation_Finance_c{get;set;}
    public string Rot_Housing_Module_D_c{get;set;}
    public string Rot_Visa_Module_D_c{get;set;}
    public string Rot_Insurance_Module_D_c{get;set;}
    public string Rot_Housing_Module_E_c{get;set;}
    public string Rot_Visa_Module_E_c{get;set;}
    public string Rot_Insurance_Module_E_c{get;set;}
    
    public Fin_Statement_bba_ctrlr(){
        try{
            islondon=false;
            Lock_Installment_Plan_c=false;
            nomap='No Map';
            type=System.currentPagereference().getParameters().get('type');
            buttn_name=System.currentPagereference().getParameters().get('buttn');
            if(System.currentPagereference().getParameters().get('contactid')!=null){
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
            opp=[select Primary_Program_Choice__c, PaytoStudy_Registration__c, Primary_Campus__c, program__r.CurrencyIsoCode,CloseDate,           
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
                    BBA_Unlock_Student_Financial_Information__c,
                    Unlock_Student_Financial_Information__c,
                    Accommodation_Depositx__c,
                    BBA_Pre_University_Fee_Year_1__c,
                    CurrencyIsoCode, 
                    OP_Campus__c, 
                    Payment_Amount_1st__c,
                    Payment_Amount_2nd__c,
                    Payment_Amount_3rd__c,
                    Payment_Amount_4th__c,
                    Payment_Amount_5th__c,
                    Payment_Amount_6th__c,
                    Payment_Amount_7th__c,
                    Payment_Amount_8th__c,
                    Payment_Due_Date_1st__c,
                    Payment_Due_Date_2nd__c,
                    Payment_Due_Date_3rd__c,
                    Payment_Due_Date_4th__c,
                    Payment_Due_Date_5th__c,
                    Payment_Due_Date_6th__c,
                    Payment_Due_Date_7th__c,
                    Payment_Due_Date_8th__c,
                    BBA_Program_Fee_Year_1__c,
                    BBA_Program_Fee_Year_2__c,
                    BBA_Program_Fee_Year_3__c,
                    BBA_Program_Fee_Year_4__c,
                    BBA_Accommodation_Fee_Year_1__c,
                    BBA_Accommodation_Fee_Year_2__c,
                    BBA_Accommodation_Fee_Year_3__c,
                    BBA_Accommodation_Fee_Year_4__c,
                    BBA_Accommodation_Deposit__c,
                    BBA_Accommodation_Deposit_Year_2__c,
                    BBA_Accommodation_Deposit_Year_3__c,
                    BBA_Accommodation_Deposit_Year_4__c,
                    BBA_Insurance_Year_1__c,
                    BBA_Insurance_Year_2__c,
                    BBA_Insurance_Year_3__c,
                    BBA_Insurance_Year_4__c,
                    BBA_Installment_Plan_Year_1__c,
                    BBA_Installment_Plan_Year_2__c,
                    BBA_Installment_Plan_Year_3__c,
                    BBA_Installment_Plan_Year_4__c,
                    BBA_Extra_Credits_Charged_Year_1__c,
                    BBA_Extra_Credits_Charged_Year_2__c,
                    BBA_Extra_Credits_Charged_Year_3__c,
                    BBA_Extra_Credits_Charged_Year_4__c,
                    BBA_Extra_Credits_Charged_Year_5__c,
                    BBA_Scholarship_Financial_Aid_Year_1__c,
                    BBA_Scholarship_Financial_Aid_Year_2__c,
                    BBA_Scholarship_Financial_Aid_Year_3__c,
                    BBA_Scholarship_Financial_Aid_Year_4__c,
                    BBA_Scholarship_Percent__c,
                    BBA_Dean_Financial_Aid_Year_1__c,
                    BBA_Dean_Financial_Aid_Year_2__c,
                    BBA_Dean_Financial_Aid_Year_3__c,
                    BBA_Dean_Financial_Aid_Year_4__c,
                    BBA_Adjustment_Amount_Year_1_BBA__c,
                    BBA_Adjustment_Amount_Year_2_BBA__c,
                    BBA_Adjustment_Amount_Year_3_BBA__c,
                    BBA_Adjustment_Amount_Year_4_BBA__c,
                    BBA_US_Federal_Direct_Loan_Year_1__c,
                    BBA_US_Federal_Direct_Loan_Year_2__c,
                    BBA_US_Federal_Direct_Loan_Year_3__c,
                    BBA_US_Federal_Direct_Loan_Year_4__c,
                    BBA_US_Federal_Parent_Plus_Year_1__c,
                    BBA_US_Federal_Parent_Plus_Year_2__c,
                    BBA_US_Federal_Parent_Plus_Year_3__c,
                    BBA_US_Federal_Parent_Plus_Year_4__c,
                    BBA_US_Federal_Pell_Year_1__c,
                    BBA_US_Federal_Pell_Year_2__c,
                    BBA_US_Federal_Pell_Year_3__c,
                    BBA_US_Federal_Pell_Year_4__c,
                    BBA_Private_Financing_Year_1__c,
                    BBA_Private_Financing_Year_2__c,
                    BBA_Private_Financing_Year_3__c,
                    BBA_Private_Financing_Year_4__c,
                    BBA_GoEd_Loan_Year_1__c,
                    BBA_GoEd_Loan_Year_2__c,
                    BBA_GoEd_Loan_Year_3__c,
                    BBA_GoEd_Loan_Year_4__c,
                    Go_Ed_Loan_Note__c,
                    BBA_Total_Due_Year_1__c,
                    BBA_Total_Due_Year_2__c,
                    BBA_Total_Due_Year_3__c,
                    BBA_Total_Payments_Year_4__c,
                    BBA_Total_Due_Year_5__c,
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
                    Rotation_Finance__c,
                    Total_Rotation_Fees_Due__c,
                    BBA_Total_Rotation_Fees_Year_1__c,
                    BBA_Total_Rotation_Fees_Year_2__c,
                    BBA_Total_Rotation_Fees_Year_3__c,
                    BBA_Total_Rotation_Fees_Year_4__c,
                    I_agree_to_Hult_Terms_and_Conditions__c,Name,Id from Opportunity_Finance__c where Opportunity__c=:opp.id];
                
            CurrencyIsoCode = oppfin.CurrencyIsoCode;
            PrimaryCampus=oppfin.OP_Campus__c;
                
            Payment_Amount_1st_c = oppfin.Payment_Amount_1st__c;
            Payment_Amount_2nd_c = oppfin.Payment_Amount_2nd__c;
            Payment_Amount_3rd_c = oppfin.Payment_Amount_3rd__c;
            Payment_Amount_4th_c = oppfin.Payment_Amount_4th__c;
            Payment_Amount_5th_c = oppfin.Payment_Amount_5th__c;
            Payment_Amount_6th_c = oppfin.Payment_Amount_6th__c;
            Payment_Amount_7th_c = oppfin.Payment_Amount_7th__c;
            Payment_Amount_8th_c = oppfin.Payment_Amount_8th__c;
            Payment_Due_Date_1st_c = oppfin.Payment_Due_Date_1st__c;
            Payment_Due_Date_2nd_c = oppfin.Payment_Due_Date_2nd__c;
            Payment_Due_Date_3rd_c = oppfin.Payment_Due_Date_3rd__c;
            Payment_Due_Date_4th_c = oppfin.Payment_Due_Date_4th__c;
            Payment_Due_Date_5th_c = oppfin.Payment_Due_Date_5th__c;
            Payment_Due_Date_6th_c = oppfin.Payment_Due_Date_6th__c;
            Payment_Due_Date_7th_c = oppfin.Payment_Due_Date_7th__c;
            Payment_Due_Date_8th_c = oppfin.Payment_Due_Date_8th__c; 
            Go_Ed_Loan_Note_c = oppfin.Go_Ed_Loan_Note__c;
            
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
            Total_Rotation_Fees_Due_c=oppfin.Total_Rotation_Fees_Due__c;
            Rotation_Finance_c=oppfin.Rotation_Finance__c;
            
            if(buttn_name=='bba_yr1'){
                BBA_Program_Fee_c = oppfin.BBA_Program_Fee_Year_1__c==null?0:oppfin.BBA_Program_Fee_Year_1__c; 
                BBA_Pre_University_Fee_c= oppfin.BBA_Pre_University_Fee_Year_1__c==null?0:oppfin.BBA_Pre_University_Fee_Year_1__c;
                BBA_Accommodation_Fee_c = oppfin.BBA_Accommodation_Fee_Year_1__c==null?0:oppfin.BBA_Accommodation_Fee_Year_1__c;
                BBA_Accommodation_Deposit_c = oppfin.BBA_Accommodation_Deposit__c==null?0:oppfin.BBA_Accommodation_Deposit__c;
                BBA_Insurance_c = oppfin.BBA_Insurance_Year_1__c==null?0:oppfin.BBA_Insurance_Year_1__c;
                BBA_Installment_Plan_c = oppfin.BBA_Installment_Plan_Year_1__c==null?0:oppfin.BBA_Installment_Plan_Year_1__c;
                BBA_Extra_Credits_Charged_c = oppfin.BBA_Extra_Credits_Charged_Year_1__c==null?0:oppfin.BBA_Extra_Credits_Charged_Year_1__c;
                BBA_Scholarship_Financial_Aid_c = oppfin.BBA_Scholarship_Financial_Aid_Year_1__c==null?0:oppfin.BBA_Scholarship_Financial_Aid_Year_1__c;
                BBA_Dean_Financial_Aid_c = oppfin.BBA_Dean_Financial_Aid_Year_1__c==null?0:oppfin.BBA_Dean_Financial_Aid_Year_1__c;
                BBA_GoEd_Loan_c = oppfin.BBA_GoEd_Loan_Year_1__c==null?0:oppfin.BBA_GoEd_Loan_Year_1__c;
                BBA_Adjustment_Amount_BBA_c = oppfin.BBA_Adjustment_Amount_Year_1_BBA__c==null?0:oppfin.BBA_Adjustment_Amount_Year_1_BBA__c;
                BBA_US_Federal_Direct_Loan_c = oppfin.BBA_US_Federal_Direct_Loan_Year_1__c==null?0:oppfin.BBA_US_Federal_Direct_Loan_Year_1__c;
                BBA_Private_Financing_c = oppfin.BBA_Private_Financing_Year_1__c==null?0:oppfin.BBA_Private_Financing_Year_1__c;
                BBA_US_Federal_Parent_Plus_c = oppfin.BBA_US_Federal_Parent_Plus_Year_1__c==null?0:oppfin.BBA_US_Federal_Parent_Plus_Year_1__c;
                BBA_US_Federal_Pell_c = oppfin.BBA_US_Federal_Pell_Year_1__c==null?0:oppfin.BBA_US_Federal_Pell_Year_1__c;
                BBA_Total_Rotation_Fees_c=oppfin.BBA_Total_Rotation_Fees_Year_1__c==null?0:oppfin.BBA_Total_Rotation_Fees_Year_1__c;
    
                BBA_tot_program_fee_c=BBA_Program_Fee_c+BBA_Pre_University_Fee_c+BBA_Accommodation_Fee_c+BBA_Accommodation_Deposit_c+BBA_Insurance_c+BBA_Installment_Plan_c+BBA_Extra_Credits_Charged_c
                                    +Total_Rotation_Fees_Due_c+BBA_Total_Rotation_Fees_c;
                BBA_tot_scholarship_c=BBA_Scholarship_Financial_Aid_c+BBA_Dean_Financial_Aid_c+BBA_Adjustment_Amount_BBA_c+BBA_US_Federal_Direct_Loan_c
                                            +BBA_Private_Financing_c+BBA_GoEd_Loan_c+BBA_US_Federal_Parent_Plus_c+BBA_US_Federal_Pell_c;
                BBA_total_Balance_Due_c=BBA_tot_program_fee_c-BBA_tot_scholarship_c;
                BBA_current_Balance_Due_c=oppfin.BBA_Total_Due_Year_1__c;
            }
            if(buttn_name=='bba_yr2'){
                BBA_Program_Fee_c = oppfin.BBA_Program_Fee_Year_2__c==null?0:oppfin.BBA_Program_Fee_Year_2__c; 
                BBA_Accommodation_Fee_c = oppfin.BBA_Accommodation_Fee_Year_2__c==null?0:oppfin.BBA_Accommodation_Fee_Year_2__c;
                BBA_Accommodation_Deposit_c = oppfin.BBA_Accommodation_Deposit_Year_2__c==null?0:oppfin.BBA_Accommodation_Deposit_Year_2__c;
                BBA_Insurance_c = oppfin.BBA_Insurance_Year_2__c==null?0:oppfin.BBA_Insurance_Year_2__c;
                BBA_Installment_Plan_c = oppfin.BBA_Installment_Plan_Year_2__c==null?0:oppfin.BBA_Installment_Plan_Year_2__c;
                BBA_Extra_Credits_Charged_c = oppfin.BBA_Extra_Credits_Charged_Year_2__c==null?0:oppfin.BBA_Extra_Credits_Charged_Year_2__c;
                BBA_Scholarship_Financial_Aid_c = oppfin.BBA_Scholarship_Financial_Aid_Year_2__c==null?0:oppfin.BBA_Scholarship_Financial_Aid_Year_2__c;
                BBA_Dean_Financial_Aid_c = oppfin.BBA_Dean_Financial_Aid_Year_2__c==null?0:oppfin.BBA_Dean_Financial_Aid_Year_2__c;
                BBA_GoEd_Loan_c = oppfin.BBA_GoEd_Loan_Year_2__c==null?0:oppfin.BBA_GoEd_Loan_Year_2__c;
                BBA_Adjustment_Amount_BBA_c = oppfin.BBA_Adjustment_Amount_Year_2_BBA__c==null?0:oppfin.BBA_Adjustment_Amount_Year_2_BBA__c;
                BBA_US_Federal_Direct_Loan_c = oppfin.BBA_US_Federal_Direct_Loan_Year_2__c==null?0:oppfin.BBA_US_Federal_Direct_Loan_Year_2__c;
                BBA_Private_Financing_c = oppfin.BBA_Private_Financing_Year_2__c==null?0:oppfin.BBA_Private_Financing_Year_2__c;
                BBA_US_Federal_Parent_Plus_c = oppfin.BBA_US_Federal_Parent_Plus_Year_2__c==null?0:oppfin.BBA_US_Federal_Parent_Plus_Year_2__c;
                BBA_US_Federal_Pell_c = oppfin.BBA_US_Federal_Pell_Year_2__c==null?0:oppfin.BBA_US_Federal_Pell_Year_2__c;
                BBA_Total_Rotation_Fees_c=oppfin.BBA_Total_Rotation_Fees_Year_2__c==null?0:oppfin.BBA_Total_Rotation_Fees_Year_2__c;
    
                BBA_tot_program_fee_c=BBA_Program_Fee_c+BBA_Accommodation_Fee_c+BBA_Accommodation_Deposit_c+BBA_Insurance_c+BBA_Installment_Plan_c
                                    +BBA_Extra_Credits_Charged_c+Total_Rotation_Fees_Due_c+BBA_Total_Rotation_Fees_c;
                BBA_tot_scholarship_c=BBA_Scholarship_Financial_Aid_c+BBA_Dean_Financial_Aid_c+BBA_Adjustment_Amount_BBA_c+BBA_US_Federal_Direct_Loan_c
                                            +BBA_Private_Financing_c+BBA_GoEd_Loan_c+BBA_US_Federal_Parent_Plus_c+BBA_US_Federal_Pell_c;
                BBA_total_Balance_Due_c=BBA_tot_program_fee_c-BBA_tot_scholarship_c;
                BBA_current_Balance_Due_c=oppfin.BBA_Total_Due_Year_2__c;
            }
            if(buttn_name=='bba_yr3'){
                BBA_Program_Fee_c = oppfin.BBA_Program_Fee_Year_3__c==null?0:oppfin.BBA_Program_Fee_Year_3__c; 
                BBA_Accommodation_Fee_c = oppfin.BBA_Accommodation_Fee_Year_3__c==null?0:oppfin.BBA_Accommodation_Fee_Year_3__c;
                BBA_Accommodation_Deposit_c = oppfin.BBA_Accommodation_Deposit_Year_3__c==null?0:oppfin.BBA_Accommodation_Deposit_Year_3__c;
                BBA_Insurance_c = oppfin.BBA_Insurance_Year_3__c==null?0:oppfin.BBA_Insurance_Year_3__c;
                BBA_Installment_Plan_c = oppfin.BBA_Installment_Plan_Year_3__c==null?0:oppfin.BBA_Installment_Plan_Year_3__c;
                BBA_Extra_Credits_Charged_c = oppfin.BBA_Extra_Credits_Charged_Year_3__c==null?0:oppfin.BBA_Extra_Credits_Charged_Year_3__c;
                BBA_Scholarship_Financial_Aid_c = oppfin.BBA_Scholarship_Financial_Aid_Year_3__c==null?0:oppfin.BBA_Scholarship_Financial_Aid_Year_3__c;
                BBA_Dean_Financial_Aid_c = oppfin.BBA_Dean_Financial_Aid_Year_3__c==null?0:oppfin.BBA_Dean_Financial_Aid_Year_3__c;
                BBA_GoEd_Loan_c = oppfin.BBA_GoEd_Loan_Year_3__c==null?0:oppfin.BBA_GoEd_Loan_Year_3__c;
                BBA_Adjustment_Amount_BBA_c = oppfin.BBA_Adjustment_Amount_Year_3_BBA__c==null?0:oppfin.BBA_Adjustment_Amount_Year_3_BBA__c;
                BBA_US_Federal_Direct_Loan_c = oppfin.BBA_US_Federal_Direct_Loan_Year_3__c==null?0:oppfin.BBA_US_Federal_Direct_Loan_Year_3__c;
                BBA_Private_Financing_c = oppfin.BBA_Private_Financing_Year_3__c==null?0:oppfin.BBA_Private_Financing_Year_3__c;
                BBA_US_Federal_Parent_Plus_c = oppfin.BBA_US_Federal_Parent_Plus_Year_3__c==null?0:oppfin.BBA_US_Federal_Parent_Plus_Year_3__c;
                BBA_US_Federal_Pell_c = oppfin.BBA_US_Federal_Pell_Year_3__c==null?0:oppfin.BBA_US_Federal_Pell_Year_3__c;
                BBA_Total_Rotation_Fees_c=oppfin.BBA_Total_Rotation_Fees_Year_3__c==null?0:oppfin.BBA_Total_Rotation_Fees_Year_3__c;
                
                BBA_tot_program_fee_c=BBA_Program_Fee_c+BBA_Accommodation_Fee_c+BBA_Accommodation_Deposit_c+BBA_Insurance_c+BBA_Installment_Plan_c
                                    +BBA_Extra_Credits_Charged_c+Total_Rotation_Fees_Due_c+BBA_Total_Rotation_Fees_c;
                BBA_tot_scholarship_c=BBA_Scholarship_Financial_Aid_c+BBA_Dean_Financial_Aid_c+BBA_Adjustment_Amount_BBA_c+BBA_US_Federal_Direct_Loan_c
                                            +BBA_Private_Financing_c+BBA_GoEd_Loan_c+BBA_US_Federal_Parent_Plus_c+BBA_US_Federal_Pell_c;
                BBA_total_Balance_Due_c=BBA_tot_program_fee_c-BBA_tot_scholarship_c;
                BBA_current_Balance_Due_c=oppfin.BBA_Total_Due_Year_3__c;
            }
            if(buttn_name=='bba_yr4'){
                BBA_Program_Fee_c = oppfin.BBA_Program_Fee_Year_4__c==null?0:oppfin.BBA_Program_Fee_Year_4__c;
                BBA_Accommodation_Fee_c = oppfin.BBA_Accommodation_Fee_Year_4__c==null?0:oppfin.BBA_Accommodation_Fee_Year_4__c;
                BBA_Accommodation_Deposit_c = oppfin.BBA_Accommodation_Deposit_Year_4__c==null?0:oppfin.BBA_Accommodation_Deposit_Year_4__c;
                BBA_Insurance_c = oppfin.BBA_Insurance_Year_4__c==null?0:oppfin.BBA_Insurance_Year_4__c;
                BBA_Installment_Plan_c = oppfin.BBA_Installment_Plan_Year_4__c==null?0:oppfin.BBA_Installment_Plan_Year_4__c;
                BBA_Extra_Credits_Charged_c = oppfin.BBA_Extra_Credits_Charged_Year_4__c==null?0:oppfin.BBA_Extra_Credits_Charged_Year_4__c;
                BBA_Scholarship_Financial_Aid_c = oppfin.BBA_Scholarship_Financial_Aid_Year_4__c==null?0:oppfin.BBA_Scholarship_Financial_Aid_Year_4__c;
                BBA_Dean_Financial_Aid_c = oppfin.BBA_Dean_Financial_Aid_Year_4__c==null?0:oppfin.BBA_Dean_Financial_Aid_Year_4__c;
                BBA_GoEd_Loan_c = oppfin.BBA_GoEd_Loan_Year_4__c==null?0:oppfin.BBA_GoEd_Loan_Year_4__c;
                BBA_Adjustment_Amount_BBA_c = oppfin.BBA_Adjustment_Amount_Year_4_BBA__c==null?0:oppfin.BBA_Adjustment_Amount_Year_4_BBA__c;
                BBA_US_Federal_Direct_Loan_c = oppfin.BBA_US_Federal_Direct_Loan_Year_4__c==null?0:oppfin.BBA_US_Federal_Direct_Loan_Year_4__c;
                BBA_Private_Financing_c = oppfin.BBA_Private_Financing_Year_4__c==null?0:oppfin.BBA_Private_Financing_Year_4__c;
                BBA_US_Federal_Parent_Plus_c = oppfin.BBA_US_Federal_Parent_Plus_Year_4__c==null?0:oppfin.BBA_US_Federal_Parent_Plus_Year_4__c;
                BBA_US_Federal_Pell_c = oppfin.BBA_US_Federal_Pell_Year_4__c==null?0:oppfin.BBA_US_Federal_Pell_Year_4__c;
                BBA_Total_Rotation_Fees_c=oppfin.BBA_Total_Rotation_Fees_Year_4__c==null?0:oppfin.BBA_Total_Rotation_Fees_Year_4__c;
                
                BBA_tot_program_fee_c=BBA_Program_Fee_c+BBA_Accommodation_Fee_c+BBA_Accommodation_Deposit_c+BBA_Insurance_c+BBA_Installment_Plan_c
                                    +BBA_Extra_Credits_Charged_c+Total_Rotation_Fees_Due_c+BBA_Total_Rotation_Fees_c;
                BBA_tot_scholarship_c=BBA_Scholarship_Financial_Aid_c+BBA_Dean_Financial_Aid_c+BBA_Adjustment_Amount_BBA_c+BBA_US_Federal_Direct_Loan_c
                                            +BBA_Private_Financing_c+BBA_GoEd_Loan_c+BBA_US_Federal_Parent_Plus_c+BBA_US_Federal_Pell_c;
                BBA_total_Balance_Due_c=BBA_tot_program_fee_c-BBA_tot_scholarship_c;
                BBA_current_Balance_Due_c=oppfin.BBA_Total_Payments_Year_4__c;
            }
            if(buttn_name=='bba_yr5'){
                BBA_Extra_Credits_Charged_c = oppfin.BBA_Extra_Credits_Charged_Year_5__c==null?0:oppfin.BBA_Extra_Credits_Charged_Year_5__c;
                BBA_tot_program_fee_c=BBA_Extra_Credits_Charged_c+Total_Rotation_Fees_Due_c;
                BBA_tot_scholarship_c=0;
                BBA_total_Balance_Due_c=BBA_tot_program_fee_c-BBA_tot_scholarship_c;
                BBA_current_Balance_Due_c=oppfin.BBA_Total_Due_Year_5__c;
            }
            
            if(islondon){
                //for London Page 2
                BBA_Program_Fee2_c = BBA_Program_Fee_c==null?0:BBA_Program_Fee_c*0.6;
                BBA_Pre_University_Fee2_c= BBA_Pre_University_Fee_c==null?0:BBA_Pre_University_Fee_c*0.6;
                BBA_Accommodation_Fee2_c = BBA_Accommodation_Fee_c==null?0:BBA_Accommodation_Fee_c;
                BBA_Accommodation_Deposit2_c = BBA_Accommodation_Deposit_c==null?0:BBA_Accommodation_Deposit_c;
                BBA_Insurance2_c = BBA_Insurance_c==null?0:BBA_Insurance_c*0;
                BBA_Installment_Plan2_c = BBA_Installment_Plan_c==null?0:BBA_Installment_Plan_c*0;
                BBA_Extra_Credits_Charged2_c = BBA_Extra_Credits_Charged_c==null?0:BBA_Extra_Credits_Charged_c*0.6;
                BBA_Scholarship_Financial_Aid2_c = BBA_Scholarship_Financial_Aid_c==null?0:BBA_Scholarship_Financial_Aid_c*0.6;
                BBA_Dean_Financial_Aid2_c = BBA_Dean_Financial_Aid_c==null?0:BBA_Dean_Financial_Aid_c*0.6;
                BBA_GoEd_Loan2_c = BBA_GoEd_Loan_c==null?0:BBA_GoEd_Loan_c*0;
                BBA_Adjustment_Amount2_BBA_c = BBA_Adjustment_Amount_BBA_c==null?0:BBA_Adjustment_Amount_BBA_c*0.6;
                BBA_US_Federal_Direct_Loan2_c = BBA_US_Federal_Direct_Loan_c==null?0:BBA_US_Federal_Direct_Loan_c*0;
                BBA_Private_Financing2_c = BBA_Private_Financing_c==null?0:BBA_Private_Financing_c*0;
                BBA_US_Federal_Parent_Plus2_c = BBA_US_Federal_Parent_Plus_c==null?0:BBA_US_Federal_Parent_Plus_c*0;
                BBA_US_Federal_Pell2_c = BBA_US_Federal_Pell_c==null?0:BBA_US_Federal_Pell_c*0;
                BBA_Total_Rotation_Fees2_c = BBA_Total_Rotation_Fees_c==null?0:BBA_Total_Rotation_Fees_c*0.6;
                
                BBA_tot_program_fee2_c = BBA_Program_Fee2_c + BBA_Pre_University_Fee2_c + BBA_Accommodation_Fee2_c + BBA_Accommodation_Deposit2_c 
                                            + BBA_Insurance2_c + BBA_Installment_Plan2_c +BBA_Extra_Credits_Charged2_c+BBA_Total_Rotation_Fees2_c;
                BBA_tot_scholarship2_c = BBA_Scholarship_Financial_Aid2_c + BBA_Dean_Financial_Aid2_c + BBA_GoEd_Loan2_c +BBA_Adjustment_Amount2_BBA_c 
                                            + BBA_US_Federal_Direct_Loan2_c + BBA_Private_Financing2_c + BBA_US_Federal_Parent_Plus2_c 
                                            + BBA_US_Federal_Pell2_c;
                BBA_total_Balance_Due2_c=BBA_tot_program_fee2_c-BBA_tot_scholarship2_c;                            
                                            
                //for London Page 3                            
                BBA_Program_Fee3_c = BBA_Program_Fee_c==null?0:BBA_Program_Fee_c*0.4;
                BBA_Pre_University_Fee3_c= BBA_Pre_University_Fee_c==null?0:BBA_Pre_University_Fee_c*0.4;
                BBA_Accommodation_Fee3_c = BBA_Accommodation_Fee_c==null?0:BBA_Accommodation_Fee_c*0;
                BBA_Accommodation_Deposit3_c = BBA_Accommodation_Deposit_c==null?0:BBA_Accommodation_Deposit_c*0;
                BBA_Insurance3_c = BBA_Insurance_c==null?0:BBA_Insurance_c;
                BBA_Installment_Plan3_c = BBA_Installment_Plan_c==null?0:BBA_Installment_Plan_c;
                BBA_Extra_Credits_Charged3_c = BBA_Extra_Credits_Charged_c==null?0:BBA_Extra_Credits_Charged_c*0.4;
                BBA_Scholarship_Financial_Aid3_c = BBA_Scholarship_Financial_Aid_c==null?0:BBA_Scholarship_Financial_Aid_c*0.4;
                BBA_Dean_Financial_Aid3_c = BBA_Dean_Financial_Aid_c==null?0:BBA_Dean_Financial_Aid_c*0.4;
                BBA_GoEd_Loan3_c = BBA_GoEd_Loan_c==null?0:BBA_GoEd_Loan_c*0;
                BBA_Adjustment_Amount3_BBA_c = BBA_Adjustment_Amount_BBA_c==null?0:BBA_Adjustment_Amount_BBA_c*0.4;
                BBA_US_Federal_Direct_Loan3_c = BBA_US_Federal_Direct_Loan_c==null?0:BBA_US_Federal_Direct_Loan_c*0;
                BBA_Private_Financing3_c = BBA_Private_Financing_c==null?0:BBA_Private_Financing_c*0;
                BBA_US_Federal_Parent_Plus3_c = BBA_US_Federal_Parent_Plus_c==null?0:BBA_US_Federal_Parent_Plus_c*0;
                BBA_US_Federal_Pell3_c = BBA_US_Federal_Pell_c==null?0:BBA_US_Federal_Pell_c*0;
                BBA_Total_Rotation_Fees3_c = BBA_Total_Rotation_Fees_c==null?0:BBA_Total_Rotation_Fees_c;
                
                BBA_tot_program_fee3_c = BBA_Program_Fee3_c + BBA_Pre_University_Fee3_c + BBA_Accommodation_Fee3_c + BBA_Accommodation_Deposit3_c 
                                            + BBA_Insurance3_c + BBA_Installment_Plan3_c +BBA_Extra_Credits_Charged3_c+Total_Rotation_Fees_Due_c+BBA_Total_Rotation_Fees3_c;
                BBA_tot_scholarship3_c = BBA_Scholarship_Financial_Aid3_c + BBA_Dean_Financial_Aid3_c + BBA_GoEd_Loan3_c +BBA_Adjustment_Amount3_BBA_c 
                                            + BBA_US_Federal_Direct_Loan3_c + BBA_Private_Financing3_c + BBA_US_Federal_Parent_Plus3_c 
                                            + BBA_US_Federal_Pell3_c;
                BBA_total_Balance_Due3_c=BBA_tot_program_fee3_c-BBA_tot_scholarship3_c;                            
            }
            if((oppfin.BBA_Unlock_Student_Financial_Information__c!=null && oppfin.BBA_Unlock_Student_Financial_Information__c.contains('Year1') && buttn_name=='bba_yr1') || (type=='draft' && buttn_name=='bba_yr1')){
                Unlock_Student_Financial_Information_c =true;
                year1_bool=true;
            }
            else if((oppfin.BBA_Unlock_Student_Financial_Information__c!=null && oppfin.BBA_Unlock_Student_Financial_Information__c.contains('Year2') && buttn_name=='bba_yr2') || (type=='draft' && buttn_name=='bba_yr2')){
                Unlock_Student_Financial_Information_c =true;
                year2_bool=true;
            }
            else if((oppfin.BBA_Unlock_Student_Financial_Information__c!=null && oppfin.BBA_Unlock_Student_Financial_Information__c.contains('Year3') && buttn_name=='bba_yr3') || (type=='draft' && buttn_name=='bba_yr3')){
                Unlock_Student_Financial_Information_c =true;
                year3_bool=true;
            }
            else if((oppfin.BBA_Unlock_Student_Financial_Information__c!=null && oppfin.BBA_Unlock_Student_Financial_Information__c.contains('Year4') && buttn_name=='bba_yr4') || (type=='draft' && buttn_name=='bba_yr4')){
                Unlock_Student_Financial_Information_c =true;
                year4_bool=true;
            }
            else if((oppfin.BBA_Unlock_Student_Financial_Information__c!=null && oppfin.BBA_Unlock_Student_Financial_Information__c.contains('Year5') && buttn_name=='bba_yr5') || (type=='draft' && buttn_name=='bba_yr5')){
                Unlock_Student_Financial_Information_c =true;
                year5_bool=true;
            }
            else{
                Unlock_Student_Financial_Information_c = false;
            }
            }
            catch (exception e){
                Unlock_Student_Financial_Information_c = false;
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
       
    public List<Fin_Statement_bba_ctrlr.WrapObj>  getfTransactionList(){
        List<Finance_Transactions__c> sList = [select createddate, Transaction_Type__c,Amount_Received__c, CurrencyIsoCode,Transaction_Date_Time__c from Finance_Transactions__c where Finance__r.Opportunity__c=: opp.id and (Transaction_Status__c='Success' or Transaction_Status__c='Manually Processed') and Transaction_Type__c!='Application Fee' order by createddate desc];
        //System.debug('------>>>'+slist);
        List<Fin_Statement_bba_ctrlr.WrapObj> wrapList = new List<Fin_Statement_bba_ctrlr.WrapObj>();
        Set<String> paytype=new Set<String>{'Program Fee Payment','Program Fee Payment AR','Refund','Refund AR','Refund AR - Loan Payoff','Writeoff','Writeoff AR','Writeoff - Recharge','Accommodation Deposit','Accommodation Deposit Refund','Accommodation Fee','Accommodation Deposit Forfeited'};
        
        for(Finance_Transactions__c f : sList){
            if(buttn_name=='bba_yr1' && (f.Transaction_Type__c.contains('Year 1') || f.Transaction_Type__c.contains('Confirmation Deposit') || paytype.contains(f.Transaction_Type__c))){
                wrapList.add(new Fin_Statement_bba_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
            if(buttn_name=='bba_yr2' && f.Transaction_Type__c.contains('Year 2')){
                wrapList.add(new Fin_Statement_bba_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
            if(buttn_name=='bba_yr3' && f.Transaction_Type__c.contains('Year 3')){
                wrapList.add(new Fin_Statement_bba_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
            if(buttn_name=='bba_yr4' && f.Transaction_Type__c.contains('Year 4')){
                wrapList.add(new Fin_Statement_bba_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
            if(buttn_name=='bba_yr5' && f.Transaction_Type__c.contains('Year 5')){
                wrapList.add(new Fin_Statement_bba_ctrlr.WrapObj(f.Transaction_Date_Time__c, currencyConvert(double.valueof(f.Amount_Received__c),f.CurrencyIsoCode,date.valueof(f.createddate)), f.Transaction_Type__c, opp.program__r.CurrencyIsoCode));
            }
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
    
    
}