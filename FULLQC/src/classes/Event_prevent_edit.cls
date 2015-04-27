/*
Author        :- Premanath Reddy
Created Date  :- 11/21/12
Purpose       :- It prevents the any user to Edit the Open Activities(Event/Interview),but only when that Event related to Applicant record.
*/
public class Event_prevent_edit {
    
    public boolean section1{get;set;}
    List<Id> conids=new List<Id>();
    String str=Apexpages.currentpage().getparameters().get('id');
    String returl=Apexpages.currentpage().getparameters().get('retURL');
    public Event_prevent_edit(ApexPages.StandardController controller) {
    
    }
    public void prevention(){
        List<event> evnt=[select id,Subject,whoid from Event where id=:str];
        for(Integer i=0;i<evnt.size();i++){
            conids.add(evnt[i].whoid);
        }
        List<Contact> varcon=[select id from Contact where id In:conids];
        if(!varcon.isEmpty()){
            section1=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Interview Actiivities are non editable in this section, please make your Interview changes using the Interview Scheduler'));
        }
        else{
            section1=true;
        }
    }
    public pagereference cusback(){
        pagereference pageref=new pagereference(''+returl);
        return pageref;
    }
}