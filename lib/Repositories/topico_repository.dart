import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/services/api_service.dart';

class TopicoRepository {
  final ApiService _apiService = ApiService();

  Future<List<Topico>> getTopicos() async {
    _apiService.setAuthToken("tokenFixo");

    try {
      final response = await _apiService.getRequest("thread/mobile");

      if (response != null && response['data'] != null) {
        final topicosData = response['data'] as List;
        return topicosData.map((e) => Topico.fromJson(e)).toList();
      } else {
        throw Exception('Falha ao carregar tópicos');
      }
    } catch (e) {
      print('Erro ao buscar tópicos: $e');
      throw Exception('Erro ao buscar tópicos');
    }
  }
}
