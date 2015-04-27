@isTest
public class lead_newdetailpagectrlr_Test{
/*
    Developer : Harsha Simha
        Test class for : New_lead_headers_ctrlr , new_lead_attachments_ctrlr,new_lead_ui_event_ctrlr
*/	
    public static testmethod void test_lead_inlinevfs(){
        
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
        ctry.Flags__c='richtext<img src="asdfsafd"/>';
        insert ctry;
        
        Program__c pro =new Program__c();
        pro.name='MBA';
        insert pro;
        
        Setting_Disabled__c obj=new Setting_Disabled__c();
        obj.Lead_OverrideCountries__c=false;
        insert obj;
       
        Lead led = new Lead();
        led.Company = 'Company';
        led.FirstName = 'FirstName';
        led.LastName = 'LastName';
        led.Status='Open';
        led.Email = 'lead11123@testmail.com';
        led.Applicant_Email__c = 'lead11123@testmail.com';
        led.Phone='123456';
        led.MobilePhone='+91-(0)-9874506789';
        led.Country_Of_Residence__c = ctry.Id;
        led.LeadSource = 'GMASS';
        led.Program_Primary__c = pro.id;
        insert led;
        
        Id currleadid=led.id;
        
        Event ev=new Event();
        datetime myDateTime = System.Today().addDays(5);
        ev.StartDateTime=myDateTime;
        ev.EndDateTime=myDateTime.addHours(1);
        ev.WhoId=led.id;
        insert ev;
        
        Task ts=new Task();
        ts.whoId=led.ID;
        ts.Program__c=pro.id;
        ts.Phone__c=led.Phone;
        ts.Status='Completed';
        insert ts;
        
        Task ts1=new Task();
        ts1.whoId=led.ID;
        ts1.Program__c=pro.id;
        ts1.Phone__c=led.Phone;
        ts1.Status='Progress';
        insert ts1;
        
        Attachment attch= new Attachment();
        attch.ParentId=led.id;
        attch.Name='name';
        attch.Body=Blob.valueof('myBlob');
        attch.ContentType='text/plain';
        insert attch;
        
        Comments__c c=new Comments__c();
        //c.Name='comments';
        c.Lead__c=led.id;
        insert c;
        
        test.startTest();
        
        //for opportunity Headers controller
        
        PageReference pageRef = Page.new_lead_headers;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',led.id);
        
        ApexPages.StandardController ctrlr=new ApexPages.StandardController(led);
        new_lead_headers_ctrlr ldhdrs=new new_lead_headers_ctrlr(ctrlr);
        ldhdrs.init();

        ev.StartDateTime=system.now().addhours(-1);
        ev.EndDateTime=system.now().addHours(1);
        update ev;
        ldhdrs.init();

        
        
        pageRef = Page.new_lead_ui_event;
        Test.setCurrentPage(pageRef);
        Apexpages.currentPage().getparameters().put('id',led.id);       
        
        //for Lead Attachments controller
        new_lead_attachments_ctlr ldattch=new new_lead_attachments_ctlr(ctrlr);
        ldattch.newattach();
        LDATTCH.cancelattach();
        
        string bdy='tetstattchmnt';
        Attachment at=new Attachment();
        at.name='tetstattchmnt.txt';
        at.body=blob.valueof(bdy);
        at.ContentType='.txt';
        at.PArentId=led.Id;
        insert at;
        ldattch.newattach();
        
        ldattch.attchmnt.name='tetstattchmnt.txt';
        ldattch.attchmnt.body=blob.valueof(bdy);
        ldattch.attchmnt.ContentType='.txt';
        //ldattch.attchmnt.BodyLength=bdy.length;
        ldattch.upattach();
        ldattch.editattchid=at.id;
        ldattch.editattach();
        ldattch.saveattach();
        ldattch.delattach();
        
        
        //for Lead Events page controller   
        ev.StartDateTime=system.Now();
        ev.EndDateTime=system.Now().addMinutes(10);
        update ev;
        new_lead_ui_event_ctrlr ldevts=new new_lead_ui_event_ctrlr(ctrlr);
        ldevts.init_lead();
        ldevts.editeventid=ev.id;
        ldevts.viewintrvw();
        ldevts.donothing();
        system.debug(ldevts.getselectedtimeslot());
        system.debug(ldevts.getstimeslot());
        
        ev.StartDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 0, 0, 0));
        ev.EndDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 30, 0, 0));
        update ev;
        ldevts.init_lead();
        
        ev.StartDateTime=Datetime.newInstance(system.today(), Time.newInstance(10, 30, 0, 0));
        ev.EndDateTime=Datetime.newInstance(system.today(), Time.newInstance(11, 0, 0, 0));
        update ev;
        ldevts.init_lead();
        ldevts.schedule_intrvw();

     // ldevts.set_intrvw_date=system.today();
        ldevts.set_intrvw_time='10.30';
        ldevts.set_intrvw_date=system.today();
        ldevts.schedule_intrvw();
        ldevts.intrvw_datechange();
       // ldevts.schedule_intrvw();
        ldevts.editeventid=ev.id;
        
        ldevts.del_intervw();
        led.Interview_status__c='Booked';
        update led;
        ldevts.init_lead();
        
        ldevts.set_intrvw_date=system.today();
        ldevts.set_intrvw_time='12.00';
        ldevts.schedule_intrvw();
        ldevts.set_intrvw_date=system.today().adddays(-1);
        ldevts.schedule_intrvw();
        
        
        ldevts.set_intrvw_date=system.today().adddays(1);
        ldevts.schedule_intrvw();
        
        ldevts.init_interview_Status_table();
        if(ldevts.intstatsset.size()>0){ldevts.intstatsset[0].intstats='Completed';}
        ldevts.save_interview_Status_table();
        
        
        Event ev1=new Event();
        datetime myDateTime1 = System.Today();
        ev1.StartDateTime=myDateTime1;
        ev1.EndDateTime=myDateTime1.addHours(1);
        ev1.WhoId=led.id;
        ev1.Subject='Phone Interview';
        ev1.Interview_Status__c='Booked';
        insert ev1;
        
        ldevts.ownerchngd();
        ldevts.getremaindertime();
        ldevts.getsubvals();
        ldevts.edit_closed_interviews();
        If(!ldevts.lst_interview_schdls.isEmpty())
        {
        	ldevts.intstatsset[0].intstats='Cancelled';
        }
        ldevts.ask_save_interview_Status_table();
        ldevts.save_canceledintrvs();
        
        
        
        test.stopTest();
        
        
        /*lead_newdetailpagectrlr l1=new lead_newdetailpagectrlr(xyz);
       
        l1.disp_events=[select id, StartDateTime,EndDateTime,OwnerId ,phone__c From Event where OwnerID=:Userinfo.getUserId() and StartDateTime>=:ev.StartDateTime and EndDateTime<=:ev.EndDateTime];
        l1.selectedt_intrvw_time='0.3';
        l1.init_interviewscdules(Date.valueOf(ev.StartDateTime));
        
        l1.selectedt_intrvw_time='0.3';
        l1.set_intrvw_date=System.Today().addDays(10);
        l1.set_intrvw_time='9.0';
        l1.schedule_intrvw();
        
        l1.selectedt_intrvw_time='9';
        l1.set_intrvw_date=System.Today().addDays(10);
        l1.set_intrvw_time='9.30';
        l1.schedule_intrvw();
        
        l1.set_intrvw_date=System.Today();
        l1.intrvw_datechange();
        l1.getselectedtimeslot();
        
        l1.set_intrvw_date=null;
        l1.schedule_intrvw();
        l1.set_intrvw_date=System.Today()-1;
        l1.schedule_intrvw();
        l1.set_intrvw_date=System.Today();
        l1.set_intrvw_time='9.0';
        l1.schedule_intrvw();
        
        l1.mapevents.put(ev.Id,ev);
        l1.editeventid=ev.id;
        l1.del_intervw();
        l1.mapevents.put(ev.Id,ev);
        l1.editeventid=ev.id;
        l1.set_intrvw_date=null;
        l1.del_intervw();
        
        l1.currleadid=led.id;
        l1.get_exist_intrvw_times=l1.init_interviewscdules(Date.valueOf(ev.StartDateTime));
        //l1.currlead_rec.Country_Of_Residence__r.Flags__c=ctry.Flags__c;
        l1.init_lead();
        
        l1.editlead();
        l1.savelead();
        l1.refrsh();
        l1.getstimeslot();
        
        l1.editeventid=ev.id;
        l1.editeventid=ev.id;
        l1.viewintrvw();
        
        l1.donothing();
        l1.currleadid=led.id;
        l1.initattachments();
        l1.newattach();
        l1.editattchid=attch.id;
        l1.editattach();
        l1.saveattach();
        l1.cancelattach();
        l1.editcmntid=c.id;
        l1.delattach();
        
        l1.currleadid=led.id;
        l1.init_activtes();
        l1.view_activtes();
        
        
        l1.back();
        l1.init_comments();
        l1.Newcomment();
        l1.editcomment();
        l1.editcmntid=c.id;
        l1.viewcomment();
        l1.savecomment();
        l1.cancelcomment();
        l1.delcomment();
        */
    }
}