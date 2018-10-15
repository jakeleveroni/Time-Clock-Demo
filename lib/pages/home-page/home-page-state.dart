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

  TimeTracker removeTimer(int timerIndex) => this.timers.removeAt(timerIndex);

  List<TimeTracker> getActiveTimers() => 
    this.timers.where((TimeTracker t) => t.currentState != TimerState.STOPPED).toList();

  List<TimeTracker> getPausedTimers() => 
    this.timers.where((TimeTracker t) => t.currentState == TimerState.PAUSED).toList();

  List<TimeTracker> getStoppedTimers() => 
    this.timers.where((TimeTracker t) => t.currentState == TimerState.STOPPED).toList();
}