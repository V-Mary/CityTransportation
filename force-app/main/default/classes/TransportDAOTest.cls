@IsTest

public with sharing class TransportDAOTest {

    @TestSetup
    static void makeData(){
        Bus_Route__c route1 = new Bus_Route__c(Name = 'route1', Start_Time__c = Time.newInstance(1, 0, 0, 0), End_Time__c = Time.newInstance(3, 0, 0, 0));
        Bus_Route__c route2 = new Bus_Route__c(Name = 'route2', Start_Time__c= Time.newInstance(2, 0, 0, 0), End_Time__c = Time.newInstance(6, 0, 0, 0));
        insert route1;
        insert route2;


        Bus_Stop__c stop1 = new Bus_Stop__c(Name = 'stop1');
        Bus_Stop__c stop2 = new Bus_Stop__c(Name = 'stop2');
        Bus_Stop__c stop3 = new Bus_Stop__c(Name = 'stop2');
        insert stop1;
        insert stop2;
        insert stop3;

        Schedule__c sch1r1 = new Schedule__c(Bus_Route__c = route1.Id, Bus_Stop__c = stop1.Id, Name = 'sch1', Time__c = Time.newInstance(1, 0, 0, 0));
        Schedule__c sch2r1 = new Schedule__c(Bus_Route__c = route1.Id, Bus_Stop__c = stop2.Id, Name = 'sch2', Time__c = Time.newInstance(3, 0, 0, 0));
        Schedule__c sch3r2 = new Schedule__c(Bus_Route__c = route2.Id, Bus_Stop__c = stop1.Id, Name = 'sch3', Time__c = Time.newInstance(2, 0, 0, 0));
        Schedule__c sch4r2 = new Schedule__c(Bus_Route__c = route2.Id, Bus_Stop__c = stop2.Id, Name = 'sch4', Time__c = Time.newInstance(4, 0, 0, 0));
        Schedule__c sch5r2 = new Schedule__c(Bus_Route__c = route2.Id, Bus_Stop__c = stop3.Id, Name = 'sch5', Time__c = Time.newInstance(6, 0, 0, 0));
        insert sch1r1;
        insert sch2r1;
        insert sch3r2;
        insert sch4r2;
        insert sch5r2;
    }

    @IsTest
    static void getNumberOfStopsTest(){

        Bus_Route__c route = [SELECT Id, Total_Stops__c FROM Bus_Route__c WHERE Name = 'route1' LIMIT 1];
        
        Test.startTest();

        Integer numStops = TransportDAO.getNumberOfStops(route.Id);

        Test.stopTest();

        system.assertEquals(2, numStops, 'No valid number of stops');

    }

    @IsTest
    static void getLongestByTimeRouteIdTest(){

        Bus_Route__c route = [SELECT Id FROM Bus_Route__c WHERE Name = 'route2' LIMIT 1];
        
        Test.startTest();

        Id longestRoud = TransportDAO.getLongestByTimeRouteId();

        Test.stopTest();

        system.assertEquals(route.Id, longestRoud, 'Do not find longest route');

    }

    @IsTest
    static void getSchedulesTest(){
        
        Test.startTest();

        List<Schedule__c> schList = TransportDAO.getSchedules(3, 2);

        Test.stopTest();

        system.assertEquals(3, schList.size(), 'No valid list of schedules');
        system.assertEquals('sch3', schList.get(0).Name, 'No valid number of stops');

    }

    @IsTest
    static void getBusStopsByIdsTest(){

        Set<Id> setIds = new Set<Id>();

        for (Bus_Stop__c stop : [SELECT Id FROM Bus_Stop__c]) {
            setIds.add(stop.Id);
        }
        
        Test.startTest();

        List<Bus_Stop__c> stopList = TransportDAO.getBusStopsByIds(setIds);

        Test.stopTest();

        system.assertEquals(3, stopList.size(), 'Do not find list of Stops');

    }

    @IsTest
    static void getBusRoutesTest(){

        Set<Id> setIds = new Set<Id>();

        for (Bus_Stop__c stop : [SELECT Id FROM Bus_Stop__c]) {
            setIds.add(stop.Id);
        }
        
        Test.startTest();

        List<Bus_Route__c> routeList = TransportDAO.getBusRoutes(setIds);

        Test.stopTest();

        system.assertEquals(2, routeList.size(), 'Do not find routes by stop id');

    }

    @IsTest
    static void getBusRoutesWithMinDurationTest(){

        Bus_Route__c route = [SELECT Id FROM Bus_Route__c WHERE name = 'route1'];
        
        Test.startTest();

        Map<Id, Integer> routeTimeMap = TransportDAO.getBusRoutesWithMinDuration(2);

        Test.stopTest();

        system.assertEquals(120, routeTimeMap.get(route.Id), 'Do not routes by stop id');

    }

    @IsTest
    static void getBusRoutesWithMaxDurationTest(){

        Bus_Route__c route = [SELECT Id FROM Bus_Route__c WHERE name = 'route2'];
        
        Test.startTest();

        Map<Id, Integer> routeTimeMap = TransportDAO.getBusRoutesWithMaxDuration(2);

        Test.stopTest();

        system.assertEquals(240, routeTimeMap.get(route.Id), 'Do not routes by stop id');

    }

}