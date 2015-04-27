/************************************************************************
Trigger    : unlockStudentInfromation
written By : Anil.B
Purpose    : To update a field(Unlock_Student_Financial_Information__c) .
Test Class : unlockStudentInfromation_Test(87%)
Both on Contact and Opportunity when the related finance record field
(Unlock_Student_Financial_Information__c)get update .
Modified   : Just Commented lines 41,46,49 and replaced all this with 51 line.
Enhancement : Removed a Workflow::Set Accommodation Stage to 4 and added that functionality in this trigger
Modified By :Anil.B 22/7/2014:-
Added if condition to update opportunity accomodation stage to "3. Accom. booked (not paid yet)".
And added 
Modified By :Anil.B 7/10/2014
Changed bachelor of international business administartion to Bachelor of Business Administration
Modified By :Anil.B 04/02/2015
Added fees__c and Total_bursary__c in the condition and added 65 to 69 lines
intsead of work flow:-Finance fields updated on Opp

Modified By :Anil.B 20/03/2015 Added programs (MSE/MIB/MIM/MFIN) in if condition to update accomidation stage to 3 on oppty
Anil.B 30/3/2015    Added extra condition to update stage 3 on opportuntiy based on BBA_Accommodation_Weeks_Year_1__c and BBA_Accommodation_Year_1__c
*************************************************************************/

trigger unlockStudentInformation on Opportunity_Finance__c (after update) {

            //Set<id> oppids=new Set<id>();            
            Map<String,Opportunity_Finance__c> varmap=new Map<String,Opportunity_Finance__c>();
            List<Opportunity> opp=new List<Opportunity>();
            List<Contact> cs=new List<Contact>();
            Set<String>pg_name=new set<string>{'MBA','MFIN','MIM','MSE','MIB','Masters','BBA'}; // used to check the program_parsed__c with this set to updated accomidation stage on opportunity 
           
    
    if(Trigger.isupdate){                    
            for(Opportunity_Finance__c op:Trigger.New){
                if(Trigger.NewMap.get(op.id).Unlock_Student_Financial_Information__c !=Trigger.oldMap.get(op.id).Unlock_Student_Financial_Information__c ||
                    (op.Hult_Financial_Aid__c!=trigger.oldmap.get(op.id).Hult_Financial_Aid__c ||
                    op.Scholarship_Amount__c!=trigger.oldmap.get(op.id).Scholarship_Amount__c)||
                    op.Confirmation_Deposit__c!=trigger.oldmap.get(op.id).Confirmation_Deposit__c||
                    op.Non_BBA_Accommodation_Deposit__c!=trigger.oldmap.get(op.id).Non_BBA_Accommodation_Deposit__c||
                    op.Housing_Accommodation__c!=trigger.oldmap.get(op.id).Housing_Accommodation__c||
                    op.Accommodation_weeks__c!=trigger.oldmap.get(op.id).Accommodation_weeks__c||
                    op.Financial_Aid_Category__c!=trigger.oldmap.get(op.id).Accommodation_weeks__c||
                    op.Fees__c!=trigger.oldmap.get(op.id).Fees__c||
                    op.Total_Bursary_Amount__c!=trigger.oldmap.get(op.id).Total_Bursary_Amount__c||
                    op.BBA_Accommodation_Weeks_Year_1__c!=trigger.oldmap.get(op.id).BBA_Accommodation_Weeks_Year_1__c||                    
                    op.BBA_Accommodation_Year_1__c!=trigger.oldmap.get(op.id).BBA_Accommodation_Year_1__c                   
                    ){                 
                    
                    varmap.put(op.Opportunity__c,op);                
                }
            }            
    if(!varmap.IsEMpty()){           
    List<Opportunity> opps=[select id,name,Accom_Stage_4_date_time__c,Total_Bursary_Amount__c,Financial_Aid_Category__c,Accommodation_Status__c,Accom_Stage_3_date_time__c,Confirmation_Deposit__c,Hult_Fin_Aid_Merit_of_Tuition__c,Unlock_Student_Financial_Information__c,Contact__r.Unlock_Student_Financial_Information__c,Contact__c from opportunity where Contact__c!=null AND id in:Varmap.keyset()];
      
            if(!opps.isEmpty()){                          
                for(Opportunity o:opps){  
                    Opportunity_Finance__c opfin=varmap.get(o.id);                    
                    If(opfin.Unlock_Student_Financial_Information__c!=trigger.oldmap.get(opfin.id).Unlock_Student_Financial_Information__c){                                  
                        o.Unlock_Student_Financial_Information__c=varmap.get(o.id).Unlock_Student_Financial_Information__c; 
                        
                        Contact c=new contact();                      
                        c.id=o.contact__c;                                   
                        c.Unlock_Student_Financial_Information__c=o.Unlock_Student_Financial_Information__c;                    
                        cs.add(c);                                                             
                       
                    }If(opfin.Hult_Financial_Aid__c!=trigger.oldmap.get(opfin.id).Hult_Financial_Aid__c ||
                        opfin.Scholarship_Amount__c!=trigger.oldmap.get(opfin.id).Scholarship_Amount__c){                       
                           o.Hult_Fin_Aid_Merit_of_Tuition__c=varmap.get(o.id).Hult_Fin_Aid_Merit_of_Tuition__c;
                                                 
                    }if(opfin.Confirmation_Deposit__c!=trigger.oldmap.get(opfin.id).Confirmation_Deposit__c ||
                        o.Confirmation_Deposit__c!=opfin.Confirmation_Deposit__c){
                          o.Confirmation_Deposit__c=varmap.get(o.id).Confirmation_Deposit__c;      
                                              
                    }if(opfin.Total_Bursary_Amount__c!=trigger.oldmap.get(opfin.id).Total_Bursary_Amount__c ||
                        opfin.Financial_Aid_Category__c!=trigger.oldmap.get(opfin.id).Financial_Aid_Category__c||
                           o.Total_Bursary_Amount__c!=opfin.Total_Bursary_Amount__c){
                           o.Total_Bursary_Amount__c=varmap.get(o.id).Total_Bursary_Amount__c;
                           o.Financial_Aid_Category__c=varmap.get(o.id).Financial_Aid_Category__c;
                        
                    }
                    /*Workflow::Set Accommodation Stage to 4*/
                    if(opfin.Non_BBA_Accommodation_Deposit__c!=trigger.oldmap.get(opfin.id).Non_BBA_Accommodation_Deposit__c &&opfin.Non_BBA_Accommodation_Deposit__c>=350 && opfin.OP_Program__c!=Null && 
                        pg_Name.contains(opfin.Program_Parsed__c)){
                       // o.Accommodation_Depo__c=varmap.get(o.id).Non_BBA_Accommodation_Deposit__c;
                       o.Accom_Stage_4_date_time__c=System.now();
                       o.Accommodation_Status__c='4. Accom. deposit paid';
                       
                    }
                    /*Workflow::Set Accommodation Stage to 3*/                 
                      
                    if((opfin.Housing_Accommodation__c!=Null && opfin.Accommodation_weeks__c!=NULL) && pg_Name.contains(opfin.Program_Parsed__c) &&
                        (opfin.Housing_Accommodation__c!=trigger.oldmap.get(opfin.id).Housing_Accommodation__c||
                        opfin.Accommodation_weeks__c!=trigger.oldmap.get(opfin.id).Accommodation_weeks__c)){
                        o.Accom_Stage_3_date_time__c=system.now();  
                        o.Accommodation_Status__c='3. Accom. booked (not paid yet)';
                    }
                    
                    If((opfin.BBA_Accommodation_Weeks_Year_1__c!=Null && opfin.BBA_Accommodation_Year_1__c!=NULL)&& opfin.Program_Parsed__c=='BBA' &&
                        (opfin.BBA_Accommodation_Weeks_Year_1__c!=trigger.oldmap.get(opfin.id).BBA_Accommodation_Weeks_Year_1__c||
                        opfin.BBA_Accommodation_Year_1__c!=trigger.oldmap.get(opfin.id).BBA_Accommodation_Year_1__c)){   
                                         
                        o.Accom_Stage_3_date_time__c=system.now();  
                        o.Accommodation_Status__c='3. Accom. booked (not paid yet)';
                    
                    }
                    
                    opp.add(o);
                    
                }
                System.debug('--->'+cs); 
                if(!opp.IsEmpty()){ 
                    database.update(opp);  
                    System.debug('--->'+opp); 
                }
                if(!cs.IsEmpty()){ 
                    database.update(cs); 
                    System.debug('--->'+cs);  
                }      
            }
           
     }   
   }                               
}