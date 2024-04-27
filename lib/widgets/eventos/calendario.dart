import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:softshares_mobile/models/eventoTC.dart';

class TableCalendarWidget extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final RangeSelectionMode rangeSelectionMode;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime?, DateTime?, DateTime) onRangeSelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;
  final Function(DateTime) eventLoader;

  const TableCalendarWidget({
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.rangeSelectionMode,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onDaySelected,
    required this.onRangeSelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.eventLoader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(left: 15, right: 12),
      child: TableCalendar<EventTC>(
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final List<Widget> markers = [];

            int i = 0;
            for (final event in events) {
              final category = event.categoria;
              if (i <= 3) {
                markers.add(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getCategoryColor(category),
                    ),
                    width: 8.0,
                    height: 8.0,
                  ),
                );
              }
              i++;
            }

            return Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: markers,
              ),
            );
          },
        ),
        weekendDays: const [DateTime.saturday, DateTime.sunday],
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        rangeStartDay: rangeStart,
        rangeEndDay: rangeEnd,
        calendarFormat: calendarFormat,
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        rangeSelectionMode: rangeSelectionMode,
        eventLoader: (day) => eventLoader(day),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
        ),
        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay, focusedDay);
        },
        onRangeSelected: (start, end, focusedDay) {
          onRangeSelected(start, end, focusedDay);
        },
        onFormatChanged: (format) {
          onFormatChanged(format);
        },
        onPageChanged: (focusedDay) {
          onPageChanged(focusedDay);
        },
      ),
    );
  }

  Color _getCategoryColor(int categoryNumber) {
    switch (categoryNumber) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      default:
        return const Color(0x00e3fc03);
    }
  }
}
