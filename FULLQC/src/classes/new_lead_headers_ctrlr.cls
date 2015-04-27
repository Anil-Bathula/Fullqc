public class new_lead_headers_ctrlr
{
/*
    Developer : Harsha Simha
        Extension for  new_lead_headers VF page.
*/
    public string currleadid{get;set;}
    public Lead currlead_rec{get;set;}
    public boolean editlead{get;set;}
    public string flagurl{get;set;}
    
    public new_lead_headers_ctrlr(ApexPages.StandardController controller) {        
        
    }
    /* page load  method which extracts the current Lead record values 
       and sets flag and other images
    */
    public void init()
    {
        currleadid=Apexpages.currentPage().getparameters().get('id');
        currlead_rec=new Lead();
        if(currleadid!=null)
        {//Lead.
            editlead=false;
                currlead_rec=[select id,Name,Interview_Status__c,Interview_Date__c,Interview_Date_Booked__c,Program_Parsed__c,Lead_Stage__c,Region__c ,Country_Of_Residence__c,Country_Of_Residence__r.Flags__c,Country_Of_Residence__r.Name,SFGA__Web_Source__c,Program_Primary__r.Name,Owner.Name,Program_Primary__c,Telesales_Caller__c,Marketing_Source__c,Telesales_Caller__r.Name,OwnerId,LeadSource,Start_Term__c from Lead where id=:currleadid];
               
                string flag=currlead_rec.Country_Of_Residence__r.Flags__c;
                if(flag!=null && flag.contains('<img '))
                {
                    list<string> s=flag.split('src="');
                    if(s.size()>1)
                    {    
                        flagurl=s[1].substring(0,s[1].indexOf('"'));
                        flagurl=flagurl.replace('&amp;','&');
                    }
                
                }
                
                boolean chk=false;
                for(Event e:[select id,StartDateTime,whoid from Event where StartDateTime>=:System.Now() and whoid=:currlead_rec.Id])
                {
                    chk=true;
                }            
                if(!chk && currlead_rec.Interview_Status__c!=null)
                {
                    currlead_rec.Interview_Status__c=null;
                    currlead_rec.Interview_Date__c=null;
                    currlead_rec.Interview_Date_Booked__c=null;
                    update currlead_rec;
                }                        
        }
    }
}