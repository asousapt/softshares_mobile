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
    NotificationPreferenceRepository notificationPreferenceRepository =
        NotificationPreferenceRepository();

    List<NotificationPreference> listaPref =
        await notificationPreferenceRepository.getPrefsUtil();

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

    // filtra o tipo de notificação que o utilizador quer receber
    for (var notif in listaNotif) {
      for (var pref in listaPref) {
        if (notif.tipo == pref.type) {
          if (pref.enabled) {
            listaFinal.add(notif);
          }
        }
      }
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

  Future<int> getNmrNotificacoes() async {
    List<Notificacao> listaNotif = [];
    NotificationPreferenceRepository notificationPreferenceRepository =
        NotificationPreferenceRepository();
    int numeroNotificacoes = 0;

    List<NotificationPreference> listaPref =
        await notificationPreferenceRepository.getPrefsUtil();

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

    // filtra o tipo de notificação que o utilizador quer receber
    for (var notif in listaNotif) {
      for (var pref in listaPref) {
        if (notif.tipo == pref.type) {
          if (pref.enabled) {
            numeroNotificacoes++;
          }
        }
      }
    }

    return numeroNotificacoes;
  }
}
