import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class MensagemDetalheScreen extends StatefulWidget {
  const MensagemDetalheScreen({
    super.key,
    required this.mensagemId,
    required this.nome,
    required this.imagemUrl,
  });

  final int mensagemId;
  final String nome;
  final String imagemUrl;

  @override
  State<StatefulWidget> createState() {
    return _MensagemDetalheScreenState();
  }
}

class _MensagemDetalheScreenState extends State<MensagemDetalheScreen> {
  final TextEditingController _messageController = TextEditingController();
  final int utilizadorId = 1;
  List<Mensagem> mensagens = [];
  bool _isLoading = false;

  // Função que busca as mensagens
  Future<List<Mensagem>> fetchMensagens() async {
    await Future.delayed(Duration(seconds: 2));
    List<Mensagem> messages = [
      Mensagem(
        mensagemId: 1,
        mensagemTexto: 'Hello John!',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(hours: 1)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 2,
        mensagemTexto: 'Hi Alice! How are you doing?',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 50)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 3,
        mensagemTexto: 'I\'m good, thanks! Just got back from vacation.',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 45)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 4,
        mensagemTexto: 'That\'s awesome! Where did you go?',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 40)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 5,
        mensagemTexto: 'I went to the mountains. It was so refreshing!',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 35)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 6,
        mensagemTexto: 'Sounds amazing! I could use a vacation myself.',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 30)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 7,
        mensagemTexto: 'Hello John!',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(hours: 1)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 8,
        mensagemTexto: 'Hi Alice! How are you doing?',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 50)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 9,
        mensagemTexto: 'I\'m good, thanks! Just got back from vacation.',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 45)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 10,
        mensagemTexto: 'That\'s awesome! Where did you go?',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 40)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 11,
        mensagemTexto: 'I went to the mountains. It was so refreshing!',
        remetente: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 35)),
        anexos: [],
        vista: true,
      ),
      Mensagem(
        mensagemId: 12,
        mensagemTexto:
            'Sounds amazing! I could use a vacation myself Sounds amazing! I could use a vacation myself Sounds amazing! I could use a vacation myself Sounds amazing! I could use a vacation myself jfnhewjknfkjewnfkjnewkjfnkjewnf.',
        remetente: Utilizador(2, 'John', 'Doe', 'john.doe@example.com',
            'Some info', 1, [1, 2], 1, 1),
        destinatarioUtil: Utilizador(1, 'Alice', 'Johnson',
            'alice.johnson@example.com', 'Some info', 1, [1, 2], 1, 1),
        dataEnvio: DateTime.now().subtract(Duration(minutes: 30)),
        anexos: [],
        vista: true,
      ),
    ];
    return messages;
  }

  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    mensagens = await fetchMensagens();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            padding:
                EdgeInsets.only(right: largura * 0.02, left: largura * 0.02),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: largura * 0.02,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.imagemUrl,
                  ),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: largura * 0.02,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nome,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: altura * 0.01,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                )
              : ListView.builder(
                  itemCount: mensagens.length + 1, // Include one extra item
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: altura * 0.02, bottom: altura * 0.02),
                  itemBuilder: (context, index) {
                    if (index == mensagens.length) {
                      // This is the last item, return an extra SizedBox for spacing
                      return SizedBox(height: altura * 0.1);
                    }
                    bool isSender =
                        mensagens[index].remetente.utilizadorId == utilizadorId;
                    return Container(
                      padding: EdgeInsets.only(
                          left: largura * 0.02,
                          right: largura * 0.02,
                          top: altura * 0.02,
                          bottom: altura * 0.02),
                      child: Align(
                        alignment:
                            (isSender ? Alignment.topRight : Alignment.topLeft),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (isSender
                                ? Theme.of(context)
                                    .secondaryHeaderColor
                                    .withOpacity(0.8)
                                : Theme.of(context).canvasColor),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: largura * 0.02,
                              vertical: altura * 0.02),
                          child: Text(
                            mensagens[index].mensagemTexto,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                left: largura * 0.02,
                bottom: altura * 0.02,
                top: altura * 0.02,
              ),
              height: altura * 0.1,
              width: double.infinity,
              color: Theme.of(context).canvasColor,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: altura * 0.06,
                      width: largura * 0.12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        FontAwesomeIcons.plus,
                        color: Theme.of(context).canvasColor,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: largura * 0.02),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: largura * 0.02,
                  ),
                  Container(
                    height: altura * 0.06,
                    width: largura * 0.12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Substituir pela função de envio de mensagem
                        if (_messageController.text.trim().isNotEmpty) {
                          setState(() {
                            mensagens.add(
                              Mensagem(
                                mensagemId: mensagens.length + 1,
                                mensagemTexto: _messageController.text.trim(),
                                remetente: Utilizador(
                                  utilizadorId,
                                  'Alice',
                                  'Johnson',
                                  'alice.johnson@example.com',
                                  'Some info',
                                  1,
                                  [1, 2],
                                  1,
                                  1,
                                ),
                                destinatarioUtil: Utilizador(
                                  2,
                                  'John',
                                  'Doe',
                                  'john.doe@example.com',
                                  'Some info',
                                  1,
                                  [1, 2],
                                  1,
                                  1,
                                ),
                                dataEnvio: DateTime.now(),
                                anexos: [],
                                vista: true,
                              ),
                            );
                            _messageController.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).canvasColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
