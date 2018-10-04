import 'package:flutter/material.dart';
import 'pages/login-page.dart';

import './services/firebase-initializer.dart';

void main() async {
  await FirebaseInitializer.instance();
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'LFMX Time Tracker',
      theme: new ThemeData(
        // This is the theme of your application.
        primaryColor: Colors.pink,
        accentColor: Colors.pinkAccent,
        brightness: Brightness.dark,
      ),
      home: new LoginPage(title: 'LFMX Login'),
    );
  }
}
