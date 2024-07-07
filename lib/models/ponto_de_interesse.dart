import "utilizador.dart";

class PontoInteresse {
  final int pontoInteresseId;
  final int subCategoriaId;
  final int categoriaId;
  final String titulo;
  final List<String>? imagens;
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
    required this.categoriaId,
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
    this.imagens,
  });

  factory PontoInteresse.fromJson(Map<String, dynamic> json) {
    final pontoInteresseId = json['pontointeresseid'] as int?;
    final subCategoriaId = json['subcategoriaid'] as int?;
    final categoriaId = json['categoriaid'] as int?;
    final titulo = json['titulo'] as String?;
    final descricao = json['descricao'] as String?;
    final aprovado = json['aprovado'] as bool?;
    final dataAprovacao = json['dataaprovacao'] != null
        ? DateTime.parse(json['dataaprovacao'])
        : null;
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
    final imagens = (json['imagem'] as List<dynamic>?)
        ?.map((item) => item as String)
        .toList();

    if (pontoInteresseId == null ||
        subCategoriaId == null ||
        categoriaId == null ||
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
      categoriaId: categoriaId,
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
      imagens: imagens,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pontointeresseid': pontoInteresseId,
      'subcategoriaid': subCategoriaId,
      'categoriaid': categoriaId,
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
      'imagens': imagens,
    };
  }
}

