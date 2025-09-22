import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final void Function(DateTime?, DateTime?, DateTime) onRangeSelected;
  final void Function(DateTime) onPageChanged;

  const CalendarCard({
    super.key,
    required this.focusedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onRangeSelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        rangeStartDay: rangeStart,
        rangeEndDay: rangeEnd,
        rangeSelectionMode: RangeSelectionMode.enforced, // Optional
        onRangeSelected: onRangeSelected,
        onPageChanged: onPageChanged,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.circle,
          ),
          rangeStartDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
