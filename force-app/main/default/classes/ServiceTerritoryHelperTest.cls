/* @Description  This is a Test Class for the 'ServiceTerritoryHelper' Aplex Class
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      03/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

@isTest
private class ServiceTerritoryHelperTest {
    
    @testSetup 
    static void setup() {   
        /* 
Order of Creation:
1- Users
2- Operating Hours + Time Slots
3- Service Resources 
4- Service Territory with the Operating Hours
5- Service Territory Members with Operating Hours
*/          
        List<User> userList = TestDataFactory.createUsers(3);  
        List<OperatingHours> weekOperatingHoursList = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlots = TestDataFactory.createWeekTimeSlots(weekOperatingHoursList); 
        List<ServiceResource> serviceResourcesList = TestDataFactory.createServiceResources(userList);        
        List<ServiceTerritory> serviceTerritoryList = TestDataFactory.createServiceTerritoryRecords(1, weekOperatingHoursList); 
        String territoryType = 'M'; // M = Mixed   /  P = Primary / S = Secondary
        List<ServiceTerritoryMember> serviceTerritoryMemberList = TestDataFactory.createServiceTerritoryMemberRecords(serviceTerritoryList, serviceResourcesList, territoryType);       
    }
    
    @isTest 
    static void positiveScenario() {
        List<ServiceTerritory> serviceTerritoryList = [SELECT Id, Name, OperatingHoursId, IsActive 
                                                       FROM ServiceTerritory 
                                                       LIMIT 190];
        Set<Id> serviceTerritoryIdSets = new Set<Id>();
        for(serviceTerritory sT : serviceTerritoryList){
            serviceTerritoryIdSets.add(sT.Id);
        }
        List<ServiceTerritoryMember> serviceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                   FROM ServiceTerritoryMember 
                                                                   WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                   LIMIT 190];      
        for(serviceTerritory sT : serviceTerritoryList){
            System.assertEquals(true, sT.IsActive);
        }
        
        Datetime todaysDate = Datetime.now();
        for(ServiceTerritoryMember sTM : serviceTerritoryMemberList){
            System.assertNotEquals(todaysDate.addDays(-2), sTM.EffectiveStartDate); 
            System.assertNotEquals(todaysDate.addDays(-1), sTM.EffectiveEndDate);
        } 
        
        for(serviceTerritory sT : serviceTerritoryList){
            sT.IsActive = false;
        }
        
        List<Database.Error> failedRecordsErrors = new List<Database.Error>(); 
        
        Test.startTest();   
        Database.SaveResult[] saveResults = Database.update(serviceTerritoryList, false);           
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());  
            }
        }
        if(!failedRecordsErrors.isEmpty()){
            for (Database.Error error : failedRecordsErrors) {
                System.debug('FLAG - ServiceTerritoryHelperTest.positiveScenario() - Failed Record Error: ' + error.getMessage());
            }
        }    
        
        Test.stopTest();
        List<ServiceTerritory> updatedServiceTerritoryList = [SELECT Id, Name, OperatingHoursId, IsActive 
                                                              FROM ServiceTerritory 
                                                              LIMIT 190];
        List<ServiceTerritoryMember> updatedServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                          LIMIT 190];   
        if(failedRecordsErrors.isEmpty()){
            for(serviceTerritory sT : updatedServiceTerritoryList){
                System.assertEquals(false, sT.IsActive);
            } 
            
            for(ServiceTerritoryMember sTM : updatedServiceTerritoryMemberList){
                System.assertEquals(todaysDate.addDays(-2), sTM.EffectiveStartDate); 
                System.assertEquals(todaysDate.addDays(-1), sTM.EffectiveEndDate);
            }   
        } 
    }
    
    /*
@isTest 
static void negativeScenario() {
}

@isTest 
static void bulkScenario() {
}


@isTest 
static void edgeScenarioOne() { 
} 

@isTest 
static void edgeScenarioTwo() {   
}
*/
    
}