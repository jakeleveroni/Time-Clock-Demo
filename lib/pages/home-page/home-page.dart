import 'dart:async';
import 'package:flutter/material.dart';

import '../login-page.dart';
import '../account-page/account-page.dart';
import '../../models/timer.dart';
import './home-page-state.dart';
import '../../components/timer-list-item-component.dart';
import '../../services/authentication-service.dart';
import '../../services/firebase-database.dart';

class HomePage extends StatefulWidget {
  final AuthenticationService _auth = new AuthenticationService();
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

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
      setState(() {});
    });

  }

  Future<void> _select(Choice c) async{
      _selectedChoice = c;
      if (_selectedChoice.title == 'Logout') {
        await this._auth.logout();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else if (_selectedChoice.title == 'My Profile') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
      }

      setState(() {});
  }

  Future<void> _startNewTimer() async {
    var user = this._auth.currentUser;

    if (user != null) {
      var t = TimeTracker(true, user.uid);
      this._state.addTimer(t);
      await this._db.createTimer(t);
    }
  }

  Future<dynamic> _deleteTimer(int timerIndex) async {
    if (this._auth.currentUser != null) {
      TimeTracker removedTracker = this._state.removeTimer(timerIndex);
      return await this._db.deleteTimer(removedTracker);
    } else {
      return false;
     }  
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            'LFMX Timer App', 
            style: new TextStyle(
              color: Colors.grey[850],
            ),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Active Timers'),
              Tab(text: 'Finished Timers')
            ],
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
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => _buildTimerList(true, context, index),
                    itemCount: this._state.getActiveTimers().length,
                    padding: new EdgeInsets.symmetric(vertical: 45.0)
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => _buildTimerList(false, context, index),
                    itemCount: this._state.getStoppedTimers().length,
                    padding: new EdgeInsets.symmetric(vertical: 45.0)
                  ),
                ),
              ],
            )
          ]
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _startNewTimer,
          foregroundColor: Colors.grey[850],
          tooltip: 'Start New Timer',
          child: new Icon(Icons.alarm_add),
        ), 
      )
    ); 
  }

  Dismissible _buildTimerList(bool activeTimers, BuildContext context, int index) {
    List<TimeTracker> filteredTimers = (activeTimers) 
      ? this._state.getActiveTimers()
      : this._state.getStoppedTimers();

    if (filteredTimers.length == 0) {
      return null;
    }

    var timer = filteredTimers[index];

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.symmetric(
          vertical: 25.0
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0)
          )
        ),
        child: Align(
          child: Text('Delete Timer')
        ),
      ),
      key: Key(timer.uid),
      onDismissed: (direction) async {
        // remove from firebase
        await this._deleteTimer(index);
        setState(() {});

        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.grey[700],
            duration: const Duration(milliseconds: 2000),
            content: Text('Timer Removed', )
          )
        );
      },
      child: TimerListItemComponent(timer),
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
