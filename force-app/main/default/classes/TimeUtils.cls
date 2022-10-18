public with sharing class TimeUtils {

    public Time calculateMinimumTime (List<Time> timeList) {
        Time timeValue = timeList[0];

        for(Time t: timeList){
            if (t < timeValue) {
                timeValue = t;
            }
        }

        return timeValue;
    }

    public Time calculateMaximumTime (List<Time> timeList) {
        Time timeValue = timeList[0];
        for(Time t: timeList){
            if (t > timeValue) {
                timeValue = t;
            }
        }

        return timeValue;
    }

}

// Time myTime1 = Time.newInstance(1, 0, 0, 0);
// Time myTime2 = Time.newInstance(2, 0, 0, 0);
// Time myTime3 = Time.newInstance(3, 0, 0, 0);

// List<Time> listTime = new List<Time>();
// listTime.add(myTime1);
// listTime.add(myTime2);
// listTime.add(myTime3);

// TimeUtils test = new TimeUtils();
// System.debug(test.calculateMinimumTime(listTime));