import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/gerais/logo.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcraReporPass extends StatefulWidget {
  const EcraReporPass({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraReporPass> createState() {
    return _EcraReporPassState();
  }
}

class _EcraReporPassState extends State<EcraReporPass> {
  String version = 'Loading...';
  String pass = '';
  String pass2 = '';
  late TextEditingController _controlPass;
  late TextEditingController _controlPass2;
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _controlPass = TextEditingController();
    _controlPass2 = TextEditingController();
    getVersion();
  }

  @override
  void dispose() {
    //libertar recurso
    _controlPass2.dispose();
    _controlPass.dispose();
    super.dispose();
  }

  void sub() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final json = {"password": pass};
    api.putRequestNoAuth('utilizadores/alterarPass/email/$email', json);
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 90),
        child: SingleChildScrollView(
          child: Container(
            height: (MediaQuery.of(context).size.height) * 1 -
                90, // Adjust height as needed
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height) * 0.8,
                  color: Theme.of(context).canvasColor,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.repor +
                            ' ' +
                            AppLocalizations.of(context)!.password,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: (MediaQuery.of(context).size.height) * 0.20),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _controlPass,
                                decoration: InputDecoration(
                                  labelText: (AppLocalizations.of(context)!
                                          .nova +
                                      ' ' +
                                      AppLocalizations.of(context)!.password),
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    AppLocalizations.of(context)!
                                        .introduzapassword;
                                    //fazer outra coisa
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _controlPass2,
                                decoration: InputDecoration(
                                  labelText: (AppLocalizations.of(context)!
                                          .confirmar +
                                      ' ' +
                                      AppLocalizations.of(context)!.password),
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.password}";
                                  } else if (value != pass) {
                                    print(
                                        "Valor de value - $value, Valor de pass1 - $pass");
                                    return AppLocalizations.of(context)!
                                        .passwordsDiferentes;
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                child: SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () async {
                                      setState(() {
                                        pass = _controlPass.text;
                                        pass2 = _controlPass2.text;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        sub();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .loginInvalido)),
                                        );
                                        Navigator.pushNamed(context, '/login');
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .confirmar),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      0.1),
                              Logo()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) * 0.05),
                Row(
                  children: [
                    const Icon(
                      Icons.copyright,
                      color: Color.fromRGBO(230, 230, 230, 1),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "Softinsa v$version",
                      style: const TextStyle(
                          color: Color.fromRGBO(230, 230, 230, 1)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
