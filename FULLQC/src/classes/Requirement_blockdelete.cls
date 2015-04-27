/*
    Developer : Harsha Simha S
    Date      : 11/7/2012
    To Block the Delete operation from UI
    Modified By :Anil.B for jira No:SFSUP:807
    Test Class  :requirementsmatrix_Test(84%)
*/
public with sharing class Requirement_blockdelete {
     
    String prof_name=RecordTypeHelper.getprofilename(userinfo.getProfileId());

        public Requirement_blockdelete(Apexpages.StandardController ctrlr)
        {
          /*  If(Apexpages.currentPage().getParameters().get('id')!=null){
                If(prof_name!='System Administrator' && prof_name!='Operations-AAM'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Record Cannot be deleted!');
                    ApexPages.addmessage(myMsg);
                 } 
            } else{
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No records found!');
              ApexPages.addmessage(myMsg);
            }*/
            
        }
        
        /***** Start of JIRA SFSUP-807*****/
        public void del(){
        
            If(Apexpages.currentPage().getParameters().get('id')==null){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No records found!');
                 ApexPages.addmessage(myMsg);
                
            }else{
            
                If(prof_name!='System Administrator' && prof_name!='Operations-AAM'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Record Cannot be deleted!');
                    ApexPages.addmessage(myMsg);                    
                 }
                 else{        
                     Requirement__c r=[select id,opportunity__c from requirement__c where id=:Apexpages.currentPage().getParameters().get('id')];             
                     delete r; 
                     System.debug('===>'+r);                                                  
                 }
           }
        }
        /***** END of JIRA SFSUP-807*****/
        public pagereference  back()
        {    
            return new Pagereference('/'+Apexpages.currentPage().getParameters().get('retURL'));
               
        }
        
       
}