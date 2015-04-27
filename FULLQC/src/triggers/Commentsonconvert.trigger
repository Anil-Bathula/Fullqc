/*Trigger:Commentsonconvert
  Written by:Anil.B
  Purpose:To attach comments to contact and opportunity
  which are linked with lead on conversion of lead
  
  Modified by : Harsha Simha
  Date        : 13/8/2013
  Purpose     : code Optimization
  */
  
trigger Commentsonconvert on Lead (after update,after insert) {
     List<String> leadIDs = new List<String>();
     List<Comments__c> Com = new List<Comments__c>();    
     map<id,Lead> smap=new map<id,Lead>();
         for(Lead l: Trigger.New) {
             if (l.isConverted) { 
                 smap.put(l.id,l);
                 leadIDs.add(l.Id);                
             } 
         }
 /*Querying for comments which are linked with lead and assiging the converted lead id to Contact and Opportunity*/        
     if(!leadIDs.IsEmpty())
     {//by shs:: added this condition for not querying every time.
     	List <Comments__c> cs = [Select id,Applicant__c, Application__c, Lead__c from Comments__c where Lead__c IN :leadIDs]; 
         for (Comments__c comTemp :cs ) { 
             if(smap.ContainsKey(comtemp.Lead__c)){
                   comTemp.Application__c = smap.get(comtemp.Lead__c).ConvertedOpportunityId;
                   comTemp.Applicant__c = smap.get(comtemp.Lead__c).ConvertedContactId; 
                   Com.add(comTemp); 
             }
          } if(Com!=null)  
            update Com; 
     }
}