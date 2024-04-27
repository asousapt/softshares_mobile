import "package:flutter/material.dart";

class EcraLogin extends StatelessWidget {
  const EcraLogin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const MyHomePage(title: "Softshares"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFFFFFFF)),
              padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Softshares",
                    style: TextStyle(
                      fontSize: 55, // Set the font size to 20
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 48, 48,
                          48), // Set the color to dark grey (800 is the shade)
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Bem Vindo de volta\nRealize o login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  TextField(
                    controller: controlEmail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: controlPass,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the value as needed
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Esqueci-me da password. ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      TextButton(
                        onPressed: () =>
                            {Navigator.pushNamed(context, "/recuperarPass")},
                        child: const Text("Clicar Aqui",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FilledButton(
                    onPressed: sub,
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10
                      ),
                      textStyle: TextStyle(
                        fontSize: 22, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.circle)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.circle))
                    ],
                  ),
                  Divider(color: Color(0xFF0465D9),),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: sub,
                      style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10), // Adjust padding as needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.facebook_outlined),
                          Text("Facebook"),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: sub,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apps),
                          Text("Google"),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Não tens conta? ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              TextButton(
                onPressed: () => {Navigator.pushNamed(context, "/registar")},
                child: const Text("Registar",
                    style: TextStyle(
                        color: Color(0xFF83B1FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              )
            ],
          )
        ],
      ),
      backgroundColor: Color(0xFF0465D9),
    );
  }
}
