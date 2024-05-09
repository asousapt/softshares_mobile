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
  String pass2 = '';

  late TextEditingController _controlEmail;
  late TextEditingController _controlPass;
  late TextEditingController _controlPNome;
  late TextEditingController _controlUNome;
  late TextEditingController _controlPass2;
  //Basededados bd = Basededados();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controlEmail = TextEditingController();
    _controlPass = TextEditingController();
    _controlPNome = TextEditingController();
    _controlUNome = TextEditingController();
    _controlPass2 = TextEditingController();
    getVersion();
  }

  @override
  void dispose() {
    //libertar recurso
    _controlPNome.dispose();
    _controlUNome.dispose();
    _controlPass2.dispose();
    _controlEmail.dispose();
    _controlPass.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    return emailRegex.hasMatch(email);
  }

  void sub() {
    setState(() {
      pNome = _controlPNome.text;
      uNome = _controlUNome.text;
      email = _controlEmail.text;
      pass = _controlPass.text;
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
          child: Column(children: [
        Container(
          color: Theme.of(context).canvasColor,
          child: Expanded(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.criarConta,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.comecaAgora,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _controlPNome,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.primeiroNome,
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.primeiroNome}";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controlUNome,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.ultimoNome,
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.ultimoNome}";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controlEmail,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.account_circle_outlined),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !isValidEmail(value)) {
                          return AppLocalizations.of(context)!.insiraEmaiValido;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _controlPass,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.password}";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _controlPass2,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.repetirPassword,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.password}";
                        } else if (value != pass2) {
                          return AppLocalizations.of(context)!
                              .passwordsDiferentes;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.register),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisSize: MainAxisSize.min, children: [
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
                              padding: const EdgeInsets.all(8),
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
                          widget.mudaIdioma('es');
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
                          widget.mudaIdioma('en');
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
                    ]),
                    const Divider(color: Colors.grey),
                    // Secção do SSO
                    ElevatedButton(
                      onPressed: sub,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10), // Adjust padding as needed
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.facebook),
                          SizedBox(width: 4),
                          Text("Facebook"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: sub,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () => {Navigator.pushNamed(context, "/login")},
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
            const SizedBox(width: 3),
            Text(
              "Softinsa v$version",
              style: const TextStyle(color: Color.fromRGBO(230, 230, 230, 1)),
            )
          ],
        )
      ])),
    ));
  }
}
