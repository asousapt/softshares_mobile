import "package:flutter/material.dart";

class EcraRegistar extends StatelessWidget {
  const EcraRegistar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyHomePage(title: "Softshares"),
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
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
        padding: EdgeInsets.all(60),
        child: Column(
          children: <Widget>[
            Text(
              "Criar uma conta",
              style: TextStyle(
                fontSize: 55, // Set the font size to 20
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 48, 48,
                    48), // Set the color to dark grey (800 is the shade)
              ),
            ),
            Text(
              "Bem  Vindo de volta\nRealize o rEcraRegistar",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controlEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Adjust the value as needed
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
            ElevatedButton(onPressed: sub, child: Text("rEcraRegistar")),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: sub,
                child: Row(
                  children: [
                    Icon(Icons.facebook_outlined),
                    Text("Facebook"),
                  ],
                )),
            ElevatedButton(
                onPressed: sub,
                child: Row(
                  children: [
                    Icon(Icons.apps),
                    Text("Google"),
                  ],
                )),
          ],
        ),
      ),
      backgroundColor: Color(0xFF0465D9),
    );
  }
}
