/***************************************************************************************
Class Name      : Lead_ConvertNew 
Author          : Mahesh Gaddam
Created Date    : November 16, 2011
Usage           : This class is for Lead_ConvertNew trigger.                
                : This trigger checks the Convert_Now__c checkbox on Lead and create a record in rC_Core__Message__c object with required data;    
Changes Done    : Anil.B 6/5/2013 -Added if contion to do not create message when Do not convert =true
****************************************************************************************/
global without sharing class Lead_ConvertNew extends rC_Core.LeadTrigger 
{
    public Lead_ConvertNew(Lead[] leadOldList, Lead[] leadNewList) 
        {
            super(leadOldList, leadNewList);
        }
    
   global override void execute()
    {
        System.debug(':::::: Lead_ConvertNew :: execute :: START ===>' );
        rC_Core__Message__c[] messageList = new rC_Core__Message__c[]{};
        
        for(Lead leadNew : leadNewList) 
        {
             System.debug(':::::: Lead_ConvertNew :: execute :: LOOP :: 1===>' );
                Lead leadOld = leadOld(leadNew.Id);
    
                if (leadNew.Convert_Now__c != true)
                    continue; // lead isn't marked for conversion
                if (leadNew.Do_not_convert__c== true)
                    continue;  //Added by Anil.B 6/5/2013
                System.debug(':::::: Lead_ConvertNew :: execute :: LOOP :: 2===>' );
                
                if (leadNew.Convert_Now__c == leadOld.Convert_Now__c && LeadNew.Do_not_Convert__c==leadold.Do_not_Convert__c)  //Added Condition after  && by Anil.B 6/5/2013
                continue;
                     // || (Trigger.isUpdate == true && leadOld.Company!=null && leadNew.Company != leadOld.Company))
                     // commented by Premanath Reddy . Some leads are not converting, because of changing progam.        
                     // lead is marked, but hasn't been changed in this update, which means that the 
                     // conversion message was already submitted.
                System.debug(':::::: Lead_ConvertNew :: execute :: LOOP :: 3===>' );
                rC_Core__Message__c message = new rC_Core__Message__c();
                message.rC_Core__Endpoint__c = Lead_ConvertApplicantServicer.QUEUE_NAME;
                message.rC_Core__Effective_Date__c = DateTime.now();
                message.rC_Core__Data__c = '<Lead id="' + leadNew.Id + '" />';
                message.Convert_Now_Lead__c = leadNew.Id;
                message.Convert_Now_Errors__c = false;
                messageList.add(message);
                System.debug(':::::: Lead_ConvertNew :: execute :: LOOP :: 4===>' );
          
        }
         insert messageList;
         System.debug(':::::: Lead_ConvertNew :: execute :: END ===>' );
     }
}