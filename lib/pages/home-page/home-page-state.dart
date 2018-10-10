import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/timer.dart';

class HomePageState {
  bool timerActive;
  Stream<QuerySnapshot> timerStream;
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