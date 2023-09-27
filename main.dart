import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'parent_days.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parenting Holiday App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ParentingCalendar(),
    );
  }
}

class ParentingCalendar extends StatefulWidget {
  @override
  _ParentingCalendarState createState() => _ParentingCalendarState();
}



class _ParentingCalendarState extends State<ParentingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parenting Holiday Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2050, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => parentDays[day] != null ? [parentDays[day]!] : [],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              holidayTextStyle: TextStyle().copyWith(color: Colors.orange),
              outsideDaysVisible: false,
              markersMaxCount: 1,
              markerDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (parentDays[date] == 'custodial') {
                  return Positioned(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    ),
                    right: 1,
                    bottom: 1,
                  );
                } else if (parentDays[date] == 'noncustodial') {
                  return Positioned(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                    ),
                    right: 1,
                    bottom: 1,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            holidayPredicate: (day) => parentDays.containsKey(day),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(width: 20, height: 20, color: Colors.red),
                    SizedBox(width: 5),
                    Text('custodial Parent'),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 20, height: 20, color: Colors.blue),
                    SizedBox(width: 5),
                    Text('Non-custodial Parent'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
