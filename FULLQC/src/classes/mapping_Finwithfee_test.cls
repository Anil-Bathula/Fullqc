/*
Author : Premanath Reddy
pupose : Test class for add_fee2finance and conect_finwithfee Triggers,mapping_Finwithfeevalues class
SFSUP-772
*/
@isTest(seeAllData=true)
public class mapping_Finwithfee_test{
    static testmethod void methodname(){
        //BBA Finance
        String bba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');
        String nonbba_rectype=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance');
        
        List<Department__c> deptlst=new List<Department__c>();
        List<Program__c> prolst=new List<Program__c>();
        List<Opportunity> opplst=new List<Opportunity>();
        List<Opportunity_Finance__c> opfinlst=new List<Opportunity_Finance__c>();
        List<Fees__c> feelst=new List<Fees__c>();
        //for BBA Finance
        Department__c dept=new Department__c();
        dept.Name='BBA';
        deptlst.add(dept);
        //for Non-BBA Finance
        Department__c dept1=new Department__c();
        dept1.Name='MIB';
        deptlst.add(dept1);
        
        insert deptlst;
        //for BBA Finance
        Program__c pro =new Program__c();
        pro.name='Bachelor of Business Administration-UK-London';
        pro.Campus__c='London';
        pro.Department__c=dept.id;
        prolst.add(pro);
        //for Non-BBA Finance
        Program__c pro1 =new Program__c();
        pro1.name='MIB-UK-London';
        pro1.Campus__c='London';
        pro1.Department__c=dept.id;
        prolst.add(pro1);
        
        insert prolst;
        //for BBA Finance
        String p1=pro.Name;
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Fees__c').getDescribe().fields.getMap();
        String theQuery = 'SELECT ';
        for(Schema.SObjectField s : fieldMap.values()){
           String theName = s.getDescribe().getName();
           theQuery += theName + ',';
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1);
        theQuery += ' from Fees__c where Program_Name__r.Name=:P1 limit 1';
        
        fees__c fee=Database.query(theQuery);
        
        /*Fees__c fee=new Fees__c();
        fee.Program_Name__c=pro.id;
        fee.Year__c='2014';
        fee.BBA_Apartment_P1_Year_1__c=100;
        fee.BBA_Apartment_P2_Year_1__c=101;
        fee.BBA_Apartment_P3_Year_1__c=102;
        fee.Bunk_Studio_P1__c=105;
        fee.Bunk_Studio_Vista_P1__c=106;
        fee.BBA_Deluxe_Studio_Apart_P2_Year_3__c=104;
        fee.BBA_Deluxe_Studio_Apart_P3_Year_2__c=110;
        fee.BBA_Erika_Insurance_Year_1_Single_BBA__c=110;
        fee.BBA_Erika_Insurnce_Year_2_Single_BBA__c=111;
        fee.BBA_Erika_Insurance_Year_3_Single_BBA__c=112;
        fee.BBA_Erika_Insurance_Year_4_Single_BBA__c=113;
        fee.BBA_Installment_Plan_Year_1_BBA__c=110;
        fee.BBA_Installment_Plan_Year_2_BBA__c=111;
        fee.BBA_Installment_Plan_Year_3_BBA__c=112;
        fee.BBA_Installment_Plan_Year_4_BBA__c=113;
        fee.BBA_Solo_P1_Year_1__c=120;
        fee.BBA_Twin_P2_Year_2__c=120;
        fee.BBA_Studio_P3_Year_3__c=120;
        fee.BBA_Apartment_P2_Year_4__c=120;
        feelst.add(fee);*/
        
        //for Non-BBA Finance
        Fees__c fee1=new Fees__c();
        fee1.Program_Name__c=pro1.id;
        fee1.Year__c='2014';
        fee1.Apartment_Vista_P3__c=101;
        fee1.Deluxe_Studio_Apartment_P3__c=105;
        //fee1.Solo_P2__c=106;
        feelst.add(fee1);
        
        insert feelst;
        
        //for BBA Finance
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.StageName = 'Accepted';
        opp.CloseDate = Date.today();
        opp.Program__c = pro.Id;
        opp.Start_Term__c='September 2014';
        opp.Start_Term__c='September'+' '+system.today().year();
        opp.Primary_Campus__c=pro.Campus__c;
        opplst.add(opp);
        //for Non-BBA Finance
        Opportunity op1=new opportunity();
        op1.Name='firstname';
        op1.StageName='Confirmed';
        op1.Start_Term__c='January 2014';
        op1.CloseDate=System.today();
        op1.Program__c=pro1.id;
        op1.Primary_Campus__c=pro1.Campus__c;
        opplst.add(op1);
        
        insert opplst;
        test.startTest();
        //for BBA Finance
        Opportunity_Finance__c fin=new Opportunity_Finance__c();
        fin.Opportunity__c=opp.id;
        fin.Fees__c=fee.id;
        fin.recordTypeId=nonbba_rectype;
        fin.Insurance__c='Single';
        fin.Installment_Plan__c='Installment Plan';
        fin.Financial_Aid_Category__c='Academic Excellence';
        fin.Scholarship_Amount__c=500;
        fin.Housing_Accommodation__c='solo';
        fin.Accommodation_weeks__c='36';
        opfinlst.add(fin);
        //for Non-BBA Finance
        opportunity_Finance__c fn=new Opportunity_finance__c();        
        fn.Opportunity__c=op1.id;
        fn.CurrencyIsoCode='USD';
        fn.Go_Ed_Loan_Amount__c=200;
        fn.Go_Ed_Loan_Amount_First_Rate_USD__c=200;
        fn.fees__c=fee1.id;
        opfinlst.add(fn);
        
        // for add_fee2finance trigger
        opportunity_Finance__c f=new Opportunity_finance__c();        
        f.Opportunity__c=op1.id;
        f.CurrencyIsoCode='USD';
        f.Go_Ed_Loan_Amount__c=200;
        f.Go_Ed_Loan_Amount_First_Rate_USD__c=200;
        f.fees__c=null;
        opfinlst.add(f);
        
        insert opfinlst;
                
        fin.BBA_Insurance_Picklist_Year_1__c='Erika Insurance';
        fin.BBA_Insurance_Picklist_Year_2__c='Erika Insurance';
        fin.BBA_Insurance_Picklist_Year_3__c='Erika Insurance';
        fin.BBA_Insurance_Picklist_Year_4__c='Erika Insurance';
        
        fin.BBA_Installment_Plan_Picklist__c='Installment Plan';
        fin.BBA_Installment_Plan_Picklist_Year_2__c='Installment Plan';
        fin.BBA_Installment_Plan_Picklist_Year_3__c='Installment Plan';
        fin.BBA_Installment_Plan_Picklist_Year_4__c='Installment Plan';
        
        fin.BBA_Accommodation_Year_1__c='solo';
        fin.BBA_Accommodation_Weeks_Year_1__c='36';
        fin.BBA_Accommodation_Year_2__c='twin';
        fin.BBA_Accommodation_Weeks_Year_2__c='43';
        fin.BBA_Accommodation_Year_3__c='studio';
        fin.BBA_Accommodation_Weeks_Year_3__c='51';
        fin.BBA_Accommodation_Year_4__c='apartment';
        fin.BBA_Accommodation_Weeks_Year_4__c='43';
        
        fin.recordTypeId=bba_rectype;
        update fin; 
        
        /*System.assertEquals(fin.BBA_Insurance_Year_1__c,fee.BBA_Erika_Insurance_Year_1_Single_BBA__c);
        System.assertEquals(fin.BBA_Insurance_Year_2__c,fee.BBA_Erika_Insurnce_Year_2_Single_BBA__c);
        System.assertEquals(fin.BBA_Insurance_Year_3__c,fee.BBA_Erika_Insurance_Year_3_Single_BBA__c);
        System.assertEquals(fin.BBA_Insurance_Year_4__c,fee.BBA_Erika_Insurance_Year_4_Single_BBA__c);
        
        System.assertEquals(fin.BBA_Installment_Plan_Year_1__c,fee.BBA_Installment_Plan_Year_1_BBA__c);
        System.assertEquals(fin.BBA_Installment_Plan_Year_2__c,fee.BBA_Installment_Plan_Year_2_BBA__c);
        System.assertEquals(fin.BBA_Installment_Plan_Year_3__c,fee.BBA_Installment_Plan_Year_3_BBA__c);
        System.assertEquals(fin.BBA_Installment_Plan_Year_4__c,fee.BBA_Installment_Plan_Year_4_BBA__c);
        
        System.assertEquals(fin.BBA_Accommodation_Fee_Year_1__c,fee.BBA_Solo_P1_Year_1__c);
        System.assertEquals(fin.BBA_Accommodation_Fee_Year_2__c,fee.BBA_Twin_P2_Year_2__c);
        System.assertEquals(fin.BBA_Accommodation_Fee_Year_3__c,fee.BBA_Studio_P3_Year_3__c);
        System.assertEquals(fin.BBA_Accommodation_Fee_Year_4__c,fee.BBA_Apartment_P2_Year_4__c);*/
        
        // updating 2nd time
        fin.BBA_Accommodation_Year_1__c='Dubai Housing Bursary';
        fin.BBA_Accommodation_Weeks_Year_1__c='45';
        fin.BBA_Accommodation_Year_2__c='Dubai Housing Bursary';
        fin.BBA_Accommodation_Weeks_Year_2__c='36';
        fin.BBA_Accommodation_Year_3__c='Dubai Housing Bursary';
        fin.BBA_Accommodation_Weeks_Year_3__c='35';
        fin.BBA_Accommodation_Year_4__c='Dubai Housing Bursary';
        fin.BBA_Accommodation_Weeks_Year_4__c='52';
        
        update fin;
        
        //Non-BBA Finance
        
        fn.Housing_Accommodation__c='Solo';
        fn.Accommodation_weeks__c='43';
        fn.Rot_Housing_Module_D__c='NYC - Housing - Single - Mod D';
        fn.Rot_Visa_Module_D__c='SHA - Housing - Type A - Mod E';
        fn.Rot_Insurance_Module_D__c='SHA - Housing - Type C1 - Mod E';
        fn.Rot_Housing_Module_E__c='SHA - Housing - Type E - Mod E';
        fn.Rot_Visa_Module_E__c='SHA - Housing - Dependent - Mod D';
        fn.Rot_Insurance_Module_E__c='Insurance - Erika - Mod E'; 
        update fn;
        
        System.assertEquals(fn.Annual_Accommodation_Fee__c,fee1.Solo_P2__c);
        test.stopTest();
    }
}