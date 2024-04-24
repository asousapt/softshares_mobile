import "package:flutter/material.dart";

class EcraLogin extends StatelessWidget {
  const EcraLogin({Key? key}) : super(key: key);
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
      body: Padding(
        padding: EdgeInsets.all(100),
        child: Column(
          children: <Widget>[
            Text(
              "Softshares",
              style: TextStyle(
                fontSize: 65, // Set the font size to 20
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 48, 48,
                    48), // Set the color to dark grey (800 is the shade)
              ),
            ),
            Text(
              "Bem  Vindo de volta\nRealize o login",
              textAlign: TextAlign.center,
            ),
            TextField(
                controller: controlEmail,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: "Email")),
                
            TextField(
              controller: controlPass,
              decoration: InputDecoration(
                prefixIcon : Icon(Icons.lock_outline_rounded),
                labelText: "Password"),
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
            ElevatedButton(onPressed: sub, child: Text("Login")),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: sub, child: Row(
              children: [
                Icon(Icons.facebook_outlined),
                Text("Facebook"),
              ],
            )),
            ElevatedButton(onPressed: sub, child: Row(
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
