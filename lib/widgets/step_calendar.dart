import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/pedometer.dart';

class StepsCalendar extends StatefulWidget {
  const StepsCalendar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StepsCalendarState createState() => _StepsCalendarState();
}

class _StepsCalendarState extends State<StepsCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PedometerProvider>(context);

    return SizedBox(
      height: 150,
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (format != CalendarFormat.week) {
            setState(() {
              _calendarFormat = CalendarFormat.week;
            });
          }
        },
        onDaySelected: (selectedDay, focusedDay) {
          provider.updateSelectedDate(selectedDay);
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          weekendStyle: TextStyle(
            color: Colors.green, // for example
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 4),
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 3),
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          weekendTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          todayTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          selectedBuilder: (context, day, focusedDay) => Container(
            width: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen, width: 3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
