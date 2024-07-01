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
      nome: json['name'] ?? json['nome'],
      url: json['url'],
      tamanho: json['size'] ?? json['tamanho'],
      base64: "",
    );
  }

  // Imagem to JSON
  Map<String, dynamic> toJson() {
    String uriBase64 = "data:image/jpeg;base64,$base64";
    return {
      'nome': nome,
      'base64': uriBase64,
      'tamanho': tamanho,
    };
  }

  // Retorna o url da imagem
  String getFotoUrl() {
    return url ?? '';
  }
}
