import '../../models/timer.dart';

class HomePageState {
  bool timerActive;
  List<Timer> timers;

  void addTimer({bool startOnCreate = true}) {
    this.timers.add(new Timer(true));
  }

  List<Timer> getActiveTimers() {
    return this.timers.where((Timer t) => t.currentState == TimerState.STARTED);
  }

  List<Timer> getPausedTimers() {
    return this.timers.where((Timer t) => t.currentState == TimerState.PAUSED);
  }

  List<Timer> getStoppedTimers() {
    return this.timers.where((Timer t) => t.currentState == TimerState.STOPPED);
  }
}