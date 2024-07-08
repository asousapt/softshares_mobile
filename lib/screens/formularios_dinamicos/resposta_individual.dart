import 'package:flutter/material.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/Repositories/formulario_repository.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Repositories/respostadetalhe_repository.dart';

class RespostaIndividualScreen extends StatefulWidget {
  const RespostaIndividualScreen({
    super.key,
    required this.evento,
    required this.utilizador,
  });

  final Evento evento;
  final int utilizador;

  @override
  State<StatefulWidget> createState() {
    return _RespostaIndividualScreenState();
  }
}

class _RespostaIndividualScreenState extends State<RespostaIndividualScreen>
    with SingleTickerProviderStateMixin {
  Formulario? formulario;
  String? tituloForm;
  String? tipoForm;
  List<RespostaDetalhe> respostasformInsc = [];
  List<RespostaDetalhe> respostasformQualidade = [];
  bool _isLoading = true;
  late TabController _tabController;
  bool _secondTabActivated = false;
  late int utilizadorId;
  late Evento evento;
  late int formInscId;
  late int formQualId;
  Formulario? formInsc;
  Formulario? formQual;

  @override
  void initState() {
    utilizadorId = widget.utilizador;
    evento = widget.evento;

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchFormularios().then((value) {
      fetchRespostas();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Retorna o formulario da API
  Future<void> fetchFormularios() async {
    setState(() {
      _isLoading = true;
    });
    EventoRepository eventoRepository = EventoRepository();
    int formInscIdl = await eventoRepository.getFormId(evento, "INSCR");
    int formQualIdl = await eventoRepository.getFormId(evento, "QUALIDADE");
    setState(() {
      formInscId = formInscIdl;
      formQualId = formQualIdl;
    });

    if (formInscId > 0) {
      FormularioRepository formularioRepository = FormularioRepository();

      Formulario fetchedFormulario =
          await formularioRepository.getFormulariobyId(formInscId);

      setState(() {
        formInsc = fetchedFormulario;
      });

      if (formQualId > 0) {
        Formulario fetchedFormularioQual =
            await formularioRepository.getFormulariobyId(formQualId);
        setState(() {
          _secondTabActivated = true;
          formQual = fetchedFormularioQual;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Retorna as respostas ao formulario da API
  Future<void> fetchRespostas() async {
    setState(() {
      _isLoading = true;
    });
    RespostaDetalheRepository respostaDetalheRepository =
        RespostaDetalheRepository();
    List<RespostaDetalhe> respostasInscl =
        await respostaDetalheRepository.getRespostasDetalhe(
            evento.eventoId!, "EVENTO", formInscId, utilizadorId);

    List<RespostaDetalhe> respostasQuall =
        await respostaDetalheRepository.getRespostasDetalhe(
            evento.eventoId!, "EVENTO", formQualId, utilizadorId);
    setState(() {
      respostasformQualidade =
          respostaDetalheRepository.groupRespostas(respostasQuall);
      respostasformInsc =
          respostaDetalheRepository.groupRespostas(respostasInscl);
      _isLoading = false;
    });
  }

  // constroi o ecra de respostas ao formulario
  Widget buildFormContent(
    BuildContext context,
    double altura,
    double largura,
    Formulario? form,
    List<RespostaDetalhe> respostas,
  ) {
    return Container(
      height: altura * 0.9,
      color: Theme.of(context).canvasColor,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              form?.titulo ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.getEnumValue(form!.tipoFormulario!),
            ),
            SizedBox(height: altura * 0.02),
            Expanded(
                child: respostas.isNotEmpty
                    ? ListView.builder(
                        itemCount: respostas.length,
                        itemBuilder: (context, index) {
                          RespostaDetalhe resposta = respostas[index];
                          return ListTile(
                            title: Text(
                              resposta.pergunta?.pergunta ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(resposta.resposta ?? ''),
                          );
                        },
                      )
                    : Center(
                        child: Text(AppLocalizations.of(context)!.naoHaDados),
                      )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.respostaFormulario),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!
                  .getEnumValue(TipoFormulario.inscr),
            ),
            Tab(
              text: AppLocalizations.of(context)!
                  .getEnumValue(TipoFormulario.inscr),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).canvasColor,
              ))
            : TabBarView(
                controller: _tabController,
                children: [
                  formInsc != null
                      ? buildFormContent(
                          context, altura, largura, formInsc, respostasformInsc)
                      : Container(
                          color: Theme.of(context).canvasColor,
                          child: Center(
                            child:
                                Text(AppLocalizations.of(context)!.naoHaDados),
                          ),
                        ),
                  _secondTabActivated && formQual != null
                      ? buildFormContent(context, altura, largura, formQual!,
                          respostasformQualidade)
                      : Container(
                          color: Theme.of(context).canvasColor,
                          child: Center(
                            child:
                                Text(AppLocalizations.of(context)!.naoHaDados),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
