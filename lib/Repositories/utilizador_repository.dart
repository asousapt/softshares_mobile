import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class UtilizadorRepository {
  ApiService apiService = ApiService();

  Future<Utilizador> getUtilizador(String id) async {
    apiService.setAuthToken("tokenFixo");
    try {
      var response = await apiService.getRequest('utilizadores/mobile/$id');

      final utilizadoresFormatted = response['data'];

      if (utilizadoresFormatted != null) {
        return Utilizador.fromJson(utilizadoresFormatted);
      } else {
        throw Exception('Failed to load utilizador');
      }
    } catch (e) {
      throw Exception('Failed to load utilizador: $e');
    }
  }
}
