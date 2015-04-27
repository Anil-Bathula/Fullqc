@isTest
/**********
Test Class for:-unlockStudentInformation(87%)
***********/
public class unlockStudentInformation_Test{



public static testmethod void methodname() {

       Program__c pr=new program__c();
       pr.Name='MIB-US-San Francisco';
       pr.Campus__c='London';
       pr.Program_pre_parsed__c='MIB';
       insert pr;
       
       Program__c pr1=new program__c();
       pr1.Name='MBA-UK-London';
       pr.Campus__c='London';
       pr.Program_pre_parsed__c='MBA';
       insert pr1;


            Contact c=new Contact();
            c.LastName='Hult';  
            c.Applicant_Email__c='test@mail444.com'; 
            c.Program_Primary__c=pr.id;         
            insert c;
            
            
            Opportunity os=new opportunity();
            os.Name='Hult';
            os.StageName='Confirmed';
            os.Contact__c=c.id;
            os.CloseDate=system.today();
            os.Program__c=pr.id;          
            os.Unlock_Student_Financial_Information__c=false;
            insert os;
            
                     
        
        Opportunity_Finance__c fss=new Opportunity_Finance__c();
           fss.opportunity__c=os.id;
           fss.Unlock_Student_Financial_Information__c=false;
           insert fss; 
           fss.Unlock_Student_Financial_Information__c=True;  
           fss.Housing_Accommodation__c='Premium Single UK';
           fss.Accommodation_weeks__c='10';          
           update fss; 
           
           os.Unlock_Student_Financial_Information__c=os.Unlock_Student_Financial_Information__c;           
           update os;  
           
         
           
       }
       }