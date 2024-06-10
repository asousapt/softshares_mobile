import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Grupo {
  int? grupoId;
  String nome;
  String descricao;
  Subcategoria? subcategoria;
  List<Utilizador>? utilizadores;
  bool publico = false;
  String? imagem;

  Grupo({
    this.grupoId,
    required this.nome,
    required this.descricao,
    this.subcategoria,
    this.utilizadores,
    required this.publico,
    this.imagem,
  });
}

Future<List<Grupo>> fetchGrupos() async {
  await Future.delayed(Duration(seconds: 2));

  return [
    Grupo(
        grupoId: 1,
        nome: "Grupo da Bola",
        descricao: "Grupo da Bola",
        publico: false,
        imagem: "https://via.placeholder.com/150"),
    Grupo(
        grupoId: 2,
        nome: "Grupo das Jolas",
        descricao: "Grupo das Jolas",
        publico: false,
        imagem: "https://via.placeholder.com/150"),
    Grupo(
        grupoId: 3,
        nome: "Grupo da Ramboia",
        descricao: "Grupo da Ramboia",
        publico: false,
        imagem: "https://via.placeholder.com/150"),
    Grupo(
        grupoId: 4,
        nome: "Grupo de ir as gajas",
        descricao: "Grupo de ir as gajas",
        publico: false,
        imagem: "https://via.placeholder.com/150"),
  ];
}

Future<Grupo> fetchGrupo(int grupoId) async {
  await Future.delayed(Duration(seconds: 2));

  return Grupo(
      grupoId: grupoId,
      nome: "Grupo da Bola",
      descricao: "Grupo da Bola",
      publico: false,
      imagem: "https://via.placeholder.com/150");
}
