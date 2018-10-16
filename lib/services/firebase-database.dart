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

  Future<dynamic> createUser(UserDto user) async {
    return await this._db.runTransaction((Transaction trans) async {
      CollectionReference ref = this._db.collection('users');
      await ref.add(user.toDocument());
    });
  }

  Future<QuerySnapshot> getUser(String userId) async {
    return await this._db.collection('users').where('uid', isEqualTo: userId).snapshots().first;
  }

  Future<dynamic> createTimer(TimeTracker t) async {
    return await this._db.runTransaction((Transaction trans) async {
      CollectionReference timersRef = this._db.collection('timers');
      await timersRef.add(t.toDocument());
    });
  }

  Future<dynamic> deleteTimer(TimeTracker t) async {
    var query = await this._db.collection('timers').where('uid', isEqualTo: t.uid).snapshots().first;

    if (query.documents.length != 1) {
      print('Error removing timer, number of timers found: ${query.documents.length}');
      return null;
    }

    return await this._db.runTransaction((Transaction trans) async {
      return this._db.collection('timers').document(query.documents[0].documentID).delete();
    });
  }

  Future<dynamic> updateTimer(TimeTracker timer) async {
    QuerySnapshot q = await this._db.collection('timers').where('uid', isEqualTo: timer.uid).snapshots().first;

    if (q.documents.length == 1) {
      return await this._db.runTransaction((Transaction t) async {
        await this._db.document('timers/${q.documents[0].documentID}').updateData(timer.toDocument());
      });
    } else {
      print('Either too many or not enough documents referenced for update: ${q.documents.length}');
      return null;
    }
  }

  Stream<QuerySnapshot> getUsersTimers(String uid) {
    return this._db.collection('timers').where('owner', isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getUsersActiveTimers(String uid) {
    return this._db.collection('timers')
      .where('owner', isEqualTo: uid)
      .where('currentState', isEqualTo: 'STARTED')
      .where('currentState', isEqualTo: 'PAUSED')
      .where('currentState', isEqualTo: 'UNPAUSED')
      .snapshots();
  }

    Stream<QuerySnapshot> getUsersInactiveTimers(String uid) {
    return this._db.collection('timers')
      .where('owner', isEqualTo: uid)
      .where('currentState', isEqualTo: 'STOPPED')
      .snapshots();
  }

  Future<QuerySnapshot> getTimerById(String timerId) {
    return this._db.collection('timers').where('uid', isEqualTo: timerId).snapshots().first;
  }

  Future<dynamic> updateUser(UserDto user) async {
    QuerySnapshot q = await this._db.collection('users').where('uid', isEqualTo: user.uid).snapshots().first;

    if (q.documents.length == 1) {
      return await this._db.runTransaction((Transaction t) async {
        await this._db.document('users/${q.documents[0].documentID}').updateData(user.toDocument());
      });
    } else {
      print('Either too many or not enough documents referenced for update: ${q.documents.length}');
      return null;
    }
  }
}