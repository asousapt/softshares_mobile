import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/tab_perfil.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/perfil_img.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.utilizador});

  final Utilizador utilizador;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Utilizador user = widget.utilizador;
    String nomeCompleto = user.getNomeCompleto();

    // faz a validação dos dados antes de gravar
    bool validadados() {
      if (user.pNome.isEmpty ||
          user.uNome.isEmpty ||
          user.poloId == 0 ||
          user.departamentoId == 0 ||
          user.funcaoId == 0 ||
          user.sobre.isEmpty ||
          user.departamentoId == 0 ||
          user.funcaoId == 0 ||
          user.poloId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Campos não preenchidos"),
          ),
        );
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.check,
              color: Color.fromRGBO(29, 90, 161, 1),
            ),
            onPressed: () {
              if (validadados()) {
                setState(() {});
              }
            },
          ),
        ],
        title: const Text("Perfil"),
      ),
      backgroundColor: const Color.fromRGBO(29, 90, 161, 1),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 15,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfileWidget(
                nome: nomeCompleto,
                descricao: "Chefe de Vendas - Marketing",
              ),
              Container(
                color: const Color.fromRGBO(217, 215, 215, 1),
                child: TabPerfil(
                  utilizador: user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
