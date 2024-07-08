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
  String? fotoUrl1;
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
    this.fotoUrl1,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      grupoId: json['grupoid'],
      nome: json['nome'],
      descricao: json['descricao'],
      subcategoriaId: json['subcategoriaid'],
      categoriaId: json['categoriaid'],
      utilizadores: json['utilizadores'] != null
          ? (json['utilizadores'] as List)
              .map((e) => Utilizador.fromJsonSimplificado(e))
              .toList()
          : null,
      publico: json['publico'] ?? false,
      imagem: json['imagem'] != null
          ? (json['imagem'] as List).map((e) => Imagem.fromJson(e)).toList()
          : null,
      utilizadorCriouId: json['utilizadorCriou'] ?? 0,
      fotourls: json['fotoUrl'] != null && json['fotoUrl'] != ''
          ? [json['fotoUrl']]
          : [],
      fotoUrl1: json['fotoUrl1'] ?? '',
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
