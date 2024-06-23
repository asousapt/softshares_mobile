import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:softshares_mobile/models/evento.dart';

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
  final List<Evento> Function(DateTime) eventLoader;
  final List<Categoria> categorias;
  final String idioma;

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
    required this.categorias,
    required this.idioma,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: largura * 0.02,
        vertical: altura * 0.01,
      ),
      child: TableCalendar<Evento>(
        locale: idioma,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final List<Widget> markers = [];

            int i = 0;
            for (final event in events) {
              final category = event.categoria;
              if (i <= 3) {
                markers.add(
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: largura * 0.005),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: categorias
                          .firstWhere(
                              (element) => element.categoriaId == category)
                          .getCor(),
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
        firstDay: DateTime.now().subtract(const Duration(days: 90)),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        rangeStartDay: rangeStart,
        rangeEndDay: rangeEnd,
        calendarFormat: calendarFormat,
        onDayLongPressed: (selectedDay, focusedDay) {},
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        rangeSelectionMode: rangeSelectionMode,
        eventLoader: eventLoader,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          markersMaxCount: 3,
          weekendTextStyle: TextStyle(color: Colors.red),
          outsideDaysVisible: false,
          canMarkersOverflow: false,
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
}
