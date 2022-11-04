public with sharing class TransportDAO {
    
    //Get number of bus stops by bus route Id
   public static Integer getNumberOfStops(Id busRouteId) {

       Bus_Route__c route = [SELECT Total_Stops__c FROM Bus_Route__c WHERE Id =: busRouteId];

       return Integer.valueOf(route.Total_Stops__c);

   }
    //System.debug(TransportDAO.getNumberOfStops('a007Q00000BHdypQAD'));

    //Get Id of longest by time route
    public static Id getLongestByTimeRouteId() {

        List<Bus_Route__c> listRoutes = [SELECT Id FROM Bus_Route__c ORDER BY Duration_In_Minutes__c DESC LIMIT 1];

        Bus_Route__c route = listRoutes.get(0);

        return  route.Id;
        
    }
    //System.debug(TransportDAO.getLongestByTimeRouteId());

     //Get list of bus schedtules
    public static List<Schedule__c> getSchedules(Integer limitNumber, Integer offsetNumber) {

        List<Schedule__c> listSchedule = new List<Schedule__c>();

        if ((offsetNumber > 0)&&(limitNumber > offsetNumber)) {
            listSchedule = [SELECT Name FROM Schedule__c LIMIT :limitNumber OFFSET :offsetNumber];
        } else {
            System.debug('Invalid parameters');
        }
       
        return listSchedule;

    }
   // System.debug(TransportDAO.getSchedules(3, 1));


    public static List<Bus_Stop__c> getBusStopsByIds(Set<Id> busStops) {
        //Get list of bus stops by bus stop Ids
       // List<Bus_Stop__c> listStops = [SELECT Name FROM Bus_Stop__c WHERE Id IN: busStops];
        
        return [SELECT Name FROM Bus_Stop__c WHERE Id IN: busStops];
    }
    // Set<Id> s1 = new Set<Id>();
    // s1.add('a017Q000019IilYQAS');
    // s1.add('a017Q000019Jin4QAC');
    // System.debug(TransportDAO.getBusStopsByIds(s1));

   public static List<Bus_Route__c> getBusRoutes (Set<Id> busStops) {
        //Get list of bus routes for specified set of bus stops
     //   List<Bus_Stop__c> listStops = [SELECT Bus_Route__c FROM Bus_Stop__c WHERE Id IN: busStops];

        Set<Id> setRoutes = new Set<Id>();

        for (Schedule__c i : [SELECT Bus_Route__c FROM Schedule__c WHERE 	Bus_Stop__c IN: busStops]) {

            setRoutes.add(i.Bus_Route__c);
            
        }

       // List<Bus_Route__c> listRoutes = [SELECT Name__c FROM Bus_Route__c WHERE Id IN: setRoutes];

       return [SELECT Name__c FROM Bus_Route__c WHERE Id IN: setRoutes];
   }

    public static Map<Id, Integer> getBusRoutesWithMinDuration(Integer limitNumber) {
        //Returns map of bus route to duration. Parameter limit specifies number of shortest routes which should be returned

        Map<Id, Integer> routeTime = new Map<Id, Integer>();

        for (Bus_Route__c item : [SELECT Id, Duration_In_Minutes__c FROM Bus_Route__c ORDER BY Duration_In_Minutes__c ASC LIMIT :limitNumber ]) {
            routeTime.put(item.Id, Integer.valueOf(item.Duration_In_Minutes__c));
        }

        return routeTime;
    }

   //System.debug(TransportDAO.getBusRoutesWithMinDuration(1));


    public static Map<Id, Integer> getBusRoutesWithMaxDuration(Integer limitNumber) {
        //  Returns map of bus route to duration. Parameter limit specifies number of longest routes which should be returned

        Map<Id, Integer> routeTime = new Map<Id, Integer>();

        for (Bus_Route__c i : [SELECT Id, Duration_In_Minutes__c FROM Bus_Route__c ORDER BY Duration_In_Minutes__c DESC LIMIT :limitNumber ]) {
            routeTime.put(i.Id, Integer.valueOf(i.Duration_In_Minutes__c));
        }

        return routeTime;
    }

    //System.debug(TransportDAO.getBusRoutesWithMaxDuration(1));
}