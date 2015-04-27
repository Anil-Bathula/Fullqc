public with sharing class redirect_newportal {

    public PageReference redirect() {
        PageReference newpage =  new PageReference('https://studentapplication.hult.edu/');
        newpage.setRedirect(true);
        return newpage;
    }

}