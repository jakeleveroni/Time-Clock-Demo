import 'package:flutter/material.dart';
import 'dart:async';

import '../models/timer.dart';
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

  TimerListItemComponentState() {
    this._db = new FirebaseDatabaseService();
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
            title: Text(this._formatTimerTitle(widget._timer)),
            subtitle: Text('Started ${this._formatDateTime(widget._timer.startTime)}'),
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

  String _formatDateTime(DateTime time) {
    var weekday = capitalizeFirstWord(_intWeekdayToString(time.weekday));
    var day = time.day;
    var monthString = this._intMonthToString(time.month);
    var hour = time.hour % 12;
    var meridiem = time.hour > 12 ? 'AM' : 'PM';
    var minutes = time.minute;
    
    return '$weekday $monthString $day, $hour:$minutes $meridiem';
  }

  String _formatTimerTitle(TimeTracker t) {  
    return '${t.title ?? 'Tap To Add Title'} - ${this._timeStateToString(t.currentState)}';
  }

  String _timeStateToString(TimerState state) {
    switch(state) {
      case TimerState.STARTED:
      case TimerState.UNPAUSED:
        return 'Tracking';
      case TimerState.STOPPED:
      case TimerState.NEVER_STARTED:
        return 'Not Tracking';
      case TimerState.PAUSED:
        return 'Paused';
      default: 
        return 'invalid state';
    }
  }

  String capitalizeFirstWord(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String _intWeekdayToString(int weekDayInt) {
    switch(weekDayInt) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Invalid Day';
    }
  }

  String _intMonthToString(int monthInt) {
    switch(monthInt) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown Month';
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
    setState(() {});
  }
}