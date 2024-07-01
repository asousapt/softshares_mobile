import "utilizador.dart";

class PontoInteresse {
  final int pontoInteresseId;
  final int subCategoriaId;
  final String titulo;
  final String descricao;
  final bool? aprovado;
  final DateTime? dataAprovacao;
  final String localizacao;
  final String? latitude;
  final String? longitude;
  final int idiomaId;
  final int cidadeId;
  final DateTime dataCriacao;
  final DateTime? dataAlteracao;
  final int? criador;
  final double? avaliacao;

  PontoInteresse({
    required this.pontoInteresseId,
    required this.subCategoriaId,
    required this.titulo,
    required this.descricao,
    this.aprovado,
    this.dataAprovacao,
    required this.localizacao,
    this.latitude,
    this.longitude,
    required this.idiomaId,
    required this.cidadeId,
    required this.dataCriacao,
    this.dataAlteracao,
    this.criador,
    this.avaliacao,
  });

  factory PontoInteresse.fromJson(Map<String, dynamic> json) {
    final pontoInteresseId = json['pontointeresseid'] as int?;
    final subCategoriaId = json['subcategoriaid'] as int?;
    final titulo = json['titulo'] as String?;
    final descricao = json['descricao'] as String?;
    final aprovado = json['aprovado'] as bool?;
    final dataAprovacao = json['dataaprovacao'] != null
        ? DateTime.parse(json['dataaprovacao'])
        : null;
    final utilizadorAprova = json['utilizadoraprova'] as int?;
    final localizacao = json['localizacao'] as String?;
    final latitude = json['latitude'] as String?;
    final longitude = json['longitude'] as String?;
    final idiomaId = json['idiomaid'] as int?;
    final cidadeId = json['cidadeid'] as int?;
    final dataCriacao = json['datacriacao'] != null
        ? DateTime.parse(json['datacriacao'])
        : null;
    final dataAlteracao = json['dataalteracao'] != null
        ? DateTime.parse(json['dataalteracao'])
        : null;
    final criador = json['utilizadoraprova'] as int?;
    final avaliacao = json['avgavaliacao'] != null 
      ? double.tryParse(json['avgavaliacao']) 
      : null;

    if (pontoInteresseId == null ||
        subCategoriaId == null ||
        titulo == null ||
        descricao == null ||
        localizacao == null ||
        idiomaId == null ||
        cidadeId == null ||
        dataCriacao == null) {
      throw Exception('Missing required field');
    }

    return PontoInteresse(
      pontoInteresseId: pontoInteresseId,
      subCategoriaId: subCategoriaId,
      titulo: titulo,
      descricao: descricao,
      aprovado: aprovado,
      dataAprovacao: dataAprovacao,
      localizacao: localizacao,
      latitude: latitude,
      longitude: longitude,
      idiomaId: idiomaId,
      cidadeId: cidadeId,
      dataCriacao: dataCriacao,
      dataAlteracao: dataAlteracao,
      criador: criador,
      avaliacao: avaliacao,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pontointeresseid': pontoInteresseId,
      'subcategoriaid': subCategoriaId,
      'titulo': titulo,
      'descricao': descricao,
      'aprovado': aprovado,
      'dataaprovacao': dataAprovacao?.toIso8601String(),
      'localizacao': localizacao,
      'latitude': latitude,
      'longitude': longitude,
      'idiomaid': idiomaId,
      'cidadeid': cidadeId,
      'datacriacao': dataCriacao.toIso8601String(),
      'dataalteracao': dataAlteracao?.toIso8601String(),
      'utilizadorcriou_utilizador': criador,
      'avgavaliacao': avaliacao,
    };
  }
}

final List<PontoInteresse> pontosDeInteresseTeste = [
  PontoInteresse(
    pontoInteresseId: 1,
    subCategoriaId: 1,
    titulo: 'Parque Central',
    descricao:
        'Um lindo parque no centro da cidade com áreas verdes e playgrounds.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 4, 12),
    localizacao: 'Centro da Cidade',
    latitude: '40.785091',
    longitude: '-73.968285',
    idiomaId: 1,
    cidadeId: 101,
    dataCriacao: DateTime(2023, 1, 10),
    criador: utilizadores[0].utilizadorId,
    avaliacao: 4.5,
  ),
  PontoInteresse(
    pontoInteresseId: 2,
    subCategoriaId: 2,
    titulo: 'Museu de Arte Moderna',
    descricao:
        'Um museu com uma coleção incrível de arte moderna e contemporânea.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 5, 20),
    localizacao: 'Rua das Artes, 45',
    latitude: '40.761436',
    longitude: '-73.977621',
    idiomaId: 1,
    cidadeId: 101,
    dataCriacao: DateTime(2023, 2, 15),
    criador: utilizadores[1].utilizadorId,
    avaliacao: 4.7,
  ),
  PontoInteresse(
    pontoInteresseId: 3,
    subCategoriaId: 3,
    titulo: 'Praia do Sol',
    descricao: 'Uma bela praia com areia dourada e águas cristalinas.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 6, 5),
    localizacao: 'Avenida Beira Mar',
    latitude: '40.595928',
    longitude: '-73.961452',
    idiomaId: 1,
    cidadeId: 102,
    dataCriacao: DateTime(2023, 3, 25),
    criador: utilizadores[2].utilizadorId,
    avaliacao: 4.8,
  ),
  PontoInteresse(
    pontoInteresseId: 4,
    subCategoriaId: 4,
    titulo: 'Catedral de São Pedro',
    descricao: 'Uma catedral histórica com arquitetura gótica impressionante.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 7, 15),
    localizacao: 'Praça da Sé, 10',
    latitude: '40.712776',
    longitude: '-74.005974',
    idiomaId: 1,
    cidadeId: 103,
    dataCriacao: DateTime(2023, 4, 30),
    criador: utilizadores[3].utilizadorId,
    avaliacao: 4.9,
  ),
];
