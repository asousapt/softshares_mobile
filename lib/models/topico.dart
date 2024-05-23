import 'package:softshares_mobile/models/utilizador.dart';

class Topico {
  int? topicoId;
  int categoria;
  int subcategoria;
  Utilizador utilizadorId;
  String titulo;
  String mensagem;
  DateTime? dataCriacao;
  int idiomaId;
  List<String> imagem;
  int? poloId;

  Topico({
    this.topicoId,
    required this.categoria,
    required this.subcategoria,
    required this.utilizadorId,
    required this.titulo,
    required this.mensagem,
    this.dataCriacao,
    required this.idiomaId,
    required this.imagem,
  });
}
