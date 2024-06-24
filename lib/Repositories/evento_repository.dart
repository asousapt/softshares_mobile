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

  // funcao que verifica se o utilizador pode inscrever-se no evento
  bool podeInscrever(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    if (evento.utilizadoresInscritos!.contains(utilizadorId)) {
      return false;
    }

    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if ((evento.dataLimiteInsc.isAfter(hoje) ||
        evento.dataLimiteInsc.isAtSameMomentAs(hoje))) {
      if (evento.numeroMaxPart == 0) {
        return true;
      } else if (evento.numeroInscritos < evento.numeroMaxPart) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // Verifica se o utilizador pode cancelar a inscricao no evento
  bool podeCancelarInscricao(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // utilizador nao pode cancelar se foi o criador do evento
    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    // o evento ja aconteceu
    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAtSameMomentAs(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        !evento.utilizadoresInscritos!.contains(utilizadorId)) {
      return false;
    }

    return true;
  }

  // Verifica se o evento pode ser cancelado pelo seu criador
  bool podeCancelarEvento(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        evento.utilizadorCriou == utilizadorId) {
      return true;
    }
    return false;
  }
}
