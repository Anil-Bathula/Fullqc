/*
Author          :- Premanath Reddy
Created Date    :- 1/7/2014
Purpose         :- Replacing the 12 formula fieds using this Trigger.
Test Clas       :- mapping_Finwithfee_test (81%)
*/

trigger bba_calculation on Opportunity_Finance__c (before insert,before update) {
    try{
        for(Opportunity_Finance__c f:Trigger.New){
            //Used Credits and Banked Credits
            
            Decimal incyr1,incyr2,incyr3,incyr4; 
            Decimal ercyr1,ercyr2,ercyr3,ercyr4,wdcyr1,wdcyr2,wdcyr3,wdcyr4,facyr1,facyr2,facyr3,facyr4;
            ercyr1=f.BBA_Earned_Credits_Yr1__c==null?0:f.BBA_Earned_Credits_Yr1__c;
            ercyr2=f.BBA_Earned_Credits_Yr2__c==null?0:f.BBA_Earned_Credits_Yr2__c;
            ercyr3=f.BBA_Earned_Credits_Yr3__c==null?0:f.BBA_Earned_Credits_Yr3__c;
            ercyr4=f.BBA_Earned_Credits_Yr4__c==null?0:f.BBA_Earned_Credits_Yr4__c;
            
            wdcyr1=f.BBA_Withdrawn_Credits_Yr1__c==null?0:f.BBA_Withdrawn_Credits_Yr1__c;
            wdcyr2=f.BBA_Withdrawn_Credits_Yr2__c==null?0:f.BBA_Withdrawn_Credits_Yr2__c;
            wdcyr3=f.BBA_Withdrawn_Credits_Yr3__c==null?0:f.BBA_Withdrawn_Credits_Yr3__c;
            wdcyr4=f.BBA_Withdrawn_Credits_Yr4__c==null?0:f.BBA_Withdrawn_Credits_Yr4__c;
            
            facyr1=f.BBA_Failed_Credits_Yr1__c==null?0:f.BBA_Failed_Credits_Yr1__c;
            facyr2=f.BBA_Failed_Credits_Yr2__c==null?0:f.BBA_Failed_Credits_Yr2__c;
            facyr3=f.BBA_Failed_Credits_Yr3__c==null?0:f.BBA_Failed_Credits_Yr3__c;
            facyr4=f.BBA_Failed_Credits_Yr4__c==null?0:f.BBA_Failed_Credits_Yr4__c;
            
            incyr1=f.BBA_Invoiced_credits_Yr1__c==null?0:f.BBA_Invoiced_credits_Yr1__c;
            incyr2=f.BBA_Invoiced_Credits_Yr2__c==null?0:f.BBA_Invoiced_Credits_Yr2__c;
            incyr3=f.BBA_Invoiced_Credits_Yr3__c==null?0:f.BBA_Invoiced_Credits_Yr3__c; 
            incyr4=f.BBA_Invoiced_Credits_Yr4__c==null?0:f.BBA_Invoiced_Credits_Yr4__c;
            
            f.BBA_Used_Credits_Yr1__c=ercyr1 + wdcyr1 + facyr1;
            
            
            if(f.BBA_Used_Credits_Yr1__c < incyr1){
                f.BBA_Banked_Credits_Yr1__c=f.BBA_Used_Credits_Yr1__c-incyr1;
            }
            else{
                f.BBA_Banked_Credits_Yr1__c=0;
            }
            
            f.BBA_Used_Credits_Yr2__c=ercyr2 + wdcyr2 + facyr2 + f.BBA_Banked_Credits_Yr1__c;
            
            
            if(f.BBA_Used_Credits_Yr2__c < incyr2){
                f.BBA_Banked_Credits_Yr2__c=f.BBA_Used_Credits_Yr2__c-incyr2;
            }
            else{
                f.BBA_Banked_Credits_Yr2__c=0;
            }
            
            f.BBA_Used_Credits_Yr3__c=ercyr3 + wdcyr3 + facyr3 + f.BBA_Banked_Credits_Yr2__c;
            
            if(f.BBA_Used_Credits_Yr3__c < incyr3){
                f.BBA_Banked_Credits_Yr3__c=f.BBA_Used_Credits_Yr3__c-incyr3;
            }
            else{
                f.BBA_Banked_Credits_Yr3__c=0;
            }
            
            f.BBA_Used_Credits_Yr4__c=ercyr4 + wdcyr4 + facyr4 + f.BBA_Banked_Credits_Yr3__c;
            
            if(f.BBA_Used_Credits_Yr4__c < incyr4){
                f.BBA_Banked_Credits_Yr4__c=f.BBA_Used_Credits_Yr4__c-incyr4;
            }
            else{
                f.BBA_Banked_Credits_Yr4__c=0;
            }
            
            // Additional Credits Charged
            
            if(f.BBA_Used_Credits_Yr1__c > incyr1){
                f.BBA_Additional_Credits_Taken_Yr1__c=f.BBA_Used_Credits_Yr1__c-incyr1;
            }
            else{
                f.BBA_Additional_Credits_Taken_Yr1__c=null;
            }
            
            if(f.BBA_Used_Credits_Yr2__c > incyr2){
                f.BBA_Additional_Credits_Taken_Yr2__c=f.BBA_Used_Credits_Yr2__c-incyr2;
            }
            else{
                f.BBA_Additional_Credits_Taken_Yr2__c=null;
            }
            
            if(f.BBA_Used_Credits_Yr3__c > incyr3){
                f.BBA_Additional_Credits_Taken_Yr3__c=f.BBA_Used_Credits_Yr3__c-incyr3;
            }
            else{
                f.BBA_Additional_Credits_Taken_Yr3__c=null;
            }
            
            if(f.BBA_Used_Credits_Yr4__c > incyr4){
                f.BBA_Additional_Credits_Taken_Yr4__c=f.BBA_Used_Credits_Yr4__c-incyr4;
            }
            else{
                f.BBA_Additional_Credits_Taken_Yr4__c=null;
            }
            
        }
    }
    catch(Exception e){
        system.Debug(e);
    }
}