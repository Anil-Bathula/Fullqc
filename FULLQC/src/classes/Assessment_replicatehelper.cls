public class Assessment_replicatehelper{

//NUAGE GROUP:082013: For Hult Project, to integrate with TimeTrade 
//NUAGE GROUP:082013: Invoked by Trigger Assessment_replicate for UPSERT



   public static void createAssessment(List<Assessment_un__c> lstnewass){
    
    if (lstnewass[0].Processed__c == false){
   
      List<ts2__Assessment__c> lstnewas = new  List<ts2__Assessment__c>();
      
       RecordType rectype = [SELECT Id,Name FROM RecordType WHERE Name = 'Appointment'];    
       
       List<Contact> lstcnts  =  [Select Id from contact where Id =:lstnewass[0].Contact_Id_Text__c];
       List<User> lstusers = [Select Id from user where Email = :lstnewass[0].User_Email__c and isActive = true limit 1];
       for(Assessment_un__c a:lstnewass){
         
         ts2__Assessment__c asses = new ts2__Assessment__c ();
         
         asses.Appointment_Type__c = a.Appointment_Type__c;
         asses.Campus__c = a.Campus__c;
         asses.Date__c = a.Date__c;
         asses.TimeTrade_Event_ID__c = a.TimeTrade_Event_ID__c;
         
         if (!lstcnts.isEmpty()){
            asses.ts2__Contact__c = lstcnts[0].Id;
         }
         
         if (!lstusers.isEmpty()){ 
            asses.ts2__User__c=lstusers[0].Id;         
         }
         
         asses.Status__c=a.Status_c__c;
         asses.Location__c=a.Location__c;
         asses.Start_Time__c=a.Start_Time__c;
         asses.End_Time__c=a.End_Time__c;
         asses.RecordTypeId = rectype.Id;
         lstnewas.add(asses);
      }
      
      if(lstnewas.size()>0){
         insert lstnewas;
         Assessment_un__c assunUpd = [SELECT Id, Processed__c  FROM Assessment_un__c WHERE TimeTrade_Event_ID__c = :lstnewas[0].TimeTrade_Event_ID__c];
         assunUpd.Processed__c = true; 
         update assunUpd;
      }
   
  }
   }
    public static void updateassesment(List<Assessment_un__c> lstnewass){
    if (lstnewass[0].Processed__c == false){
     List<ts2__Assessment__c> lstnewas=new  List<ts2__Assessment__c>();
     Set<String> setIds=new Set<String>();
     Map<String,ts2__Assessment__c> mapIdByAssesment=new Map<String,ts2__Assessment__c>();
     
     RecordType rectype = [SELECT Id,Name FROM RecordType WHERE Name = 'Appointment'];    
    
     
     List<Contact> lstcnts  =  [Select Id from contact where Id =:lstnewass[0].Contact_Id_Text__c];
     List<User> lstusers = [Select Id from user where Email = :lstnewass[0].User_Email__c and isActive = true limit 1];
    
     for(Assessment_un__c assesment:lstnewass){
        setIds.add(assesment.TimeTrade_Event_ID__c);
     }
      
     for(ts2__Assessment__c t:[Select Appointment_Type__c,Campus__c,Date__c,End_Time__c,Start_Time__c,TimeTrade_Event_ID__c,ts2__Contact__c,ts2__User__c,Status__c,Location__c  from ts2__Assessment__c  where TimeTrade_Event_ID__c in:setIds]){
         mapIdByAssesment.put(t.TimeTrade_Event_ID__c,t);
     }
      
     for(Assessment_un__c oas:lstnewass){
      
        if(mapIdByAssesment.get(oas.TimeTrade_Event_ID__c)!=null){
         
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Appointment_Type__c=oas.Appointment_Type__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Campus__c=oas.Campus__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Date__c=oas.Date__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).TimeTrade_Event_ID__c=oas.TimeTrade_Event_ID__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).ts2__Contact__c=oas.tsContact__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).ts2__User__c=oas.User__c;
         
         if (!lstcnts.isEmpty()  ){
            mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).ts2__Contact__c = lstcnts[0].Id;
         }
        
         if (!lstusers.isEmpty() ){ 
            mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).ts2__User__c = lstusers[0].Id;         
         }
        
         
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Status__c=oas.Status_c__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Location__c=oas.Location__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).Start_Time__c=oas.Start_Time__c;
         mapIdByAssesment.get(oas.TimeTrade_Event_ID__c).End_Time__c=oas.End_Time__c;
         
         lstnewas.add(mapIdByAssesment.values());         
        }
      
      }
    
       if(lstnewas.size()>0){
           update lstnewas;
           Assessment_un__c assunUpd = [SELECT Id, Processed__c  FROM Assessment_un__c WHERE TimeTrade_Event_ID__c = :lstnewas[0].TimeTrade_Event_ID__c];
           assunUpd.Processed__c = true; 
           update assunUpd;
       }
    
    }
   }

}