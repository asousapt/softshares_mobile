import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    super.key,
    required this.nome,
    required this.descricao,
    required this.fotoUrl,
  });

  final String nome;
  final String descricao;
  final String fotoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 150,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 180,
                backgroundImage: NetworkImage(fotoUrl),
              ),
              Positioned(
                bottom: 0,
                left: 150,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(217, 215, 215, 1),
                  ),
                  padding: const EdgeInsets.all(3), // Adjust padding as needed
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.penToSquare,
                      size: 16,
                      color: Color.fromRGBO(29, 90, 161, 1),
                    ),
                    onPressed: () {
                      // FALTA A funcao de mudar a imagem
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          nome,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 1),
        Text(
          descricao, // Replace with the user's name
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(191, 191, 191, 1),
          ),
        ),
        const SizedBox(height: 16),
        // Add TabPerfil here
      ],
    );
  }
}
