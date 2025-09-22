import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/create_project/widgets/calender_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderScreen  extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalenderScreen> {
  DateTime? startDate;
  DateTime? endDate;

  List<DateTime> generateDaysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = first.weekday % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 6 - last.weekday % 7;
    final lastToDisplay = last.add(Duration(days: daysAfter));

    return List.generate(
      lastToDisplay.difference(firstToDisplay).inDays + 1,
          (i) => firstToDisplay.add(Duration(days: i)),
    );
  }

  Widget buildMonth(DateTime month) {
    final days = generateDaysInMonth(month);
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(month),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((d) => Expanded(child: Center(child: Text(d))))
              .toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7),
          itemBuilder: (_, index) {
            final day = days[index];
            bool isCurrentMonth = day.month == month.month;
            bool isBeforeToday = day.isBefore(DateTime(today.year, today.month, today.day));
            bool isSelected = (startDate != null &&
                endDate != null &&
                day.isAfter(startDate!.subtract(Duration(days: 1))) &&
                day.isBefore(endDate!.add(Duration(days: 1))));

            Color textColor = isCurrentMonth
                ? (isSelected ? Colors.white : Colors.black)
                : Colors.grey;

            BoxDecoration? decoration;
            if (isSelected) {
              decoration = BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              );
            }

            return GestureDetector(
              onTap: isBeforeToday
                  ? null
                  : () {
                setState(() {
                  if (startDate == null || (startDate != null && endDate != null)) {
                    startDate = day;
                    endDate = null;
                  } else if (day.isBefore(startDate!)) {
                    startDate = day;
                    endDate = null;
                  } else {
                    endDate = day;
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: decoration,
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                        color: isBeforeToday ? Colors.grey.shade300 : textColor),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthsToDisplay = [
      DateTime(now.year, now.month),
      DateTime(now.year, now.month + 1),
      DateTime(now.year, now.month + 2),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Select start & end date')),
      body: Column(
        children: [
          Container(
            height: 550,
            margin: EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: monthsToDisplay.map(buildMonth).toList(),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: ShapeDecoration(
              color: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              'Assign Project',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.22,
              ),
            ),
          )
        ],
      ),
    );
  }
}
