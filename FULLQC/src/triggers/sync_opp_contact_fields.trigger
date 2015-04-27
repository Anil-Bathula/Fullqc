/*
    Trigger   : sync_opp_contact_fields
    Events    : After Insert and Update on Opportunity  
    Developer : Harsha Simha S
    Date      : 31/10/2012
    Comment   : To avoid recursive exceution of triggers using avoid_recursive_syncctctopp_trigg class. 
                Updates Linked in satatus field in contact with the Linked in satatus field value in opportunity    
     
     --------------------
    Enhancement : Trigger to update the applicant with the Application substage value 
    Date        : 19/12/2012
    Developer   : Harsha Simha S  
     
     --------------------   
    Enhancement : Added Event Before update. (when Application is created on lead convert, first applicant is not linked to the application 
                  and after few lines of execution application is linked to applicant)So that, when applicant is linked to the application then 
                  linked in status should be auto populated from contact to the opportunity.   
    Date        : 22/7/2013
    Developer   : Harsha Simha S  
     
     --------------------
    Enhancement :if any user waives application fee then auto set who waived it.
                 Instead of validation rule(03dU00000009P3E) added error to check the profiles that waive app fee in this code only.  
                 Instead of Validation rule added error to check application stage should be in Inprogress or qualified lead when app fee is waived off.    
                 SFSUP-640::Waived off Application Fee-autopoulate who waived it 
    Date        :26/7/2013
    Developer   :Harsha Simha S
    
    ------------------------
    Enhancement :There is a workflow which will set paid appliation fee,Application fee complete,Final submission to true and sets Stage name to partial application when 
                 Application fee waived off is set to true. 
                 And this workflow again firing the trigger which throwing the custom validation rule "Application can be waived in only qualified lead and inprogress state only". 
                 So deactivated above workflow(Waive Application Fee https://cs9.salesforce.com/01QU0000000D4hG) and assigned these values in before update trigger only.   
                 SFSUP-640::Waived off Application Fee-autopoulate who waived it 
    Date        :31/7/2013
    Developer   :Harsha Simha S
    
    ----------------------------
    Enhancement :Added Condition to stop recursive Trigger. in Before update. to check if particular opportunity is already waived off or not.                
    Date        :5/8/2013
    Developer   :Harsha Simha S
    Modified By :Anil.B on 19/3/2014...Added profile name::"9.4 HULT Super User" to waiveoff_profiles at line 51.
    
    -------------------
    Changes :- contact.Partial_Application_Date__c field is removed from code.
                Inprogress datetime from opp is set to Contact Date_time_ip__c.
    Developer :Prem 21/7/2014 SFSUP-757
    Modified Prem : SFSUP-767
*/
trigger sync_opp_contact_fields on Opportunity (after insert, after update,before update) 
{
    if(trigger.isbefore)
    {   
        /*waiveoff_profiles :: profiles that can waive application fee*/
        //Removed profile name '_9.0SU Hult Finance' from waiveoff_profiles by anil.b on 25/10/2013- Jira-SFSUP-666
        set<string> waiveoff_profiles=new set<String>{'Sales-Product Head','Sales-Global Product Head','Sales-Regional Head','Finance-Manager','System Administrator','9.4 HULT Super User'};
        list<string> bfre_oppctctlist=new list<string>();
        Map<Id,Opportunity> bfre_oppmap=new map<Id,Opportunity>();
        
        for(Opportunity o:trigger.new)
        { 
            if(!RecordTypeHelper.isapplicationprocessrecordtype(o.Recordtypeid))          
                continue;
            if(o.Contact__c!=Trigger.oldMap.get(o.Id).contact__c && o.Contact__c!=null && o.Linked_In_Status_New__c==null)
            {
                bfre_oppctctlist.add(o.Contact__c);
                bfre_oppmap.put(o.Contact__c,o);
            }
            System.DEbug(avoid_recursive_syncctctopp_trigg.has_opp_alreadywaived(o.Id+'') +'====='+o.Waived_off_Application_Fee__c +'========='+Trigger.oldMap.get(o.Id).Waived_off_Application_Fee__c+'==='+o.StageName);
            
            //shs:26/7/2013 if any user waives application fee then auto set who waived it, if the waived user is not in desired profile or at waived off time,if  sttage is not Qualified lead or inprogress then throw error.
            if(!avoid_recursive_syncctctopp_trigg.has_opp_alreadywaived(''+o.Id) && o.Waived_off_Application_Fee__c && o.Waived_off_Application_Fee__c!=Trigger.oldMap.get(o.Id).Waived_off_Application_Fee__c)
            {  
                if(o.StageName=='Qualified Lead' || o.StageName=='In Progress')
                {   //shs :31/7/2013 included some more fields in the assignment.
                    if(waiveoff_profiles.contains(RecordTypeHelper.getprofilename(Userinfo.getProfileId())))
                    {   
                        o.Application_Fee_Waived_By__c=Userinfo.getUserId();
                        o.Paid_Application_Fee__c=true;
                        o.Final_Submission_Tab_Complete__c=true;
                        o.Application_Fee_Complete__c=true;
                        o.StageName='Partial Application';
                        avoid_recursive_syncctctopp_trigg.set_opp_waived(''+o.id);
                    }
                    else
                    {                       
                        o.Application_Fee_Waived_By__c.addError('The user waiving the fee must be either a Product, Regional, or Global Head, a member of Finance, or a System Admin');
                    }
                }
                else
                {
                    o.Waived_off_Application_Fee__c.addError('Application Fee Can be Waived only in Qualified Lead or In Progress Stage');
                }
               
            }
        } 
        if(!bfre_oppctctlist.Isempty())
        {
                for(Contact ctct:[select id,Name,Linked_In_Status__c from Contact where id IN:bfre_oppctctlist and Linked_In_Status__c!=null])
                {
                    Opportunity o=bfre_oppmap.get(ctct.Id);
                    o.Linked_In_Status_new__c=ctct.Linked_In_Status__c;
                }
        }
    }
    if (trigger.isAfter && !avoid_recursive_syncctctopp_trigg.hastriggfiredalready()) 
    {
    
        system.debug('==Sync==>');
        list<string> oppctctlist=new list<string>();
        Map<Id,Opportunity> oppmap=new map<Id,Opportunity>();
        
        for(Opportunity o:trigger.New)
        {
            if(!RecordTypeHelper.isapplicationprocessrecordtype(o.Recordtypeid))            
                continue;
                
                
                system.debug('==Sync-inside==>'+o.contact__c);
            if(Trigger.isInsert && o.Contact__c!=null)// && (o.Linked_In_Status_New__c!=null || o.Application_Substage__c!=null ||o.Percent_Complete__c!=null||o.Partial_Application_Date__c!=null))
            {
                    oppctctlist.add(o.contact__C);
                    system.debug('==Sync-if ==>'+o.contact__c);
                    oppmap.put(o.Contact__c,o);
            }
            if(Trigger.isUpdate && o.Contact__c!=null && (o.Linked_In_Status_New__c!= Trigger.oldMap.get(o.Id).Linked_In_Status_New__c 
                || o.Application_Substage__c!= Trigger.oldMap.get(o.Id).Application_Substage__c 
                || o.Percent_Complete__c!= Trigger.oldMap.get(o.Id).Percent_Complete__c
                //||o.Partial_Application_Date__c!= Trigger.oldMap.get(o.Id).Partial_Application_Date__c
                ||o.StageName!=Trigger.oldMap.get(o.Id).StageName))//by shs added contact old & new value check.
            {
                    oppctctlist.add(o.Contact__c);
                    oppmap.put(o.Contact__c,o);
            }
            
        }
        
        
        if(!oppctctlist.Isempty())
        {
            List<contact> ctct=[select id,Name,Linked_In_Status__c,Application_Sub_Stage__c,Date_Time_Partial_Application__c,
                                    Date_Time_Confirmed__c,Date_Time_IP__c,Percentage_Completed__c from Contact where id IN:oppctctlist ];
              system.debug('==sync2==>'+ctct.size());
            if(!ctct.IsEmpty())
            {
                for(integer i=0;i<ctct.size();i++)
                {
                    ctct[i].Linked_In_Status__c=oppmap.get(ctct[i].Id).Linked_In_Status_New__c;
                    ctct[i].Application_Sub_Stage__c=oppmap.get(ctct[i].Id).Application_Substage__c;  
                    ctct[i].Percentage_Completed__c=oppmap.get(ctct[i].Id).Percent_Complete__c==null?0:oppmap.get(ctct[i].Id).Percent_Complete__c;  
                    if(Trigger.IsInsert)
                    {
                        ctct[i].Stage__c='Qualified Lead';
                        
                    }
                    else
                    {
                        ctct[i].Stage__c=oppmap.get(ctct[i].Id).stageName; 
                        ctct[i].Date_Time_Confirmed__c=oppmap.get(ctct[i].Id).Confirmed_date_time__c;
                        System.debug('---->'+ctct[i].Date_Time_Confirmed__c+'--->'+oppmap.get(ctct[i].Id).Confirmed_date_time__c);
                        ctct[i].Date_Time_Partial_Application__c=oppmap.get(ctct[i].Id).Partial_Application_date_time__c;
                        ctct[i].Date_Time_IP__c=oppmap.get(ctct[i].Id).In_Progress_date_time__c; //j757
                    }
                   /* if(oppmap.get(ctct[i].Id).Partial_Application_Date__c!=null)
                    {
                        ctct[i].Partial_Application_Date__c=oppmap.get(ctct[i].Id).Partial_Application_Date__c;
                    }*/
                }
                avoid_recursive_syncctctopp_trigg.settriggfiredalready();
                update ctct;
            }           
        }
    }
}