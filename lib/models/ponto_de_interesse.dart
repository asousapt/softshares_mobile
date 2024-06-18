import "utilizador.dart";

class PontoInteresse {
  final int pontoInteresseId;
  final int subCategoriaId;
  final String titulo;
  final String descricao;
  final bool? aprovado;
  final DateTime? dataAprovacao;
  final int? utilizadorAprova;
  final String localizacao;
  final String? latitude;
  final String? longitude;

  final int idiomaId;
  final int cidadeId;
  final DateTime dataCriacao;
  final DateTime? dataAlteracao;
  final Utilizador? criador;

  PontoInteresse(
      {required this.pontoInteresseId,
      required this.subCategoriaId,
      required this.titulo,
      required this.descricao,
      this.aprovado,
      this.dataAprovacao,
      this.utilizadorAprova,
      required this.localizacao,
      this.latitude,
      this.longitude,
      required this.idiomaId,
      required this.cidadeId,
      required this.dataCriacao,
      this.dataAlteracao,
      this.criador});

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
    final criador = json['utilizadorcriou_utilizador'] != null
        ? Utilizador.fromJson(json['utilizadorcriou_utilizador'])
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
        pontoInteresseId: json['pontointeresseid'],
        subCategoriaId: json['subcategoriaid'],
        titulo: json['titulo'],
        descricao: json['descricao'],
        aprovado: json['aprovado'],
        dataAprovacao: json['dataaprovacao'] != null
            ? DateTime.parse(json['dataaprovacao'])
            : null,
        utilizadorAprova: json['utilizadoraprova'],
        localizacao: json['localizacao'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        idiomaId: json['idiomaid'],
        cidadeId: json['cidadeid'],
        dataCriacao: DateTime.parse(json['datacriacao']),
        dataAlteracao: json['dataalteracao'] != null
            ? DateTime.parse(json['dataalteracao'])
            : null,
        criador: Utilizador.fromJson(json['utilizadorcriou_utilizador']));
  }

  Map<String, dynamic> toJson() {
    return {
      'pontoInteresseId': pontoInteresseId,
      'subCategoriaId': subCategoriaId,
      'titulo': titulo,
      'descricao': descricao,
      'aprovado': aprovado,
      'dataAprovacao': dataAprovacao?.toIso8601String(),
      'utilizadorAprova': utilizadorAprova,
      'localizacao': localizacao,
      'latitude': latitude,
      'longitude': longitude,
      'idiomaId': idiomaId,
      'cidadeId': cidadeId,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAlteracao': dataAlteracao?.toIso8601String(),
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
    utilizadorAprova: 2,
    localizacao: 'Centro da Cidade',
    latitude: '40.785091',
    longitude: '-73.968285',
    idiomaId: 1,
    cidadeId: 101,
    dataCriacao: DateTime(2023, 1, 10),
    criador: utilizadores[0],
  ),
  PontoInteresse(
    pontoInteresseId: 2,
    subCategoriaId: 2,
    titulo: 'Museu de Arte Moderna',
    descricao:
        'Um museu com uma coleção incrível de arte moderna e contemporânea.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 5, 20),
    utilizadorAprova: 3,
    localizacao: 'Rua das Artes, 45',
    latitude: '40.761436',
    longitude: '-73.977621',
    idiomaId: 1,
    cidadeId: 101,
    dataCriacao: DateTime(2023, 2, 15),
    criador: utilizadores[1],
  ),
  PontoInteresse(
    pontoInteresseId: 3,
    subCategoriaId: 3,
    titulo: 'Praia do Sol',
    descricao: 'Uma bela praia com areia dourada e águas cristalinas.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 6, 5),
    utilizadorAprova: 1,
    localizacao: 'Avenida Beira Mar',
    latitude: '40.595928',
    longitude: '-73.961452',
    idiomaId: 1,
    cidadeId: 102,
    dataCriacao: DateTime(2023, 3, 25),
    criador: utilizadores[2],
  ),
  PontoInteresse(
    pontoInteresseId: 4,
    subCategoriaId: 4,
    titulo: 'Catedral de São Pedro',
    descricao: 'Uma catedral histórica com arquitetura gótica impressionante.',
    aprovado: true,
    dataAprovacao: DateTime(2023, 7, 15),
    utilizadorAprova: 4,
    localizacao: 'Praça da Sé, 10',
    latitude: '40.712776',
    longitude: '-74.005974',
    idiomaId: 1,
    cidadeId: 103,
    dataCriacao: DateTime(2023, 4, 30),
    criador: utilizadores[3],
  ),
];
