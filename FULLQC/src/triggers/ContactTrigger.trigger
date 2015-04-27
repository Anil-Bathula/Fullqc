trigger ContactTrigger on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    final ContactHandler handler = ContactHandler.getHandler();
    
    if(Trigger.isAfter && Trigger.isInsert) { handler.afterInsert(); return; }
    if(Trigger.isAfter && Trigger.isUpdate) { handler.afterUpdate(); return; }
}