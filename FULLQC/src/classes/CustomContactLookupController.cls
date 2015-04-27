/*
Purpose     :- SFSUP-906 - For BBA applications, recruiters are using the Contact VF page at the top of the appllications to create parents.
                They are using the lookup next to Applicant Parent field and then in there they are clicking New.
Test Class  :- contact2opportunity_test (100%)
*/
public with sharing class CustomContactLookupController {

    public Contact con{get;set;}
    public List<Contact> results{get;set;} // search results
    public string searchString{get;set;} // search keyword
    public string rec_type{get;set;}
    
    public CustomContactLookupController() {
        con= new Contact();
        rec_type=RecordTypeHelper.getRecordTypeId('Contact','Parent');
        // get the current search stringtest class for 
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();  
    }
    
    // prepare the query and issue the search command
    public void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);               
    } 
    
    // run the search and return the records found. 
    public List<Contact> performSearch(string searchString) {
        String soql = 'select id, name from Contact';
        if(searchString != '' && searchString != null)
        soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
        soql = soql + ' limit 25';
        System.debug(soql);
        return database.query(soql);
    }
    
    // save the new account record
    public String saveContact() {
        con.recordtypeid=rec_type;
        insert con;
        return null;
    }
    
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    
}