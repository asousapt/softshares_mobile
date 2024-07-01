import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/utils.dart';

class Evento {
  final int? eventoId;
  final String titulo;
  final int? categoria;
  final int subcategoria;
  final String descricao;
  final int numeroMaxPart;
  int numeroInscritos;
  final int nmrConvidados;
  final String localizacao;
  final String latitude;
  final String longitude;
  final DateTime dataInicio;
  final DateTime dataFim;
  final DateTime dataLimiteInsc;
  final List<String>? imagem;
  final int utilizadorCriou;
  final int cidadeid;
  final bool? cancelado;
  final List<int>? utilizadoresInscritos;
  List<Imagem>? imagens;
  final int? utilizadorAprovou;
  final bool? aprovado;
  final DateTime? dataAprovacao;
  final int? poloId;
  Formulario? formInsc;
  Formulario? formQualidade;
  List<XFile>? images;

  Evento({
    this.eventoId,
    required this.titulo,
    this.categoria,
    required this.subcategoria,
    required this.descricao,
    required this.numeroMaxPart,
    required this.numeroInscritos,
    required this.nmrConvidados,
    required this.localizacao,
    required this.latitude,
    required this.longitude,
    required this.dataInicio,
    required this.dataFim,
    required this.dataLimiteInsc,
    this.imagem,
    required this.utilizadorCriou,
    required this.cidadeid,
    required this.cancelado,
    required this.utilizadoresInscritos,
    this.imagens,
    this.utilizadorAprovou,
    this.aprovado = false,
    this.dataAprovacao,
    this.poloId,
    this.formInsc,
    this.formQualidade,
    this.images,
  });

  // construtor para criar o evento a enviar para a API
  Evento.criar({
    this.eventoId = 0,
    required this.titulo,
    this.categoria,
    required this.subcategoria,
    required this.descricao,
    required this.numeroMaxPart,
    required this.nmrConvidados,
    required this.localizacao,
    required this.latitude,
    required this.longitude,
    required this.dataInicio,
    required this.dataFim,
    required this.dataLimiteInsc,
    this.imagem,
    required this.utilizadorCriou,
    required this.cidadeid,
    this.cancelado,
    this.utilizadoresInscritos,
    this.numeroInscritos = 0,
    this.imagens,
    this.utilizadorAprovou,
    this.aprovado = false,
    this.dataAprovacao,
    this.poloId,
    this.formInsc,
    this.formQualidade,
  });

  // construtor para criar o evento a partir da API
  // Factory constructor to create an Evento instance from JSON
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      eventoId: json['eventoid'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataInicio: DateTime.parse(json['datainicio']),
      dataFim: DateTime.parse(json['datafim']),
      dataLimiteInsc: DateTime.parse(json['dataliminscricao']),
      cancelado: json['cancelado'],
      numeroMaxPart: json['nmrmaxparticipantes'],
      localizacao: json['localizacao'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cidadeid: json['cidadeid'],
      utilizadorCriou: json['utilizadorcriou'],
      utilizadorAprovou: json['utilizadoraprovou'],
      aprovado: json['aprovado'] ?? false,
      dataAprovacao: json['dataaprovacao'] != null
          ? DateTime.parse(json['dataaprovacao'])
          : null,
      subcategoria: json['subcategoriaid'],
      poloId: json['poloid'],
      numeroInscritos: json['numinscritos'],
      nmrConvidados: 0,
      utilizadoresInscritos: json['participantes'] != null
          ? List<int>.from(json['participantes'])
          : [],
      categoria: json['categoriaid'],
      imagem: json['imagens'] != null ? List<String>.from(json['imagens']) : [],
    );
  }

  // Factory constructor to create an Evento instance from JSON~
  factory Evento.fromJsonEditar(Map<String, dynamic> json) {
    return Evento(
      eventoId: json['eventoid'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataInicio: DateTime.parse(json['datainicio']),
      dataFim: DateTime.parse(json['datafim']),
      dataLimiteInsc: DateTime.parse(json['dataliminscricao']),
      cancelado: json['cancelado'],
      numeroMaxPart: json['nmrmaxparticipantes'],
      localizacao: json['localizacao'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cidadeid: json['cidadeid'],
      utilizadorCriou: json['utilizadorcriou'],
      utilizadorAprovou: json['utilizadoraprovou'],
      aprovado: json['aprovado'],
      dataAprovacao: json['dataaprovacao'] != null
          ? DateTime.parse(json['dataaprovacao'])
          : null,
      subcategoria: json['subcategoriaid'],
      poloId: json['poloid'],
      numeroInscritos: json['numinscritos'],
      nmrConvidados: json['nmrconvidados'],
      utilizadoresInscritos: json['participantes'] != null
          ? List<int>.from(json['participantes'])
          : [],
      categoria: json['categoriaid'],
      images: json['images'] != null ? List<XFile>.from(json['images']) : [],
      formInsc: json['forminscricao'] != null
          ? Formulario.fromJson(json['forminscricao'])
          : null,
      formQualidade: json['formqualidade'] != null
          ? Formulario.fromJson(json['formqualidade'])
          : null,
    );
  }

  // ToJson para envio para a API
  Map<String, dynamic> toJsonCriar() {
    List<Map<String, dynamic>> listaImagens =
        toJsonList(imagens, (Imagem img) => img.toJson());

    List<Map<String, dynamic>> listPergInscr = formInsc != null
        ? toJsonList(formInsc!.perguntas, (pergunta) => pergunta.toJson())
        : [];

    List<Map<String, dynamic>> listPergQual = formQualidade != null
        ? toJsonList(formQualidade!.perguntas, (pergunta) => pergunta.toJson())
        : [];

    return {
      "titulo": titulo,
      "poloId": poloId,
      "subcategoriaId": subcategoria,
      "descricao": descricao,
      "nmrMaxParticipantes": numeroMaxPart,
      "nmrConvidados": nmrConvidados,
      "localizacao": localizacao,
      "latitude": latitude,
      "longitude": longitude,
      "dataInicio": dataInicio.toIso8601String(),
      "dataFim": dataFim.toIso8601String(),
      "dataLimInscricao": dataLimiteInsc.toIso8601String(),
      "utilizadorCriou": utilizadorCriou,
      "cidadeID": cidadeid,
      "imagens": listaImagens,
      'formInsc': listPergInscr,
      'formQualidade': listPergQual,
    };
  }

  Map<String, dynamic> toJsonInscricao(int utilizadorId, int nmrConvidados,
      List<Map<String, dynamic>> respostas) {
    return {
      "idEvento": eventoId,
      "idUser": utilizadorId,
      "numConvidados": nmrConvidados,
      "respostas": respostas,
    };
  }

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
