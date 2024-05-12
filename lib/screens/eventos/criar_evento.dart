import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import '../../time_utils.dart';

class CriarEventoScreen extends StatefulWidget {
  const CriarEventoScreen({Key? key}) : super(key: key);

  @override
  State<CriarEventoScreen> createState() {
    return _CriarEventoScreen();
  }
}

class _CriarEventoScreen extends State<CriarEventoScreen> {
  final _tituloController = TextEditingController();
  final _dateIni = TextEditingController();
  final _timeIni = TextEditingController();
  final _dateFim = TextEditingController();
  final _timeFim = TextEditingController();
  final _nmrMaxParticipantes = TextEditingController();
  final _nmrConvidados = TextEditingController();
  final _descricao = TextEditingController();
  String? _categoriaId;
  String? _subCategoriaId;
  int? nmrMaxParticipantes;
  bool? permiteConvidados;
  int? nmrConvidados;
  String? descricao;

// Lista de categorias a substituir por dados vindos da BD ou chamada API
  List<Categoria> categorias = [
    Categoria(1, "Gastronomia", "cor1", "garfo"),
    Categoria(2, "Desporto", "cor2", "futebol"),
    Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
    Categoria(4, "Alojamento", "cor3", "casa"),
    Categoria(5, "Saúde", "cor3", "cruz"),
    Categoria(6, "Ensino", "cor3", "escola"),
    Categoria(7, "Infraestruturas", "cor3", "infra"),
  ];

  List<Subcategoria> subcategorias = [
    // Subcategories for "Gastronomia" category
    Subcategoria(1, 1, "Comida italiana"),
    Subcategoria(2, 1, "Comida mexicana"),
    Subcategoria(3, 1, "Comida japonesa"),

    // Subcategories for "Desporto" category
    Subcategoria(4, 2, "Futebol"),
    Subcategoria(5, 2, "Basquetebol"),
    Subcategoria(6, 2, "Ténis"),

    // Subcategories for "Atividade Ar Livre" category
    Subcategoria(7, 3, "Caminhada"),
    Subcategoria(8, 3, "Ciclismo"),

    // Subcategories for "Alojamento" category
    Subcategoria(9, 4, "Hotel"),
    Subcategoria(10, 4, "Hostel"),
    Subcategoria(11, 4, "Apartamento"),

    // Subcategories for "Saúde" category
    Subcategoria(12, 5, "Médico geral"),
    Subcategoria(13, 5, "Dentista"),
    Subcategoria(14, 5, "Fisioterapia"),

    // Subcategories for "Ensino" category
    Subcategoria(15, 6, "Escola primária"),
    Subcategoria(16, 6, "Escola secundária"),
    Subcategoria(17, 6, "Universidade"),

    // Subcategories for "Infraestruturas" category
    Subcategoria(18, 7, "Transporte público"),
    Subcategoria(19, 7, "Estradas"),
    Subcategoria(20, 7, "Rede de água e saneamento"),
  ];

  DateTime selected = DateTime.now();
  DateTime initial = DateTime(DateTime.now().year);
  DateTime last = DateTime(DateTime.now().year + 1);

  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _categoriaId = categorias[0].categoriaId.toString();
    _subCategoriaId = subcategorias[0].subcategoriaId.toString();
    _nmrMaxParticipantes.text = "0";
    nmrMaxParticipantes = 0;
    permiteConvidados = false;
    nmrConvidados = 0;
    descricao = "";
  }

  Future<void> _selectStartTime(BuildContext context) async {
    await displayTimePicker(context, _timeIni, timeOfDay);
  }

  Future<void> _selectEndTime(BuildContext context) async {
    await displayTimePicker(context, _timeFim, timeOfDay);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    await displayDatePicker(
      context,
      _dateIni,
      selected,
      initial,
      last,
    );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    await displayDatePicker(
      context,
      _dateFim,
      selected,
      initial,
      last,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar evento"),
        //title: Text(AppLocalizations.of(context).criarEvento),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 15,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                margin: const EdgeInsets.all(10),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "detalhes do Evento",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          maxLength: 160,
                          controller: _tituloController,
                          decoration: InputDecoration(
                            label: Text("titulo"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "preencha o titulo";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Data e hora de início',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                controller: _dateIni,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectStartDate(context);
                              },
                              icon: const Icon(FontAwesomeIcons.calendar),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                controller: _timeIni,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectStartTime(context);
                              },
                              icon: const Icon(FontAwesomeIcons.clock),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Data e hora de fim',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                controller: _dateFim,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectEndDate(context);
                              },
                              icon: const Icon(FontAwesomeIcons.calendar),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                controller: _timeFim,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectEndTime(context);
                              },
                              icon: const Icon(FontAwesomeIcons.clock),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Selecção de categoria
                        DropdownButton(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          borderRadius: BorderRadius.circular(20),
                          hint: Text("Categoria"),
                          isExpanded: true,
                          value: _categoriaId.toString(),
                          items: getListaCatDropdown(categorias),
                          onChanged: (value) {
                            setState(
                              () {
                                _categoriaId = value;
                                _subCategoriaId = subcategorias
                                    .where((e) =>
                                        e.categoriaId == int.parse(value))
                                    .first
                                    .subcategoriaId
                                    .toString();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        //selecção de subcategoria
                        DropdownButton(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          borderRadius: BorderRadius.circular(20),
                          hint: Text("Sub-categoria"),
                          isExpanded: true,
                          value: _subCategoriaId.toString(),
                          items: getListaSubCatDropdown(
                              subcategorias, int.parse(_categoriaId!)),
                          onChanged: (value) {
                            setState(
                              () {
                                _subCategoriaId = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _nmrMaxParticipantes,
                          decoration: InputDecoration(
                            label: Text("Número máximo de participantes"),
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                nmrMaxParticipantes = int.parse(value);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 5),
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
                                  label: Text("Número de convidados"),
                                ),
                                validator: (value) {
                                  if (permiteConvidados == true &&
                                      (value == null || value.isEmpty)) {
                                    return "preencha o número de convidados";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          maxLines: 2,
                          controller: _descricao,
                          decoration: InputDecoration(
                            label: Text("Descrição"),
                          ),
                          onChanged: (value) {
                            setState(() {
                              descricao = value;
                            });
                          },
                          validator: (value) => value!.isEmpty
                              ? "preencha a descrição do evento"
                              : null,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child:
                                  Text(AppLocalizations.of(context)!.cancelar),
                            ),
                            const SizedBox(width: 20),
                            FilledButton(
                              onPressed: () {},
                              child: Text(AppLocalizations.of(context)!.enviar),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
