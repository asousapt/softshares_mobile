import 'package:intl/intl.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Evento {
  final int eventoId;
  final String titulo;
  final int categoria;
  final String descricao;
  final int numeroMaxPart;
  final int numeroInscritos;
  final String localizacao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<String> imagem;

  const Evento(
    this.eventoId,
    this.titulo,
    this.categoria,
    this.descricao,
    this.numeroMaxPart,
    this.numeroInscritos,
    this.localizacao,
    this.dataInicio,
    this.dataFim,
    this.imagem,
  );

  String dataFormatada(String local) {
    String dataF = "";

    DateTime dataIni =
        DateTime(dataInicio.year, dataInicio.month, dataInicio.day);
    DateTime dataFi = DateTime(dataFim.year, dataFim.month, dataFim.day);
    if (dataIni.compareTo(dataFi) == 0) {
      dataF =
          "${DateFormat.E(local).format(dataInicio)}, ${DateFormat.d().format(dataInicio)} ${DateFormat.MMM(local).format(dataInicio)} ${DateFormat.y().format(dataInicio)}";
    } else {
      dataF =
          "${DateFormat.yMd(local).format(dataInicio)} - ${DateFormat.yMd(local).format(dataFim)}";
    }
    return dataF;
  }

  String horaFormatada(String local) {
    return "${DateFormat.jm(local).format(dataInicio)} - ${DateFormat.jm(local).format(dataFim)}";
  }
}

// carregamento do Evento
final kEvents = LinkedHashMap<DateTime, List<Evento>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<DateTime, List<Evento>> _kEventSource = {
  DateTime(2024, 06, 15): [
    Evento(
      1,
      "Conferência de Tecnologia 2024",
      1,
      "Junte-se a nós para a maior conferência de tecnologia do ano!",
      1000,
      500,
      "Virtual",
      DateTime(2024, 06, 15, 10, 0), // June 15, 2024, 10:00 AM
      DateTime(2024, 06, 15, 18, 0), // June 15, 2024, 6:00 PM
      [],
    ),
  ],
  DateTime(2024, 07, 20): [
    Evento(
      2,
      "Festival de Música 2024",
      2,
      "Viva um fim de semana de música, comida e diversão!",
      5000,
      3000,
      "Central Park, Nova York",
      DateTime(2024, 07, 20, 12, 0), // July 20, 2024, 12:00 PM
      DateTime(2024, 07, 22, 22, 0), // July 22, 2024, 10:00 PM
      [],
    ),
  ],
  DateTime(2024, 08, 10): [
    Evento(
      3,
      "Cimeira de Startups 2024",
      1,
      "Conecte-se com investidores e empreendedores na Cimeira de Startups!",
      800,
      400,
      "San Francisco, Califórnia",
      DateTime(2024, 08, 10, 9, 0), // August 10, 2024, 9:00 AM
      DateTime(2024, 08, 12, 17, 0), // August 12, 2024, 5:00 PM
      [],
    ),
  ],
  DateTime(2024, 09, 5): [
    Evento(
      4,
      "Feira de Livros 2024",
      3,
      "Explore uma variedade de livros de diferentes gêneros na Feira de Livros!",
      500,
      200,
      "Centro de Convenções, São Paulo",
      DateTime(2024, 09, 5, 10, 0), // September 5, 2024, 10:00 AM
      DateTime(2024, 09, 10, 20, 0), // September 10, 2024, 8:00 PM
      [],
    ),
  ],
  DateTime(2024, 10, 15): [
    Evento(
      5,
      "Exposição de Arte Contemporânea 2024",
      4,
      "Descubra obras de arte modernas e inovadoras na Exposição de Arte Contemporânea!",
      300,
      150,
      "Galeria de Arte Moderna, Lisboa",
      DateTime(2024, 10, 15, 12, 0), // October 15, 2024, 12:00 PM
      DateTime(2024, 10, 20, 18, 0), // October 20, 2024, 6:00 PM
      [],
    ),
  ],
  DateTime(2024, 11, 8): [
    Evento(
      6,
      "Conferência de Saúde Mental 2024",
      5,
      "Participe de palestras e workshops sobre saúde mental na Conferência de Saúde Mental!",
      600,
      300,
      "Online",
      DateTime(2024, 11, 8, 9, 0), // November 8, 2024, 9:00 AM
      DateTime(2024, 11, 10, 17, 0), // November 10, 2024, 5:00 PM
      [],
    ),
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
