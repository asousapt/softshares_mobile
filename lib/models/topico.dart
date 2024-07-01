import 'package:softshares_mobile/models/utilizador.dart';

class Topico {
  final int topicoId;
  final int categoria;
  final int subcategoria;
  final Utilizador utilizadorId;
  final String titulo;
  final String mensagem;
  final DateTime dataCriacao;
  final int idiomaId;
  final List<String> imagem;

  Topico({
    required this.topicoId,
    required this.categoria,
    required this.subcategoria,
    required this.utilizadorId,
    required this.titulo,
    required this.mensagem,
    required this.dataCriacao,
    required this.idiomaId,
    required this.imagem,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    print('Topico parsed: $json');
    try {
      return Topico(
        topicoId: json['topicoId'],
        categoria: json['categoria'],
        subcategoria: json['subcategoria'],
        utilizadorId: Utilizador.fromJson(json['utilizadorId']),
        titulo: json['titulo'],
        mensagem: json['mensagem'],
        dataCriacao: DateTime.parse(json['dataCriacao']),
        idiomaId: json['idiomaId'],
        imagem: List<String>.from(json['imagem']),
      );
    } catch (e) {
      print('Erro ao converter JSON para Topico: $e');
      throw Exception('Erro ao converter JSON para Topico');
    }
  }
}
