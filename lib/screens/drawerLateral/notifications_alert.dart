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
  String titulo = "";

  @override
  void initState() {
    super.initState();
    listaNotificacoes = [
      Notificacao(1, 'Nova mensagem recebida', false),
      Notificacao(
          2,
          'Você tem uma nova solicitação de amizade trhrt h btrhntrvhb rrt vnhjtrhnt hbtrhv btrhvbr',
          false),
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
        title: Text(
            "${AppLocalizations.of(context)!.notificacoes} / ${AppLocalizations.of(context)!.alertas}"),
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
                                  padding: const EdgeInsets.only(right: 10),
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child: const Icon(
                                    size: 32,
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                  ),
                                ),
                                key: ValueKey<int>(e.notificacaoId),
                                onDismissed: (direction) {
                                  // vai invocar o méroto que marca como lida a notificação
                                },
                                child: NotificationCard(
                                  texto: e.notificacao,
                                  icone: const Icon(
                                    FontAwesomeIcons.bell,
                                    color: Color.fromRGBO(77, 156, 250, 1),
                                  ),
                                ));
                          }).toList(),
                        ),
                        ListView(
                          children: listaAlertas!.map((e) {
                            return NotificationCard(
                              texto: e.alerta,
                              icone: const Icon(
                                FontAwesomeIcons.lightbulb,
                                color: Color.fromRGBO(77, 156, 250, 1),
                              ),
                            );
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
