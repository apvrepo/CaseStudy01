/* @Description  This is a Test Class that helps creating test data for the rest of Test Classes
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      02/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

@IsTest
public class TestDataFactory {
    
    // USERS
    public static List<User> createUsers(Integer numUsers) {
        Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Integer randomInt = Integer.valueOf(Math.floor(Math.random() * 16003) + 1);
        
        List<User> uList = new List<User>();
        for ( Integer i=0; i < numUsers; i++ ) {
            User u = new User(); 
            u.LastName= 'Test';
            u.FirstName= 'User' + i;
            // u.Name= ;
            u.ProfileId = adminProfile.Id;
            u.IsActive= true;
            u.Alias = 'User' + i;
            u.EmailEncodingKey = 'UTF-8';
            u.Email = u.FirstName + '@gmail.com'; 
            u.Username= String.valueOf(u.FirstName + randomInt) + '@gmail.com';
            u.TimeZoneSidKey= 'Europe/Amsterdam';
            u.UserRoleId= null;
            u.LocaleSidKey= 'nl_NL';
            //  u.UserType= 'Standard';
            u.LanguageLocaleKey= 'en_US';
            u.UserPermissionsSFContentUser= true;
            u.UserPermissionsKnowledgeUser= true;
            u.UserPermissionsSupportUser= true;
            u.ContactId= null;
            // u.AccountId= null;
            u.DigestFrequency= 'D';
            u.DefaultGroupNotificationFrequency= 'N';
            u.JigsawImportLimitOverride= 300;
            uList.add(u);
        }
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(uList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory - Users - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }
        return uList;
    } 
    
    // SERVICE RESOURCES
    public static List<ServiceResource> createServiceResources(List<User> usersToRelateToServiceResources) {
        
        List<ServiceResource> sRList = new List<ServiceResource>();
        for ( Integer i=0; i < usersToRelateToServiceResources.size(); i++ ) {
            ServiceResource sR = new ServiceResource(); 
            //   sR.OwnerId= ;
            sR.Name= 'Technician' + i;
            //   sR.CreatedDate= ;
            //   sR.CreatedById= ;
            //   sR.LastModifiedDate= ;
            //   sR.LastModifiedById= ;
            //   sR.SystemModstamp= ;
            //   sR.LastViewedDate= ;
            //   sR.LastReferencedDate= ;
            sR.RelatedRecordId= usersToRelateToServiceResources[i].Id;
            sR.ResourceType= 'T';
            sR.Description= 'Field tech guy number' + i;
            sR.IsActive= true;
            sR.IsCapacityBased= false;
            sR.IsOptimizationCapable= false;
            //   sR.LastKnownLatitude= null;
            //    sR.LastKnownLongitude= null;
            //     sR.LastKnownLocationDate= null;
            sR.LocationId= null;
            sR.ServiceCrewId= null;
            sR.AccountId= null;
            sR.SchedulingConstraintId= null;
            sRList.add(sR);
        }
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(sRList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createServiceResources() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }  
        return sRList;
    }
    
    // WEEK OPERATING HOURS
    public static List<OperatingHours> createWeekOperatingHours() { 
        List<OperatingHours> oHList = new List<OperatingHours>();
        
        for ( Integer i=0; i < 1 ; i++ ) {
            OperatingHours oH = new OperatingHours(); 
            //oH.IsDeleted= false;
            oH.Name= 'Mon-Fri 8am-5pm';
            // oH.CreatedDate= ;
            //  oH.CreatedById= ;
            //  oH.LastModifiedDate= ;
            //  oH.LastModifiedById= ;
            //  oH.SystemModstamp= ;
            //  oH.LastViewedDate= ;
            //  oH.LastReferencedDate= ;
            oH.Description= 'Amsterdam Hours';
            oH.TimeZone= 'Europe/Amsterdam'; 
            oHList.add(oH);
        }   
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(oHList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createWeekOperatingHours() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        } 
        return oHList;
    } 
    
    // WEEKEND OPERATING HOURS
    public static List<OperatingHours> createWeekendOperatingHours() { 
        List<OperatingHours> oHList = new List<OperatingHours>();
        
        for ( Integer i=0; i < 1 ; i++ ) {
            OperatingHours oH = new OperatingHours(); 
            //oH.IsDeleted= false;
            oH.Name= 'Weekend 8am-1pm';
            // oH.CreatedDate= ;
            //  oH.CreatedById= ;
            //  oH.LastModifiedDate= ;
            //  oH.LastModifiedById= ;
            //  oH.SystemModstamp= ;
            //  oH.LastViewedDate= ;
            //  oH.LastReferencedDate= ;
            oH.Description= 'Amsterdam Hours';
            oH.TimeZone= 'Europe/Amsterdam'; 
            oHList.add(oH);
        }   
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(oHList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createWeekendOperatingHours() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        } 
        return oHList;
    }
    
    // WEEK TIME SLOTS
    public static List<TimeSlot> createWeekTimeSlots(List<OperatingHours> operatingHoursList) { 
        List<TimeSlot> timeSlotList = new List<TimeSlot>();
        List<String> daysOfTheWeek = new List<String>{'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};              
            for(OperatingHours oH : operatingHoursList){
                for(Integer i=0; i < daysOfTheWeek.size() ; i++ ){
                    TimeSlot tS = new TimeSlot(); 
                    // tS.IsDeleted=false;
                    // tS.TimeSlotNumber= 'TS-0001';
                    // tS.CreatedDate= '';
                    // tS.CreatedById= '';
                    //  tS.LastModifiedDate= '';
                    // tS.LastModifiedById= '';
                    // tS.SystemModstamp= '';
                    //  tS.LastViewedDate= '';
                    //  tS.LastReferencedDate= '';
                    tS.OperatingHoursId= oH.Id;
                    tS.DayOfWeek= daysOfTheWeek[i];
                    tS.Type= 'Normal';
                    tS.StartTime= Time.newInstance(8, 00, 00, 00); 
                    tS.EndTime= Time.newInstance(17, 00, 00, 00); 
                    timeSlotList.add(tS);
                }
            }
        
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(timeSlotList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createWeekTimeSlots() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        } 
        return timeSlotList;
    }
    
    // WEEKEND TIME SLOTS
    public static  List<TimeSlot> createWeekendTimeSlots(List<OperatingHours> operatingHoursList) { 
        List<TimeSlot> timeSlotList = new List<TimeSlot>();
        List<String> daysOfTheWeek = new List<String>{'Saturday', 'Sunday'};  
            for(OperatingHours oH : operatingHoursList){
                for(Integer i=0; i < daysOfTheWeek.size() ; i++ ){ 
                    TimeSlot tS = new TimeSlot(); 
                    // tS.IsDeleted=false;
                    // tS.TimeSlotNumber= 'TS-0001';
                    // tS.CreatedDate= '';
                    // tS.CreatedById= '';
                    //  tS.LastModifiedDate= '';
                    // tS.LastModifiedById= '';
                    // tS.SystemModstamp= '';
                    //  tS.LastViewedDate= '';
                    //  tS.LastReferencedDate= '';
                    tS.OperatingHoursId= oH.Id;
                    tS.DayOfWeek= daysOfTheWeek[i];
                    tS.Type= 'Normal';
                    tS.StartTime= Time.newInstance(8, 00, 00, 00); 
                    tS.EndTime= Time.newInstance(13, 00, 00, 00); 
                    timeSlotList.add(tS);
                }
            }
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(timeSlotList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createWeekTimeSlots() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }  
        return timeSlotList;
    }
    
    // SERVICE TERRITORIES
    public static List<ServiceTerritory> createServiceTerritoryRecords(Integer numST, List<OperatingHours> operatingHoursList) {
        List<ServiceTerritory> sTSList = new List<ServiceTerritory>();
        
        for ( Integer i=0; i < numST; i++ ) {
            ServiceTerritory st = new ServiceTerritory(); 
            //   st.OwnerId= ;
            //   st.IsDeleted= false;
            st.Name= 'TestServiceTerritory' + i;
            //   st.CreatedDate= ;
            //   st.CreatedById= ;
            //   st.LastModifiedDate= ;
            //   st.LastModifiedById= ;
            //   st.SystemModstamp= ;
            //   st.LastViewedDate= ;
            //   st.LastReferencedDate= ;
            st.ParentTerritoryId= null;
            //    st.TopLevelTerritoryId= ;
            st.Description= null;
            st.OperatingHoursId= operatingHoursList[i].Id;
            st.Street= null;
            st.City= null;
            st.State= null;
            st.PostalCode= null;
            st.Country= null;
            st.Latitude= null;
            st.Longitude= null;
            st.GeocodeAccuracy= null;
            st.IsActive= true;
            st.TypicalInTerritoryTravelTime= null;
            st.SchedulingConstraintId= null;
            st.TravelModeId= null;
            sTSList.add(st);
        }
        
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(sTSList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createServiceTerritoryRecords() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }
        return sTSList;
    }
    
    // SERVICE TERRITORY MEMBERS
    public static List<ServiceTerritoryMember> createServiceTerritoryMemberRecords(List<ServiceTerritory> serviceTerritoryList, List<ServiceResource> serResources, String territoryType) {
        List<ServiceTerritoryMember> sTMList = new List<ServiceTerritoryMember>();    
        
        for(ServiceTerritory sT : serviceTerritoryList){         
            // The amount of ServiceTerritoryMember records will be equal to the amount of diferent ServiceResources, to avoid DUPLICATE_VALUE errors on the field ServiceResourceId
            for ( Integer i=0; i < serResources.size(); i++ ) {
                
                Integer num = Integer.valueOf(i);
                ServiceTerritoryMember sTM = new ServiceTerritoryMember(); 
                //  sTM.IsDeleted= false;
                //  sTM.MemberNumber= 'STM-0003';
                //  sTM.CreatedDate= ;
                //  sTM.CreatedById= ;
                //  sTM.LastModifiedDate= ;
                //  sTM.LastModifiedById= ;
                //   sTM.SystemModstamp= ;
                //  sTM.LastViewedDate= ;
                //  sTM.LastReferencedDate= ;
                sTM.ServiceTerritoryId= sT.Id; 
                sTM.ServiceResourceId= serResources[i].Id; 
                if(territoryType == 'M'){
                    if( Math.mod(num , 2) == 0){
                        sTM.TerritoryType= 'P';
                    } else {                   
                        sTM.TerritoryType= 'S';
                    }
                } else if( territoryType == 'S' || territoryType == 'P' ){
                    sTM.TerritoryType= territoryType;
                }        
                sTM.EffectiveStartDate=  System.now().addDays(-10);
                sTM.EffectiveEndDate=  System.now().addDays(-5);
                sTM.Street= null;
                sTM.City= null;
                sTM.State= null;
                sTM.PostalCode= null;
                sTM.Country= null;
                sTM.Latitude= null;
                sTM.Longitude= null;
                sTM.GeocodeAccuracy= null;
                sTM.OperatingHoursId= sT.OperatingHoursId; 
                sTM.TravelModeId= null;
                sTMList.add(sTM);
            }
        }
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.insert(sTMList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.createPrimaryServiceTerritoryMemberRecords() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }  
        return sTMList;
    }
    
    // SERVICE TERRITORY MEMBER'S EFFECTIVESTARTDATE AND EFFECTIVEENDDATE RAMDOMIZER
    public static  List<ServiceTerritoryMember> ramdomizeSTMDates(List<ServiceTerritoryMember> serviceTerritoryMembersList) { 
        
        List<ServiceTerritoryMember> sTMToUpdateList = new  List<ServiceTerritoryMember>(); 
        Integer min = 1;
        Integer max = 100;
        Integer higherNum;
        Integer lowerNum; 
        Integer ramdomMonth;
        
        for(ServiceTerritoryMember sTM : serviceTerritoryMembersList){
            ramdomMonth = Integer.valueOf(Math.floor(Math.random() * 12) + 1);
            Datetime dt = Datetime.newInstance(Datetime.now().year(), ramdomMonth, Datetime.now().day(), 00,00,00); 
            lowerNum =  Integer.valueOf(Math.floor(Math.random() * (max - min + 1)) + min);
            higherNum = Integer.valueOf(Math.floor(Math.random() * (max - lowerNum + 1)) + lowerNum);
            sTM.EffectiveStartDate = dt.addDays(lowerNum);
            sTM.EffectiveEndDate = dt.addDays(higherNum);
            sTMToUpdateList.add(sTM);  
        }
        
        // Perform the DML operation and capture the results
        Database.SaveResult[] saveResults = Database.update(sTMToUpdateList, false);
        List<Database.Error> failedRecordsErrors = new List<Database.Error>();
        
        for (Database.SaveResult saveResult : saveResults) {
            if (!saveResult.isSuccess()) {
                failedRecordsErrors.addAll(saveResult.getErrors());
                System.debug('TestDataFactory.ramdomizeSTMDates() - Failed Record Error:  ' + saveResult.getErrors()); 
            }
        }  
        return sTMToUpdateList;
    }  
}