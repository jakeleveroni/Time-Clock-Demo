import '../models/timer.dart';

class Utility {
  Utility();

  static String formatDateTime(DateTime time) {
    var weekday = capitalizeFirstWord(intWeekdayToString(time.weekday));
    var day = time.day;
    var monthString = Utility.intMonthToString(time.month);
    var hour = time.hour % 12;
    var meridiem = time.hour > 12 ? 'AM' : 'PM';
    var minutes = time.minute;
    
    return '$weekday $monthString $day, $hour:$minutes $meridiem';
  }

  static String formatTimerTitle(TimeTracker t) {  
    return '${t.title ?? 'Tap To Add Title'} - ${Utility.timeStateToString(t.currentState)}';
  }

  static String timeStateToString(TimerState state) {
    switch(state) {
      case TimerState.STARTED:
      case TimerState.UNPAUSED:
        return 'Tracking';
      case TimerState.STOPPED:
      case TimerState.NEVER_STARTED:
        return 'Not Tracking';
      case TimerState.PAUSED:
        return 'Paused';
      default: 
        return 'invalid state';
    }
  }

  static String capitalizeFirstWord(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  static String intWeekdayToString(int weekDayInt) {
    switch(weekDayInt) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Invalid Day';
    }
  }

  static String intMonthToString(int monthInt) {
    switch(monthInt) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown Month';
    }
  }
}