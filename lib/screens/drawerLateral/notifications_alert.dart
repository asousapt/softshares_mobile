import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/alerta_repository.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/Repositories/notificacao_repository.dart';
import 'package:softshares_mobile/Repositories/ponto_interesse_repository.dart';
import 'package:softshares_mobile/Repositories/topico_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/screens/eventos/consultar_evento.dart';
import 'package:softshares_mobile/screens/pontos_interesse/consultar_ponto_interesse.dart';
import 'package:softshares_mobile/screens/topicos/topico_details.dart';
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
  List<Notificacao> listaNotificacoes = [];
  List<Alerta> listaAlertas = [];
  String titulo = "";
  bool isLoading = false;
  late String idioma;
  late int idiomaId;

  @override
  void initState() {
    super.initState();
    getAlertasNots();
  }

  Future<void> getAlertasNots() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    idioma = prefs.getString("idioma") ?? "pt";
    idiomaId = prefs.getInt("idiomaId") ?? 1;
    AlertaRepository alertaRepository = AlertaRepository();
    listaAlertas = await alertaRepository.getAlertas();

    NotificacaoRepository notificacaoRepository = NotificacaoRepository();
    listaNotificacoes = await notificacaoRepository.getNotificacoes();

    setState(() {
      isLoading = false;
    });
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).canvasColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                  right: 12, left: 12, top: 10, bottom: 20),
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
                              listaNotificacoes.isEmpty
                                  ? Container(
                                      color: Theme.of(context).canvasColor,
                                      child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .naoHaDados),
                                      ),
                                    )
                                  : ListView(
                                      children: listaNotificacoes.map((e) {
                                        return Dismissible(
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              alignment: Alignment.centerRight,
                                              color: Colors.red,
                                              child: const Icon(
                                                size: 32,
                                                FontAwesomeIcons.trash,
                                                color: Colors.white,
                                              ),
                                            ),
                                            key: ValueKey<int>(e.notificacaoId),
                                            onDismissed: (direction) async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              NotificacaoRepository
                                                  notificacaoRepository =
                                                  NotificacaoRepository();
                                              bool sucesso =
                                                  await notificacaoRepository
                                                      .marcarNotificacaoComoVista(
                                                          e.notificacaoId);
                                              if (!sucesso) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .ocorreuErro),
                                                  ),
                                                );
                                              }
                                              setState(() {
                                                isLoading = false;
                                                listaNotificacoes.remove(e);
                                              });
                                            },
                                            // AREA DE NOTIFICACOES
                                            child: InkWell(
                                              onTap: () async {
                                                List<Categoria> categorias = [];
                                                CategoriaRepository
                                                    categoriaRepository =
                                                    CategoriaRepository();
                                                categorias =
                                                    await categoriaRepository
                                                        .fetchCategoriasDB(
                                                            idiomaId);
                                                switch (e.tipo) {
                                                  case "EVENTO":
                                                    //navegar para o evento
                                                    EventoRepository
                                                        eventoRepository =
                                                        EventoRepository();
                                                    Evento evento =
                                                        await eventoRepository
                                                            .getEventobyId(
                                                                e.idregisto);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConsultEventScreen(
                                                            evento: evento,
                                                            categorias:
                                                                categorias,
                                                          ),
                                                        ));

                                                    break;
                                                  case "POI":
                                                    //navegar para o POI
                                                    PontoInteresseRepository
                                                        pontoInteresseRepository =
                                                        PontoInteresseRepository();
                                                    PontoInteresse poi =
                                                        await pontoInteresseRepository
                                                            .getPoiById(
                                                                e.idregisto);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConsultPontoInteresseScreen(
                                                          pontoInteresse: poi,
                                                        ),
                                                      ),
                                                    );

                                                    break;
                                                  case "THREAD":
                                                    TopicoRepository
                                                        topicoRepository =
                                                        TopicoRepository();
                                                    Topico topico =
                                                        await topicoRepository
                                                            .getTopicoByid(
                                                                e.idregisto);

                                                    //navegar para a thread
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TopicoDetailsScreen(
                                                          topico: topico,
                                                          categorias:
                                                              categorias,
                                                        ),
                                                      ),
                                                    );
                                                    break;
                                                  default:
                                                    break;
                                                }
                                              },
                                              child: NotificationCard(
                                                idioma: idioma,
                                                data: e.data,
                                                texto: e.notificacao,
                                                icone: const Icon(
                                                  FontAwesomeIcons.bell,
                                                  color: Color.fromRGBO(
                                                      77, 156, 250, 1),
                                                ),
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                              listaAlertas.isEmpty
                                  ? Container(
                                      color: Theme.of(context).canvasColor,
                                      child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .naoHaDados),
                                      ),
                                    )
                                  : ListView(
                                      // alertas
                                      children: listaAlertas.map((e) {
                                        return NotificationCard(
                                          idioma: idioma,
                                          data: e.datacriacao,
                                          texto: e.alerta,
                                          icone: const Icon(
                                            FontAwesomeIcons.lightbulb,
                                            color:
                                                Color.fromRGBO(77, 156, 250, 1),
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
