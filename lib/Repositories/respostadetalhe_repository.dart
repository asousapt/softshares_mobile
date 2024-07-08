import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:softshares_mobile/services/api_service.dart';

class RespostaDetalheRepository {
  final ApiService _apiService = ApiService();

  // busca a respostas para um formulario de um utilizador
  Future<List<RespostaDetalhe>> getRespostasDetalhe(
      int registoId, String tabela, int formId, int utilizadorId) async {
    _apiService.setAuthToken("tokenFixo");
    try {
      final String url =
          "formulario/$formId/tabela/$tabela/utilizador/$utilizadorId/registo/$registoId";
      final response = await _apiService.getRequest(url);
      final respostasFormatted = response['data'] as List;

      if (respostasFormatted.isEmpty) {
        return [];
      } else {
        return respostasFormatted
            .map((e) => RespostaDetalhe.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // busca as respostas de todos os utilizadores para um formulario
  Future<List<RespostaDetalhe>> getRespostasTodos(
      int registoId, String tabela, int formId) async {
    _apiService.setAuthToken("tokenFixo");
    try {
      final String url = "formulario/$formId/tabela/$tabela/registo/$registoId";
      final response = await _apiService.getRequest(url);
      final respostasFormatted = response['data'] as List;

      if (respostasFormatted.isEmpty) {
        return [];
      } else {
        return respostasFormatted
            .map((e) => RespostaDetalhe.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // agrupa respostas da mesma pergunta
  List<RespostaDetalhe> groupRespostas(List<RespostaDetalhe> respostas) {
    Map<int, Map<String, dynamic>> groupedRespostas = {};

    for (var respostaDetalhe in respostas) {
      if (!groupedRespostas.containsKey(respostaDetalhe.perguntaId)) {
        groupedRespostas[respostaDetalhe.perguntaId] = {
          'pergunta': respostaDetalhe.pergunta,
          'respostas': [],
        };
      }
      groupedRespostas[respostaDetalhe.perguntaId]!['respostas']
          .add(respostaDetalhe.resposta);
    }

    List<RespostaDetalhe> combinedRespostas = [];

    groupedRespostas.forEach((perguntaId, data) {
      Pergunta? pergunta = data['pergunta'];
      List<String> respostasList = List<String>.from(data['respostas']);

      combinedRespostas.add(RespostaDetalhe(
        perguntaId: perguntaId,
        pergunta: pergunta,
        resposta: respostasList.join(', '),
      ));
    });

    return combinedRespostas;
  }
}
