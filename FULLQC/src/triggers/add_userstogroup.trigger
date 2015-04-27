/*
Author         : Premanath Reddy
Created Date   : 25/8/2014
Purpose        : (SFSUP-765) Insert and update of user object if Hult Department/Regional Division/ Product is changed then 
                Check for the Groups whose name = Group Code, and add this user as a group member to that group.
                And it will remove user from the old group on changing above three values. 
Test class     :User_Deactivation_Test(97% code coverage)
*/
trigger add_userstogroup on User (after insert,after update){
    Map<Id,String> varmap=new Map<Id,String>();
    Map<Id,String> oldmap=new Map<Id,String>();
    for(User u:Trigger.New){
        User oldusr=Trigger.isInsert?new User():Trigger.oldmap.get(u.id);
        if(u.Hult_Department__c!=oldusr.Hult_Department__c || u.Regional_Division__c!=oldusr.Regional_Division__c
           || u.Product__c!=oldusr.Product__c)
        {
            varmap.put(u.id,u.Group_Code__c);
            if(oldusr.Group_Code__c!=null)
                oldmap.put(u.id,oldusr.Group_Code__c);
        }
    }
    if(!varmap.isEmpty()){
        //Insert Group members
        List<GroupMember> insrtmem=new List<GroupMember>();
        List<GroupMember> deltmem=new List<GroupMember>();
        Map<String,Id> grupmap=new Map<String,Id>();
        //System.Debug('****************'+varmap.values());
        List<Group> grup=[select Id,Name from Group Where Name in :varmap.values()];
        for(Group g:grup){
            grupmap.put(g.Name,g.id);
        }
        for(ID uid:varmap.keyset()){
            if(grupmap.containsKey(varmap.get(uid))){
                GroupMember gm= new GroupMember(); 
                gm.GroupId=grupmap.get(varmap.get(uid));
                gm.UserOrGroupId =uid;
                insrtmem.add(gm);
            }
        }
        
        //Delete Group members
        if(!oldmap.isEmpty()){
            Map<Id,GroupMember> grupmem=new Map<Id,GroupMember>();
            List<GroupMember> grupm =[Select Id, UserOrGroupId From GroupMember Where Group.Name in:oldmap.values()];
            for(GroupMember gm:grupm){
                grupmem.put(gm.UserOrGroupId,gm);
            }
            for(ID uid:oldmap.keyset()){
                if(grupmem.containsKey(uid)){
                    GroupMember gm= new GroupMember(); 
                    gm.GroupId=grupmap.get(oldmap.get(uid));
                    gm.UserOrGroupId =uid;
                    deltmem.add(grupmem.get(uid));
                }
            }
        }
        try{
            insert insrtmem;
            delete deltmem;
        }
        Catch(Exception e){}
        
    }
}