import 'dart:convert';
import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/cidade_repository.dart';
import 'package:softshares_mobile/Repositories/departamento_repository.dart';
import 'package:softshares_mobile/Repositories/funcao_repositry.dart';
import 'package:softshares_mobile/Repositories/notificacaoPref_repository.dart';
import 'package:softshares_mobile/Repositories/polo_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/polo.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/google_signin_api.dart';
import 'package:softshares_mobile/services/api_service.dart';

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
  Map<String, dynamic>? _facebookData;
  ApiService api = ApiService();
  AccessToken? _accessToken;
  bool _checking = true;
  String version = 'Loading...';
  String email = '';
  String pass = '';
  bool isChecked = false;
  late TextEditingController controlEmail;
  late TextEditingController controlPass;
  //Basededados bd = Basededados();
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String idioma = 'pt';
  bool _isLoading = false;

  _checkIfisLoggedInFacebook() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = await FacebookAuth.instance.accessToken;
    await prefs.setString("tipoLogin", "facebook");
    setState(() {
      _checking = false;
    });

    if (accessToken != null) {
      print("Acess token: ${accessToken.toJson()}");
      final facebookData = await FacebookAuth.instance.getUserData();
      setState(() {
        _accessToken = accessToken;
        _facebookData = facebookData;
      });
      await prefs.setString("email", _facebookData!['email']);
      await prefs.setString("token", _accessToken!.tokenString);
      carregaDados();
      //Get and set user local with this data
      _facebookData!.forEach((key, value) {
        print('$key: $value');
      });
    } else {
      await _loginFacebook();
      //Get and set user local with this data
    }
  }

  Future<void> carregaDados() async {
    final context = this.context;
    final prefs = await SharedPreferences.getInstance();
    bool? exists = false;
    final tipo = prefs.getString("tipoLogin");

    try {
      setState(() {
        _isLoading = true;
      });
      if (tipo == "google") {
        final email = prefs.getString("email");
        final token = prefs.getString("token");
        Map<String, dynamic> json = {
          "tipo": "google",
          "email": email,
          "token": token,
        };
        await api.fetchAuthTokenWithFallback(json);
      } else if (tipo == "facebook") {
        final email = prefs.getString("email");
        final token = prefs.getString("token");
        Map<String, dynamic> json = {
          "tipo": "facebook",
          "email": email,
          "token": token,
        };
        await api.fetchAuthTokenWithFallback(json);
      } else if (tipo == "normal") {
        final email = await prefs.getString("email");
        final pass = await prefs.getString("pass");
        Map<String, dynamic> json = {
          "tipo": "normal",
          "email": email,
          "pass": pass,
        };
        await api.fetchAuthTokenWithFallback(json);
      }
      final utilStrin = prefs.getString("utilizadorObj");
      print(utilStrin);
      Utilizador util = Utilizador.fromJson(jsonDecode(utilStrin!));
      await prefs.setBool('isChecked', isChecked);
      NotificationPreferenceRepository notificationPreferenceRepository =
          NotificationPreferenceRepository();
      bool temprefs = await notificationPreferenceRepository
          .verificaPermissoesUtilizador(util.utilizadorId);
      if (!temprefs) {
        await notificationPreferenceRepository
            .criarPrefsutil(util.utilizadorId);
      }

      await carregaPolos();
      await carregaCategorias();
      SubcategoriaRepository subcategoriaRepository = SubcategoriaRepository();
      if (mounted) {
        await subcategoriaRepository.carregaSubategorias(context);
        DepartamentoRepository departamentoRepository =
            DepartamentoRepository();
        await departamentoRepository.carregaDepartamentos(context);
        FuncaoRepository funcaoRepositry = FuncaoRepository();
        await funcaoRepositry.carregaFuncoes(context);
        CidadeRepository cidadeRepository = CidadeRepository();
        await cidadeRepository.carregaCidades(context);
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(context, '/escolherPolo');
      }
    } catch (e) {
      setState(() {
          _isLoading = false;
        });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginInvalido)),
      );
    }
  }

  void resetUtil() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('utilizadorObj');
    prefs.remove('email');
    prefs.remove('token');
    prefs.remove('facebooktoken');
    prefs.remove('googletoken');
  }

  _loginFacebook() async {
    final prefs = await SharedPreferences.getInstance();
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final facebookData = await FacebookAuth.instance.getUserData();
      _facebookData = facebookData;
      _facebookData!.forEach((key, value) {
        print('$key: $value');
      });
      await prefs.setString("email", _facebookData!['email']);
      await prefs.setString("facebooktoken", _accessToken!.tokenString);
      carregaDados();
    } else {
      print(result.status);
      print(result.message);
    }
    setState(() {
      _checking = false;
    });
  }

  Future signInGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("tipoLogin", "google");
    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.googleFailed)));
    } else {
      print(
          "Sign in by google\nNome do user: ${user.displayName}, Email: ${user.email}");
      final googleAuth = await user.authentication;
      await prefs.setString("email", user.email);
      await prefs.setString("googletoken", googleAuth.accessToken!);
      //Get and set user local with this data
      carregaDados();
    }
  }

  _logoutFacebook() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _facebookData = null;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    return emailRegex.hasMatch(email);
  }

  void inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    bool? exists = false;
    String? idiomaProv = prefs.getString('idioma');
    if (idiomaProv != null) {
      setState(() {
        idioma = idiomaProv;
      });
    } else {
      prefs.setString('idioma', 'pt');
    }
    exists = prefs.getBool('isChecked');
    if (exists != null) {
      setState(() {
        isChecked = exists!;
      });
    }
    if (isChecked) {
      final tipo = await prefs.getString("tipoLogin");
      if (tipo == "google") {
        final email = prefs.getString("email");
        final token = prefs.getString("googletoken");
        Map<String, dynamic> json = {
          "tipo": "google",
          "email": email,
          "token": token,
        };
        api.fetchAuthTokenWithFallback(json);
      } else if (tipo == "facebook") {
        final email = await prefs.getString("email");
        final token = await prefs.getString("facebooktoken");
        Map<String, dynamic> json = {
          "tipo": "facebook",
          "email": email,
          "token": token,
        };
        api.fetchAuthTokenWithFallback(json);
      } else if (tipo == "normal") {
        final email = await prefs.getString("email");
        final pass = await prefs.getString("pass");
        Map<String, dynamic> json = {
          "tipo": "normal",
          "email": email,
          "pass": pass,
        };
        api.fetchAuthTokenWithFallback(json);
      }
      Navigator.pushNamed(context, "/home");
    } else {
      print("will execute logout");
      await FacebookAuth.instance.logOut();
      await GoogleSignInApi.logout();
    }
  }

  @override
  void initState() {
    super.initState();

    inicializar();
    controlEmail = TextEditingController();
    controlPass = TextEditingController();
    getVersion();
    passwordVisible = true;
  }

  @override
  void dispose() {
    //libertar recurso
    controlEmail.dispose();
    controlPass.dispose();
    super.dispose();
  }

  void sub() async {
    print("Passa por aqui");

    setState(() {
      email = controlEmail.text;
      pass = controlPass.text;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("utilizadorObj");
    prefs.setString("tipoLogin", "normal");
    prefs.setString("email", email);
    prefs.setString("pass", pass);
    await carregaDados();
    //bd.inserirvalor(Email, Passricao);
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  Future<void> carregaPolos() async {
    PoloRepository poloRepository = PoloRepository();

    try {
      // Fetch polos da api
      List<Polo> poloList = await poloRepository.fetchPolos();

      // Apagar todos os polos da base de dados
      await poloRepository.deleteAllPolos();

      for (Polo polo in poloList) {
        // Inserir polo na base de dados
        bool inseriu = await poloRepository.createPolo(polo);
        if (!inseriu) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.ocorreuErro),
            ),
          );
        }
      }
    } catch (e, stacktrace) {
      print("An error occurred: $e");
      print("Stacktrace: $stacktrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.ocorreuErro}: $e'),
        ),
      );
    }
  }

  // carrega as categorias
  Future<void> carregaCategorias() async {
    CategoriaRepository categoriaRepository = CategoriaRepository();

    try {
      // Fetch categorias da api
      List<Categoria> categoriaList =
          await categoriaRepository.fetchCategorias();

      // Apagar todas as categorias da base de dados
      categoriaRepository.deleteAllCategorias();

      for (Categoria categoria in categoriaList) {
        // Inserir categoria na base de dados
        bool inseriu = await categoriaRepository.createCategoria(categoria);
        if (!inseriu) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.ocorreuErro),
            ),
          );
        }
      }
    } catch (e, stacktrace) {
      print("An error occurred: $e");
      print("Stacktrace: $stacktrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.ocorreuErro}: $e'),
        ),
      );
    }
  }

  // carrega subcategorias

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ))
          : SafeArea(
              top: true,
              right: true,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.only(
                  top: altura * 0.01,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                //mainAxisSize: MainAxisSize.max,
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
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: controlEmail,
                                          decoration: const InputDecoration(
                                            labelText: "Email",
                                            prefixIcon: Icon(
                                                Icons.account_circle_outlined),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !isValidEmail(value)) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .insiraEmaiValido;
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: altura * 0.01),
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: passwordVisible,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          controller: controlPass,
                                          decoration: InputDecoration(
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                    .password),
                                            prefixIcon: const Icon(
                                                Icons.lock_outline_rounded),
                                            suffixIcon: IconButton(
                                              icon: Icon(passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisible =
                                                      !passwordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
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
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                          height: largura * 0.03,
                                        ),
                                        SizedBox(
                                          height: altura * 0.065,
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: () async {
                                              /*UtilizadorRepository rep = UtilizadorRepository();
                                        Utilizador utTeste = await rep.getUtilizador('37');
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.setString(
          'utilizadorObj', jsonEncode(utTeste.toJson()));*/
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                sub();
                                              }
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .login),
                                          ),
                                        ),
                                        SizedBox(
                                          height: largura * 0.03,
                                        ),
                                        // Esqueceu a password
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .forgotPassword,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, "/recuperarPass");
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .clickHere,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline),
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
                                                onTap: () async {
                                                  widget.mudaIdioma('pt');
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await prefs.setString(
                                                      'idioma', 'pt');
                                                },
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          altura * 0.01),
                                                      child: CountryFlag
                                                          .fromCountryCode(
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
                                                onTap: () async {
                                                  widget.mudaIdioma('es');
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await prefs.setString(
                                                      'idioma', 'es');
                                                },
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: CountryFlag
                                                          .fromCountryCode(
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
                                                onTap: () async {
                                                  widget.mudaIdioma('en');
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await prefs.setString(
                                                      'idioma', 'en');
                                                },
                                                child: CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: CountryFlag
                                                          .fromCountryCode(
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
                                          onPressed: _checkIfisLoggedInFacebook,
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: largura * 0.1,
                                                vertical: altura * 0.02),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  FontAwesomeIcons.facebook),
                                              SizedBox(width: largura * 0.02),
                                              const Text("Facebook"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: altura * 0.01),
                                        ElevatedButton(
                                          onPressed: signInGoogle,
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: largura * 0.1,
                                              vertical: altura * 0.02,
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
                                      ],
                                    ),
                                  ),
                                ],
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
                              child: Text(
                                  AppLocalizations.of(context)!.register,
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
