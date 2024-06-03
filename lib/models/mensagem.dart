import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Mensagem {
  int? mensagemId;
  String mensagemTexto;
  Utilizador remetente;
  Utilizador? destinatarioUtil;
  Grupo? destinatarioGrupo;
  bool? vista = false;
  DateTime dataEnvio;
  List<String> anexos = [];

  Mensagem({
    this.mensagemId,
    required this.mensagemTexto,
    required this.remetente,
    this.destinatarioUtil,
    this.destinatarioGrupo,
    required this.dataEnvio,
    required this.anexos,
    this.vista,
  });
}
