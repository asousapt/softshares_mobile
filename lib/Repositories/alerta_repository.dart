import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/alertas.dart';
import 'package:softshares_mobile/services/api_service.dart';

class AlertaRepository {
  final ApiService _apiService = ApiService();

  Future<List<Alerta>> getAlertas() async {
    final prefs = await SharedPreferences.getInstance();
    int poloId = prefs.getInt("poloId") ?? 1;
    int idiomaId = prefs.getInt("idiomaId") ?? 1;

    _apiService.setAuthToken("tokenFixo");
    final url = "alerta/polo/$poloId/idioma/$idiomaId";
    final response = await _apiService.getRequest(url);
    final alertasformatted = response['data'];

    if (alertasformatted != null) {
      return (alertasformatted as List)
          .map((item) => Alerta.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}
