import 'dart:io';

import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import '../../time_utils.dart';

class TopicoCardItem extends StatelessWidget {
  const TopicoCardItem({
    super.key,
    required this.topico,
    required this.categorias,
    required this.idioma,
  });

  final Topico topico;
  final List<Categoria> categorias;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * 0.02,
          horizontal: largura * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              overflow: TextOverflow.ellipsis,
              topico.titulo,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: altura * 0.01),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: (topico.utilizadorCriou!.fotoUrl!.isEmpty)
                      ? null
                      : topico.utilizadorCriou!.fotoUrl!.startsWith('http') ||
                              topico.utilizadorCriou!.fotoUrl!
                                  .startsWith('https')
                          ? NetworkImage(topico.utilizadorCriou!.fotoUrl!)
                          : FileImage(File(topico.utilizadorCriou!.fotoUrl!))
                              as ImageProvider<Object>?,
                  backgroundColor: topico.utilizadorCriou!.fotoUrl!.isEmpty
                      ? Colors.blue
                      : null,
                  child: topico.utilizadorCriou!.fotoUrl!.isEmpty
                      ? Text(
                          topico.utilizadorCriou!.getIniciais(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: largura * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topico.utilizadorCriou!.getNomeCompleto(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dataFormatada(idioma, topico.dataCriacao!),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                categorias
                    .firstWhere(
                      (element) => element.categoriaId == topico.categoria,
                    )
                    .getIcone(),
              ],
            ),
            SizedBox(height: altura * 0.01),
            Text(
              overflow: TextOverflow.ellipsis,
              topico.mensagem,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
