import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
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

class _MensagensMainScreenState extends State<MensagensMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Mensagem> listaEvFiltrada = [];
  List<Mensagem> mensagens = [];
  Color containerColorMensagens = Colors.transparent;
  bool _isSearching = false;
  bool _isLoading = false;

  Future<List<Mensagem>> fetchMensagens() async {
    await Future.delayed(Duration(seconds: 2));

    List<Mensagem> mensagens = [];
    /* Mensagem(
        mensagemId: 1,
        mensagemTexto: 'Hello John!',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1, 'https://via.placeholder.com/150'),
        dataEnvio: DateTime.now().subtract(Duration(hours: 1)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 2,
        mensagemTexto: 'Meeting at 5 PM',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioGrupo: Grupo(
          imagem: 'https://via.placeholder.com/150',
          grupoId: 1,
          nome: 'Team Meeting',
          descricao: 'Team Meeting',
          subcategoria: Subcategoria(1, 1, 'Meeting', 1),
          utilizadores: [
            Utilizador(1, 'Alice', 'Johnson', 'alice.johnson@example.com',
                'Some info', 1, [1, 2], 1, 1),
            Utilizador(2, 'John', 'Doe', 'john.doe@example.com', 'Some info', 1,
                [1, 2], 1, 1)
          ],
          publico: false,
          utilizadorCriouId: 1,
        ),
        dataEnvio: DateTime.now().subtract(Duration(days: 2)),
        anexos: [],
        vista: false,
      ),
    ]; */
    return mensagens;
  }

  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    mensagens = await fetchMensagens();
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
      listaEvFiltrada = mensagens.where((element) {
        String mensagemlower = element.mensagemTexto.toLowerCase();
        String nomelower = element.remetente.getNomeCompleto().toLowerCase();

        return mensagemlower.contains(texto) || nomelower.contains(texto);
      }).toList();

      if (listaEvFiltrada.isEmpty) {
        containerColorMensagens = Theme.of(context).canvasColor;
      } else {
        containerColorMensagens = Colors.transparent;
      }
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
          onPressed: () {
            Navigator.of(context).push(
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
              itemCount: mensagens.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navegar para a página de detalhes da mensagem
                    Navigator.pushNamed(
                      context,
                      '/mensagem_detalhe',
                      arguments: {
                        'mensagemId': mensagens[index].mensagemId,
                        'nome': mensagens[index].destinatarioGrupo != null
                            ? mensagens[index].destinatarioGrupo!.descricao
                            : mensagens[index]
                                .destinatarioUtil!
                                .getNomeCompleto(),
                        'imagemUrl': mensagens[index].destinatarioGrupo != null
                            ? mensagens[index].destinatarioGrupo!.imagem
                            : mensagens[index].destinatarioUtil!.fotoUrl,
                        'msgGrupo': mensagens[index].destinatarioGrupo != null
                            ? true
                            : false,
                        'grupoId': mensagens[index].destinatarioGrupo != null
                            ? mensagens[index].destinatarioGrupo!.grupoId
                            : 0,
                        'utilizadorId': mensagens[index].destinatarioUtil !=
                                null
                            ? mensagens[index].destinatarioUtil!.utilizadorId
                            : 0,
                      },
                    );
                  },
                  child: MensagemItem(
                    nome: mensagens[index].destinatarioGrupo != null
                        ? mensagens[index].destinatarioGrupo!.descricao
                        : mensagens[index].destinatarioUtil!.getNomeCompleto(),
                    mensagemTexto: mensagens[index].mensagemTexto,
                    imagemUrl:
                        'https://via.placeholder.com/150', // Placeholder image
                    hora: dataFormatadaMsg(mensagens[index].dataEnvio, 'pt'),
                    //lida: mensagens[index].vista!,
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
