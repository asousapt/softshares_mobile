import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Grupo {
  int? grupoId;
  String nome;
  String descricao;
  int? subcategoriaId;
  int? categoriaId;
  List<Imagem>? imagem;
  List<Utilizador>? utilizadores;
  bool publico;
  List<String>? fotourls;
  int utilizadorCriouId;

  Grupo({
    this.grupoId,
    required this.nome,
    this.subcategoriaId,
    required this.descricao,
    this.utilizadores,
    required this.publico,
    this.imagem,
    required this.utilizadorCriouId,
    this.categoriaId,
    this.fotourls,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      grupoId: json['grupoId'],
      nome: json['nome'],
      descricao: json['descricao'],
      subcategoriaId: json['subcategoriaId'],
      categoriaId: json['categoriaId'],
      utilizadores: json['utilizadores'] != null
          ? (json['utilizadores'] as List)
              .map((e) => Utilizador.fromJsonSimplificado(e))
              .toList()
          : null,
      publico: json['publico'] ?? false,
      imagem: json['imagem'] != null
          ? (json['imagem'] as List).map((e) => Imagem.fromJson(e)).toList()
          : null,
      utilizadorCriouId: json['utilizadorCriouId'],
      fotourls:
          json['fotourls'] != null ? List<String>.from(json['fotourls']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grupoId': grupoId,
      'nome': nome,
      'descricao': descricao,
      'subcategoriaid': subcategoriaId,
      'categoriaid': categoriaId,
      'users': utilizadores?.map((e) => e.toJsonGrupo()).toList(),
      'publico': publico,
      'imagem': imagem?.map((e) => e.toJson()).toList(),
      'utilizadorcriou': utilizadorCriouId,
      'fotourls': fotourls ?? [],
    };
  }
}
