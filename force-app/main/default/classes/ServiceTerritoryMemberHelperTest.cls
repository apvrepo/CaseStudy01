/* @Description  This is a Test Class for the 'ServiceTerritoryMemberHelper' Aplex Class
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      03/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

@isTest
public class ServiceTerritoryMemberHelperTest {
    
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
        List<User> userList = TestDataFactory.createUsers(2);  
        List<OperatingHours> weekOperatingHoursList = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlots = TestDataFactory.createWeekTimeSlots(weekOperatingHoursList); 
        List<ServiceResource> serviceResourcesList = TestDataFactory.createServiceResources(userList);        
        List<ServiceTerritory> serviceTerritoryList = TestDataFactory.createServiceTerritoryRecords(1, weekOperatingHoursList); 
        String territoryType = 'P'; // M = Mixed   /  P = Primary / S = Secondary
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
        List<ServiceTerritoryMember> primaryServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                          LIMIT 190];      
        for(serviceTerritory sT : serviceTerritoryList){
            System.assertEquals(true, sT.IsActive);
        }
        
        Datetime todaysDate = Datetime.now();
        for(ServiceTerritoryMember sTM : primaryServiceTerritoryMemberList){
            System.assertNotEquals(todaysDate.addDays(-2), sTM.EffectiveStartDate); 
            System.assertNotEquals(todaysDate.addDays(-1), sTM.EffectiveEndDate);
        } 
        
        primaryServiceTerritoryMemberList[0].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
        primaryServiceTerritoryMemberList[0].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 20, 00,00,00); 
        
        update primaryServiceTerritoryMemberList; 
        
        List<User> userList = TestDataFactory.createUsers(1);  
        List<OperatingHours> weekOperatingHoursList = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlots = TestDataFactory.createWeekTimeSlots(weekOperatingHoursList); 
        List<ServiceResource> serviceResourcesList = TestDataFactory.createServiceResources(userList);            
        
        List<ServiceTerritoryMember> sTMList = new List<ServiceTerritoryMember>();    
        for(ServiceTerritory sT : serviceTerritoryList){         
            // The amount of ServiceTerritoryMember records will be equal to the amount of diferent ServiceResources, to avoid DUPLICATE_VALUE errors on the field ServiceResourceId
            for ( Integer i=0; i < serviceResourcesList.size(); i++ ) {
                
                Integer num = Integer.valueOf(i);
                ServiceTerritoryMember sTM = new ServiceTerritoryMember(); 
                sTM.ServiceTerritoryId= sT.Id; 
                sTM.ServiceResourceId= serviceResourcesList[i].Id; 
                sTM.TerritoryType= 'S';
                sTM.EffectiveStartDate=  Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
                sTM.EffectiveEndDate= Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00); 
                sTM.OperatingHoursId= sT.OperatingHoursId; 
                sTMList.add(sTM);
            }
        }
        
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        Test.startTest();
        
        Database.SaveResult[] saveResults = Database.insert(sTMList, false);
        
        Test.stopTest();
        
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());  
            }
        }
        if(!failedRecordsErrors.isEmpty()){
            for (Database.Error error : failedRecordsErrors) {
                System.debug('ServiceTerritoryMemberHelperTest.positiveScenario() - Failed Record Error: ' + error.getMessage());
            }
        }  
        
        List<ServiceTerritoryMember> updatedServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE TerritoryType= 'S'
                                                                          LIMIT 190];
        
        for(ServiceTerritoryMember sTM : updatedServiceTerritoryMemberList){
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00), sTM.EffectiveStartDate); 
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00), sTM.EffectiveEndDate);
        } 
    }
    
    
    
    @isTest 
    static void negativeScenario() {
        List<ServiceTerritory> serviceTerritoryList = [SELECT Id, Name, OperatingHoursId, IsActive 
                                                       FROM ServiceTerritory 
                                                       LIMIT 190];
        
        Set<Id> serviceTerritoryIdSets = new Set<Id>();
        for(serviceTerritory sT : serviceTerritoryList){
            serviceTerritoryIdSets.add(sT.Id);
        }
        List<ServiceTerritoryMember> primaryServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                          LIMIT 190];      
        for(serviceTerritory sT : serviceTerritoryList){
            System.assertEquals(true, sT.IsActive);
        }
        
        Datetime todaysDate = Datetime.now();
        for(ServiceTerritoryMember sTM : primaryServiceTerritoryMemberList){
            System.assertNotEquals(todaysDate.addDays(-2), sTM.EffectiveStartDate); 
            System.assertNotEquals(todaysDate.addDays(-1), sTM.EffectiveEndDate);
        } 
        
        primaryServiceTerritoryMemberList[0].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
        primaryServiceTerritoryMemberList[0].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 20, 00,00,00); 
        
        update primaryServiceTerritoryMemberList; 
        
        List<User> userList = TestDataFactory.createUsers(1);  
        List<OperatingHours> weekOperatingHoursList = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlots = TestDataFactory.createWeekTimeSlots(weekOperatingHoursList); 
        List<ServiceResource> serviceResourcesList = TestDataFactory.createServiceResources(userList);            
        
        List<ServiceTerritoryMember> sTMList = new List<ServiceTerritoryMember>();    
        for(ServiceTerritory sT : serviceTerritoryList){         
            // The amount of ServiceTerritoryMember records will be equal to the amount of diferent ServiceResources, to avoid DUPLICATE_VALUE errors on the field ServiceResourceId
            for ( Integer i=0; i < serviceResourcesList.size(); i++ ) {
                
                Integer num = Integer.valueOf(i);
                ServiceTerritoryMember sTM = new ServiceTerritoryMember(); 
                sTM.ServiceTerritoryId= sT.Id; 
                sTM.ServiceResourceId= serviceResourcesList[i].Id; 
                sTM.TerritoryType= 'S';
                sTM.EffectiveStartDate=  Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
                sTM.EffectiveEndDate= Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 23, 00,00,00); 
                sTM.OperatingHoursId= sT.OperatingHoursId; 
                sTMList.add(sTM);
            }
        }
        
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        Test.startTest();
        
        Database.SaveResult[] saveResults = Database.insert(sTMList, false);
        
        Test.stopTest();
        
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());  
            }
        }
        if(!failedRecordsErrors.isEmpty()){
            for (Database.Error error : failedRecordsErrors) {
                System.debug('ServiceTerritoryMemberHelperTest.positiveScenario() - Failed Record Error: ' + error.getMessage());
            }
        }  
        
        List<ServiceTerritoryMember> updatedServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE TerritoryType= 'S'
                                                                          LIMIT 190];
        Datetime todayDate = System.now().addDays(-5);
        for(ServiceTerritoryMember sTM : updatedServiceTerritoryMemberList){
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00), sTM.EffectiveStartDate); 
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(),todayDate.day() , 00,00,00), sTM.EffectiveEndDate);
            
        }
    } 
    @isTest 
    static void alternativeScenario() {
        List<ServiceTerritory> serviceTerritoryList = [SELECT Id, Name, OperatingHoursId, IsActive 
                                                       FROM ServiceTerritory 
                                                       LIMIT 190];
        
        Set<Id> serviceTerritoryIdSets = new Set<Id>();
        for(serviceTerritory sT : serviceTerritoryList){
            serviceTerritoryIdSets.add(sT.Id);
        }
        List<ServiceTerritoryMember> primaryServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                          LIMIT 190];      
        for(serviceTerritory sT : serviceTerritoryList){
            System.assertEquals(true, sT.IsActive);
        }
        
        Datetime todaysDate = Datetime.now();
        for(ServiceTerritoryMember sTM : primaryServiceTerritoryMemberList){
            System.assertNotEquals(todaysDate.addDays(-2), sTM.EffectiveStartDate); 
            System.assertNotEquals(todaysDate.addDays(-1), sTM.EffectiveEndDate);
        } 
        
        primaryServiceTerritoryMemberList[0].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
        primaryServiceTerritoryMemberList[0].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveEndDate = null; 
        
        update primaryServiceTerritoryMemberList; 
        
        List<User> userList = TestDataFactory.createUsers(1);  
        List<OperatingHours> weekOperatingHoursList = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlots = TestDataFactory.createWeekTimeSlots(weekOperatingHoursList); 
        List<ServiceResource> serviceResourcesList = TestDataFactory.createServiceResources(userList);            
        
        List<ServiceTerritoryMember> sTMList = new List<ServiceTerritoryMember>();    
        for(ServiceTerritory sT : serviceTerritoryList){         
            // The amount of ServiceTerritoryMember records will be equal to the amount of diferent ServiceResources, to avoid DUPLICATE_VALUE errors on the field ServiceResourceId
            for ( Integer i=0; i < serviceResourcesList.size(); i++ ) {
                
                Integer num = Integer.valueOf(i);
                ServiceTerritoryMember sTM = new ServiceTerritoryMember(); 
                sTM.ServiceTerritoryId= sT.Id; 
                sTM.ServiceResourceId= serviceResourcesList[i].Id; 
                sTM.TerritoryType= 'S';
                sTM.EffectiveStartDate=  Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 17, 00,00,00); 
                sTM.EffectiveEndDate= Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 23, 00,00,00); 
                sTM.OperatingHoursId= sT.OperatingHoursId; 
                sTMList.add(sTM);
            }
        }
        
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        Test.startTest();
        
        Database.SaveResult[] saveResults = Database.insert(sTMList, false);
        
        Test.stopTest();
        
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());  
            }
        }
        if(!failedRecordsErrors.isEmpty()){
            for (Database.Error error : failedRecordsErrors) {
                System.debug('ServiceTerritoryMemberHelperTest.positiveScenario() - Failed Record Error: ' + error.getMessage());
            }
        }  
        
        List<ServiceTerritoryMember> updatedServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE TerritoryType= 'S'
                                                                          LIMIT 190];
        
        for(ServiceTerritoryMember sTM : updatedServiceTerritoryMemberList){
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 17, 00,00,00), sTM.EffectiveStartDate); 
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 23, 00,00,00), sTM.EffectiveEndDate);
        } 
    }
    
    
    @isTest 
    static void bulkScenario() { 
        List<ServiceTerritoryMember> sTMList = new List<ServiceTerritoryMember>();     
        List<ServiceTerritory> serviceTerritoryList = [SELECT Id, Name, OperatingHoursId, IsActive 
                                                       FROM ServiceTerritory 
                                                       LIMIT 190];
        
        Set<Id> serviceTerritoryIdSets = new Set<Id>();
        for(serviceTerritory sT : serviceTerritoryList){
            serviceTerritoryIdSets.add(sT.Id);
        }
        List<ServiceTerritoryMember> primaryServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE ServiceTerritoryId = :serviceTerritoryIdSets
                                                                          LIMIT 190];      
        
        primaryServiceTerritoryMemberList[0].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 9, 00,00,00); 
        primaryServiceTerritoryMemberList[0].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 13, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveStartDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00); 
        primaryServiceTerritoryMemberList[1].EffectiveEndDate = Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 20, 00,00,00); 
        
        update primaryServiceTerritoryMemberList; 
        
        
        List<User> userListTwo = TestDataFactory.createUsers(200);  
        List<OperatingHours> weekOperatingHoursListTwo = TestDataFactory.createWeekOperatingHours(); // Creates Only One Record
        List<TimeSlot> weekTimeSlotsTwo = TestDataFactory.createWeekTimeSlots(weekOperatingHoursListTwo); 
        List<ServiceResource> serviceResourcesListTwo = TestDataFactory.createServiceResources(userListTwo);            
        
        for(ServiceTerritory sT : serviceTerritoryList){         
            // The amount of ServiceTerritoryMember records will be equal to the amount of diferent ServiceResources, to avoid DUPLICATE_VALUE errors on the field ServiceResourceId
            for ( Integer j=0 ; j < serviceResourcesListTwo.size(); j++ ) {
                
                Integer num = Integer.valueOf(j);
                ServiceTerritoryMember sTM = new ServiceTerritoryMember(); 
                sTM.ServiceTerritoryId= sT.Id; 
                sTM.ServiceResourceId= serviceResourcesListTwo[j].Id; 
                sTM.TerritoryType= 'S';
                sTM.EffectiveStartDate=  Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00); 
                sTM.EffectiveEndDate= Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 20, 00,00,00); 
                sTM.OperatingHoursId= sT.OperatingHoursId; 
                sTMList.add(sTM);
            }
        }
        
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        Test.startTest();
        
        Database.SaveResult[] saveResults = Database.insert(sTMList, false);
        
        Test.stopTest();   
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());  
            }
        }
        if(!failedRecordsErrors.isEmpty()){
            for (Database.Error error : failedRecordsErrors) {
                System.debug('ServiceTerritoryMemberHelperTest.positiveScenario() - Failed Record Error: ' + error.getMessage());
            }
        }  
        
        List<ServiceTerritoryMember> updatedServiceTerritoryMemberList = [SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                                                                          FROM ServiceTerritoryMember 
                                                                          WHERE TerritoryType= 'S'
                                                                          LIMIT 190];
        
        for(ServiceTerritoryMember sTM : updatedServiceTerritoryMemberList){
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 16, 00,00,00), sTM.EffectiveStartDate); 
            System.assertEquals(Datetime.newInstance(Datetime.now().year(), Datetime.now().month(), 20, 00,00,00), sTM.EffectiveEndDate);
        } 
    }
    /*
@isTest 
static void edgeScenarioOne() { 
} 

@isTest 
static void edgeScenarioTwo() {   
}
*/  
}