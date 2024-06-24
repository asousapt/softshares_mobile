import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/widgets/eventos/event_list.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/widgets/eventos/calendario.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<List<Evento>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String idioma = "pt";
  List<Categoria> categorias = [];
  bool isLoading = true;
  List<Evento> eventos = [];
  late Map<DateTime, List<Evento>> kEventSource;
  late LinkedHashMap<DateTime, List<Evento>> _kEvents;

  Future<void> carregaEventos() async {
    EventoRepository eventoRepository = EventoRepository();
    eventos = await eventoRepository.getEventos();
    setState(() {
      isLoading = false;
    });
  }

  // carrega as categorias do idioma selecionado
  Future<void> buscarCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaL = prefs.getString("idioma") ?? "pt";
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    CategoriaRepository categoriaRepository = CategoriaRepository();
    categorias = await categoriaRepository.fetchCategoriasDB(idiomaId);
    setState(() {
      idioma = idiomaL;
    });
  }

  @override
  void initState() {
    super.initState();
    buscarCategorias();
    carregaEventos().then((_) {
      kEventSource = EventoRepository().getEventosMap(eventos);
      _kEvents = EventoRepository().getEventosLinkedHashMap(kEventSource);
      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Evento> _getEventsForDay(DateTime day) {
    return _kEvents[day] ?? [];
  }

  List<Evento> _getEventsForRange(DateTime start, DateTime end) {
    EventoRepository eventoRepository = EventoRepository();
    final days = eventoRepository.daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    final kToday = DateTime.now();

    return Scaffold(
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 0),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paginaInicial),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).canvasColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: largura * 0.01, vertical: altura * 0.01),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TableCalendarWidget(
                    idioma: idioma,
                    selectedDay: _selectedDay ?? kToday,
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    rangeStart: _rangeStart,
                    rangeEnd: _rangeEnd,
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    eventLoader: _getEventsForDay,
                    categorias: categorias,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Evento>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return EventListView(
                          selectedEvents: _selectedEvents,
                          categorias: categorias,
                          idioma: idioma,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
