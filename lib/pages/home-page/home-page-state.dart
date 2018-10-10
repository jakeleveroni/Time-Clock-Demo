import '../../models/timer.dart';

class HomePageState {
  bool timerActive;
  List<TimeTracker> timers;

  HomePageState() {
    this.timers = new List<TimeTracker>();
  }

  void addTimer(TimeTracker t) {
    this.timers.add(t);
  }

  List<TimeTracker> getActiveTimers() {
    return this.timers.where((TimeTracker t) => t.currentState == TimerState.STARTED);
  }

  List<TimeTracker> getPausedTimers() {
    return this.timers.where((TimeTracker t) => t.currentState == TimerState.PAUSED);
  }

  List<TimeTracker> getStoppedTimers() {
    return this.timers.where((TimeTracker t) => t.currentState == TimerState.STOPPED);
  }
}