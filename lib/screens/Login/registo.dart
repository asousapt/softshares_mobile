import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EcraRegistar extends StatefulWidget {
  EcraRegistar({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraRegistar> createState() {
    return _EcraRegistarState();
  }
}

class _EcraRegistarState extends State<EcraRegistar> {
  String version = 'Loading...';
  String pNome = '';
  String uNome = '';
  String email = '';
  String pass = '';
  late TextEditingController controlEmail;
  late TextEditingController controlPass;
  late TextEditingController controlPNome;
  late TextEditingController controlUNome;
  late TextEditingController controlPass2;
  //Basededados bd = Basededados();

  @override
  void initState() {
    super.initState();
    controlEmail = TextEditingController();
    controlPass = TextEditingController();
    controlPNome = TextEditingController();
    controlUNome = TextEditingController();
    controlPass2 = TextEditingController();
    getVersion();
  }

  @override
  void dispose() {
    //libertar recurso
    controlPNome.dispose();
    controlUNome.dispose();
    controlPass2.dispose();
    controlEmail.dispose();
    controlPass.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
      pNome = controlPNome.text;
      uNome = controlUNome.text;
      email = controlEmail.text;
      pass = controlPass.text;
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
        padding: const EdgeInsets.only(left: 12, right: 12, top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        AppLocalizations.of(context)!.criarConta,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.comecaAgora,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 30),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controlEmail,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.primeiroNome,
                                prefixIcon:
                                    const Icon(Icons.account_circle_outlined),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controlEmail,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.ultimoNome,
                                prefixIcon:
                                    const Icon(Icons.account_circle_outlined),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controlEmail,
                              decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon:
                                    const Icon(Icons.account_circle_outlined),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controlPass,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              controller: controlPass,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () {},
                                child: Text("Registar"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("escolhi PT");
                                  },
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors
                                        .transparent, // Make the background transparent
                                    child: AspectRatio(
                                      aspectRatio:
                                          1.0, // Ensure aspect ratio is 1:1 to maintain the circular shape
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: CountryFlag.fromCountryCode(
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
                                    print("escolhi ES");
                                  },
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.transparent,
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: CountryFlag.fromCountryCode(
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
                                    print("escolhi GB");
                                  },
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.transparent,
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: CountryFlag.fromCountryCode(
                                          'GB',
                                          height: 48,
                                          width: 48,
                                          borderRadius: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tens uma conta?",
                    style: const TextStyle(
                      fontSize: 16,
                      color: const Color.fromRGBO(230, 230, 230, 1),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, "/login")},
                    child: const Text("Entrar",
                        style: TextStyle(
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