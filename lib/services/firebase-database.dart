import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dtos/user-dto.dart';

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
}