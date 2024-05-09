import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EcraLogin extends StatefulWidget {
  const EcraLogin({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraLogin> createState() {
    return _EcraLoginState();
  }
}

class _EcraLoginState extends State<EcraLogin> {
  String version = 'Loading...';
  String email = '';
  String pass = '';
  bool isChecked = false;
  late TextEditingController controlEmail;
  late TextEditingController controlPass;
  //Basededados bd = Basededados();
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
    controlPass = TextEditingController();
    getVersion();
    isChecked = false;
    passwordVisible = true;
  }

  @override
  void dispose() {
    //libertar recurso
    controlEmail.dispose();
    controlPass.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
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
        padding: const EdgeInsets.only(left: 12, right: 12, top: 90),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'SoftShares',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.bemVindo,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.doLogin,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: controlPass,
                                decoration: InputDecoration(
                                  label: Text(
                                      AppLocalizations.of(context)!.password),
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .introduzapassword;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passwordVisible,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: controlPass,
                                decoration: InputDecoration(
                                  label: Text(
                                      AppLocalizations.of(context)!.password),
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .introduzapassword;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
