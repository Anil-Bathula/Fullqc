trigger Exam_ApplicationOwner_Updater on Exam__c (before insert, before update,after insert,after update) 
{
/*
      Modified  : Harsha Simha
      Date      : 24/09/2013
      Comment   : Changed Exam_Type Map values.
      Test Class: validation_AAM_Test(90%)
      Modified  : Prem (21/08/2014)- I have added Cambridge First Test type into the map.
      Modified Prem : SFSUP-767
*/
  map<string,string> exam_type=new map<string,string>{'GMAT'=>'Admission','GRE'=>'Admission','Master GMAT'=>'Admission','SAT'=>'Admission','ACT'=>'Admission','SHL'=>'Admission','BULATS online'=>'Admission','Wonderlic'=>'Admission','TOEFL'=>'Language','IELTS'=>'Language','Cambridge Advanced'=>'Language','Cambridge Proficiency'=>'Language','Cambridge Business'=>'Language','Pearson/PTE'=>'Language','TOEIC'=>'Language','IEMA'=>'Language','BEST'=>'Language','UPIBT'=>'Language','City & Guilds'=>'Language','Cambridge First Certificate'=>'Language','Cambridge First'=>'Language'};
  //map<string,string> exam_type=new map<string,string>{'GMAT'=>'Admission','GRE'=>'Admission','SAT'=>'Admission','ACT'=>'Admission','SHL'=>'Admission','TOEFL'=>'Language','IELTS'=>'Language','Cambridge Advanced'=>'Language','Pearson/PTE'=>'Language','TOEIC'=>'Language','Cambridge Advanced or Higher'=>'Language','TOEFL or Equivalent'=>'Language'};
  if(trigger.isbefore)
  {  /*Daniel Mora code*/
    /*
      Modified  : Harsha Simha
      Date      : 04/04/2013
        Comment   : created 2 formula fields and assigned it to same object 2 reference fields 
              as these 2 reference fields are used in Email updates.    
      Test Class: validation_AAM_Test(90%)
    */
    map<String,Exam__c> opexams=new map<string,Exam__c>();
       for(Exam__c ex: Trigger.New )  
       {     
          
          if(ex.Application__c!=null && (ex.Application_Owner__c!=ex.op_Application_owner__c || ex.Converter__c!=ex.op_Converter__c))   
          {
            ex.Application_Owner__c=ex.op_Application_owner__c;
            ex.Converter__c=ex.op_Converter__c;
            //opexams.put(ex.Application__c,ex);
          }     //Trigger Action Logic  
       }
       /*
       if(!opexams.KeySet().ISEmpty())
       {
         List<Opportunity> oppList = [Select id, Conversion_Team_Member__c, OwnerId from Opportunity where id IN: opexams.Keyset()];        
       for(Opportunity opp:oppList)  
        {   
          Exam__c ex=opexams.get(opp.Id);
            ex.Application_Owner__c = opp.OwnerId;  
            ex.Converter__c= opp.Conversion_Team_Member__c; 
        }
       }        */       
         
    /*      
    Trigger   : Exam_ApplicationOwner_Updater          
      Developer : Harsha Simha S
      Date      : 04/04/2013
      Comment   : Only AAm and System Admins can set AAM Validated Falg to true.
            AAm Validated canot be true for 'Apply for test Waiver' and 'No test required' Exam Types
            There can be max of 2 AAm validated for an Application and 1 should be of Admission type and another should be of Language Type.    
    Test Class: validation_AAM_Test(90%)  
  
  */
    
              
    list<String> opids=new list<String>();  
    map<String,list<Exam__c>> opp_exam_ids=new map<String,list<Exam__c>>();
    string prof=RecordTypeHelper.getprofileName(Userinfo.getProfileId());  
    for(Exam__c ex:trigger.New)
    {  //Exam__c.AAM_validate_updater_usedin_code_only__c
      ex.AAM_validate_updater_usedin_code_only__c=false;
      if(Trigger.isInsert && ex.AAM_Validated__c)
      {
        if(ex.Exam_Type__c=='Apply for test waiver'||ex.Exam_Type__c=='No test required' || ex.Exam_Type__c==null)
        {
          ex.addError('AAM Validated canot be true for Test Type :: '+ex.Exam_Type__c);
        }
        else if(prof!='Operations-AAM' && prof!='System Administrator')
        {
          ex.addError('you dont have permissions to set AAM Validated field.');
        }
        else if(ex.Application__c!=null)
        {  
          ex.AAM_validate_updater_usedin_code_only__c=true;
          opids.add(ex.Application__c);  
          list<Exam__c> exam_ids=opp_exam_ids.containsKey(ex.Application__c)?opp_exam_ids.get(ex.Application__c):new list<Exam__c>();
          exam_ids.add(ex);
          opp_exam_ids.put(ex.Application__c,exam_ids);
        }
      }
      if(Trigger.isUpdate && ex.AAM_Validated__c!=Trigger.oldMap.get(ex.Id).AAM_Validated__c && ex.AAM_Validated__c )
      {
        if(ex.Exam_Type__c=='Apply for test waiver'||ex.Exam_Type__c=='No test required'|| ex.Exam_Type__c==null)
        {
          ex.addError('AAM Validated canot be true for Test Type :: '+ex.Exam_Type__c);
        }
        else if(prof!='Operations-AAM' && prof!='System Administrator')
        {
          ex.addError('you dont have permissions to set AAM Validated field.');
        }
        else if(ex.Application__c!=null)
        {  
          ex.AAM_validate_updater_usedin_code_only__c=true;
          opids.add(ex.Application__c);  
          list<Exam__c> exam_ids=opp_exam_ids.containsKey(ex.Application__c)?opp_exam_ids.get(ex.Application__c):new list<Exam__c>();
          exam_ids.add(ex);
          opp_exam_ids.put(ex.Application__c,exam_ids);
        }
      }
    }
    if(!opids.IsEmpty())
    {
      map<string,set<String>> exms=new map<String,set<string>>();
      list<Exam__c> exams=[select id,Name,AAm_Validated__c,Application__c,Exam_Type__c from Exam__c where Application__c IN: opids and AAm_VAlidated__c=true and Exam_Type__c IN:exam_type.keyset() ];
      if(!exams.IsEmpty())
      {
        for(Exam__c ex:exams)
        {
          set<String> temp=exms.containsKey(ex.Application__c)?exms.get(ex.Application__c):new set<String>();
          temp.add(exam_type.get(ex.Exam_Type__c));
          exms.put(ex.Application__c,temp);  
        }
      }
      for(Exam__c exm:Trigger.New)
      {
        if(!exm.AAM_validate_updater_usedin_code_only__c)
          continue;  
        exm.AAM_validate_updater_usedin_code_only__c=false;        
        if(!exms.containsKey(exm.Application__c))
          continue;
        if(exms.get(exm.Application__c).contains(exam_type.get(exm.Exam_Type__c)))
          exm.addError('A validated '+exam_type.get(exm.Exam_Type__c) +' exists, please find it and un-validate it if you wish to proceed');  
      }      
    }
  }
  if(Trigger.isAfter)
  {
    Map<string,List<Exam__c>> exammaps=new map<String,List<Exam__c>>();
    Map<string,List<Exam__c>> exammaps_unset=new map<String,List<Exam__c>>();
    
    for(Exam__c ex:trigger.New)
    {
      if(Trigger.isInsert && ex.AAM_Validated__c)
      {
        list<Exam__c> exam_ids=exammaps.containsKey(ex.Application__c)?exammaps.get(ex.Application__c):new list<Exam__c>();
        exam_ids.add(ex);
        exammaps.put(ex.Application__c,exam_ids);          
      }
      if(Trigger.isUpdate && ex.AAM_Validated__c && ((ex.AAM_Validated__c != Trigger.oldMap.get(ex.Id).AAM_Validated__c || ex.Exam_Score__c!=Trigger.oldMap.get(ex.Id).Exam_Score__c)||(ex.Test_Waiver__c!=Trigger.oldMap.get(ex.Id).Test_Waiver__c)||(ex.GMAT_Equivalent__c!=Trigger.oldMap.get(ex.Id).GMAT_Equivalent__c)||(ex.TOEFL_Equivalent__c!=Trigger.oldMap.get(ex.Id).TOEFL_Equivalent__c)))
      {
        list<Exam__c> exam_ids=exammaps.containsKey(ex.Application__c)?exammaps.get(ex.Application__c):new list<Exam__c>();
        exam_ids.add(ex);
        exammaps.put(ex.Application__c,exam_ids);        
      }
      if(trigger.isUpdate && !ex.AAM_Validated__c && (ex.AAM_Validated__c != Trigger.oldMap.get(ex.Id).AAM_Validated__c ))
      {
        list<Exam__c> exam_ids=exammaps.containsKey(ex.Application__c)?exammaps.get(ex.Application__c):new list<Exam__c>();
        exam_ids.add(ex);
        exammaps_unset.put(ex.Application__c,exam_ids);
      }
      
    }
    if(!exammaps.keyset().isEmpty() || !exammaps_unset.keyset().isEmpty() )
    {
      List<Opportunity> listopps=[select id,Name,Type_of_Validated_Language__c,Validated_Language_Test_Score__c,
                    Type_of_Validated_Admission_Test__c,Validated_Admission_Test_Score__c,
                    Language_Test_Waiver__c,Admission_Test_Waiver__c from Opportunity where id IN:exammaps.keySet() or id IN:exammaps_unset.keyset()];
      for(integer i=0;i<listopps.size();i++)
      {
        if(exammaps_unset.containsKey(listopps[i].id))
        {
          for(Exam__c ex:exammaps_unset.get(listopps[i].id))
          {          
            if(!ex.AAM_Validated__c && exam_type.get(ex.Exam_Type__c)=='Language')  
            {  
              listopps[i].Type_of_Validated_Language__c=null;
              listopps[i].Validated_Language_Test_Score__c=null;
            }
            if(!ex.AAM_Validated__c && exam_type.get(ex.Exam_Type__c)=='Admission')
            {
              listopps[i].Type_of_Validated_Admission_Test__c=null;
              listopps[i].Validated_Admission_Test_Score__c=null;
            }
          }
        }
        if(exammaps.containsKey(listopps[i].id))
        {
          for(Exam__c ex:exammaps.get(listopps[i].id))
          {          
            if(ex.AAM_Validated__c && exam_type.get(ex.Exam_Type__c)=='Language')  
            {  
              listopps[i].Type_of_Validated_Language__c=ex.Exam_Type__c;
              listopps[i].Validated_Language_Test_Score__c=ex.Exam_Score__c;
              listopps[i].Validated_Lang_Test_Score_TOEFL_Eq__c=ex.TOEFL_Equivalent__c;
              listopps[i].Language_Test_Waived__c=ex.Test_Waiver__c;
              listopps[i].Language_Test_Waiver__c=ex.Waiver_Reason__c;
            }
            if(ex.AAM_Validated__c && exam_type.get(ex.Exam_Type__c)=='Admission')
            {
              listopps[i].Type_of_Validated_Admission_Test__c=ex.Exam_Type__c;
              listopps[i].Validated_Admission_Test_Score__c=ex.Exam_Score__c;
              listopps[i].Validated_Adm_Test_Score_GMAT_Eq__c=ex.GMAT_Equivalent__c;
              listopps[i].Admission_Test_Waived__c=ex.Test_Waiver__c;
              listopps[i].Admission_Test_Waiver__c=ex.Waiver_Reason__c;
            }
          }
        }        
      }
      try{
        update listopps;
      }
      catch(Exception e){system.debug( e);}
    }
  }
}