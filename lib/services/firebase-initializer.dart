import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static FirebaseApp _app;

  static Future<FirebaseApp> instance() async {
    if (_app != null) {
      return _app;
    } else {
    return await FirebaseApp.configure(
      name: 'LFMX-Time-Clock-Demo',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:263409862022:ios:d4fcf723eee4325b',
              databaseURL: 'https://lfmx-time-clock-demo.firebaseio.com',
              apiKey: 'AIzaSyCzQ9-c9QBBYKOJ8IhQZV6WnuXO6nzEa18'
            )
          : null,
      );
    }
  }
}