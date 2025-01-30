trigger ServiceTerritoryTrigger on ServiceTerritory (before insert, after insert, before update, after update) {
  new ServiceTerritoryTriggerHandler().run();
}