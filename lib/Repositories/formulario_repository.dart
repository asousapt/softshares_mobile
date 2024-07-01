import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/services/api_service.dart';

class FormularioRepository {
  final ApiService _apiService = ApiService();

  Future<Formulario> getFormulariobyId(int formid) async {
    _apiService.setAuthToken("tokenFixo");
    final url = "evento/form/$formid";

    try {
      final response = await _apiService.getRequest(url);
      if (response['data'] != null) {
        return Formulario.fromJson(response['data']);
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (error) {
      print('Error fetching the form: $error');
      rethrow;
    }
  }
}
