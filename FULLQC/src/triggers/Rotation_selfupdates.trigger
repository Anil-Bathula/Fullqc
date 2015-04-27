trigger Rotation_selfupdates on Rotation__c (Before insert,Before Update) 
{
    for(Rotation__c rot:Trigger.New)
    {
        string name=rot.Name__c+' : '+rot.Type__c+' : '+rot.Rotation_Campus__c;
        
        rot.Name=name.length()>=80?name.substring(0,80):name;
    }
}