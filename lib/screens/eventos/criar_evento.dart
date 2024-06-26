import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/formulario_cfg.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/widgets/gerais/foto_picker.dart';
import '../../time_utils.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:softshares_mobile/screens/generic/location_picker.dart';

class CriarEventoScreen extends StatefulWidget {
  const CriarEventoScreen({super.key});

  @override
  State<CriarEventoScreen> createState() {
    return _CriarEventoScreen();
  }
}

class _CriarEventoScreen extends State<CriarEventoScreen> {
  final _tituloController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _dateIni = TextEditingController();
  final _timeIni = TextEditingController();
  final _dateFim = TextEditingController();
  final _timeFim = TextEditingController();
  final _nmrMaxParticipantes = TextEditingController();
  final _nmrConvidados = TextEditingController();
  final _descricao = TextEditingController();
  final _dataLimiteInscricao = TextEditingController();
  String? _categoriaId;
  String? _subCategoriaId;
  int? nmrMaxParticipantes;
  bool? permiteConvidados;
  int? nmrConvidados;
  String? descricao;
  List<Formulario> forms = [];
  List<Categoria>? categorias;
  List<Subcategoria>? subcategorias;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  double latitude = 0.0;
  double longitude = 0.0;
  int utilizadorId = 0;
  int poloId = 0;
  List<XFile> images = [];

  Future<void> carregarCategoriasSubcats() async {
    final prefs = await SharedPreferences.getInstance();
    final int idiomaId = prefs.getInt("idiomaId") ?? 1;
    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasL =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    SubcategoriaRepository subcategoriaRepository = SubcategoriaRepository();
    List<Subcategoria> subcategoriasL =
        await subcategoriaRepository.fetchSubcategoriasDB(idiomaId);

    // Carrega ytilizadorId
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    utilizadorId = utilizador.utilizadorId;
    poloId = utilizador.poloId;

    setState(() {
      categorias = categoriasL;
      subcategorias = subcategoriasL;
      _isLoading = false;
    });
  }

  DateTime selected = DateTime.now();
  DateTime initial = DateTime(DateTime.now().year);
  DateTime last = DateTime(DateTime.now().year + 1);

  TimeOfDay timeOfDay = TimeOfDay.now();

  void _updateImages(List<XFile> newImages) {
    setState(() {
      images = newImages;
      print("tamanho: ${images.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    carregarCategoriasSubcats().then((value) {
      setState(() {
        _categoriaId = categorias![0].categoriaId.toString();
        _subCategoriaId = subcategorias![0].subcategoriaId.toString();
      });
    });
    _nmrMaxParticipantes.text = "0";
    nmrMaxParticipantes = 0;
    permiteConvidados = false;
    nmrConvidados = 0;
    descricao = "";
    forms = [];
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _localizacaoController.dispose();
    _dateIni.dispose();
    _timeIni.dispose();
    _dateFim.dispose();
    _timeFim.dispose();
    _nmrMaxParticipantes.dispose();
    _nmrConvidados.dispose();
    _descricao.dispose();
    _dataLimiteInscricao.dispose();
    super.dispose();
  }

  // chama o date picker para a selecção da hora de inicio
  Future<void> _selectStartTime(BuildContext context) async {
    await displayTimePicker(context, _timeIni, timeOfDay);
  }

  // chama o date picker para a selecção da hora de fim
  Future<void> _selectEndTime(BuildContext context) async {
    await displayTimePicker(context, _timeFim, timeOfDay);
  }

  // chama o date picker para a selecção da data de início
  Future<void> _selectStartDate(BuildContext context) async {
    await displayDatePicker(
      context,
      _dateIni,
      selected,
      initial,
      last,
    );
  }

  // chama o date picker para a selecção da data de fim
  Future<void> _selectEndDate(BuildContext context) async {
    await displayDatePicker(
      context,
      _dateFim,
      selected,
      initial,
      last,
    );
  }

  // chama o date picker para a selecção da data limite de inscrição
  Future<void> _selectDeadLineDate(BuildContext context) async {
    await displayDatePicker(
      context,
      _dataLimiteInscricao,
      selected,
      initial,
      last,
    );
  }

  // faz a validação das datas
  String? validaDatas(String campo) {
    DateTime dataInicio = DateTime.parse(_dateIni.text);
    DateTime dataFim = DateTime.parse(_dateFim.text);
    TimeOfDay horaInicio = parseTimeOfDay(_timeIni.text);
    TimeOfDay horaFim = parseTimeOfDay(_timeFim.text);
    DateTime agora = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    // Verifica se a data de início é anterior à data atual
    if (dataInicio.isBefore(agora)) {
      switch (campo) {
        case "dataInicio":
          return AppLocalizations.of(context)!.dataInicioAntHoje;
        case "horaInicio":
          return "";

        default:
          return "";
      }
    }

    // Verifica se a data de fim é anterior à data atual
    if (dataFim.isBefore(agora)) {
      switch (campo) {
        case "dataFim":
          return AppLocalizations.of(context)!.dataFimAntHoje;
        case "horaFim":
          return "";
      }
    }

    // Verifica se a data de fim é anterior à data de início
    if (dataFim.isBefore(dataInicio)) {
      switch (campo) {
        case "dataFim":
          return AppLocalizations.of(context)!.dataFimAntInicio;
        case "horaFim":
          return "";
      }
    }

    // verifica os campos das horas de início e fim
    if (dataInicio.isAtSameMomentAs(dataFim)) {
      if (horaFim.hour < horaInicio.hour ||
          (horaFim.hour == horaInicio.hour &&
              horaFim.minute < horaInicio.minute)) {
        switch (campo) {
          case "dataFim":
            return AppLocalizations.of(context)!.horaFimAntInicio;
          case "horaFim":
            return "";
        }
      }
    }

    return null;
  }

  /* Seçao de adicionar formulario à lista */

  bool _adicionaFormulario(Formulario formulario) {
    // verifica se o formulário já existe na lista
    final index = forms.indexWhere((form) => form.formId == formulario.formId);
    print(index);

    if (index != -1) {
      // A editar um formulário existente
      setState(() {
        forms[index] = formulario;
      });
      return true;
    } else {
      // Adicionar um novo formulário
      if (forms.isEmpty) {
        setState(() {
          forms.add(formulario);
        });
        return true;
      } else if (forms.length == 1) {
        // Verifica se o formulário a adicionar é do mesmo tipo que o existente
        if (forms[0].tipoFormulario == formulario.tipoFormulario) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.naoPodeAdicionarForm),
            ),
          );
          return false;
        } else {
          setState(() {
            forms.add(formulario);
          });
          return true;
        }
      }
      return true;
    }
  }

  /* Fim Seçao de adicionar formulario à lista */

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_tituloController.text.isNotEmpty ||
              _localizacaoController.text.isNotEmpty ||
              _dateIni.text.isNotEmpty ||
              _timeIni.text.isNotEmpty ||
              _dateFim.text.isNotEmpty ||
              _timeFim.text.isNotEmpty ||
              _dataLimiteInscricao.text.isNotEmpty ||
              _categoriaId!.isNotEmpty ||
              _subCategoriaId!.isNotEmpty ||
              _nmrMaxParticipantes.text.isNotEmpty ||
              _descricao.text.isNotEmpty) {
            Future<bool> confirma = confirmExit(
              context,
              AppLocalizations.of(context)!.sairSemGuardar,
              AppLocalizations.of(context)!.dadosSeraoPerdidos,
            );

            confirma.then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.criarEvento,
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: largura * 0.02, vertical: altura * 0.02),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).canvasColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FotoPicker(
                                    pickedImages: images,
                                    onImagesPicked: _updateImages,
                                  ),
                                  SizedBox(height: altura * 0.02),

                                  Text(
                                    AppLocalizations.of(context)!
                                        .detalhesEvento,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    maxLength: 160,
                                    controller: _tituloController,
                                    decoration: InputDecoration(
                                      label: Text(
                                          AppLocalizations.of(context)!.titulo),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "${AppLocalizations.of(context)!.porfavorInsiraO} ${AppLocalizations.of(context)!.titulo}";
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    maxLength: 160,
                                    controller: _localizacaoController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          LatLng? localizacao =
                                              await Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const LocationPicker(),
                                          ));
                                          if (localizacao != null) {
                                            latitude = localizacao.latitude;
                                            longitude = localizacao.longitude;
                                          }
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.locationDot),
                                      ),
                                      label: Text(AppLocalizations.of(context)!
                                          .localizacao),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "${AppLocalizations.of(context)!.porfavorInsiraA} ${AppLocalizations.of(context)!.localizacao}";
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: altura * 0.02),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                                overflow: TextOverflow.visible),
                                            errorStyle: const TextStyle(
                                                overflow: TextOverflow.visible),
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .dataHoraIni,
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _selectStartDate(context);
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.calendar),
                                            ),
                                          ),
                                          controller: _dateIni,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                _timeIni.text.isEmpty) {
                                              return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.dataHoraIni}";
                                            }
                                            return validaDatas("dataInicio");
                                          },
                                        ),
                                      ),
                                      SizedBox(width: largura * 0.02),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _selectStartTime(context);
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.clock),
                                            ),
                                          ),
                                          controller: _timeIni,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                _dateIni.text.isEmpty) {
                                              return "";
                                            }

                                            return validaDatas("horaInicio");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .dataHoraFim,
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _selectEndDate(context);
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.calendar),
                                            ),
                                          ),
                                          controller: _dateFim,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                _timeFim.text.isEmpty) {
                                              return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.dataHoraFim}";
                                            }

                                            return validaDatas("dataFim");
                                          },
                                        ),
                                      ),
                                      SizedBox(width: largura * 0.02),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _selectEndTime(context);
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.clock),
                                            ),
                                          ),
                                          controller: _timeFim,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                _dateFim.text.isEmpty) {
                                              return "";
                                            }

                                            return validaDatas("horaFim");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    controller: _dataLimiteInscricao,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .dataLimiteInscricao,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                            FontAwesomeIcons.calendar),
                                        onPressed: () {
                                          _selectDeadLineDate(context);
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      DateTime hoje = DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          0,
                                          0,
                                          0);
                                      if (value == null || value.isEmpty) {
                                        return "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.dataLimiteInscricao}";
                                      }

                                      if (DateTime.parse(value)
                                          .isBefore(hoje)) {
                                        return AppLocalizations.of(context)!
                                            .dataLimiteAntHoje;
                                      }

                                      if (DateTime.parse(value).isAfter(
                                          DateTime.parse(_dateIni.text))) {
                                        return AppLocalizations.of(context)!
                                            .dataLimiteSupInicio;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  // Selecção de categoria
                                  DropdownButtonFormField(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hint: Text(AppLocalizations.of(context)!
                                        .categoria),
                                    isExpanded: true,
                                    value: _categoriaId.toString(),
                                    items: getListaCatDropdown(categorias!),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _categoriaId = value;
                                          _subCategoriaId = subcategorias!
                                              .where((e) =>
                                                  e.categoriaId ==
                                                  int.parse(value))
                                              .first
                                              .subcategoriaId
                                              .toString();
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  //selecção de subcategoria
                                  DropdownButton(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    borderRadius: BorderRadius.circular(20),
                                    hint: Text(AppLocalizations.of(context)!
                                        .subCategoria),
                                    isExpanded: true,
                                    value: _subCategoriaId.toString(),
                                    items: getListaSubCatDropdown(
                                        subcategorias!,
                                        int.parse(_categoriaId!)),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _subCategoriaId = value;
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _nmrMaxParticipantes,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!
                                          .nmrMaxParticipantes),
                                    ),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          nmrMaxParticipantes =
                                              int.parse(value);
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  // Secção de convidados permitidos
                                  Row(
                                    children: [
                                      Checkbox(
                                        tristate: false,
                                        value: permiteConvidados,
                                        onChanged: (value) {
                                          setState(() {
                                            permiteConvidados = value;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _nmrConvidados,
                                          enabled: permiteConvidados,
                                          decoration: InputDecoration(
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                    .nmrMaxConvidados),
                                          ),
                                          validator: (value) {
                                            if (permiteConvidados == true &&
                                                (value == null ||
                                                    value.isEmpty)) {
                                              return "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.nmrMaxConvidados}";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    maxLines: 2,
                                    controller: _descricao,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!
                                          .descricao),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        descricao = value;
                                      });
                                    },
                                    validator: (value) => value!.isEmpty
                                        ? "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.descricao}"
                                        : null,
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  // LISTA DE FORMULARIOS
                                  forms.isNotEmpty
                                      ? Text(
                                          AppLocalizations.of(context)!
                                              .formularios,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const SizedBox(height: 0),
                                  forms.isNotEmpty
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              for (var form in forms)
                                                ListTile(
                                                  title: Text(form.titulo),
                                                  subtitle: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .getEnumValue(form
                                                              .tipoFormulario!)),
                                                  trailing: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () {
                                                      setState(() {
                                                        forms.remove(form);
                                                      });
                                                    },
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfiguracaoFormularioScreen(
                                                          adicionaFormulario:
                                                              _adicionaFormulario,
                                                          formulario: form,
                                                          formId: form.formId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(height: 0),
                                  SizedBox(height: altura * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_tituloController
                                                  .text.isNotEmpty ||
                                              _localizacaoController
                                                  .text.isNotEmpty ||
                                              _dateIni.text.isNotEmpty ||
                                              _timeIni.text.isNotEmpty ||
                                              _dateFim.text.isNotEmpty ||
                                              _timeFim.text.isNotEmpty ||
                                              _dataLimiteInscricao
                                                  .text.isNotEmpty ||
                                              _categoriaId!.isNotEmpty ||
                                              _subCategoriaId!.isNotEmpty ||
                                              _nmrMaxParticipantes
                                                  .text.isNotEmpty ||
                                              _descricao.text.isNotEmpty) {
                                            Future<bool> confirma = confirmExit(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .sairSemGuardar,
                                              AppLocalizations.of(context)!
                                                  .dadosSeraoPerdidos,
                                            );

                                            confirma.then((value) {
                                              if (value) {
                                                Navigator.of(context).pop();
                                              }
                                            });
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancelar),
                                      ),
                                      SizedBox(width: largura * 0.02),
                                      FilledButton(
                                        onPressed: () async {
                                          String mensagem = "";

                                          if (forms.isEmpty) {
                                            mensagem =
                                                AppLocalizations.of(context)!
                                                    .criarEventoSemForms;
                                          } else if (forms.length == 1) {
                                            mensagem =
                                                AppLocalizations.of(context)!
                                                    .maisForms;
                                          }

                                          if (forms.isEmpty ||
                                              forms.length == 1) {
                                            Future<bool> confirma = confirmExit(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .criarEvento,
                                              mensagem,
                                            );

                                            EventoRepository eventoRepository;

                                            Evento eventoCriar;

                                            final List<Imagem> imagens = images
                                                    .isNotEmpty
                                                ? await convertListXfiletoImagem(
                                                    images)
                                                : [];
                                            confirma.then((value) => {
                                                  if (value)
                                                    {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConfiguracaoFormularioScreen(
                                                            adicionaFormulario:
                                                                _adicionaFormulario,
                                                            formId: forms
                                                                    .isEmpty
                                                                ? 1
                                                                : forms.last
                                                                        .formId +
                                                                    1,
                                                          ),
                                                        ),
                                                      )
                                                    }
                                                  else
                                                    {
                                                      print(
                                                          "A criar evento sem form "),
                                                      // Envio sem formularios
                                                      eventoCriar =
                                                          Evento.criar(
                                                        imagens: imagens,
                                                        poloId: poloId,
                                                        titulo:
                                                            _tituloController
                                                                .text,
                                                        subcategoria: int.parse(
                                                            _subCategoriaId!),
                                                        descricao:
                                                            _descricao.text,
                                                        numeroMaxPart:
                                                            nmrMaxParticipantes!,
                                                        numeroInscritos: 0,
                                                        nmrConvidados:
                                                            permiteConvidados!
                                                                ? nmrConvidados!
                                                                : 0,
                                                        localizacao:
                                                            _localizacaoController
                                                                .text,
                                                        latitude: latitude
                                                            .toStringAsFixed(6),
                                                        longitude: longitude
                                                            .toStringAsFixed(6),
                                                        dataInicio:
                                                            DateTime.parse(
                                                                _dateIni.text +
                                                                    " " +
                                                                    _timeIni
                                                                        .text),
                                                        dataFim: DateTime.parse(
                                                            _dateFim.text +
                                                                " " +
                                                                _timeFim.text),
                                                        dataLimiteInsc:
                                                            DateTime.parse(
                                                                _dataLimiteInscricao
                                                                        .text +
                                                                    " 00:00:00"),
                                                        utilizadorCriou:
                                                            utilizadorId,
                                                        cidadeid: 1,
                                                        formInsc: null,
                                                        formQualidade: null,
                                                      ),
                                                      eventoRepository =
                                                          EventoRepository(),
                                                      eventoRepository
                                                          .criarEvento(
                                                              eventoCriar)
                                                    }
                                                });
                                          } else {
                                            // TODO: IMPLEMENTAR ENVIO
                                            for (var form in forms) {
                                              print(form.titulo);
                                            }
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .guardar),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
