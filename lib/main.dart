import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/Login/confirmar_id.dart';
import 'package:softshares_mobile/screens/Login/escolher_polo.dart';
import 'package:softshares_mobile/screens/Login/login.dart';
import 'package:softshares_mobile/screens/Login/recuperar_pass.dart';
import 'package:softshares_mobile/screens/Login/registo.dart';
import 'package:softshares_mobile/screens/Login/repor_pass.dart';
import 'package:softshares_mobile/screens/drawerLateral/contacte_suporte.dart';
import 'package:softshares_mobile/screens/drawerLateral/notifications_alert.dart';
import 'package:softshares_mobile/screens/drawerLateral/perfil.dart';
import 'package:softshares_mobile/screens/eventos/consultar_evento.dart';
import 'package:softshares_mobile/screens/eventos/criar_evento.dart';
import 'package:softshares_mobile/screens/eventos/eventos_main.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/reposta_form.dart';
import 'package:softshares_mobile/screens/home.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/criar_grupo.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/listar_grupos.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagem_detalhe.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagens_main.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/nova_mensagem.dart';
import 'package:softshares_mobile/screens/pontos_interesse/consultar_ponto_interesse.dart';
import 'package:softshares_mobile/screens/pontos_interesse/criar_ponto_interesse.dart';
import 'package:softshares_mobile/screens/pontos_interesse/pontos_interesse.main.dart';
import 'package:softshares_mobile/screens/topicos/criar_topico.dart';
import 'package:softshares_mobile/screens/topicos/topico_details.dart';
import 'package:softshares_mobile/screens/topicos/topicos_main.dart';
import 'package:softshares_mobile/Repositories/idioma_repository.dart';
import 'package:softshares_mobile/services/database_service.dart';
import 'package:softshares_mobile/softshares_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbService = DatabaseService.instance;

  // Ensure the database is initialized before use
  await dbService.database;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final idiomaRepository = IdiomaRepository();
  String local = "pt";

  @override
  void initState() {
    super.initState();
    // Initialize locale asynchronously
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    String localAdefinir = "pt";
    // carrega dados iniciais da aplicação
    await carregaDadosCfgInicial();

    // Get initial locale
    final systemLocale = PlatformDispatcher.instance.locale;
    final List<String> fetchedLocales =
        await idiomaRepository.fetchSupportedLocales();

    localAdefinir = fetchedLocales.contains(systemLocale.languageCode)
        ? systemLocale.languageCode
        : 'pt';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("idioma", localAdefinir);
    final int idiomaId = await idiomaRepository.getIdiomaId(localAdefinir);
    await prefs.setInt("idiomaId", idiomaId);

    setState(() {
      local = localAdefinir;
    });
  }

  Future<void> carregaDadosCfgInicial() async {
    try {
      // carrega os idiomas da API
      final idiomas = await idiomaRepository.fetchIdiomas();
      final int numeroIdiomasAPI = idiomas.length;
      final int numeroIdiomasLocal = await idiomaRepository.numeroIdiomas();

      if (numeroIdiomasAPI != numeroIdiomasLocal) {
        await idiomaRepository.deleteAllIdiomas();
        for (final idioma in idiomas) {
          final inserted = await idiomaRepository.createIdioma(idioma);
          if (!inserted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.ocorreuErro),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.ocorreuErro),
        ),
      );
    }
  }

  // função que faz a mudança de idioma
  void _mudaIdioma(String linguagem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("idioma", linguagem);
    setState(() {
      local = linguagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Softshares',
      // initialRoute: "/login",
      theme: SoftSharesTheme.lightTheme,
      routes: {
        "/login": (context) => EcraLogin(mudaIdioma: _mudaIdioma),
        "/registar": (context) => EcraRegistar(mudaIdioma: _mudaIdioma),
        '/home': (context) => const HomeScreen(),
        '/notificacoes': (context) => const NotificationsAlertScreen(),
        '/suporte': (context) => const ContactSupport(),
        '/eventos': (context) => const EventosMainScreen(),
        '/criarEvento': (context) => const CriarEventoScreen(),
        '/recuperarPass': (context) => EcraRecPass(mudaIdioma: _mudaIdioma),
        '/confirmarID': (context) => EcraConfID(mudaIdioma: _mudaIdioma),
        '/reporPass': (context) => EcraReporPass(mudaIdioma: _mudaIdioma),
        '/escolherPolo': (context) => const EcraEscolherPolo(),
        '/responderForm': (context) =>
            const RespostaFormScreen(formularioId: 0),
        '/forum': (context) => const TopicosListaScreen(),
        '/vertopico': (context) => const TopicoDetailsScreen(),
        '/criarTopico': (context) => const CriarTopicoScreen(),
        '/mensagens': (context) => const MensagensMainScreen(),
        '/pontosInteresse': (context) => const PontosDeInteresseMainScreen(),
        '/criarPontoInteresse': (context) => const CriarPontoInteresseScreen(),
        '/ListarGrupo': (context) => const ListarGrupoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/consultarEvento') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ConsultEventScreen(
              evento: arguments['evento'] as Evento,
              categorias: arguments['categorias'] as List<Categoria>,
            ),
          );
        } else if (settings.name == '/mensagem_detalhe') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MensagemDetalheScreen(
              mensagemId: arguments['mensagemId'] as int,
              nome: arguments['nome'] as String,
              imagemUrl: arguments['imagemUrl'] as String,
              msgGrupo: arguments['msgGrupo'] as bool,
              grupoId: arguments['grupoId'] as int,
              utilizadorId: arguments['utilizadorId'] as int,
            ),
          );
        } else if (settings.name == '/consultarPontoInteresse') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ConsultPontoInteresseScreen(
              pontoInteresse: arguments['PontoInteresse'] as PontoInteresse,
            ),
          );
        } else if (settings.name == '/novaMensagem') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => NovaMensagem(
              mensagens: arguments['mensagens'] as List<Mensagem>,
            ),
          );
        } else if (settings.name == '/criarGrupo') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CriarGrupoScreen(
              editar: arguments['editar'] as bool,
            ),
          );
        } else if (settings.name == "/perfil") {
          final arguments = settings.arguments as Utilizador;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(utilizador: arguments),
          );
        }
        return null;
      },
      locale: Locale(local),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
      ],
      home: EcraLogin(mudaIdioma: _mudaIdioma),
    );
  }
}
