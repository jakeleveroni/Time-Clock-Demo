import 'package:flutter/material.dart';

import '../../models/timer.dart';

class HomePageDataTableSource extends DataTableSource {
  List<TimerDataRow> timers;
  int _selectedCount;

  HomePageDataTableSource(List<Timer> timers) {
    // TODO get timers from db
    this.timers = new List<TimerDataRow>();
    for (var t in timers) {
      this.timers.add(new TimerDataRow(t));
    }
  }

  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
      if (index >= this.timers.length) {
        return null;
      }

    final TimerDataRow timerData = this.timers[index];
    return DataRow.byIndex(
      index: index,
      selected: timerData.selected,
      onSelectChanged: (bool value) {
        if (timerData.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          timerData.selected = value;
          notifyListeners();
        }
      },
      cells: <DataCell>[
        DataCell(Text('${timerData.timer.title}')),
        DataCell(Text('${timerData.timer.description}')),
        DataCell(Text('${timerData.timer.startTime}')),
        DataCell(Text('${timerData.timer.pauseStartTime}')),
        DataCell(Text('${timerData.timer.endTime}')),
        DataCell(Text('${timerData.timer.getTotalActiveTime()}')),
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.timers.length;

  @override
  int get selectedRowCount => this._selectedCount;

}

class TimerDataRow {
  Timer timer;
  bool selected;

  TimerDataRow(this.timer) {
    selected = false;
  }
}