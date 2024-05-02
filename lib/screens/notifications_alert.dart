import 'package:flutter/material.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/models/notificacoes.dart';
import 'package:softshares_mobile/models/alertas.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/notificacoes/notification_item.dart';

class NotificationsAlertScreen extends StatefulWidget {
  const NotificationsAlertScreen({super.key});

  @override
  State<NotificationsAlertScreen> createState() {
    return _NotificationsAlertScreenState();
  }
}

class _NotificationsAlertScreenState extends State<NotificationsAlertScreen> {
  List<Notificacao>? listaNotificacoes;
  List<Alerta>? listaAlertas;

  @override
  void initState() {
    super.initState();
    listaNotificacoes = [
      Notificacao(1, 'Nova mensagem recebida', false),
      Notificacao(2, 'Você tem uma nova solicitação de amizade', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
      Notificacao(3, 'Novo evento agendado para amanhã', false),
    ];

    listaAlertas = [
      Alerta(1, "Alerta 1"),
      Alerta(2, "Alerta 2"),
      Alerta(3, "Alerta 3"),
      Alerta(4, "Alerta 4"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 0),
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.notificacoes}/"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: 12, left: 12, top: 10, bottom: 20),
        child: Container(
          color: Theme.of(context).canvasColor,
          child: DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: [
                    CustomTab(
                        icon: FontAwesomeIcons.bell,
                        text: AppLocalizations.of(context)!.notificacoes),
                    CustomTab(
                        icon: FontAwesomeIcons.lightbulb,
                        text: AppLocalizations.of(context)!.alertas),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        ListView(
                          children: listaNotificacoes!.map((e) {
                            return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                ),
                                key: ValueKey<int>(e.notificacaoId),
                                onDismissed: (direction) {
                                  print(e.notificacaoId);
                                },
                                child: NotificationCard(texto: e.notificacao));
                          }).toList(),
                        ),
                        ListView(
                          children: listaAlertas!.map((e) {
                            return ListTile(title: Text(e.alerta));
                          }).toList(),
                        ),
                      ],
                    ),
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
