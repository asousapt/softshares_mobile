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
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                    "https://pplware.sapo.pt/wp-content/uploads/2022/02/s_22_plus_1.jpg "),
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
