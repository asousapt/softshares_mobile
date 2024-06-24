import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/tab_perfil.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/perfil_img.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.utilizador,
  });

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
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    userIni = widget.utilizador;

    user = Utilizador(
      utilizadorId: widget.utilizador.utilizadorId,
      pNome: widget.utilizador.pNome,
      uNome: widget.utilizador.uNome,
      email: widget.utilizador.email,
      sobre: widget.utilizador.sobre,
      poloId: widget.utilizador.poloId,
      preferencias: widget.utilizador.preferencias,
      funcaoId: widget.utilizador.funcaoId,
      departamentoId: widget.utilizador.departamentoId,
      fotoUrl: widget.utilizador.fotoUrl,
      fotoEnvio: widget.utilizador.fotoEnvio,
      idiomaId: widget.utilizador.idiomaId,
    );
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          if (objectosIguais(userIni!, user!)) {
            Navigator.of(context).pop();
          } else {
            // show confirmation dialog
            bool confirm = await confirmExit(context);
            if (confirm) {
              Navigator.of(context).pop();
            }
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
              onPressed: () async {
                if (validadados()) {
                  // muda o estado para mostrar o loading
                  setState(() {
                    isSaving = true;
                  });

                  user!.fotoUrl = fotoUrl;

                  UtilizadorRepository utilizadorRepository =
                      UtilizadorRepository();
                  await utilizadorRepository
                      .updateUtilizador(user!)
                      .then((value) async {
                    if (value > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.dadosGravados),
                        ),
                      );
                      Utilizador utilizadorRefresh = await utilizadorRepository
                          .getUtilizador(user!.utilizadorId.toString());

                      Map<String, dynamic> utilJson =
                          utilizadorRefresh.toJson();
                      print(utilJson);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                          'utilizadorObj', jsonEncode(utilJson));

                      // muda o estado para ocultar o loading
                      setState(() {
                        isSaving = false;
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.ocorreuErro),
                        ),
                      );
                      // muda o estado para ocultar o loading
                      setState(() {
                        isSaving = false;
                      });
                    }
                  });

                  // Navigator.pop(context);
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
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserProfileWidget(
                    utilizador: user!,
                  ),
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
              if (isSaving)
                Container(
                  color: Colors.white.withOpacity(0.4),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).canvasColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
