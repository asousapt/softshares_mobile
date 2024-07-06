import 'package:flutter/material.dart';

class Departamento {
  final int departamentoId;
  final String descricao;
  final int idiomaId;

  const Departamento(
    this.departamentoId,
    this.descricao,
    this.idiomaId,
  );

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      json['departamentoId'] as int,
      json['descricao'] as String,
      json['idiomaId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departamentoId': departamentoId,
      'descricao': descricao,
      'idiomaId': idiomaId,
    };
  }
}

List<DropdownMenuItem> getListaDepDropdown(List<Departamento> departamentos) {
  return departamentos.map((e) {
    return DropdownMenuItem(
      value: e.departamentoId.toString(),
      child: Text(e.descricao),
    );
  }).toList();
}
