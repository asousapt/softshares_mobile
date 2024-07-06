import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/services/api_service.dart';

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

Future<Imagem?> downloadImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();

      // Clean up the URL to get a proper file name without query parameters
      final uri = Uri.parse(imageUrl);
      final fileName = path.basename(uri.path);

      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(bytes);

      return Imagem(
        nome: fileName,
        url: file.path,
        tamanho: bytes.length,
        base64: base64Encode(bytes),
      );
    } else {
      throw Exception('Erro ao carregar imagem');
    }
  } catch (e) {
    print('Erro ao converter para base64: $e');
    return null;
  }
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

// faz pedido para enviar email a API
Future<bool> envioEmail(String email, String assunto, String mensagem) async {
  try {
    ApiService apiService = ApiService();
    apiService.setAuthToken("tokenFixo");

    Map<String, dynamic> data = {
      'email': email,
      'assunto': assunto,
      'mensagem': mensagem,
    };

    var response = apiService.postRequest('enviar', data);
    bool enviou = response as bool;

    return enviou;
  } catch (e) {
    print('Erro ao enviar email: $e');
    return false;
  }
}
