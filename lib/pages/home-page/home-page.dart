import 'dart:async';
import 'package:flutter/material.dart';

import '../login-page.dart';
import '../../services/authentication-service.dart';

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
  Choice _selectedChoice = popoutMenuOpts[0];

  _HomePage(this._auth);

  Future<void> _select(Choice c) async{
    setState(() async {
      _selectedChoice = c;
      if (c.title == 'Logout') {
        await this._auth.logout();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      // Navigator.push(context, route)
    });
  }

  void _toggleTimer() {

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
        onPressed: _toggleTimer,
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
  const Choice(title: 'Messaging', icon: Icons.message),
  const Choice(title: 'Logout', icon: Icons.power_settings_new),
];
