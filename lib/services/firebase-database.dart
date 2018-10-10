import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dtos/user-dto.dart';
import '../models/timer.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabaseService _singleton = new FirebaseDatabaseService._internal();
  Firestore _db;
  
  factory FirebaseDatabaseService() {
    return _singleton;
  }

  FirebaseDatabaseService._internal() {
    this._db = Firestore.instance;
  }

  Future<void> createUser(UserDto user) async {
    this._db.runTransaction((Transaction trans) async {
      CollectionReference ref = this._db.collection('users');
      await ref.add(user.toDocument());
    });
  }

  Future<void> createTimer(TimeTracker t) {
    this._db.runTransaction((Transaction trans) async {
      CollectionReference ref = this._db.collection('timers').where('uid', isEqualTo: t.owner);
      if (ref != null) {
        CollectionReference timerRef = this._db.collection('timers');
        await timerRef.add(t.toDocument());
      } 
    });
  }
}