trigger Opportunity_UpdateRollups on Opportunity (before insert, before update) {
    new Opportunity_UpdateRollups(trigger.old, trigger.new).execute();
}