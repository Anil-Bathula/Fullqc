/*
rotationvisaportal (86%)
documentpagecontroller (83%)
student_login_ctrlr (88%)
*/
@IsTest(seealldata=true) 
public class rotationvisaportal_Test{
    public static List<Program__c> programs = [select Id from Program__c where Name like 'MBA-UK%' limit 10];
    static testMethod void rot_visaportal()
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
        
        Account account =TestDataUtil.createAccount('Testing account', 'Candidate');
        insert account; 
        
        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        if(RecordTypeHelper.getRecordTypeId('Contact','Student')!=null)
            contact.RecordTypeId=RecordTypeHelper.getRecordTypeId('Contact','Student');
        contact.Start_Term__c = 'Jan 2014';
        contact.LastName = 'LastName';
        contact.MobilePhone='12234567879';
        contact.City_Of_Birth__c='test';
        //contact.birthdate=system.Today()-10000;
        contact.Relationship_Status__c='single';
        contact.Languages__c='test';
        contact.Rotation_Interests__c='test';
        contact.Rotation_Interest_Event_Type__c='test';
        contact.Rotation_Avg_Entrance_Fee_Amount__c=1000;
        contact.Rotation_Housing_Plans__c='Find independent lease or sub-let';
        contact.Rotation_Housing_Resources_Plan__c='Other';
        contact.Program_Primary__c = program1;
        contact.AccountId = account.Id;
        contact.Country_Of_Citizenship__c = country.Id;
        contact.Country_Of_Origin__c = country.Id;
        contact.Country_Of_Residence__c = country.Id;
        insert contact;
        
        Opportunity opp= new Opportunity();
        opp.Name = 'OpportunityName';
        opp.Contact__c=contact.id;
        opp.StageName = 'StageName';
        opp.CloseDate = Date.today();
        opp.Program__c = program1;
        insert opp;
        
        Opportunity_Finance__c oppfin=new Opportunity_Finance__c();
        oppfin.Opportunity__c=opp.id;
        oppfin.Rot_Housing_Module_D__c='London - Apartment - Mod D';
        oppfin.Rot_Housing_Module_E__c='London - Apartment - Mod E';
        oppfin.Rot_Insurance_Module_D__c='Insurance - Erika - Mod D';
        oppfin.Rot_Insurance_Module_E__c='Insurance - Erika - Mod E';
        insert oppfin;
        test.startTest();
        List<Rotation__c> rotlst=new List<Rotation__c>();
        Rotation__c r1=new Rotation__c();
        r1.Active__c=true;
        r1.Student__c=contact.Id;
        r1.Rotation_Campus__c='San Francisco';
        r1.Earliest_Elective_Start_Date__c=System.Today();
        r1.Latest_Elective_End_Date__c=System.Today()+5;
        r1.Type__c='Mod E';
        r1.Rot_Housing_Module_E__c='San Francisco - Premium Single - Mod E';
        r1.Booking_Policy__c=true;
        r1.Visa_Track__c=visatracks[0].Id;
        r1.Is_Rotating__c=true;
        rotlst.add(r1);
        
        Rotation__c r2=new Rotation__c();
        r2.Active__c=true;
        r2.Student__c=contact.Id;
        r2.Rotation_Campus__c='Shanghai';
        r2.Earliest_Elective_Start_Date__c=System.Today();
        r2.Latest_Elective_End_Date__c=System.Today()+5;
        r2.Type__c='Mod D';
        r2.Rot_Housing_Module_D__c='Shanghai - Suite - Mod D';
        r2.Booking_Policy__c=true;
        r2.Visa_Track__c=visatracks[0].Id;
        r2.Is_Rotating__c=true;
        rotlst.add(r2);
        
        insert rotlst;
        
        Rotation_Documents__c rd1=new Rotation_Documents__c();
        rd1.Name='Second Passport';
        rd1.Rotation1_VisaTrack__c=visatracks[0].Id;
        rd1.Rotation1__c=r1.id;
        insert rd1;
        
        List<Dependent__c> deps=new List<Dependent__c>();
        Dependent__c d=new Dependent__c();
        d.Rotation1__c=r1.Id;
        d.First_Name__c='t1';
        d.Last_Name__c='t2';
        d.Relationship__c='Child';
        d.Student__c=contact.Id;
        d.Have_second_Passport__c=true;
        d.Gender__c='male';
        d.Date_of_Birth__c=system.today().addyears(-1);
        insert d;  
        deps.add(d); 
                
        Rotation_Documents__c rd2=new Rotation_Documents__c();
        rd2.Name='Second Passport';
        rd2.Passport_issued_country__c=country.id;
        rd2.Passport_Number__c='1234';
        rd2.Passport_Issue_Date__c=system.today()-30;
        rd2.Passport_Expiration_Date__c=system.today()+30;
        rd2.EXACT_Passport_First_Name__c='test';
        rd2.EXACT_Passport_Family_Name__c='test';
        rd2.Passport_Type__c='test';
        rd2.Rotation1_VisaTrack__c=visatracks[0].Id;
        rd2.Rotation1__c=r1.id;
        rd2.supplied__c=true;
        rd2.Dependent__c=d.id;
        rd2.Created_from_Visatrack_Portal__c=false;
        insert rd2; 
        
        Attachment attachment = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.Body = bodyBlob;
        attachment.Name =  'caseAttachment';
        attachment.ParentId = rd2.id;
        insert attachment;
        
        student_login_ctrlr stdlog=new student_login_ctrlr();
        stdlog.login();
        stdlog.redirect2forgetpwd();
        stdlog.Sent_email();
        stdlog.cancel();
        stdlog.forgotPassword();
        
        documentpagecontroller dpc=new documentpagecontroller();
        
        ApexPages.currentPage().getParameters().put('student_id',contact.id);
        ApexPages.currentPage().getParameters().put('id',r1.id);
        ApexPages.CurrentPage().getParameters().put('depsid',d.id);
        ApexPages.currentPage().getParameters().put('doc',rd2.id);
        ApexPages.currentPage().getParameters().put('savetype','save_andatach');
        ApexPages.currentPage().getParameters().put('tab2','Rotationinfo');
        ApexPages.currentPage().getParameters().put('home_page','hme_redct');
        
        dpc.attach=attachment;
        dpc.init();
        dpc.tabmethod();
        dpc.getrotdocs();
        dpc.dispdocs();
        dpc.getclist();
        dpc.saveand();
        
        dpc=new documentpagecontroller();
        ApexPages.currentPage().getParameters().put('student_id',contact.id);
        ApexPages.currentPage().getParameters().put('id',r1.id);
        ApexPages.CurrentPage().getParameters().put('depsid',d.id);
        ApexPages.currentPage().getParameters().put('doc',rd2.id);
        ApexPages.currentPage().getParameters().put('home_page','hme_redct');
        ApexPages.currentPage().getParameters().put('tab3','dependents');
        dpc.attach=attachment;
        dpc.init();
        dpc.tabmethod();
        dpc.getrotdocs();
        dpc.dispdocs();
        dpc.saveand();
        
        dpc=new documentpagecontroller();
        ApexPages.currentPage().getParameters().put('student_id',contact.id);
        ApexPages.currentPage().getParameters().put('id',r1.id);
        ApexPages.CurrentPage().getParameters().put('depsid',d.id);
        ApexPages.currentPage().getParameters().put('doc',rd2.id);
        ApexPages.currentPage().getParameters().put('home_page','hme_redct');
        ApexPages.currentPage().getParameters().put('tab4','accommdat');
        dpc.attach=attachment;
        dpc.init();
        dpc.tabmethod();
        
        dpc=new documentpagecontroller();
        ApexPages.currentPage().getParameters().put('doc',null);
        ApexPages.currentPage().getParameters().put('home_page','hme_redct');
        ApexPages.currentPage().getParameters().put('tab1','home');
        dpc.init();
        dpc.tabmethod();
        dpc.saveand();
        
        rotationvisaportal rotcntlr=new rotationvisaportal();
        
        ApexPages.currentPage().getParameters().put('id',contact.id);
        ApexPages.currentPage().getParameters().put('Rec',r1.id);
        ApexPages.currentPage().getParameters().put('Rec2','True');
        ApexPages.currentPage().getParameters().put('rotinfo','rotinfo');
        ApexPages.currentPage().getParameters().put('tab1','home');
        
        rotcntlr.init();
        rotcntlr.rotmethod();
        rotcntlr.closePopup();
        rotcntlr.detailPage() ;
        rotcntlr.detail_rotPage(); 
        rotcntlr.tabmethod();
        rotcntlr.cancelmethod() ;  
        rotcntlr.getclist();
        rotcntlr.getsec_pass(); 
        rotcntlr.getrediovals();
        rotcntlr.getinsur_vals();
        rotcntlr.getrothosmodd();
        rotcntlr.getrothosmode();  
        rotcntlr.birthdate='15/07/1990';         
        rotcntlr.save_rotcontact(); 
        rotcntlr.save_rot();
        rotcntlr.init_dependents();
        rotcntlr.delete_dep();
        rotcntlr.New_dep() ;
        rotcntlr.add_newdep();       
        rotcntlr.add_blankdep();
        //rotcntlr.save_deps(); 
        rotcntlr.save_accm();
        rotcntlr.create2passport(deps);
        rotcntlr.cancl();
        rotcntlr.getrot_values();   
        
        contact.Mydetails_Rotation_Tab_Completed__c=true;
        contact.MobilePhone=null;
        contact.Relationship_Status__c=null;
        contact.Languages__c=null;
        contact.Rotation_Interests__c=null;
        contact.Rotation_Interest_Event_Type__c=null;
        contact.Rotation_Avg_Entrance_Fee_Amount__c=null;
        contact.Rotation_Housing_Plans__c=null; 
        contact.Country_Of_Residence__c = null;
        contact.Country_Of_Citizenship__c=null;
        update contact;
        
        rotcntlr=new rotationvisaportal();
        ApexPages.currentPage().getParameters().put('depend','depend');
        ApexPages.currentPage().getParameters().put('tab1','home');
        rotcntlr.disp_rotdoc=rd1;
        rotcntlr.init();
        rotcntlr.rotmethod();
        rotcntlr.detail_rotPage();
        rotcntlr.save_rotcontact(); 
        rotcntlr.init_dependents();
        rotcntlr.tabmethod();
       // rotcntlr.create_deps.add(new rotationvisaportal.createdeps(true,d));
        rotcntlr.save_deps(); 
        rotcntlr.create2passport(deps); 
        
        rotcntlr=new rotationvisaportal();
        ApexPages.currentPage().getParameters().put('tab3','dependents');
        rotcntlr.init();
        rotcntlr.rotmethod();
        rotcntlr.detail_rotPage();
        rotcntlr.save_rotcontact(); 
        rotcntlr.init_dependents();
        rotcntlr.tabmethod();
        Test.stopTest();
        rotcntlr=new rotationvisaportal();
        ApexPages.currentPage().getParameters().put('accomm','accomm');
        ApexPages.currentPage().getParameters().put('tab4','accommdat');
        rotcntlr.init();
        rotcntlr.rotmethod();
        rotcntlr.detail_rotPage();
        rotcntlr.save_rotcontact(); 
        rotcntlr.init_dependents();
        rotcntlr.tabmethod();
        rotcntlr.save_accm();
        
        List<Rotation__c> updtrotlst=new List<Rotation__c>();
        r1.Visa_Track_Added__c=true;
        r1.Rot_Housing_Module_D__c=null;
        r1.Rotation_Campus__c='London';
        updtrotlst.add(r1);
        
        r2.Rotation_Campus__c='New York';
        updtrotlst.add(r2);
        
        update updtrotlst;
        
        rotcntlr=new rotationvisaportal();
        rotcntlr.init();
        rotcntlr.rotmethod();
        rotcntlr.detail_rotPage();
        rotcntlr.save_rotcontact(); 
        rotcntlr.init_dependents();
        ApexPages.currentPage().getParameters().put('tab5','Document');
        rotcntlr.tabmethod();
        
        delete r1;
        rotcntlr=new rotationvisaportal();
        rotcntlr.rotation=true;
        rotcntlr.init();
        rotcntlr.rotmethod();
        
    }
}