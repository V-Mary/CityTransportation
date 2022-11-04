public with sharing class ScheduleTriggerHandler {

    @TestVisible
    private static Set<Id> getBusRouteId(List<Schedule__c> newSch, Map<Id, Schedule__c> oldMap){

        Set<Id> idsSet = new Set<Id>();

        if (oldMap == null) {
            //insert new sch
            for(Schedule__c schedule : newSch){
                idsSet.add(schedule.Bus_Route__c);
            }
            
        }else{
            //update time or bus route in sch
            for (Schedule__c sch : newSch) {
                if (sch.Time__c != oldMap.get(sch.Id).Time__c || sch.Bus_Route__c != oldMap.get(sch.Id).Bus_Route__c) {
                    idsSet.add(sch.Bus_Route__c);
                    idsSet.add(oldMap.get(sch.Id).Bus_Route__c);
                }
            }
        }

        return idsSet;

    }
    //Start and End Times of the Bus Route should be based on the minimum and maximum values in the Time field of the Schedule.
    //after Insert update sch
    public static void updateStartEndTime(List<Schedule__c> newSchedules, Map<Id, Schedule__c> oldSchedulesMap){

        Set<Id> idsSet = getBusRouteId(newSchedules, oldSchedulesMap);

        List <Bus_Route__c> busRouteList = [SELECT Start_Time__c, End_Time__c, 
                (SELECT Time__c FROM Schedules__r ORDER BY Time__c ASC) 
                FROM Bus_Route__c WHERE Id IN: idsSet];

        for (Bus_Route__c br : busRouteList) {
            If (!br.Schedules__r.isEmpty()) {
                br.Start_Time__c = br.Schedules__r.get(0).Time__c;
                br.End_Time__c = br.Schedules__r.get(br.Schedules__r.size()-1).Time__c;
            }
        }
            
        update busRouteList;

    }

    // автоматично прокалькулювати TimeToNextStop__c коли змінився розклад
    public static void setTimeToNextStop(List<Schedule__c> newSchedules, Map<Id, Schedule__c> oldSchedulesMap) {

        Set<Id> idsSet = getBusRouteId(newSchedules, oldSchedulesMap);

        List<Bus_Route__c> busRouteList = [
                SELECT Start_Time__c, End_Time__c, 
                (SELECT Time__c, Time_To_Next_Stop__c FROM Schedules__r ORDER BY Time__c ASC) 
                FROM Bus_Route__c 
                WHERE Id 
                IN: idsSet];

        List<Schedule__c> schedtoUpdate = new List<Schedule__c>();

        for (Bus_Route__c br : busRouteList) {
            for ( Integer i = 0; i <  br.Schedules__r.size(); i++ ) {
                //остання зупинки, де час до наступної = 0
                if (i == (br.Schedules__r.size() - 1)) {
                    br.Schedules__r.get(i).Time_To_Next_Stop__c = 0;
                }else{
                    br.Schedules__r.get(i).Time_To_Next_Stop__c =
                     (br.Schedules__r.get(i+1).Time__c.hour() - br.Schedules__r.get(i).Time__c.hour())*60 + (br.Schedules__r.get(i+1).Time__c.minute() - br.Schedules__r.get(i).Time__c.minute());
                }
            schedtoUpdate.add(br.Schedules__r.get(i));
        }

        update schedtoUpdate;

    }
}

}