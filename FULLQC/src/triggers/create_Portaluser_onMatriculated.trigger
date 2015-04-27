/*
    Developer   : Harsha Simha
    Date        : 9/10/2014
    Purpose     : This trigger collects list of contacts which are matriculated and calls Future Method "create_portaluser" 
                    which creates user records for them.    
    Test Class  : TEST_Createportal_user.cls(75%)
    Modified By : Anil.B On 9/10/2014 changed BIBA to BBA in if condition by using Custom_lables class.
*/
trigger create_Portaluser_onMatriculated on Opportunity (after update) 
{
    List<string> contactids=new list<String>();
    List<string> finallist=new list<String>();
    string wrongmail_list='Contact Id, Name, Email , Program , Start Term, Error \n';
    for(opportunity o:Trigger.New)
    {
        if(o.Matriculated__c && !Trigger.oldMap.get(o.Id).Matriculated__c && o.Program_Parsed__c!=null && o.Program_Parsed__c!=custom_lables.Bachelor_Pgm_abvtn)
        {
            contactids.add(o.contact__c);
        }
    }
    if(!Contactids.IsEmpty())
    {
        create_portaluser_onmatriculated.create_portaluser(Contactids);
        /*
        list<contact> con=[select id,name,Email,start_Term__c,Program_Parsed__c from Contact where id IN: Contactids];
        for(contact c:con)
        {
            if(c.Email!=null && c.Email.contains('@student.hult.edu'))
            {
                finallist.add(c.Id);
            }
            else
            {
                wrongmail_list+=c.Id+','+c.Name+','+c.Email+','+c.Program_Parsed__c+','+c.start_Term__c+', Email id is not Hult Student Mailid \n';
            }
        }*/
        
    }
}