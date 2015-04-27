@isTest(SeeAllData=true)
public with sharing class contact_new_detail_page_test {
/*
    Developer : Harsha Simha
        Test class for : new_ctct_attachments_ctrlr,new_ui_event_ctrlr
*/	
	 public static testmethod void test_ctct_inlinevfs()
	 {
	 	List<user> usr=[select id,UserName,profileid,Profile.Name from user where Profile.Name='System Administrator'];
	 	/*if(!usr.IsEmpty()){
	 		system.runAs(usr[0]);}*/
	 		
		Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        ctry.Flags__c='richtext<img src="asdfsafd"/>';
        insert ctry;
        
        Department__c objDept = TestDataUtil.createDepartment();
        Database.insert(objDept);
        
        Program__c objPro = TestDataUtil.createProgram(ctry.Id, objDept.Id);
        Database.insert(objPro);
        
        Account objAcc = TestDataUtil.createAccount();
        Database.insert(objAcc);
        
        Contact objCon = TestDataUtil.createContact(objPro.id);
        Database.insert(objCon);
        
        Event ev=new Event();
        datetime myDateTime = System.Today().addDays(5);
        ev.StartDateTime=myDateTime;
        ev.EndDateTime=myDateTime.addHours(1);
        ev.WhoId=objcon.id;
        insert ev;
        
        Task ts=new Task();
        ts.whoId=objcon.ID;
        ts.Program__c=objpro.id;
        ts.Phone__c=objcon.Phone;
        ts.Status='Completed';
        insert ts;
        
        Task ts1=new Task();
        ts1.whoId=objcon.ID;
        ts1.Program__c=objpro.id;
        ts1.Phone__c=objcon.Phone;
        ts1.Status='Progress';
        insert ts1;
        
        Attachment attch= new Attachment();
        attch.ParentId=objcon.id;
        attch.Name='name';
        attch.Body=Blob.valueof('myBlob');
        attch.ContentType='text/plain';
        insert attch;
        
		
        ev.StartDateTime=system.Now();
        ev.EndDateTime=system.Now().addMinutes(10);
        update ev;  
        test.startTest(); 
        //for Contact Events page controller   
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(objcon);
        Apexpages.currentPage().getparameters().put('id',objcon.id);     
        new_ui_event_ctrlr ctctevts=new new_ui_event_ctrlr(ctrlr);
        
        ctctevts.init();
        ctctevts.init_ctct();
        ctctevts.editeventid=ev.id;
        ctctevts.viewintrvw();
        ctctevts.donothing();
        system.debug(ctctevts.getselectedtimeslot());
        system.debug(ctctevts.getstimeslot());
        
        ev.StartDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 0, 0, 0));
        ev.EndDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 30, 0, 0));
        update ev;
        ctctevts.init_ctct();
        
        ev.StartDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 30, 0, 0));
        ev.EndDateTime=Datetime.newInstance(system.today(), Time.newInstance(11, 0, 0, 0));
        update ev;        
        ctctevts.init_ctct();
        ctctevts.schedule_intrvw();

		
     // ldevts.set_intrvw_date=system.today();
        ctctevts.set_intrvw_time='10.30';
        ctctevts.set_intrvw_date=system.today();
        ctctevts.schedule_intrvw();
        ctctevts.intrvw_datechange();       
        ctctevts.editeventid=ev.id;
        
        ctctevts.del_intervw();
        objcon.Interview_status__c='Booked';
        update objcon;
        ctctevts.init_ctct();
        
        ctctevts.set_intrvw_date=system.today();
        ctctevts.set_intrvw_time='12.00';
        ctctevts.schedule_intrvw();
        ctctevts.set_intrvw_date=system.today().adddays(-1);
        ctctevts.schedule_intrvw();
        
        
        ctctevts.set_intrvw_date=system.today().adddays(1);
        ctctevts.schedule_intrvw();
        ctctevts.init_interview_Status_table();
        if(ctctevts.intstatsset.size()>0){ctctevts.intstatsset[0].intstats='Completed';}
        ctctevts.save_interview_Status_table();
        
        
        Event ev1=new Event();
        datetime myDateTime1 = System.Today();
        ev1.StartDateTime=myDateTime1;
        ev1.EndDateTime=myDateTime1.addHours(1);
        ev1.WhoId=objcon.id;
        ev1.Subject='Phone Interview';
        ev1.Interview_Status__c='Booked';
        insert ev1;
        
        ctctevts.ownerchngd();
        ctctevts.getremaindertime();
        ctctevts.getsubvals();
        ctctevts.edit_closed_interviews();
        If(!ctctevts.lst_interview_schdls.isEmpty())
        {
        	ctctevts.intstatsset[0].intstats='Cancelled';
        }
        ctctevts.ask_save_interview_Status_table();
        ctctevts.save_canceledintrvs();
        
        //for Contact Attachments controller   
        new_ctct_attachments_ctlr ctctattch=new new_ctct_attachments_ctlr(ctrlr);
        ctctattch.newattach();
        ctctATTCH.cancelattach();        
        string bdy='tetstattchmnt';
        ctctattch.newattach();
        
        ctctattch.attchmnt.name='tetstattchmnt.txt';
        ctctattch.attchmnt.body=blob.valueof(bdy);
        ctctattch.attchmnt.ContentType='.txt';        
        ctctattch.upattach();
        ctctattch.editattchid=attch.id;
        ctctattch.editattach();
        ctctattch.saveattach();
        ctctattch.delattach();   
        
        
        
        Test.stopTest();
	 }
}