import 'package:flutter/material.dart';

class Subcategoria {
  final int subcategoriaId;
  final int categoriaId;
  final String descricao;

  const Subcategoria(
    this.subcategoriaId,
    this.categoriaId,
    this.descricao,
  );
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
