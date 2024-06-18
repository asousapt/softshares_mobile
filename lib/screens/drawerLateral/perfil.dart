import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/tab_perfil.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/perfil_img.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.utilizador});

  final Utilizador utilizador;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  Utilizador? user;
  Utilizador? userIni;
  String fotoUrl = "";

  @override
  void initState() {
    super.initState();
    userIni = widget.utilizador;
    user = Utilizador(
        widget.utilizador.utilizadorId,
        widget.utilizador.pNome,
        widget.utilizador.uNome,
        widget.utilizador.email,
        widget.utilizador.sobre,
        widget.utilizador.poloId,
        widget.utilizador.preferencias,
        widget.utilizador.funcaoId,
        widget.utilizador.departamentoId,
        widget.utilizador.fotoUrl);
  }

  // faz a validação dos dados antes de gravar
  bool validadados() {
    if (user!.pNome.isEmpty ||
        user!.uNome.isEmpty ||
        user!.poloId == 0 ||
        user!.departamentoId == 0 ||
        user!.funcaoId == 0 ||
        user!.sobre!.isEmpty ||
        user!.departamentoId == 0 ||
        user!.funcaoId == 0 ||
        user!.poloId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fillAllFields),
        ),
      );
      return false;
    }
    return true;
  }

  bool objectosIguais(Utilizador ut1, Utilizador ut2) {
    if (ut1.pNome != ut2.pNome ||
        ut1.uNome != ut2.uNome ||
        ut1.departamentoId != ut2.departamentoId ||
        ut1.email != ut2.email ||
        ut1.funcaoId != ut2.funcaoId ||
        ut1.poloId != ut2.poloId ||
        ut1.preferencias != ut2.preferencias ||
        ut1.sobre != ut2.sobre) {
      return false;
    }
    return true;
  }

  Future<bool> confirmExit(BuildContext context) async {
    // Show the ConfirmExitDialog and await user's decision
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        titulo: AppLocalizations.of(context)!.sairSemGuardar,
        msg: AppLocalizations.of(context)!.dadosSeraoPerdidos,
      ),
    );
    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String nomeCompleto = user!.getNomeCompleto();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          if (objectosIguais(userIni!, user!) == true) {
            Navigator.of(context).pop();
          } else {
            // vamos mostrar uma validacao para saber se ficamos ou nao neste ecra
            Future<bool> confirma = confirmExit(context);

            confirma.then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.check,
              ),
              onPressed: () {
                if (validadados()) {
                  // faz a alteração do objecto passado do widget anterior
                  widget.utilizador.departamentoId = user!.departamentoId;
                  widget.utilizador.email = user!.email;
                  widget.utilizador.funcaoId = user!.funcaoId;
                  widget.utilizador.pNome = user!.pNome;
                  widget.utilizador.poloId = user!.poloId;
                  widget.utilizador.preferencias = user!.preferencias;
                  widget.utilizador.sobre = user!.sobre;
                  widget.utilizador.uNome = user!.uNome;
                  //fecha o ecra anterior
                  Navigator.pop(context);
                }
              },
            ),
          ],
          title: Text(AppLocalizations.of(context)!.perfil),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 15,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfileWidget(
                  nome: nomeCompleto,
                  descricao: "Chefe de Vendas - Marketing",
                  fotoUrl: user!.fotoUrl!),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    child: TabPerfil(utilizador: user!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
