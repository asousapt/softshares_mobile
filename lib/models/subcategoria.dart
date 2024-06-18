import 'package:flutter/material.dart';

class Subcategoria {
  final int subcategoriaId;
  final int categoriaId;
  final String descricao;
  final int idiomaId;

  const Subcategoria(
    this.subcategoriaId,
    this.categoriaId,
    this.descricao,
    this.idiomaId,
  );

  // Transforma um JSON em um objeto Subcategoria
  static Subcategoria subcategoriaFromJson(Map<String, dynamic> json) {
    return Subcategoria(
      json['subcategoriaId'],
      json['categoriaId'],
      json['descricao'],
      json['idiomaId'],
    );
  }

  // transforma um objeto Subcategoria em um JSON
  Map<String, dynamic> toJson() {
    return {
      'subcategoriaId': subcategoriaId,
      'categoriaId': categoriaId,
      'descricao': descricao,
      'idiomaId': idiomaId,
    };
  }
}

// Retorna uma lista de items do filtro de subcategoria
List<DropdownMenuItem<String>> getListaSubCatDropdown(
  List<Subcategoria> subcategorias,
  int categoriaId,
) {
  return subcategorias
      .where((e) => e.categoriaId == categoriaId)
      .map((e) => DropdownMenuItem(
            value: e.subcategoriaId.toString(),
            child: Text(e.descricao),
          ))
      .toList();
}
