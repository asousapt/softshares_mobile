class Idioma {
  final int id;
  final String nome;
  final String icone;

  const Idioma(
    this.id,
    this.nome,
    this.icone,
  );
}

// Busca os idiomas disponíveis da API
Future<List<Idioma>> fetchIdiomas() async {
  await Future.delayed(Duration(seconds: 2));

  return [
    Idioma(1, 'Português', '🇵🇹'),
    Idioma(2, 'Inglês', '🇬🇧'),
    Idioma(4, 'Espanhol', '🇪🇸'),
  ];
}

// Transforma um json num idioma
Idioma jsonToIdioma(Map<String, dynamic> json) {
  return Idioma(
    json['id'],
    json['nome'],
    json['icone'],
  );
}
