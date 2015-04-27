@isTest
public class Finance_test {
	@testSetup static void DataArrange(){  
         Country__c country=TestDataUtil.createCountry();
        insert country;
        
        City__c city=new City__c();
        city.Name='testCity';
        city.Country__c=country.Id;
        insert city;
        
        Department__c department=TestDataUtil.createDepartment();
        insert department;
        
        List<program__c> pgms=new List<program__c>();
        Program__c program=TestDataUtil.createProgram(country.id, department.Id);
        Program.Name='MBA-US-San Francisco';
        program.Program_pre_Parsed__c='MBA';
        program.Campus__c='San Francisco';
        pgms.add(program);
        
        Program__c program1=TestDataUtil.createProgram(country.id, department.Id);
        program1.Program_pre_Parsed__c='BBA';
        Program1.Name='Bachelor of Business Administration-UK-London';
        program1.Campus__c='London';
        pgms.add(program1);        
        insert pgms;
        
        Installment_Plan_Multiplier_Values__c  ip=new Installment_Plan_Multiplier_Values__c();
        ip.inst1_Accommodation_Deposit__c=.01;
        ip.inst1_Annual_Accommodation_Fee__c=.03;
        ip.inst1_Course_Deposit_Paid__c=0.03;
        ip.inst1_Course_Deposit_Paid__c=.05;
        ip.inst1_Due_Date_Offset_days__c=50;
        ip.inst1_Tuition_Fee__c=.02;
        insert ip;
        
        List<Fees__c> fes=new List<Fees__c>() ;
        Fees__c f=new Fees__c() ;
        f.Year__c='2008';
        f.Program_Name__c=pgms[0].Id;
        f.Application_Fee__c=150;
        f.Confirmation_Deposit__c=1000;
        f.Installment_Plan__c=ip.Id;
        f.Installment_Plan_Flex__c=ip.Id;
        f.No_Installment_Plan__c=ip.Id;
        f.No_FlexiPlan__c=ip.Id;
        f.Year__c='2014';
        f.Apartment_Vista_P3__c=101;
        f.Deluxe_Studio_Apartment_P3__c=105;
        fes.add(f);
        
        Fees__c f1=new Fees__c() ;
        f1.Year__c='2008';
        f1.Program_Name__c=pgms[1].Id;
        f1.Application_Fee__c=150;
        f1.Confirmation_Deposit__c=1000;
        f1.Installment_Plan__c=ip.Id;
        f1.Installment_Plan_Flex__c=ip.Id;
        f1.No_Installment_Plan__c=ip.Id;
        f1.No_FlexiPlan__c=ip.Id;
        f1.BBA_Apartment_P1_Year_1__c=100;
        f1.BBA_Apartment_P2_Year_1__c=101;
        f1.BBA_Apartment_P3_Year_1__c=102;
        f1.Bunk_Studio_P1__c=105;
        f1.Bunk_Studio_Vista_P1__c=106;
        f1.BBA_Deluxe_Studio_Apart_P2_Year_3__c=104;
        f1.BBA_Deluxe_Studio_Apart_P3_Year_2__c=110;
        f1.BBA_Erika_Insurance_Year_1_Single_BBA__c=110;
        f1.BBA_Erika_Insurnce_Year_2_Single_BBA__c=111;
        f1.BBA_Erika_Insurance_Year_3_Single_BBA__c=112;
        f1.BBA_Erika_Insurance_Year_4_Single_BBA__c=113;
        f1.BBA_Installment_Plan_Year_1_BBA__c=110;
        f1.BBA_Installment_Plan_Year_2_BBA__c=111;
        f1.BBA_Installment_Plan_Year_3_BBA__c=112;
        f1.BBA_Installment_Plan_Year_4_BBA__c=113;
        f1.BBA_Solo_P1_Year_1__c=120;
        f1.BBA_Twin_P2_Year_2__c=120;
        f1.BBA_Studio_P3_Year_3__c=120;
        f1.BBA_Apartment_P2_Year_4__c=120;
        fes.add(f1);
        insert fes;
        
        list<Contact> cons=new list<Contact>();
        Contact c=TestDataUtil.createContact(pgms[0].Id);
        c.FirstName='c';
        c.LastName='Finance_test';
        c.Applicant_Email__c='Finance_testclass@test.com';
        c.Email='Finance_testclass@test.com';
        c.Country_Of_Residence__c=country.Id;
        cons.add(c);
        Contact c1=TestDataUtil.createContact(pgms[1].Id);
        c1.FirstName='c';
        c1.LastName='Finance_test';
        c1.Applicant_Email__c='Finance_bba_testclass@test.com';
        c1.Email='Finance_bba_testclass@test.com';
        c1.Country_Of_Residence__c=country.Id;
        cons.add(c1);
        insert cons;
            
        list<opportunity> opps = new list<opportunity>();
        Opportunity o=new Opportunity(Name='test',contact__c=cons[0].Id);
        o.program__c=program.Id;
        o.stageName='Confirmed';
        o.Start_Term__c='September 2008';
        o.CloseDate=System.today().addYears(1);
        opps.add(o);
        Opportunity o1=new Opportunity(Name='test',contact__c=cons[1].Id);
        o1.program__c=program1.Id;
        o1.stageName='Confirmed';
        o1.Start_Term__c='September 2008';
        o1.CloseDate=System.today().addYears(1);
        opps.add(o1);
        
        insert opps;
    	
        List<Opportunity_Finance__c> fins=new List<Opportunity_Finance__c>();
        Opportunity_Finance__c fin=new Opportunity_Finance__c(Opportunity__c=o.Id,
			Installment_Plan__c='No Installment Plan',
		RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance'));
        Opportunity_Finance__c fin1=new Opportunity_Finance__c(Opportunity__c=o1.Id,
			Installment_Plan__c='Installment Plan flex',fees__c=fes[1].Id,
		RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','Non-BBA Finance'));
        fins.add(fin);
        fins.add(fin1);        
        insert fins;
        
        
    }
    
   static testmethod void mapping_finwithfee_test(){
        Opportunity_Finance__c fin;
        Opportunity_Finance__c fn;
        for(Opportunity_Finance__c fins:[select id,Name,Opportunity__c,Opportunity__r.contact__c,Installment_Plan__c,OP_Program__c  
			from Opportunity_Finance__c where Opportunity__r.contact__r.Email='Finance_testclass@test.com' or 
            Opportunity__r.contact__r.Email='Finance_bba_testclass@test.com']){
                if(fins.OP_Program__c.startsWith('Bachelor')){
                    fin=new Opportunity_Finance__c(id=fins.Id);
                }
                else
                {
                    fn=new Opportunity_Finance__c(id=fins.Id);
                }
		}
        
        //Opportunity_Finance__c fin=new Opportunity_Finance__c(id=fins[1].Id);
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
        fin.RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');        
        update fin; 
        
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
 		//Opportunity_Finance__c fn=new Opportunity_Finance__c(id=fins[0].Id);       
        fn.Housing_Accommodation__c='Solo';
        fn.Accommodation_weeks__c='43';
        fn.Rot_Housing_Module_D__c='NYC - Housing - Single - Mod D';
        fn.Rot_Visa_Module_D__c='SHA - Housing - Type A - Mod E';
        fn.Rot_Insurance_Module_D__c='SHA - Housing - Type C1 - Mod E';
        fn.Rot_Housing_Module_E__c='SHA - Housing - Type E - Mod E';
        fn.Rot_Visa_Module_E__c='SHA - Housing - Dependent - Mod D';
        fn.Rot_Insurance_Module_E__c='Insurance - Erika - Mod E'; 
        update fn;
        
       fin.RecordTypeId=RecordTypeHelper.getRecordTypeId('Opportunity_Finance__c','BBA Finance');        
       update fin;
        
    }
        
    
    
}