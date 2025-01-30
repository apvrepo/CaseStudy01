/* @Description  This ServiceTerritoryMemberHelper class holds the complex logic for the ServiceTerritoryMemberTriggerHandler.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Andres Pereyra      01/12/2024          Initial Creation - User Story: 'Assigment Salesforce Developer'                                                  
*******************************************************************************************/

public without sharing class ServiceTerritoryMemberHelper {
    
    public ServiceTerritoryMemberHelper() {
    }
    
    public void processServiceTerritoryMembers(List<ServiceTerritoryMember> serviceTerritoryMembersToProcess) {
        List<ServiceTerritoryMember> secondarySTMList = new List<ServiceTerritoryMember>();
        
        // Separate incoming ServiceTerritoryMember by TerritoryType
        for(ServiceTerritoryMember serTerMem : serviceTerritoryMembersToProcess){
            if(serTerMem.TerritoryType == 'S'){
                secondarySTMList.add(serTerMem);
            }
        }   
        
        // Validate if there are secondary ServiceTerritoryMember
        if(!secondarySTMList.isEmpty()){     
            Set<Id> serviceTerritoryIdSets = new Set<Id>();
            for(ServiceTerritoryMember secondarySTM : secondarySTMList){
                serviceTerritoryIdSets.add(secondarySTM.ServiceTerritoryId);
            }
            
            List<ServiceTerritoryMember> allPrimaryRelatedSTMList = [
                SELECT Id, MemberNumber, ServiceTerritoryId, ServiceResourceId, TerritoryType, EffectiveStartDate, EffectiveEndDate, OperatingHoursId 
                FROM ServiceTerritoryMember 
                WHERE ServiceTerritoryId IN :serviceTerritoryIdSets AND TerritoryType = 'P'
            ];
            
            Map<Id, List<ServiceTerritoryMember>> primarySTMMap = new Map<Id, List<ServiceTerritoryMember>>();
            for(ServiceTerritoryMember primarySTM : allPrimaryRelatedSTMList){
                if(!primarySTMMap.containsKey(primarySTM.ServiceTerritoryId)){
                    primarySTMMap.put(primarySTM.ServiceTerritoryId, new List<ServiceTerritoryMember>());
                }
                primarySTMMap.get(primarySTM.ServiceTerritoryId).add(primarySTM);
            }
            
            for(ServiceTerritoryMember secondarySTM : secondarySTMList){     
                List<ServiceTerritoryMember> onlyDirectlyRelatedPrimarySTMList = primarySTMMap.get(secondarySTM.ServiceTerritoryId);
                if(onlyDirectlyRelatedPrimarySTMList != null){
                    Boolean validation = validateDatesOfIndividualSecondarySTM(onlyDirectlyRelatedPrimarySTMList, secondarySTM);  
                    if(!validation){
                        System.debug('FLAG - ServiceTerritoryMemberHelper.validateDates() -  Validation Fail - Error');
                        secondarySTM.addError('Please check the Start and End dates for the Secondary Service Territory Member record. They must be within the dates of a Primary Service Territory Member');
                    }
                }
            }  
        }
    }
    
    // This method validates the Dates of a single secondary STM against each of the primary STM related by the same ServiceTerritoryId. 
    public Boolean validateDatesOfIndividualSecondarySTM (List<ServiceTerritoryMember> primaryRelatedSTM, ServiceTerritoryMember singleSecondarySTM) {
        for(ServiceTerritoryMember primarySTM : primaryRelatedSTM){
            if(singleSecondarySTM.EffectiveStartDate >= primarySTM.EffectiveStartDate && 
               (singleSecondarySTM.EffectiveEndDate <= primarySTM.EffectiveEndDate || primarySTM.EffectiveEndDate == null)){
                return true;
                break; // Stop the loop when the first match is found
            }  
        }
        return false;
    }
}