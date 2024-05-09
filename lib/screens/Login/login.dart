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
                                keyboardType: TextInputType.emailAddress,
                                controller: controlEmail,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  prefixIcon:
                                      Icon(Icons.account_circle_outlined),
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
                              Row(
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .keepMeLoggedIn,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == null) {
                                            isChecked = false;
                                          } else {
                                            isChecked = value;
                                          }
                                        });
                                      }),
                                ],
                              ),

                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    /*if (_formKey.currentState!.validate()) {
                                      Navigator.pushNamed(context, '/home');
                                    }*/
                                    Navigator.pushNamed(context, '/home');
                                  },
                                  child:
                                      Text(AppLocalizations.of(context)!.login),
                                ),
                              ),
                              // Esqueceu a password
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .forgotPassword,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {Navigator.pushNamed(context, "/recuperarPass");},
                                    child: Text(
                                      AppLocalizations.of(context)!.clickHere,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              //Secção das bandeiras
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
                                ],
                              ),
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
                              const SizedBox(height: 4),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.noAccount,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, "/registar")},
                    child: Text(AppLocalizations.of(context)!.register,
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
