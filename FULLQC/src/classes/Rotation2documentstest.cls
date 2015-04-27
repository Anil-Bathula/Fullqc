/*

Test class for :: Rotation_selfupdates(100%)
rot_Create_update_rot_Docs(91%)
Update_rotationdocs (77%)
deps_Create_update_rot_Docs(87%)
update_dependent_docs(78%)
rot_visatrack (100%)
rot_autofee (77%)
*/

@IsTest(seealldata=true) 
private class Rotation2documentstest 
{
    public static List<Program__c> programs = [select Id from Program__c where Name like 'MBA-UK%' limit 10];
    static testMethod void Rotationtriggers()
    {
        string program1;
        if(!programs.IsEmpty())
            program1=programs[0].id;
        List<Visa_Track__c> cam_change=new List<Visa_Track__c>();
        List<Visa_Track__c> auto_fee=new List<Visa_Track__c>();
        List<Visa_Track__c> visatracks=[select id,Name,Campus1__c,Campus2__c from Visa_Track__c where (Campus1__c='Boston' and Campus2__c='San Francisco' and (NOT Name LIKE 'CAMPUS CHANGE%'))
                                        or (Name='China: X-2 Visa' or Name='UAE: Visitor Visa' or Name='UAE: EMBA Transit Visa')];
        for(Visa_Track__c vt:visatracks){
            if(vt.Campus1__c=='Boston' && vt.Campus2__c=='San Francisco'){
                cam_change.add(vt);
            }
            else if(vt.Name=='China: X-2 Visa' || vt.Name=='UAE: Visitor Visa' || vt.Name=='UAE: EMBA Transit Visa'){
                auto_fee.add(vt);
            }
        }
        
        Master_Rotation_Document__c mrd=new Master_Rotation_Document__c();
        mrd.Visa_Track__c=cam_change[0].Id;
        mrd.Applies_to_Student__c=true;
        mrd.Applies_to_Dependent__c=true;
        mrd.New_copy_in_all_rotations__c=true;
        insert mrd;
        
        Country__c country = new Country__c(Name='Test Country');
        insert country;
        
        Account account =TestDataUtil.createAccount('Testing account', 'Candidate');// new Account();
        
        insert account;
        System.debug(' ::Task_AssignOwnerTest:: step 1' +account.Id); 
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        if(RecordTypeHelper.getRecordTypeId('Contact','Student')!=null)
            contact.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact','Student');
        contact.Start_Term__c = 'Jan 2014';
        contact.LastName = 'LastName';
        contact.Program_Primary__c = program1;
        contact.AccountId = account.Id;
        contact.Country_Of_Citizenship__c = country.Id;
        contact.Country_Of_Origin__c = country.Id;
        contact.Country_Of_Residence__c = country.Id;
        insert contact;
        System.debug(' ::Task_AssignOwnerTest:: step 2' +contact.Id);  
        
        Rotation__c r1=new Rotation__c();
        r1.Active__c=true;
        r1.Student__c=contact.Id;
        r1.Rotation_Campus__c='San Francisco';
        r1.Earliest_Elective_Start_Date__c=System.today().addmonths(7);
        r1.Latest_Elective_End_Date__c=System.today().addmonths(13);
        r1.Type__c='Mod E';
        r1.Is_Rotating__c=true;
        //rots.add(r1);
        insert r1;
        
        Dependent__c d=new Dependent__c();
        //d.Rotation1__c=rots[0].Id;
        d.Rotation1__c=r1.Id;
        d.First_Name__c='t1';
        d.Last_Name__c='t2';
        d.Relationship__c='Child';
        d.Student__c=contact.Id;
        d.Have_second_Passport__c=true;
        d.Date_of_Birth__c=system.today().addyears(-1);
         insert d;
        contact.Have_second_Passport__c=true;
        update contact;
        
        r1.Visa_Track__c=cam_change[0].Id;
        update r1;
                
        List<Rotation__c> rots=new List<Rotation__c>();
        Rotation__c r=new Rotation__c();
        r.Active__c=true;
        r.Student__c=contact.Id;
        r.Rotation_Campus__c='Boston';
        r.Earliest_Elective_Start_Date__c=System.today().addmonths(1);
        r.Latest_Elective_End_Date__c=System.today().addmonths(3);
        r.Type__c='Mod D';
        r.Is_Rotating__c=true;
        insert r;
        
        d.Rotation2__c=r.Id;
        update d;
        r.Visa_Track__c=cam_change[1].Id;
        update r;
        
        //for rot_autofee trigger
        test.startTest();
        Opportunity op1=new opportunity();
        op1.Name='firstname';
        op1.StageName='Confirmed';
        op1.Start_Term__c='January 2014';
        op1.Contact__c=contact.Id;
        op1.CloseDate=System.today();
        op1.Program__c=program1;
        insert op1;
        
        opportunity_Finance__c fn=new Opportunity_finance__c();        
        fn.Opportunity__c=op1.id;
        fn.CurrencyIsoCode='USD';
        fn.Go_Ed_Loan_Amount__c=200;
        fn.Go_Ed_Loan_Amount_First_Rate_USD__c=200;
        insert fn;
        
        Rotation__c ro1=new Rotation__c();
        ro1.Active__c=true;
        ro1.Student__c=contact.Id;
        ro1.Rotation_Campus__c='Shanghai';
        ro1.Earliest_Elective_Start_Date__c=System.today().addmonths(1);
        ro1.Latest_Elective_End_Date__c=System.today().addmonths(3);
        ro1.Type__c='Mod D';
        ro1.Visa_Track__c=auto_fee[0].Id;
        ro1.Is_Rotating__c=true;
        insert ro1;
        
        ro1.Type__c='Mod E';
        ro1.Visa_Track__c=auto_fee[1].Id;
        update ro1;
        
        test.stopTest();
    }
    
    
    /*
    Rotation_dependents_ctrlr(73%)
    Rotation_documents_ctrlr(86%)
    
    */
    static testMethod void Rotation_vfpages()
    {
        string program1;
        if(!programs.IsEmpty())
            program1=programs[0].id;
        List<Visa_Track__c> visatracks=[select id,Name from Visa_Track__c where Campus1__c='Boston' and Campus2__c='San Francisco' and (NOT Name LIKE 'CAMPUS CHANGE%')];
        
        Master_Rotation_Document__c mrd=new Master_Rotation_Document__c();
        mrd.Visa_Track__c=visatracks[0].Id;
        mrd.Applies_to_Student__c=true;
        mrd.Applies_to_Dependent__c=true;
        mrd.New_copy_in_all_rotations__c=true;
        insert mrd;
        
         Country__c country = new Country__c(Name='Test Country');
         insert country;
        
        Account account =TestDataUtil.createAccount('Testing account', 'Candidate');// new Account();
        
        insert account;
        System.debug(' ::Task_AssignOwnerTest:: step 1' +account.Id); 
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        if(RecordTypeHelper.getRecordTypeId('Contact','Student')!=null)
            contact.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact','Student');
        contact.Start_Term__c = 'Jan 2014';
        contact.LastName = 'LastName';
        contact.Program_Primary__c = program1;
        contact.AccountId = account.Id;
        contact.Country_Of_Citizenship__c = country.Id;
        contact.Country_Of_Origin__c = country.Id;
        contact.Country_Of_Residence__c = country.Id;
        insert contact;
        System.debug(' ::Task_AssignOwnerTest:: step 2' +contact.Id);  
        
        Rotation__c r1=new Rotation__c();
        r1.Active__c=true;
        r1.Student__c=contact.Id;
        r1.Rotation_Campus__c='San Francisco';
        r1.Earliest_Elective_Start_Date__c=System.today().addmonths(7);
        r1.Latest_Elective_End_Date__c=System.today().addmonths(13);
        r1.Type__c='Mod E';
        r1.Visa_Track__c=visatracks[0].Id;
        r1.Is_Rotating__c=true;        
        insert r1;
        
        Dependent__c d=new Dependent__c();
        d.Rotation1__c=r1.Id;
        d.First_Name__c='t1';
        d.Last_Name__c='t2';
        d.Relationship__c='Child';
        d.Student__c=contact.Id;
        d.Have_second_Passport__c=true;
        d.Date_of_Birth__c=system.today().addyears(-1);
        insert d;    
        
        ApexPages.StandardController rotdocctrlr= new ApexPages.StandardController(r1);
        ApexPages.CurrentPage().getParameters().put('id',r1.id);
        
        Rotation_documents_ctrlr rdocctrlr=new Rotation_documents_ctrlr (rotdocctrlr);
         rdocctrlr.newbtn();         
         rdocctrlr.cancelbtn();
         rdocctrlr.getfiltervals() ;
         rdocctrlr.getopt_docsvals();       
         rdocctrlr.savebtn();
         
        Rotation_dependents_ctrlr  rdc= new Rotation_dependents_ctrlr (rotdocctrlr);
        rdc.init();
        rdc.New_dep();
        rdc.add_blankdep();
        rdc.save_deps();
        rdc.cancl();
        ApexPages.CurrentPage().getParameters().put('depsid',d.id);
        rdc.delete_dep();    
         
         
    }
}