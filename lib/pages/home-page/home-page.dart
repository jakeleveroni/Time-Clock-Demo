import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  Choice _selectedChoice = popoutMenuOpts[0];

  void _select(Choice c) {
    setState(() {
      _selectedChoice = c;
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
