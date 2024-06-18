import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Categoria {
  final int categoriaId;
  final String cor;
  final String icone;
  final String descricao;
  final int idiomaId;

  const Categoria({
    required this.categoriaId,
    required this.descricao,
    required this.cor,
    required this.icone,
    required this.idiomaId,
  });

  // retorna a cor da categoria
  Color getCor() {
    String colorString = "FF$cor";
    int colorInt = int.parse(colorString, radix: 16);
    return Color(colorInt);
  }

  // retorna um icone de acordo com a categoria
  Widget getIcone() {
    Widget? resultado;
    switch (icone) {
      case "garfo":
        resultado = const Icon(FontAwesomeIcons.utensils);
        break;
      case "futebol":
        resultado = const Icon(FontAwesomeIcons.football);
        break;
      case "arvore":
        resultado = const Icon(FontAwesomeIcons.tree);
        break;
      case "casa":
        resultado = const Icon(FontAwesomeIcons.building);
        break;
      case "cruz":
        resultado = const Icon(FontAwesomeIcons.kitMedical);
        break;
      case "escola":
        resultado = const Icon(FontAwesomeIcons.school);
        break;
      case "infra":
        resultado = const Icon(FontAwesomeIcons.buildingUser);
        break;
      case "todos":
        resultado = const Icon(FontAwesomeIcons.layerGroup);
        break;
      default:
        resultado = const Icon(FontAwesomeIcons.hashtag);
        break;
    }
    return resultado;
  }
}

Categoria categoriafromJson(Map<String, Object?> json) => Categoria(
      categoriaId: json['categoriaId'] as int,
      cor: json['cor'] as String,
      icone: json['icone'] as String,
      descricao: json['descricao'] as String,
      idiomaId: json['idiomaId'] as int,
    );

categoriaToJson(Categoria instance) => <String, Object?>{
      'categoriaId': instance.categoriaId,
      'descricao': instance.descricao,
      'cor': instance.cor,
      'icone': instance.icone,
      'idiomaId': instance.idiomaId,
    };

// Retorna uma lista de itesms do filtro de categoria
List<PopupMenuEntry<String>> getCatLista(List<Categoria> categorias) {
  return categorias.map((e) {
    return PopupMenuItem<String>(
      value: e.categoriaId.toString(),
      child: Row(
        children: [
          e.getIcone(),
          const SizedBox(width: 10),
          Text(e.descricao),
        ],
      ),
    );
  }).toList();
}

// Retorna uma lista de items do dropdown de categoria
List<DropdownMenuItem> getListaCatDropdown(List<Categoria> categorias) {
  return categorias.map((e) {
    return DropdownMenuItem(
      value: e.categoriaId.toString(),
      child: Row(
        children: [
          e.getIcone(),
          const SizedBox(width: 10),
          Text(e.descricao),
        ],
      ),
    );
  }).toList();
}

List<Categoria> categoriasTeste = [
  const Categoria(1, "Gastronomia", "cor1", "garfo"),
  const Categoria(2, "Desporto", "cor2", "futebol"),
  const Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
  const Categoria(4, "Alojamento", "cor3", "casa"),
  const Categoria(5, "Saúde", "cor3", "cruz"),
  const Categoria(6, "Ensino", "cor3", "escola"),
  const Categoria(7, "Infraestruturas", "cor3", "infra"),
  const Categoria(0, "Todas", "corTodas", "todos"),
];
