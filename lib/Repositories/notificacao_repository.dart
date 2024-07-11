import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/notificacaoPref_repository.dart';
import 'package:softshares_mobile/models/notificacoes.dart';
import 'package:softshares_mobile/models/notification_preference.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';

class NotificacaoRepository {
  final ApiService _apiService = ApiService();

  Future<List<Notificacao>> getNotificacoes() async {
    List<Notificacao> listaFinal = [];
    List<Notificacao> listaNotif = [];
    NotificationPreferenceRepository _notificationPreferenceRepository =
        NotificationPreferenceRepository();

    //List<NotificationPreference> listaPref =
    // await _notificationPreferenceRepository
    //   .fetchLocalNotificationPreferences();
    /*for (var preferencias in listaPref) {
      print(preferencias.type);
      print(preferencias.enabled);
    }*/

    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;
    _apiService.setAuthToken("tokenFixo");

    final url = "notificacao/utilizador/$utilizadorId/naolidas";
    final response = await _apiService.getRequest(url);
    final notificacoesFormatted = response['data'];

    if (notificacoesFormatted != null) {
      listaNotif = (notificacoesFormatted as List)
          .map((item) => Notificacao.fromJson(item))
          .toList();
    }

    return listaFinal;
  }

  Future<bool> marcarNotificacaoComoVista(int notificacaoId) async {
    _apiService.setAuthToken("tokenFixo");

    final url = "notificacao/lida/$notificacaoId";
    var response = await _apiService.putRequest(url, {});

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }
}
