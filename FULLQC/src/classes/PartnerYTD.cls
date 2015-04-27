/************************************************************************
Class      : PartnerYTD
written By : Anil.B
Purpose    : To dispaly PatnerBusiness record in Inline Visualforce Page(PartnerYTD).
Changes   : Added if condition and  changed lead into List of lead 13/5/2013 Anil.B
*************************************************************************/

Public Class PartnerYTD{
/*Declaration of variable */
    public Account Acc {get;set;}
    public list<Partner_Business__c> listPYTD{get; set;}  
    Public Partner_Business__c acs{get;set;}
    public string stringAppend{get;set;}   
    id str{get;set;}      
    
 
 /*Defining the controller */  
    public PartnerYTD(ApexPages.StandardController controller) {         
          Acc=(Account)controller.getRecord();
          system.debug('===>'+acc);        
           
    }
    
   /*Querying for comments records which are linked with Current lead record*/
    public void loaddata(){   
        str=Apexpages.currentpage().getparameters().get('id');    
        //system.debug('===>'+str);  
            
        Integer curr_year=system.today().year();
        if(System.today().month()>9)
        curr_year=system.today().year()+1;
        String s=curr_year-1+'-'+curr_year;
        
        if(str==null){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'There is no Account Record'));
        }
        else{    
         
           listPYTD=[select id,name,createddate,Size_Of_Business_BBA__c,Size_of_Business_EMBA__c,
                       Size_of_Business_Masters__c,Size_of_Business_MBA__c,Total_Size_of_Business__c,
                       YTD_Partials_BBA__c,YTD_Partials_EMBA__c,YTD_Partials_Masters__c,YTD_Partials_MBA__c,
                       YTD_Confirmed_BBA__c,YTD_Confirmed_EMBA__c,YTD_Confirmed_Masters__c,YTD_Confirmed_MBA__c,
                       Target_Confirmed_BBA__c,Target_Confirmed_EMBA__c,Target_Confirmed_Masters__c,Target_Confirmed_MBA__c,
                       Target_Partials_BBA__c,Target_Partials_EMBA__c,Target_Partials_Masters__c,Target_Partials_MBA__c,Recruitment_Year__c,
                       Total_Business_with_Hult_Potential__c,of_Business_with_Hult_Potential__c,Last_Year_In_Class_BBA__c,
                       Last_Year_In_Class_EMBA__c,Last_Year_In_Class_Masters__c,Last_Year_In_Class_MBA__c,Last_Year_Partials_BBA__c,
                       Last_Year_Partials_EMBA__c,Last_Year_Partials_Masters__c,Last_Year_Partials_MBA__c
                       
                        from Partner_Business__c
                        where Partner_Business__c=:str AND Recruitment_Year__c=:s limit 1];
                system.debug('====>'+listPYTD.size());               
                If(!listPYTD.Isempty()){                   
                   for(Partner_Business__c a:listPYTD){
                       acs=a;
                   }  
                }else{  
                    Partner_Business__c acs= new Partner_Business__c();
                    acs.Partner_Business__c=str;
                    acs.Recruitment_Year__c=s;
                    insert acs;
                     system.debug('====>'+acs);                
                }  
        } 
                                          
    }  
  }