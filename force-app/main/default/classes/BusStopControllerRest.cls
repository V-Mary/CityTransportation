@RestResource(urlMapping='/Routes/*')
global with sharing class BusStopControllerRest {

    @httpGet
    global static List<Bus_Route__c> getRecords() {
        return [SELECT 	Name, Total_Stops__c FROM Bus_Route__c ORDER BY Total_Stops__c desc LIMIT 5];
    }

}
