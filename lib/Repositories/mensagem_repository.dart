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

  Future<List<Mensagem>> getConversa(int mensagemId) async {
    apiService.setAuthToken("tokenFixo");

    var response =
        await apiService.getRequest("mensagens/lista/util/$mensagemId");

    var mensagensFormatted = response['data'] as List;

    List<Mensagem> mensagens =
        mensagensFormatted.map((e) => Mensagem.fromJson(e)).toList();

    return mensagens;
  }

  Future<List<Mensagem>> getConversaGr(int mensagemId) async {
    apiService.setAuthToken("tokenFixo");

    var response =
        await apiService.getRequest("mensagens/lista/grupo/$mensagemId");

    var mensagensFormatted = response['data'] as List;

    List<Mensagem> mensagens =
        mensagensFormatted.map((e) => Mensagem.fromJson(e)).toList();

    return mensagens;
  }

  Future<bool> enviarMensagem(Mensagem mensagem) async {
    apiService.setAuthToken("tokenFixo");
    Map<String, dynamic> mensagemJson = await mensagem.toJson();
    var response = await apiService.postRequest("mensagens/", mensagemJson);

    return response['data'] as bool;
  }
}
