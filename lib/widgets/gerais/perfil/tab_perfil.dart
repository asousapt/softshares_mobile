import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/models/polo.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/departamento.dart';
import 'package:softshares_mobile/models/funcao.dart';
import 'package:softshares_mobile/widgets/gerais/dropdown_generica.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabPerfil extends StatefulWidget {
  TabPerfil({super.key, required this.utilizador});

  Utilizador utilizador;
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

  Departamento? _departamento;
  Polo? _polo;
  Funcao? _funcao;

  List<Polo> polos = [
    Polo(1, 'Polo 1'),
    Polo(2, 'Polo 2'),
    Polo(3, 'Polo 3'),
  ];

  List<Subcategoria> subcategorias = [
    Subcategoria(1, 'Subcategoria 1'),
    Subcategoria(2, 'Subcategoria 2'),
    Subcategoria(3, 'Subcategoria 3'),
    Subcategoria(4, 'Subcategoria 4'),
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

    //Carrega a informação vinda do ecrã anterior
    _pnome.text = widget.utilizador.pNome;
    _unome.text = widget.utilizador.uNome;
    _email.text = widget.utilizador.email;
    _sobre.text = widget.utilizador.sobre;
    _departamento = departamentos.firstWhere((element) =>
        element.departamentoId == widget.utilizador.departamentoId);
    _polo = polos
        .firstWhere((element) => element.poloId == widget.utilizador.poloId);
    _funcao = funcoes.firstWhere(
        (element) => element.funcaoId == widget.utilizador.funcaoId);
    if (widget.utilizador.preferencias.isNotEmpty) {
      subcatFav = widget.utilizador.preferencias;
    } else {
      subcatFav = [];
    }
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
      widget.utilizador.poloId = _polo == null ? 0 : _polo!.poloId;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          border: Theme.of(context).inputDecorationTheme.border,
                          label:
                              Text(AppLocalizations.of(context)!.primeiroNome),
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
                          border: Theme.of(context).inputDecorationTheme.border,
                          label: Text(AppLocalizations.of(context)!.ultimoNome),
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
                          label: Text(AppLocalizations.of(context)!.password),
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
                          label: Text(AppLocalizations.of(context)!.sobreMim),
                        ),
                        onChanged: (value) {
                          widget.utilizador.sobre = value;
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown de seleccao do polo
                      DropdownGenereica(
                        items: polos,
                        onChanged: _mudaPolo,
                        titulo: AppLocalizations.of(context)!.polo,
                        value: _polo,
                        getText: (polo) => polo.nome,
                      ),
                      const SizedBox(height: 24),
                      //DropDown departamento
                      DropdownGenereica(
                        items: departamentos,
                        onChanged: _mudaDepartamento,
                        titulo: AppLocalizations.of(context)!.departamento,
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView(
                          children: subcategorias.map((subcat) {
                            return CheckboxListTile(
                              value: subcatFav!.contains(subcat.subcategoriaId),
                              onChanged: (value) {
                                setState(() {
                                  if (value == null || value == false) {
                                    subcatFav!.remove(subcat.subcategoriaId);
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
}
