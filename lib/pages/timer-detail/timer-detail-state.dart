import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/timer.dart';
import '../../services/firebase-database.dart';

class TimerDetailState {
  String timerId;
  TimeTracker timer;
  final FirebaseDatabaseService _db = FirebaseDatabaseService();

  TimerDetailState(this.timerId) {
    this.timer = TimeTracker.empty();
    this._db.getTimerById(timerId).then((QuerySnapshot q) {
      if (q.documents.length == 1) {
        this.timer = TimeTracker.fromDocument(q.documents[0]);
      }
    });
  }

    String getTimerTitle() {
    if (this.timer.title != null) {
      return this.timer.title.isNotEmpty ? this.timer.title : 'None'; 
    } else {
      return 'None';
    }
  }

    String getDescription() {
    if (this.timer.description != null) {
      return this.timer.description.isNotEmpty ? this.timer.description : 'None'; 
    } else {
      return 'None';
    }
  }
}