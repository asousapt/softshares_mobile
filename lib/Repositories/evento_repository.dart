import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';

class EventoRepository {
  final ApiService _apiService = ApiService();

  // busca todos os eventos disponiveis no polo num range de 6 meses
  Future<List<Evento>> getEventos() async {
    _apiService.setAuthToken("tokenFixo");
    final prefs = await SharedPreferences.getInstance();
    final poloId = prefs.getInt("poloId").toString();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;
    final DateTime now = DateTime.now();
    final DateTime firstDay = DateTime(now.year, now.month, now.day - 90);
    final DateTime lastDay = DateTime(now.year, now.month, now.day + 90);

    final url =
        "evento/$poloId/data/range/${firstDay.toIso8601String()}/${lastDay.toIso8601String()}/utilizador/${utilizadorId.toString()}";
    final response = await _apiService.getRequest(url);

    final eventosformattr = response['data'] as List;

    if (eventosformattr.isEmpty) {
      return [];
    } else {
      return eventosformattr.map((e) => Evento.fromJson(e)).toList();
    }
  }

  // busca todos os eventos disponiveis no polo num range de 365 dias antes e depois de determinada categoria
  Future<List<Evento>> getEventosBycat(int categoriaId) async {
    _apiService.setAuthToken("tokenFixo");
    final prefs = await SharedPreferences.getInstance();
    final poloId = prefs.getInt("poloId").toString();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;
    final DateTime now = DateTime.now();
    final DateTime firstDay = DateTime(now.year, now.month, now.day - 365);
    final DateTime lastDay = DateTime(now.year, now.month, now.day + 365);

    final url =
        "evento/$poloId/data/range/${firstDay.toIso8601String()}/${lastDay.toIso8601String()}/utilizador/${utilizadorId.toString()}/categoria/$categoriaId";
    final response = await _apiService.getRequest(url);

    final eventosformattr = response['data'] as List;

    if (eventosformattr.isEmpty) {
      return [];
    } else {
      return eventosformattr.map((e) => Evento.fromJson(e)).toList();
    }
  }

  // busca todos os eventos disponiveis no polo num range de 365 dias antes e depois de determinada categoria
  Future<List<Evento>> getEventosByStr(String pesquisa) async {
    _apiService.setAuthToken("tokenFixo");
    final prefs = await SharedPreferences.getInstance();
    final poloId = prefs.getInt("poloId").toString();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;
    final DateTime now = DateTime.now();
    final DateTime firstDay = DateTime(now.year, now.month, now.day - 365);
    final DateTime lastDay = DateTime(now.year, now.month, now.day + 365);

    final url =
        "evento/$poloId/data/range/${firstDay.toIso8601String()}/${lastDay.toIso8601String()}/utilizador/${utilizadorId.toString()}/filtro/$pesquisa";
    final response = await _apiService.getRequest(url);

    final eventosformattr = response['data'] as List;

    if (eventosformattr.isEmpty) {
      return [];
    } else {
      return eventosformattr.map((e) => Evento.fromJson(e)).toList();
    }
  }

  // Busca os eventos em que o utilizador esta inscrito
  Future<List<Evento>> getEventosInscritos(int utilizadorId) async {
    _apiService.setAuthToken("tokenFixo");
    final response =
        await _apiService.getRequest("evento/incricto/$utilizadorId");

    final eventosformattr = response['data'] as List;

    if (eventosformattr.isEmpty) {
      return [];
    } else {
      return eventosformattr.map((e) => Evento.fromJson(e)).toList();
    }
  }

  // cancelar inscricao do evento
  Future<void> cancelarInscricao(int eventoId, int utilizadorId) async {
    _apiService.setAuthToken("tokenFixo");
    final url = "evento/utilizador/delete/$eventoId/$utilizadorId";
    final response = await _apiService.deleteRequest(url);
  }

  // BUsca o evento peloID para edicao
  Future<Evento> obtemEvento(int eventoId) async {
    _apiService.setAuthToken("tokenFixo");
    final response = await _apiService.getRequest("evento/mobile/$eventoId");
    final eventoformattr = response['data'];

    return Evento.fromJsonEditar(eventoformattr);
  }

  // Pedido de insercao de um novo evento
  Future<void> criarEvento(Evento evento) async {
    _apiService.setAuthToken("tokenFixo");
    final response =
        await _apiService.postRequest("evento/add/", evento.toJsonCriar());
  }

  Future<void> editarEvento(Evento evento) async {
    _apiService.setAuthToken("tokenFixo");
    final String url = "evento/update/mobile/${evento.eventoId}";
    final response = await _apiService.putRequest(url, evento.toJsonEditar());
  }

  // Pedido de inscricao no evento
  Future<bool> inscreverEvento(Evento evento, List<RespostaDetalhe> respostas,
      int utilizadorId, int nmrConvidados) async {
    List<Map<String, dynamic>> respostasmap;
    if (respostas.isNotEmpty) {
      respostasmap = respostas.map((e) => e.toJsonCriar()).toList();
    } else {
      respostasmap = [];
    }
    _apiService.setAuthToken("tokenFixo");
    final response = await _apiService.postRequest("evento/inscricao",
        evento.toJsonInscricao(utilizadorId, nmrConvidados, respostasmap));

    if (response['data'] != null) {
      return true;
    } else {
      return false;
    }
  }

  // Responde ao formulario de qualidade do evento
  Future<bool> respostaFormQualidadeEvento(
    Evento evento,
    List<RespostaDetalhe> respostas,
    int utilizadorId,
  ) async {
    List<Map<String, dynamic>> respostasmap;
    if (respostas.isNotEmpty) {
      respostasmap = respostas.map((e) => e.toJsonCriar()).toList();
    } else {
      respostasmap = [];
    }

    _apiService.setAuthToken("tokenFixo");
    final response = await _apiService.postRequest("evento/formQualidade",
        evento.toJsonRespostaQualidade(utilizadorId, respostasmap));

    if (response['data'] != null) {
      return true;
    } else {
      return false;
    }
  }

  // pedido do formulario dinamico do evento
  Future<int> getFormId(Evento evento, String formType) async {
    _apiService.setAuthToken("tokenFixo");
    final url = "evento/${evento.eventoId}/form/$formType";

    try {
      final response = await _apiService.getRequest(url);
      if (response['data'] != null && response['data'] is int) {
        return response['data'] as int;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (error) {
      print('Error fetching form ID: $error');
      return 0;
    }
  }

  // Busca os utilizadores inscritos no evento
  Future<List<Utilizador>> getUtilizadoresInscritos(int eventoId) async {
    _apiService.setAuthToken("tokenFixo");
    final url = "evento/participantes/$eventoId";
    final response = await _apiService.getRequest(url);

    final utilizadoresformattr = response['data'] as List;

    if (utilizadoresformattr.isEmpty) {
      return [];
    } else {
      return utilizadoresformattr
          .map((e) => Utilizador.fromJsonSimplificado(e))
          .toList();
    }
  }

  // Faz o cancelamento do evento
  Future<void> cancelarEvento(int eventoId) async {
    _apiService.setAuthToken("tokenFixo");
    final url = "evento/cancelar/$eventoId";
    final response = await _apiService.putRequest(url, {});
  }

  // retorna os eventos de um dia especifico (usado no table_calendar)
  Map<DateTime, List<Evento>> getEventosMap(List<Evento> eventos) {
    final Map<DateTime, List<Evento>> eventSource = {};

    for (final event in eventos) {
      final eventDate = DateTime(
          event.dataInicio.year, event.dataInicio.month, event.dataInicio.day);
      if (eventSource[eventDate] == null) {
        eventSource[eventDate] = [];
      }
      eventSource[eventDate]!.add(event);
    }

    return eventSource;
  }

  // retorna os eventos de um dia especifico (usado no table_calendar)
  LinkedHashMap<DateTime, List<Evento>> getEventosLinkedHashMap(
      Map<DateTime, List<Evento>> eventSource) {
    return LinkedHashMap<DateTime, List<Evento>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventSource);
  }

  // usado no table_calendar
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // usado no table_calendar
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  // funcao que verifica se o utilizador pode inscrever-se no evento
  bool podeInscrever(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    if (evento.utilizadoresInscritos!.contains(utilizadorId)) {
      return false;
    }

    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if ((evento.dataLimiteInsc.isAfter(hoje) ||
        evento.dataLimiteInsc.isAtSameMomentAs(hoje))) {
      if (evento.numeroMaxPart == 0) {
        return true;
      } else if (evento.numeroInscritos < evento.numeroMaxPart) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // Verifica se o utilizador pode cancelar a inscricao no evento
  bool podeCancelarInscricao(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // utilizador nao pode cancelar se foi o criador do evento
    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    // o evento ja aconteceu
    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAtSameMomentAs(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        !evento.utilizadoresInscritos!.contains(utilizadorId)) {
      return false;
    }

    return true;
  }

  // Verifica se o evento pode ser cancelado pelo seu criador
  bool podeCancelarEvento(Evento evento, int utilizadorId) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        evento.utilizadorCriou == utilizadorId) {
      return true;
    }
    return false;
  }

  Future<bool> podeResponderQuestQualidade(
      Evento evento, int utilizadorId) async {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.cancelado == true) return false;

    int formId = 0;

    if (evento.dataFim.isBefore(hoje) &&
        evento.utilizadoresInscritos!.contains(utilizadorId)) {
      // vamos verificar se existe algum form de qualidade para o evento
      formId = await getFormId(evento, "QUALIDADE");

      if (formId != 0) {
        // vamos verificar se o utilizador ja respondeu ao form
        _apiService.setAuthToken("tokenFixo");
        final url =
            "formulario/respondeu/$formId/tabela/EVENTO/registo/${evento.eventoId}/utilizador/$utilizadorId";
        final response = await _apiService.getRequest(url);
        bool jarespondeu = response['data'] as bool;
        if (!jarespondeu) {
          return true;
        }
      }
    }

    return false;
  }
}
