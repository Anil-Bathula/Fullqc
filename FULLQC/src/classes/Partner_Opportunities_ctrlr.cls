/***************
Modified By :-Anil.B on 15/11/2013---JIRA No:-SFSUP-672
****************/

public with sharing class Partner_Opportunities_ctrlr 
{
    Public list<opportunity> opps{get;set;}
    public string acctid{get;set;}
    public string sel_year{get;set;}
   // public string sel_Stage{get;set;}
    public integer pagenum{get;set;}
    public integer disprecs{get;set;}
    
    public Partner_Opportunities_ctrlr(ApexPages.StandardController controller) 
    {
        acctid=apexpages.currentpage().getparameters().get('id');
        opps=new list<opportunity>();                
    }
    
    public List<SelectOption> getyears(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult F = Opportunity.Start_Term__c.getDescribe();
        options.add (new SelectOption ('all','ALL'));
        sel_year='all';
        for(Schema.PicklistEntry P:F.getPicklistValues())
        {
            if(p.IsActive())
                options.add (new SelectOption (p.getValue(),p.getLabel()));
        }
        return options;
    }
    /*
    public List<SelectOption> getoppstage(){
        
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult F = Opportunity.StageName.getDescribe();
        options.add (new SelectOption ('all','ALL'));
        sel_stage='all';
        options.add (new SelectOption ('Confirmed','Confirmed'));
        options.add (new SelectOption ('Admissions Endorsed Confirmed','Admissions Endorsed Confirmed'));
        
        return options;
    }*/
    public void searchopps()
    {
        pagenum=0;
        disprecs=1000;
        get_recs(pagenum,disprecs);
    }
    public void get_recs(integer page,integer disprec)
    {
        if(acctid!=null)
        {
            integer offst=1;
            offst=page*disprec;
            string qry='select id,Name,Start_Term__c,stageName,LastModifiedDate,(select id,Name,Total_Fees_Due_FS__c,Total_Paid_by_Applicant__c from Opportunity_Finances__r) from Opportunity where Partner__c=:acctid and (stageName=\'Confirmed\' or stageName=\'Admissions Endorsed Confirmed\' or stageName=\'Conditionally Confirmed\' or stageName=\'Soft Rejected Confirmed\' )';
            if(sel_year!=null && sel_year!='all')
            {
                qry+=' and Start_Term__c=:sel_year';
            }
            /*if(sel_stage!=null && sel_stage!='all')
            {
                qry+=' and stageName=:sel_Stage';
            }*/
            qry+=' ORDER BY LastModifiedDate DESC LIMIT:disprec OFFSET:offst';
            opps=Database.Query(qry);//[select id,Name from Opportunity where Partner__c=:acctid];                            
        }
        else
        {
            //add message :: no account
        }
    }
    
    public void previous()
    {
        if(pagenum>0)
        { 
            pagenum--;
            get_recs(pagenum,disprecs);   
        }
    }
    
    public void next()
    {
         pagenum++;
         get_recs(pagenum,disprecs);   
    }
}