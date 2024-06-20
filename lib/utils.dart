import 'dart:convert';
import 'package:http/http.dart' as http;

// Função que converte uma imagem de um URL para base64
Future<String?> convertImageUrlToBase64(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return base64Encode(bytes);
    } else {
      throw Exception('Erro ao carregar imagem');
    }
  } catch (e) {
    print('Erro ao converter para base64: $e');
    return null;
  }
}
