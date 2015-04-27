/*
    Developer : Premanath Reddy
    Date      : 20/03/2014                
    purpose   : This class connects a Finance fields with Fee object fields,it run every time any of these fields is INSERTED or UPDATED.
                This class is calling from conect_finwithfee and add_fee2finance triggers
              
    Test class: mapping_Finwithfee_test
    coverage  : 86%
    Modified :Prem : SFSUP-772
    Modified : 07/11/2014 - Prem :: SFSUP-779
    Modified : 17/02/2015 - Prem :: SFSUP-970
*/
public class mapping_Finwithfeevalues{
    
    public static Map<string,string> fin_bba_map=new Map<string,string>();
    public static Map<string,string> fee_bba_map=new Map<string,string>();
    public static Map<string,string> fin_nonbba_map=new Map<string,string>();
    //Using map to get the API names dynamically for BBA mapping
    public static void biba_map()
    {
        fin_bba_map.put('pgm fee year 1','BBA_Program_Fee_Year_1__c');
        fin_bba_map.put('pgm fee year 2','BBA_Program_Fee_Year_2__c');
        fin_bba_map.put('pgm fee year 3','BBA_Program_Fee_Year_3__c');
        fin_bba_map.put('pgm fee year 4','BBA_Program_Fee_Year_4__c');

        fin_bba_map.put('invoice credits year 1','BBA_Invoiced_credits_Yr1__c');
        fin_bba_map.put('invoice credits year 2','BBA_Invoiced_Credits_Yr2__c');
        fin_bba_map.put('invoice credits year 3','BBA_Invoiced_Credits_Yr3__c');

        fin_bba_map.put('insurance year 1','BBA_Insurance_Year_1__c');
        fin_bba_map.put('insurance year 2','BBA_Insurance_Year_2__c');
        fin_bba_map.put('insurance year 3','BBA_Insurance_Year_3__c');
        fin_bba_map.put('insurance year 4','BBA_Insurance_Year_4__c');
        
        fin_bba_map.put('insurance pick year 1','BBA_Insurance_Picklist_Year_1__c');
        fin_bba_map.put('insurance pick year 2','BBA_Insurance_Picklist_Year_2__c');
        fin_bba_map.put('insurance pick year 3','BBA_Insurance_Picklist_Year_3__c');
        fin_bba_map.put('insurance pick year 4','BBA_Insurance_Picklist_Year_4__c');
        
        fin_bba_map.put('installment year 1','BBA_Installment_Plan_Year_1__c');
        fin_bba_map.put('installment year 2','BBA_Installment_Plan_Year_2__c');
        fin_bba_map.put('installment year 3','BBA_Installment_Plan_Year_3__c');
        fin_bba_map.put('installment year 4','BBA_Installment_Plan_Year_4__c');
        
        fin_bba_map.put('installment pick year 1','BBA_Installment_Plan_Picklist__c');
        fin_bba_map.put('installment pick year 2','BBA_Installment_Plan_Picklist_Year_2__c');
        fin_bba_map.put('installment pick year 3','BBA_Installment_Plan_Picklist_Year_3__c');
        fin_bba_map.put('installment pick year 4','BBA_Installment_Plan_Picklist_Year_4__c');
        
        fin_bba_map.put('Accommodation year 1','BBA_Accommodation_Fee_Year_1__c');
        fin_bba_map.put('Accommodation year 2','BBA_Accommodation_Fee_Year_2__c');
        fin_bba_map.put('Accommodation year 3','BBA_Accommodation_Fee_Year_3__c');
        fin_bba_map.put('Accommodation year 4','BBA_Accommodation_Fee_Year_4__c');
        
        fin_bba_map.put('Accommodation pick year 1','BBA_Accommodation_Year_1__c');
        fin_bba_map.put('Accommodation pick year 2','BBA_Accommodation_Year_2__c');
        fin_bba_map.put('Accommodation pick year 3','BBA_Accommodation_Year_3__c');
        fin_bba_map.put('Accommodation pick year 4','BBA_Accommodation_Year_4__c');
        
        fin_bba_map.put('Accommodation weeks year 1','BBA_Accommodation_Weeks_Year_1__c');
        fin_bba_map.put('Accommodation weeks year 2','BBA_Accommodation_Weeks_Year_2__c');
        fin_bba_map.put('Accommodation weeks year 3','BBA_Accommodation_Weeks_Year_3__c');
        fin_bba_map.put('Accommodation weeks year 4','BBA_Accommodation_Weeks_Year_4__c');
        
        //---------fees---------------
        fee_bba_map.put('pgm fee year 1','BBA_Program_Fee_Year_1_BBA__c');
        fee_bba_map.put('pgm fee year 2','BBA_Program_Fee_Year_2__c');
        fee_bba_map.put('pgm fee year 3','BBA_Program_Fee_Year_3_BBA__c');
        fee_bba_map.put('pgm fee year 4','BBA_Program_Fee_Year_4_BBA__c');
        
        fee_bba_map.put('invoice credits year 1','30');
        fee_bba_map.put('invoice credits year 2','30');
        fee_bba_map.put('invoice credits year 3','30');
        
    }
    //Using map to get the API names dynamically for Non-BBA mapping
    public static void nonbiba_map()
    {
        fin_nonbba_map.put('rotation 1 fee','Rot_Housing_Mod_D_Fee__c');
        fin_nonbba_map.put('rotation 2 fee','Rot_Visa_Mod_D_Fee__c');
        fin_nonbba_map.put('rotation 3 fee','Rot_Insurance_Mod_D_Fee__c');
        fin_nonbba_map.put('rotation 4 fee','Rot_Housing_Mod_E_Fee__c');
        fin_nonbba_map.put('rotation 5 fee','Rot_Visa_Mod_E_Fee__c');
        fin_nonbba_map.put('rotation 6 fee','Rot_Insurance_Mod_E_Fee__c');
       
        fin_nonbba_map.put('rotation 1 pick','Rot_Housing_Module_D__c');
        fin_nonbba_map.put('rotation 2 pick','Rot_Visa_Module_D__c');
        fin_nonbba_map.put('rotation 3 pick','Rot_Insurance_Module_D__c');
        fin_nonbba_map.put('rotation 4 pick','Rot_Housing_Module_E__c');
        fin_nonbba_map.put('rotation 5 pick','Rot_Visa_Module_E__c');
        fin_nonbba_map.put('rotation 6 pick','Rot_Insurance_Module_E__c');
    }
    // This method is for to check the finance bba dependent values changed or not.
    public static boolean isbiba_dependentvalues_changed(Opportunity_Finance__c oldfin,Opportunity_Finance__c fin)
    {
        return (oldfin.BBA_Program_Fee_Year_1__c!=fin.BBA_Program_Fee_Year_1__c || 
            oldfin.BBA_Program_Fee_Year_2__c!=fin.BBA_Program_Fee_Year_2__c ||
            oldfin.BBA_Program_Fee_Year_3__c!=fin.BBA_Program_Fee_Year_3__c ||
            oldfin.BBA_Program_Fee_Year_4__c!=fin.BBA_Program_Fee_Year_4__c ||
            
            oldfin.BBA_Invoiced_credits_Yr1__c!=fin.BBA_Invoiced_credits_Yr1__c || 
            oldfin.BBA_Invoiced_Credits_Yr2__c!=fin.BBA_Invoiced_Credits_Yr2__c ||
            oldfin.BBA_Invoiced_Credits_Yr3__c!=fin.BBA_Invoiced_Credits_Yr3__c ||
            
            oldfin.BBA_Insurance_Year_1__c!=fin.BBA_Insurance_Year_1__c || 
            oldfin.BBA_Insurance_Year_2__c!=fin.BBA_Insurance_Year_2__c ||
            oldfin.BBA_Insurance_Year_3__c!=fin.BBA_Insurance_Year_3__c ||
            oldfin.BBA_Insurance_Year_4__c!=fin.BBA_Insurance_Year_4__c ||
            
            oldfin.BBA_Installment_Plan_Year_1__c!=fin.BBA_Installment_Plan_Year_1__c || 
            oldfin.BBA_Installment_Plan_Year_2__c!=fin.BBA_Installment_Plan_Year_2__c ||
            oldfin.BBA_Installment_Plan_Year_3__c!=fin.BBA_Installment_Plan_Year_3__c ||
            oldfin.BBA_Installment_Plan_Year_4__c!=fin.BBA_Installment_Plan_Year_4__c ||
            
            oldfin.BBA_Accommodation_Fee_Year_1__c!=fin.BBA_Accommodation_Fee_Year_1__c || 
            oldfin.BBA_Accommodation_Fee_Year_2__c!=fin.BBA_Accommodation_Fee_Year_2__c ||
            oldfin.BBA_Accommodation_Fee_Year_3__c!=fin.BBA_Accommodation_Fee_Year_3__c ||
            oldfin.BBA_Accommodation_Fee_Year_4__c!=fin.BBA_Accommodation_Fee_Year_4__c ||
            
            oldfin.Rot_Housing_Mod_D_Fee__c!=fin.Rot_Housing_Mod_D_Fee__c ||
            oldfin.Rot_Visa_Mod_D_Fee__c!=fin.Rot_Visa_Mod_D_Fee__c ||
            oldfin.Rot_Insurance_Mod_D_Fee__c!=fin.Rot_Insurance_Mod_D_Fee__c ||
            oldfin.Rot_Housing_Mod_E_Fee__c!=fin.Rot_Housing_Mod_E_Fee__c ||
            oldfin.Rot_Visa_Mod_E_Fee__c!=fin.Rot_Visa_Mod_E_Fee__c ||
            oldfin.Rot_Insurance_Mod_E_Fee__c!=fin.Rot_Insurance_Mod_E_Fee__c ||
            
            oldfin.Rot_Housing_Module_D__c!=fin.Rot_Housing_Module_D__c ||
            oldfin.Rot_Visa_Module_D__c!=fin.Rot_Visa_Module_D__c ||
            oldfin.Rot_Insurance_Module_D__c!=fin.Rot_Insurance_Module_D__c ||
            oldfin.Rot_Housing_Module_E__c!=fin.Rot_Housing_Module_E__c ||
            oldfin.Rot_Visa_Module_E__c!=fin.Rot_Visa_Module_E__c ||
            oldfin.Rot_Insurance_Module_E__c!=fin.Rot_Insurance_Module_E__c ||
            (fin.Housing_Accommodation__c !=null && fin.Annual_Accommodation_Fee__c==null) ||
            (fin.Rot_Housing_Module_D__c !=null && fin.Rot_Housing_Mod_D_Fee__c==null) ||
            (fin.Rot_Visa_Module_D__c !=null && fin.Rot_Visa_Mod_D_Fee__c==null) ||
            (fin.Rot_Insurance_Module_D__c !=null && fin.Rot_Insurance_Mod_D_Fee__c==null) ||
            (fin.Rot_Housing_Module_E__c !=null && fin.Rot_Housing_Mod_E_Fee__c==null) ||
            (fin.Rot_Visa_Module_E__c !=null && fin.Rot_Visa_Mod_E_Fee__c==null) ||
            (fin.Rot_Insurance_Module_E__c  !=null && fin.Rot_Insurance_Mod_E_Fee__c==null) ||
            
            oldfin.BBA_Pre_University_Fee_Year_1__c!=fin.BBA_Pre_University_Fee_Year_1__c);
    }
    // This method is for to check the finance non-bba dependent values changed or not.
    public static boolean isnon_biba_dependentvalues_changed(Opportunity_Finance__c oldfin,Opportunity_Finance__c fin)
    {
         return (oldfin.Annual_Accommodation_Fee__c!=fin.Annual_Accommodation_Fee__c ||
        
            oldfin.Rot_Housing_Mod_D_Fee__c!=fin.Rot_Housing_Mod_D_Fee__c ||
            oldfin.Rot_Visa_Mod_D_Fee__c!=fin.Rot_Visa_Mod_D_Fee__c ||
            oldfin.Rot_Insurance_Mod_D_Fee__c!=fin.Rot_Insurance_Mod_D_Fee__c ||
            oldfin.Rot_Housing_Mod_E_Fee__c!=fin.Rot_Housing_Mod_E_Fee__c ||
            oldfin.Rot_Visa_Mod_E_Fee__c!=fin.Rot_Visa_Mod_E_Fee__c ||
            oldfin.Rot_Insurance_Mod_E_Fee__c!=fin.Rot_Insurance_Mod_E_Fee__c);
    }
    
    
    //BBA Finance mapping 
    public static void biba_method(fees__c fees,Opportunity_Finance__c opfin,Map<String,string> feelables){
        biba_map();
        opfin.put('BBA_Pre_University_Fee_Year_1__c',fees.get('BBA_Pre_University_Fee__c'));
        for(integer i=1;i<=4;i++)
        {
            //if(!(boolean)opfin.get(fin_bba_map.get('is year '+i)))
            String godlever=opfin.God_Lever_BBA__c==null?'':opfin.God_Lever_BBA__c;
            if(!godlever.contains('Year '+i))
            {
                // Program Fee
                opfin.put(fin_bba_map.get('pgm fee year '+i), fees.get(fee_bba_map.get('pgm fee year '+i)));
                
                // Invoice Credits
                if(i!=4)
                    opfin.put(fin_bba_map.get('invoice credits year '+i), Decimal.valueOf(fee_bba_map.get('invoice credits year '+i)));
                
                // Insurance Section
                string fin_ins_api=(string)opfin.get(fin_bba_map.get('insurance pick year '+i));
                String ins_yr=fin_ins_api!=null?fin_ins_api.tolowercase()+' - year '+i+' - single':fin_ins_api;
                if(feelables.containsKey(ins_yr))
                {
                    if(fees.get(feelables.get(ins_yr))!=null)
                    {
                        opfin.put(fin_bba_map.get('insurance year '+i),double.valueOf(fees.get(feelables.get(ins_yr))));
                    }
                    else
                    {
                         opfin.put(fin_bba_map.get('insurance year '+i),null);
                    }
                }
                else
                {
                     opfin.put(fin_bba_map.get('insurance year '+i),null);
                }  
                
                // Installment Plan section
                string fin_inst_api=(string)opfin.get(fin_bba_map.get('installment pick year '+i));
                String inst_yr=fin_inst_api!=null?fin_inst_api.tolowercase()+' - year '+i:fin_inst_api;
                if(feelables.containsKey(inst_yr))
                {
                    if(fees.get(feelables.get(inst_yr))!=null)
                    {
                        opfin.put(fin_bba_map.get('installment year '+i),double.valueOf(fees.get(feelables.get(inst_yr))));
                    }
                    else
                    {
                        opfin.put(fin_bba_map.get('installment year '+i),null);
                    }
                }
                else
                {
                    opfin.put(fin_bba_map.get('installment year '+i),null);
                }
                
                //Accommodation - Section
                String hous_accm=(string)opfin.get(fin_bba_map.get('Accommodation pick year '+i));
                integer accm_weeks;
                Try{accm_weeks=Integer.valueOf(opfin.get(fin_bba_map.get('Accommodation weeks year '+i)));
                }catch(Exception e){system.debug(e);}
                String housing;
                if(accm_weeks>=1 && accm_weeks<=42){
                    housing=hous_accm+' P1 - Year '+i;
                }
                else if(accm_weeks>=43 && accm_weeks<=50){
                    housing=hous_accm+' P2 - Year '+i;
                }
                else if(accm_weeks>=51 && accm_weeks<=52){
                    housing=hous_accm+' P3 - Year '+i;
                }
                housing=housing!=null?housing.tolowercase():housing;
                //System.Debug(feelables.get('Penthouse Luxury Studio P1 - Year 1')+'**************============'+feelables.keyset());
                if(feelables.containsKey(housing))
                {   
                    if(fees.get(feelables.get(housing))!=null)
                    {
                        opfin.put(fin_bba_map.get('Accommodation year '+i),double.valueOf(fees.get(feelables.get(housing)))*accm_weeks);
                    }
                    else
                    {
                        opfin.put(fin_bba_map.get('Accommodation year '+i),null);
                    }
                }
                else
                {
                    String hos_acc=hous_accm!=null?hous_accm.tolowercase():hous_accm;
                    if(feelables.containsKey(hos_acc))
                    {
                        if(fees.get(feelables.get(hos_acc))!=null)
                        {
                            opfin.put(fin_bba_map.get('Accommodation year '+i),double.valueOf(fees.get(feelables.get(hos_acc))));
                        }
                        else
                        {
                            opfin.put(fin_bba_map.get('Accommodation year '+i),null);
                        }
                    }
                    else
                    {
                        opfin.put(fin_bba_map.get('Accommodation year '+i),null);
                    }
                }
                
            }
        
        }
        
        nonbiba_map();
        // Rotation Section
        for(integer i=1;i<=6;i++){
            string fin_rot_mod=(string)opfin.get(fin_nonbba_map.get('rotation '+i+' pick'));
            String rot_mod=fin_rot_mod!=null?fin_rot_mod.tolowercase():fin_rot_mod;
            if(feelables.containsKey(rot_mod))
            {
                if(fees.get(feelables.get(rot_mod))!=null)
                {
                    opfin.put(fin_nonbba_map.get('rotation '+i+' fee'),double.valueOf(fees.get(feelables.get(rot_mod))));
                }
                else
                {
                    opfin.put(fin_nonbba_map.get('rotation '+i+' fee'),null);
                }
            }
            else
            {
                opfin.put(fin_nonbba_map.get('rotation '+i+' fee'),null);
            }
        }
    }
    
    /*
    Non-BBA Finance mapping
    */
    public static void non_biba_method(Fees__c fees,Opportunity_Finance__c new_fin,Map<String,string> feelables)
    {
        nonbiba_map();
        //Housing Accommodation Section
        String hous_accmm=new_fin.Housing_Accommodation__c;
        integer  accm_weeks;
        Try{accm_weeks=Integer.valueOf(new_fin.Accommodation_weeks__c);
        }catch(Exception e){system.debug(e);}
        String housing;
        if(accm_weeks>=1 && accm_weeks<=42){
            housing=hous_accmm+' P1';
        }
        else if(accm_weeks>=43 && accm_weeks<=50){
            housing=hous_accmm+' P2';
        }
        else if(accm_weeks>=51 && accm_weeks<=52){
            housing=hous_accmm+' P3';
        }
        housing=housing!=null?housing.tolowercase():housing;
        sObject fe=fees;
        if(feelables.containsKey(housing))
        {   
            if(fe.get(feelables.get(housing))!=null)
            {
                new_fin.Annual_Accommodation_Fee__c=double.valueOf(fe.get(feelables.get(housing)))*accm_weeks;
            }
            else
            {
                new_fin.Annual_Accommodation_Fee__c=null;
            }
        }
        else
        {
            String hos_acc=new_fin.Housing_Accommodation__c!=null?new_fin.Housing_Accommodation__c.tolowercase():new_fin.Housing_Accommodation__c;
            if(feelables.containsKey(hos_acc))
            {
                if(fe.get(feelables.get(hos_acc))!=null)
                {
                    new_fin.Annual_Accommodation_Fee__c=double.valueOf(fe.get(feelables.get(hos_acc)));
                }
                else
                {
                    new_fin.Annual_Accommodation_Fee__c=null;
                }
            }
            else
            {
                new_fin.Annual_Accommodation_Fee__c=null;
            }
        }
        
        // Rotation Section
        for(integer i=1;i<=6;i++){
            string fin_rot_mod=(string)new_fin.get(fin_nonbba_map.get('rotation '+i+' pick'));
            String rot_mod=fin_rot_mod!=null?fin_rot_mod.tolowercase():fin_rot_mod;
            if(feelables.containsKey(rot_mod))
            {
                if(fees.get(feelables.get(rot_mod))!=null)
                {
                    new_fin.put(fin_nonbba_map.get('rotation '+i+' fee'),double.valueOf(fees.get(feelables.get(rot_mod))));
                }
                else
                {
                    new_fin.put(fin_nonbba_map.get('rotation '+i+' fee'),null);
                }
            }
            else
            {
                new_fin.put(fin_nonbba_map.get('rotation '+i+' fee'),null);
            }
        }
    }
    
    public static decimal blank_val(decimal val){         
        return val==null?0:val;     
    }
    public static Map<string,string> instplan_bba_map=new Map<string,string>();
    private static void installmentplan_vals_map()
    {
        instplan_bba_map.put('pay amount 1 year 1','Payment_Amount_1st__c');
        instplan_bba_map.put('pay amount 1 year 2','x1st_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 1 year 3','X1st_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 1 year 4','X1st_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 2 year 1','Payment_Amount_2nd__c');
        instplan_bba_map.put('pay amount 2 year 2','X2nd_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 2 year 3','X2nd_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 2 year 4','X2nd_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 3 year 1','Payment_Amount_3rd__c');
        instplan_bba_map.put('pay amount 3 year 2','X3rd_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 3 year 3','X3rd_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 3 year 4','X3rd_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 4 year 1','Payment_Amount_4th__c');
        instplan_bba_map.put('pay amount 4 year 2','X4th_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 4 year 3','X4th_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 4 year 4','X4th_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 5 year 1','Payment_Amount_5th__c');
        instplan_bba_map.put('pay amount 5 year 2','X5th_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 5 year 3','X5th_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 5 year 4','X5th_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 6 year 1','Payment_Amount_6th__c');
        instplan_bba_map.put('pay amount 6 year 2','X6th_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 6 year 3','X6th_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 6 year 4','X6th_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 7 year 1','Payment_Amount_7th__c');
        instplan_bba_map.put('pay amount 7 year 2','X7th_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 7 year 3','X7th_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 7 year 4','X7th_Payment_Amount_Year_4__c');
        
        instplan_bba_map.put('pay amount 8 year 1','Payment_Amount_8th__c');
        instplan_bba_map.put('pay amount 8 year 2','X8th_Payment_Amount_Year_2__c');
        instplan_bba_map.put('pay amount 8 year 3','X8th_Payment_Amount_Year_3__c');
        instplan_bba_map.put('pay amount 8 year 4','X8th_Payment_Amount_Year_4__c');
        
        
                //--Installment Date
        
        instplan_bba_map.put('Pay Date 1 year 1','Payment_Due_Date_1st__c');
        instplan_bba_map.put('Pay Date 1 year 2','x1st_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 1 year 3','X1st_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 1 year 4','X1st_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 2 year 1','Payment_Due_Date_2nd__c');
        instplan_bba_map.put('Pay Date 2 year 2','X2nd_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 2 year 3','X2nd_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 2 year 4','X2nd_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 3 year 1','Payment_Due_Date_3rd__c');
        instplan_bba_map.put('Pay Date 3 year 2','X3rd_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 3 year 3','X3rd_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 3 year 4','X3rd_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 4 year 1','Payment_Due_Date_4th__c');
        instplan_bba_map.put('Pay Date 4 year 2','X4th_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 4 year 3','X4th_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 4 year 4','X4th_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 5 year 1','Payment_Due_Date_5th__c');
        instplan_bba_map.put('Pay Date 5 year 2','X5th_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 5 year 3','X5th_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 5 year 4','X5th_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 6 year 1','Payment_Due_Date_6th__c');
        instplan_bba_map.put('Pay Date 6 year 2','X6th_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 6 year 3','X6th_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 6 year 4','X6th_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 7 year 1','Payment_Due_Date_7th__c');
        instplan_bba_map.put('Pay Date 7 year 2','X7th_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 7 year 3','X7th_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 7 year 4','X7th_Payment_Due_Date_Year_4__c');
        
        instplan_bba_map.put('Pay Date 8 year 1','Payment_Due_Date_8th__c');
        instplan_bba_map.put('Pay Date 8 year 2','X8th_Payment_Due_Date_Year_2__c');
        instplan_bba_map.put('Pay Date 8 year 3','X8th_Payment_Due_Date_Year_3__c');
        instplan_bba_map.put('Pay Date 8 year 4','X8th_Payment_Due_Date_Year_4__c');
        
    }
    public static Opportunity_Finance__c inst_multiplier(Opportunity_Finance__c fin,Fees__c fee,Installment_Plan_Multiplier_Values__c inst)
    {
        String prog=fin.Program__c;
        string plan=fin.Installment_Plan__c;
        /*integer offset1=inst.inst1_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst1_Due_Date_Offset_days__c);
        integer offset2=inst.inst2_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst2_Due_Date_Offset_days__c);
        integer offset3=inst.inst3_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst3_Due_Date_Offset_days__c);
        integer offset4=inst.inst4_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst4_Due_Date_Offset_days__c);
        integer offset5=inst.inst5_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst5_Due_Date_Offset_days__c);
        integer offset6=inst.inst6_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst6_Due_Date_Offset_days__c);
        integer offset7=inst.inst7_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst7_Due_Date_Offset_days__c);
        integer offset8=inst.inst8_Due_Date_Offset_days__c==null?0:Integer.valueof(inst.inst8_Due_Date_Offset_days__c);*/
        if(plan==null)
            return fin;
       installmentplan_vals_map();
        if(Prog.startsWith('Bachelor'))
        {
            map<String,string> years=new map<string,string>{'1'=>'__c','2'=>'_Year2__c','3'=>'_Year3__c','4'=>'_Year4__c'};
            map<String,string> bba_years=new map<string,string>{'1'=>'_Year_1__c','2'=>'_Year_2__c','3'=>'_Year_3__c','4'=>'_Year_4__c'};
            String godlever=fin.God_Lever_BBA__c==null?'':fin.God_Lever_BBA__c;
            
            for(integer i=1;i<=4;i++)
            {
                if(!godlever.contains('Year '+i))
                {
                    string yr=years.get(''+i);
                    string bba_yr=bba_years.get(''+i);
                    string accomdeposit='BBA_Accommodation_Deposit'+(i==1?yr:bba_yr);
                    Double Total_Bursary_Amount_c=0;
                    if(i==1)
                    {
                        Total_Bursary_Amount_c=blank_val((Double)fin.BBA_Scholarship_Financial_Aid_Year_1__c)+blank_val((Double)fin.BBA_Dean_Financial_Aid_Year_1__c)+
                            blank_val((Double)fin.BBA_Private_Financing_Year_1__c)+blank_val((Double)fin.BBA_Adjustment_Amount_Year_1_BBA__c)+
                            blank_val((Double)fin.BBA_GoEd_Loan_Year_1__c);
                            /*blank_val((Double)fin.BBA_US_Federal_Direct_Loan_Year_1__c)+blank_val((Double)fin.BBA_US_Federal_Parent_Plus_Year_1__c)+
                            blank_val((Double)fin.BBA_US_Federal_Pell_Year_1__c)+*/
                    }
                    if(i==2)
                    {
                        Total_Bursary_Amount_c=blank_val((Double)fin.BBA_Scholarship_Financial_Aid_Year_2__c)+
                            blank_val((Double)fin.BBA_Dean_Financial_Aid_Year_2__c)+blank_val((Double)fin.BBA_Adjustment_Amount_Year_2_BBA__c)+
                            blank_val((Double)fin.BBA_Private_Financing_Year_2__c)+blank_val((Double)fin.BBA_GoEd_Loan_Year_2__c);
                            /*blank_val((Double)fin.R_Scholarship_Financial_Aid_Year_2__c)+blank_val((Double)fin.BBA_US_Federal_Direct_Loan_Year_2__c)+
                            blank_val((Double)fin.BBA_US_Federal_Parent_Plus_Year_2__c)+blank_val((Double)fin.BBA_US_Federal_Pell_Year_2__c)+*/
                    }
                    if(i==3)
                    {
                        Total_Bursary_Amount_c=blank_val((Double)fin.BBA_Scholarship_Financial_Aid_Year_3__c)+
                            blank_val((Double)fin.BBA_Dean_Financial_Aid_Year_3__c)+blank_val((Double)fin.BBA_Adjustment_Amount_Year_3_BBA__c)+
                            blank_val((Double)fin.BBA_Private_Financing_Year_3__c)+blank_val((Double)fin.BBA_US_Federal_Pell_Year_3__c)+
                            blank_val((Double)fin.BBA_GoEd_Loan_Year_3__c);
                            /*blank_val((Double)fin.R_Scholarship_Financial_Aid_Year_3__c)+blank_val((Double)fin.BBA_US_Federal_Direct_Loan_Year_3__c)+
                            blank_val((Double)fin.BBA_US_Federal_Parent_Plus_Year_3__c)+*/

                    }
                    if(i==4)
                    {
                        Total_Bursary_Amount_c=blank_val((Double)fin.BBA_Scholarship_Financial_Aid_Year_4__c)+
                            blank_val((Double)fin.BBA_Dean_Financial_Aid_Year_4__c)+blank_val((Double)fin.BBA_Adjustment_Amount_Year_4_BBA__c)+
                            blank_val((Double)fin.BBA_Private_Financing_Year_4__c)+blank_val((Double)fin.BBA_US_Federal_Pell_Year_4__c)+
                            blank_val((Double)fin.BBA_GoEd_Loan_Year_4__c);
                        /*blank_val((Double)fin.R_Scholarship_Financial_Aid_Year_4__c)+blank_val((Double)fin.BBA_US_Federal_Direct_Loan_Year_4__c)+
                        blank_val((Double)fin.BBA_US_Federal_Parent_Plus_Year_4__c)+*/

                    }
                    for(integer j=1;j<=8;j++)
                    {
                        Double Pay=(blank_val((Double)fin.get('BBA_Program_Fee'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_Tuition_Fee'+yr)))+
                                    (blank_val((Double)fin.get('BBA_Accommodation_Fee'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_Annual_Accommodation_Fee'+yr)))+
                                    (blank_val((Double)fin.get(accomdeposit))*blank_val((Double)inst.get('inst'+j+'_Accommodation_Deposit'+yr)))+
                                    (blank_val((Double)fin.get('BBA_Installment_Plan'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_Installment_Plan_Fee'+yr)))+
                                    (blank_val((Double)fin.get('BBA_Insurance'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_Insurance_Price'+yr)))+
                                    (blank_val((Double)fin.get('BBA_Extra_Credits_Charged'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_extra_credits_charged'+yr)))+
                                    (blank_val(fin.Total_Rotation_Fees_Due__c)*blank_val((Double)inst.get('Inst'+j+'_Total_Rotation_fees_Due'+yr)))+
                                    (blank_val(Total_Bursary_Amount_c)*blank_val((Double)inst.get('inst'+j+'_Total_Bursary_Amount'+yr)));//+
                                    //(blank_val(fin.BBA_Confirmation_Deposit_Paid__c)*blank_val((Double)inst.get('inst'+j+'_Course_Deposit_Paid'+yr)));
                                    /*Do i need to create +BBA_Extra_Credits_Charged_Year_1__c +BBA_Pre_University_Fee_Year_1__c  related in inst?*/    
                        /*if(i==1)
                        {
                            
                            pay=pay+(blank_val((Double)fin.get('BBA_Pre_University_Fee'+bba_yr))*blank_val((Double)inst.get('inst'+j+'_Pre_University_Fee'+yr)));
                        }*/
                        string fld='Program_Start_Date'+bba_yr;
                        if(i==1)
                            fld='Program_Start_Date__c';
                        
                        Decimal offset=(Decimal)inst.get('Inst'+j+'_Due_Date_Offset_days__c');
                        Date pgmdate=(Date)fee.get(fld);
                        Date Pay_date;
                        if(offset!=null)
                            Pay_date=pgmdate!=null?pgmdate.addDays(Integer.valueof(offset)):null;
                        
                        fin.put(instplan_bba_map.get('pay amount '+j+' year '+i),Pay);
                        fin.put(instplan_bba_map.get('Pay Date '+j+' year '+i),Pay_date);
                    }
                }
            }
        }
        else
        {
            if(!fin.God_Lever__c)
            {
                for(integer j=1;j<=8;j++)
                {
                    Double pay=(blank_val( fin.Tuition_Fee__c) * blank_val((Double)inst.get('inst'+j+'_Tuition_Fee__c'))) + 
                                              (blank_val( fin.Annual_Accommodation_Fee__c) *blank_val((Double)inst.get('inst'+j+'_Annual_Accommodation_Fee__c'))) + 
                                              (blank_val( fin.Accommodation_Depositx__c) * blank_val((Double)inst.get('inst'+j+'_Accommodation_Deposit__c')))+ 
                                              (blank_val( fin.Installment_Plan_Fee__c) *blank_val((Double)inst.get('inst'+j+'_Installment_Plan_Fee__c'))) +
                                              (blank_val( fin.Insurance_Price__c) * blank_val((Double)inst.get('inst'+j+'_Insurance_Price__c'))) + 
                                              (blank_val( fin.Visa_Fee__c) * blank_val((Double)inst.get('inst'+j+'_Visa_Fee__c')))+ 
                                              (blank_val( fin.Specialization_Fee_preFS__c) * blank_val((Double)inst.get('inst'+j+'_Specialization_Fee__c')))+ 
                                              (blank_val( fin.Partner_Program_Fee__c) * blank_val((Double)inst.get('inst'+j+'_Partner_Program_Fee__c')))+
                                              (blank_val( fin.Partner_Program_Insurance_Fee__c)*blank_val((Double)inst.get('inst'+j+'_Partner_Program_Insurance__c')))+
                                              (blank_val(fin.Total_Rotation_Fees_Due__c)*blank_val((Double)inst.get('inst'+j+'_Total_Rotation_fees_Due__c')))+(
                                                  (blank_val( fin.Course_Deposit_Paid__c)*blank_val(inst.inst1_Course_Deposit_Paid__c)) +
                                              (blank_val( fin.Total_Bursary_Amount__c) * blank_val((Double)inst.get('inst'+j+'_Total_Bursary_Amount__c'))));
                    
                    //Date Pay_date=fee.Program_Start_Date__c!=null?fee.Program_Start_Date__c.addDays(Offset1):null;
                    Decimal offset=(Decimal)inst.get('Inst'+j+'_Due_Date_Offset_days__c');
                    Date Pay_date;
                    if(offset!=null)
                        Pay_date=fee.Program_Start_Date__c!=null?fee.Program_Start_Date__c.addDays(Integer.valueof(offset)):null;
                        
                    fin.put(instplan_bba_map.get('pay amount '+j+' year 1'),Pay);
                    fin.put(instplan_bba_map.get('Pay Date '+j+' year 1'),Pay_date);
                }
            }
        }
        return fin;
    }
    public static Boolean check_installmentplan_trigger_conditions(Opportunity_Finance__c fin,Opportunity_Finance__c oldfin){
        boolean ischanged;
        ischanged=(fin.Installment_Plan__c!=oldfin.Installment_Plan__c)||(fin.Fees__C!=oldfin.Fees__c)||
        (fin.BBA_Scholarship_Financial_Aid_Year_1__c!=oldfin.BBA_Scholarship_Financial_Aid_Year_1__c)||
        (fin.BBA_Dean_Financial_Aid_Year_1__c!=oldfin.BBA_Dean_Financial_Aid_Year_1__c)||
        (fin.BBA_Private_Financing_Year_1__c!=oldfin.BBA_Private_Financing_Year_1__c)||
        (fin.BBA_Adjustment_Amount_Year_1_BBA__c!=oldfin.BBA_Adjustment_Amount_Year_1_BBA__c)||
        (fin.BBA_GoEd_Loan_Year_1__c!=oldfin.BBA_GoEd_Loan_Year_1__c)||
        (fin.BBA_Scholarship_Financial_Aid_Year_2__c!=oldfin.BBA_Scholarship_Financial_Aid_Year_2__c)||
        (fin.BBA_Dean_Financial_Aid_Year_2__c!=oldfin.BBA_Dean_Financial_Aid_Year_2__c)||
        (fin.BBA_Adjustment_Amount_Year_2_BBA__c!=oldfin.BBA_Adjustment_Amount_Year_2_BBA__c)||
        (fin.BBA_Private_Financing_Year_2__c!=oldfin.BBA_Private_Financing_Year_2__c)||
        (fin.BBA_GoEd_Loan_Year_2__c!=oldfin.BBA_GoEd_Loan_Year_2__c)||
        (fin.BBA_Scholarship_Financial_Aid_Year_3__c!=oldfin.BBA_Scholarship_Financial_Aid_Year_3__c)||
        (fin.BBA_Dean_Financial_Aid_Year_3__c!=oldfin.BBA_Dean_Financial_Aid_Year_3__c)||
        (fin.BBA_Adjustment_Amount_Year_3_BBA__c!=oldfin.BBA_Adjustment_Amount_Year_3_BBA__c)||
        (fin.BBA_Private_Financing_Year_3__c!=oldfin.BBA_Private_Financing_Year_3__c)||
        (fin.BBA_US_Federal_Pell_Year_3__c!=oldfin.BBA_US_Federal_Pell_Year_3__c)||
        (fin.BBA_GoEd_Loan_Year_3__c!=oldfin.BBA_GoEd_Loan_Year_3__c)||
        (fin.BBA_Scholarship_Financial_Aid_Year_4__c!=oldfin.BBA_Scholarship_Financial_Aid_Year_4__c)||
        (fin.BBA_Dean_Financial_Aid_Year_4__c!=oldfin.BBA_Dean_Financial_Aid_Year_4__c)||
        (fin.BBA_Adjustment_Amount_Year_4_BBA__c!=oldfin.BBA_Adjustment_Amount_Year_4_BBA__c)||
        (fin.BBA_Private_Financing_Year_4__c!=oldfin.BBA_Private_Financing_Year_4__c)||
        (fin.BBA_US_Federal_Pell_Year_4__c!=oldfin.BBA_US_Federal_Pell_Year_4__c)||
        (fin.BBA_GoEd_Loan_Year_4__c!=oldfin.BBA_GoEd_Loan_Year_4__c)||
        (fin.BBA_Program_Fee_Year_1__c!=oldfin.BBA_Program_Fee_Year_1__c)||
        (fin.BBA_Program_Fee_Year_2__c!=oldfin.BBA_Program_Fee_Year_2__c)||
        (fin.BBA_Program_Fee_Year_3__c!=oldfin.BBA_Program_Fee_Year_3__c)||
        (fin.BBA_Program_Fee_Year_4__c!=oldfin.BBA_Program_Fee_Year_4__c)||
        (fin.BBA_Accommodation_Fee_Year_1__c!=oldfin.BBA_Accommodation_Fee_Year_1__c)||
        (fin.BBA_Accommodation_Fee_Year_2__c!=oldfin.BBA_Accommodation_Fee_Year_2__c)||
        (fin.BBA_Accommodation_Fee_Year_3__c!=oldfin.BBA_Accommodation_Fee_Year_3__c)||
        (fin.BBA_Accommodation_Fee_Year_4__c!=oldfin.BBA_Accommodation_Fee_Year_4__c)||
        (fin.BBA_Accommodation_Deposit__c!=oldfin.BBA_Accommodation_Deposit__c)||
        (fin.BBA_Accommodation_Deposit_Year_2__c!=oldfin.BBA_Accommodation_Deposit_Year_2__c)||
        (fin.BBA_Accommodation_Deposit_Year_3__c!=oldfin.BBA_Accommodation_Deposit_Year_3__c)||
        (fin.BBA_Accommodation_Deposit_Year_4__c!=oldfin.BBA_Accommodation_Deposit_Year_4__c)||
        (fin.BBA_Installment_Plan_Year_1__c!=oldfin.BBA_Installment_Plan_Year_1__c)||
        (fin.BBA_Installment_Plan_Year_2__c!=oldfin.BBA_Installment_Plan_Year_2__c)||
        (fin.BBA_Installment_Plan_Year_3__c!=oldfin.BBA_Installment_Plan_Year_3__c)||
        (fin.BBA_Installment_Plan_Year_4__c!=oldfin.BBA_Installment_Plan_Year_4__c)||
        (fin.BBA_Insurance_Year_1__c!=oldfin.BBA_Insurance_Year_1__c)||
        (fin.BBA_Insurance_Year_2__c!=oldfin.BBA_Insurance_Year_2__c)||
        (fin.BBA_Insurance_Year_3__c!=oldfin.BBA_Insurance_Year_3__c)||
        (fin.BBA_Insurance_Year_4__c!=oldfin.BBA_Insurance_Year_4__c)||
        (fin.BBA_Extra_Credits_Charged_Year_1__c!=oldfin.BBA_Extra_Credits_Charged_Year_1__c)||
        (fin.BBA_Extra_Credits_Charged_Year_2__c!=oldfin.BBA_Extra_Credits_Charged_Year_2__c)||
        (fin.BBA_Extra_Credits_Charged_Year_3__c!=oldfin.BBA_Extra_Credits_Charged_Year_3__c)||
        (fin.BBA_Extra_Credits_Charged_Year_4__c!=oldfin.BBA_Extra_Credits_Charged_Year_4__c)||
        (fin.Total_Rotation_Fees_Due__c!=oldfin.Total_Rotation_Fees_Due__c)||        
        (fin.Tuition_Fee__c!=oldfin.Tuition_Fee__c)||
        (fin.Annual_Accommodation_Fee__c!=oldfin.Annual_Accommodation_Fee__c)||                                 
         (fin.Accommodation_Depositx__c!=oldfin.Accommodation_Depositx__c)||
        ( fin.Installment_Plan_Fee__c!=oldfin.Installment_Plan_Fee__c)||
        ( fin.Insurance_Price__c!=oldfin.Insurance_Price__c)||
        ( fin.Visa_Fee__c!=oldfin.Visa_Fee__c)||
        ( fin.Specialization_Fee_preFS__c!=oldfin.Specialization_Fee_preFS__c)||
        ( fin.Partner_Program_Fee__c!=oldfin.Partner_Program_Fee__c)|| 
        (fin.Partner_Program_Insurance_Fee__c!=oldfin.Partner_Program_Insurance_Fee__c)||
        (fin.Course_Deposit_Paid__c!=oldfin.Course_Deposit_Paid__c)||
        (fin.Total_Bursary_Amount__c!=oldfin.Total_Bursary_Amount__c);
        
        return ischanged;
    }
}