trigger ServiceTerritoryMemberTrigger on ServiceTerritoryMember (before insert, after insert, before update, after update) {
    new ServiceTerritoryMemberTriggerHandler().run();
}