import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/gerais/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcraConfID extends StatefulWidget {
  const EcraConfID({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraConfID> createState() {
    return _EcraConfIDState();
  }
}

class _EcraConfIDState extends State<EcraConfID> {
  String version = 'Loading...';
  String codigo = '';
  int? codigoValid;
  late TextEditingController controlCodigo;
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidcodigo(String codigo) {
    int code = int.parse(codigo);
    return (code == codigoValid);
  }

  void inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      codigoValid = prefs.getInt("codigo");
    });
  }

  @override
  void initState() {
    super.initState();
    inicializar();
    controlCodigo = TextEditingController();
    getVersion();
  }

  @override
  void dispose() {
    //libertar recurso
    controlCodigo.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
      codigo = controlCodigo.text;
    });
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
                        AppLocalizations.of(context)!.confirmarID,
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
                                controller: controlCodigo,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.codigo,
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !isValidcodigo(value)) {
                                    return AppLocalizations.of(context)!
                                        .codigoInvalido;
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        Navigator.pushNamed(
                                            context, '/reporPass');
                                      }
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .confirmar),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      0.002),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                child: SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove("codigo");
                                      Navigator.pushNamed(
                                          context, '/recuperarPass');
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.cancelar),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: (MediaQuery.of(context).size.height) *
                                      0.15),
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
