/*
    --------------------
    code        : linkedinstatus    
    original Trigger : sync_opp_contact_fields
    
    Enhancement : Added Event Before update. (when Application is created on lead convert, first applicant is not linked to the application 
                  and after few lines of execution application is linked to applicant)So that, when applicant is linked to the application then 
                  linked in status should be auto populated from contact to the opportunity.
    Date        : 22/7/2013
    Developer   : Harsha Simha S  
    
    Enhancement :Added Condition to stop recursive Trigger. in Before update. to check if particular opportunity is already waived off or not.                
    Date        :5/8/2013
    Developer   :Harsha Simha S
    
    --------------------
    code        :waive appfee
    original Trigger : sync_opp_contact_fields
    
    Enhancement :if any user waives application fee then auto set who waived it.
                 Instead of validation rule(03dU00000009P3E) added error to check the profiles that waive app fee in this code only.  
                 Instead of Validation rule added error to check application stage should be in Inprogress or qualified lead when app fee is waived off.    
                 SFSUP-640::Waived off Application Fee-autopoulate who waived it 
    Date        :26/7/2013
    Developer   :Harsha Simha S
    
    Enhancement :There is a workflow which will set paid appliation fee,Application fee complete,Final submission to true and sets Stage name to partial application when 
                 Application fee waived off is set to true. 
                 And this workflow again firing the trigger which throwing the custom validation rule "Application can be waived in only qualified lead and inprogress state only". 
                 So deactivated above workflow(Waive Application Fee https://cs9.salesforce.com/01QU0000000D4hG) and assigned these values in before update trigger only.   
                 SFSUP-640::Waived off Application Fee-autopoulate who waived it 
    Date        :31/7/2013
    Developer   :Harsha Simha S
    
    ----------------------------
    code            : aec_exam
    original Trigger: AdmissionsEndorsedConfirmed_validation
    Author          : Premanath Reddy
    created Date    : 11/9/2012    
    Purpouse        : It will give validation Errors where Changing Application Sub-Stage from ‘AEC Quality – Low – missing test date/proof of test’
                      and where at least one of the entries in Exams does not have a date greater or equal to 'Accepted Date’  
                      in the field “Planned Test Date” should receive an error message when any user with a profile 
                      other than Operations-AAM attempts to change.
                      
                      Any Opportunity record where "Stage is switched to Admissions Endorsed Confirmed"
                      and where none of the dates entered in ‘Planned Test Date’ on Exams is greater or equal to
                      the date entered in ‘Accepted Date’ then
                      the checkbox ‘Test date/proof of test not submitted’ will be marked True and
                      Application Sub-Stage will be set to ‘AEC Quality – Low – missing test date/proof of test’                      
    
    Changes         : by SHS on 5/6/2013
                    : Removed query on user to get Profile name and used record type helper.  
                      added profiles 2,5,6 and admin in if condition (i.e exclude these profiles from AEC Quality - Low - Missing test date/proof of test date validate)                 
        
    ----------------------------
    Modified Prem : SFSUP-767
    
  */  
trigger Opportunity_self_update on Opportunity (before insert, before update) 
{
     /*waiveoff_profiles :: profiles that can waive application fee*/
     //Removed profile '_9.0SU Hult Finance' from wavieoff_profiles by anil.b on 25/10/2013- jira : SFSUP-666
    set<string> waiveoff_profiles=new set<String>{'Sales-Product Head','Sales-Global Product Head','Sales-Regional Head','Finance-Manager','System Administrator'};
    
    /*profiles that can change Planned Test Date*/
    set<String> aecqltylow_profiles=new set<String>{'Operations-AAM','Sales-Recruiter and Converter','Sales-Product Head','Sales-Global Product Head','Sales-Regional Head','System Administrator'};
    
    list<string> bfre_oppctctlist=new list<string>();
    Map<Id,Opportunity> bfre_oppmap=new map<Id,Opportunity>();
    set<string> aeclow_opps=new set<String>();
    set<string> aeconf_opps=new set<String>();
        
    for(Opportunity o:trigger.new)
    {  
        /*start:waive appfee*/
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
        /*End:waive appfee*/
        
        /*Start:linkedinstatus*/    
        if(o.Contact__c!=Trigger.oldMap.get(o.Id).contact__c && o.Contact__c!=null && o.Linked_In_Status_New__c==null)
        {
            bfre_oppctctlist.add(o.Contact__c);
            bfre_oppmap.put(o.Contact__c,o);
        }       
        /*End:linkedinstatus*/    
        
        /*Start:aec_exam*/
        if(Trigger.oldMap.get(o.id).Application_Substage__c=='AEC Quality - Low - Missing test date/proof of test' && Trigger.NewMap.get(o.id).Application_Substage__c!=Trigger.oldMap.get(o.id).Application_Substage__c)
        {
            if(!aecqltylow_profiles.Contains(RecordTypeHelper.getprofilename(Userinfo.getProfileId())))
                aeclow_opps.add(o.id);
        }
        if(Trigger.NewMap.get(o.id).StageName=='Admissions Endorsed Confirmed' && Trigger.NewMap.get(o.id).StageName!=Trigger.oldMap.get(o.id).StageName)
        {
            aeconf_opps.add(o.id);
        }
        /*End:aec_exam*/
    } 
    
  /*----------------------------------------------------------------------------------*/  
    
    /*linkedinstatus*/ 
    if(!bfre_oppctctlist.Isempty())
    {
        for(Contact ctct:[select id,Name,Linked_In_Status__c from Contact where id IN:bfre_oppctctlist and Linked_In_Status__c!=null])
        {
            Opportunity o=bfre_oppmap.get(ctct.Id);
            o.Linked_In_Status_new__c=ctct.Linked_In_Status__c;
        }
    }
    
    /*Start:aec_exam*/
    if(!(aeclow_opps.IsEmpty() && aeconf_opps.IsEmpty()))
    {
        Map<id,Exam__c> varmap=new Map<id,Exam__c>();
        List<Exam__c> exm1=[Select id,Planned_Test_Date__c,Application__c,Application__r.Accepted_Date__c From Exam__c Where Application__c in:aeclow_opps or Application__c in:aeconf_opps];
        for(Exam__c e:exm1)
        {
            if(e.Planned_Test_Date__c >=e.Application__r.Accepted_Date__c)
            {
                varmap.put(e.Application__c,e);
            }
        }
        for(Opportunity opp:Trigger.New)
        {
            if(varmap.get(opp.id)==null)
            {
                if(aeclow_opps.Contains(opp.id))
                {
                    Trigger.newMap.get(opp.id).addError('A Planned Test Date must be entered in the relevant field under Exams before you can change the sub-stage from AEC – Quality – Low –missing test date/proof of test');                        
                }
                if(aeconf_opps.Contains(opp.id))
                {
                    opp.Product_Head_interview_has_not_happened__c=false;
                    opp.Test_date_proof_of_test_not_submitted__c=True;
                    opp.Application_Substage__c='AEC Quality - Low - Missing test date/proof of test';                        
                }
            }
            else
            {
                if(aeclow_opps.Contains(opp.id))
                {
                    opp.Test_date_proof_of_test_not_submitted__c=false;
                }
                if(aeconf_opps.Contains(opp.id))
                {
                    opp.Test_date_proof_of_test_not_submitted__c=false;
                    opp.Application_Substage__c='AEC Quality - Low';
                    opp.Product_Head_interview_has_not_happened__c=True;                   
                }
            }            
        }
    }
    /*End:aec_exam*/
}