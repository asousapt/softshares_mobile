import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class ComentarioRepository {
  ApiService api = ApiService();

  // carrega os comentarios passando apenas a entidade e o id do registo
  Future<List<Commentario>> fetchAllComentarios(
      String tabela, int idRegisto) async {
    try {
      api.setAuthToken("tokenFixo");
      final lista =
          await api.getRequest('comentario/tabela/$tabela/registo/$idRegisto');
      final listaFormatted = lista['data'] as List;
      return listaFormatted.map((e) => Commentario.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // adiciona de comentario
  Future<bool> addComentario(Commentario comentario, String tipo, int idRegisto,
      int comentarioPai) async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;
    try {
      api.setAuthToken("tokenFixo");
      final Map<String, dynamic> commentJson = {
        "tipo": tipo,
        "idRegisto": idRegisto,
        "utilizadorid": utilizadorId,
        "comentario": comentario.comentario,
        "comentarioPai": comentarioPai,
      };
      print("commentJson: $commentJson");
      final response = await api.postRequest('comentario/add', commentJson);

      return response['data'] as bool;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
