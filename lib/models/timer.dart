import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeTracker {
  String uid;
  String title;
  String description;
  String owner;
  DateTime startTime;
  DateTime endTime;
  TimerState currentState;
  List<TimerLog> timerLogs;

  TimeTracker(bool start, this.owner) {
    this.timerLogs = List<TimerLog>();
    this.uid = Uuid().v4(); // v4 is a random guid

    if (start) {
      this.startTime = DateTime.now();
      this.currentState = TimerState.STARTED;
    } else {
      this.currentState = TimerState.NEVER_STARTED;
    }
  }

  TimeTracker.fromDocument(DocumentSnapshot snapshot) {
    this.uid = snapshot['uid'];
    this.title = snapshot['title'];
    this.description = snapshot['description'];
    this.owner = snapshot['owner'];
    this.startTime = snapshot['startTime'];
    this.endTime = snapshot['endTime'];
    this.currentState = TimerUtils.stringToState(snapshot['currentState']);
    
    if (snapshot['timerLogs'] != null) {
      this.timerLogs = List<TimerLog>();
      snapshot['timerLogs'].forEach((dynamic x) => this.timerLogs.add(TimerLog.fromDocumentArray(x)));
    } else {
      this.timerLogs = List<TimerLog>();
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
      this.currentState = TimerState.PAUSED;
      this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.PAUSED));
    }
  }

  void unpause({String description = ''}) {
    if (this.currentState == TimerState.PAUSED) {
      this.currentState = TimerState.STARTED;
      this.timerLogs.add(TimerLog(DateTime.now(), description, TimerState.STARTED));
    }
  }

  Duration getTotalActiveTime() {
   // TODO this will be done by combing through the specific timers TimerLogs
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'currentState': TimerUtils.stateToString(currentState),
      'owner': owner,
      'timerLogs': timerLogs.map((x) => x.toDocument()).toList()
    };
  }
}

class TimerLog {
  DateTime timestamp;
  TimerState state;
  String description;

  TimerLog(this.timestamp, this.description, this.state);

  TimerLog.fromDocument(DocumentSnapshot snapshot) {
    this.timestamp = snapshot['timestamp'];
    this.state = TimerUtils.stringToState(snapshot['state']);
    this.description = snapshot['description'];
  }

  TimerLog.fromDocumentArray(dynamic x) {
    this.timestamp = x['timestamp'];
    this.state = TimerUtils.stringToState(x['state']);
    this.description = x['description'];
  }

  Map<String, dynamic> toDocument() {
    return {
      'timestamp': timestamp,
      'state': TimerUtils.stateToString(state),
      'description': description
    };
  }
}

enum TimerState {
  NEVER_STARTED,
  STARTED,
  PAUSED,
  UNPAUSED,
  STOPPED
}

class TimerUtils {
  static String stateToString(TimerState t) {
    switch(t) {
      case TimerState.NEVER_STARTED:
        return 'NEVER_STARTED';
      case TimerState.STARTED:
        return 'STARTED';
      case TimerState.PAUSED:
        return 'PAUSED';
      case TimerState.UNPAUSED:
        return 'UNPAUSED';
      case TimerState.STOPPED:
        return 'STOPPED';
      default:
        return 'NEVER_STARTED';
    }
  }
   
  static TimerState stringToState(String t) {
    switch(t) {
      case 'NEVER_STARTED':
        return TimerState.NEVER_STARTED;
      case 'STARTED':
        return TimerState.STARTED;
      case 'PAUSED':
        return TimerState.PAUSED;
      case 'UNPAUSED':
        return TimerState.UNPAUSED;
      case 'STOPPED':
        return TimerState.STOPPED;
      default:
        return TimerState.NEVER_STARTED;
    }
  }
}