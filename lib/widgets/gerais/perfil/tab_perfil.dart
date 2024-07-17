import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/departamento_repository.dart';
import 'package:softshares_mobile/Repositories/funcao_repositry.dart';
import 'package:softshares_mobile/Repositories/polo_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/models/polo.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/departamento.dart';
import 'package:softshares_mobile/models/funcao.dart';
import 'package:softshares_mobile/widgets/gerais/dropdown_generica.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabPerfil extends StatefulWidget {
  const TabPerfil({super.key, required this.utilizador});

  final Utilizador utilizador;

  @override
  State<StatefulWidget> createState() {
    return _TabPerfilState();
  }
}

class _TabPerfilState extends State<TabPerfil> with TickerProviderStateMixin {
  final TextEditingController _pnome = TextEditingController();
  final TextEditingController _unome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _sobre = TextEditingController();
  List<int>? subcatFav;
  final PoloRepository _poloRepository = PoloRepository();
  List<Polo> polos = [];
  bool _isLoading = true;

  Departamento? _departamento;
  Polo? _polo;
  Funcao? _funcao;
  List<Subcategoria> subcategorias = [];
  List<Departamento> departamentos = [];
  List<Funcao> funcoes = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await carregaDadosIniciais();
    setState(() {
      _pnome.text = widget.utilizador.pNome;
      _unome.text = widget.utilizador.uNome;
      _email.text = widget.utilizador.email;
      _sobre.text = widget.utilizador.sobre ?? '';
      _departamento = departamentos.firstWhere((element) =>
          element.departamentoId == widget.utilizador.departamentoId);
      _polo = polos
          .firstWhere((element) => element.poloid == widget.utilizador.poloId);
      _funcao = funcoes.firstWhere(
          (element) => element.funcaoId == widget.utilizador.funcaoId);
      subcatFav = widget.utilizador.preferencias?.isNotEmpty ?? false
          ? widget.utilizador.preferencias
          : [];
      _isLoading = false;
    });
  }

  Future<void> carregaDadosIniciais() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    polos = await _poloRepository.fetchPolosFromDb();
    subcategorias =
        await SubcategoriaRepository().fetchSubcategoriasDB(idiomaId);
    departamentos =
        await DepartamentoRepository().fetchDepartamentosDB(idiomaId);
    funcoes = await FuncaoRepository().fetchFuncoesDB(idiomaId);
  }

  // faz a mudança de departamento
  void _mudaDepartamento(Departamento? value) {
    setState(() {
      _departamento = value;
      widget.utilizador.departamentoId = _departamento?.departamentoId ?? 0;
    });
  }

  // muda a funcao do utilizador
  void _mudaFuncao(Funcao? value) {
    setState(() {
      _funcao = value;
      widget.utilizador.funcaoId = _funcao?.funcaoId ?? 0;
    });
  }

  // muda o polo do utilizador
  void _mudaPolo(Polo? value) {
    setState(() {
      _polo = value;
      widget.utilizador.poloId = _polo?.poloid ?? 0;
    });
  }

  @override
  void dispose() {
    _pnome.dispose();
    _unome.dispose();
    _email.dispose();
    _sobre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ),
          )
        : DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: [
                    CustomTab(
                        icon: FontAwesomeIcons.user,
                        text: AppLocalizations.of(context)!.personalData),
                    CustomTab(
                        icon: FontAwesomeIcons.heart,
                        text: AppLocalizations.of(context)!.favoritos),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 18,
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              maxLength: 60,
                              controller: _pnome,
                              decoration: InputDecoration(
                                border: Theme.of(context)
                                    .inputDecorationTheme
                                    .border,
                                label: Text(
                                    AppLocalizations.of(context)!.primeiroNome),
                              ),
                              onChanged: (value) {
                                widget.utilizador.pNome = value;
                              },
                            ),
                            TextFormField(
                              maxLength: 60,
                              keyboardType: TextInputType.text,
                              controller: _unome,
                              decoration: InputDecoration(
                                border: Theme.of(context)
                                    .inputDecorationTheme
                                    .border,
                                label: Text(
                                    AppLocalizations.of(context)!.ultimoNome),
                              ),
                              onChanged: (value) {
                                widget.utilizador.uNome = value;
                              },
                            ),
                            TextFormField(
                              maxLength: 60,
                              readOnly: true,
                              controller: _email,
                              decoration: const InputDecoration(
                                label: Text("Email"),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              minLines: 4,
                              maxLines: 6,
                              maxLength: 140,
                              keyboardType: TextInputType.text,
                              controller: _sobre,
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.sobreMim),
                              ),
                              onChanged: (value) {
                                widget.utilizador.sobre = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Dropdown de seleccao do polo
                                  DropdownGenereica(
                                      items: polos,
                                      onChanged: _mudaPolo,
                                      titulo:
                                          AppLocalizations.of(context)!.polo,
                                      value: _polo,
                                      getText: (polo) => polo.descricao,
                                      readOnly: true),
                                  const SizedBox(height: 24),
                                  //DropDown departamento
                                  DropdownGenereica(
                                    items: departamentos,
                                    onChanged: _mudaDepartamento,
                                    titulo: AppLocalizations.of(context)!
                                        .departamento,
                                    value: _departamento,
                                    getText: (departamento) =>
                                        departamento.descricao,
                                  ),
                                  const SizedBox(height: 24),
                                  //DropDown Fucao
                                  DropdownGenereica(
                                    items: funcoes,
                                    onChanged: _mudaFuncao,
                                    titulo:
                                        AppLocalizations.of(context)!.funcao,
                                    value: _funcao,
                                    getText: (funcao) => funcao.descricao,
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                      thickness: 3, color: Colors.black),
                                  Text(
                                    AppLocalizations.of(context)!.subcatFav,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: subcategorias.map((subcat) {
                                        return CheckboxListTile(
                                          value: subcatFav!
                                              .contains(subcat.subcategoriaId),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == null ||
                                                  value == false) {
                                                subcatFav!.remove(
                                                    subcat.subcategoriaId);
                                              } else {
                                                subcatFav!
                                                    .add(subcat.subcategoriaId);
                                              }
                                              widget.utilizador.preferencias =
                                                  subcatFav;
                                            });
                                          },
                                          title: Text(subcat.descricao),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
