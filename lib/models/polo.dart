import 'package:flutter/material.dart';

class Polo {
  final int poloid;
  final String descricao;
  final String coordenador;
  final String cidade;
  final int cidadeid;

  Polo({
    required this.poloid,
    required this.descricao,
    required this.coordenador,
    required this.cidade,
    required this.cidadeid,
  });

  factory Polo.fromJson(Map<String, dynamic> json) {
    return Polo(
      poloid: json['poloid'],
      descricao: json['descricao'],
      coordenador: json['coordenador'],
      cidade: json['cidade'],
      cidadeid: json['cidadeid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poloid': poloid,
      'descricao': descricao,
      'coordenador': coordenador,
      'cidade': cidade,
      'cidadeid': cidadeid,
    };
  }
}

List<DropdownMenuItem> getListaPoloDropdown(List<Polo> funcoes) {
  return funcoes.map((e) {
    return DropdownMenuItem(
      value: e.poloid.toString(),
      child: Text(e.descricao),
    );
  }).toList();
}
