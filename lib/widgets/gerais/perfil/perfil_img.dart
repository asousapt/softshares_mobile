import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/widgets/gerais/tirar_foto.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({
    super.key,
    required this.nome,
    required this.descricao,
    required this.fotoUrl,
    required this.iniciais,
  });

  final String nome;
  final String descricao;
  final String fotoUrl;
  final String iniciais;

  @override
  State<StatefulWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late String fotoUrl;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    fotoUrl = widget.fotoUrl;
    if (fotoUrl.isNotEmpty) {
      _initBase64Image(fotoUrl);
    }
  }

  Future<void> _initBase64Image(String imageUrl) async {
    base64Image = await convertImageUrlToBase64(imageUrl);
    setState(() {});
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(AppLocalizations.of(context)!.galeria),
            onTap: () async {
              Navigator.pop(context);
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                _updateFotoUrl(image.path);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(AppLocalizations.of(context)!.camara),
            onTap: () async {
              final cameras = await availableCameras();
              final newFotoUrl = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TirarFoto(cam: cameras),
                ),
              );
              if (newFotoUrl != null) {
                _updateFotoUrl(newFotoUrl);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(AppLocalizations.of(context)!.removerFoto),
            onTap: () {
              Navigator.pop(context);
              _updateFotoUrl('');
            },
          ),
        ],
      ),
    );
  }

  // Reseta a fotoUrl e base64Image
  void _updateFotoUrl(String newFotoUrl) {
    setState(() {
      fotoUrl = newFotoUrl;
      base64Image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    final String nome = widget.nome;
    final String descricao = widget.descricao;
    final String iniciais = widget.iniciais;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: largura * 0.4,
          height: altura * 0.2,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 180,
                backgroundImage: (fotoUrl.isEmpty)
                    ? null
                    : fotoUrl.startsWith('http') || fotoUrl.startsWith('https')
                        ? NetworkImage(fotoUrl)
                        : FileImage(File(fotoUrl)) as ImageProvider<Object>?,
                backgroundColor: fotoUrl.isEmpty ? Colors.blue : null,
                child: fotoUrl.isEmpty
                    ? Text(
                        iniciais,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                left: largura * 0.24,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(217, 215, 215, 1),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: largura * 0.02, vertical: altura * 0.01),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Color.fromRGBO(29, 90, 161, 1),
                    ),
                    onPressed: () {
                      _showImageSourceActionSheet(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: altura * 0.02),
        Text(
          nome,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: altura * 0.005),
        Text(
          descricao,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(191, 191, 191, 1),
          ),
        ),
        SizedBox(height: altura * 0.02),
      ],
    );
  }
}
