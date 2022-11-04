public with sharing class RouteDescriptionBatch implements Database.Batchable<sObject>, Schedulable,  Database.Stateful {
    
    public Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT id, Route_Description__c, (SELECT Time__c, Bus_Stop__r.Address__c FROM Schedules__r ORDER BY Time__c ASC) FROM Bus_Route__c' 
        );
    }

    public void execute(Database.BatchableContext bc, list<Bus_Route__c> routesList){

        for (Bus_Route__c route: routesList){
            route.Route_Description__c = '';
            for (Schedule__c schedule : route.Schedules__r) {
                route.Route_Description__c = route.Route_Description__c + schedule.Bus_Stop__r.Address__c + ' - ';
            }
        }

        update routesList;

    }

    public void finish(Database.BatchableContext bc){}

    public void execute(SchedulableContext pr1){
        RouteDescriptionBatch routeDescription = new RouteDescriptionBatch();
        Id batchId = Database.executeBatch(routeDescription);
    }

}


//Database.executeBatch(new RouteDescriptionBatch(), 200);