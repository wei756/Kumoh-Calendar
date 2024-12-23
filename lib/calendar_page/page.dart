import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kumoh_calendar/calendar_page/date_item.dart';

import '../data/schedule_data.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;
  String _title = "0월";

  List<ScheduleData> _schedules = [];

  DateTime get _firstDateOfMonth {
    return DateTime(_currentYear, _currentMonth, 1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _title = "$_currentMonth월";

        // dummy data
        _schedules = List.generate(10, (index) {
          var startDate = DateTime(DateTime.now().year, DateTime.now().month,
              Random().nextInt(27) + 1);
          return ScheduleData(
            id: index + 1,
            name: '일정 ${index + 1}',
            userId: 1, // 0에서 99 사이의 랜덤 사용자 ID
            startDate: startDate,
            endDate: startDate,
            place: 'Place ${index + 1}',
            memo: 'Memo for schedule ${index + 1}',
            participants: List.generate(
                Random().nextInt(5) + 1, (_) => Random().nextInt(100)),
          );
        });
      });
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentYear++;
        _currentMonth = 1;
      } else {
        _currentMonth++;
      }
      _title = "$_currentMonth월";
    });
  }

  void _prevMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentYear--;
        _currentMonth = 12;
      } else {
        _currentMonth--;
      }
      _title = "$_currentMonth월";
    });
  }

  @override
  Widget build(BuildContext context) {
    var datesOfMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    // 표시되여할 주 길이
    var weekLength = (datesOfMonth + _firstDateOfMonth.weekday - 1) ~/ 7 + 1;
    // date list of a week
    var month = List<List<Widget>>.generate(
        weekLength,
        (week) => List<Widget>.generate(7, (index) {
              var dateTime = _firstDateOfMonth
                  .subtract(Duration(days: _firstDateOfMonth.weekday))
                  .add(Duration(days: week * 7 + index));
              return Expanded(
                  child: DateItemWidget(
                key: ValueKey(dateTime),
                date: dateTime,
                isCurrentMonth: dateTime.month == _currentMonth,
                schedules: [
                  for (var schedule in _schedules)
                    if (schedule.startDate.day == dateTime.day &&
                        schedule.startDate.month == dateTime.month &&
                        schedule.startDate.year == dateTime.year)
                      schedule
                ],
              ));
            }));

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            onPressed: _prevMonth,
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: Column(children: [
        Row(
          children: ['일', '월', '화', '수', '목', '금', '토']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ))
              .toList(),
        ),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  child: Column(
                children: month
                    .map((week) => Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: week,
                        )))
                    .toList(),
              ))
            ]))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue, // 버튼 배경색
        child: const Icon(Icons.add), // 버튼 아이콘
      ),
    );
  }
}
