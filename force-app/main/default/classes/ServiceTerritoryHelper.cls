/* @Description  This ServiceTerritoryHelper class holds the complex logic for the ServiceTerritoryTriggerHandler.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      01/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

public without sharing class ServiceTerritoryHelper {
    
    public ServiceTerritoryHelper() {
    }
    
    public void setEffectiveEndDate (List<ServiceTerritory> serviceTerritoryToProcess) {
        Set<Id> serviceTerritoryIdsList = new Set<Id>();
        // Check if the ServiceTerritory.IsActive field has changed to false
        for(ServiceTerritory serTer : serviceTerritoryToProcess){
            if(serTer.IsActive == false){
                serviceTerritoryIdsList.add(serTer.Id);
            }
        }
        if(!serviceTerritoryIdsList.isEmpty()){
            List<ServiceTerritoryMember> serviceTerritoryMemberToUpdateList = new List<ServiceTerritoryMember>();
            // Query all the related Service Territory Members
            List<ServiceTerritoryMember> relatedServiceTerritoryMembersList = Database.query('SELECT Id, EffectiveEndDate, EffectiveStartDate, ServiceTerritoryId ' +
                                                                                             'FROM ServiceTerritoryMember ' +
                                                                                             'WHERE ServiceTerritoryId = :serviceTerritoryIdsList', AccessLevel.SYSTEM_MODE); 
            if(!relatedServiceTerritoryMembersList.isEmpty()){
                // Change the EffectiveEndDate in every related Service Territory Member
                for(ServiceTerritoryMember serTerMem : relatedServiceTerritoryMembersList){
                    Datetime todaysDate = Datetime.now();
                    serTerMem.EffectiveEndDate = todaysDate.addDays(-1); 
                    serTerMem.EffectiveStartDate  = todaysDate.addDays(-2); // The Start Date must be earlier than the End Date
                    serviceTerritoryMemberToUpdateList.add(serTerMem);
                }  
            }
            if(!serviceTerritoryMemberToUpdateList.isEmpty()){
                // Perform the DML operation and capture the results
                Database.SaveResult[] saveResults = Database.update(serviceTerritoryMemberToUpdateList, false);
                
                List<Database.Error> failedRecordsErrors = new List<Database.Error>();
                for (Database.SaveResult saveResult : saveResults) {
                    if (!saveResult.isSuccess()) {
                        failedRecordsErrors.addAll(saveResult.getErrors());
                    }
                }
                if(!failedRecordsErrors.isEmpty()){
                    for (Database.Error error : failedRecordsErrors) {
                        System.debug('ServiceTerritoryHelper.setEffectiveEndDate() - Failed Record Error: ' + error.getMessage());
                    }
                }    
            }
        }    
    }  
}