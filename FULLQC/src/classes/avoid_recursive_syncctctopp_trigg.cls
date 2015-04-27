/*
    Class     : avoid_recursive_syncctctopp_trigg 
    Developer : Harsha Simha S
    Date      : 10/31/2012
    Comment   : To avoid recursive exceution of Sync_contact_opp_fields & Sync_opp_contact_fields After Insert/Update triggers.     
    
    ----------------------------
    Enhancement :To avoid recursive exceution of Sync_contact_opp_fields & Sync_opp_contact_fields Before Update triggers.                        
    Date        :5/8/2013
    Developer   :Harsha Simha S
     
*/
public with sharing class avoid_recursive_syncctctopp_trigg 
{   
    private static boolean triggfiredalready = false;
    public static boolean hastriggfiredalready() 
    {
        return triggfiredalready;
    }
    public static void settriggfiredalready() 
    {
        triggfiredalready = true;
    }
    
    
    private static set<string> fired_opps = new set<string>();
    public static boolean has_opp_alreadywaived(string oid) 
    {
        return fired_opps.contains(oid);
    }
    public static void set_opp_waived(string oid) 
    {
        fired_opps.add(oid);
    }
    
    private static set<string> salestree_stage = new set<string>();
    private static set<string> salestree_accstatus = new set<string>();
    public static boolean has_salestree_opp_alreadyfired(string setname,string oid) 
    {
        if(setname=='salestree_stage')
            return salestree_stage.contains(oid);
        if(setname=='salestree_accstatus')
            return salestree_accstatus.contains(oid);    
            
        return false;
    }
    public static void set_salestree_opp_fired(string setname,string oid) 
    {
        if(setname=='salestree_stage')
            salestree_stage.add(oid);
        if(setname=='salestree_accstatus')
            salestree_accstatus.add(oid);  
    }
}