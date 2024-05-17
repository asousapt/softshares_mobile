import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
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
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        top: true,
        right: true,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(
            left: largura * 0.03,
            right: largura * 0.03,
            top: altura * 0.01,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: altura * 0.85,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: largura * 0.03),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: altura * 0.05),
                        const Text(
                          'SoftShares',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: altura * 0.02),
                        Text(
                          AppLocalizations.of(context)!.bemVindo,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: altura * 0.002),
                        Text(
                          AppLocalizations.of(context)!.doLogin,
                          style: const TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: altura * 0.03),
                        Form(
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
                              SizedBox(height: altura * 0.01),
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
                                  Flexible(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .keepMeLoggedIn,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
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
                                height: altura * 0.065,
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    /*if (_formKey.currentState!.validate()) {
                                      Navigator.pushNamed(context, '/home');
                                    }*/
                                    Navigator.pushNamed(context, '/escolherPolo');
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
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/recuperarPass");
                                    },
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
                              SizedBox(height: altura * 0.002),
                              //Secção das bandeiras
                              SizedBox(
                                height: altura * 0.07,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.mudaIdioma('pt');
                                      },
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.transparent,
                                        child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(altura * 0.01),
                                            child: CountryFlag.fromCountryCode(
                                              'PT',
                                              height: largura * 0.03,
                                              width: largura * 0.03,
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
                                              height: largura * 0.03,
                                              width: largura * 0.03,
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
                                              height: largura * 0.03,
                                              width: largura * 0.03,
                                              borderRadius: 48,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey),
                              SizedBox(
                                height: altura * 0.01,
                              ),
                              // Secção do SSO
                              ElevatedButton(
                                onPressed: sub,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: largura * 0.1,
                                      vertical: altura * 0.02),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(FontAwesomeIcons.facebook),
                                    SizedBox(width: largura * 0.02),
                                    const Text("Facebook"),
                                  ],
                                ),
                              ),
                              SizedBox(height: altura * 0.01),
                              ElevatedButton(
                                onPressed: sub,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: largura * 0.1,
                                    vertical: altura * 0.02,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: altura * 0.04,
                  child: Row(
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
                ),
                SizedBox(
                  height: altura * 0.04,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.copyright,
                        color: Color.fromRGBO(230, 230, 230, 1),
                      ),
                      SizedBox(width: largura * 0.01),
                      Text(
                        "Softinsa v$version",
                        style: const TextStyle(
                            color: Color.fromRGBO(230, 230, 230, 1)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
