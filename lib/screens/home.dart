import 'package:flutter/material.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/widgets/eventos/calendario.dart';
import 'package:softshares_mobile/widgets/eventos/event_list.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<List<Evento>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Evento> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Evento> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 0),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paginaInicial),
      ),
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Text(
                AppLocalizations.of(context)!.comunidade,
                style: const TextStyle(
                  color: Color.fromRGBO(217, 215, 215, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TableCalendarWidget(
              eventLoader: _getEventsForDay,
              selectedDay: _selectedDay!,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              rangeStart: _rangeStart,
              rangeEnd: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                AppLocalizations.of(context)!.eventos,
                style: const TextStyle(
                  color: Color.fromRGBO(217, 215, 215, 1),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: EventListView(selectedEvents: _selectedEvents),
            ),
          ],
        ),
      ),
    );
  }
}
