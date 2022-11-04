public with sharing class RelatedSchedulesByIdController {
    @AuraEnabled(cacheable=true)
    public static List<Schedule__c> getSchedules(Id stopId){
        return [SELECT Name, Name__c, Time__c, Time_To_Next_Stop__c FROM Schedule__c WHERE Bus_Stop__c=:stopId AND Time_To_Next_Stop__c <= 10]; 
    }
}