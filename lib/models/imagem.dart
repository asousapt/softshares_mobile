import 'package:path/path.dart';

class Imagem {
  String nome;
  String base64;
  int tamanho;
  String? url;

  Imagem({
    required this.nome,
    required this.base64,
    required this.tamanho,
    this.url,
  });

  // Imagem from JSON
  factory Imagem.fromJson(Map<String, dynamic> json) {
    return Imagem(
      nome: json['name'],
      base64: json['url'],
      tamanho: json['size'],
      url: json['url'],
    );
  }

  // Imagem to JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'base64': base64,
      'tamanho': tamanho,
    };
  }

  // Retorna o url da imagem
  String getFotoUrl() {
    return url ?? '';
  }
}
