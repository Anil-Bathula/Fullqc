/*
Author         : Premanath Reddy
Created Date   : 9-Jul-2013
Purpose        : when user is deactivated substitute user field should not be empty.
                 substitute user "email field" should match to only one user email id.
                 else throw error::
                 0 matches : no user with this email id found.
                 more than 1 match : more than 1 user with this email id found.
Modified by Prem:9/12/2013 :: SFSUP-685 :: Substitute user - Allow any profile in the below profile List(proflist) .
Modified Prem : SFSUP-767
*/
trigger User_Deactivation on User (before update,after update) {
    string sfhosturl='.salesforce.com';//used to check whether current instance is sandbox or production
    Map<String,ID> emailmap=new Map<String,ID>();
    //Map<String,ID> username_map=new Map<String,ID>();
    Map<String,String> emailmap1=new Map<String,String>();
    set<String> proflist=new set<String>{'System Administrator','Sales-Recruiter and Converter','Sales-Product Head','Sales-Global Product Head','Sales-Regional Head'};
    
    for(User u:Trigger.New){
        if(Trigger.NewMap.get(u.id).IsActive!=Trigger.OldMap.get(u.id).IsActive && Trigger.NewMap.get(u.id).IsActive==false){
            String usrprof=RecordTypeHelper.getprofilename(u.ProfileID);            
            if(proflist.contains(usrprof)){
                if(u.Substitiute_User__c==null){
                    u.addError('when user is deactivated substitute user field should not be empty');
                }
                else{
                    emailmap.put(u.Substitiute_User__c,u.id);//subuser emailid -> old_user_id
                   // username_map.put(u.userName,u.id);//Old_username -> Old_user_id
                    emailmap1.put(u.Substitiute_User__c,u.Username);//subuser emailid -> Old_user_name
                }
            } 
        }
    }
    if(!emailmap.isEmpty()){
        List<User> usr=[select id,Name,ProfileId,Profile_Name__c,username,Email from User where (Email IN:emailmap.keyset() and id NOT IN:emailmap.values()) and isActive=true];
        integer a=0;  
        if (Trigger.isBefore){      
            if(!usr.isEmpty())
            {
                map<string,integer> emailcount=new map<String,integer>();
                map<string,user> sub_usres=new map<String,user>();
                for(User u:usr)
                {
                    integer cnt=emailcount.containsKey(u.email)?emailcount.get(u.email):0;
                    emailcount.put(u.email,cnt+1);
                    sub_usres.put(u.email,u);
                }            
                for(String s:emailmap.keyset())
                {
                    if(emailcount.containsKey(s))
                    {
                        if(emailcount.get(s)>1)
                        {
                            Trigger.Newmap.get(emailmap.get(s)).addError('More than 1 user exist with this email id');
                        }
                        else
                        {
                          // modified : Prem:: Allow substitute user to be selected as any other profile in the above Profile List(proflist).
                            if(!proflist.contains(RecordTypeHelper.getprofilename(sub_usres.get(s).ProfileId)))
                            {
                                Trigger.Newmap.get(emailmap.get(s)).addError('Substiture User Profile should be in this List of Profiles:'+proflist);
                            }
                        }
                    }
                    else
                    {
                        Trigger.Newmap.get(emailmap.get(s)).addError('No user exists with this email id');
                    }
                }
            }
            else
            {
                for(string s:emailmap.keyset())
                {
                    Trigger.Newmap.get(emailmap.get(s)).addError('No user exists with this email id');
                }
            }
        }
        if(Trigger.isAfter){
            if(!usr.isEmpty())
            {
                map<String,String> user_subuser=new map<String,String>();
                map<String,String> route_subuser=new map<String,String>();
                for(User u:usr)
                {
                    if(emailmap.containsKey(u.Email))
                    {   
                        user_subuser.put(emailmap.get(u.Email),u.Id);//set old ownerids, substitute user id value.
                        route_subuser.put(emailmap.get(u.Email),u.Id);//set old ownerids, substitute user id value.
                    }
                    if(emailmap1.containsKey(u.Email))
                        route_subuser.put(emailmap1.get(u.Email),u.UserName);//set old owner usernames, substitute username value.
                }  
                if(!user_subuser.IsEmpty() || !route_subuser.IsEmpty())
                {
                    string mailbody='start::user_subuser'+user_subuser+',end::user_subuser  \n   start::route_subuser'+route_subuser+',end::route_subuser';
                    messaging.Singleemailmessage mail=new messaging.Singleemailmessage();
                    String[] toAddresses = new String[] {'harsha.simha@ef.com','update_owner_on_user_deactivation@1-2oznzw13ax433nino0p1a9apxfkzpu1evglq89kko28otq6nfh.k-w2s4nmab.cs9.apex.sandbox.salesforce.com'};
                    //above sandbox url
                    String sfurl  =  System.URL.getSalesforceBaseUrl().getHost();
                    if(sfurl.contains(sfhosturl) && !sfurl.startsWith('cs'))
                    {
                        toAddresses.clear();
                        toAddresses.add('harsha.simha@ef.com');
                        toAddresses.add('update_owner_on_user_deactivation@2v8s3nuzzoc9hyvovrr2nf3gv18r7znd39hbws1ohavkfbzca.u-hgvhma4.na12.apex.salesforce.com');//production url
                    }
                    mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('Hult Users Deactivated');
                    mail.setSubject('User Deactivation Mail');
                    mail.setPlainTextBody(mailbody);
                    system.debug('----------------------'+mailbody);
                    try{ 
                        messaging.sendEmail(new messaging.Singleemailmessage[]{mail}); 
                    }
                    catch(DMLException e){ 
                        system.debug('ERROR SENDING EMAIL:'+e); 
                    } 
                    
                    /*Owner_updater o_upd=new Owner_updater(user_subuser,route_subuser);        
                    database.executebatch(o_upd,200);
                    
                    lead_owner_updater lo_upd=new lead_owner_updater(user_subuser);        
                    database.executebatch(lo_upd,200);*/
                }
            }
           /*
            List<string> recs=new List<String>();
for(integer i=0;i<50;i++)
{
    recs.add('---'+i);
}
       Owner_updater der=new Owner_updater(recs);        
       database.executebatch(der,10);    
       //System.abortJob(ctx.getTriggerId());
           
            if(!usr.isEmpty())
            {
                map<string,user> sub_usres1=new map<String,user>();
                for(User u:usr)
                {
                    sub_usres1.put(u.email,u);
                }  
                //Find all leads whose owner is deactivated user and change it with the substitute user record.               
                Map<String,String> leadupdt=new Map<String,String>();
                List<Lead> leadlst=[select id,Name,OwnerID from Lead where OwnerID in:emailmap.values() and isconverted=false];
                for(Lead l:leadlst)
                {
                    if(!TRigger.newMap.containsKey(l.OwnerID))
                        continue;
                    If(sub_usres1.containsKey(TRigger.newMap.get(l.OwnerID).Substitiute_User__c))
                    {    
                        leadupdt.put(l.OwnerID,sub_usres1.get(TRigger.newMap.get(l.OwnerID).Substitiute_User__c).id);
                        //l.OwnerID=sub_usres1.get(TRigger.newMap.get(l.OwnerID).Substitiute_User__c).id;
                         //leadupdt.add(l);
                    }
                }
                //Find all Contacts whose owner is deactivated user and change it with the substitute user record
                Map<String,String> conupdt=new Map<String,String>();
                List<Contact> conlst=[select id,Name,OwnerID from Contact where OwnerID in:emailmap.values()];
                for(Contact c:conlst)
                {
                    if(!TRigger.newMap.containsKey(c.OwnerID))
                        continue;
                    If(sub_usres1.containsKey(TRigger.newMap.get(c.OwnerID).Substitiute_User__c))
                    {   
                        conupdt.put(c.OwnerID,sub_usres1.get(TRigger.newMap.get(c.OwnerID).Substitiute_User__c).id);
                    }                   
                }
                
                //Find all Routing Rules whose Routed to value contains deactivated user and change it with the substitute user record.
                Map<String,String> routupdt=new Map<String,String>();
                List<Routing_Table__c> routlst=[select id,Name,OwnerID,Routed_By__c,Routed_To__c from Routing_Table__c where (Routed_To__c in:emailmap1.values() and Routed_By__c='User Name') or ((Routed_To__c in:emailmap.values() and Routed_By__c='User ID'))];
                for(Routing_Table__c r:routlst)
                {
                    if(r.Routed_By__c=='User Name')
                    {
                        if(!username_map.containsKey(r.Routed_To__c))
                            continue;
                        if(sub_usres1.containsKey(TRigger.newMap.get(username_map.get(r.Routed_To__c)).Substitiute_User__c))
                        {   
                            routupdt.put(r.Routed_To__c,sub_usres1.get(TRigger.newMap.get(username_map.get(r.Routed_To__c)).Substitiute_User__c).username);
                        }
                    }
                    else if(r.Routed_By__c=='User ID') 
                    {
                        if(!TRigger.newMap.containsKey(r.Routed_To__c))
                            continue;
                        If(sub_usres1.containsKey(TRigger.newMap.get(r.Routed_To__c).Substitiute_User__c))
                        {    
                            routupdt.put(r.Routed_To__c,sub_usres1.get(TRigger.newMap.get(username_map.get(r.Routed_To__c)).Substitiute_User__c).username);
                        }
                    }                    
                }
                if(!conupdt.isEmpty() || !leadupdt.isEmpty() ||!routupdt.isEmpty() )
                {
                    User_Deactivation_future.update_owner(leadupdt,conupdt,routupdt);
                }
            }*/
        }
    }
    
   
    
}