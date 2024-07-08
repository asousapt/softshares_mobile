import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/Login/dadosConta.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:softshares_mobile/services/google_signin_api.dart';

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
  String email = '';
  String pass = '';
  String pass2 = '';
  Map<String, dynamic>? _facebookData;
  AccessToken? _accessToken;

  late TextEditingController _controlEmail;
  late TextEditingController _controlPass;
  late TextEditingController _controlPass2;
  //Basededados bd = Basededados();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    inicializar();
    _controlEmail = TextEditingController();
    _controlPass = TextEditingController();
    _controlPass2 = TextEditingController();
    getVersion();
  }

  void inicializar() async {
    await FacebookAuth.instance.logOut();
    await GoogleSignInApi.logout();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

   Future<void>_loginFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final facebookData = await FacebookAuth.instance.getUserData();
      _facebookData = facebookData;
    } else {
      print(result.status);
      print(result.message);
    }
    _facebookData!.forEach((key, value) {
      print('$key: $value');
    });
  }

  _checkIfisLoggedInFacebook() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      print("Acess Token - ${accessToken.toJson()}");
      final facebookData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _facebookData = facebookData;
      });
      print("Facebook Data: $_facebookData");
    } else {
      print("goes to else");
      await _loginFacebook();
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EcraDadosConta(
                  mudaIdioma: widget.mudaIdioma,
                  email: _facebookData!['email'],
                  tipo: "facebook",
                  nome: _facebookData!['name'],
                  token: _accessToken!.tokenString,
                )));
  }

  Future signInGoogle() async {
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.googleFailed)));
    } else {
      print("Nome do user: ${user.displayName}, Email: ${user.email}");
    }
    final googleAuth = await user!.authentication;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EcraDadosConta(
                  mudaIdioma: widget.mudaIdioma,
                  email: user.email,
                  tipo: "google",
                  nome: user.displayName,
                  token: googleAuth.accessToken,
                )));
  }

  @override
  void dispose() {
    //libertar recurso
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
      email = _controlEmail.text;
      pass = _controlPass.text;
      pass2 = _controlPass2.text;
    });
    //bd.inserirvalor(Email, Passricao);
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: altura * 0.01,
        ),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: largura * 0.02),
            height: altura * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(horizontal: largura * 0.02),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              SizedBox(height: altura * 0.05),
              Text(
                AppLocalizations.of(context)!.criarConta,
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
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
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
                    SizedBox(height: altura * 0.02),
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
                    SizedBox(height: altura * 0.02),
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
                        } else if (value != pass) {
                          print(
                              "Valor de value - $value, Valor de pass1 - $pass");
                          return AppLocalizations.of(context)!
                              .passwordsDiferentes;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: altura * 0.03),
                    SizedBox(
                      height: altura * 0.05,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          sub();
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EcraDadosConta(
                                          mudaIdioma: widget.mudaIdioma,
                                          email: email,
                                          tipo: "normal",
                                          pass: pass,
                                        )));
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.register),
                      ),
                    ),
                    SizedBox(height: altura * 0.01),
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
                      onPressed: _checkIfisLoggedInFacebook,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20), // Adjust padding as needed
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
                    SizedBox(height: altura * 0.01),
                    ElevatedButton(
                      onPressed: signInGoogle,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
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
              SizedBox(width: 3),
              Text(
                "Softinsa v$version",
                style: const TextStyle(color: Color.fromRGBO(230, 230, 230, 1)),
              )
            ],
          )
        ])),
      ),
    ));
  }
}
