import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import '../../time_utils.dart';

class TopicoCardItem extends StatelessWidget {
  const TopicoCardItem({
    super.key,
    required this.topico,
    required this.categorias,
  });

  final Topico topico;
  final List<Categoria> categorias;

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
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/250?image=9',
                  ),
                ),
                SizedBox(width: largura * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topico.getNomeCompleto(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dataFormatada('pt', topico.dataCriacao!),
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
