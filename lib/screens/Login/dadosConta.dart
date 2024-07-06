import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/departamento.dart';
import 'package:softshares_mobile/models/funcao.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcraDadosConta extends StatefulWidget {
  EcraDadosConta(
      {super.key,
      required this.mudaIdioma,
      required this.email,
      this.pass,
      required this.isToken,
      this.token});

  final String? email, pass, token;
  final bool isToken;

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraDadosConta> createState() {
    return _EcraDadosContaState();
  }
}

class _EcraDadosContaState extends State<EcraDadosConta> {
  List<Funcao> funcoes = [];
  List<Departamento> departamentos = [];

  String version = 'Loading...', pNome = '', uNome = '';
  String? funcaoId, departamentoId;
  int idiomaId = 1;

  late TextEditingController _controlPNome;
  late TextEditingController _controlUNome;
  //Basededados bd = Basededados();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = true;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    api.setAuthToken('tokenFixo');
    carregarDados();
    _controlPNome = TextEditingController();
    _controlUNome = TextEditingController();
    getVersion();
  }

  Future<void> fetchFuncoes() async {
    try {
      final lista = await api.getRequest('funcao/mobile');
      final listaFormatted = lista['data'];
      if (listaFormatted is! List) {
        throw Exception("Failed to load data: Expected a list in 'data'");
      }

      final listaFormatted2 = listaFormatted.where((e) => e["idiomaId"] == idiomaId);

      // Parse the JSON data into a list of PontoInteresse objects
      List<Funcao> listaUpdated = listaFormatted2.map<Funcao>((item) {
        try {
          return Funcao.fromJson(item);
        } catch (e) {
          print("Error parsing item2: $item");
          print("Error details: $e");
          rethrow;
        }
      }).toList();
      setState(() {
        funcoes = List.from(listaUpdated);
      });
    } catch (e) {
      print("Error fetching data1: $e");
      // Handle error appropriately
    }
    _loading = false;
  }

  Future<void> fetchDepartamentos() async {
    try {
      final lista = await api.getRequest('departamento/mobile');
      final listaFormatted = lista['data'];
      if (listaFormatted is! List) {
        throw Exception("Failed to load data: Expected a list in 'data'");
      }
      final listaFormatted2 = listaFormatted.where((e) => e["idiomaId"] == idiomaId);

      // Parse the JSON data into a list of PontoInteresse objects
      List<Departamento> listaUpdated =
          listaFormatted2.map<Departamento>((item) {
        try {
          return Departamento.fromJson(item);
        } catch (e) {
          print("Error parsing item2: $item");
          print("Error details: $e");
          rethrow;
        }
      }).toList();
      setState(() {
        departamentos = List.from(listaUpdated);
      });
    } catch (e) {
      print("Error fetching data1: $e");
      // Handle error appropriately
    }
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    idiomaId = prefs.getInt("idiomaId") ?? 1;
    await fetchDepartamentos();
    await fetchFuncoes();
    setState(() {
      if (departamentos.isNotEmpty) {
        departamentoId = departamentos[0].departamentoId.toString();
      }
      if (funcoes.isNotEmpty) {
        funcaoId = funcoes[0].funcaoId.toString();
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    //libertar recurso
    _controlPNome.dispose();
    _controlUNome.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
      pNome = _controlPNome.text;
      uNome = _controlUNome.text;
    });
    //bd.inserirvalor(Email, Passricao);
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : (departamentos.isEmpty || funcoes.isEmpty)
                ? Container(
                    height: altura * 0.8,
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.naoHaDados),
                        ],
                      ),
                    ),
                  )
                : SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: altura * 0.01,
                      ),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: largura * 0.02),
                          height: altura * 0.85,
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: largura * 0.02),
                          child:
                              Column(mainAxisSize: MainAxisSize.max, children: [
                            SizedBox(height: altura * 0.05),
                            Text(
                              AppLocalizations.of(context)!.inserirDadosConta,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: altura * 0.02),
                            Text(
                              AppLocalizations.of(context)!.comecaAgora,
                              style: const TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: altura * 0.02),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 30),
                              child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    controller: _controlPNome,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .primeiroNome,
                                      prefixIcon: const Icon(
                                          Icons.account_circle_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.primeiroNome}";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    controller: _controlUNome,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .ultimoNome,
                                      prefixIcon: const Icon(
                                          Icons.account_circle_outlined),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.ultimoNome}";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  DropdownButtonFormField(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hint: Text(AppLocalizations.of(context)!
                                        .categoria),
                                    isExpanded: true,
                                    value: departamentoId,
                                    items: getListaDepDropdown(departamentos),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          departamentoId = value;
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  DropdownButtonFormField(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hint: Text(AppLocalizations.of(context)!
                                        .categoria),
                                    isExpanded: true,
                                    value: funcaoId,
                                    items: getListaFunDropdown(funcoes),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          funcaoId = value;
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: altura * 0.03),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () {
                                        sub();
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushNamed(
                                              context, '/dadosConta');
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .register),
                                    ),
                                  ),
                                  SizedBox(height: altura * 0.01),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            widget.mudaIdioma('pt');
                                          },
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundColor: Colors
                                                .transparent, // Make the background transparent
                                            child: AspectRatio(
                                              aspectRatio:
                                                  1.0, // Ensure aspect ratio is 1:1 to maintain the circular shape
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child:
                                                    CountryFlag.fromCountryCode(
                                                  'PT',
                                                  height: 48,
                                                  width: 48,
                                                  borderRadius: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            widget.mudaIdioma('es');
                                          },
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundColor: Colors.transparent,
                                            child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child:
                                                    CountryFlag.fromCountryCode(
                                                  'ES',
                                                  height: 48,
                                                  width: 48,
                                                  borderRadius: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            widget.mudaIdioma('en');
                                          },
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundColor: Colors.transparent,
                                            child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child:
                                                    CountryFlag.fromCountryCode(
                                                  'GB',
                                                  height: 48,
                                                  width: 48,
                                                  borderRadius: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                  const Divider(color: Colors.grey),
                                  // Secção do SSO
                                  ElevatedButton(
                                    onPressed: sub,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              20), // Adjust padding as needed
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.facebook),
                                        SizedBox(width: 4),
                                        Text("Facebook"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: sub,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 20,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.google),
                                        SizedBox(width: 4),
                                        Text("Google"),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.jaTemConta,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(230, 230, 230, 1),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  {Navigator.pushNamed(context, "/login")},
                              child: Text(AppLocalizations.of(context)!.login,
                                  style: const TextStyle(
                                      color: Color(0xFF83B1FF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.copyright,
                              color: Color.fromRGBO(230, 230, 230, 1),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Softinsa v$version",
                              style: const TextStyle(
                                  color: Color.fromRGBO(230, 230, 230, 1)),
                            )
                          ],
                        )
                      ])),
                    ),
                  ));
  }
}
