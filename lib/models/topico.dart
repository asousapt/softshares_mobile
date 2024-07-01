import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class Topico {
  ApiService api = ApiService();
  int? topicoId;
  int subcategoria;
  int utilizadorId;
  String utilizadorPnome;
  String utilizadorUnome;
  String titulo;
  String mensagem;
  DateTime? dataCriacao;
  int idiomaId;
  List<String> imagem;
  int? poloId;
  int? categoria;

  Topico({
    this.topicoId,
    required this.subcategoria,
    required this.utilizadorId,
    required this.utilizadorPnome,
    required this.utilizadorUnome,
    required this.titulo,
    required this.mensagem,
    required this.dataCriacao,
    required this.idiomaId,
    required this.imagem,
    this.categoria,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      topicoId: json['threadid'] ?? 0,
      subcategoria: json['subcategoriaid'] ?? 0,
      categoria: json['categoriaid'] ?? 0,
      utilizadorId: json['utilizadorid'] ?? 0,
      utilizadorPnome: json['pnome'] ?? '',
      utilizadorUnome: json['unome'] ?? '',
      titulo: json['titulo'] ?? '',
      mensagem: json['mensagem'] ?? '',
      dataCriacao: json['datacriacao'] != null ? DateTime.parse(json['datacriacao']) : DateTime(1970, 1, 1),
      idiomaId: json['idiomaid'] ?? 0,
      imagem: List<String>.from(json['imagens'] ?? []),
    );
  }

  String getNomeCompleto() {
    return "$utilizadorPnome $utilizadorUnome";
  }
}
