import 'package:camera/camera.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/utils.dart';

class Topico {
  final int? topicoId;
  final int? categoria;
  final int subcategoria;
  final Utilizador? utilizadorCriou;
  final int? utilizadorId;
  final String titulo;
  final String mensagem;
  final DateTime? dataCriacao;
  final int idiomaId;
  final List<String>? imagem;
  List<XFile>? images;
  List<Imagem>? imagens;
  int? poloid;

  Topico({
    this.topicoId,
    this.categoria,
    required this.subcategoria,
    this.utilizadorCriou,
    required this.titulo,
    required this.mensagem,
    this.dataCriacao,
    required this.idiomaId,
    this.imagem,
    this.utilizadorId,
    this.images,
    this.imagens,
    this.poloid,
  });

  // retorna um objeto Topico a partir de um json
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
        poloid: json['poloid']);
  }

  Map<String, dynamic> toJsonCriar() {
    List<Map<String, dynamic>> listaImagens =
        toJsonList(imagens, (Imagem img) => img.toJson());

    return {
      "subcategoriaid": subcategoria,
      "titulo": titulo,
      "mensagem": mensagem,
      "imagens": listaImagens,
      "utilizadorid": utilizadorId ?? 0,
      "idiomaid": idiomaId,
      "poloid": poloid
    };
  }
}
