public with sharing class hrp_ssologin_errs 
{    public string pid{get;set;}
    public hrp_ssologin_errs()
    {
     
    }   
    public PageReference init()
    {
        set<string> profileids=new set<string>();
        try{
            profileids.add(RecordTypeHelper.getprofileid('Hult Career Point Student Profile'));
            profileids.add(RecordTypeHelper.getprofileid('Hult Career Point Student Profile - Off Service'));
            profileids.add(RecordTypeHelper.getprofileid('System Administrator'));
            profileids.add(REcordTypeHelper.getProfileid('sso for hrp'));
        }
        catch(exception ecx)
        {}
        profileids.add('00eU0000000IrdI');
        profileids.add('00eU0000000J49l');
        try{             
        system.debug('User info '+UserInfo.getUserId());
        system.debug('profile info '+UserInfo.getProfileId());
            user usr = [SELECT contact.Total_Login__c,contact.RecordTypeId, contact.Name,contact.Last_Log_In__c FROM User 
                        WHERE id = :UserInfo.getUserId() and (profileid IN:profileids) and 
                        (Contact.RecordTypeId=:RecordTypeHelper.getRecordTypeId('Contact', 'Candidate') or 
                        Contact.RecordTypeId=:RecordTypeHelper.getRecordTypeId('Contact', 'Student') )];
           PageReference pageRef = new PageReference('/apex/rotationvisaportal');
            pageRef.setRedirect(true);
            return pageRef;
        }        
        catch(exception ecx)
        {     /*      
           if(Userinfo.getUserType()!='GUEST')
           { 
               pid='profile = '+Userinfo.getProfileId()+' ;name ='+Userinfo.getName()+'; username='+Userinfo.getUserName()+' ; type='+Userinfo.getUserType();
               pid='Error :: Current User'+Userinfo.getUserName()+' doesnot have either HCP/Sso for HRP profile or Student Record Type. ';
           }
           else
           {
                PageReference pageRef = new PageReference('https://app.onelogin.com/trust/saml2/http-post/sso/394893');//https://app.onelogin.com/client/apps');//
                pageRef.setRedirect(true);
                return pageRef;
           }*/           
           pid='Current User '+Userinfo.getUserName()+' doesnot have access to HRP Portal, Please contact your Administrator. ';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, ''+pid);
            ApexPages.addMessage(myMsg); 
            pid+='profile = '+Userinfo.getProfileId()+' ;name ='+Userinfo.getName()+'; username='+Userinfo.getUserName()+' ; type='+Userinfo.getUserType()+'---'+ecx;
           return null;
        }
    }
}