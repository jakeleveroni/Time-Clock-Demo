import 'dart:async';
import 'package:flutter/material.dart';

import '../login-page.dart';
import '../../models/timer.dart';
import './home-page-state.dart';
import '../../services/authentication-service.dart';
import '../../services/firebase-database.dart';

class HomePage extends StatefulWidget {
  AuthenticationService _auth;
  final String title;

  HomePage({Key key, this.title}) : super(key: key) {
    this._auth = new AuthenticationService();
  }


  @override
  _HomePage createState() => new _HomePage(_auth);
}

class _HomePage extends State<HomePage> {
  AuthenticationService _auth;
  FirebaseDatabaseService _db;
  Choice _selectedChoice = popoutMenuOpts[0];
  HomePageState _state;

  _HomePage(this._auth) {
    this._state = new HomePageState();
    this._db = new FirebaseDatabaseService();
    this._auth = new AuthenticationService();

    // Initialize the views state with database information
    this._state.timerStream = this._db.getUsersTimers(this._auth.currentUser.uid);
    this._state.timerStream.listen((data) {
      this._state.timers = data.documents.map((x) => TimeTracker.fromDocument(x)).toList();
    });
  }

  Future<void> _select(Choice c) async{
    setState(() async {
      _selectedChoice = c;
      if (_selectedChoice.title == 'Logout') {
        await this._auth.logout();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  void _toggleTimer(TimeTracker t) {
    // TODO
  }

  void _debug() {
    print('States timers: ${this._state.timers.length}');
  }

  Future<void> _startNewTimer() async {
    var user = this._auth.currentUser;

    if (user != null) {
      var t = TimeTracker(true, user.uid);
      this._state.addTimer(t);
      await this._db.createTimer(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'LFMX Timer App', 
          style: new TextStyle(
            color: Colors.grey[850],
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _select,
            icon: Icon(
              Icons.more_vert, 
              color: Colors.grey[850]
            ),
            itemBuilder: (BuildContext context) {
              return popoutMenuOpts.map((Choice c) {
                return PopupMenuItem<Choice>(
                    value: c,
                    child: Text(c.title),
                  );
              }).toList();
            })
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Welcome Back',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _startNewTimer,
        foregroundColor: Colors.grey[850],
        tooltip: 'Start New Timer',
        child: new Icon(Icons.alarm_add),
      ), 
    );
  }
}

// Helper Classes
class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> popoutMenuOpts = const <Choice>[
  const Choice(title: 'My Profile', icon: Icons.person),
  const Choice(title: 'Messaging', icon: Icons.message),
  const Choice(title: 'Logout', icon: Icons.power_settings_new),
];
