import 'package:softshares_mobile/models/utilizador.dart';

class Topico {
  final int? topicoId;
  final int categoria;
  final int subcategoria;
  final Utilizador utilizadorCriou;
  final String titulo;
  final String mensagem;
  final DateTime? dataCriacao;
  final int idiomaId;
  final List<String>? imagem;

  Topico({
    this.topicoId,
    required this.categoria,
    required this.subcategoria,
    required this.utilizadorCriou,
    required this.titulo,
    required this.mensagem,
    this.dataCriacao,
    required this.idiomaId,
    required this.imagem,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      topicoId: json['topicoId'],
      categoria: json['categoria'],
      subcategoria: json['subcategoria'],
      utilizadorCriou: Utilizador.fromJsonSimplificado(json['utilizador']),
      titulo: json['titulo'],
      mensagem: json['mensagem'],
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.parse(json['dataCriacao'])
          : null,
      idiomaId: json['idiomaId'],
      imagem: json['imagens'] != null
          ? List<String>.from(json['imagens'].map((item) => item.toString()))
          : [],
    );
  }
}
