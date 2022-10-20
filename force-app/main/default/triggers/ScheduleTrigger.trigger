trigger ScheduleTrigger on Schedule__c (before insert, before update, after insert, after update ) {

    //Start and End Times of the Bus Route should be based on the minimum and maximum values in the Time field of the Schedule.
    if (Trigger.isAfter) {

        if (Trigger.isUpdate || Trigger.isInsert) {
            ScheduleTriggerHandler.updateStartEndTime(Trigger.new, Trigger.oldMap);
            ScheduleTriggerHandler.setTimeToNextStop(Trigger.new, Trigger.oldMap);
        }
        
    }

    //Time To Next Stop should display the correct information.

}