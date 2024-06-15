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
  factory Subcategoria.fromJson(Map<String, dynamic> json) {
    return Subcategoria(
      json['subcategoriaid'],
      json['categoriaid'],
      json['valoren'],
    );
  }
}

List<Subcategoria> subcategoriasTeste = [
    // Subcategories for "Gastronomia" category
    const Subcategoria(1, 1, "Comida italiana"),
    const Subcategoria(2, 1, "Comida mexicana"),
    const Subcategoria(3, 1, "Comida japonesa"),

    // Subcategories for "Desporto" category
    const Subcategoria(4, 2, "Futebol"),
    const Subcategoria(5, 2, "Basquetebol"),
    const Subcategoria(6, 2, "Ténis"),

    // Subcategories for "Atividade Ar Livre" category
    const Subcategoria(7, 3, "Caminhada"),
    const Subcategoria(8, 3, "Ciclismo"),

    // Subcategories for "Alojamento" category
    const Subcategoria(9, 4, "Hotel"),
    const Subcategoria(10, 4, "Hostel"),
    const Subcategoria(11, 4, "Apartamento"),

    // Subcategories for "Saúde" category
    const Subcategoria(12, 5, "Médico geral"),
    const Subcategoria(13, 5, "Dentista"),
    const Subcategoria(14, 5, "Fisioterapia"),

    // Subcategories for "Ensino" category
    const Subcategoria(15, 6, "Escola primária"),
    const Subcategoria(16, 6, "Escola secundária"),
    const Subcategoria(17, 6, "Universidade"),

    // Subcategories for "Infraestruturas" category
    const Subcategoria(18, 7, "Transporte público"),
    const Subcategoria(19, 7, "Estradas"),
    const Subcategoria(20, 7, "Rede de água e saneamento"),
  ];

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
