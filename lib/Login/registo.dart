import "package:flutter/material.dart";

class EcraRegistar extends StatelessWidget {
  const EcraRegistar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyHomePage(title: "Registo"),
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
  String nome = '';
  String descricao = '';
  late TextEditingController controlNome;
  late TextEditingController controlDesc;
  //Basededados bd = Basededados();

  @override
  void initState() {
    super.initState();
    controlNome = TextEditingController();
    controlDesc = TextEditingController();
// inicializac¸˜ao do controlador
  }

  @override
  void dispose() {
    //libertar recurso
    controlNome.dispose();
    controlDesc.dispose();
    super.dispose();
  }

  void sub() {
    setState(() {
      nome = controlNome.text;
      descricao = controlDesc.text;
    });
    //bd.inserirvalor(nome, descricao);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aula 7"),
      ),
      body: Column(
        children: <Widget>[
          const Text("Nome",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          TextField(
            controller: controlNome,
          ),
          const Text("Descricao",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          TextField(
            controller: controlDesc,
          ),
          ElevatedButton(onPressed: sub, child: Text("Submeter"))
        ],
      ),
    );
  }
}
