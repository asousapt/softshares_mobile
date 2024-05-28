import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/mensagens/mensagem_item.dart';

class MensagensMainScreen extends StatefulWidget {
  const MensagensMainScreen({super.key});

  @override
  State<MensagensMainScreen> createState() {
    return _MensagensMainScreenState();
  }
}

class _MensagensMainScreenState extends State<MensagensMainScreen> {
  List<Mensagem> dummyMessages = [
    Mensagem(
      mensagemId: 1,
      mensagemTexto: 'Hello John!',
      remetente: Utilizador(1, 'Alice', 'Johnson', 'alice.johnson@example.com',
          'Some info', 1, [1, 2], 1, 1),
      destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
          'Some info', 1, [1, 2], 1, 1),
      dataEnvio: DateTime.now().subtract(Duration(days: 1)),
      anexos: [],
    ),
    Mensagem(
      mensagemId: 2,
      mensagemTexto: 'Meeting at 5 PM',
      remetente: Utilizador(1, 'Alice', 'Johnson', 'alice.johnson@example.com',
          'Some info', 1, [1, 2], 1, 1),
      destinatarioGrupo: Grupo(
        grupoId: 1,
        descricao: 'Team Meeting',
        subcategoria: Subcategoria(1, 1, 'Meeting'),
        utilizadores: [
          Utilizador(1, 'Alice', 'Johnson', 'alice.johnson@example.com',
              'Some info', 1, [1, 2], 1, 1),
          Utilizador(2, 'John', 'Doe', 'john.doe@example.com', 'Some info', 1,
              [1, 2], 1, 1)
        ],
        publico: false,
      ),
      dataEnvio: DateTime.now().subtract(Duration(days: 2)),
      anexos: [],
    ),
    // Add more dummy messages as needed
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(seleccao: 4),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.messages),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.02),
          child: Container(
            color: Theme.of(context).canvasColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: dummyMessages.length,
                    itemBuilder: (context, index) {
                      return MensagemItem(mensagem: dummyMessages[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
