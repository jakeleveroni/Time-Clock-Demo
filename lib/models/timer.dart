import 'package:flutter/material.dart';

class TimeTracker {
  String uid;
  String title;
  String description;
  String owner;
  DateTime startTime;
  DateTime pauseStartTime;
  DateTime pauseStopTime;
  DateTime endTime;
  TimerState currentState;
  List<TimerLog> timerLogs;

  TimeTracker(bool start, String owner) {
    // init objects
    this.timerLogs = new List<TimerLog>();

    if (start) {
      startTime = DateTime.now();
      currentState = TimerState.STARTED;
    } else {
      currentState = TimerState.NEVER_STARTED;
    }
  }

  void start({String description = ''}) {
      if (this.currentState == TimerState.NEVER_STARTED) {
        this.startTime = DateTime.now();
        this.currentState = TimerState.STARTED;
        this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.STARTED));
      }  
  }

  void stop({String description = ''}) {
    if (this.currentState == TimerState.STARTED || this.currentState == TimerState.PAUSED) {
      this.endTime = DateTime.now(); 
      this.currentState = TimerState.STOPPED;
      this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.STOPPED));
    }
  }

  void pause({String description = ''}) {
    if (this.currentState == TimerState.STARTED) {
      this.pauseStartTime = DateTime.now();
      this.currentState = TimerState.PAUSED;
      this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.PAUSED));
    }
  }

  void unpause({String description = ''}) {
    if (this.currentState == TimerState.PAUSED) {
      this.pauseStopTime = DateTime.now();
      this.currentState = TimerState.STARTED;
      this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.STARTED));
    }
  }

  Duration getTotalActiveTime() {
    Duration pauseDuration;
    Duration offsetDifference;
    Duration offsetPauseDifference;

    if (this.pauseStartTime != null && this.pauseStopTime != null) {
      pauseDuration = this.pauseStartTime.difference(this.pauseStopTime);
    }

    var totalDuration = this.startTime.difference(this.endTime);

    // TODO check if the subtraction order is correct
    if (this.startTime.timeZoneName != this.endTime.timeZoneName) {
      offsetDifference = this.startTime.timeZoneOffset - this.endTime.timeZoneOffset;
    }

    if (this.pauseStartTime.timeZoneName != this.pauseStopTime.timeZoneName) {
      offsetPauseDifference = this.pauseStartTime.timeZoneOffset - this.pauseStopTime.timeZoneOffset;
    }

    // TODO incorporate timezone changes into the calculated duration returned
    
    return totalDuration - (pauseDuration ?? 0);
  }

  String _stateToString(TimerState t) {
    switch(t) {
      case TimerState.NEVER_STARTED:
        return 'NEVER_STARTED';
      case TimerState.STARTED:
        return 'STARTED';
      case TimerState.PAUSED:
        return 'PAUSED';
      case TimerState.STOPPED:
        return 'STOPPED';
      default:
        return 'NEVER_STARTED';
    }
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'startTime': startTime,
      'pauseStartTime': pauseStartTime,
      'pauseStopTime': pauseStopTime,
      'endTime': endTime,
      'currentState': _stateToString(currentState)
    };
  }
}

class TimerLog {
  DateTime timestamp;
  TimerState state;
  String description;

  TimerLog(this.timestamp, this.description, this.state);
}

enum TimerState {
  NEVER_STARTED,
  STARTED,
  PAUSED,
  STOPPED
}