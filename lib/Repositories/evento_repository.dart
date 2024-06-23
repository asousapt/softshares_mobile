import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';

class EventoRepository {
  final ApiService _apiService = ApiService();

  // busca todos os eventos disponiveis no polo num range de 6 meses
  Future<List<Evento>> getEventos() async {
    _apiService.setAuthToken("tokenFixo");
    final prefs = await SharedPreferences.getInstance();
    final poloId = prefs.getInt("poloId").toString();
    final DateTime now = DateTime.now();
    final DateTime firstDay = DateTime(now.year, now.month, now.day - 90);
    final DateTime lastDay = DateTime(now.year, now.month, now.day + 90);

    final response = await _apiService.getRequest(
        "evento/$poloId/data/range/${firstDay.toIso8601String()}/${lastDay.toIso8601String()}");
    final eventosformattr = response['data'] as List;

    if (eventosformattr.isEmpty) {
      return [];
    } else {
      return eventosformattr.map((e) => Evento.fromJson(e)).toList();
    }
  }

  // retorna os eventos de um dia especifico (usado no table_calendar)
  Map<DateTime, List<Evento>> getEventosMap(List<Evento> eventos) {
    final Map<DateTime, List<Evento>> eventSource = {};

    for (final event in eventos) {
      final eventDate = DateTime(
          event.dataInicio.year, event.dataInicio.month, event.dataInicio.day);
      if (eventSource[eventDate] == null) {
        eventSource[eventDate] = [];
      }
      eventSource[eventDate]!.add(event);
    }

    return eventSource;
  }

  // retorna os eventos de um dia especifico (usado no table_calendar)
  LinkedHashMap<DateTime, List<Evento>> getEventosLinkedHashMap(
      Map<DateTime, List<Evento>> eventSource) {
    return LinkedHashMap<DateTime, List<Evento>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventSource);
  }

  // usado no table_calendar
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // usado no table_calendar
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
