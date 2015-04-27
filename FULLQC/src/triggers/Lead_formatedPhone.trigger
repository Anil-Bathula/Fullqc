/*
Trigger Name:-     Lead_formatedPhone
Author:-           Premanath Reddy
Created Date:-     Sep-05-2012
Usage:-            Trigger for Five9 Formated Phone numbers 
                   insert/update the Lead fields Five_9_Formatted_Phone_Number1__c,Five_9_Formatted_Mobile_Phone_Number1__c
Note:-             
*/

trigger Lead_formatedPhone on Lead(before Insert,before Update) {
    
    Map<id,Country__c> mapcode=new Map<id,Country__c>();
    if(!test.isRunningtest())
    {
        List<Country__c> codes = [SELECT id,name,Calling_Code__c,MSN__c,Prefix_011_not_required_for_five9__c,Calling_Code_secondary__c FROM country__c limit 45000];         
        for (country__c c: codes) {              
               mapcode.put(c.id,c);      
        }
    }
    else
    {
        list<string> test_ctry=new list<string>();
        for(Lead led:Trigger.New)
        {
            test_ctry.add(led.Country_Of_Residence__c);
        }
        List<Country__c> codes = [SELECT id,name,Calling_Code__c,MSN__c,Prefix_011_not_required_for_five9__c,Calling_Code_secondary__c FROM country__c where Id in: test_ctry limit 45000];         
        for (country__c c: codes) {              
               mapcode.put(c.id,c);      
        }
    }
    for(Lead led:Trigger.New){
    System.debug('bfre>>>>>>'+led.Interview_Status__c);
        String Fphone;
        String mobile;
        String ccode;
        Integer msn;
        boolean selected;
            
            if(mapcode.containsKey(led.Country_Of_Residence__c))
            {
                Country__c c1=mapcode.get(led.Country_Of_Residence__c);
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
                
                     
                
                 Fphone=led.Phone;
                 mobile=led.MobilePhone; 
                 if(Fphone!=null && ccode!=null )
                 {
                     formatedphone ph=new formatedphone();        
                     formatedphone.phnresp pc=new formatedphone.phnresp();
                     pc=ph.formatedphone(Fphone,ccode,msn,selected); 
                     led.Five_9_Formatted_Phone_Number__c=pc.Fphcode;
                 }
                 //calling wrapperclass for formating Mobile number
                 if(mobile!=null && ccode!=null)
                 {
                     formatedphone ph1=new formatedphone();        
                     formatedphone.phnresp pc1=new formatedphone.phnresp();
                     pc1=ph1.formatedphone(mobile,ccode,msn,selected); 
                     led.Five_9_Formatted_Mobile_Phone_Number__c=pc1.Fphcode;
                 }
             }  
     }
     /*for(lead led:trigger.New)
     { System.debug('after>>>>>>'+led.Interview_Status__c);}*/
}