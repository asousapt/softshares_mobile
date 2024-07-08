import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/services/api_service.dart';

class GrupoRepository {
  ApiService apiService = ApiService();

  Future<bool> createGrupo(Grupo grupo) async {
    apiService.setAuthToken("tokenFixo");
    var response = await apiService.postRequest("grupo/add", grupo.toJson());

    bool resultado = response['data'] as bool;

    return resultado;
  }
}
