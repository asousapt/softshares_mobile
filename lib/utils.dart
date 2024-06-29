import 'dart:convert';
import 'package:camera/camera.dart';
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

Future<List<Imagem>> convertListXfiletoImagem(List<XFile> xFiles) async {
  List<Imagem> imagens = [];

  for (XFile xFile in xFiles) {
    final bytes = await xFile.readAsBytes();
    final base64String = base64Encode(bytes);
    final nome = path.basename(xFile.path);
    final tamanho = bytes.length;

    imagens.add(
      Imagem(
        nome: nome,
        base64: base64String,
        tamanho: tamanho,
      ),
    );
  }

  return imagens;
}

// Função que converte uma lista de objetos para JSON
List<Map<String, dynamic>> toJsonList<T>(
    List<T>? items, Map<String, dynamic> Function(T) toJsonFunction) {
  List<Map<String, dynamic>> itemList = [];
  if (items != null) {
    for (T item in items) {
      itemList.add(toJsonFunction(item));
    }
  }
  return itemList;
}
