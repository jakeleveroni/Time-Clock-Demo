import 'package:flutter/material.dart';

import '../models/timer.dart';

class TimerListItemComponent extends StatefulWidget {
  final TimeTracker _timer;

  TimerListItemComponent(this._timer);
  TimerListItemComponentState createState() => TimerListItemComponentState();
}

class TimerListItemComponentState extends State<TimerListItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(widget._timer.title ?? 'Untitled'),
            subtitle: Text('Started ${widget._timer.startTime}'),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                new FlatButton(
                  child: Text(widget._timer.currentState == TimerState.PAUSED ? 'Resume Timer' : 'PauseTimer'),
                  onPressed: () {
                    if (widget._timer.currentState == TimerState.PAUSED) {
                      _resumeTimer(widget._timer);
                    } else {
                      _pauseTimer(widget._timer);
                    }
                  }
                ),
                new FlatButton(
                  child: const Text('Stop Timer'),
                  onPressed: () => _stopTimer(widget._timer)
                ),
              ]
            )
          )
        ],
      ),
    );
  }

  void _pauseTimer(TimeTracker t) {
    print(t.toDocument());
  }

  void _resumeTimer(TimeTracker t) {
    print('resume timer ${t.toDocument()}');
  }

  void _stopTimer(TimeTracker t) {
    print('stop timer ${t.toDocument()}');
  }
}