import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/utilizador.dart';
import '../../models/ponto_de_interesse.dart';

class PontoInteresseCard extends StatelessWidget {
  final PontoInteresse pontoInteresse;

  PontoInteresseCard({
    Key? key,
    required this.pontoInteresse,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(FontAwesomeIcons.user),
              title: Text("${pontoInteresse.criador?.pNome} ${pontoInteresse.criador?.uNome}"),
              trailing: IconButton(
                icon: Icon(FontAwesomeIcons.ellipsisV),
                onPressed: () {
                  // Action to perform on button press
                },
              ),
            ),
            FadeInImage(
                fit: BoxFit.cover,
                height: altura * 0.2,
                width: double.infinity,
                placeholder: const AssetImage("Images/Restaurante.jpg"),
                image: const AssetImage("Images/Restaurante.jpg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Image(image:AssetImage("Images/Restaurante.jpg"));
                },
              ),
            Divider(),
            Text(
              pontoInteresse.titulo,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Location: ${pontoInteresse.localizacao}"),
            SizedBox(height: 10),
            Text(pontoInteresse.descricao),
            
          ],
        ),
      ),
    );
  }
}
