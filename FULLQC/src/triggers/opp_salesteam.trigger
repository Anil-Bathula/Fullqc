trigger opp_salesteam on Opportunity (after update) 
{
    /*
        Developer   : Harsha Simha S
        Date        : 8/8/2012
        Description : on Change of opportunity owner : existing salesteam will be deleted 
                        and default salesteam of the owner will be added. 
    //completely commented by shs for jira case 603.
    
    list<string> oppids=new list<string>();
    list<string> usrids=new list<string>();
    map<string,List<UserTeamMember>> utmap=new map<string,List<UserTeamMember>>();
    list<OpportunityTeamMember> insotm=new List<OpportunityTeamMember>();
    for(opportunity o:Trigger.New)
    {
        if(o.OwnerId!=Trigger.oldMap.get(o.Id).OwnerId)
        {
            oppids.add(o.Id);
            usrids.add(o.OwnerId);
        }
    }
    
    if(!oppids.IsEmpty())
    {
        for(UserTeamMember utm:[Select UserId, TeamMemberRole, OwnerId, OpportunityAccessLevel, Id From UserTeamMember where OwnerId in: usrids])
        {
            list<UserTeamMember> u=new List<UserTeamMember>();
            if(utmap.containsKey(utm.OwnerId))
            {
                u=utmap.get(utm.OwnerId);
            }
            u.add(utm);
            utmap.put(utm.OwnerId,u);
        }
        List<OpportunityTeamMember> delotm=[select id,OpportunityId from OpportunityTeamMember where OpportunityId IN : oppids];
        if(!delotm.IsEmpty())
        {
            try
            {
                delete delotm;
            }
            catch(Exception e)
            {
                system.Debug(e);
            }
        }
        for(string o:oppids)
        {
            if(utmap.ContainsKey(trigger.Newmap.get(o).OwnerId))
            {
                for(UserTeamMember u:utmap.get(trigger.Newmap.get(o).OwnerId))
                {
                    OpportunityTeamMember otm=new OpportunityTeamMember();
                    otm.OpportunityId=o;
                    otm.UserId=u.UserId;//UserTeamMember.
                    otm.TeamMemberRole=u.TeamMemberRole;
                    //otm.OpportunityAccessLevel=u.OpportunityAccessLevel;
                    insotm.add(otm);
                }
            } 
        }
        if(!insotm.ISEmpty())
        {
            try
            {
                insert insotm;
            }
            catch(Exception e)
            {
                System.debug(e);
            }
        }
    }*/
}