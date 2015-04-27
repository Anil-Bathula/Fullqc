/******************************************************************************
Class:CommentsTriggerTestMethod
Written By: Anil.B
Purpose:This Class Consists of Test Method for 4 triggers.
******************************************************************************/



@isTest
private class CommentsTriggerTestMethod {
/*--------------Test Method For Commentsonconvert Trigger---------------*/
    static testMethod void Commentsonconvert() {  
    
        Country__c ctry=new Country__c();
        ctry.name='India';
        ctry.Calling_Code__c=91;
        ctry.MSN__c=10;
        ctry.Prefix_011_not_required_for_five9__c=false;
        ctry.Calling_Code_secondary__c=1;
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
        led.Email = 'Commentsonconvert_123@testmail.com';
        led.Applicant_Email__c = 'Commentsonconvert_123@testmail.com';
        led.Phone='123456';
        led.MobilePhone='987456';
        led.Country_Of_Residence__c = ctry.Id;
        led.LeadSource = 'GMASS';
        led.Program_Primary__c = pro.id;
        insert led;
        
        Country__c ctry1=new Country__c();
        ctry1.name='India';
        ctry1.Calling_Code__c=91;
        ctry1.MSN__c=null;
        ctry1.Prefix_011_not_required_for_five9__c=true;
        ctry1.Calling_Code_secondary__c=1;
        insert ctry1;
       
        Lead led1 = new Lead();
        led1.Company = 'Company';
        led1.FirstName = 'FirstName';
        led1.LastName = 'LastName';
        led1.Status='Open';
        led1.Email = 'Commentsonconvert@testmail.com';
        led1.Applicant_Email__c = 'Commentsonconvert@testmail.com';
        led1.Phone='123456';
        led1.MobilePhone='987456';
        led1.Country_Of_Residence__c = ctry1.Id;
        led1.LeadSource = 'GMASS';
        led1.Program_Primary__c = pro.id;
        insert led1;
            
        List<Comments__c> c=new List<Comments__c>();{
            Comments__c con =new Comments__c();
           // con.name='Test';
            con.Lead__c=led1.id;        
            c.add(con);    
            Comments__c con1 =new Comments__c();
            //con1.name='Test1'; 
            con1.Lead__c=led1.id;       
            c.add(con1);
        }insert c;
        
        // convert the lead
        Database.LeadConvert lc =
        new database.LeadConvert();        
        lc.setLeadId(led1.Id);        
        LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=
        true limit 1];        
        lc.setConvertedStatus(convertStatus.MasterLabel);        
        Database.LeadConvert[] lcArray =
        new Database.LeadConvert[] {lc};        
        Database.LeadConvertResult[] results = Database.convertLead(lcArray);        
        System.assert(results[0].IsSuccess());                    
        
    }
/*--------------Test Method For Addcomments2Opportunity Trigger---------------*/    
    static testMethod void Addcomments2Opportunity () {
       Contact c=new Contact();
            c.LastName='Hult';            
            insert c;
            
      Contact con=new Contact();
            con.LastName='Hult';            
            insert con;
            
        Comments__c cm =new comments__c();
            cm.Comments__c='text';
            cm.Applicant__c=c.id;
            insert cm;                        
        
       Opportunity o=new opportunity();
            o.Name='Hult';
            o.StageName='prospecting';
            o.CloseDate=system.today();
            o.Contact__c=c.id;
            insert o; 
            o.Contact__c=con.id;
            update o;
           
        
        Comments__c cs =new comments__c(); 
           cs.Comments__c='text';
           cs.Applicant__c=c.id;
           cs.Application__c=o.id;           
           insert cs;        
           
    }
/*--------------Test Method For Addcomments2Finance Trigger---------------*/    
    static testMethod void Addcomments2Finance () {
        Opportunity o=new opportunity();
            o.Name='Hult';
            o.StageName='prospecting';
            o.CloseDate=system.today();
            insert o;
            
            
        Opportunity os=new opportunity();
            os.Name='Hult';
            os.StageName='prospecting';
            os.CloseDate=system.today();
            insert os;
            
        Comments__c c =new comments__c();
            c.Comments__c='text';
            c.Application__c=o.id;
            insert c;              
        
        Opportunity_Finance__c fss=new Opportunity_Finance__c();
           fss.opportunity__c=o.id;
           insert fss;         
        
        Comments__c cs =new comments__c(); 
           cs.Comments__c='text';
           cs.Application__c=o.id;
           cs.Finance__c=fss.id;
           insert cs; 
           cs.Application__c=o.id;
           update cs;
            
           
          
          
    }
/*--------------Test Method For updatingcomments Trigger---------------*/     
    static testMethod void Updatingcomments(){
  
        Contact c= new contact();
            c.LastName='Anil'; 
            insert c; 
            
        Opportunity o=new opportunity();
            o.name='Anil';
            o.StageName='prospecting';
            o.CloseDate=system.today();
            o.Contact__c=c.id;
            insert o; 
            
        Opportunity_Finance__c f=new Opportunity_Finance__c(); 
            f.opportunity__c=o.id;
            insert f; 
            
        Comments__c c1=new comments__c();         
            c1.Applicant__c=c.id;
            insert c1; 
            
        comments__c c2=new comments__c();            
            c2.Application__c=o.id;
            insert c2; 
            
        Comments__c c3=new comments__c();           
            c3.Finance__c=f.id;
            insert c3; 
     }      


  

}