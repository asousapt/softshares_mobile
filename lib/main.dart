import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/screens/Login/recuperar_pass.dart';
import 'package:softshares_mobile/screens/drawerLateral/contacte_suporte.dart';
import 'package:softshares_mobile/screens/eventos/consultar_evento.dart';
import 'package:softshares_mobile/screens/eventos/criar_evento.dart';
import 'package:softshares_mobile/screens/eventos/eventos_main.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/reposta_form.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagem_detalhe.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagens_main.dart';
import 'package:softshares_mobile/screens/pontos_interesse.dart/criar_ponto_interesse.dart';
import 'package:softshares_mobile/screens/topicos/criar_topico.dart';
import 'package:softshares_mobile/screens/topicos/topico_details.dart';
import 'package:softshares_mobile/screens/topicos/topicos_main.dart';
import "screens/Login/registo.dart";
import "screens/Login/login.dart";
import "package:flutter/material.dart";
import 'package:softshares_mobile/screens/home.dart';
import 'package:softshares_mobile/screens/drawerLateral/perfil.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/softshares_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/drawerLateral/notifications_alert.dart';
import 'screens/Login/confirmar_id.dart';
import 'screens/Login/repor_pass.dart';
import 'screens/Login/escolher_polo.dart';
import 'screens/pontos_interesse.dart/pontos_interesse.main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String local = 'pt';

  @override
  void initState() {
    local = 'pt';
    super.initState();
  }

  //Funcao que faz a mudamça da linguagem da aplicação
  void _mudaIdioma(String linguagem) {
    setState(() {
      local = linguagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    Utilizador utilizador = Utilizador(
      1, // utilizadorId
      'John', // pNome
      'Doe', // uNome
      'john.doe@example.com', // email
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', // sobre
      1, // poloId
      [1, 2, 3], // preferencias
      1, // funcaoId
      1, // departamentoId
    );

    return MaterialApp(
      title: 'Softshares',
      //initialRoute: "/login",
      theme: SoftSharesTheme.lightTheme,
      routes: {
        "/login": (context) => EcraLogin(mudaIdioma: _mudaIdioma),
        "/registar": (context) => EcraRegistar(mudaIdioma: _mudaIdioma),
        "/perfil": (context) => ProfileScreen(utilizador: utilizador),
        '/home': (context) => const HomeScreen(),
        '/notificacoes': (context) => const NotificationsAlertScreen(),
        '/suporte': (context) => const ContactSupport(),
        '/eventos': (context) => const EventosMainScreen(),
        '/criarEvento': (context) => const CriarEventoScreen(),
        '/recuperarPass': (context) => EcraRecPass(mudaIdioma: _mudaIdioma),
        '/confirmarID': (context) => EcraConfID(mudaIdioma: _mudaIdioma),
        '/reporPass': (context) => EcraReporPass(mudaIdioma: _mudaIdioma),
        '/escolherPolo': (context) => EcraEscolherPolo(mudaIdioma: _mudaIdioma),
        '/responderForm': (context) =>
            const RespostaFormScreen(formularioId: 0),
        '/forum': (context) => const TopicosListaScreen(),
        '/vertopico': (context) => const TopicoDetailsScreen(),
        '/criarTopico': (context) => const CriarTopicoScreen(),
        '/mensagens': (context) => const MensagensMainScreen(),
        '/pontosInteresse': (context) => const PontosDeInteresseMainScreen(),
        '/criarPontoInteresse':(context) => const CriarPontoInteresseScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/consultarEvento') {
          final arguments = settings.arguments as Evento;
          return MaterialPageRoute(
            builder: (context) => ConsultEventScreen(evento: arguments),
          );
        } else if (settings.name == '/mensagem_detalhe') {
          final arguments = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MensagemDetalheScreen(
              mensagemId: arguments['mensagemId'] as int,
              nome: arguments['nome'] as String,
              imagemUrl: arguments['imagemUrl'] as String,
              msgGrupo: arguments['msgGrupo'] as bool,
            ),
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
