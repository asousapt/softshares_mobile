import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/topico.dart';

class TopicoDetailsScreen extends StatefulWidget {
  const TopicoDetailsScreen({
    super.key,
    required this.topico,
  });

  final Topico topico;

  @override
  State<TopicoDetailsScreen> createState() {
    return _TopicoDetailsScreenState();
  }
}

class _TopicoDetailsScreenState extends State<TopicoDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Tópico'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: Text('Detalhes do Tópico'),
      ),
    );
  }
}
