import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class GrupoRepository {
  ApiService apiService = ApiService();

  Future<bool> createGrupo(Grupo grupo) async {
    apiService.setAuthToken("tokenFixo");
    var response = await apiService.postRequest("grupo/add", grupo.toJson());

    bool resultado = response['data'] as bool;

    return resultado;
  }

  // vai a API buscar os grupos onde o utilizador nao pertence
  Future<List<Grupo>> getGrupos() async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    apiService.setAuthToken("tokenFixo");
    var response = await apiService.getRequest("grupo/publicos/$utilizadorId");

    var gruposFormatted = response['data'] as List;

    List<Grupo> grupos = gruposFormatted.map((e) => Grupo.fromJson(e)).toList();

    return grupos;
  }

  Future<void> aderirGrupo(int grupoId) async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    apiService.setAuthToken("tokenFixo");
    var response = await apiService.postRequest("grupo/juntar", {
      "grupoid": grupoId,
      "utilizadorid": utilizadorId,
    });
  }

  //Obtem a informacao do grupo atraves do id
  Future<Grupo?> getGrupo(int grupoId) async {
    apiService.setAuthToken("tokenFixo");
    try {
      var response = await apiService.getRequest("grupo/$grupoId");
      if (response['data'] != null) {
        print(response['data'][0]);
        var grupoFormatted = response['data'][0] as Map<String, dynamic>;
        Grupo grupo = Grupo.fromJson(grupoFormatted);

        return grupo;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
