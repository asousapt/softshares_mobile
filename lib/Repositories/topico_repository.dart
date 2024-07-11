import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/services/api_service.dart';

class TopicoRepository {
  final ApiService _apiService = ApiService();

  Future<List<Topico>> getTopicos() async {
    _apiService.setAuthToken("tokenFixo");

    try {
      final prefs = await SharedPreferences.getInstance();
      int poloid = prefs.getInt('poloId') ?? 1;

      final response = await _apiService.getRequest("thread/mobile/$poloid");

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

  Future<void> criarTopico(Topico topico) async {
    final prefs = await SharedPreferences.getInstance();
    int poloid = prefs.getInt('poloId') ?? 1;
    topico.poloid = poloid;

    _apiService.setAuthToken("tokenFixo");
    final response =
        await _apiService.postRequest("thread/add/", topico.toJsonCriar());
  }

  // Busca um tópico pelo id
  Future<Topico> getTopicoByid(int topicoId) async {
    _apiService.setAuthToken("tokenFixo");

    try {
      final response = await _apiService.getRequest("thread/$topicoId/mobile");

      if (response != null && response['data'] != null) {
        final topicosData = response['data'];

        return Topico.fromJson(topicosData);
      } else {
        throw Exception('Falha ao carregar tópico');
      }
    } catch (e) {
      print('Erro ao buscar tópico: $e');
      throw Exception('Erro ao buscar tópico');
    }
  }
}
