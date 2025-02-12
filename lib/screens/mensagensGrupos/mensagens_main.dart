import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/mensagem_repository.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/nova_mensagem.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:softshares_mobile/widgets/mensagens/mensagem_item.dart';

class MensagensMainScreen extends StatefulWidget {
  const MensagensMainScreen({super.key});

  @override
  State<MensagensMainScreen> createState() {
    return _MensagensMainScreenState();
  }
}

class _MensagensMainScreenState extends State<MensagensMainScreen>
    with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  List<Mensagem> listaEvFiltrada = [];
  List<Mensagem> mensagens = [];
  Color containerColorMensagens = Colors.transparent;
  bool _isSearching = false;
  bool _isLoading = false;
  late String idioma;
  late int utilizadorId;

  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    var idiomaLocal = prefs.getString('idioma') ?? 'pt';
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorIdLocal = utilizador.utilizadorId;

    setState(() {
      utilizadorId = utilizadorIdLocal;
      idioma = idiomaLocal;
    });

    // Carregar mensagens
    MensagemRepository mensagemRepository = MensagemRepository();
    mensagens = await mensagemRepository.getMensagensMain();

    setState(() {
      listaEvFiltrada = mensagens;

      if (mensagens.isEmpty) {
        containerColorMensagens = Theme.of(context).canvasColor;
      } else {
        containerColorMensagens = Colors.transparent;
      }

      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // Refresh the data when coming back to this screen
    actualizaDados();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the route observer to be notified of route changes
    RouteObserver<ModalRoute<void>>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Unsubscribe from the route observer
    RouteObserver<ModalRoute<void>>().unsubscribe(this);
    _searchController.dispose();
    super.dispose();
  }

  // constroi o widget de pesquisa
  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        filtraPorTexto(value);
      },
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "${AppLocalizations.of(context)!.procurar}...",
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(FontAwesomeIcons.eraser),
          onPressed: () {
            setState(() {
              _searchController.clear();
              filtraPorTexto(
                  ''); // Clear the filter when clearing the search field
            });
          },
        ),
      ),
    );
  }

  // faz filtro por texto
  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      _isLoading = true;
    });

    listaEvFiltrada = mensagens.where((element) {
      String nomeDestlower =
          element.destinatarioUtil!.getNomeCompleto().toLowerCase();
      String nomeGrupo = element.destinatarioGrupo != null
          ? element.destinatarioGrupo!.nome.toLowerCase()
          : '';
      String nomeRemetenteLower =
          element.remetente!.getNomeCompleto().toLowerCase();

      bool matchesNomeDestlower = nomeDestlower.contains(texto);
      bool matchesNomeGrupo = nomeGrupo.contains(texto);
      bool matchesNomeRemetenteLower = nomeRemetenteLower.contains(texto);

      return matchesNomeDestlower ||
          matchesNomeGrupo ||
          matchesNomeRemetenteLower;
    }).toList();

    if (listaEvFiltrada.isEmpty) {
      containerColorMensagens = Theme.of(context).canvasColor;
    } else {
      containerColorMensagens = Colors.transparent;
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchController.clear();
              filtraPorTexto(''); // Clear the filter when closing the search
            }
          });
        },
        icon: Icon(_isSearching ? Icons.close : Icons.search),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            final refresh = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NovaMensagem(
                  mensagens: mensagens,
                ),
              ),
            );
          },
          child: const Icon(
            FontAwesomeIcons.plus,
            color: Color.fromRGBO(217, 215, 215, 1),
          ),
        ),
        bottomNavigationBar: const BottomNavigation(seleccao: 4),
        appBar: AppBar(
          title: _isSearching
              ? _buildSearchField()
              : Text(AppLocalizations.of(context)!.messages),
          actions: _buildAppBarActions(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.02),
          child: Container(
            height: altura * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              itemCount: listaEvFiltrada.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    // Navegar para a página de detalhes da mensagem e aguardar o resultado
                    final result = await Navigator.pushNamed(
                      context,
                      '/mensagem_detalhe',
                      arguments: {
                        'mensagemId': listaEvFiltrada[index].mensagemId,
                        'nome': listaEvFiltrada[index].destinatarioGrupo != null
                            ? listaEvFiltrada[index].destinatarioGrupo!.nome
                            : listaEvFiltrada[index]
                                        .destinatarioUtil!
                                        .utilizadorId !=
                                    utilizadorId
                                ? listaEvFiltrada[index]
                                    .destinatarioUtil!
                                    .getNomeCompleto()
                                : listaEvFiltrada[index]
                                    .remetente!
                                    .getNomeCompleto(),
                        'imagemUrl': listaEvFiltrada[index].destinatarioGrupo !=
                                null
                            ? listaEvFiltrada[index]
                                    .destinatarioGrupo!
                                    .fotoUrl1!
                                    .isNotEmpty
                                ? listaEvFiltrada[index]
                                    .destinatarioGrupo!
                                    .fotoUrl1!
                                : ''
                            : listaEvFiltrada[index]
                                        .destinatarioUtil!
                                        .utilizadorId !=
                                    utilizadorId
                                ? listaEvFiltrada[index]
                                        .destinatarioUtil!
                                        .fotoUrl ??
                                    ''
                                : listaEvFiltrada[index].remetente!.fotoUrl ??
                                    '',
                        'msgGrupo':
                            listaEvFiltrada[index].destinatarioGrupo != null
                                ? true
                                : false,
                        'grupoId': listaEvFiltrada[index].destinatarioGrupo !=
                                null
                            ? listaEvFiltrada[index].destinatarioGrupo!.grupoId
                            : 0,
                        'utilizadorId':
                            listaEvFiltrada[index].destinatarioUtil != null
                                ? listaEvFiltrada[index]
                                            .destinatarioUtil!
                                            .utilizadorId !=
                                        utilizadorId
                                    ? listaEvFiltrada[index]
                                        .destinatarioUtil!
                                        .utilizadorId
                                    : listaEvFiltrada[index]
                                        .remetente!
                                        .utilizadorId
                                : 0,
                      },
                    );
                    // Refresh the data after coming back from the detail screen
                    if (result != null && result == true) {
                      actualizaDados();
                    }
                  },
                  child: MensagemItem(
                    nome: listaEvFiltrada[index].destinatarioGrupo != null
                        ? listaEvFiltrada[index].destinatarioGrupo!.nome
                        : listaEvFiltrada[index]
                                    .destinatarioUtil!
                                    .utilizadorId !=
                                utilizadorId
                            ? listaEvFiltrada[index]
                                .destinatarioUtil!
                                .getNomeCompleto()
                            : listaEvFiltrada[index]
                                .remetente!
                                .getNomeCompleto(),
                    mensagemTexto: listaEvFiltrada[index].mensagemTexto,
                    imagemUrl: listaEvFiltrada[index].destinatarioGrupo != null
                        ? listaEvFiltrada[index]
                                .destinatarioGrupo!
                                .fotoUrl1!
                                .isNotEmpty
                            ? listaEvFiltrada[index]
                                .destinatarioGrupo!
                                .fotoUrl1!
                            : ''
                        : listaEvFiltrada[index]
                                    .destinatarioUtil!
                                    .utilizadorId !=
                                utilizadorId
                            ? listaEvFiltrada[index]
                                    .destinatarioUtil!
                                    .fotoUrl ??
                                ''
                            : listaEvFiltrada[index].remetente!.fotoUrl ?? '',
                    hora: dataFormatadaMsg(
                        listaEvFiltrada[index].dataEnvio!, idioma),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
