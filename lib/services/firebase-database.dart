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

  Future<dynamic> createTimer(TimeTracker t) async {
    return await this._db.runTransaction((Transaction trans) async {
      CollectionReference timersRef = this._db.collection('timers');
      await timersRef.add(t.toDocument());
    });
  }

  Stream<QuerySnapshot> getUsersTimers(String uid) {
    return this._db.collection('timers').where('owner', isEqualTo: uid).snapshots();
  }
}