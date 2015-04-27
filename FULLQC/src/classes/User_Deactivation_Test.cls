/*
Author    :- Premanath Reddy
Date      :- 17/7/2012
Usage     :- Test class for User_Deactivation,add_userstogroup Triggers
Modified Prem : SFSUP-767
Modified Prem(9/9/2014) : SFSUP-765
*/
@isTest
private class User_Deactivation_Test {
    static testmethod void methodname(){
        
        List<User> usr=new List<User>();
        
        String p = RecordTypeHelper.getprofileid('Sales-Recruiter and Converter');
        
        User u = new User(alias = 'standt', email='standarduser09876@testorg.com', 
        lastname='Testing', EmailEncodingKey='UTF-8',isActive=True,
        languagelocalekey='en_US', Hult_Department__c='OPS',Regional_Division__c='DUB',
        localesidkey='en_US', profileid = p,TimeZoneSidKey='America/Los_Angeles',
        username='standarduser09876@testorg.com');
        usr.add(u);
        
        //User with the same Profile(2. HULT Rec...) of user u and Same Email(usertest86@testtest.com) of User u3
        User u1 = new User(alias = 'tenttt', email='usertest86@testtest.com', 
        lastname='orgtest', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p,TimeZoneSidKey='America/Los_Angeles',
        username='usertest86@testtest.com');
        usr.add(u1);
        
        //User with same Profile(2. HULT Rec...) and same Email(usertest86@testtest.com) of User u1
        User u3 = new User(alias = 'same', email='usertest86@testtest.com', 
        lastname='orgtest', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p,TimeZoneSidKey='America/Los_Angeles',
        username='usertest87@testtest87.com');
        usr.add(u3);
        
        //User with same Profile(2. HULT Rec...) of user u and Different Email of User u
        User u4 = new User(alias = 'same', email='usertest91@testtest.com', 
        lastname='orgtest', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p,TimeZoneSidKey='America/Los_Angeles',
        username='usertest91@testtest91.com');
        usr.add(u4);
        
        // Different User with Different Profile and Different Email
        String p1 = RecordTypeHelper.getprofileid('Operations-AAM');
        User u2 = new User(alias = 'diff', email='usertest88@testtest88.com', 
        lastname='orgtest', EmailEncodingKey='UTF-8',
        languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p1,TimeZoneSidKey='America/Los_Angeles',
        username='usertest88@testtest88.com');
        usr.add(u2);
        
        insert usr;
        
        
        // Scenario 1:- If substitute User field is Empty
        try{
            u.isActive=false;
            update u;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('when user is deactivated substitute user field should not be empty') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
        }
        
        // Scenario 2:- if Substititute User field Email exist in more than 1 user
        try{
            u.isActive=false;
            u.Substitiute_User__c='usertest86@testtest.com';
            update u;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('More than 1 user exist with this email id') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
        }
        
        // Scenario 3:- if Substititute User field with different Profile from Current user profile
        try{
            u.isActive=false;
            u.Substitiute_User__c='usertest88@testtest88.com';
            update u;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Substiture User Profile should be in this List of Profiles:') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
        }
        
        // Scenario 4:- if No User is Exist with Substititute User field Email
        try{
            u.isActive=false;
            u.Substitiute_User__c='test@123gg.com';
            update u;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('No user exists with this email id') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
        }
        
        // Scenario 5:- If Everything is fine(if Substititute User having with same profile from Current user profile and Different Email)
        try{
            u.isActive=false;
            u.Substitiute_User__c='usertest91@testtest.com';
            u.Hult_Department__c='OPS';
            u.Regional_Division__c='BOS';
            update u;            
        }
        catch(Exception e){
            system.Debug(e);       
        }
       
        Messaging.InboundEmail inbemail = new Messaging.InboundEmail();
        Messaging.Inboundenvelope inbenv=new Messaging.Inboundenvelope();
        inbemail.subject = 'User Deactivation Mail';
        inbemail.plainTextBody = 'start::user_subuser{'+u.Id+'='+u4.Id+'},end::user_subuser  \n   start::route_subuser{'+u.Id+'='+u4.Id+','+u.username+'='+u4.username+'},end::route_subuser, ';
        inbenv.fromAddress = 'user@hult.edu';
          
        User_Deacctivation_emailhandler mailhandler=new User_Deacctivation_emailhandler();
        test.startTest();
        mailhandler.handleInboundEmail(inbemail, inbenv);
        test.stopTest();
    }
}