import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class TabPerfil extends StatefulWidget {
  TabPerfil({super.key, required this.utilizador});

  Utilizador utilizador;
  @override
  State<StatefulWidget> createState() {
    return _TabPerfilState();
  }
}

class _TabPerfilState extends State<TabPerfil> with TickerProviderStateMixin {
  final TextEditingController _pnome = TextEditingController();
  final TextEditingController _unome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _passwd = TextEditingController();
  final TextEditingController _sobre = TextEditingController();
  bool? isFieldEmpty;

  @override
  void initState() {
    super.initState();

    //Carrega a informação vinda do ecrã anterior
    _pnome.text = widget.utilizador.pNome;
    _unome.text = widget.utilizador.uNome;
    _email.text = widget.utilizador.email;
    _sobre.text = widget.utilizador.sobre;

    if (_pnome.text.isEmpty) {
      setState(() {
        isFieldEmpty = true;
      });
    } else {
      setState(() {
        isFieldEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TabBar(
              tabs: [
                CustomTab(
                  icon: FontAwesomeIcons.user,
                  text: "Dados Pessoais",
                ),
                CustomTab(
                  icon: FontAwesomeIcons.heart,
                  text: "Favoritos",
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLength: 60,
                        controller: _pnome,
                        decoration: InputDecoration(
                          label: Text("Primeiro nome"),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isFieldEmpty! ? Colors.red : Colors.grey),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              isFieldEmpty = true;
                              print(isFieldEmpty);
                            });
                          } else {
                            setState(() {
                              isFieldEmpty = false;
                              widget.utilizador.pNome = value;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        maxLength: 60,
                        controller: _unome,
                        decoration: InputDecoration(
                          label: Text("último nome"),
                        ),
                        onChanged: (value) {},
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _email,
                        decoration: InputDecoration(
                          label: Text("Email"),
                        ),
                      ),
                      TextFormField(
                        controller: _passwd,
                        decoration: InputDecoration(
                          label: Text("Password"),
                        ),
                      ),
                      TextFormField(
                        minLines: 5,
                        maxLines: 7,
                        controller: _sobre,
                        decoration: InputDecoration(
                          label: Text("Sobre mim "),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text("222"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
