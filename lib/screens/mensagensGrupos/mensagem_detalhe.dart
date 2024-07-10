import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softshares_mobile/Repositories/mensagem_repository.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/screens/generic/galeria_fotos.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/info_grupo.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/info_utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/foto_picker.dart';

class MensagemDetalheScreen extends StatefulWidget {
  const MensagemDetalheScreen({
    super.key,
    required this.mensagemId,
    required this.nome,
    required this.imagemUrl,
    required this.msgGrupo,
    this.grupoId,
    this.utilizadorId,
  });

  final int mensagemId;
  final String nome;
  final String imagemUrl;
  final bool msgGrupo;
  final int? grupoId;
  final int? utilizadorId;

  @override
  State<StatefulWidget> createState() {
    return _MensagemDetalheScreenState();
  }
}

class _MensagemDetalheScreenState extends State<MensagemDetalheScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late int utilizadorId;
  List<Mensagem> mensagens = [];
  bool _isLoading = false;
  List<XFile> _selectedImages = [];

  Future<void> actualizaDados() async {
    setState(() {
      utilizadorId = widget.utilizadorId!;
      _isLoading = true;
    });
    MensagemRepository mensagemRepository = MensagemRepository();
    if (!widget.msgGrupo) {
      // carrega mensagens da base de dados

      List<Mensagem> mensagensL =
          await mensagemRepository.getConversa(widget.mensagemId);

      setState(() {
        mensagens = mensagensL;
        _isLoading = false;
      });
    } else {
      List<Mensagem> mensagensL =
          await mensagemRepository.getConversaGr(widget.mensagemId);
      setState(() {
        mensagens = mensagensL;
        _isLoading = false;
      });
    }

    // Faz scroll para a última mensagem
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _onImagesPicked(List<XFile> images) {
    setState(() {
      _selectedImages = images;
    });
  }

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            padding:
                EdgeInsets.only(right: largura * 0.02, left: largura * 0.02),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(width: largura * 0.02),
                InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.imagemUrl),
                      maxRadius: 20,
                    ),
                    onTap: () {
                      if (widget.msgGrupo) {
                        // Navegar para a página de informações do grupo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GrupoInfoScreen(
                                grupoId: widget.grupoId!,
                              );
                            },
                          ),
                        );
                      } else {
                        // Navegar para a página de informações do utilizador
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UtilizadorInfoScreen(
                                utilizadorId: widget.utilizadorId!,
                                mostraGaleria: true,
                              );
                            },
                          ),
                        );
                      }
                    }),
                SizedBox(width: largura * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.nome,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: altura * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: mensagens.length + 1,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: altura * 0.02, bottom: altura * 0.02),
                  itemBuilder: (context, index) {
                    if (index == mensagens.length) {
                      return SizedBox(height: altura * 0.1);
                    }
                    print(mensagens[index].remetente.utilizadorId);
                    bool isSender =
                        mensagens[index].remetente.utilizadorId == utilizadorId;
                    return Container(
                      padding: EdgeInsets.only(
                          left: largura * 0.02,
                          right: largura * 0.02,
                          top: altura * 0.02,
                          bottom: altura * 0.02),
                      child: Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (widget.msgGrupo && !isSender) ...[
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      mensagens[index].remetente.fotoUrl!),
                                  maxRadius: 12,
                                ),
                                SizedBox(width: largura * 0.02),
                                Text(
                                  mensagens[index].remetente.getNomeCompleto(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: altura * 0.02),
                          ],
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isSender
                                  ? Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(0.8)
                                  : Theme.of(context).canvasColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: largura * 0.02,
                                vertical: altura * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mensagens[index].mensagemTexto,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                // Mostrar imagens se existirem
                                if (mensagens[index].anexos.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      // Navegar para a galeria de fotos
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoGalleryScreen(
                                            imageUrls: mensagens[index].anexos,
                                            initialIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: altura * 0.02),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: largura * 0.02,
                                          mainAxisSpacing: altura * 0.02,
                                        ),
                                        itemCount:
                                            mensagens[index].anexos.length > 4
                                                ? 4
                                                : mensagens[index]
                                                    .anexos
                                                    .length,
                                        itemBuilder: (context, imgIndex) {
                                          if (imgIndex == 3 &&
                                              mensagens[index].anexos.length >
                                                  4) {
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.network(
                                                  mensagens[index]
                                                      .anexos[imgIndex],
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  color: Colors.black54,
                                                  child: Center(
                                                    child: Text(
                                                      '+${mensagens[index].anexos.length - 4}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Image.network(
                                            mensagens[index].anexos[imgIndex],
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: altura * 0.01),
                          Text(
                            dataFormatadaMsg(mensagens[index].dataEnvio, "pt"),
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                  left: largura * 0.02,
                  bottom: altura * 0.02,
                  top: altura * 0.02),
              height: altura * 0.1,
              width: double.infinity,
              color: Theme.of(context).canvasColor,
              child: Row(
                children: <Widget>[
                  /*FotoPicker(
                    pickedImages: _selectedImages,
                    onImagesPicked: _onImagesPicked,
                  ), */
                  SizedBox(width: largura * 0.02),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.writeMessage,
                          hintStyle: const TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(width: largura * 0.02),
                  Container(
                    height: altura * 0.06,
                    width: largura * 0.12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO implementar envio de mensagem e imagens
                        if (_messageController.text.trim().isNotEmpty ||
                            _selectedImages.isNotEmpty) {
                          setState(() {
                            /*mensagens.add(
                              Mensagem(
                                mensagemId: mensagens.length + 1,
                                mensagemTexto: _messageController.text.trim(),
                                remetente: Utilizador(
                                  utilizadorId,
                                  'Alice',
                                  'Johnson',
                                  'alice.johnson@example.com',
                                  'Some info',
                                  1,
                                  [1, 2],
                                  1,
                                  1,
                                ),
                                destinatarioUtil: Utilizador(
                                  2,
                                  'John',
                                  'Doe',
                                  'john.doe@example.com',
                                  'Some info',
                                  1,
                                  [1, 2],
                                  1,
                                  1,
                                ),
                                dataEnvio: DateTime.now(),
                                anexos: _selectedImages
                                    .map((image) => image.path)
                                    .toList(),
                                vista: true,
                              ),
                            );*/
                            _messageController.clear();
                          });
                          // Faz scroll para a última mensagem
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          });
                        }
                      },
                      icon: Icon(Icons.send,
                          color: Theme.of(context).canvasColor, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
