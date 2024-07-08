import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/departamento_repository.dart';
import 'package:softshares_mobile/Repositories/funcao_repositry.dart';
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

  // Update utilizador
  Future<int> updateUtilizador(Utilizador utilizador) async {
    apiService.setAuthToken("tokenFixo");

    print(utilizador.toJsonEnvio());
    try {
      String caminho =
          "utilizadores/update/mobile/${utilizador.utilizadorId.toString()}";
      var response =
          await apiService.putRequest(caminho, utilizador.toJsonEnvio());

      if (int.parse(response['data']) > 0) {
        return int.parse(response['data']);
      } else {
        throw Exception('Failed to update utilizador');
      }
    } catch (e) {
      throw Exception('Failed to update utilizador: $e');
    }
  }

  Future<String> getutilizadorDescricao(Utilizador utilizador) async {
    String descricao = "";
    final prefs = await SharedPreferences.getInstance();
    int idiomaId = prefs.getInt('idiomaId') ?? 1;
    try {
      DepartamentoRepository departamentoRepository = DepartamentoRepository();
      var departamento =
          await departamentoRepository.getDepartamentoByIdAndIdioma(
        utilizador.departamentoId!,
        idiomaId,
      );
      FuncaoRepository funcaoRepository = FuncaoRepository();
      var funcao = await funcaoRepository.getFuncaoByIdAndIdioma(
          utilizador.funcaoId!, idiomaId);

      descricao = "$departamento - $funcao";
    } catch (e) {
      print('Erro ao buscar departamento: $e');
      return descricao;
    }

    return descricao;
  }

  Future<List<Utilizador>> getUtilizadoresSimplificado() async {
    apiService.setAuthToken("tokenFixo");
    try {
      var response = await apiService.getRequest('utilizadores/listas');

      final utilizadoresFormatted = response['data'] as List;

      return utilizadoresFormatted
          .map((e) => Utilizador.fromJsonSimplificado(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load utilizadores: $e');
    }
  }
}
