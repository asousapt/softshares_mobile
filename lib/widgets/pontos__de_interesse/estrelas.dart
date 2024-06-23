import 'package:flutter/material.dart';

class EstrelasRating extends StatelessWidget {
  final double rating;

  EstrelasRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: criarEstrelas(),
    );
  }

  List<Widget> criarEstrelas() {
    // Garantir que a classificação esteja dentro do intervalo de 0 a 5
    if (rating < 0 || rating > 5) {
      return <Widget>[const Text("Erro nos ratings, valor inválido(<0 ou 5<)")];
    }

    List<Widget> estrelas = [];

    // Número de estrelas cheias
    int estrelasCheias = rating.floor();
    // Verificar se há meia estrela
    bool temMeiaEstrela = (rating - estrelasCheias) >= 0.5;

    // Adicionar estrelas cheias
    for (int i = 0; i < estrelasCheias; i++) {
      estrelas.add(const Icon(
        Icons.star,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    // Adicionar meia estrela, se aplicável
    if (temMeiaEstrela) {
      estrelas.add(const Icon(
        Icons.star_half,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    // Adicionar estrelas vazias restantes
    int estrelasVazias = 5 - estrelas.length;
    for (int i = 0; i < estrelasVazias; i++) {
      estrelas.add(const Icon(
        Icons.star_border,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    return estrelas;
  }
}
