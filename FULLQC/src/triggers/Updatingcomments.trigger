/*
Trigger      : Updatingcomments
Written by   : Anil.B
Purpose      : To add new created comments to other objects which have relation ship
*/ 


trigger Updatingcomments on comments__c (before insert) {
 Set<Id> sobjectSetOfIds = new Set<Id>();
 Set<Id> sobjectSetOfctctIds = new Set<Id>();
 Set<Id> sobjectSetOffinIds = new Set<Id>();

    Comments__c cms;
    opportunity opp;  
    UserRole ur = [ select Id, Name FROM UserRole where Id =:Userinfo.getUserroleid()];
 /* Checking for the conditions and getting the ids */  
    for(Comments__c cs:trigger.New){
        cms=cs;    
        if(cms.Application__c!=null && cms.Applicant__c==null && cms.finance__c==null){
            sobjectSetOfIds.add(cms.Application__c);           
        }
        if(cms.Application__c==null && cms.Applicant__c!=null && cms.finance__c==null){
            sobjectSetOfctctIds.add(cms.Applicant__c);
        }
        if(cms.Application__c==null && cms.Applicant__c==null && cms.finance__c!=null){
            sobjectSetOffinIds.add(cms.Finance__c);
        }
    }
  /* updating contact and finance from opportunity object comments related list*/   
    if(!sobjectSetOfIds.ISEmpty())
    {
        Map<Id,Opportunity>smap= new Map<Id, Opportunity>([Select id,Name,Contact__c,(Select id,name from Opportunity_Finances__r)  from Opportunity where Id in : sobjectSetOfIds]);
                    
        for(Comments__c s: trigger.new){
            if(smap.containsKey(s.Application__c)){        
                s.Applicant__c=smap.get(s.Application__c).Contact__c;  
                if(smap.get(s.Application__c).Opportunity_Finances__r.size()>0){            
                    s.Finance__c=smap.get(s.Application__c).Opportunity_Finances__r[0].id; 
                }
                s.Comment_Created_from__c ='App'; //::'+ '  '+smap.get(s.Application__c).Name;
                s.written_by__c=UserInfo.getName();
                s.Written_date__c=system.Today();
                s.Role__c=ur.name;
            }
        }
    }
    
    /* updating opportunity and finance from contact object comments related list*/ 
   if(!sobjectSetOfctctIds.ISEmpty()){      
   List<Opportunity> opportunities = [select Id,Contact__c, Name,Contact__r.Name,(Select id,name from Opportunity_Finances__r )from Opportunity where Contact__c in:sobjectSetOfctctIds];
   map<string,string> mpcopid=new map<string,string>();
   map<string,string> mpcopname=new map<string,string>();
   map<string,string> mpfinid=new map<string,string>();                     
               for(Opportunity oppn:opportunities){                        
                   mpcopid.put(oppn.Contact__c,oppn.Id);
                   mpcopname.put(oppn.Contact__c,oppn.Contact__r.Name);
                   if(oppn.Opportunity_Finances__r.size()>0){mpfinid.put(oppn.Contact__c,oppn.Opportunity_Finances__r[0].Id);}
                   
                 
                }
                for(Comments__c s: trigger.new){
                    if(mpcopid.containsKey(s.Applicant__c))
                    { 
                        s.Application__c=mpcopid.get(s.Applicant__c);
                        if(mpfinid.ContainsKey(s.Applicant__c)){s.Finance__c=mpfinid.get(s.Applicant__c);}  
                        s.Comment_Created_from__c ='App';//  ::  '+mpcopname.get(s.Applicant__c);
                        s.written_by__c=UserInfo.getName();
                        s.Written_date__c=system.Today();
                        s.Role__c=ur.name;
                    } 
                }
    }
            
 
   
   /* updating opportunity and contact from finance */
    if(!sobjectSetOffinIds.ISEmpty()){    
        Map<id,Opportunity_Finance__c> fc =new Map<id,Opportunity_Finance__c>([select id,Name,Opportunity__r.id,Opportunity__r.Contact__r.id from Opportunity_Finance__c where id in:sobjectSetOffinIds]); 
        for(Comments__c cs:trigger.New){
            if(fc.containsKey(cs.Finance__c)){
                cs.Application__c=fc.get(cs.Finance__c).Opportunity__r.id;
                cs.Applicant__c=fc.get(cs.Finance__c).Opportunity__r.Contact__r.id;
                cs.Comment_Created_from__c='Fin';//::'+''+fc.get(cs.Finance__c).Name;
                cs.written_by__c=UserInfo.getName();
                cs.Written_date__c=system.Today();
                cs.Role__c=ur.Name;
               
             }
         }
    }
}