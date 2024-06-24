import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:softshares_mobile/models/imagem.dart';

// Função que converte uma imagem de um URL para base64
Future<Imagem?> convertImageUrlToBase64(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final fileName = path.basename(imageUrl);
      final finalFileName = fileName.split('?').first;

      return Imagem(
        nome: fileName,
        base64: base64Encode(bytes),
        tamanho: bytes.length,
      );
    } else {
      throw Exception('Erro ao carregar imagem');
    }
  } catch (e) {
    print('Erro ao converter para base64: $e');
    return null;
  }
}
