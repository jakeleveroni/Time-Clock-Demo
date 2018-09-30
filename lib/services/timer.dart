class Timer {
  Timer(bool start) {
    if (start) {
      startTime = DateTime.now();
      currentState = TimerState.STARTED;
    } else {
      currentState = TimerState.NEVER_STARTED;
    }
  }

  DateTime startTime;
  DateTime pauseStartTime;
  DateTime pauseStopTime;
  DateTime endTime;
  TimerState currentState;

  void start() {
      if (this.currentState == TimerState.NEVER_STARTED) {
        this.startTime = DateTime.now();
        this.currentState = TimerState.STARTED;
      }  
  }

  void stop() {
    if (this.currentState == TimerState.STARTED) {
      this.endTime = DateTime.now(); 
      this.currentState = TimerState.STOPPED;
    } else if (this.currentState == TimerState.PAUSED) {
      this.endTime = DateTime.now();
      this.currentState = TimerState.STOPPED;
    }
  }

  void pause() {
    if (this.currentState == TimerState.STARTED) {
      this.pauseStartTime = DateTime.now();
      this.currentState = TimerState.PAUSED;
    }
  }

  void unpause() {
    if (this.currentState == TimerState.PAUSED) {
      this.pauseStopTime = DateTime.now();
      this.currentState = TimerState.STARTED;
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
}

enum TimerState {
  NEVER_STARTED,
  STARTED,
  PAUSED,
  STOPPED
}