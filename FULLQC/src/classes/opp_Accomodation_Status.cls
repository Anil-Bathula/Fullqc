/*********************************************************
Created By   :- Anil.B
Created Date :- 2/11/13
Pupose       :- In line VF page to show Accommodation_status__c
field and their realted fields in a Vf page and throw error when
when a particular value is selected in this and the related fields are null
Test class   :-opp_Accomodation_Status_test(86%)
Modified Prem : SFSUP-767
Modified By  :Anil.B on 8/10/2014 changed the program parsed from BIBA to BBA.
***********************************************************/

public class opp_Accomodation_Status {
    Public Opportunity opp{get;set;}
    public Boolean showblock{get;set;}
    public Boolean hidebutton{get;set;}
    public Boolean hidelable{get;set;}
    public Boolean fildblock{get;set;}
    public boolean refreshPage{get;set;}
    public String Accommodation_Status_c {get;set;}
    public String Name_of_alternative_Accommodation_c{get;set;}
    public String Proof_of_Alternative_accomm_uploaded_c{get;set;}
    public Opportunity op {get;set;}   
    String str;
    public Attachment attchmnt{get;set;}
    public String prof_name;
    set<String> proflist=new set<String>{'Sales-Global Product Head','Sales-Regional Head','System Administrator'};
    public opp_Accomodation_Status(ApexPages.StandardController controller) {
        fildblock=false;
        refreshPage=false;
        opp=new Opportunity();
        str=ApexPages.CurrentPage().getParameters().get('id');
        prof_name=RecordTypeHelper.getprofilename(Userinfo.getProfileId());
        loaddata();    
        attchmnt= new Attachment();
       /* if(str==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        }        
        else{
            op=[select id,Name,stagename,Hult_Fin_Aid_Merit_of_Tuition__c,Accommodation_status__c,Name_of_alternative_Accommodation__c,Proof_of_Alternative_accomm_uploaded__c from Opportunity where id=:str];
            System.debug('**************>'+op.Accommodation_status__c); 
            hidebutton=true;

            if(op.Accommodation_status__c==null){
                hidelable=false;                
            }       
            
        }*/
    }
    public void loaddata(){
        if(str==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        } else{
            op=[select id,Name,stagename,Hult_Fin_Aid_Merit_of_Tuition__c,Accommodation_status__c,Name_of_alternative_Accommodation__c,Proof_of_Alternative_accomm_uploaded__c
                 ,Accom_Stage_1_date_time__c,Accom_Stage_2_date_time__c,Accom_Stage_3_date_time__c,Accom_Stage_4_date_time__c,Program_Parsed_picklist__c
                 from Opportunity where id=:str];
            //System.debug('**************>'+op.Accommodation_status__c); 
            hidebutton=true;
            if(op.Accommodation_status__c==null){
                hidelable=false; 
                hidebutton=False;               
            }
        }
    }
    //This method is for New Button
    public void cusnew(){
        if(str==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Application Record'));
        }
        fildblock=true;
        hidebutton=false;
        hidelable=false; 
       
    }
    //This method is for GoBack Link
    Public Void CustCancel(){ 
            loaddata();          
            hidebutton=true; 
            hidelable=true;
            fildblock=false;
    }
    
    //This method is for Save Button
    public void cussave(){
        try{  
            if(Op.Name_of_alternative_Accommodation__c==null && op.Accommodation_status__c=='2c. Not Interested (Alternative accom.)' && op.Program_Parsed_picklist__c==custom_lables.Bachelor_Pgm_abvtn){
                hidelable=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter name of alternative accommodation'));                
            }     
           /* else if(op.Accommodation_status__c=='2b. Not Interested (Financial reasons)' && (op.Hult_Fin_Aid_Merit_of_Tuition__c==null || op.Hult_Fin_Aid_Merit_of_Tuition__c<=15)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Scholarship & Fin Aid package is lower than 15%. Get in touch with student/parent to increase financial package OR convince student to book accommodation and move to 2a'));
            }
            else if(op.Accommodation_status__c=='2c. Not Interested (Alternative accom.)'&&(op.Name_of_alternative_Accommodation__c==NULL)){
                hidelable=false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please enter name of alternative accommodation and provide proof of alternative accommodation (upload doc)'));
            }*/
            else if(attchmnt.body==null && op.Accommodation_status__c=='2c. Not Interested (Alternative accom.)'  && op.Program_Parsed_picklist__c==custom_lables.Bachelor_Pgm_abvtn){
                attchmnt.body=null;
                attchmnt=new Attachment();
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide proof of alternative accommodation.'));
            }
            else if(!proflist.contains(prof_name) && (op.Accommodation_status__c=='3. Accom. booked (not paid yet)' || op.Accommodation_status__c=='4. Accom. deposit paid'||op.Accommodation_status__c=='Approved by Management')){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can\'t select this value.'));
            }
            else{
                opp.id=op.id;
                opp.Accommodation_status__c=op.Accommodation_status__c;
                opp.Name_of_alternative_Accommodation__c=op.Name_of_alternative_Accommodation__c; 
                opp.Proof_of_Alternative_accomm_uploaded__c=op.Proof_of_Alternative_accomm_uploaded__c;              
                refreshPage=true;
                opp.Accom_Stage_1_date_time__c=opp.Accommodation_status__c=='1. Recruiter presented Hult accom.'?System.Now():op.Accom_Stage_1_date_time__c;
                opp.Accom_Stage_2_date_time__c=opp.Accommodation_status__c=='2a. Student is happy with Hult accom.'||opp.Accommodation_status__c=='2b. Not Interested (Financial reasons)'||opp.Accommodation_status__c=='2c. Not Interested (Alternative accom.)'?System.Now():op.Accom_Stage_2_date_time__c;
                opp.Accom_Stage_3_date_time__c=opp.Accommodation_status__c=='3. Accom. booked (not paid yet)'?System.Now():op.Accom_Stage_3_date_time__c;
                opp.Accom_Stage_4_date_time__c=opp.Accommodation_status__c=='4. Accom. deposit paid'?System.Now():op.Accom_Stage_4_date_time__c;
                update opp;
                try{
                    if(op.Accommodation_status__c=='2c. Not Interested (Alternative accom.)' && op.Program_Parsed_picklist__c==custom_lables.Bachelor_Pgm_abvtn){
                        attchmnt.ParentId = str;
                        upsert attchmnt;
                    }
                }
                Catch(Exception e){
                    attchmnt.body=null;
                    attchmnt=new Attachment();
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This file exceeds maximum size limit of 5MB.'));
                }
                finally {
                    attchmnt.body=null;
                    attchmnt= new Attachment();
                   
                }
                loaddata();
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,''+e));
        }
    }
    
 }