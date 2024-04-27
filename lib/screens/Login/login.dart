import "package:flutter/material.dart";
import 'package:country_flags/country_flags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EcraLogin extends StatefulWidget {
  const EcraLogin({super.key});

  @override
  State<EcraLogin> createState() {
    return _EcraLoginState();
  }
}

class _EcraLoginState extends State<EcraLogin> {
  String email = '';
  String pass = '';
  late TextEditingController controlEmail;
  late TextEditingController controlPass;
  //Basededados bd = Basededados();

  @override
  void initState() {
    super.initState();
    controlEmail = TextEditingController();
    controlPass = TextEditingController();
// inicializacao do controlador
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 100, bottom: 90),
        child: Container(
          color: Theme.of(context).canvasColor,
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'SoftShares',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Bem-vindo de volta",
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Ralize o Login",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                    child: Column(
                      children: [
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
                            labelText: "Palavra-passe",
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Esqueci-me da palavra-passe",
                              style: const TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Clique aqui",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {},
                            child: Text("Login"),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
