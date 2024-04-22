import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

/// Exemplo da class evento table calendar
/// Poderão ser carregados mais campos na estrutura
class EventTC {
  final String titulo;
  final int categoria;
  final String descricao;

  const EventTC(
    this.titulo,
    this.categoria,
    this.descricao,
  );
}

// carregamento do eventTC
final kEvents = LinkedHashMap<DateTime, List<EventTC>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<DateTime, List<EventTC>> _kEventSource = {
  DateTime(2024, 4, 19): [
    EventTC('Event 1', 1, 'gfwergferw'),
    EventTC('Event 2', 2, 'gfwergferw'),
    EventTC('Event 17', 1, 'gfwergferw'),
    EventTC('Event 99', 2, 'gfwergferw'),
    EventTC('Event 98', 2, 'gfwergferw'),
  ],
  DateTime(2024, 4, 20): [
    EventTC('Event 3', 3, 'gfwergferw'),
  ],
  DateTime(2024, 4, 25): [
    EventTC('Event 4', 3, 'gfwergferw'),
  ],
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
