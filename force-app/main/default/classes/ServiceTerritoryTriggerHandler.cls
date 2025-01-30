/* @Description  This ServiceTerritoryTriggerHandler class executes the logics based on the ServiceTerritoryTrigger events.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      01/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

public without sharing class ServiceTerritoryTriggerHandler extends TriggerHandler {

    private List<ServiceTerritory> newServiceTerritoryList;
    private Map<Id, ServiceTerritory> oldServiceTerritoryMap;
    private List<ServiceTerritory> serviceTerritoryListToProcess;

    public ServiceTerritoryTriggerHandler() {
        this.newServiceTerritoryList = (List<ServiceTerritory>) Trigger.new;
        this.oldServiceTerritoryMap = (Map<Id, ServiceTerritory>) Trigger.oldMap;
        this.serviceTerritoryListToProcess = new List<ServiceTerritory>();
    }

    // Instance of the Apex Class 'ServiceTerritoryHelper':
    private ServiceTerritoryHelper serviceTerritoryHelper = new ServiceTerritoryHelper();

    public override void afterUpdate() {
        for (ServiceTerritory st : newServiceTerritoryList) {
            ServiceTerritory oldSt = oldServiceTerritoryMap.get(st.Id);
            if (oldSt.isActive && !st.isActive) {
                serviceTerritoryListToProcess.add(st);
            }
        }
        if (!serviceTerritoryListToProcess.isEmpty()) {
            serviceTerritoryHelper.setEffectiveEndDate(serviceTerritoryListToProcess);
        }
    }
}