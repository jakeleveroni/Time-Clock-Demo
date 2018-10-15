import 'package:flutter/material.dart';

import 'timer-detail-state.dart';
import '../../services/firebase-database.dart';

class TimerDetailPage extends StatefulWidget {
  TimerDetailState _state;

  TimerDetailPage(String timerId) {
    this._state = new TimerDetailState(timerId);
  }

  @override
  _TimerDetailPageState createState() => _TimerDetailPageState();
}

class _TimerDetailPageState extends State<TimerDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabaseService _db = FirebaseDatabaseService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Timer'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await this._db.updateTimer(widget._state.timer);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Changes Saved'),
                      duration: Duration(milliseconds: 2000),
                    )
                  );
                }
              }
            );
          }
        )],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.title),
              title: const Text('Timer Title'),
              subtitle: Text(widget._state.getTimerTitle()),
            ),
            new ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Description'),
              subtitle: Text(widget._state.getDescription()),
            ),
            const Divider(
              height: 1.0,
            ),
            new ListTile(
              leading: const Icon(Icons.title),
              title: new TextFormField(
                decoration: new InputDecoration(hintText: "Timer title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  } else {
                    widget._state.timer.title = value;
                  }
                }
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.description),
              title: new TextFormField(
                decoration: new InputDecoration(hintText: "Timer description"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  } else {
                    widget._state.timer.description = value;
                  }
                },
              ),
            ),  
          ],
        ),
      ),
    );
  }
}