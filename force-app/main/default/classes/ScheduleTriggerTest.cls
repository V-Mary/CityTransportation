@IsTest

public with sharing class ScheduleTriggerTest {

    @TestSetup
    static void makeData(){
        Bus_Route__c route1 = new Bus_Route__c(Name = 'route1', Start_Time__c = Time.newInstance(1, 0, 0, 0), End_Time__c = Time.newInstance(3, 0, 0, 0));
        Bus_Route__c route2 = new Bus_Route__c(Name = 'route2', Start_Time__c= Time.newInstance(2, 0, 0, 0), End_Time__c = Time.newInstance(6, 0, 0, 0));
        insert route1;
        insert route2;


        Bus_Stop__c stop1 = new Bus_Stop__c(Name = 'stop1');
        Bus_Stop__c stop2 = new Bus_Stop__c(Name = 'stop2');
        Bus_Stop__c stop3 = new Bus_Stop__c(Name = 'stop3');
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
    static void updateStartEndTimeTest(){

        Schedule__c sch = [SELECT id FROM Schedule__c where name = 'sch1'];

        Time newTime = Time.newInstance(2, 0, 0, 0);

        sch.Time__c = newTime;

        Test.startTest();

        update sch;

        Test.stopTest();

        Bus_Route__c route1 = [SELECT Start_Time__c from Bus_Route__c where name = 'route1'];

        system.assertEquals(newTime, route1.Start_Time__c, 'Do not update time in route');

    }

    @IsTest
    static void setTimeToNextStopTest(){

        Schedule__c sch = [SELECT id FROM Schedule__c where name = 'sch1'];

        Time newTime = Time.newInstance(2, 0, 0, 0);

        sch.Time__c = newTime;

        Test.startTest();

        update sch;

        Test.stopTest();

        Schedule__c updateSch = [SELECT Time_To_Next_Stop__c FROM Schedule__c where name = 'sch1'];

        system.assertEquals(60, updateSch.Time_To_Next_Stop__c, 'Do not update time in sch');

    }

}