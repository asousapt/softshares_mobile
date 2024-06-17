import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/Repositories/polo_repository.dart';
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
  final TextEditingController _passwd = TextEditingController();
  final TextEditingController _sobre = TextEditingController();
  List<int>? subcatFav;
  final PoloRepository _poloRepository = PoloRepository();
  List<Polo> polos = [];

  Departamento? _departamento;
  Polo? _polo;
  Funcao? _funcao;

  List<Subcategoria> subcategorias = [
    // Subcategories for "Gastronomia" category
    Subcategoria(1, 1, "Comida italiana"),
    Subcategoria(2, 1, "Comida mexicana"),
    Subcategoria(3, 1, "Comida japonesa"),
    // Subcategories for "Desporto" category
    Subcategoria(4, 2, "Futebol"),
    Subcategoria(5, 2, "Basquetebol"),
    Subcategoria(6, 2, "Ténis"),
    // Subcategories for "Atividade Ar Livre" category
    Subcategoria(7, 3, "Caminhada"),
    Subcategoria(8, 3, "Ciclismo"),
    // Subcategories for "Alojamento" category
    Subcategoria(9, 4, "Hotel"),
    Subcategoria(10, 4, "Hostel"),
    Subcategoria(11, 4, "Apartamento"),
    // Subcategories for "Saúde" category
    Subcategoria(12, 5, "Médico geral"),
    Subcategoria(13, 5, "Dentista"),
    Subcategoria(14, 5, "Fisioterapia"),
    // Subcategories for "Ensino" category
    Subcategoria(15, 6, "Escola primária"),
    Subcategoria(16, 6, "Escola secundária"),
    Subcategoria(17, 6, "Universidade"),
    // Subcategories for "Infraestruturas" category
    Subcategoria(18, 7, "Transporte público"),
    Subcategoria(19, 7, "Estradas"),
    Subcategoria(20, 7, "Rede de água e saneamento"),
  ];

  List<Departamento> departamentos = [
    Departamento(1, 'Administração'),
    Departamento(2, 'Financeiro'),
    Departamento(3, 'Logistica'),
    Departamento(4, 'RH'),
  ];
  List<Funcao> funcoes = [
    Funcao(1, 'Gestor'),
    Funcao(2, 'Programador'),
    Funcao(3, 'Técnico de RH'),
    Funcao(4, 'Administrativo'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchPolos();
  }

  void _fetchPolos() async {
    final polosdb = await _poloRepository.fetchPolosFromDb();

    setState(() {
      polos = polosdb;

      // Initialize utilizador related fields after polos are fetched
      _pnome.text = widget.utilizador.pNome;
      _unome.text = widget.utilizador.uNome;
      _email.text = widget.utilizador.email;
      _sobre.text = widget.utilizador.sobre!;
      _departamento = departamentos.firstWhere((element) =>
          element.departamentoId == widget.utilizador.departamentoId);
      _polo = polos
          .firstWhere((element) => element.poloid == widget.utilizador.poloId);
      _funcao = funcoes.firstWhere(
          (element) => element.funcaoId == widget.utilizador.funcaoId);
      subcatFav = widget.utilizador.preferencias!.isNotEmpty
          ? widget.utilizador.preferencias
          : [];
    });
  }

  // faz a mudança de departamento
  void _mudaDepartamento(value) {
    setState(() {
      _departamento = value;
      widget.utilizador.departamentoId =
          _departamento == null ? 0 : _departamento!.departamentoId;
    });
  }

  // muda a funcao do utilizador
  void _mudaFuncao(value) {
    setState(() {
      _funcao = value;
      widget.utilizador.funcaoId = _funcao == null ? 0 : _funcao!.funcaoId;
    });
  }

  //muda o polo do utilizador
  void _mudaPolo(value) {
    setState(() {
      _polo = value;
      widget.utilizador.poloId = _polo == null ? 0 : _polo!.poloid;
    });
  }

  @override
  void dispose() {
    _pnome.dispose();
    _unome.dispose();
    _email.dispose();
    _passwd.dispose();
    _sobre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _poloRepository.fetchPolosFromDb(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Erro ao carregar os polos'),
          );
        } else {
          return DefaultTabController(
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
                            TextFormField(
                              readOnly: true,
                              controller: _passwd,
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.password),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              minLines: 3,
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
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dropdown de seleccao do polo
                            DropdownGenereica(
                              items: polos,
                              onChanged: _mudaPolo,
                              titulo: AppLocalizations.of(context)!.polo,
                              value: _polo,
                              getText: (polo) => polo.descricao,
                            ),
                            const SizedBox(height: 24),
                            //DropDown departamento
                            DropdownGenereica(
                              items: departamentos,
                              onChanged: _mudaDepartamento,
                              titulo:
                                  AppLocalizations.of(context)!.departamento,
                              value: _departamento,
                              getText: (departamento) => departamento.descricao,
                            ),
                            const SizedBox(height: 24),
                            //DropDown Fucao
                            DropdownGenereica(
                              items: funcoes,
                              onChanged: _mudaFuncao,
                              titulo: AppLocalizations.of(context)!.funcao,
                              value: _funcao,
                              getText: (funcao) => funcao.descricao,
                            ),
                            const SizedBox(height: 10),
                            const Divider(thickness: 3, color: Colors.black),
                            Text(
                              AppLocalizations.of(context)!.subcatFav,
                              textAlign: TextAlign.left,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView(
                                children: subcategorias.map((subcat) {
                                  return CheckboxListTile(
                                    value: subcatFav!
                                        .contains(subcat.subcategoriaId),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == null || value == false) {
                                          subcatFav!
                                              .remove(subcat.subcategoriaId);
                                        } else {
                                          subcatFav!.add(subcat.subcategoriaId);
                                        }
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
      },
    );
  }
}
