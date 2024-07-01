import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class RespostaDetalhe {
  final int perguntaId;
  final Pergunta? pergunta;
  final String resposta;
  final Utilizador? utilizador;

  RespostaDetalhe({
    required this.perguntaId,
    required this.resposta,
    this.pergunta,
    this.utilizador,
  });

  Map<String, dynamic> toJson() {
    return {
      'perguntaId': perguntaId,
      'pergunta': pergunta?.toJson(),
      'resposta': resposta,
      'utilizador': utilizador?.toJson(),
    };
  }

  static Future<List<RespostaDetalhe>> getRespostasDetalhe({
    required int utilizadorId,
    required int respostaFormId,
  }) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    List<RespostaDetalhe> dummyRespostas = [
      RespostaDetalhe(
        perguntaId: 1,
        resposta: 'John Doe',
        pergunta: Pergunta(
          detalheId: 1,
          pergunta: 'Qual é o seu nome?',
          tipoDados: TipoDados.textoLivre,
          obrigatorio: true,
          min: 0,
          max: 0,
          tamanho: 100,
          valoresPossiveis: [],
          ordem: 1,
        ),
      ),
      RespostaDetalhe(
        perguntaId: 2,
        resposta: '25',
        pergunta: Pergunta(
          detalheId: 2,
          pergunta: 'Qual é a sua idade?',
          tipoDados: TipoDados.numerico,
          obrigatorio: true,
          min: 1,
          max: 120,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 2,
        ),
      ),
      RespostaDetalhe(
        perguntaId: 3,
        resposta: 'true',
        pergunta: Pergunta(
          detalheId: 3,
          pergunta: 'É vegetariano?',
          tipoDados: TipoDados.logico,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 3,
        ),
      ),
      RespostaDetalhe(
        perguntaId: 4,
        resposta: 'Manhã',
        pergunta: Pergunta(
          detalheId: 4,
          pergunta: 'Escolha um horário',
          tipoDados: TipoDados.seleccao,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: ['Manhã', 'Tarde', 'Noite'],
          ordem: 4,
        ),
      ),
    ];

    return dummyRespostas;
  }

  // Obtem todas as respostas a determinado um formulário
  static Future<List<RespostaDetalhe>> getTodasRespostas({
    required int respostaFormId,
  }) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    List<RespostaDetalhe> dummyRespostas = [];
    /*RespostaDetalhe(
        perguntaId: 1,
        resposta: 'John Doe',
        pergunta: Pergunta(
          detalheId: 1,
          pergunta: 'Qual é o seu nome?',
          tipoDados: TipoDados.textoLivre,
          obrigatorio: true,
          min: 0,
          max: 0,
          tamanho: 100,
          valoresPossiveis: [],
          ordem: 1,
        ),
        utilizador: Utilizador(1, 'John', 'Doe', 'john.doe@example.com',
            'Sobre John', 1, [1, 2], 1, 1),
      ),
      RespostaDetalhe(
        perguntaId: 2,
        resposta: '25',
        pergunta: Pergunta(
          detalheId: 2,
          pergunta: 'Qual é a sua idade?',
          tipoDados: TipoDados.numerico,
          obrigatorio: true,
          min: 1,
          max: 120,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 2,
        ),
        utilizador: Utilizador(1, 'John', 'Doe', 'john.doe@example.com',
            'Sobre John', 1, [1, 2], 1, 1),
      ),
      RespostaDetalhe(
        perguntaId: 3,
        resposta: 'true',
        pergunta: Pergunta(
          detalheId: 3,
          pergunta: 'É vegetariano?',
          tipoDados: TipoDados.logico,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 3,
        ),
        utilizador: Utilizador(1, 'John', 'Doe', 'john.doe@example.com',
            'Sobre John', 1, [1, 2], 1, 1),
      ),
      RespostaDetalhe(
        perguntaId: 4,
        resposta: 'Manhã',
        pergunta: Pergunta(
          detalheId: 4,
          pergunta: 'Escolha um horário',
          tipoDados: TipoDados.seleccao,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: ['Manhã', 'Tarde', 'Noite'],
          ordem: 4,
        ),
        utilizador: Utilizador(1, 'John', 'Doe', 'john.doe@example.com',
            'Sobre John', 1, [1, 2], 1, 1),
      ),
      // Additional dummy responses from different users
      RespostaDetalhe(
        perguntaId: 1,
        resposta: 'Jane Smith',
        pergunta: Pergunta(
          detalheId: 1,
          pergunta: 'Qual é o seu nome?',
          tipoDados: TipoDados.textoLivre,
          obrigatorio: true,
          min: 0,
          max: 0,
          tamanho: 100,
          valoresPossiveis: [],
          ordem: 1,
        ),
        utilizador: Utilizador(2, 'Jane', 'Smith', 'jane.smith@example.com',
            'Sobre Jane', 2, [3, 4], 2, 2),
      ),
      RespostaDetalhe(
        perguntaId: 2,
        resposta: '30',
        pergunta: Pergunta(
          detalheId: 2,
          pergunta: 'Qual é a sua idade?',
          tipoDados: TipoDados.numerico,
          obrigatorio: true,
          min: 1,
          max: 120,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 2,
        ),
        utilizador: Utilizador(2, 'Jane', 'Smith', 'jane.smith@example.com',
            'Sobre Jane', 2, [3, 4], 2, 2),
      ),
      RespostaDetalhe(
        perguntaId: 3,
        resposta: 'false',
        pergunta: Pergunta(
          detalheId: 3,
          pergunta: 'É vegetariano?',
          tipoDados: TipoDados.logico,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 3,
        ),
        utilizador: Utilizador(2, 'Jane', 'Smith', 'jane.smith@example.com',
            'Sobre Jane', 2, [3, 4], 2, 2),
      ),
      RespostaDetalhe(
        perguntaId: 4,
        resposta: 'Tarde',
        pergunta: Pergunta(
          detalheId: 4,
          pergunta: 'Escolha um horário',
          tipoDados: TipoDados.seleccao,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: ['Manhã', 'Tarde', 'Noite'],
          ordem: 4,
        ),
        utilizador: Utilizador(2, 'Jane', 'Smith', 'jane.smith@example.com',
            'Sobre Jane', 2, [3, 4], 2, 2),
      ),
    ];*/

    return dummyRespostas;
  }
}
