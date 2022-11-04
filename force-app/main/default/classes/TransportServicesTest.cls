@IsTest

public with sharing class TransportServicesTest {

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
    static void createStopTest(){

        Test.startTest();

        TransportServices.createStop('test', 'adress');

        Test.stopTest();

        List<Bus_Stop__c> listStops =[SELECT ID FROM Bus_Stop__c WHERE Name = 'test'];

        system.assertEquals(1, listStops.size(), 'Do not create new stop');

    }

    @IsTest
    static void addStopToScheduleTest(){

        Bus_Route__c route1 = [SELECT ID FROM Bus_Route__c WHERE Name = 'route1'];

        Bus_Stop__c stop1 = [SELECT ID FROM Bus_Stop__c WHERE Name = 'stop1'];

        Test.startTest();

        TransportServices.addStopToSchedule(route1.Id, stop1.Id, Time.newInstance(8, 0, 0, 0));

        Test.stopTest();
        
        Time myTime =  Time.newInstance(8, 0, 0, 0);

        List<Schedule__c> listSch =[SELECT ID FROM Schedule__c WHERE Time__c =: myTime];

        system.assertEquals(1, listSch.size(), 'Do not create new schedule');

    }

    @IsTest
    static void updateScheduleTimesTest(){

        Schedule__c sch1 = [SELECT ID, Time__c FROM Schedule__c WHERE Name = 'sch1'];
        
        List<TransportServices.ScheduleTimeHelper> scheduleTimes = new List<TransportServices.ScheduleTimeHelper> ();
        
        TransportServices.ScheduleTimeHelper sth = new TransportServices.ScheduleTimeHelper(sch1.id, Time.newInstance(1, 3, 0, 0));
        
        scheduleTimes.add(sth);

        Test.startTest();

        TransportServices.updateScheduleTimes(scheduleTimes);

        Test.stopTest();

        Schedule__c newSch1 = [SELECT ID, Time__c FROM Schedule__c WHERE Name = 'sch1'];

        system.assertEquals(Time.newInstance(1, 3, 0, 0), newSch1.Time__c, 'Do not update time');

    }

    @IsTest
    static void deleteBusStopTest(){

        List<Bus_Stop__c> listStops = [SELECT ID FROM Bus_Stop__c];

        List<Schedule__c> listSch = [SELECT ID FROM Schedule__c];

        Bus_Stop__c stop1 = listStops.get(0);

        Test.startTest();

        TransportServices.deleteBusStop(stop1.id);

        Test.stopTest();

        List<Bus_Stop__c> newlistStops = [SELECT ID FROM Bus_Stop__c];

        List<Schedule__c> newlistSch = [SELECT ID FROM Schedule__c];

        //3
        system.assertEquals(2, newlistStops.size(), 'Do not DELETE stop');
        //5
        system.assertEquals(3, newlistSch.size(), 'Do not DELETE sch');

    }

}