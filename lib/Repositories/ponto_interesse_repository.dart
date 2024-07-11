import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/services/api_service.dart';

class PontoInteresseRepository {
  final ApiService _apiService = ApiService();

  Future<PontoInteresse> getPoiById(int poiId) async {
    _apiService.setAuthToken("tokenFixo");

    try {
      final response =
          await _apiService.getRequest("pontointeresse/$poiId/mobile");

      if (response != null && response['data'] != null) {
        final poiData = response['data'] as Map<String, dynamic>;

        return PontoInteresse.fromJson(poiData);
      } else {
        throw Exception('Falha ao carregar ponto de interesse');
      }
    } catch (e) {
      print('Erro ao buscar ponto de interesse: $e');
      throw Exception('Erro ao buscar ponto de interesse');
    }
  }
}
