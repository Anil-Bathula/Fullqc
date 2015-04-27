/*trigger create_rotation coverage (85%) */
@isTest
public class Create_Rotation_Test{
    public static testmethod void methodname(){
    
    List<Contact>cs=new list<Contact>();
    List<Contact>updtecs=new list<Contact>();
    
    String ModE=Label.Rotation_ModE;
    String ModD=Label.Rotation_ModD;
    
       Program__c pr=new program__c();
       pr.Name='EMBA-UK-London';
       insert pr;
       
       Program__c pr1=new program__c();
       pr1.Name='MBA-UK-London';
       insert pr1;
       
        Contact c = new Contact();
        c.FirstName = 'FirstName12';
        c.LastName = 'LastName12';
        c.Email = 'Create_Rotation_Test1@samples.com';
        c.Program_Primary__c=pr.id;
        c.Rotations_Scenario__c=Null ;     
        c.Rotation_1_Type__c=null;
        c.Rotation_1_Campus__c=null;
        c.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c.Rotation_1_Latest_Elective_End_Date__c=null;
        c.Rotation_2_Type__c=null;
        c.Rotation_2_Campus__c=null;
        c.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c);
        
        Contact c1 = new Contact();
        c1.FirstName = 'FirstName12';
        c1.LastName = 'LastName12';
        c1.Email = 'Create_Rotation_Test2@samples.com';
        c1.Program_Primary__c=pr.id;
        c1.Rotations_Scenario__c=Null ;     
        c1.Rotation_1_Type__c=null;
        c1.Rotation_1_Campus__c=null;
        c1.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c1.Rotation_1_Latest_Elective_End_Date__c=null;
        c1.Rotation_2_Type__c=null;
        c1.Rotation_2_Campus__c=null;
        c1.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c1.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c1);
        
        Contact c2 = new Contact();
        c2.FirstName = 'FirstName12';
        c2.LastName = 'LastName12';
        c2.Email = 'Create_Rotation_Test3@samples.com';
        c2.Program_Primary__c=pr.id;
        c2.Rotations_Scenario__c=Null ;     
        c2.Rotation_1_Type__c=null;
        c2.Rotation_1_Campus__c=null;
        c2.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c2.Rotation_1_Latest_Elective_End_Date__c=null;
        c2.Rotation_2_Type__c=null;
        c2.Rotation_2_Campus__c=null;
        c2.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c2.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c2);
        
        Contact c3 = new Contact();
        c3.FirstName = 'FirstName12';
        c3.LastName = 'LastName12';
        c3.Email = 'Create_Rotation_Test4@samples.com';
        c3.Program_Primary__c=pr.id;
        c3.Rotations_Scenario__c=Null ;     
        c3.Rotation_1_Type__c=null;
        c3.Rotation_1_Campus__c=null;
        c3.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c3.Rotation_1_Latest_Elective_End_Date__c=null;
        c3.Rotation_2_Type__c=null;
        c3.Rotation_2_Campus__c=null;
        c3.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c3.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c3);
        
        Contact c4= new Contact();
        c4.FirstName = 'FirstName12';
        c4.LastName = 'LastName12';
        c4.Email = 'Create_Rotation_Test5@samples.com';
        c4.Program_Primary__c=pr.id;
        c4.Rotations_Scenario__c=Null ;     
        c4.Rotation_1_Type__c=null;
        c4.Rotation_1_Campus__c=null;
        c4.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c4.Rotation_1_Latest_Elective_End_Date__c=null;
        c4.Rotation_2_Type__c=null;
        c4.Rotation_2_Campus__c=null;
        c4.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c4.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c4);
        
        Contact c5 = new Contact();
        c5.FirstName = 'FirstName12';
        c5.LastName = 'LastName12';
        c5.Email = 'Create_Rotation_Test6@samples.com';
        c5.Program_Primary__c=pr.id;
        c5.Rotations_Scenario__c=Null ;     
        c5.Rotation_1_Type__c=null;
        c5.Rotation_1_Campus__c=null;
        c5.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c5.Rotation_1_Latest_Elective_End_Date__c=null;
        c5.Rotation_2_Type__c=null;
        c5.Rotation_2_Campus__c=null;
        c5.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c5.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c5);
        
        Contact c6 = new Contact();
        c6.FirstName = 'FirstName12';
        c6.LastName = 'LastName12';
        c6.Email = 'Create_Rotation_Test7@samples.com';
        c6.Program_Primary__c=pr.id;
        c6.Rotations_Scenario__c=Null ;     
        c6.Rotation_1_Type__c=null;
        c6.Rotation_1_Campus__c=null;
        c6.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c6.Rotation_1_Latest_Elective_End_Date__c=null;
        c6.Rotation_2_Type__c=null;
        c6.Rotation_2_Campus__c=null;
        c6.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c6.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c6);
        
        Contact c7 = new Contact();
        c7.FirstName = 'FirstName12';
        c7.LastName = 'LastName12';
        c7.Email = 'Create_Rotation_Test8@samples.com';
        c7.Program_Primary__c=pr.id;
        c7.Rotations_Scenario__c=Null ;     
        c7.Rotation_1_Type__c=null;
        c7.Rotation_1_Campus__c=null;
        c7.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c7.Rotation_1_Latest_Elective_End_Date__c=null;
        c7.Rotation_2_Type__c=null;
        c7.Rotation_2_Campus__c=null;
        c7.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c7.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c7);
        
        Contact c8 = new Contact();
        c8.FirstName = 'FirstName12';
        c8.LastName = 'LastName12';
        c8.Email = 'Create_Rotation_Test9@samples.com';
        c8.Program_Primary__c=pr.id;
        c8.Rotations_Scenario__c=Null ;     
        c8.Rotation_1_Type__c=null;
        c8.Rotation_1_Campus__c=null;
        c8.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c8.Rotation_1_Latest_Elective_End_Date__c=null;
        c8.Rotation_2_Type__c=null;
        c8.Rotation_2_Campus__c=null;
        c8.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c8.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c8);
        
        Contact c9 = new Contact();
        c9.FirstName = 'FirstName12';
        c9.LastName = 'LastName12';
        c9.Email = 'Create_Rotation_Test10@samples.com';
        c9.Program_Primary__c=pr.id;
        c9.Rotations_Scenario__c=Null ;     
        c9.Rotation_1_Type__c=null;
        c9.Rotation_1_Campus__c=null;
        c9.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c9.Rotation_1_Latest_Elective_End_Date__c=null;
        c9.Rotation_2_Type__c=null;
        c9.Rotation_2_Campus__c=null;
        c9.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c9.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c9);
        
        Contact c10 = new Contact();
        c10.FirstName = 'FirstName12';
        c10.LastName = 'LastName12';
        c10.Email = 'Create_Rotation_Test11@samples.com';
        c10.Program_Primary__c=pr.id;
        c10.Rotations_Scenario__c=Null ;     
        c10.Rotation_1_Type__c=null;
        c10.Rotation_1_Campus__c=null;
        c10.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c10.Rotation_1_Latest_Elective_End_Date__c=null;
        c10.Rotation_2_Type__c=null;
        c10.Rotation_2_Campus__c=null;
        c10.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c10.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c10);
        
        Contact c11 = new Contact();
        c11.FirstName = 'FirstName12';
        c11.LastName = 'LastName12';
        c11.Email = 'Create_Rotation_Test12@samples.com';
        c11.Program_Primary__c=pr.id;
        c11.Rotations_Scenario__c=Null ;     
        c11.Rotation_1_Type__c=null;
        c11.Rotation_1_Campus__c=null;
        c11.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c11.Rotation_1_Latest_Elective_End_Date__c=null;
        c11.Rotation_2_Type__c=null;
        c11.Rotation_2_Campus__c=null;
        c11.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c11.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c11);
        
        Contact c12 = new Contact();
        c12.FirstName = 'FirstName12';
        c12.LastName = 'LastName12';
        c12.Email = 'Create_Rotation_Test13@samples.com';
        c12.Program_Primary__c=pr.id;
        c12.Rotations_Scenario__c=Null ;     
        c12.Rotation_1_Type__c=null;
        c12.Rotation_1_Campus__c=null;
        c12.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c12.Rotation_1_Latest_Elective_End_Date__c=null;
        c12.Rotation_2_Type__c=null;
        c12.Rotation_2_Campus__c=null;
        c12.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c12.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c12);
        
        Contact c13 = new Contact();
        c13.FirstName = 'FirstName12';
        c13.LastName = 'LastName12';
        c13.Email = 'Create_Rotation_Test14@samples.com';
        c13.Program_Primary__c=pr.id;
        c13.Rotations_Scenario__c=Null ;     
        c13.Rotation_1_Type__c=null;
        c13.Rotation_1_Campus__c=null;
        c13.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c13.Rotation_1_Latest_Elective_End_Date__c=null;
        c13.Rotation_2_Type__c=null;
        c13.Rotation_2_Campus__c=null;
        c13.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c13.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c13);
        
        Contact c14 = new Contact();
        c14.FirstName = 'FirstName12';
        c14.LastName = 'LastName12';
        c14.Email = 'Create_Rotation_Test15@samples.com';
        c14.Program_Primary__c=pr.id;
        c14.Rotations_Scenario__c=Null ;     
        c14.Rotation_1_Type__c=null;
        c14.Rotation_1_Campus__c=null;
        c14.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c14.Rotation_1_Latest_Elective_End_Date__c=null;
        c14.Rotation_2_Type__c=null;
        c14.Rotation_2_Campus__c=null;
        c14.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c14.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c14);
        
        Contact c15 = new Contact();
        c15.FirstName = 'FirstName12';
        c15.LastName = 'LastName12';
        c15.Email = 'Create_Rotation_Test16@samples.com';
        c15.Program_Primary__c=pr1.id;
        c15.Rotations_Scenario__c=Null ;     
        c15.Rotation_1_Type__c=null;
        c15.Rotation_1_Campus__c=null;
        c15.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c15.Rotation_1_Latest_Elective_End_Date__c=null;
        c15.Rotation_2_Type__c=null;
        c15.Rotation_2_Campus__c=null;
        c15.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c15.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c15); // cond -11 
        
        Contact c16 = new Contact();
        c16.FirstName = 'FirstName12';
        c16.LastName = 'LastName12';
        c16.Email = 'Create_Rotation_Test17@samples.com';
        c16.Program_Primary__c=pr1.id;
        c16.Rotations_Scenario__c=Null ;     
        c16.Rotation_1_Type__c=null;
        c16.Rotation_1_Campus__c=null;
        c16.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c16.Rotation_1_Latest_Elective_End_Date__c=null;
        c16.Rotation_2_Type__c=null;
        c16.Rotation_2_Campus__c=null;
        c16.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c16.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c16); // cond - 12
        
        Contact c17 = new Contact();
        c17.FirstName = 'FirstName12';
        c17.LastName = 'LastName12';
        c17.Email = 'Create_Rotation_Test18@samples.com';
        c17.Program_Primary__c=pr.id;
        c17.Rotations_Scenario__c=Null ;     
        c17.Rotation_1_Type__c=null;
        c17.Rotation_1_Campus__c=null;
        c17.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c17.Rotation_1_Latest_Elective_End_Date__c=null;
        c17.Rotation_2_Type__c=null;
        c17.Rotation_2_Campus__c=null;
        c17.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c17.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c17); // cond - 5
        
        
        Contact c18 = new Contact();
        c18.FirstName = 'FirstName12';
        c18.LastName = 'LastName12';
        c18.Email = 'Create_Rotation_Test19@samples.com';
        c18.Program_Primary__c=pr.id;
        c18.Rotations_Scenario__c=Null ;     
        c18.Rotation_1_Type__c=null;
        c18.Rotation_1_Campus__c=null;
        c18.Rotation_1_Earliest_Elective_Start_Date__c=null;
        c18.Rotation_1_Latest_Elective_End_Date__c=null;
        c18.Rotation_2_Type__c=null;
        c18.Rotation_2_Campus__c=null;
        c18.Rotation_2_Earliest_Elective_Start_Date__c=null;
        c18.Rotation_2_Latest_Elective_End_Date__c=null;
        cs.add(c18); 
        
        Insert cs;   
        
          
        
        
        
        c.Rotation_1_Type__c=ModD;
        c.Rotation_1_Campus__c='London';
        c.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c.Rotation_2_Type__c=ModE;
        c.Rotation_2_Campus__c='London';
        c.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c.Rotation_2_Latest_Elective_End_Date__c=system.today();        
       // update c;
        
        c18.Rotation_1_Type__c=ModD;
        c18.Rotation_1_Campus__c='London';
        c18.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c18.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c18.Rotation_2_Type__c=Null;
        c18.Rotation_2_Campus__c=Null;
        c18.Rotation_2_Earliest_Elective_Start_Date__c=Null;
        c18.Rotation_2_Latest_Elective_End_Date__c=Null;        
        update c18; 
        
        /*c2.Rotation_1_Type__c=ModD;
        c2.Rotation_1_Campus__c='London';
        c2.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c2.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c2.Rotation_2_Type__c=Null;
        c2.Rotation_2_Campus__c=Null;
        c2.Rotation_2_Earliest_Elective_Start_Date__c=Null;
        c2.Rotation_2_Latest_Elective_End_Date__c=Null; 
        updtecs.add(c2);
        
        c3.Rotation_1_Type__c=NULL;
        c3.Rotation_1_Campus__c=NULL;
        c3.Rotation_1_Earliest_Elective_Start_Date__c=NULL;
        c3.Rotation_1_Latest_Elective_End_Date__c=NULL;
        c3.Rotation_2_Type__c=ModE;
        c3.Rotation_2_Campus__c='London';
        c3.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c3.Rotation_2_Latest_Elective_End_Date__c=system.today();
        updtecs.add(c3);
        
        c1.Rotation_1_Type__c=ModD;
        c1.Rotation_1_Campus__c='Dubai';
        c1.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c1.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c1.Rotation_2_Type__c=Null;
        c1.Rotation_2_Campus__c=Null;
        c1.Rotation_2_Earliest_Elective_Start_Date__c=Null;
        c1.Rotation_2_Latest_Elective_End_Date__c=Null;
        updtecs.add(c1);
        
        c4.Rotation_1_Type__c=NULL;
        c4.Rotation_1_Campus__c=NULL;
        c4.Rotation_1_Earliest_Elective_Start_Date__c=NULL;
        c4.Rotation_1_Latest_Elective_End_Date__c=NULL;
        c4.Rotation_2_Type__c=ModE;
        c4.Rotation_2_Campus__c='Dubai';
        c4.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c4.Rotation_2_Latest_Elective_End_Date__c=system.today();
        updtecs.add(c4);
        
        c5.Rotation_1_Type__c=ModD;
        c5.Rotation_1_Campus__c='London';
        c5.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c5.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c5.Rotation_2_Type__c=ModE;
        c5.Rotation_2_Campus__c='Dubai';  
        c5.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c5.Rotation_2_Latest_Elective_End_Date__c=system.today();    
        updtecs.add(c5);
        
        c6.Rotation_1_Type__c=ModD;
        c6.Rotation_1_Campus__c='Dubai';
        c6.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c6.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c6.Rotation_2_Type__c=ModE;
        c6.Rotation_2_Campus__c='London';   
        c6.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c6.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c6);
        
        c7.Rotation_1_Type__c=ModD;
        c7.Rotation_1_Campus__c='Dubai';
        c7.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c7.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c7.Rotation_2_Type__c=ModE;
        c7.Rotation_2_Campus__c='shangai';   
        c7.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c7.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c7);
        
        c8.Rotation_1_Type__c=ModD;
        c8.Rotation_1_Campus__c='Dubai';
        c8.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c8.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c8.Rotation_2_Type__c=ModD;
        c8.Rotation_2_Campus__c='Dubai';   
        c8.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c8.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c8); // cond - 6
        
        c9.Rotation_1_Type__c=ModD;
        c9.Rotation_1_Campus__c='London';
        c9.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c9.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c9.Rotation_2_Type__c=ModD;
        c9.Rotation_2_Campus__c='shangai';   
        c9.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c9.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c9); //cond - 7
        
        c10.Rotation_1_Type__c=ModD;
        c10.Rotation_1_Campus__c='Dubai';
        c10.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c10.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c10.Rotation_2_Type__c=ModD;
        c10.Rotation_2_Campus__c='London';   
        c10.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c10.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c10); //cond 7.1
        
        c11.Rotation_1_Type__c=ModD;
        c11.Rotation_1_Campus__c='Dubai';
        c11.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c11.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c11.Rotation_2_Type__c=ModD;
        c11.Rotation_2_Campus__c='shangai';   
        c11.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c11.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c11); // cond-8
        
        c12.Rotation_1_Type__c=ModE;
        c12.Rotation_1_Campus__c='London';
        c12.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c12.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c12.Rotation_2_Type__c=ModE;
        c12.Rotation_2_Campus__c='shangai';   
        c12.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c12.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c12); //cond - 9
        
        c13.Rotation_1_Type__c=ModE;
        c13.Rotation_1_Campus__c='Dubai';
        c13.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c13.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c13.Rotation_2_Type__c=ModE;
        c13.Rotation_2_Campus__c='London';   
        c13.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c13.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c13); //cond 9.1
        
        c14.Rotation_1_Type__c=ModE;
        c14.Rotation_1_Campus__c='Dubai';
        c14.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c14.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c14.Rotation_2_Type__c=ModE;
        c14.Rotation_2_Campus__c='shangai';   
        c14.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c14.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c14); // cond-10
        
        c15.Rotation_1_Type__c=ModD;
        c15.Rotation_1_Campus__c='Dubai';
        c15.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c15.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c15.Rotation_2_Type__c=ModD;
        c15.Rotation_2_Campus__c='Dubai';   
        c15.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c15.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c15); //cond-11
        
        c16.Rotation_1_Type__c=ModD;
        c16.Rotation_1_Campus__c='London';
        c16.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c16.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c16.Rotation_2_Type__c=ModD;
        c16.Rotation_2_Campus__c='shangai';   
        c16.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c16.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c16); // cond-12
        
        c17.Rotation_1_Type__c=ModD;
        c17.Rotation_1_Campus__c='shangai';
        c17.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c17.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c17.Rotation_2_Type__c=ModE;
        c17.Rotation_2_Campus__c='shangai';   
        c17.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c17.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c17); // cond-5
        
        
        c18.Rotation_1_Type__c=ModD;
        c18.Rotation_1_Campus__c='London';
        c18.Rotation_1_Earliest_Elective_Start_Date__c=system.today();
        c18.Rotation_1_Latest_Elective_End_Date__c=system.today();
        c18.Rotation_2_Type__c=Null;
        c18.Rotation_2_Campus__c=Null;   
        c18.Rotation_2_Earliest_Elective_Start_Date__c=system.today();
        c18.Rotation_2_Latest_Elective_End_Date__c=system.today();   
        updtecs.add(c18); // cond-5
        
                
        update updtecs;
        
        List<Contact> updtecs1=new list<Contact>();
        
        c.Rotation_2_Campus__c='dubai';   
        updtecs1.add(c);
        
        c7.Rotation_1_Campus__c='London';  
        c7.Rotation_2_Campus__c='London';  
        updtecs1.add(c7);
        
        c2.Rotation_1_Campus__c='Dubai';
        updtecs1.add(c2);
        
        c1.Rotation_1_Type__c=ModD;
        c1.Rotation_1_Campus__c='Dubai';
        c1.Rotation_2_Type__c=ModE;
        c1.Rotation_2_Campus__c='Sanfran';
        updtecs1.add(c1);
        
        c5.Rotation_1_Campus__c='Dubai';
        c5.Rotation_2_Campus__c='London';      
        updtecs1.add(c5);
       
        c6.Rotation_2_Campus__c='Dubai';    
        updtecs1.add(c6);
        
        c8.Rotation_1_Campus__c='sanf';
        c8.Rotation_2_Campus__c='sanf';    
        updtecs1.add(c8); // cond - 6
        
        c9.Rotation_2_Campus__c='sanf';    
        updtecs1.add(c9); //cond - 7
        
        c10.Rotation_1_Campus__c='Sanf';
        updtecs1.add(c10); // cond - 7.1
        
        c11.Rotation_2_Campus__c='Sanf';  
        updtecs1.add(c11); // cond-8
        
        c12.Rotation_2_Campus__c='sanf';   
        updtecs1.add(c12); //cond - 9
        
        c13.Rotation_1_Campus__c='sanf'; 
        updtecs1.add(c13); //cond 9.1
        
        c14.Rotation_2_Campus__c='sanf';  
        updtecs1.add(c14); // cond-10
        
        c15.Rotation_1_Campus__c='sanf';
        c15.Rotation_2_Campus__c='sanf';     
        updtecs1.add(c15); //cond-11
        
        c16.Rotation_2_Campus__c='sanf';  
        updtecs.add(c16); // cond-12
        
        c17.Rotation_1_Campus__c='Dubai';
        c17.Rotation_2_Campus__c='Dubai';   
        updtecs1.add(c17); // cond-5
        
        update updtecs1;*/
        
         
        
    }
}