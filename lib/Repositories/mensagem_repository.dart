import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class MensagemRepository {
  ApiService apiService = ApiService();

  Future<List<Mensagem>> getMensagensMain() async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    apiService.setAuthToken("tokenFixo");
    var response = await apiService.getRequest("mensagens/lista/$utilizadorId");

    var mensagensFormatted = response['data'] as List;

    List<Mensagem> mensagens =
        mensagensFormatted.map((e) => Mensagem.fromJson(e)).toList();

    return mensagens;
  }
}
