import 'package:flutter/material.dart';
import 'dart:async';

import '../models/timer.dart';
import '../services/utility.dart';
import '../services/firebase-database.dart';

class TimerListItemComponent extends StatefulWidget {
  final TimeTracker _timer;

  TimerListItemComponent(this._timer);
  TimerListItemComponentState createState() => TimerListItemComponentState();
}

class TimerListItemComponentState extends State<TimerListItemComponent>
  with SingleTickerProviderStateMixin {
  AnimationController _controller;
  FirebaseDatabaseService _db;
  Utility _util;

  TimerListItemComponentState() {
    this._db = new FirebaseDatabaseService();
    this._util = new Utility();
  }

  @override
  void initState() {
    super.initState();

    // create animation controller 
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this
    )
    ..addListener(() {
      this.setState(() {});
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // start the contoller and repeat it
    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: Color.lerp(Colors.pinkAccent, Colors.white30, _controller.value),
            ),
            title: Text(Utility.formatTimerTitle(widget._timer)),
            subtitle: Text('Started ${Utility.formatDateTime(widget._timer.startTime)}'),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text('Stop Timer'),
                  onPressed: () => _stopTimer(widget._timer)
                ),
                new FlatButton(
                  child: Text(widget._timer.currentState == TimerState.PAUSED ? 'Resume Timer' : 'Pause Timer'),
                  onPressed: () {
                    if (widget._timer.currentState == TimerState.PAUSED) {
                      _resumeTimer(widget._timer);
                    } else {
                      _pauseTimer(widget._timer);
                    }
                  }
                ) 
              ]
            )
          )
        ],
      ),
    );
  }

  Future<void> _pauseTimer(TimeTracker timer, {String desc = ''}) async {
    timer.pause();
    await this._db.updateTimer(timer);
    setState(() {});
  }

  Future<void> _resumeTimer(TimeTracker timer, {String desc = ''}) async {
    timer.unpause();
    await this._db.updateTimer(timer);
    setState(() {});
  }

  Future<void> _stopTimer(TimeTracker timer, {String desc = ''}) async {
    timer.stop();
    await this._db.updateTimer(timer);
    setState(() {});
  }
}