import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/screens/Login/recuperar_pass.dart';
import 'package:softshares_mobile/screens/drawerLateral/contacte_suporte.dart';
import 'package:softshares_mobile/screens/eventos/consultar_evento.dart';
import 'package:softshares_mobile/screens/eventos/criar_evento.dart';
import 'package:softshares_mobile/screens/eventos/eventos_main.dart';
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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/consultarEvento') {
          final arguments = settings.arguments;
          return MaterialPageRoute(
            builder: (context) =>
                ConsultEventScreen(evento: arguments as Evento),
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
