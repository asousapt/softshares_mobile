import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/widgets/gerais/tirar_foto.dart';

class UserProfileWidget extends StatefulWidget {
  UserProfileWidget({
    super.key,
    required this.utilizador,
  });

  final Utilizador utilizador;

  @override
  State<StatefulWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late String fotoUrl;
  String? base64Image;
  late Imagem imagem;
  late String descricaoUtilizador;
  bool isloading = false;

  @override
  void initState() {
    isloading = true;
    super.initState();
    getDescricaoUtilizador().then((_) {
      fotoUrl = widget.utilizador.fotoUrl ?? '';
      imagem = widget.utilizador.fotoEnvio ??
          Imagem(nome: "", base64: "", tamanho: 0);
      if (fotoUrl.isNotEmpty) {
        _initBase64Image(fotoUrl);
      }
      setState(() {
        isloading = false;
      });
    });
  }

  // busca a funcao do utilizador
  Future<void> getDescricaoUtilizador() async {
    String descricao = "";
    UtilizadorRepository utilizadorRepository = UtilizadorRepository();
    descricao =
        await utilizadorRepository.getutilizadorDescricao(widget.utilizador);
    setState(() {
      descricaoUtilizador = descricao;
    });
  }

  // Inicializa a base64Image
  Future<void> _initBase64Image(String imageUrl) async {
    Imagem? carregaImagem = await convertImageUrlToBase64(imageUrl);
    setState(() {
      if (carregaImagem != null) {
        base64Image = carregaImagem.base64;
        widget.utilizador.fotoEnvio = carregaImagem;
        print("Imagem carregada com sucesso: ${carregaImagem.nome}");
      }
    });
  }

  // carrega o selector para escolher a fonte da imagem
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
                _updateFotoUrl(image);
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
              print("Foto tirada: $newFotoUrl");
              if (newFotoUrl != null) {
                _updateFotoUrl(newFotoUrl as XFile?);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(AppLocalizations.of(context)!.removerFoto),
            onTap: () async {
              Navigator.pop(context);
              _updateFotoUrl(null);
            },
          ),
        ],
      ),
    );
  }

  // Reseta a fotoUrl e base64Image
  void _updateFotoUrl(XFile? newFotoUrl) async {
    if (newFotoUrl == null) {
      setState(() {
        fotoUrl = '';
        base64Image = null;
        widget.utilizador.fotoEnvio = Imagem(nome: "", tamanho: 0, base64: "");
      });
    } else {
      // Ler a imagem como bytes
      final bytes = await newFotoUrl.readAsBytes();

      // Faz encode dos bytes para base64
      final base64String = base64Encode(bytes);

      setState(() {
        fotoUrl = newFotoUrl.path;
        base64Image = null;
        widget.utilizador.fotoEnvio = Imagem(
            nome: newFotoUrl.name, tamanho: bytes.length, base64: base64String);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    final String nome = widget.utilizador.getNomeCompleto();

    final String iniciais = widget.utilizador.getIniciais();

    return isloading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ),
          )
        : Column(
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
                          : fotoUrl.startsWith('http') ||
                                  fotoUrl.startsWith('https')
                              ? NetworkImage(fotoUrl)
                              : FileImage(File(fotoUrl))
                                  as ImageProvider<Object>?,
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
                            horizontal: largura * 0.02,
                            vertical: altura * 0.01),
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
                descricaoUtilizador,
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
