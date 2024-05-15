import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/gerais/logo.dart';
import 'confirmar_id.dart';

class EcraRecPass extends StatefulWidget {
  const EcraRecPass({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraRecPass> createState() {
    return _EcraRecPassState();
  }
}

class _EcraRecPassState extends State<EcraRecPass> {
  String version = 'Loading...';
  String email = '';
  late TextEditingController controlEmail;
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    controlEmail = TextEditingController();
    getVersion();
    passwordVisible = true;
  }

  @override
  void dispose() {
    //libertar recurso
    controlEmail.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
      email = controlEmail.text;
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 90),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height) * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.recuperarPass,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: (MediaQuery.of(context).size.height) * 0.10),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: controlEmail,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.account_circle_outlined),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isValidEmail(value)) {
                                  return AppLocalizations.of(context)!
                                      .insiraEmaiValido;
                                }
                                return null;
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/confirmarID');
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.continuar),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height) * 0.1),
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
    );
  }
}
