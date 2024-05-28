import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Grupo {
  int? grupoId;
  String descricao;
  Subcategoria subcategoria;
  List<Utilizador> utilizadores;
  bool publico = false;
  String? imagem;

  Grupo({
    this.grupoId,
    required this.descricao,
    required this.subcategoria,
    required this.utilizadores,
    required this.publico,
    this.imagem,
  });
}
