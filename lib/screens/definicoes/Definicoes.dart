import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/notificacaoPref_repository.dart';
import 'package:softshares_mobile/models/notification_preference.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/logo.dart';

class DefinicoesScreen extends StatefulWidget {
  const DefinicoesScreen({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<StatefulWidget> createState() {
    return _DefinicoesScreenState();
  }
}

class _DefinicoesScreenState extends State<DefinicoesScreen> {
  bool _isNotificacoesExpanded = false;
  bool _isIdiomaExpanded = false;

  String _selectedIdioma = 'Português';

  bool _isPostsEnabled = false;
  bool _isEventosEnabled = false;
  bool _isPontosDeInteresseEnabled = false;
  bool isLoading = false;

  @override
  void initState() {
    carregaDados();
    super.initState();
  }

  // carrega os dados das preferências de notificação do utilizador logado
  Future<void> carregaDados() async {
    setState(() {
      isLoading = true;
    });
    NotificationPreferenceRepository notificationPreferenceRepository =
        NotificationPreferenceRepository();
    List<NotificationPreference> prefsUtil =
        await notificationPreferenceRepository.getPrefsUtil();

    for (var pref in prefsUtil) {
      if (pref.type == 'THREAD') {
        setState(() {
          _isPostsEnabled = pref.enabled;
        });
      } else if (pref.type == 'EVENTO') {
        setState(() {
          _isEventosEnabled = pref.enabled;
        });
      } else if (pref.type == 'POI') {
        setState(() {
          _isPontosDeInteresseEnabled = pref.enabled;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void atualizaDefinicoes(bool valor, String tipo) async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    NotificationPreferenceRepository notificationPreferenceRepository =
        NotificationPreferenceRepository();
    bool atualizou =
        await notificationPreferenceRepository.updateNotificationPreference(
      NotificationPreference(
          type: tipo, enabled: valor, utilizadorId: utilizadorId),
    );
    if (atualizou) {
      if (tipo == 'THREAD') {
        setState(() {
          _isPostsEnabled = valor;
        });
      } else if (tipo == 'EVENTO') {
        setState(() {
          _isEventosEnabled = valor;
        });
      } else if (tipo == 'POI') {
        setState(() {
          _isPontosDeInteresseEnabled = valor;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.definicoes),
      ),
      body: SafeArea(
        top: true,
        right: true,
        bottom: true,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).canvasColor,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: largura * 0.02),
                height: altura * 0.85,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: largura * 0.02, vertical: altura * 0.01),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.notificacoes),
                            trailing: Icon(
                              _isNotificacoesExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right,
                            ),
                            onTap: () {
                              setState(() {
                                _isNotificacoesExpanded =
                                    !_isNotificacoesExpanded;
                              });
                            },
                          ),
                          if (_isNotificacoesExpanded)
                            Column(
                              children: [
                                SwitchListTile(
                                  title: Text(
                                      AppLocalizations.of(context)!.threads),
                                  value: _isPostsEnabled,
                                  onChanged: (value) async {
                                    atualizaDefinicoes(value, 'THREAD');
                                  },
                                ),
                                const Divider(),
                                SwitchListTile(
                                  title: Text(
                                      AppLocalizations.of(context)!.eventos),
                                  value: _isEventosEnabled,
                                  onChanged: (value) async {
                                    atualizaDefinicoes(value, 'EVENTO');
                                  },
                                ),
                                const Divider(),
                                SwitchListTile(
                                  title: Text(AppLocalizations.of(context)!
                                      .pontosInteresse),
                                  value: _isPontosDeInteresseEnabled,
                                  onChanged: (value) async {
                                    atualizaDefinicoes(value, 'POI');
                                  },
                                ),
                              ],
                            ),
                          const Divider(),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.idioma),
                            trailing: Icon(
                              _isIdiomaExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right,
                            ),
                            onTap: () {
                              setState(() {
                                _isIdiomaExpanded = !_isIdiomaExpanded;
                              });
                            },
                          ),
                          if (_isIdiomaExpanded)
                            Column(
                              children: [
                                ListTile(
                                  leading: CountryFlag.fromCountryCode(
                                    'PT',
                                    height: largura * 0.03,
                                    width: largura * 0.03,
                                    borderRadius: 48,
                                  ),
                                  title: Text(
                                      AppLocalizations.of(context)!.portugues),
                                  trailing: _selectedIdioma == 'Português'
                                      ? Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedIdioma = 'Português';
                                      _isIdiomaExpanded = false;
                                      widget.mudaIdioma('pt');
                                    });
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: CountryFlag.fromCountryCode(
                                    'GB',
                                    height: largura * 0.03,
                                    width: largura * 0.03,
                                    borderRadius: 48,
                                  ),
                                  title: Text(
                                      AppLocalizations.of(context)!.ingles),
                                  trailing: _selectedIdioma == 'Inglês'
                                      ? Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedIdioma = 'Inglês';
                                      _isIdiomaExpanded = false;
                                      widget.mudaIdioma('en');
                                    });
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: CountryFlag.fromCountryCode(
                                    'ES',
                                    height: largura * 0.03,
                                    width: largura * 0.03,
                                    borderRadius: 48,
                                  ),
                                  title: Text(
                                      AppLocalizations.of(context)!.espanhol),
                                  trailing: _selectedIdioma == 'Espanhol'
                                      ? Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedIdioma = 'Espanhol';
                                      _isIdiomaExpanded = false;
                                      widget.mudaIdioma('es');
                                    });
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Logo(),
                  ],
                ),
              ),
      ),
    );
  }
}
