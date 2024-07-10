import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/criar_grupo.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagem_detalhe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NovaMensagem extends StatefulWidget {
  const NovaMensagem({
    super.key,
    required this.mensagens,
  });

  final List<Mensagem> mensagens;

  @override
  State<NovaMensagem> createState() {
    return _NovaMensagemState();
  }
}

class _NovaMensagemState extends State<NovaMensagem> {
  List<Utilizador> listaUtilizadores = [];
  List<Utilizador> listaUtilizadoresFiltrada = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  // Função que atualiza a lista de utilizadores
  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    UtilizadorRepository utilizadorRepository = UtilizadorRepository();
    utilizadores = await utilizadorRepository.getUtilizadoresSimplificado();

    setState(() {
      listaUtilizadores = utilizadores;
      listaUtilizadoresFiltrada = utilizadores;
      _isLoading = false;
    });
  }

  // Função que retorna o id da mensagem que contém o utilizador
  int getMensagemId(List<Mensagem> msgs, int utilizadorId) {
    for (Mensagem msg in msgs) {
      if (msg.remetente!.utilizadorId == utilizadorId ||
          (msg.destinatarioUtil != null &&
              msg.destinatarioUtil!.utilizadorId == utilizadorId)) {
        return msg.mensagemId!;
      }
    }
    return 0;
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
              listaUtilizadoresFiltrada = utilizadores;
              _searchController.clear();
            });
          },
        ),
      ),
    );
  }

  // Função que filtra a lista de utilizadores por texto
  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      listaUtilizadoresFiltrada = utilizadores.where((element) {
        String nomelower = element.getNomeCompleto().toLowerCase();

        return nomelower.contains(texto);
      }).toList();
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

    return Scaffold(
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
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: altura * 0.8,
            margin: EdgeInsets.symmetric(
                horizontal: largura * 0.02, vertical: altura * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/ListarGrupo");
                    },
                    child: Text(AppLocalizations.of(context)!.joinGroup),
                  ),
                ),
                SizedBox(height: altura * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CriarGrupoScreen(
                            editar: false,
                          ),
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.createGroup),
                  ),
                ),
                SizedBox(height: altura * 0.02),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: listaUtilizadoresFiltrada.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MensagemDetalheScreen(
                                      mensagemId: getMensagemId(
                                          widget.mensagens,
                                          listaUtilizadoresFiltrada[index]
                                              .utilizadorId),
                                      nome: listaUtilizadoresFiltrada[index]
                                          .getNomeCompleto(),
                                      imagemUrl:
                                          listaUtilizadoresFiltrada[index]
                                              .fotoUrl!,
                                      msgGrupo: false,
                                      utilizadorId:
                                          listaUtilizadoresFiltrada[index]
                                              .utilizadorId,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: listaUtilizadoresFiltrada[index]
                                        .fotoUrl!
                                        .isEmpty
                                    ? CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text(
                                          listaUtilizadoresFiltrada[index]
                                              .getIniciais(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          listaUtilizadoresFiltrada[index]
                                              .fotoUrl!,
                                        ),
                                      ),
                                title: Text(
                                  listaUtilizadoresFiltrada[index]
                                      .getNomeCompleto(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
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
