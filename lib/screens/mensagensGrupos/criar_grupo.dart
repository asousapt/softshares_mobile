import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CriarGrupoScreen extends StatefulWidget {
  const CriarGrupoScreen({super.key});

  @override
  State<CriarGrupoScreen> createState() {
    return _CriarGrupoScreenState();
  }
}

class _CriarGrupoScreenState extends State<CriarGrupoScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  bool publico = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createGroup),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: largura * 0.02,
          vertical: altura * 0.02,
        ),
        child: Container(
          height: altura * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: largura * 0.02,
              vertical: altura * 0.02,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  maxLength: 60,
                  decoration: InputDecoration(
                    labelText: "Nome do grupo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: altura * 0.02),
                TextFormField(
                  controller: _descricaoController,
                  maxLength: 140,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Descricão do grupo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: altura * 0.02),
                Row(
                  children: [
                    Checkbox(
                      value: publico,
                      onChanged: (value) {
                        setState(() {
                          publico = value!;
                        });
                      },
                    ),
                    SizedBox(width: largura * 0.02),
                    Text("Público"),
                  ],
                ),
                SizedBox(height: altura * 0.02),
                Text("data"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
