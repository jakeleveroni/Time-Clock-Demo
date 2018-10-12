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
  bool _isStopDisabled;
  bool _isTogglePauseDisable;

  TimerListItemComponentState() {
    this._db = new FirebaseDatabaseService();
  }

  @override
  void initState() {
    super.initState();

    _isStopDisabled = _isTogglePauseDisable = (widget._timer.currentState == TimerState.STOPPED);

    // create animation controller 
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 1200),
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
              color: _timerIconColor(widget._timer)
            ),
            title: Text(Utility.formatTimerTitle(widget._timer)),
            subtitle: Text('Started ${Utility.formatDateTime(widget._timer.startTime)}'),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: const Text('Stop Timer'),
                  onPressed: _isStopDisabled 
                              ? null 
                              : () async =>  _stopTimer(widget._timer)
                ),
                new FlatButton(
                  child: Text(widget._timer.currentState == TimerState.PAUSED ? 'Resume Timer' : 'Pause Timer'),
                  onPressed: _isTogglePauseDisable 
                              ? null 
                              : () async => _togglePause(widget._timer)
                ) 
              ]
            )
          )
        ],
      ),
    );
  }

  Future<void> _togglePause(TimeTracker t, {String desc = ''}) async {
    if (t.currentState == TimerState.PAUSED) {
      await _resumeTimer(t, desc: desc);
    } else {
      await _pauseTimer(t, desc: desc);
    }
  }

  Color _timerIconColor(TimeTracker t) {
    if (t.currentState == TimerState.NEVER_STARTED || t.currentState == TimerState.STOPPED) {
      return Color.lerp(Colors.red[900], Colors.red[200], _controller.value);
    } else if (t.currentState == TimerState.PAUSED) {
      return Color.lerp(Colors.orange[700], Colors.orange[200], _controller.value);
    } else {
      return Color.lerp(Colors.green[700], Colors.green[200], _controller.value);
    }
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
    _isStopDisabled = _isTogglePauseDisable = true;
    setState(() {});
  }
}