/*
Author          : Premanath Reddy
created Date    : 11/9/2012    
Purpouse        : It will give validation Errors where Changing Application Sub-Stage from ‘AEC Quality – Low – missing test date/proof of test’
                  and where at least one of the entries in Exams does not have a date greater or equal to 'Accepted Date’  
                  in the field “Planned Test Date” should receive an error message when any user with a profile 
                  other than Operations-AAM attempts to change.
                  
Changes         : by SHS on 5/6/2013
                : Removed query on user to get Profile name and used record type helper.  
                  added profiles 2,5,6 and admin in if condition (i.e exclude these profiles from AEC Quality - Low - Missing test date/proof of test date validate)        
                           
Modified By     :Anil.B---15/11/2013----JIRA NO :::SFSUP-672                 
Modified By     :SHS -7/2/2014   -- SFSUP-745
                 And commented code that copies opp stage name to Contact & placed that code in SyncOpportunitycontactfields trigger.                   
Modified Prem : SFSUP-767
*/
trigger AdmissionsEndorsedConfirmed_validation on Opportunity (before update){//,after update,after insert) {
    if((Test.isRunningTest()==True && Limits.getQueries()< 100) || Test.isRunningTest()!=True){
        if(Trigger.isbefore){
            // When changing the Application Sub-Stage from "AEC Quality - Low - Missing test date/proof of test" it will fire
            List<id> oppids=new List<id>();
            for(Opportunity opp:Trigger.New){
                if(!RecordTypeHelper.isapplicationprocessrecordtype(opp.RecordTypeId))
                    continue;
                if(Trigger.NewMap.get(opp.id).Application_Substage__c!=Trigger.oldMap.get(opp.id).Application_Substage__c
                    && Trigger.oldMap.get(opp.id).Application_Substage__c=='AEC Quality - Low - Missing test date/proof of test')
                {
                    //System.Debug('*****************'+opp.id);
                    oppids.add(opp.id);
                }
            }
            if(!oppids.isEmpty()){
                String s;
                s= RecordTypeHelper.getprofilename(Userinfo.getProfileId()); //[select id,Profile.Name from User where id = :Userinfo.getUserId()].Profile.Name;//by shs
                if(s!='Operations-AAM' && s!='Sales-Recruiter and Converter' && s!='Sales-Product Head' && s!='Sales-Global Product Head'&&s!='Sales-Regional Head' && s!='System Administrator'){
                    
                    Map<id,id> varmap=new Map<id,id>();
                    Map<id,id> mapmakefalse=new Map<id,id>();
                    List<Exam__c> exm=[Select id,Planned_Test_Date__c,Application__c,Application__r.Accepted_Date__c From Exam__c
                                                Where Application__c in:oppids];
                    for(Exam__c e:exm){
                        if(e.Planned_Test_Date__c >=e.Application__r.Accepted_Date__c){
                            varmap.put(e.Application__c,e.id);
                        }
                    }                                           
                    for(Opportunity opp:Trigger.New){
                        if(varmap.get(opp.id)==null){
                            Trigger.newMap.get(opp.id).addError('A Planned Test Date must be entered in the relevant field under Exams before you can change the sub-stage from AEC – Quality – Low –missing test date/proof of test');                        
                        }
                        else{
                            opp.Test_date_proof_of_test_not_submitted__c=false;
                        }
                    }
                }
            }
            /* -    Any Opportunity record where "Stage is switched to Admissions Endorsed Confirmed"
                    and where none of the dates entered in ‘Planned Test Date’ on Exams is greater or equal to
                     the date entered in ‘Accepted Date’ then
                o    the checkbox ‘Test date/proof of test not submitted’ will be marked True and
                o   Application Sub-Stage will be set to ‘AEC Quality – Low – missing test date/proof of test’*/
    
            List<id> oppids1=new List<id>();
            for(Opportunity opp:Trigger.New){
                if(Trigger.NewMap.get(opp.id).StageName!=Trigger.oldMap.get(opp.id).StageName 
                   && (Trigger.NewMap.get(opp.id).StageName=='Admissions Endorsed Confirmed'||Trigger.NewMap.get(opp.id).StageName=='Conditionally Confirmed'||Trigger.NewMap.get(opp.id).StageName=='Soft Rejected Confirmed'))
                {
                    oppids1.add(opp.id);
                }
            }
            if(!oppids1.isEmpty()){
                Map<id,id> varmap1=new Map<id,id>();
                List<Exam__c> exm1=[Select id,Planned_Test_Date__c,Application__c,Application__r.Accepted_Date__c From Exam__c
                                            Where Application__c in:oppids1];
                for(Exam__c e:exm1){
                    if(e.Planned_Test_Date__c >=e.Application__r.Accepted_Date__c){
                        varmap1.put(e.Application__c,e.id);
                    }
                }                         
                for(Opportunity opp:Trigger.New){
                    if(varmap1.get(opp.id)==null){
                        opp.Product_Head_interview_has_not_happened__c=false;
                        opp.Test_date_proof_of_test_not_submitted__c=True;
                        opp.Application_Substage__c='AEC Quality - Low - Missing test date/proof of test';
                    }
                    else{
                    // the checkbox ‘Product Head interview has not happened’ will be marked as True and substage is "AEC Quality - Low" when the Exam Date should have.
                        opp.Test_date_proof_of_test_not_submitted__c=false;
                        opp.Application_Substage__c='AEC Quality - Low';
                        opp.Product_Head_interview_has_not_happened__c=True;
                    }
                }
            }
        } 
        /*
        //Updates the field ‘Stage__c’ in the contact object, when the field ‘StageName’ is changed in the relevant opportunity.
        if(Trigger.isafter && Trigger.isupdate){
            try{
               // List<id> oppids=new List<id>();
                List<id> conids=new List<id>();
                Map<id,string> varmap=new Map<id,string>();
                for(Opportunity opp:Trigger.New){
                    if(Trigger.NewMap.get(opp.id).StageName!=Trigger.oldMap.get(opp.id).StageName
                        || Trigger.NewMap.get(opp.id).Contact__c!=Trigger.oldMap.get(opp.id).Contact__c){
                        //oppids.add(opp.id);
                        varmap.put(opp.Contact__c,opp.StageName);
                    }
                }
                if(!varmap.isEmpty()){
                    List<contact> con=new List<contact>();
                    List<contact> varcon=[select id,name,Stage__c from Contact where id in:varmap.Keyset()];
                    for(contact c:varcon){    
                        c.Stage__c=varmap.get(c.id);
                        con.add(c);
                    }
                    update con;
        
                }
            }
            catch(Exception e){}
        }   
        //Updates the field ‘Stage__c=Qualified Lead’ in the contact object, when relevant opportunity is inserted.
        if(Trigger.isinsert){
            try{
                List<id> conids=new List<id>();
                 
                for(Opportunity opp:Trigger.New){
                    conids.add(opp.Contact__c);                    
                }
                if(!conids.isEmpty()){
                    List<contact> con=new List<contact>();
                    List<contact> varcon=[select id,name,Stage__c from Contact where id in:conids];
                    for(contact c:varcon){    
                        c.Stage__c='Qualified Lead';                        
                        con.add(c);
                    }
                    update con;
        
                }
            }
            catch(Exception e){}
        }*/  
    }                           
}