/***************************
Trigger:CampaignMemberStatus
Developer:Anil.B
Purpose: TO set the campaign member status 
with the new values in the picklist when the 
campaign type='Events' for other it will be
Sent and responded.
Test Class Name:-CampaignMemberStatus_Test(88%)
***************************/



trigger CampaignMemberStatus on Campaign (after insert) {
    
    Set<Id> campgnID = new Set<Id>();
    List<CampaignMemberStatus> cms = new List<CampaignMemberStatus>();    
    List<CampaignMemberStatus> cms2Delete = new List<CampaignMemberStatus>();
    List<CampaignMemberStatus> cms2Insert = new List<CampaignMemberStatus>();
    map<id,Integer> mapcampaign=new map<id,Integer>();
    id Event_rectype=RecordTypeHelper.getRecordTypeId('Campaign','Event');
    List<string>mem_status=new List<String>{'Attended','Not Attended','Walk In','Fair Registered','Fair Registered - Hult Website','Met'};
    
    for(Campaign camp : Trigger.New){
        if(Camp.recordtypeid==Event_rectype){       
            campgnID.add(camp.Id);
        }
    }   
    
    System.debug('===>'+campgnID);
    if(!campgnID.ISempty()){
         integer i=0;
         Set<String> varlable=new Set<String>();
         cms2Delete=[select Id, Label,SortOrder,CampaignId from CampaignMemberStatus where CampaignId IN :campgnID AND Label NOT IN:mem_status];
         System.debug('==Del==>'+ cms2Delete);
         for(CampaignMemberStatus cm : cms2Delete) 
         {
                i=mapcampaign.containsKey(cm.campaignid)?mapcampaign.get(cm.campaignid):0;
                i++;
                mapcampaign.put(cm.campaignid,i);  
                        
         }      
               
         for(id ids:campgnID){
             
             integer j=mapcampaign.containskey(ids)?mapcampaign.get(ids):0;
             j++;
             CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId = ids, HasResponded=false,Label = 'Registered', SortOrder =j, isDefault = true);
             cms2Insert.add(cms1); 
             System.debug('==Cms1==>'+ cms1.isDefault);         
                
             j++;
             CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Attended', SortOrder =j);
             cms2Insert.add(cms2);
             System.debug('==cms2==>'+ cms2);
             j++;    
             CampaignMemberStatus cms3 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Not Attended', SortOrder = j);
             cms2Insert.add(cms3); 
                 
             j++;    
             CampaignMemberStatus cms4 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Walk In', SortOrder =j);
             cms2Insert.add(cms4);
             
             j++;    
             CampaignMemberStatus cms5 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Fair Registered', SortOrder =j);
             cms2Insert.add(cms5);
             
             j++;    
             CampaignMemberStatus cms6 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Fair Registered - Hult Website', SortOrder =j);
             cms2Insert.add(cms6);
             
             j++;    
             CampaignMemberStatus cms7 = new CampaignMemberStatus(CampaignId = ids, HasResponded=true,Label = 'Met', SortOrder =j);
             cms2Insert.add(cms7);    
            
          }
    }
   
    system.debug('====>'+cms2Insert.size()+'=====>'+cms2insert);
    try{
        insert cms2Insert;
        System.debug('==insert==>'+ cms2Insert.size()+'====>'+campgnID);
       }
    catch(Exception e){system.debug(e);}
    
    
    try{
    System.debug('==Del==>'+ cms2Delete);
    
        if(!cms2Delete.ISEmpty())
        {
            delete cms2Delete;
        }
    }catch(Exception e){system.debug(e);}    
   
}