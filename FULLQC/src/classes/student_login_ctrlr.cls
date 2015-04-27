public with sharing class student_login_ctrlr 
{
    public string email1{get;set;}
    public string password1{get;set;}
    public boolean islogin{get;set;}
    public boolean emails{get;set;}
    public boolean password {get;set;}
    public student_login_ctrlr ()
    {
        islogin=true;
        password=false;
        emails=false;
    }
    public PageReference login() {
        try {
        islogin=true;
            return Site.login(email1, password1, '/rotationvisaportal');//'/hrp_ssologin');
        } catch (Exception e) {
            ApexPages.addmessages(e);
        }
        
        return null;
    }
    
    public void redirect2forgetpwd()
    {
        islogin=false;
        password=true;
        emails=false;
    }
    public pagereference Sent_email()
    {
        PageReference pr = Page.student_login;
        pr.setRedirect(true);
        return pr;
    }
    
    public pagereference cancel()
    {
        return null;
    }
    public void forgotPassword() {
    //islogin=true;
        boolean success = Site.forgotPassword(email1);        
        if (success) {              
            
            islogin=false;
            password=false;
            emails=true;
        }
    }
}