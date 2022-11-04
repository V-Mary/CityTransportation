public with sharing class BusRoutesViewController {
    @AuraEnabled
    public static List<Bus_Route__c> getBusRoutes(){
        return [SELECT Name, Route_Number__c, Start_Time__c, End_Time__c, Duration_In_Minutes__c, Total_Stops__c  FROM Bus_Route__c];
    }
}