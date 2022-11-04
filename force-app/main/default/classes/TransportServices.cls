public with sharing class TransportServices {

    public class ScheduleTimeHelper {
        public Id scheduleId{get;set;}
        public Time timeValue{get;set;}
        public ScheduleTimeHelper(Id schId, Time schTime) {
            this.scheduleId = schId;
            this.timeValue = schTime;
        }
    }

    
    public static void createStop(String name, String address) {

        Bus_Stop__c newBusStop = new Bus_Stop__c(Address__c = address, Name = name);

        try{

            insert newBusStop;
            System.debug(newBusStop);

        } catch (Dmlexception e) {

            System.debug(e);

        }

    }
    //TransportServices.createStop('TestStop2', 'Address');
    

    //create schedule record
    public static void addStopToSchedule(Id busRouteId, Id busStopId, Time timeValue) {

        Schedule__c newSchedule = new Schedule__c(Bus_Route__c = busRouteId, Bus_Stop__c = busStopId, Time__c = timeValue);

        try{
            insert newSchedule;
            System.debug(newSchedule);

        } catch (Dmlexception e) {

            System.debug(e);

        }

    }
    // Time myTime = Time.newInstance(1, 2, 3, 4);
    // TransportServices.addStopToSchedule('a007Q00000BHdypQAD', 'a017Q000019KEVCQA4', myTime);
    

    //update schedule with specific time
    public static void updateScheduleTimes(List<ScheduleTimeHelper> scheduleTimes) {

        List<Schedule__c> listSchedule = new List<Schedule__c>();

        for(ScheduleTimeHelper scheduleItem: scheduleTimes){
            Schedule__c newSchedule = new Schedule__c(Id = scheduleItem.scheduleId);
            newSchedule.Time__c = scheduleItem.timeValue;
            listSchedule.add(newSchedule);

        }

        try{
            update listSchedule;
            System.debug(listSchedule);

        } catch (Dmlexception e) {

            System.debug(e);

        }

    }
    // Time myTime = Time.newInstance(1, 2, 3, 4);
    // List<TransportServices.ScheduleTimeHelper> listUpdateTime = new List<TransportServices.ScheduleTimeHelper>();
    // listUpdateTime.add(new TransportServices.ScheduleTimeHelper('a027Q000003SUrdQAG', myTime));
    // TransportServices.updateScheduleTimes(listUpdateTime);

    //delete bus stop and all related schedules
    public static void deleteBusStop(Id busStopId) {

        Bus_Stop__c BusStop = new Bus_Stop__c(id = busStopId);
        List<Schedule__c> listSchedule = [Select id from Schedule__c where Bus_Stop__c=:busStopId];

        try{
            delete listSchedule;
            delete BusStop;
            System.debug('deleted');

        } catch (Dmlexception e) {

            System.debug(e);

        }

    }
    //TransportServices.deleteBusStop('a017Q00001AuulyQAB');

}