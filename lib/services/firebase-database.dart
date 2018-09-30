import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase-initializer.dart';

class FirebaseDatabase {
  static final FirebaseDatabase _singleton = new FirebaseDatabase._internal();

  factory FirebaseDatabase() {
    return _singleton;
  }

  FirebaseDatabase._internal();

  Future<FirebaseApp> _getApp() async {
    return await FirebaseInitializer.instance();
  }
}