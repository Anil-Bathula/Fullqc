/*********************************
Trigger Name:-LeadScoring-(GMASS)
Developer:-Anil.B
Purpose:-This trigger send values to leadSource_QS_MBA class
to calculate GMASS scoring and get back values and update appropriate
fields on lead.
Modified By anil.B on 31/10/2014 for SFSUP-777.
Modified By anil.b on 11/11/2014 for SFSUP-787.
Test Class:- lComments_Test(93%)
***********************************/
trigger LeadScoring on Lead (before insert,before update) {
        //Gmass Variables
        String typeful;
        String worldregion;
        Integer worldregionid;
        
        //QS_MBA_World_tour variables
        String Typefull;
        
     If(Trigger.isBefore ){
        For(Lead ld:trigger.new){ 
            
            lead oldld=trigger.isUpdate?Trigger.oldmap.get(ld.id):new lead(); 
            
            Map<String,String>sst=new Map<String,String>();           
            
            for(SATgrouping__c s:SATgrouping__c.getAll().values()){
                sst.put(s.SAT_grouping_name__c,s.SAT_grouping_value__c);
            } 
           
            If(ld.LeadSource=='GMASS' && ((Trigger.isinsert) ||(  Trigger.isupdate && oldld.Region__c!=ld.Region__c))){
             
                worldregion=ld.World_Region__c!=NULL&&ld.World_Region__c!=''?ld.World_Region__c:'';
                worldregionid=Integer.valueof(ld.World_Region_ID__c);
                String regionvalues =ld.Region_Values__c!=Null&&ld.Region_Values__c!=''?ld.Region_Values__c:'';
                String region=ld.Region__c!=null&&ld.Region__c!=''?ld.Region__c:'';
                  
                
                leadSource_QS_MBA LQ=new leadSource_QS_MBA();
                leadSource_QS_MBA.lead_score_respone ls=new leadSource_QS_MBA.lead_score_respone();                
                ls=LQ.gmass_Model(worldregion,ld.Country_Of_Residence_Name__c,ld.Degree_Objective__c,ld.Work_Load__c,regionvalues,worldregionid,region);
                ld.Conversion_Probability__c=ls.GMASS_MBA_probx;
                ld.Global_Lead_Score__c=ls.GMASS_MBA_Total;
                ld.Lead_Score__c=ls.GMASS_lead_score;
            }
           /* If(ld.LeadSource=='QS World MBA Tour' && ((Trigger.isinsert) ||(  Trigger.isupdate && oldld.Region__c!=ld.Region__c))){
                Typefull=ld.Work_Load__c=='Full-time Student'?'Full-time':ld.Work_Load__c; 
                String region=ld.Region__c!=null&&ld.Region__c!=''?ld.Region__c:'';
                
                leadSource_QS_MBA LQ=new leadSource_QS_MBA();
                leadSource_QS_MBA.lead_score_respone ls=new leadSource_QS_MBA.lead_score_respone();
                System.debug('Email=>:'+ld.email+'COR=>:'+ld.Country_Of_Residence_Name__c+'typeful=>:'+typeful+'region=>:'+region +'work=>:'+ld.GMASS_Work_Experience__c);
                ls=LQ.leadSource_QS_MBA(ld.email,typeful,ld.Country_Of_Residence_Name__c,ld.GMASS_Work_Experience__c,region);
                ld.Conversion_Probability__c=ls.QS_MBA_probx;
                ld.Global_Lead_Score__c=ls.QS_MBA_Total;
                ld.Lead_Score__c=ls.QS_lead_score;
                
                
            }*/
            /***********SFSUP-777 ---Start of SAT grouping functionality************/
            if(ld.Leadsource=='SAT'){
                if(ld.Undergraduate_Major__c!=oldld.Undergraduate_Major__c)
                {     
                  
                        if(ld.Undergraduate_Major__c!=NULL && sst.containskey(ld.Undergraduate_Major__c.tolowercase()))
                        {
                            ld.SAT_Grouping__c=sst.get(ld.Undergraduate_Major__c.tolowercase());
                        } 
                        else
                        {
                            ld.SAT_Grouping__c='General';
                        }
                }
           }
           else
           {
              ld.SAT_Grouping__c='General';
           }
           /***********SFSUP-777 ---END of SAT grouping functionality************/
           
           /***********SFSUP-787  Start of Sub region Logic functionality************/    
                           
           if((ld.Country_Of_Residence__c!=oldld.Country_Of_Residence__c ||ld.Region__c!=oldld.Region__c) ){  
              
               String cor=ld.region__c=='North Am'?ld.State:ld.Country_Of_Residence_Name__c;
               
               String Country= sub_region_logic.get_Subregion(ld.Region__c,cor,ld.Program_Parsed__c); 
               ld.Sub_region__c=Country!=Null?Country:ld.Region__c;
               System.debug('--->'+ld.Sub_region__c);
               
              
           }
           
           /***********SFSUP-787 ---End of Sub region Logic************/            
        
     }
   }
 }