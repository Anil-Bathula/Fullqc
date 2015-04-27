/*
Author        :- Premanath Reddy
Created Date  :- 11/21/12
Purpose       :-Test class for Event_prevent_edit Class
*/
@isTest
public class Event_prevent_editTest{
    public static Testmethod void methodname(){
        
        Contact objCon = new Contact();
        objcon.LastName='LastName';
        insert objCon;
        
        Event e=New Event();
        e.Subject='Phone Interview';
        e.whoid=objCon.id;
        e.Interview_Status__c='status';
        e.StartDateTime=System.Now();
        e.EndDateTime=System.Now()+1;
        insert e;
        
        PageReference pageRef = Page.Event_prevent_edit;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',e.id);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(e);
        Event_prevent_edit ev=new Event_prevent_edit(ctrl);
        ev.prevention();
        ev.cusback();
        
        Event e1=New Event();
        e1.Subject='Phone Interview';
        e1.Interview_Status__c='status';
        e1.StartDateTime=System.Now();
        e1.EndDateTime=System.Now()+1;
        insert e1;
        
        PageReference pageRef1 = Page.Event_prevent_edit;
        system.Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('id',e1.id);
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(e1);
        Event_prevent_edit ev1=new Event_prevent_edit(ctrl2);
        ev1.prevention();
    }
}