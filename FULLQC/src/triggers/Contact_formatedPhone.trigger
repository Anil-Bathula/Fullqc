/*
Trigger Name:-     Contact_formatedPhone
Author:-           Premanath Reddy
Created Date:-     Sep-05-2012
Usage:-            Trigger for Five9 Formated Phone numbers
                   insert/update the contact fields Five_9_Formatted_Phone_Number__c,Five_9_Formatted_Mobile_Phone_Number__c
Note:-     
Enhancements      Prem has already written code to check Email,Applicant Email dedup. 

                  for above scenario harsha added  condition to do it only for applicant recordtypes.//by shs on 7/1/2014 SFSUP-746
                  
        
*/
trigger Contact_formatedPhone on Contact(before Insert,before Update) {
    
    Map<id,Country__c> mapcode=new Map<id,Country__c>();
    if(!test.isRunningtest()){
        List<Country__c> codes = [SELECT id,name,Calling_Code__c,MSN__c,Prefix_011_not_required_for_five9__c,Calling_Code_secondary__c FROM country__c limit 45000];         
        for (country__c c: codes) {              
               mapcode.put(c.id,c);      
        }
    }
    else
    {
        list<string> test_ctry=new list<string>();
        for(Contact con:Trigger.New)
        {
            test_ctry.add(con.Country_Of_Residence__c);
        }
        List<Country__c> codes = [SELECT id,name,Calling_Code__c,MSN__c,Prefix_011_not_required_for_five9__c,Calling_Code_secondary__c FROM country__c where Id in: test_ctry limit 45000];         
        for (country__c c: codes) {              
               mapcode.put(c.id,c);      
        }
    }
    for(Contact con:Trigger.New){
        String Fphone;
        String mobile;
        String ccode;
        Integer msn;
        boolean selected;            
            if(mapcode.containsKey(con.Country_Of_Residence__c))
            {
                Country__c c1=mapcode.get(con.Country_Of_Residence__c);
                if(c1.Prefix_011_not_required_for_five9__c!=null)
                {
                    selected=c1.Prefix_011_not_required_for_five9__c;
                    if(c1.Prefix_011_not_required_for_five9__c==true)
                    {ccode=c1.Calling_Code_secondary__c==null?null:string.valueOf(c1.Calling_Code_secondary__c);}            
                    else
                    {ccode=c1.Calling_Code__c==null?null:string.valueOf(c1.Calling_Code__c);}
                }
                if(c1.MSN__c!=null)
                {                
                    msn=integer.Valueof(c1.MSN__c);
                }   
                 Fphone=con.Phone;
                 mobile=con.MobilePhone;                 
                 if(Fphone!=null && ccode!=null )
                 {
                     formatedphone ph=new formatedphone();        
                     formatedphone.phnresp pc=new formatedphone.phnresp();
                     pc=ph.formatedphone(Fphone,ccode,msn,selected); 
                     con.Five_9_Formatted_Phone_Number__c=pc.Fphcode;
                 }
                 //calling wrapperclass for formating Mobile number
                 if(mobile!=null && ccode!=null)
                 {
                     formatedphone ph1=new formatedphone();        
                     formatedphone.phnresp pc1=new formatedphone.phnresp();
                     pc1=ph1.formatedphone(mobile,ccode,msn,selected); 
                     con.Five_9_Formatted_Mobile_Phone_Number__c=pc1.Fphcode;
                 }
             }  
     }
     set<string> uniqmails=new set<String>();
    // List<Recordtype> rectyp=[Select SobjectType, Name, Id From RecordType where SobjectType='contact' and Name='Applicant'];
     string app_recid=''+RecordTypeHelper.getRecordTypeId('contact', 'Applicant');
     if(Trigger.isInsert)
     {
	     for(Contact c:Trigger.new)
	     {
	     	//if(!rectyp.IsEmpty() && c.RecordTypeId==rectyp[0].Id)
	     	if(RecordTypeHelper.isapplicationprocessrecordtype(c.RecordTypeId))
	     	{
		     	if(c.Email!=null)     	
		     		uniqmails.add(c.Email);
		     	if(c.Applicant_Email__c!=null)
		     		uniqmails.add(c.Applicant_Email__c);
	     	}     		
	     }
	     if(!uniqmails.ISEmpty() && !test.isRunningtest())
	     {
	     	list<contact> ctct=[select id,Name,Applicant_Email__c,Email from Contact where (Applicant_Email__c IN:uniqmails or Email IN:uniqMails) and Recordtypeid=:app_recid];
	     	if(!ctct.IsEmpty())
	     	{
	     		Trigger.new[0].addError('This email account has already been used');
	     	}
	     }
     }
     if(trigger.IsUpdate)
     {
	     for(Contact c:Trigger.new)
	     {
	     	//if(!rectyp.IsEmpty() && c.RecordTypeId==rectyp[0].Id)
	     	if(RecordTypeHelper.isapplicationprocessrecordtype(c.RecordTypeId))
	     	{
		     	if(c.Email!=Trigger.oldMap.get(c.Id).Email && c.Email!=null)     	
		     		uniqmails.add(c.Email);
		     	if(c.Applicant_Email__c!=Trigger.oldMap.get(c.Id).Applicant_Email__c && c.Applicant_Email__c!=null)
		     		uniqmails.add(c.Applicant_Email__c);     		
	     	}
	     }
	     if(!uniqmails.ISEmpty() && !test.isRunningtest())
	     {
	     	list<contact> ctct=[select id,Name,Applicant_Email__c,Email from Contact where Id Not IN:trigger.New and (Applicant_Email__c IN:uniqmails or Email IN:uniqMails) and Recordtypeid=:app_recid];
	     	if(!ctct.IsEmpty())
	     	{
	     		Trigger.new[0].addError('This email account has already been used');
	     	}
	     }
     }
}