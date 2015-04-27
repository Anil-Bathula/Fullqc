/*************************************************
Trigger   : Create_Rotation
Developer : Anil.B
Purpose   : To create rotation 2 records when concerned fields 
where filled in the contact and also update the existing 
rotation records when contact is update .
Test Class : Create_Rotation_Test(86%)

Enhancement : By SHS for SFSUP-746 on 7/1/2014
*************************************************/
trigger Create_Rotation on Contact (before update,after update) {

    list<Rotation__c>lstRotations=new list<Rotation__c>();
    list<Rotation__c>lstRotations2=new list<Rotation__c>();    
    Map<id,contact>varmap=new map<id,contact>();
    Map<id,contact>varmap1=new map<id,contact>();
    set<String>r1campus=new set<String>();
    set<String>r2campus=new set<String>();
    date myDate = date.newInstance(1899,01,01);
    String Insert_code;
    String ModE=Label.Rotation_ModE;
    String ModD=Label.Rotation_ModD;
 
    
    For(Contact c:Trigger.New){  
        //SFSUP-746 if condition
       // if(!RecordTypeHelper.isapplicationprocessrecordtype(c.Recordtypeid))  
        //    continue;
        If(Trigger.IsBefore){            
          
             If((trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
               trigger.oldMap.get(c.id).Rotation_1_Type__c==Null&& c.Rotation_1_Type__c!=Null && 
               trigger.oldmap.get(c.id).Rotation_1_Campus__c ==Null&& c.Rotation_1_Campus__c!=Null&&
               trigger.oldmap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==Null&&c.Rotation_1_Earliest_Elective_Start_Date__c!=Null &&
               trigger.oldmap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==Null&&c.Rotation_1_Latest_Elective_End_Date__c!=Null) &&
               (trigger.oldMap.get(c.id).Rotation_2_Type__c==Null&& c.Rotation_2_Type__c!=Null && 
               trigger.oldmap.get(c.id).Rotation_2_Campus__c ==Null&& c.Rotation_2_Campus__c!=Null&&
               trigger.oldmap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==Null&&c.Rotation_2_Earliest_Elective_Start_Date__c!=Null&&
               trigger.oldmap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==Null&&c.Rotation_2_Latest_Elective_End_Date__c!=Null)){
                  
                   insert_code='I';
                   set_scenariocode(c);                   
                   System.debug('INS==='+insert_code);
              }else if(
                        trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL&&c.Rotation_1_Type__c==ModD&&
                        trigger.oldMap.get(c.id).Rotation_1_Campus__c==NULL&&c.Rotation_1_Campus__c!=NULL&&
                        trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                        trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&& c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                        c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
                        (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                        trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&& c.Rotation_2_Type__c==NULL && 
                        trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL&&c.Rotation_2_Campus__c==NULL&&
                        trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                        trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&& c.Rotation_2_Latest_Elective_End_Date__c==NULL){
                        c.Rotations_Scenario__c = 'I-16';
                    }
                    /*************Condition-I-17**********/
                    else If(c.Rotation_1_Type__c==NULL&&
                        trigger.oldMap.get(c.id).Rotation_1_Campus__c==NULL&&c.Rotation_1_Campus__c==NULL&&
                        trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                        trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL&&c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                        c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c &&
                        (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                        trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&&c.Rotation_2_Type__c==ModE && 
                        trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL&&c.Rotation_2_Campus__c!=NULL&&
                        trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                        trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&&c.Rotation_2_Latest_Elective_End_Date__c!=NULL){
                         c.Rotations_Scenario__c = 'I-17';
                    }
                    /*************Condition-I-18**********/
                    else If(
                         trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL&&c.Rotation_1_Type__c==ModD&&                    
                         trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                         trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL&&c.Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                         c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c&&
                         (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                         trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&&c.Rotation_2_Type__c==NULL&&
                         trigger.oldMap.get(c.id).Rotation_2_campus__c==NULL&& c.Rotation_2_Campus__c==NULL&&
                         trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                         trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&&c.Rotation_2_Latest_Elective_End_Date__c==NULL){
                          System.debug('----i18-->'+c.Rotations_Scenario__c);
                            c.Rotations_Scenario__c = 'I-18';
                    }
                    /*************Condition-I-19**********/  
                    else If(
                          trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL && c.Rotation_1_Type__c==NULL&&
                          trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL && c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                          trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL && c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                          trigger.oldMap.get(c.id).Rotation_1_Campus__c ==NULL && c.Rotation_1_Campus__c ==NULL&&
                          c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c &&
                          (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                          trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL && c.Rotation_2_Type__c==ModE&&
                          trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL && c.Rotation_2_Campus__c!=NULL&&
                          trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL && c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&& 
                          trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL && c.Rotation_2_Latest_Elective_End_Date__c!=NULL)
                     {
                             c.Rotations_Scenario__c = 'I-19';                      
                    
                  }else if(trigger.oldMap.get(c.id).Rotation_1_Type__c!= c.Rotation_1_Type__c ||
                   trigger.oldmap.get(c.id).Rotation_1_Campus__c != c.Rotation_1_Campus__c   ||           
                   trigger.oldmap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c!=c.Rotation_1_Earliest_Elective_Start_Date__c||
                   trigger.oldmap.get(c.id).Rotation_1_Latest_Elective_End_Date__c!=c.Rotation_1_Latest_Elective_End_Date__c||
                   trigger.oldMap.get(c.id).Rotation_2_Type__c!=c.Rotation_2_Type__c||
                   trigger.oldmap.get(c.id).Rotation_2_Campus__c!=c.Rotation_2_Campus__c ||                  
                   trigger.oldmap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c!=c.Rotation_2_Earliest_Elective_Start_Date__c||
                   trigger.oldmap.get(c.id).Rotation_2_Latest_Elective_End_Date__c!=c.Rotation_2_Latest_Elective_End_Date__c){ 
                            set_scenariocode(c);
                   }  
        }
        if(Trigger.isAfter ){ 
         
            /************Condition I-16 ************/
            if(trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
            trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL&&c.Rotation_1_Type__c==ModD&&
            trigger.oldMap.get(c.id).Rotation_1_Campus__c==NULL&&c.Rotation_1_Campus__c!=NULL&&
            trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
            trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&& c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
            c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
            trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&& c.Rotation_2_Type__c==NULL && 
            trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL&&c.Rotation_2_Campus__c==NULL&&
            trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
            trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&& c.Rotation_2_Latest_Elective_End_Date__c==NULL){
                
                system.debug('--->'+c.Rotation_2_Type__c+c.Rotation_2_Campus__c+c.Rotation_2_Earliest_Elective_Start_Date__c);
                            Rotation__c r1 = new Rotation__c();                            
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=False;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=false;
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False;
                            r2.Earliest_Elective_Start_Date__c=mydate;
                            r2.Latest_Elective_End_Date__c=mydate; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=False;
                            
                            lstRotations2.add(r2);      
                   
                
               } /************Condition I-17************/
               else if(
                trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
                c.Rotation_1_Type__c==NULL&&
                trigger.oldMap.get(c.id).Rotation_1_Campus__c==NULL&&c.Rotation_1_Campus__c==NULL&&
                trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL&&c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c &&
                (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&&c.Rotation_2_Type__c==ModE && 
                trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL&&c.Rotation_2_Campus__c!=NULL&&
                trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&&c.Rotation_2_Latest_Elective_End_Date__c!=NULL){
                system.debug('--->'+c.Rotation_2_Type__c+c.Rotation_2_Campus__c+c.Rotation_2_Earliest_Elective_Start_Date__c);
                            Rotation__c r1 = new Rotation__c();                            
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=False;
                            r1.Earliest_Elective_Start_Date__c=mydate;
                            r1.Latest_Elective_End_Date__c=mydate;
                            r1.Rotation_Campus__c=NULL;
                            r1.Is_Rotating__c=false;
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=False;
                            
                            lstRotations2.add(r2);      
                
                
               }/*************Condition I-18**********/
                     else If(
                     trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
                     trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL&&c.Rotation_1_Type__c==ModD&&                    
                     trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                     trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL&&c.Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                     c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c&&
                     (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                     trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL&&c.Rotation_2_Type__c==NULL&&
                     trigger.oldMap.get(c.id).Rotation_2_campus__c==NULL&& c.Rotation_2_Campus__c==NULL&&
                     trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                     trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL&&c.Rotation_2_Latest_Elective_End_Date__c==NULL){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            
                            r1.Is_Rotating__c=True;
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False;
                            r2.Earliest_Elective_Start_Date__c=mydate;
                            r2.Latest_Elective_End_Date__c=mydate; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            
                            r2.Is_Rotating__c=False;
                            lstRotations2.add(r2);       
                    } /*************Condition-i-19**********/  
                     else If(
                      trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
                      trigger.oldMap.get(c.id).Rotation_1_Type__c==NULL && c.Rotation_1_Type__c==NULL&&
                      trigger.oldMap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==NULL && c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                      trigger.oldMap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==NULL && c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                      trigger.oldMap.get(c.id).Rotation_1_Campus__c ==NULL && c.Rotation_1_Campus__c ==NULL&&
                      c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c &&
                      (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                      trigger.oldMap.get(c.id).Rotation_2_Type__c==NULL && c.Rotation_2_Type__c==ModE&&
                      trigger.oldMap.get(c.id).Rotation_2_Campus__c==NULL && c.Rotation_2_Campus__c!=NULL&&
                      trigger.oldMap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==NULL && c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&& 
                      trigger.oldMap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==NULL && c.Rotation_2_Latest_Elective_End_Date__c!=NULL){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=false;
                            r1.Earliest_Elective_Start_Date__c=mydate;
                            r1.Latest_Elective_End_Date__c=mydate;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=false;
                           
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            
                            r2.Is_Rotating__c=true;
                            lstRotations2.add(r2);       
                    } 
                   else  If(trigger.oldMap.get(c.id).Rotations_Scenario__c==Null &&
                   trigger.oldMap.get(c.id).Rotation_1_Type__c==Null&& c.Rotation_1_Type__c!=Null && 
                   trigger.oldmap.get(c.id).Rotation_1_Campus__c ==Null&& c.Rotation_1_Campus__c!=Null&&
                   trigger.oldmap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c==Null&&c.Rotation_1_Earliest_Elective_Start_Date__c!=Null&&
                   trigger.oldmap.get(c.id).Rotation_1_Latest_Elective_End_Date__c==Null&&c.Rotation_1_Latest_Elective_End_Date__c!=Null&&
                   trigger.oldMap.get(c.id).Rotation_2_Type__c==Null&& c.Rotation_2_Type__c!=Null && 
                   trigger.oldmap.get(c.id).Rotation_2_Campus__c ==Null&& c.Rotation_2_Campus__c!=Null&&
                   trigger.oldmap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c==Null&&c.Rotation_2_Earliest_Elective_Start_Date__c!=Null&&
                   trigger.oldmap.get(c.id).Rotation_2_Latest_Elective_End_Date__c==Null&&c.Rotation_2_Latest_Elective_End_Date__c!=Null){
            
                    /*******Condition.......1*******/
                    If(((c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE) || 
                    (c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD) || 
                    (c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE))
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D & E';  //changed By anil.B for JIRA SFSUP-851
                            r1.Active__c=False;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=false;
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=false;
                            
                            lstRotations2.add(r2);       
                    }
                    /**************Condition-2**********/
                    else If(
                          c.Rotation_1_Type__c==ModD&&
                          c.Rotation_2_Type__c==ModE &&
                          c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c && 
                          c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c ){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=false;
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true;
                            
                            lstRotations2.add(r2);       
                    }
                    /**************Condition-3**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;                            
                            r1.Is_Rotating__c=true;
                            //
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=false;
                            
                            lstRotations2.add(r2);       
                    }
                   /**************Condition-4**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c 
                    &&c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=true;                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true;
                        
                            lstRotations2.add(r2);        
                    }
                    /**************Condition-5**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D & E';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c<c.Rotation_2_Earliest_Elective_Start_Date__c?c.Rotation_1_Earliest_Elective_Start_Date__c:c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c>c.Rotation_2_Latest_Elective_End_Date__c?c.Rotation_1_Latest_Elective_End_Date__c:c.Rotation_2_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=true;
                           
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=false;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;                             
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true; 
                            
                            lstRotations2.add(r2);      
                    }
                    /**************Condition-6**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c<c.Rotation_2_Earliest_Elective_Start_Date__c?c.Rotation_1_Earliest_Elective_Start_Date__c:c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c>c.Rotation_2_Latest_Elective_End_Date__c?c.Rotation_1_Latest_Elective_End_Date__c:c.Rotation_2_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=true; 
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod D';
                            r2.Active__c=false;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true; 
                            
                            lstRotations2.add(r2);        
                    }
                    /**************Condition-7**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=False;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=false; 
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod D';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true; 
                            
                            lstRotations2.add(r2);
                                    
                    }/**************Condition-7.1**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=True; 
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod D';
                            r2.Active__c=false;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=False; 
                            
                            lstRotations2.add(r2);        
                    }

                    /**************Condition-8**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod D';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=true; 
                            
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod D';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c; 
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true; 
                            
                            lstRotations2.add(r2);       
                    }
                    /**************Condition-9**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod E';
                            r1.Active__c=False;    //Changed by anil.B JIRA: SFSUP-851 
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=False;
                             
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true;
                              
                            lstRotations2.add(r2);   
                                
                    }/**************Condition-9.1**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod E';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=True;
                             
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False; //Changed by anil.B JIRA SFSUP-851
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=False; 
                             
                            lstRotations2.add(r2);       
                    }/**************Condition-9.2**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c&&
                    c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod E';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c<c.Rotation_1_Earliest_Elective_Start_Date__c?c.Rotation_2_Earliest_Elective_Start_Date__c:c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c>c.Rotation_1_Latest_Elective_End_Date__c?c.Rotation_2_Latest_Elective_End_Date__c:c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=True;
                             
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=False; //Changed by anil.B JIRA SFSUP-851
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c<c.Rotation_1_Earliest_Elective_Start_Date__c?c.Rotation_2_Earliest_Elective_Start_Date__c:c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c>c.Rotation_1_Latest_Elective_End_Date__c?c.Rotation_2_Latest_Elective_End_Date__c:c.Rotation_1_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=True;
                              
                            lstRotations2.add(r2);       
                    }
                    /**************Condition-10**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    && c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            Rotation__c r1 = new Rotation__c();
                            r1.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r1.Student__c=c.id;
                            r1.Rotation_number__c='Rotation 1'; 
                            r1.Type__c='Mod E';
                            r1.Active__c=True;
                            r1.Earliest_Elective_Start_Date__c=c.Rotation_1_Earliest_Elective_Start_Date__c;
                            r1.Latest_Elective_End_Date__c=c.Rotation_1_Latest_Elective_End_Date__c;
                            r1.Rotation_Campus__c=c.Rotation_1_Campus__c;
                            r1.Is_Rotating__c=true;
                             
                            lstRotations.add(r1);
                            
                            Rotation__c r2 = new Rotation__c();
                            r2.Name=c.Rotation_2_Type__c+'-'+c.Rotation_2_Campus__c;
                            r2.Student__c=c.id;
                            r2.Rotation_number__c='Rotation 2'; 
                            r2.Type__c='Mod E';
                            r2.Active__c=True;
                            r2.Earliest_Elective_Start_Date__c=c.Rotation_2_Earliest_Elective_Start_Date__c;
                            r2.Latest_Elective_End_Date__c=c.Rotation_2_Latest_Elective_End_Date__c;
                            r2.Rotation_Campus__c=c.Rotation_2_Campus__c;
                            r2.Is_Rotating__c=true; 
                             
                            lstRotations2.add(r2);       
                    }
                    
             }/**********If program conditions for update rotation 1 & 2**********/
             else if(trigger.oldMap.get(c.id).Rotation_1_Type__c!=c.Rotation_1_Type__c ||
               trigger.oldmap.get(c.id).Rotation_1_Campus__c !=c.Rotation_1_Campus__c   ||           
               trigger.oldmap.get(c.id).Rotation_1_Earliest_Elective_Start_Date__c!=c.Rotation_1_Earliest_Elective_Start_Date__c||
               trigger.oldmap.get(c.id).Rotation_1_Latest_Elective_End_Date__c!=c.Rotation_1_Latest_Elective_End_Date__c||
               trigger.oldMap.get(c.id).Rotation_2_Type__c!=c.Rotation_2_Type__c||
               trigger.oldmap.get(c.id).Rotation_2_Campus__c!=c.Rotation_2_Campus__c ||                  
               trigger.oldmap.get(c.id).Rotation_2_Earliest_Elective_Start_Date__c!=c.Rotation_2_Earliest_Elective_Start_Date__c||
               trigger.oldmap.get(c.id).Rotation_2_Latest_Elective_End_Date__c!=c.Rotation_2_Latest_Elective_End_Date__c
               ){
                        
                   varmap.put(c.id,c); 
                   if(trigger.oldmap.get(c.id).Rotation_1_Campus__c != c.Rotation_1_Campus__c ){
                       r1campus.add(c.Rotation_1_Campus__c);
                       System.debug('=====r1campus=======>'+varmap);
                   }  
                   if(trigger.oldmap.get(c.id).Rotation_2_Campus__c!=c.Rotation_2_Campus__c){
                         r2campus.add(c.Rotation_2_Campus__c);
                         System.debug('=====r2campus=======>'+varmap);
                  }  
                 
                  
             }
             
             
        }
    }insert lstRotations;
     insert lstRotations2;
     
   /*This block is for update operation of rotations */
   
if(!varmap.isempty()){
        
        
        Map<String,id>vt=new map<String,id>();  
        List<Rotation__c>lstRoataions=[Select id,name,Student__c,Rotation_Campus__c,Is_Rotating__c,Active__c,Rotation_Number__c,Type__c from Rotation__c where Student__c IN:varmap.keyset()];
        
        System.debug('***lstRoataions***=>'+lstRoataions);
       
         /*This block is to get visa track records */
                 
        for( Visa_Track__c lstvt:[select id,Name,Campus1__c,Campus2__c,Campus_3__c,Country__r.Name from Visa_Track__c where Name LIKE 'CAMPUS CHANGED%'])
        {
            if(lstvt.Campus1__c!=null){
                vt.put(lstvt.Campus1__c,lstvt.Id);
            }if(lstvt.campus2__c!=null){
                vt.put(lstvt.campus2__c,lstvt.Id);
            }if(lstvt.Campus_3__c!=null){
                vt.put(lstvt.Campus_3__c,lstvt.Id);
            }
        }
         
           
For(Rotation__c r:lstRoataions) {
/***********This is to update rotation 1 record *************/

   
        
        /*******Update-Condition.......1*******/
                    If(((varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModE) || 
                    (varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModD) || 
                    (varmap.get(r.student__c).Rotation_1_Type__c==ModE&&varmap.get(r.student__c).Rotation_2_Type__c==ModE))
                    
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_1_Campus__c && varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_2_Campus__c){
                            if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)) {
                                System.debug('***Rotation 1***=>'+r.Rotation_Number__c);
                                r.Type__c='Mod D & E';
                                r.Active__c=False;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                                r.Is_Rotating__c=false;
                                if(!r1campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations.add(r);
                           }
                           if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){
                                 System.debug('***Rotation 2***=>'+r.Rotation_Number__c);
                                r.Type__c='Mod E';
                                r.Active__c=False;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c; 
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=false;
                                if(!r2campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r); 
                          }      
                    }
                    /**************Update-Condition-2**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c!=Null &&
                        varmap.get(r.student__c).Rotation_1_Type__c==ModD&&
                        varmap.get(r.student__c).Rotation_2_Type__c==ModE &&
                        varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_1_Campus__c && 
                        varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                            if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                           
                                r.Type__c='Mod D';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                                r.Is_Rotating__c=false;
                                if(!r1campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations.add(r);
                            }
                            if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                             
                                r.Type__c='Mod E';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c; 
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=true;
                                if(!r2campus.IsEmpty() ){
                                   r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r); 
                            }      
                    }
                    /**************update-Condition-3**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c!=Null &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c && varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_2_Campus__c){
                            if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                                r.Type__c='Mod D';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;                            
                                r.Is_Rotating__c=true;
                                if(!r1campus.IsEmpty()){
                                  r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations.add(r);
                            }
                            if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                            
                                r.Type__c='Mod E';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c; 
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=false;
                                if(!r2campus.IsEmpty()){
                                  r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r);
                            }       
                    }
                   /**************update-Condition-4**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c!=Null &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c && varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c 
                    &&varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                           if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                                r.Type__c='Mod D';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                                r.Is_Rotating__c=true;
                                if(!r1campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations.add(r);
                           }
                           if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){
                                r.Type__c='Mod E';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=true;
                                if(!r2campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r); 
                          }       
                    }
                    /**************update-Condition-5**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c!=Null &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c &&varmap.get(r.student__c).Rotation_1_Campus__c==varmap.get(r.student__c).Rotation_2_Campus__c){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){                               
                                r.Type__c='Mod D & E';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c<varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c?varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c:varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c>varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c?varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c:varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                                r.Is_Rotating__c=true;
                                if(!r1campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations.add(r);
                          }
                          if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                         
                                r.Type__c='Mod E';
                                r.Active__c=false;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;                             
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=true; 
                                if(!r2campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r); 
                          }     
                    }
                    /**************update-Condition-6**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModD
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c &&varmap.get(r.student__c).Rotation_1_Campus__c==varmap.get(r.student__c).Rotation_2_Campus__c){
                        if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            
                            r.Type__c='Mod D';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c<varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c?varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c:varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c>varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c?varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c:varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=true; 
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations.add(r);
                            
                       }
                       if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            Rotation__c r2 = new Rotation__c();
                             
                            r.Type__c='Mod E';
                            r.Active__c=false;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=true; 
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r); 
                          }       
                    }
                    /**************update-Condition-7**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModD
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_1_Campus__c &&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){                       
                                r.Type__c='Mod D';
                                r.Active__c=true;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                                r.Is_Rotating__c=false;
                                if(!r1campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                } 
                                lstRotations.add(r);
                          }
                          if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                          
                                r.Type__c='Mod D';
                                r.Active__c=True;
                                r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                                r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                                r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                                r.Is_Rotating__c=true; 
                                if(!r2campus.IsEmpty()){
                                    r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                                }
                                lstRotations2.add(r);
                          }
                                    
                    }/**************update-Condition-7.1**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModD
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_2_Campus__c&&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){                           
                            r.Type__c='Mod D';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=True; 
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                     
                            r.Type__c='Mod D';
                            r.Active__c=false;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations2.add(r);  
                        }      
                    }

                    /**************update-Condition-8**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModD&&varmap.get(r.student__c).Rotation_2_Type__c==ModD
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c &&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                        if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod D';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=true; 
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations.add(r);
                        }
                        if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){                          
                            r.Type__c='Mod D';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c; 
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=true; 
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r); 
                         }      
                    }
                    /**************update-Condition-9**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModE&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_1_Campus__c &&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                         if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){   
                            
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=true;
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }  
                            lstRotations2.add(r);   
                         }       
                    }/**************update-Condition-9.1**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModE&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_2_Campus__c&&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                         if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=True; 
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){   
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r); 
                         }     
                    
                    }/**************update-Condition-9.2**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModE&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c&&
                    varmap.get(r.student__c).Rotation_1_Campus__c==varmap.get(r.student__c).Rotation_2_Campus__c){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c<varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c?varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c:varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c>varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c?varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c:varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=True; 
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){   
                            r.Type__c='Mod E';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c<varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c?varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c:varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c>varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c?varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c:varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=True;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r); 
                         }    
                    
                    }
                    /**************update-Condition-10**********/
                    else If(varmap.get(r.student__c).Program_Parsed__c=='EMBA' &&varmap.get(r.student__c).Rotation_1_Type__c==ModE&&varmap.get(r.student__c).Rotation_2_Type__c==ModE
                    && varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c &&varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c&&
                    varmap.get(r.student__c).Rotation_1_Campus__c!=varmap.get(r.student__c).Rotation_2_Campus__c){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=true;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=true;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                          }     
                    }/*************update-Condition-U-16**********/
                  else If(
                  varmap.get(r.student__c).Rotation_1_Type__c==ModD&&
                  varmap.get(r.student__c).Rotation_2_Type__c==NULL&&
                  varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                  varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                  varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_1_Campus__c &&
                  (varmap.get(r.student__c).Program_Parsed__c=='EMBA' ||varmap.get(r.student__c).Program_Parsed__c=='BBA')&&
                  varmap.get(r.student__c).Rotation_2_Campus__c==NULL&&
                  varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c==NULL&& 
                  varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c==NULL){
                        if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod D';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=myDate;
                            r.Latest_Elective_End_Date__c=myDate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                         }
                      }/*************update-Condition-U-17**********/
                      else If(
                      varmap.get(r.student__c).Rotation_1_Type__c==NULL&&                     
                      varmap.get(r.student__c).Rotation_1_Campus__c==NULL &&
                      varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                      varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c==NULL&&
                      varmap.get(r.student__c).Campus_parsed_from_Program__c==varmap.get(r.student__c).Rotation_2_Campus__c&& 
                      (varmap.get(r.student__c).Program_Parsed__c=='EMBA' ||varmap.get(r.student__c).Program_Parsed__c=='BBA')&&
                      varmap.get(r.student__c).Rotation_2_Campus__c!=NULL&&                     
                      varmap.get(r.student__c).Rotation_2_Type__c==ModE&&
                      varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                      varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c!=NULL){
                         if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod D';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=mydate;
                            r.Latest_Elective_End_Date__c=mydate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                          }        
                    }/*************update-Condition-U-18**********/
                    else If(
                          varmap.get(r.student__c).Rotation_1_Type__c==ModD&&                     
                          varmap.get(r.student__c).Rotation_1_Campus__c!=NULL &&
                          varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                          varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                          varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c&& 
                          (varmap.get(r.student__c).Program_Parsed__c=='EMBA' ||varmap.get(r.student__c).Program_Parsed__c=='BBA')&&
                          varmap.get(r.student__c).Rotation_2_Campus__c==NULL&&                     
                          varmap.get(r.student__c).Rotation_2_Type__c==NULL&&
                          varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                          varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c==NULL){
                            
                            
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod D';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=True;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=mydate;
                            r.Latest_Elective_End_Date__c=mydate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                          }
                              
                    }/*************update-Condition-U-19**********/
                    else If(
                      varmap.get(r.student__c).Rotation_1_Type__c==NULL&&                     
                      varmap.get(r.student__c).Rotation_1_Campus__c==NULL &&
                      varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                      varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c==NULL&&
                      varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c&& 
                      (varmap.get(r.student__c).Program_Parsed__c=='EMBA' ||varmap.get(r.student__c).Program_Parsed__c=='BBA')&&
                      varmap.get(r.student__c).Rotation_2_Campus__c!=NULL&&                     
                      varmap.get(r.student__c).Rotation_2_Type__c==ModE&&
                      varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                      varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c!=NULL){
                         if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod D';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=Mydate;
                            r.Latest_Elective_End_Date__c=Mydate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=True;
                            r.Earliest_Elective_Start_Date__c=varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c;
                            r.Latest_Elective_End_Date__c=varmap.get(r.student__c).Rotation_2_Latest_Elective_End_Date__c;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=True;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                          }        
                              
                    }/*************update-Condition-20**********/
                     else If(varmap.get(r.student__c).Program_Parsed__c!=Null &&
                             varmap.get(r.student__c).Rotation_1_Type__c==NULL&&                             
                             varmap.get(r.student__c).Rotation_1_Campus__c==NULL &&
                             varmap.get(r.student__c).Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                             varmap.get(r.student__c).Rotation_1_Latest_Elective_End_Date__c==NULL&&
                             varmap.get(r.student__c).Rotation_2_Campus__c==NULL&&
                             (varmap.get(r.student__c).Program_Parsed__c=='EMBA' ||varmap.get(r.student__c).Program_Parsed__c=='BBA')&&
                             varmap.get(r.student__c).Rotation_2_Type__c==NULL&&  
                             varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c==NULL &&
                             varmap.get(r.student__c).Rotation_2_Earliest_Elective_Start_Date__c==NULL){
                          if(r.Rotation_Number__c=='Rotation 1' && varmap.containsKey(r.student__c)){
                            r.Type__c='Mod D';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=Mydate;
                            r.Latest_Elective_End_Date__c=Mydate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_1_Campus__c;
                            r.Is_Rotating__c=False;
                            if(!r1campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_1_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            } 
                            lstRotations.add(r);
                         }
                         if(r.Rotation_Number__c=='Rotation 2' && varmap.containsKey(r.student__c)){ 
                            r.Type__c='Mod E';
                            r.Active__c=False;
                            r.Earliest_Elective_Start_Date__c=mydate;
                            r.Latest_Elective_End_Date__c=mydate;
                            r.Rotation_Campus__c=varmap.get(r.student__c).Rotation_2_Campus__c;
                            r.Is_Rotating__c=False;  
                            if(!r2campus.IsEmpty()){
                                r.Visa_Track__c=varmap.get(r.student__c).Campus_parsed_from_Program__c!=varmap.get(r.student__c).Rotation_2_Campus__c?vt.get(r.Rotation_Campus__c):NULL;
                            }
                            lstRotations2.add(r);  
                          }        
                              
                    } 
                    
    
       
        
    }
    
}update lstRotations;
 update lstRotations2;
 
 
 //Method to update Scenario Code for insert and Update operations
 
 public void set_scenariocode(Contact c){
     
        /*******Condition.......1*******/
                    If(((c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE) || 
                    (c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD) || 
                    (c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE))
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-1':'U-1';
                    }/**************Condition-2**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c){
                           c.Rotations_Scenario__c = Insert_code=='I'?'I-2':'U-2';
                    } /**************Condition-3**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c){
                             c.Rotations_Scenario__c = Insert_code=='I'?'I-3':'U-3';
                    }/**************Condition-4**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c 
                    &&c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                             c.Rotations_Scenario__c = Insert_code=='I'?'I-4':'U-4';
                     }/**************Condition-5**********/
                    else If(c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                        c.Rotations_Scenario__c =Insert_code=='I'?'I-5':'U-5';
                    } /**************Condition-6**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-6':'U-6';
                    }/**************Condition-7**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                           c.Rotations_Scenario__c = Insert_code=='I'?'I-7':'U-7';
                    }/**************Condition-7.1**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-7.1':'U-7.1';
                    }/**************Condition-8**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-8':'U-8';
                    }/**************Condition-9**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c &&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-9':'U-9';
                    }/**************Condition-9.1**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                            c.Rotations_Scenario__c =Insert_code=='I'?'I-9.1': 'U-9.1';
                    }/**************Condition-9.2**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c&&
                    c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                             c.Rotations_Scenario__c =Insert_code=='I'?'I-9.2': 'U-9.2';
                            
                    }/**************Condition-10**********/
                    else If(c.Program_Parsed__c=='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    && c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c &&c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c&&
                    c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                    System.debug('Insert_code==='+Insert_code);
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-10':'U-10';
                            
                    } /**************Condition-11**********/
                    else If(c.Program_Parsed__c!='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    && c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Rotation_1_Campus__c==c.Rotation_2_Campus__c){
                            c.Integration_Error__c=True; 
                            System.debug('11-Insert_code==='+Insert_code);
                            c.Rotations_Scenario__c = Insert_code=='I'?'I-11':'U-11'; 
                            System.debug('&&&&&&&&'+c.Integration_Error__c);  
                    }
                    /**************Condition-12**********/
                    else If(c.Program_Parsed__c!='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD&&
                    (c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c ||c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c )
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c){
                                c.Integration_Error__c=True;
                                c.Rotations_Scenario__c = Insert_code=='I'?'I-12':'U-12';
                    }
                   /**************Condition-13**********/
                    else If(c.Program_Parsed__c!='EMBA' &&c.Rotation_1_Type__c==ModD&&c.Rotation_2_Type__c==ModD
                    && c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c 
                    &&c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                                c.Integration_Error__c=True;
                                c.Rotations_Scenario__c = Insert_code=='I'?'I-13':'U-13';
                    }
                    /**************Condition-14**********/
                    else If(c.Program_Parsed__c!='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE&&
                    (c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c ||c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c )
                    &&c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                                c.Integration_Error__c=True;
                                c.Rotations_Scenario__c = Insert_code=='I'?'I-14':'U-14';
                    }
                    /*************Condition-15**********/
                    else If(c.Program_Parsed__c!='EMBA' &&c.Rotation_1_Type__c==ModE&&c.Rotation_2_Type__c==ModE
                    &&c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c && c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c 
                    &&c.Rotation_1_Campus__c!=c.Rotation_2_Campus__c){
                                c.Integration_Error__c=True;
                                c.Rotations_Scenario__c = Insert_code=='I'?'I-15':'U-15';
                    }
                    /*************Condition-16**********/ 
                    else If(
                    
                            c.Rotation_1_Type__c==ModD&&                     
                            c.Rotation_1_Campus__c!=NULL &&
                            c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                            c.Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                            c.Campus_parsed_from_Program__c==c.Rotation_1_Campus__c&& 
                            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                            c.Rotation_2_Campus__c==NULL&&                     
                            c.Rotation_2_Type__c==NULL&&
                            c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                            c.Rotation_2_Latest_Elective_End_Date__c==NULL                                                        
                            ){
                            c.Rotations_Scenario__c ='U-16';
                    }
                    /*************Condition-17**********/
                    else If(
                            c.Rotation_1_Type__c==NULL&&                     
                            c.Rotation_1_Campus__c==NULL &&
                            c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                            c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                            c.Campus_parsed_from_Program__c==c.Rotation_2_Campus__c&& 
                            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                            c.Rotation_2_Campus__c!=NULL&&                     
                            c.Rotation_2_Type__c==ModE&&
                            c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                            c.Rotation_2_Latest_Elective_End_Date__c!=NULL){
                           c.Rotations_Scenario__c ='U-17';
                    }
                    /*************Condition-18**********/
                    else If(
                            c.Rotation_1_Type__c==ModD&&                     
                            c.Rotation_1_Campus__c!=NULL &&
                            c.Rotation_1_Earliest_Elective_Start_Date__c!=NULL&&
                            c.Rotation_1_Latest_Elective_End_Date__c!=NULL&&
                            c.Campus_parsed_from_Program__c!=c.Rotation_1_Campus__c&& 
                            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                            c.Rotation_2_Campus__c==NULL&&                     
                            c.Rotation_2_Type__c==NULL&&
                            c.Rotation_2_Earliest_Elective_Start_Date__c==NULL&&
                            c.Rotation_2_Latest_Elective_End_Date__c==NULL){
                            c.Rotations_Scenario__c ='U-18';
                    }
                    /*************Condition-19**********/  
                    else If(
                            c.Rotation_1_Type__c==NULL&&                     
                            c.Rotation_1_Campus__c==NULL &&
                            c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                            c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                            c.Campus_parsed_from_Program__c!=c.Rotation_2_Campus__c&& 
                            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                            c.Rotation_2_Campus__c!=NULL&&                     
                            c.Rotation_2_Type__c==ModE&&
                            c.Rotation_2_Earliest_Elective_Start_Date__c!=NULL&&
                            c.Rotation_2_Latest_Elective_End_Date__c!=NULL){
                             c.Rotations_Scenario__c ='U-19';                      
                    }/*************Condition-U-20**********/
                    else If(
                            c.Rotation_1_Type__c==NULL&&                        
                            c.Rotation_1_Campus__c==NULL &&             
                            c.Rotation_1_Earliest_Elective_Start_Date__c==NULL&&
                            c.Rotation_1_Latest_Elective_End_Date__c==NULL&&
                            (c.Program_Parsed__c=='EMBA' ||c.Program_Parsed__c=='BBA')&&
                            c.Rotation_2_Campus__c==NULL&&
                            c.Rotation_2_Type__c==NULL&&
                            c.Rotation_2_Earliest_Elective_Start_Date__c==NULL && 
                            c.Rotation_2_Earliest_Elective_Start_Date__c==NULL){
                           c.Rotations_Scenario__c = 'U-20'; 
                    } 
                    else {c.Integration_Error__c = True;} 
 }
 
 
}