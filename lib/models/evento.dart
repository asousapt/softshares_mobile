import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

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
  final String imagem;

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
