import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  DateTime selected = DateTime.now();
  DateTime initial = DateTime(DateTime.now().year);
  DateTime last = DateTime(DateTime.now().year + 1);

  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
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
                  child: Column(
                    children: [
                      Text(
                        "detalhes do Evento",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextFormField(
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
                                labelText: 'Start date and time',
                                border: OutlineInputBorder(),
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
                                border: OutlineInputBorder(),
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
                                labelText: 'Start date and time',
                                border: OutlineInputBorder(),
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
                                border: OutlineInputBorder(),
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
                      DropdownButton(
                        items: [],
                        onChanged: (value) {},
                      )
                    ],
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
