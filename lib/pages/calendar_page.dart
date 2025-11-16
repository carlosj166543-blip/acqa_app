// lib/pages/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  static const routeName = '/calendar';
  const CalendarPage({Key? key}) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focused,
                  selectedDayPredicate: (d) => isSameDay(d, _selected),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selected = selectedDay;
                      _focused = focusedDay;
                    });
                    Navigator.pushNamed(context, '/tasks', arguments: selectedDay);
                  },
                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  calendarStyle: CalendarStyle(outsideDaysVisible: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Toque em um dia para abrir as tarefas', style: TextStyle(color: primary)),
            const SizedBox(height: 8),
            Text('Hoje: ${DateFormat.yMMMMd().format(DateTime.now())}'),
          ],
        ),
      ),
    );
  }
}
