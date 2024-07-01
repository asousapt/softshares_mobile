import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/logo.dart';

class DefinicoesScreen extends StatefulWidget {
  const DefinicoesScreen({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  _DefinicoesScreenState createState() => _DefinicoesScreenState();
}

class _DefinicoesScreenState extends State<DefinicoesScreen> {
  bool _isNotificacoesExpanded = false;
  bool _isIdiomaExpanded = false;

  String _selectedIdioma = 'Português';

  bool _isMensagensEnabled = true;
  bool _isPostsEnabled = false;
  bool _isEventosEnabled = true;
  bool _isPontosDeInteresseEnabled = false;

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Definições'),
      ),
      body: SafeArea(
        top: true,
        right: true,
        bottom: true,
        child: Container(
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
                      title: Text(AppLocalizations.of(context)!.notificacoes),
                      trailing: Icon(
                        _isNotificacoesExpanded
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right,
                      ),
                      onTap: () {
                        setState(() {
                          _isNotificacoesExpanded = !_isNotificacoesExpanded;
                        });
                      },
                    ),
                    if (_isNotificacoesExpanded)
                      Column(
                        children: [
                          SwitchListTile(
                            title: Text(AppLocalizations.of(context)!.messages),
                            value: _isMensagensEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isMensagensEnabled = value;
                              });
                            },
                          ),
                          Divider(),
                          SwitchListTile(
                            title: Text("Posts"),
                            value: _isPostsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPostsEnabled = value;
                              });
                            },
                          ),
                          Divider(),
                          SwitchListTile(
                            title: Text(AppLocalizations.of(context)!.eventos),
                            value: _isEventosEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isEventosEnabled = value;
                              });
                            },
                          ),
                          Divider(),
                          SwitchListTile(
                            title: Text(
                                AppLocalizations.of(context)!.pontosInteresse),
                            value: _isPontosDeInteresseEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isPontosDeInteresseEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    Divider(),
                    ListTile(
                      title: Text('Idioma'),
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
                            title: Text('Português'),
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
                            title: Text('Inglês'),
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
                            title: Text('Espanhol'),
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
